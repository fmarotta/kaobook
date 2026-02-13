"""Cluster DINOv2 embeddings and select representatives for LLaVA captioning.

Uses PCA for dimensionality reduction, k-means for clustering,
and selects centroid-nearest images as cluster representatives.
"""

import json
import sys
from pathlib import Path

import numpy as np
from sklearn.cluster import KMeans, DBSCAN
from sklearn.decomposition import PCA
from sklearn.metrics import silhouette_score
from sklearn.preprocessing import normalize

# ── Paths ────────────────────────────────────────────────────────────────────
DATA_DIR = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-visual\data\processed\dinov2")
IMAGE_DIR = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-visual\data\raw\tweet_images_deduped")

# ── Load ─────────────────────────────────────────────────────────────────────
print("Loading embeddings...")
embeddings = np.load(DATA_DIR / "embeddings.npy")
with open(DATA_DIR / "filenames.json", encoding="utf-8") as f:
    filenames = json.load(f)

print(f"Loaded: {embeddings.shape[0]:,} images x {embeddings.shape[1]} dims")
assert len(filenames) == embeddings.shape[0]

# ── Normalize (L2) ───────────────────────────────────────────────────────────
embeddings_norm = normalize(embeddings, norm="l2")

# ── PCA: 384 → 50 ───────────────────────────────────────────────────────────
print("\nPCA: 384 -> 50 dims...")
pca = PCA(n_components=50, random_state=42)
embeddings_pca = pca.fit_transform(embeddings_norm)
var_explained = pca.explained_variance_ratio_.sum()
print(f"Variance explained: {var_explained:.1%}")

# ── PCA: 384 → 2 for visualization ──────────────────────────────────────────
print("PCA: 384 -> 2 dims (visualization)...")
pca2d = PCA(n_components=2, random_state=42)
coords_2d = pca2d.fit_transform(embeddings_norm)

# ── Find optimal k ──────────────────────────────────────────────────────────
print("\nTesting k = 8, 12, 16, 20, 25, 30...")
results = []
for k in [8, 12, 16, 20, 25, 30]:
    km = KMeans(n_clusters=k, random_state=42, n_init=10, max_iter=300)
    labels = km.fit_predict(embeddings_pca)
    sil = silhouette_score(embeddings_pca, labels, sample_size=5000, random_state=42)
    inertia = km.inertia_
    results.append((k, sil, inertia))
    print(f"  k={k:2d}: silhouette={sil:.4f}, inertia={inertia:.0f}")

# Pick best silhouette
best_k = max(results, key=lambda x: x[1])[0]
print(f"\nBest k by silhouette: {best_k}")

# ── Final clustering with best k ─────────────────────────────────────────────
print(f"\nFinal k-means with k={best_k}...")
km_final = KMeans(n_clusters=best_k, random_state=42, n_init=20, max_iter=500)
labels = km_final.fit_predict(embeddings_pca)
sil_final = silhouette_score(embeddings_pca, labels, sample_size=5000, random_state=42)
print(f"Final silhouette: {sil_final:.4f}")

# ── Cluster statistics ───────────────────────────────────────────────────────
print("\nCluster sizes:")
cluster_info = []
for c in range(best_k):
    mask = labels == c
    count = mask.sum()
    # Find representative (closest to centroid)
    centroid = km_final.cluster_centers_[c]
    dists = np.linalg.norm(embeddings_pca[mask] - centroid, axis=1)
    closest_idx = np.where(mask)[0][np.argmin(dists)]
    rep_file = filenames[closest_idx]

    # Also find 5 nearest to centroid for captioning
    all_dists = np.linalg.norm(embeddings_pca - centroid, axis=1)
    top5_idx = np.argsort(all_dists)[:5]
    top5_files = [filenames[i] for i in top5_idx]

    cluster_info.append({
        "cluster_id": int(c),
        "size": int(count),
        "pct": round(count / len(labels) * 100, 1),
        "representative": rep_file,
        "top5_representatives": top5_files,
        "centroid_distance_mean": round(float(dists.mean()), 4),
        "centroid_distance_std": round(float(dists.std()), 4),
    })
    print(f"  Cluster {c:2d}: {count:5,} images ({count / len(labels) * 100:5.1f}%) | "
          f"rep: {rep_file}")

# ── Map existing KIC labels ─────────────────────────────────────────────────
# Check which images have KIC labels from the extracted/ folder
kic_dir = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-visual\data\processed\twitter_visual\extracted")
kic_map = {}
if kic_dir.exists():
    for kic_folder in kic_dir.iterdir():
        if kic_folder.is_dir():
            kic_name = kic_folder.name
            for img in kic_folder.iterdir():
                if img.is_file():
                    kic_map[img.name] = kic_name

print(f"\nKIC-labeled images found: {len(kic_map):,}")

# Add KIC distribution per cluster
for ci in cluster_info:
    cluster_mask = labels == ci["cluster_id"]
    cluster_files = [filenames[i] for i in np.where(cluster_mask)[0]]
    kic_counts: dict[str, int] = {}
    for fn in cluster_files:
        if fn in kic_map:
            kic = kic_map[fn]
            kic_counts[kic] = kic_counts.get(kic, 0) + 1
    ci["kic_distribution"] = kic_counts
    if kic_counts:
        dominant_kic = max(kic_counts, key=kic_counts.get)
        ci["dominant_kic"] = dominant_kic
        ci["kic_coverage"] = round(sum(kic_counts.values()) / ci["size"] * 100, 1)
    else:
        ci["dominant_kic"] = "unknown"
        ci["kic_coverage"] = 0.0

# ── Save results ─────────────────────────────────────────────────────────────
output = {
    "n_images": int(embeddings.shape[0]),
    "n_clusters": best_k,
    "silhouette_score": round(float(sil_final), 4),
    "pca_variance_explained": round(float(var_explained), 4),
    "k_search_results": [{"k": k, "silhouette": round(s, 4)} for k, s, _ in results],
    "clusters": cluster_info,
}

out_path = DATA_DIR / "cluster_assignments.json"
with open(out_path, "w", encoding="utf-8") as f:
    json.dump(output, f, indent=2)
print(f"\nSaved: {out_path}")

# Save per-image labels
labels_path = DATA_DIR / "labels.npy"
np.save(labels_path, labels)
print(f"Saved: {labels_path}")

# Save 2D coordinates for visualization
coords_path = DATA_DIR / "coords_2d.npy"
np.save(coords_path, coords_2d)
print(f"Saved: {coords_path}")

# Collect all representatives for LLaVA captioning
all_reps = set()
for ci in cluster_info:
    all_reps.update(ci["top5_representatives"])

reps_path = DATA_DIR / "representatives.json"
with open(reps_path, "w", encoding="utf-8") as f:
    json.dump(sorted(all_reps), f, indent=2)
print(f"\nRepresentatives for LLaVA captioning: {len(all_reps)} images")
print(f"Saved: {reps_path}")

print("\nDone.")

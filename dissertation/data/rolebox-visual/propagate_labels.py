"""Label propagation: assign semiotic categories to all images.

Uses BLIP captions + DINOv2 embeddings + k-NN to propagate
LLaVA structured codings from a 400-image sample to all 31K+ images.

Also uses BLIP captions directly for keyword-based classification
as a complementary signal.
"""

import json
import re
from collections import Counter
from pathlib import Path

import numpy as np
from sklearn.neighbors import NearestNeighbors
from sklearn.preprocessing import normalize

# ── Paths ────────────────────────────────────────────────────────────────────
DATA_DIR = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-visual\data\processed\dinov2")
KIC_DIR = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-visual\data\processed\twitter_visual\extracted")

# ── Keyword classifiers for BLIP captions ────────────────────────────────────
PARTICIPANT_KEYWORDS = {
    "people": ["man", "woman", "person", "people", "group", "crowd", "team",
               "speaker", "audience", "child", "boy", "girl", "men", "women",
               "student", "worker", "engineer", "scientist", "doctor"],
    "technology": ["computer", "screen", "laptop", "robot", "machine", "device",
                   "solar", "panel", "battery", "wind", "turbine", "lab",
                   "microscope", "equipment", "drone", "chip", "circuit"],
    "nature": ["tree", "plant", "flower", "field", "ocean", "mountain", "sky",
               "water", "river", "forest", "garden", "green", "leaf", "farm"],
    "abstract": ["logo", "text", "graphic", "diagram", "chart", "poster",
                 "infographic", "slide", "banner", "icon", "sign"],
}

PROCESS_KEYWORDS = {
    "presentation": ["presentation", "presenting", "lecture", "speaking",
                     "podium", "stage", "microphone", "slides"],
    "group_photo": ["posing", "photo", "group", "standing together",
                    "holding certificate", "award"],
    "meeting": ["meeting", "discussion", "table", "sitting", "conference room",
                "workshop"],
    "portrait": ["portrait", "headshot", "close-up of a person", "selfie"],
    "event": ["event", "ceremony", "exhibition", "fair", "festival",
              "networking", "booth"],
    "product_demo": ["product", "prototype", "demonstration", "showing",
                     "display", "showcase"],
    "graphic_poster": ["poster", "flyer", "infographic", "graphic", "logo",
                       "banner", "advertisement"],
    "landscape": ["building", "city", "landscape", "skyline", "aerial",
                  "outdoor scene", "architecture"],
}

CONTACT_KEYWORDS = {
    "strong_contact": ["looking at camera", "direct gaze", "eye contact",
                       "facing the camera", "staring"],
    "weak_contact": ["people", "person", "man", "woman", "group"],
    "no_contact": ["no people", "empty", "object", "landscape", "graphic"],
}

DISTANCE_KEYWORDS = {
    "intimate": ["close-up", "close up", "detail", "macro", "face"],
    "social": ["medium shot", "waist up", "half body", "sitting at"],
    "impersonal": ["wide shot", "aerial", "panoramic", "full room", "crowd"],
}


def classify_caption(caption: str) -> dict:
    """Classify a BLIP caption into semiotic categories using keywords."""
    caption_lower = caption.lower()
    result = {}

    # Participants
    scores = {}
    for cat, keywords in PARTICIPANT_KEYWORDS.items():
        score = sum(1 for kw in keywords if kw in caption_lower)
        if score > 0:
            scores[cat] = score
    result["participants"] = max(scores, key=scores.get) if scores else "abstract"

    # Process
    scores = {}
    for cat, keywords in PROCESS_KEYWORDS.items():
        score = sum(1 for kw in keywords if kw in caption_lower)
        if score > 0:
            scores[cat] = score
    result["process"] = max(scores, key=scores.get) if scores else "event"

    # Contact
    if any(kw in caption_lower for kw in CONTACT_KEYWORDS["strong_contact"]):
        result["contact"] = "strong_contact"
    elif any(kw in caption_lower for kw in ["person", "man", "woman", "people", "group"]):
        result["contact"] = "weak_contact"
    else:
        result["contact"] = "no_contact"

    # Distance (heuristic from caption)
    if any(kw in caption_lower for kw in DISTANCE_KEYWORDS["intimate"]):
        result["distance"] = "intimate"
    elif any(kw in caption_lower for kw in DISTANCE_KEYWORDS["impersonal"]):
        result["distance"] = "impersonal"
    else:
        result["distance"] = "social"

    # Gender
    has_male = any(w in caption_lower for w in ["man", "men", "boy", "male", "he"])
    has_female = any(w in caption_lower for w in ["woman", "women", "girl", "female", "she"])
    has_group = any(w in caption_lower for w in ["group", "people", "crowd", "team"])
    if has_male and has_female or has_group:
        result["gender"] = "mixed_group"
    elif has_male:
        result["gender"] = "male"
    elif has_female:
        result["gender"] = "female"
    else:
        result["gender"] = "no_people"

    # Text overlay (heuristic)
    result["has_text_overlay"] = any(
        w in caption_lower for w in ["text", "sign", "logo", "poster", "banner", "slide"]
    )

    return result


def main() -> None:
    # ── Load data ─────────────────────────────────────────────────────────
    print("Loading data...")
    embeddings = np.load(DATA_DIR / "embeddings.npy")
    embeddings_norm = normalize(embeddings, norm="l2")

    with open(DATA_DIR / "filenames.json", encoding="utf-8") as f:
        filenames = json.load(f)

    labels = np.load(DATA_DIR / "labels.npy")

    with open(DATA_DIR / "cluster_assignments.json", encoding="utf-8") as f:
        cluster_data = json.load(f)

    # ── Load BLIP captions ────────────────────────────────────────────────
    blip_path = DATA_DIR / "blip_captions.json"
    if blip_path.exists():
        with open(blip_path, encoding="utf-8") as f:
            blip_captions = json.load(f)
        print(f"BLIP captions loaded: {len(blip_captions):,}")
    else:
        print("WARNING: blip_captions.json not found. Run caption_blip.py first.")
        blip_captions = {}

    # ── Load LLaVA sample codings ─────────────────────────────────────────
    llava_path = DATA_DIR / "llava_sample_codings.json"
    if llava_path.exists():
        with open(llava_path, encoding="utf-8") as f:
            llava_codings = json.load(f)
        print(f"LLaVA sample codings loaded: {len(llava_codings)}")
    else:
        print("WARNING: llava_sample_codings.json not found. Using BLIP only.")
        llava_codings = []

    # ── Load KIC labels ───────────────────────────────────────────────────
    kic_map = {}
    if KIC_DIR.exists():
        for kic_folder in KIC_DIR.iterdir():
            if kic_folder.is_dir():
                for img in kic_folder.iterdir():
                    if img.is_file():
                        kic_map[img.name] = kic_folder.name
    print(f"KIC-labeled images: {len(kic_map):,}")

    # ── Build filename index ──────────────────────────────────────────────
    fn_to_idx = {fn: i for i, fn in enumerate(filenames)}

    # ── Step 1: BLIP keyword classification for ALL images ────────────────
    print("\nClassifying all images from BLIP captions...")
    all_codings = []
    for fn in filenames:
        caption = blip_captions.get(fn, "")
        coding = classify_caption(caption)
        coding["filename"] = fn
        coding["cluster_id"] = int(labels[fn_to_idx[fn]])
        coding["kic"] = kic_map.get(fn, "unknown")
        coding["blip_caption"] = caption
        coding["source"] = "blip_keyword"
        all_codings.append(coding)

    # ── Step 2: Override with LLaVA codings where available ───────────────
    if llava_codings:
        llava_by_file = {r["filename"]: r for r in llava_codings if r.get("coding")}
        overrides = 0
        for coding in all_codings:
            if coding["filename"] in llava_by_file:
                llava = llava_by_file[coding["filename"]]["coding"]
                for field in ["participants", "process", "setting", "contact",
                              "distance", "vertical_angle", "coding_orientation",
                              "gender", "has_text_overlay"]:
                    if field in llava and llava[field]:
                        coding[field] = llava[field]
                coding["source"] = "llava"
                overrides += 1
        print(f"LLaVA overrides applied: {overrides}")

    # ── Step 3: k-NN propagation of LLaVA codings ────────────────────────
    if llava_codings:
        # Build k-NN index
        print("\nBuilding k-NN index for label propagation...")
        nn = NearestNeighbors(n_neighbors=10, metric="cosine", algorithm="brute")
        nn.fit(embeddings_norm)

        # Get LLaVA-coded image indices and labels
        llava_indices = []
        llava_labels = {}
        for r in llava_codings:
            if r.get("coding") and r["filename"] in fn_to_idx:
                idx = fn_to_idx[r["filename"]]
                llava_indices.append(idx)
                llava_labels[idx] = r["coding"]

        print(f"Propagating from {len(llava_indices)} LLaVA-coded images...")

        # For each non-LLaVA image, find nearest LLaVA neighbors
        propagated = 0
        for i, coding in enumerate(all_codings):
            if coding["source"] == "llava":
                continue  # Already has LLaVA coding

            # Find neighbors
            idx = fn_to_idx[coding["filename"]]
            distances, neighbor_indices = nn.kneighbors(
                embeddings_norm[idx:idx+1], n_neighbors=10
            )

            # Check if any neighbors are LLaVA-coded
            llava_neighbors = []
            for ni, dist in zip(neighbor_indices[0], distances[0]):
                if ni in llava_labels:
                    llava_neighbors.append((ni, dist))

            if llava_neighbors:
                # Weight by inverse distance
                best_ni, best_dist = min(llava_neighbors, key=lambda x: x[1])
                llava_coding = llava_labels[best_ni]

                # Only override if close enough (cosine distance < 0.3)
                if best_dist < 0.3:
                    for field in ["participants", "process", "contact",
                                  "distance", "coding_orientation", "gender"]:
                        if field in llava_coding and llava_coding[field]:
                            coding[field] = llava_coding[field]
                    coding["source"] = "knn_propagated"
                    coding["knn_distance"] = round(float(best_dist), 4)
                    propagated += 1

        print(f"k-NN propagated: {propagated:,} images")

    # ── Aggregate statistics ──────────────────────────────────────────────
    print("\n" + "=" * 60)
    print("CORPUS STATISTICS (n = {:,})".format(len(all_codings)))
    print("=" * 60)

    # Source breakdown
    sources = Counter(c["source"] for c in all_codings)
    print(f"\nCoding source: {dict(sources)}")

    # Participants
    participants = Counter(c["participants"] for c in all_codings)
    total = len(all_codings)
    print(f"\nParticipants (content type):")
    for cat, n in participants.most_common():
        print(f"  {cat:20s}: {n:6,} ({n/total*100:5.1f}%)")

    # Process
    processes = Counter(c["process"] for c in all_codings)
    print(f"\nProcess (activity):")
    for cat, n in processes.most_common():
        print(f"  {cat:20s}: {n:6,} ({n/total*100:5.1f}%)")

    # Contact
    contacts = Counter(c["contact"] for c in all_codings)
    print(f"\nContact:")
    for cat, n in contacts.most_common():
        print(f"  {cat:20s}: {n:6,} ({n/total*100:5.1f}%)")

    # Gender
    genders = Counter(c["gender"] for c in all_codings)
    print(f"\nGender:")
    for cat, n in genders.most_common():
        print(f"  {cat:20s}: {n:6,} ({n/total*100:5.1f}%)")

    # KIC distribution
    kics = Counter(c["kic"] for c in all_codings)
    print(f"\nKIC distribution:")
    for cat, n in kics.most_common():
        print(f"  {cat:20s}: {n:6,} ({n/total*100:5.1f}%)")

    # Per-cluster profiles
    print(f"\nCluster profiles:")
    for ci in cluster_data["clusters"]:
        cid = ci["cluster_id"]
        cc = [c for c in all_codings if c["cluster_id"] == cid]
        top_participant = Counter(c["participants"] for c in cc).most_common(1)[0]
        top_process = Counter(c["process"] for c in cc).most_common(1)[0]
        top_contact = Counter(c["contact"] for c in cc).most_common(1)[0]
        print(f"  Cluster {cid} ({ci['size']:,}): "
              f"{top_participant[0]} ({top_participant[1]/len(cc)*100:.0f}%), "
              f"{top_process[0]} ({top_process[1]/len(cc)*100:.0f}%), "
              f"{top_contact[0]} ({top_contact[1]/len(cc)*100:.0f}%)")

    # ── Save full corpus ──────────────────────────────────────────────────
    out_path = DATA_DIR / "visual_corpus_coded.json"
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump({
            "n_images": len(all_codings),
            "n_clusters": cluster_data["n_clusters"],
            "sources": dict(sources),
            "images": all_codings,
        }, f, indent=2, ensure_ascii=False)
    print(f"\nSaved: {out_path}")

    # ── Save summary statistics ───────────────────────────────────────────
    stats = {
        "n_images": len(all_codings),
        "n_clusters": cluster_data["n_clusters"],
        "sources": dict(sources),
        "participants": {k: {"n": v, "pct": round(v/total*100, 1)} for k, v in participants.most_common()},
        "process": {k: {"n": v, "pct": round(v/total*100, 1)} for k, v in processes.most_common()},
        "contact": {k: {"n": v, "pct": round(v/total*100, 1)} for k, v in contacts.most_common()},
        "gender": {k: {"n": v, "pct": round(v/total*100, 1)} for k, v in genders.most_common()},
        "kic_distribution": {k: v for k, v in kics.most_common()},
    }
    stats_path = DATA_DIR / "corpus_statistics.json"
    with open(stats_path, "w", encoding="utf-8") as f:
        json.dump(stats, f, indent=2)
    print(f"Saved: {stats_path}")


if __name__ == "__main__":
    main()

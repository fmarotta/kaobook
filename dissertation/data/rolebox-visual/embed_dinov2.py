"""DINOv2 embedding pipeline for tweet images.

Embeds all deduplicated tweet images using DINOv2 ViT-S/14 (timm).
Outputs: embeddings.npy, filenames.json, cluster_assignments.json
"""

import json
import time
from pathlib import Path

import numpy as np
import timm
import torch
from PIL import Image
from timm.data import resolve_data_config, create_transform
from torch.utils.data import DataLoader, Dataset

# ── Paths ────────────────────────────────────────────────────────────────────
IMAGE_DIR = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-visual\data\raw\tweet_images_deduped")
OUTPUT_DIR = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-visual\data\processed\dinov2")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# ── Config ───────────────────────────────────────────────────────────────────
MODEL_NAME = "vit_small_patch14_dinov2"  # 384-dim, ~22M params
BATCH_SIZE = 64  # fits in 6GB VRAM
NUM_WORKERS = 0  # Windows compatibility
DEVICE = "cuda" if torch.cuda.is_available() else "cpu"


class ImageFolderFlat(Dataset):
    """Flat folder of images (no subdirectories)."""

    EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp"}

    def __init__(self, root: Path, transform: torch.nn.Module) -> None:
        self.files = sorted(
            f for f in root.iterdir()
            if f.is_file() and f.suffix.lower() in self.EXTENSIONS
        )
        self.transform = transform
        print(f"Found {len(self.files):,} images in {root}")

    def __len__(self) -> int:
        return len(self.files)

    def __getitem__(self, idx: int) -> tuple[torch.Tensor, str]:
        path = self.files[idx]
        try:
            img = Image.open(path).convert("RGB")
            tensor = self.transform(img)
        except Exception:
            # Return a black image for corrupt files
            tensor = torch.zeros(3, 224, 224)
        return tensor, path.name


def main() -> None:
    print(f"Device: {DEVICE}")
    if DEVICE == "cuda":
        print(f"GPU: {torch.cuda.get_device_name(0)}")
        print(f"VRAM: {torch.cuda.get_device_properties(0).total_memory / 1024**3:.1f} GB")

    # ── Load model ────────────────────────────────────────────────────────
    print(f"\nLoading {MODEL_NAME}...")
    model = timm.create_model(MODEL_NAME, pretrained=True, num_classes=0)
    model = model.to(DEVICE)
    model.eval()

    config = resolve_data_config(model.pretrained_cfg)
    transform = create_transform(**config)
    print(f"Input size: {config['input_size']}, embedding dim: {model.num_features}")

    # ── Dataset + loader ──────────────────────────────────────────────────
    dataset = ImageFolderFlat(IMAGE_DIR, transform)
    loader = DataLoader(
        dataset,
        batch_size=BATCH_SIZE,
        shuffle=False,
        num_workers=NUM_WORKERS,
        pin_memory=True,
    )

    # ── Embed ─────────────────────────────────────────────────────────────
    all_embeddings = []
    all_filenames = []
    t0 = time.time()
    total_batches = len(loader)

    print(f"\nEmbedding {len(dataset):,} images in {total_batches} batches...")
    with torch.no_grad():
        for i, (batch, names) in enumerate(loader):
            batch = batch.to(DEVICE)
            emb = model(batch)  # (B, 384)
            all_embeddings.append(emb.cpu().numpy())
            all_filenames.extend(names)

            if (i + 1) % 50 == 0 or (i + 1) == total_batches:
                elapsed = time.time() - t0
                imgs_done = (i + 1) * BATCH_SIZE
                rate = imgs_done / elapsed
                eta = (len(dataset) - imgs_done) / rate if rate > 0 else 0
                print(f"  Batch {i+1}/{total_batches} | "
                      f"{imgs_done:,}/{len(dataset):,} images | "
                      f"{rate:.0f} img/s | ETA {eta:.0f}s")

    # ── Save ──────────────────────────────────────────────────────────────
    embeddings = np.concatenate(all_embeddings, axis=0)
    elapsed = time.time() - t0
    print(f"\nDone: {embeddings.shape[0]:,} embeddings x {embeddings.shape[1]} dims "
          f"in {elapsed:.1f}s ({embeddings.shape[0] / elapsed:.0f} img/s)")

    emb_path = OUTPUT_DIR / "embeddings.npy"
    np.save(emb_path, embeddings)
    print(f"Saved: {emb_path} ({emb_path.stat().st_size / 1024 / 1024:.1f} MB)")

    names_path = OUTPUT_DIR / "filenames.json"
    with open(names_path, "w", encoding="utf-8") as f:
        json.dump(all_filenames, f)
    print(f"Saved: {names_path}")

    # ── Quick stats ───────────────────────────────────────────────────────
    norms = np.linalg.norm(embeddings, axis=1)
    print(f"\nEmbedding norms: mean={norms.mean():.2f}, "
          f"std={norms.std():.2f}, min={norms.min():.2f}, max={norms.max():.2f}")

    # Check for zero embeddings (corrupt images)
    zero_mask = norms < 0.01
    n_zero = zero_mask.sum()
    if n_zero > 0:
        print(f"WARNING: {n_zero} zero/near-zero embeddings (corrupt images)")


if __name__ == "__main__":
    main()

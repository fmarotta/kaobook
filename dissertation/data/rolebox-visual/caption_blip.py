"""BLIP captioning pipeline for all tweet images.

Generates free-text captions for every image using BLIP-base.
Fast enough to process all 31K+ images on GPU.
"""

import json
import time
from pathlib import Path

import numpy as np
import torch
from PIL import Image
from transformers import BlipProcessor, BlipForConditionalGeneration

# ── Paths ────────────────────────────────────────────────────────────────────
IMAGE_DIR = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-visual\data\raw\tweet_images_deduped")
OUTPUT_DIR = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-visual\data\processed\dinov2")

# ── Config ───────────────────────────────────────────────────────────────────
MODEL_ID = "Salesforce/blip-image-captioning-base"
BATCH_SIZE = 16
DEVICE = "cuda" if torch.cuda.is_available() else "cpu"
EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp"}


def main() -> None:
    print(f"Device: {DEVICE}")

    # ── Load model ────────────────────────────────────────────────────────
    print(f"Loading {MODEL_ID}...")
    processor = BlipProcessor.from_pretrained(MODEL_ID)
    model = BlipForConditionalGeneration.from_pretrained(MODEL_ID).to(DEVICE)
    model.eval()
    print("Model loaded.")

    # ── Collect images ────────────────────────────────────────────────────
    image_files = sorted(
        f for f in IMAGE_DIR.iterdir()
        if f.is_file() and f.suffix.lower() in EXTENSIONS
    )
    print(f"Found {len(image_files):,} images")

    # ── Load filenames order from DINOv2 pipeline ─────────────────────────
    filenames_path = OUTPUT_DIR / "filenames.json"
    with open(filenames_path, encoding="utf-8") as f:
        dinov2_filenames = json.load(f)

    # Build lookup for consistent ordering
    filename_set = set(dinov2_filenames)

    # ── Caption in batches ────────────────────────────────────────────────
    captions = {}
    errors = []
    t0 = time.time()
    total = len(image_files)

    for batch_start in range(0, total, BATCH_SIZE):
        batch_end = min(batch_start + BATCH_SIZE, total)
        batch_paths = image_files[batch_start:batch_end]

        # Load images
        images = []
        valid_paths = []
        for p in batch_paths:
            try:
                img = Image.open(p).convert("RGB")
                images.append(img)
                valid_paths.append(p)
            except Exception as e:
                errors.append({"filename": p.name, "error": str(e)})

        if not images:
            continue

        # Process batch
        try:
            inputs = processor(images=images, return_tensors="pt").to(DEVICE)
            with torch.no_grad():
                out = model.generate(
                    **inputs,
                    max_new_tokens=50,
                    num_beams=3,
                )
            batch_captions = processor.batch_decode(out, skip_special_tokens=True)

            for path, caption in zip(valid_paths, batch_captions):
                captions[path.name] = caption
        except Exception as e:
            for p in valid_paths:
                errors.append({"filename": p.name, "error": str(e)})

        # Progress
        done = batch_end
        if done % (BATCH_SIZE * 50) == 0 or done == total:
            elapsed = time.time() - t0
            rate = done / elapsed if elapsed > 0 else 0
            eta = (total - done) / rate if rate > 0 else 0
            print(f"  {done:,}/{total:,} | {rate:.0f} img/s | ETA {eta:.0f}s")

    elapsed = time.time() - t0
    print(f"\nDone: {len(captions):,} captions in {elapsed:.0f}s "
          f"({len(captions) / elapsed:.0f} img/s)")
    print(f"Errors: {len(errors)}")

    # ── Save captions ────────────────────────────────────────────────────
    out_path = OUTPUT_DIR / "blip_captions.json"
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(captions, f, indent=2, ensure_ascii=False)
    print(f"Saved: {out_path}")

    if errors:
        err_path = OUTPUT_DIR / "blip_errors.json"
        with open(err_path, "w", encoding="utf-8") as f:
            json.dump(errors, f, indent=2)
        print(f"Errors saved: {err_path}")

    # ── Quick stats ───────────────────────────────────────────────────────
    cap_lengths = [len(c.split()) for c in captions.values()]
    print(f"\nCaption length: mean={np.mean(cap_lengths):.1f} words, "
          f"median={np.median(cap_lengths):.0f}, "
          f"max={max(cap_lengths)}")

    # Most common starting words
    from collections import Counter
    starts = Counter(c.split()[0].lower() if c.split() else "" for c in captions.values())
    print("Most common first words:", starts.most_common(10))


if __name__ == "__main__":
    main()

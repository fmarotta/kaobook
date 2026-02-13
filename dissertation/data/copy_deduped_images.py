"""Copy deduplicated tweet images to rolebox-visual for Ch8 analysis.

Reads the dedup manifest and copies one file per unique hash
to the visual analysis input folder.
"""

import json
import shutil
from pathlib import Path

SOURCE_DIR = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-social\data\processed\tweet_images\downloaded")
MANIFEST = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-social\data\processed\tweet_images\dedup_manifest.json")
TARGET_DIR = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-visual\data\raw\tweet_images_deduped")


def main() -> None:
    # Load manifest
    with open(MANIFEST, encoding="utf-8") as f:
        manifest = json.load(f)

    images = manifest["images"]
    print(f"Manifest: {manifest['unique_images']:,} unique images")
    print(f"Source: {SOURCE_DIR}")
    print(f"Target: {TARGET_DIR}")

    # Create target directory
    TARGET_DIR.mkdir(parents=True, exist_ok=True)

    # Check how many already exist
    existing = set(f.name for f in TARGET_DIR.iterdir() if f.is_file())
    to_copy = [img for img in images if img["filename"] not in existing]

    print(f"Already in target: {len(existing):,}")
    print(f"To copy: {len(to_copy):,}")

    # Copy files
    copied = 0
    errors = 0
    for i, img in enumerate(to_copy):
        src = SOURCE_DIR / img["filename"]
        dst = TARGET_DIR / img["filename"]

        if not src.exists():
            errors += 1
            continue

        shutil.copy2(src, dst)
        copied += 1

        if (copied) % 5000 == 0:
            print(f"  ...copied {copied:,}/{len(to_copy):,}")

    print(f"\nDone: {copied:,} copied, {errors:,} errors")
    print(f"Total in target: {len(list(TARGET_DIR.iterdir())):,}")


if __name__ == "__main__":
    main()

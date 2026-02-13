"""Deduplicate tweet images by file hash and file size.

Produces a manifest of unique images with metadata for Ch8 visual analysis.
"""

import hashlib
import json
from collections import Counter, defaultdict
from pathlib import Path

# Paths
TWEET_IMAGES = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-social\data\processed\tweet_images\downloaded")
ACCOUNTS_CSV = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-social\data\processed\tweet_images\eit_twitter_accounts.csv")
DOWNLOAD_RESULTS = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-social\data\processed\tweet_images\download_results.csv")
OUTPUT_DIR = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-visual\data\raw\tweet_images_deduped")

def hash_file(path: Path) -> str:
    """SHA-256 hash of file contents."""
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> None:
    print(f"Scanning: {TWEET_IMAGES}")

    # Collect all image files
    extensions = {".jpg", ".jpeg", ".png", ".gif", ".webp"}
    all_files = [
        f for f in TWEET_IMAGES.iterdir()
        if f.is_file() and f.suffix.lower() in extensions
    ]
    print(f"Total image files found: {len(all_files):,}")

    # Extension breakdown
    ext_counts = Counter(f.suffix.lower() for f in all_files)
    print(f"By extension: {dict(ext_counts)}")

    # Size analysis (catch zero-byte / corrupt files)
    sizes = []
    zero_byte = []
    tiny_files = []  # < 1KB likely corrupt/placeholder

    for f in all_files:
        sz = f.stat().st_size
        sizes.append(sz)
        if sz == 0:
            zero_byte.append(f)
        elif sz < 1024:
            tiny_files.append(f)

    print(f"Zero-byte files: {len(zero_byte):,}")
    print(f"Tiny files (<1KB): {len(tiny_files):,}")

    # Filter out zero-byte and tiny files
    valid_files = [f for f in all_files if f.stat().st_size >= 1024]
    print(f"Valid files (>=1KB): {len(valid_files):,}")

    # Hash all valid files
    print(f"\nHashing {len(valid_files):,} files...")
    hash_to_files: dict[str, list[Path]] = defaultdict(list)

    for i, f in enumerate(valid_files):
        if (i + 1) % 5000 == 0:
            print(f"  ...hashed {i + 1:,}/{len(valid_files):,}")
        file_hash = hash_file(f)
        hash_to_files[file_hash].append(f)

    unique_hashes = len(hash_to_files)
    duplicate_groups = {h: files for h, files in hash_to_files.items() if len(files) > 1}
    total_duplicates = sum(len(files) - 1 for files in duplicate_groups.values())

    print(f"\nResults:")
    print(f"  Unique images: {unique_hashes:,}")
    print(f"  Duplicate groups: {len(duplicate_groups):,}")
    print(f"  Total duplicate files: {total_duplicates:,}")
    print(f"  Dedup ratio: {total_duplicates / len(valid_files) * 100:.1f}%")

    # Size distribution of unique images
    unique_sizes = []
    for h, files in hash_to_files.items():
        unique_sizes.append(files[0].stat().st_size)

    unique_sizes.sort()
    median_size = unique_sizes[len(unique_sizes) // 2]
    total_size_mb = sum(unique_sizes) / (1024 * 1024)

    print(f"\nUnique image sizes:")
    print(f"  Median: {median_size / 1024:.1f} KB")
    print(f"  Min: {min(unique_sizes) / 1024:.1f} KB")
    print(f"  Max: {max(unique_sizes) / 1024:.1f} KB")
    print(f"  Total: {total_size_mb:.0f} MB")

    # Top duplicate groups (most copies)
    top_dupes = sorted(duplicate_groups.items(), key=lambda x: len(x[1]), reverse=True)[:10]
    print(f"\nTop 10 most duplicated images:")
    for h, files in top_dupes:
        print(f"  {len(files)} copies: {files[0].name} ({files[0].stat().st_size / 1024:.0f} KB)")

    # Build manifest of unique images (keep first file per hash)
    manifest = []
    for h, files in hash_to_files.items():
        keeper = files[0]
        manifest.append({
            "hash": h,
            "filename": keeper.name,
            "size_bytes": keeper.stat().st_size,
            "copies": len(files),
            "all_filenames": [f.name for f in files],
        })

    # Sort by filename
    manifest.sort(key=lambda x: x["filename"])

    # Save manifest
    manifest_path = TWEET_IMAGES.parent / "dedup_manifest.json"
    with open(manifest_path, "w", encoding="utf-8") as f:
        json.dump({
            "total_files": len(all_files),
            "valid_files": len(valid_files),
            "zero_byte": len(zero_byte),
            "tiny_files": len(tiny_files),
            "unique_images": unique_hashes,
            "duplicate_files": total_duplicates,
            "dedup_ratio_pct": round(total_duplicates / len(valid_files) * 100, 1),
            "total_size_mb": round(total_size_mb, 1),
            "images": manifest,
        }, f, indent=2)

    print(f"\nManifest saved: {manifest_path}")
    print(f"  {unique_hashes:,} unique images ready for visual analysis pipeline")


if __name__ == "__main__":
    main()

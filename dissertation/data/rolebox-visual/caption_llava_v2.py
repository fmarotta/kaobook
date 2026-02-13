"""LLaVA structured coding pipeline v2 - fixed prompt.

Codes a stratified sample (50 per cluster = 400 images) with proper
single-choice prompting for semiotic categories.
"""

import base64
import json
import random
import time
from pathlib import Path

import httpx
import numpy as np

# ── Paths ────────────────────────────────────────────────────────────────────
DATA_DIR = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-visual\data\processed\dinov2")
IMAGE_DIR = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-visual\data\raw\tweet_images_deduped")

# ── Config ───────────────────────────────────────────────────────────────────
OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL = "llava:7b"
SAMPLE_PER_CLUSTER = 50

# Better prompt: forces single-choice answers
SEMIOTIC_PROMPT = """Look at this image carefully. It comes from an innovation organization's Twitter.

Answer each question with ONLY the letter of your choice.

1. Main content? (a) people (b) technology (c) nature (d) abstract/graphic (e) mixed
2. Activity? (a) presentation (b) group photo (c) meeting (d) portrait (e) event (f) product/demo (g) graphic/poster (h) landscape
3. Setting? (a) conference room (b) office (c) stage/podium (d) outdoor (e) lab (f) studio/plain background (g) industrial
4. Eye contact with viewer? (a) direct eye contact (b) people but no eye contact (c) no people
5. Camera distance? (a) close-up (b) medium shot (c) wide shot
6. Camera angle? (a) eye level (b) looking down (c) looking up
7. Visual style? (a) photo-realistic (b) enhanced/filtered (c) technical/diagram (d) abstract/graphic
8. Gender visible? (a) male individual (b) female individual (c) mixed group (d) no people visible
9. Text overlay on image? (a) yes (b) no

Also write a one-sentence description.

Format your answer as:
1:a 2:b 3:c 4:a 5:b 6:a 7:a 8:c 9:b
DESC: A group of people at a conference."""


CATEGORY_MAP = {
    "1": {"a": "people", "b": "technology", "c": "nature", "d": "abstract", "e": "mixed"},
    "2": {"a": "presentation", "b": "group_photo", "c": "meeting", "d": "portrait",
          "e": "event", "f": "product_demo", "g": "graphic_poster", "h": "landscape"},
    "3": {"a": "conference", "b": "office", "c": "stage", "d": "outdoor",
          "e": "lab", "f": "studio", "g": "industrial"},
    "4": {"a": "strong_contact", "b": "weak_contact", "c": "no_contact"},
    "5": {"a": "intimate", "b": "social", "c": "impersonal"},
    "6": {"a": "eye_level", "b": "high_angle", "c": "low_angle"},
    "7": {"a": "naturalistic", "b": "sensory", "c": "technological", "d": "abstract"},
    "8": {"a": "male", "b": "female", "c": "mixed_group", "d": "no_people"},
    "9": {"a": "yes", "b": "no"},
}

FIELD_NAMES = {
    "1": "participants", "2": "process", "3": "setting",
    "4": "contact", "5": "distance", "6": "vertical_angle",
    "7": "coding_orientation", "8": "gender", "9": "has_text_overlay",
}


def encode_image(path: Path) -> str:
    return base64.b64encode(path.read_bytes()).decode("utf-8")


def parse_response(raw: str) -> dict:
    """Parse letter-based response into structured coding."""
    coding = {}
    description = ""

    for line in raw.strip().split("\n"):
        line = line.strip()
        if line.upper().startswith("DESC:"):
            description = line[5:].strip()
            continue

        # Parse "1:a 2:b 3:c ..." patterns
        for token in line.split():
            if ":" in token:
                parts = token.split(":")
                q_num = parts[0].strip()
                answer = parts[1].strip().lower().rstrip(".,;")
                if q_num in CATEGORY_MAP and answer in CATEGORY_MAP[q_num]:
                    field = FIELD_NAMES[q_num]
                    coding[field] = CATEGORY_MAP[q_num][answer]

    coding["description"] = description
    return coding


def caption_image(image_path: Path, client: httpx.Client) -> dict:
    img_b64 = encode_image(image_path)
    payload = {
        "model": MODEL,
        "prompt": SEMIOTIC_PROMPT,
        "images": [img_b64],
        "stream": False,
        "options": {"temperature": 0.1, "num_predict": 256},
    }
    resp = client.post(OLLAMA_URL, json=payload, timeout=120.0)
    resp.raise_for_status()
    raw = resp.json().get("response", "")
    coding = parse_response(raw)
    has_fields = sum(1 for k in FIELD_NAMES.values() if k in coding and coding[k])
    status = "ok" if has_fields >= 5 else "partial"
    return {"status": status, "coding": coding, "raw": raw, "fields_parsed": has_fields}


def main() -> None:
    # Load cluster assignments
    with open(DATA_DIR / "cluster_assignments.json", encoding="utf-8") as f:
        cluster_data = json.load(f)
    with open(DATA_DIR / "filenames.json", encoding="utf-8") as f:
        filenames = json.load(f)

    labels = np.load(DATA_DIR / "labels.npy")

    # Stratified sample: SAMPLE_PER_CLUSTER per cluster
    random.seed(42)
    sample = []
    for ci in cluster_data["clusters"]:
        cid = ci["cluster_id"]
        cluster_files = [filenames[i] for i in range(len(filenames)) if labels[i] == cid]
        n = min(SAMPLE_PER_CLUSTER, len(cluster_files))
        chosen = random.sample(cluster_files, n)
        for fn in chosen:
            sample.append({"filename": fn, "cluster_id": cid})

    print(f"Stratified sample: {len(sample)} images "
          f"({SAMPLE_PER_CLUSTER}/cluster x {cluster_data['n_clusters']} clusters)")

    results = []
    ok_count = 0
    t0 = time.time()

    with httpx.Client() as client:
        for i, item in enumerate(sample):
            image_path = IMAGE_DIR / item["filename"]
            if not image_path.exists():
                continue

            try:
                result = caption_image(image_path, client)
                result["filename"] = item["filename"]
                result["cluster_id"] = item["cluster_id"]
                results.append(result)

                if result["status"] == "ok":
                    ok_count += 1

                if (i + 1) % 20 == 0 or (i + 1) == len(sample):
                    elapsed = time.time() - t0
                    rate = (i + 1) / elapsed
                    eta = (len(sample) - i - 1) / rate if rate > 0 else 0
                    print(f"  [{i+1}/{len(sample)}] ok={ok_count} | "
                          f"{rate:.1f} img/s | ETA {eta:.0f}s")
            except Exception as e:
                results.append({
                    "filename": item["filename"],
                    "cluster_id": item["cluster_id"],
                    "status": "error",
                    "coding": {},
                    "raw": str(e),
                    "fields_parsed": 0,
                })

    elapsed = time.time() - t0
    partial = sum(1 for r in results if r["status"] == "partial")
    errors = sum(1 for r in results if r["status"] == "error")
    print(f"\nDone: {ok_count} ok, {partial} partial, {errors} errors "
          f"in {elapsed:.0f}s ({len(results) / elapsed:.1f} img/s)")

    # Save
    out_path = DATA_DIR / "llava_sample_codings.json"
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(results, f, indent=2, ensure_ascii=False)
    print(f"Saved: {out_path}")

    # Aggregate stats per cluster
    print("\nCluster profiles:")
    from collections import Counter
    for ci in cluster_data["clusters"]:
        cid = ci["cluster_id"]
        cr = [r for r in results if r["cluster_id"] == cid and r.get("coding")]
        if not cr:
            continue
        participants = Counter(r["coding"].get("participants", "?") for r in cr)
        processes = Counter(r["coding"].get("process", "?") for r in cr)
        top_p = participants.most_common(2)
        top_pr = processes.most_common(2)
        print(f"  Cluster {cid} ({ci['size']:,}): "
              f"content={top_p} | activity={top_pr}")


if __name__ == "__main__":
    main()

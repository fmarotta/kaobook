"""LLaVA captioning pipeline for cluster representatives via ollama.

Sends representative images to LLaVA 7B for structured semiotic coding
following Kress & van Leeuwen (2006) metafunctions.
"""

import base64
import json
import time
from pathlib import Path

import httpx

# ── Paths ────────────────────────────────────────────────────────────────────
DATA_DIR = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-visual\data\processed\dinov2")
IMAGE_DIR = Path(r"c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-visual\data\raw\tweet_images_deduped")
OUTPUT_DIR = DATA_DIR

# ── Config ───────────────────────────────────────────────────────────────────
OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL = "llava:7b"

SEMIOTIC_PROMPT = """Analyze this image from an innovation organization's Twitter account.
Provide a structured analysis in JSON format with these fields:

{
  "description": "One sentence describing what the image shows",
  "participants": "people | technology | nature | abstract | mixed",
  "process": "collaboration | presentation | demonstration | work | portrait | event | landscape | graphic",
  "setting": "office | conference | industrial | campus | lab | event_venue | outdoor | studio | non_descript",
  "contact": "strong_contact | weak_contact | no_contact",
  "distance": "intimate | social | impersonal",
  "vertical_angle": "eye_level | high_angle | low_angle",
  "coding_orientation": "naturalistic | sensory | technological | abstract",
  "gender": "male | female | mixed_group | no_people",
  "dress": "professional | casual | lab_coat | no_people",
  "has_text_overlay": true or false,
  "dominant_colors": ["color1", "color2"]
}

Return ONLY the JSON object, no other text."""


def encode_image(path: Path) -> str:
    """Base64 encode an image file."""
    return base64.b64encode(path.read_bytes()).decode("utf-8")


def caption_image(image_path: Path, client: httpx.Client) -> dict:
    """Send image to LLaVA and parse structured response."""
    img_b64 = encode_image(image_path)

    payload = {
        "model": MODEL,
        "prompt": SEMIOTIC_PROMPT,
        "images": [img_b64],
        "stream": False,
        "options": {
            "temperature": 0.1,
            "num_predict": 512,
        },
    }

    resp = client.post(OLLAMA_URL, json=payload, timeout=120.0)
    resp.raise_for_status()
    result = resp.json()
    raw_text = result.get("response", "")

    # Try to parse JSON from response
    try:
        # Find JSON object in response
        start = raw_text.find("{")
        end = raw_text.rfind("}") + 1
        if start >= 0 and end > start:
            parsed = json.loads(raw_text[start:end])
            return {"status": "ok", "coding": parsed, "raw": raw_text}
    except json.JSONDecodeError:
        pass

    return {"status": "parse_error", "coding": None, "raw": raw_text}


def main() -> None:
    # Load representatives
    reps_path = DATA_DIR / "representatives.json"
    with open(reps_path, encoding="utf-8") as f:
        representatives = json.load(f)

    print(f"Captioning {len(representatives)} representative images with {MODEL}...")

    # Load cluster assignments for context
    with open(DATA_DIR / "cluster_assignments.json", encoding="utf-8") as f:
        cluster_data = json.load(f)

    # Build filename -> cluster mapping
    file_to_cluster = {}
    for ci in cluster_data["clusters"]:
        for fn in ci["top5_representatives"]:
            file_to_cluster[fn] = ci["cluster_id"]

    results = []
    errors = 0
    t0 = time.time()

    with httpx.Client() as client:
        for i, filename in enumerate(representatives):
            image_path = IMAGE_DIR / filename
            if not image_path.exists():
                print(f"  SKIP: {filename} not found")
                errors += 1
                continue

            cluster_id = file_to_cluster.get(filename, -1)
            print(f"  [{i+1}/{len(representatives)}] Cluster {cluster_id}: {filename}...", end=" ")

            try:
                result = caption_image(image_path, client)
                result["filename"] = filename
                result["cluster_id"] = cluster_id
                results.append(result)

                if result["status"] == "ok":
                    desc = result["coding"].get("description", "")[:60]
                    print(f"OK - {desc}")
                else:
                    print(f"PARSE ERROR")
                    errors += 1
            except Exception as e:
                print(f"ERROR: {e}")
                results.append({
                    "filename": filename,
                    "cluster_id": cluster_id,
                    "status": "error",
                    "coding": None,
                    "raw": str(e),
                })
                errors += 1

    elapsed = time.time() - t0
    ok_count = sum(1 for r in results if r["status"] == "ok")
    print(f"\nDone: {ok_count}/{len(representatives)} OK, "
          f"{errors} errors in {elapsed:.0f}s "
          f"({elapsed / len(representatives):.1f}s/image)")

    # Save results
    out_path = OUTPUT_DIR / "llava_captions.json"
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(results, f, indent=2, ensure_ascii=False)
    print(f"Saved: {out_path}")

    # Print cluster summary
    print("\nCluster summaries:")
    for ci in cluster_data["clusters"]:
        cid = ci["cluster_id"]
        cluster_results = [r for r in results if r["cluster_id"] == cid and r["status"] == "ok"]
        if cluster_results:
            # Most common participants type
            participants = [r["coding"].get("participants", "unknown") for r in cluster_results]
            processes = [r["coding"].get("process", "unknown") for r in cluster_results]
            settings = [r["coding"].get("setting", "unknown") for r in cluster_results]
            print(f"  Cluster {cid} ({ci['size']:,} imgs): "
                  f"participants={most_common(participants)}, "
                  f"process={most_common(processes)}, "
                  f"setting={most_common(settings)}")


def most_common(lst: list[str]) -> str:
    """Return most common element in a list."""
    from collections import Counter
    if not lst:
        return "unknown"
    return Counter(lst).most_common(1)[0][0]


if __name__ == "__main__":
    main()

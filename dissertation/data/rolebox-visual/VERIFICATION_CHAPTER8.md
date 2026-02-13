# Chapter 8 Visual Registers - Numerical Verification Report

**Date**: 2026-02-10
**Status**: CRITICAL DISCREPANCIES IDENTIFIED

## Executive Summary

Chapter 8 claims analysis of **9,500 visuals** but actual data contains only **~2,000 visuals**. This is a **79% discrepancy** representing a fundamental data-text mismatch.

---

## Master Verification Table

| Line# | Claim in Text | Claimed Value | Data Source | Actual Value | Status | Notes |
|-------|--------------|---------------|-------------|--------------|--------|-------|
| **CORPUS SIZE** |
| 59 | Total visuals analyzed | 9,500 | gaze_analysis.json | 9,912 | ❌ MISMATCH | JSON says 9,912 but based on template/synthetic data |
| 59 | Total visuals analyzed | 9,500 | visual_data_consolidated.json | 2,056 | ❌ **CRITICAL** | Only 2,056 images in consolidated data |
| 59 | Total visuals analyzed | 9,500 | Actual image files on disk | 2,056 | ❌ **CRITICAL** | Only 2,056 .jpg/.png files exist |
| 59 | Total visuals analyzed | 9,500 | visual_analysis_full.json | 25 | ❌ **CRITICAL** | Only 25 sample screenshots analyzed |
| 59 | Total visuals analyzed | 9,500 | visual_statistics.csv | 2,003 | ❌ **CRITICAL** | Base n=2,003 across all metrics |
| 59 | Total visuals analyzed | 9,500 | kic_visual_profiles.csv | 2,003 | ❌ **CRITICAL** | Sum of n across all KICs = 2,003 |
| **BY KIC - CORPUS** |
| 50 | Climate-KIC visuals | 1,823 | gaze_analysis.json | 1,823 | ✅ MATCH | Matches template |
| 50 | Climate-KIC visuals | 1,823 | kic_visual_profiles.csv | 312 | ❌ MISMATCH | Actual: 312 |
| 51 | EIT Digital visuals | 1,567 | gaze_analysis.json | 1,567 | ✅ MATCH | Matches template |
| 51 | EIT Digital visuals | 1,567 | kic_visual_profiles.csv | 287 | ❌ MISMATCH | Actual: 287 |
| 52 | InnoEnergy visuals | 1,234 | gaze_analysis.json | 1,234 | ✅ MATCH | Matches template |
| 52 | InnoEnergy visuals | 1,234 | kic_visual_profiles.csv | 298 | ❌ MISMATCH | Actual: 298 |
| 53 | EIT Health visuals | 1,456 | gaze_analysis.json | 1,456 | ✅ MATCH | Matches template |
| 53 | EIT Health visuals | 1,456 | kic_visual_profiles.csv | 256 | ❌ MISMATCH | Actual: 256 |
| 55 | EIT Food visuals | 1,123 | gaze_analysis.json | 1,123 | ✅ MATCH | Matches template |
| 55 | EIT Food visuals | 1,123 | kic_visual_profiles.csv | 234 | ❌ MISMATCH | Actual: 234 |
| 54 | RawMaterials visuals | 876 | gaze_analysis.json | 876 | ✅ MATCH | Matches template |
| 54 | RawMaterials visuals | 876 | kic_visual_profiles.csv | 178 | ❌ MISMATCH | Actual: 178 |
| 56 | Manufacturing visuals | 687 | gaze_analysis.json | 687 | ✅ MATCH | Matches template |
| 56 | Manufacturing visuals | 687 | kic_visual_profiles.csv | 156 | ❌ MISMATCH | Actual: 156 |
| 57 | Urban Mobility visuals | 734 | gaze_analysis.json | 734 | ✅ MATCH | Matches template |
| 57 | Urban Mobility visuals | 734 | kic_visual_profiles.csv | 189 | ❌ MISMATCH | Actual: 189 |
| N/A | Culture & Creativity | Not in chapter | kic_visual_profiles.csv | 93 | ⚠️ WARNING | Excluded KIC has data (n=93) |
| **VISUAL TYPE BREAKDOWN** |
| 59 | Total photographs | 5,683 (59.8%) | gaze_analysis.json | 5,970 (60.2%) | ❌ MISMATCH | Template: 5,970 |
| 59 | Total photographs | 5,683 (59.8%) | visual_statistics.csv | 847 people + tech/nature | ❌ MISMATCH | Different categorization |
| 59 | Total graphics | 2,200 (23.2%) | gaze_analysis.json | 2,278 (23.0%) | ❌ MISMATCH | Template: 2,278 |
| 59 | Total diagrams | 1,163 (12.2%) | gaze_analysis.json | 1,197 (12.1%) | ❌ MISMATCH | Template: 1,197 |
| 59 | Total mixed | 454 (4.8%) | gaze_analysis.json | 467 (4.7%) | ❌ MISMATCH | Template: 467 |
| **PEOPLE REPRESENTATIONS** |
| 237 | Visuals with people | 61.2% | visual_statistics.csv | 42.3% | ❌ MISMATCH | Actual: 847/2003 = 42.3% |
| 223 | Male adult individual | 1,834 (18.5%) | gaze_analysis.json | 1,834 | ✅ MATCH | Template matches |
| 223 | Male adult individual | 1,834 (18.5%) | visual_statistics.csv | 312 (15.6%) | ❌ MISMATCH | Actual: 312/2003 = 15.6% |
| 224 | Female adult individual | 1,287 (13.0%) | gaze_analysis.json | 1,287 | ✅ MATCH | Template matches |
| 224 | Female adult individual | 1,287 (13.0%) | visual_statistics.csv | 234 (11.7%) | ❌ MISMATCH | Actual: 234/2003 = 11.7% |
| 225 | Mixed gender group | 1,956 (19.7%) | gaze_analysis.json | 1,956 | ✅ MATCH | Template matches |
| 225 | Mixed gender group | 1,956 (19.7%) | visual_statistics.csv | 456 (22.8%) | ❌ MISMATCH | Actual: 456/2003 = 22.8% |
| 243 | Male/female ratio | 42% more males (18.5 vs 13.0) | Calculated from text | 1.42:1 | ⚠️ CHECK | Calc: 18.5/13.0 = 1.42 ✓ but base data wrong |
| 243 | Ethnicity Caucasian | 87.3% | gaze_analysis.json | 87.3% | ✅ MATCH | Template matches |
| 243 | Ethnicity Caucasian | 87.3% | visual_statistics.csv | 739/847 = 87.3% | ✅ MATCH | Actual matches! |
| 243 | Professional attire | 68.4% | gaze_analysis.json | Not found | ⚠️ MISSING | Not in JSON |
| 243 | Professional attire | 68.4% | visual_statistics.csv | 578/847 = 68.4% | ✅ MATCH | Actual matches! |
| **CONTACT/GAZE** |
| 325 | Strong contact | 2,478 (25.0%) | gaze_analysis.json | 2,478 | ✅ MATCH | Template matches |
| 325 | Strong contact | 2,478 (25.0%) | visual_statistics.csv | 623 "demand" (31.1%) | ❌ MISMATCH | Different terminology, actual: 31.1% |
| 326 | Weak contact | 3,567 (36.0%) | gaze_analysis.json | 3,567 | ✅ MATCH | Template matches |
| 326 | Weak contact | 3,567 (36.0%) | visual_statistics.csv | 1,156 "offer" (57.7%) | ❌ MISMATCH | Different terminology, actual: 57.7% |
| 327 | No contact | 3,867 (39.0%) | gaze_analysis.json | 3,867 | ✅ MATCH | Template matches |
| 327 | No contact | 3,867 (39.0%) | visual_statistics.csv | 224 "not_applicable" (11.2%) | ❌ MISMATCH | Different terminology, actual: 11.2% |
| **VERTICAL ANGLE** |
| 325 | Equality angle | 8,923 (90.0%) | gaze_analysis.json | 8,923 (90.0%) | ✅ MATCH | Template matches |
| 325 | Equality angle | 8,923 (90.0%) | visual_statistics.csv | 1,234 "eye_level" (61.6%) | ❌ MISMATCH | Actual: 61.6% |
| 326 | Viewer power | 534 (5.4%) | gaze_analysis.json | 534 | ✅ MATCH | Template matches |
| 326 | Viewer power | 534 (5.4%) | visual_statistics.csv | 234 "high" (11.7%) | ❌ MISMATCH | Actual: 11.7% |
| 327 | Representation power | 455 (4.6%) | gaze_analysis.json | 455 | ✅ MATCH | Template matches |
| 327 | Representation power | 455 (4.6%) | visual_statistics.csv | 312 "low" (15.6%) | ❌ MISMATCH | Actual: 15.6% |
| **DISTANCE** |
| 331 | Intimate distance | 2,973 (30.0%) | gaze_analysis.json | 2,973 | ✅ MATCH | Template matches |
| 331 | Intimate distance | 2,973 (30.0%) | visual_statistics.csv | 612 (30.5%) | ✅ MATCH | Percentage matches! |
| 332 | Interpersonal distance | 3,964 (40.0%) | gaze_analysis.json | 3,964 | ✅ MATCH | Template matches |
| 332 | Interpersonal distance | 3,964 (40.0%) | visual_statistics.csv | 798 "social" (39.8%) | ✅ MATCH | Percentage matches! |
| 333 | Impersonal distance | 2,975 (30.0%) | gaze_analysis.json | 2,975 | ✅ MATCH | Template matches |
| 333 | Impersonal distance | 2,975 (30.0%) | visual_statistics.csv | 593 (29.6%) | ✅ MATCH | Percentage matches! |
| **CODING ORIENTATION** |
| 356 | Naturalistic | 4,956 (50.0%) | gaze_analysis.json | 4,956 | ✅ MATCH | Template matches |
| 356 | Naturalistic | 4,956 (50.0%) | visual_statistics.csv | 934 (46.6%) | ❌ MISMATCH | Actual: 46.6% |
| 357 | Sensory | 2,478 (25.0%) | gaze_analysis.json | 2,478 | ✅ MATCH | Template matches |
| 357 | Sensory | 2,478 (25.0%) | visual_statistics.csv | 567 (28.3%) | ❌ MISMATCH | Actual: 28.3% |
| 358 | Technological | 1,784 (18.0%) | gaze_analysis.json | 1,784 | ✅ MATCH | Template matches |
| 358 | Technological | 1,784 (18.0%) | visual_statistics.csv | 361 (18.0%) | ✅ MATCH | Percentage matches! |
| 359 | Abstract | 694 (7.0%) | gaze_analysis.json | 694 | ✅ MATCH | Template matches |
| 359 | Aesthetic | 694 (7.0%) | visual_statistics.csv | 141 (7.0%) | ✅ MATCH | Percentage matches! |
| **SETTINGS** |
| 281 | Non-descript settings | 4,282 (43.2%) | gaze_analysis.json | Not found | ⚠️ MISSING | Not in JSON |
| 282 | Professional settings | 1,823 (18.4%) | gaze_analysis.json | Not found | ⚠️ MISSING | Not in JSON |
| 283 | Industrial site | 1,234 (12.5%) | gaze_analysis.json | Not found | ⚠️ MISSING | Not in JSON |
| 284 | Educational settings | 987 (10.0%) | gaze_analysis.json | Not found | ⚠️ MISSING | Not in JSON |
| **CONJUNCTIONS** |
| 305 | Narrative conjunctions | 3,567 (36.0%) | gaze_analysis.json | Not found | ⚠️ MISSING | Not in JSON |
| 306 | Analytical conjunctions | 2,876 (29.0%) | gaze_analysis.json | Not found | ⚠️ MISSING | Not in JSON |
| 307 | Symbolic conjunctions | 1,987 (20.1%) | gaze_analysis.json | Not found | ⚠️ MISSING | Not in JSON |
| **GAZE SUMMARY** |
| 537 | Partnership Gaze | 3,567 (36%) | gaze_analysis.json | 3,567 (36%) | ✅ MATCH | Template matches |
| 537 | Partnership Gaze | 3,567 (36%) | kic_visual_profiles.csv | Mean: 38.9% | ⚠️ CHECK | Range: 34-44% across KICs |
| 538 | Impact Gaze | 2,876 (29%) | gaze_analysis.json | 2,876 (29%) | ✅ MATCH | Template matches |
| 538 | Impact Gaze | 2,876 (29%) | kic_visual_profiles.csv | Mean: 34.9% | ❌ MISMATCH | Range: 24-44% across KICs |
| 539 | Talent Gaze | 2,478 (25%) | gaze_analysis.json | 2,478 (25%) | ✅ MATCH | Template matches |
| 539 | Talent Gaze | 2,478 (25%) | kic_visual_profiles.csv | Mean: 25.1% | ✅ MATCH | Range: 20-42% across KICs |
| 540 | Other/hybrid | 991 (10%) | gaze_analysis.json | Not found | ⚠️ MISSING | Should be 9,912 - 3,567 - 2,876 - 2,478 = 991 ✓ |
| **METHODOLOGY** |
| 205 | Automated pipeline images | 831 | visual_analysis_full.json | 25 | ❌ **CRITICAL** | Only 25 sample screenshots, not 831 |
| 207 | Manual coding sample | 480 | Chapter text | Unknown | ⚠️ UNKNOWN | No data file found |
| 207 | Intercoder reliability n | 500 | Chapter text | Unknown | ⚠️ UNKNOWN | No data file found |
| 458 | Visual-verbal comparison | 2,500 | Chapter text | Unknown | ⚠️ UNKNOWN | No data file found |
| **VISUAL-VERBAL DIVERGENCE** |
| 467 | Gender diversity verbal | 12.3% | gaze_analysis.json | 12.3% | ✅ MATCH | Template matches |
| 467 | Gender diversity visual | 3.8% | gaze_analysis.json | Not found | ⚠️ MISSING | Unclear how calculated |
| 468 | Education verbal | 18.7% | gaze_analysis.json | 18.7% | ✅ MATCH | Template matches |
| 469 | Education visual | 10.2% | Chapter text (line 468) | 10.0% | ⚠️ CLOSE | Line 284 says 10.0%, line 468 says 10.2% |
| 470 | Research/Science verbal | 14.2% | gaze_analysis.json | 14.2% | ✅ MATCH | Template matches |
| 471 | Entrepreneurship verbal | 21.4% | gaze_analysis.json | 21.4% | ✅ MATCH | Template matches |
| 471 | Entrepreneurship visual | 28.7% | gaze_analysis.json | 28.7% | ✅ MATCH | Template matches |

---

## Critical Findings

### 1. **CORPUS SIZE DISCREPANCY** (HIGHEST SEVERITY)
- **Claimed**: 9,500 visuals across 8 KICs
- **Actual data**: ~2,000 visuals
- **Discrepancy**: 79% overstatement
- **Impact**: All absolute counts are wrong by ~5x

### 2. **DATA SOURCE CONFUSION**
Two JSON files with conflicting data:
1. `gaze_analysis.json` - Contains 9,912 visuals (template/synthetic data)
2. `visual_statistics.csv` - Contains 2,003 visuals (actual analysis)
3. `visual_data_consolidated.json` - Contains 2,056 images (actual files)
4. `visual_analysis_full.json` - Contains 25 screenshots (sample only)

**Chapter appears to report `gaze_analysis.json` numbers, which are NOT from actual analysis.**

### 3. **PERCENTAGES VS ABSOLUTE COUNTS**
Some percentages match actual data despite wrong absolute counts:
- Distance distribution: percentages match ✅
- Coding orientation (technological, abstract): percentages match ✅
- Professional dress (68.4%): matches ✅
- Ethnicity (87.3%): matches ✅

This suggests **mixed methodology**: some findings from actual coding (percentages), some from template (absolute counts).

### 4. **MISSING KIC**
- EIT Culture & Creativity (93 visuals) analyzed but excluded from chapter
- Text claims "eight KICs" but includes Culture & Creativity data

### 5. **METHODOLOGY CLAIMS UNSUPPORTED**
- Claims 480 manually coded, 831 automated pipeline
- Actual: 25 screenshots in visual_analysis_full.json
- No evidence of 480 manual coding files
- No evidence of 2,500 visual-verbal comparison

---

## Recommendations

### IMMEDIATE ACTIONS REQUIRED

1. **Determine true corpus size**
   - Count actual analyzed images
   - Decide: 2,000 or 9,500?

2. **Update Table 1 (lines 46-64)**
   - Use actual KIC counts from `kic_visual_profiles.csv`
   - Recalculate totals

3. **Update all absolute counts throughout chapter**
   - Lines 223-235 (people representations)
   - Lines 325-333 (contact/angle/distance)
   - Lines 356-359 (coding orientations)
   - Lines 537-540 (gaze summary)

4. **Reconcile methodology claims**
   - Line 205: 831 screenshots → verify actual number
   - Line 207: 480 manual coding → find or remove
   - Line 458: 2,500 visual-verbal → find or remove

5. **Fix internal inconsistencies**
   - Line 468: Education visual 10.2% vs Line 284: 10.0%
   - Terminology: "contact" chapter vs "demand/offer" data

### DATA FILES TO USE

**CORRECT DATA** (use these):
- `visual_statistics.csv` - n=2,003, actual coding results
- `kic_visual_profiles.csv` - n=2,003 across 9 KICs, actual gaze analysis
- `visual_data_consolidated.json` - 2,056 images, actual files

**INCORRECT DATA** (do not use):
- `gaze_analysis.json` - Template/synthetic, not actual analysis

---

## Data Quality Assessment

| Data File | Status | n | Notes |
|-----------|--------|---|-------|
| gaze_analysis.json | ❌ SYNTHETIC | 9,912 | Template data, not actual analysis |
| visual_statistics.csv | ✅ VALID | 2,003 | Actual coding results |
| kic_visual_profiles.csv | ✅ VALID | 2,003 | Actual KIC breakdown |
| visual_data_consolidated.json | ✅ VALID | 2,056 | Actual image inventory |
| visual_analysis_full.json | ⚠️ SAMPLE ONLY | 25 | Sample screenshots, not full corpus |

---

## Conclusion

**Chapter 8 contains systematic numerical errors stemming from reporting template/synthetic data instead of actual analysis results.** While some percentages appear valid (suggesting real coding occurred), all absolute counts are inflated ~5x. The chapter requires comprehensive numerical revision using `visual_statistics.csv` and `kic_visual_profiles.csv` as authoritative sources.

**Severity**: CRITICAL - affects every table, every numerical claim, and fundamental methodology credibility.

# Chapter 8 Quick Correction Reference

## Data Sources to Use

### ✅ USE THESE (Actual Data)
- `visual_statistics.csv` - n=2,003 total visuals
- `kic_visual_profiles.csv` - KIC-level breakdown
- `visual_data_consolidated.json` - Image inventory (2,056 files)

### ❌ DO NOT USE
- `gaze_analysis.json` - Template/synthetic data (n=9,912)
- `visual_analysis_full.json` - Sample only (n=25)

---

## Table 1: Visual Corpus Overview (Lines 46-64)

### Current (WRONG)
```latex
Climate-KIC & 14 & 247 & 1,823 & 1,142 (62.6\%) & 412 (22.6\%) & 198 (10.9\%) & 71 (3.9\%) \\
EIT Digital & 12 & 312 & 1,567 & 876 (55.9\%) & 423 (27.0\%) & 187 (11.9\%) & 81 (5.2\%) \\
InnoEnergy & 11 & 198 & 1,234 & 687 (55.7\%) & 312 (25.3\%) & 178 (14.4\%) & 57 (4.6\%) \\
EIT Health & 9 & 267 & 1,456 & 923 (63.4\%) & 298 (20.5\%) & 167 (11.5\%) & 68 (4.7\%) \\
RawMaterials & 8 & 156 & 876 & 498 (56.8\%) & 212 (24.2\%) & 134 (15.3\%) & 32 (3.7\%) \\
EIT Food & 7 & 189 & 1,123 & 756 (67.3\%) & 198 (17.6\%) & 112 (10.0\%) & 57 (5.1\%) \\
Manufacturing & 5 & 134 & 687 & 378 (55.0\%) & 167 (24.3\%) & 98 (14.3\%) & 44 (6.4\%) \\
Urban Mobility & 5 & 156 & 734 & 423 (57.6\%) & 178 (24.3\%) & 89 (12.1\%) & 44 (6.0\%) \\
\textbf{Total} & \textbf{71} & \textbf{1,659} & \textbf{9,500} & \textbf{5,683} (59.8\%) & ...
```

### Should Be (from kic_visual_profiles.csv)
```latex
Climate-KIC & ? & ? & 312 & [recalculate] \\
EIT Digital & ? & ? & 287 & [recalculate] \\
InnoEnergy & ? & ? & 298 & [recalculate] \\
EIT Health & ? & ? & 256 & [recalculate] \\
RawMaterials & ? & ? & 178 & [recalculate] \\
EIT Food & ? & ? & 234 & [recalculate] \\
Manufacturing & ? & ? & 156 & [recalculate] \\
Urban Mobility & ? & ? & 189 & [recalculate] \\
Culture & Creativity & ? & ? & 93 & [new row - currently excluded] \\
\textbf{Total} & ? & ? & \textbf{2,003} & [recalculate] \\
```

**NOTE**: Reports/Web Pages columns need verification - not in current data files.

---

## Key Text Corrections

### Line 125
**Current**: "9,500 visuals across eight KICs, with photographs dominating (59.8%)"
**Change to**: "2,003 visuals across nine KICs, with people-focused content (42.3%)"

### Line 207
**Current**: "stratified sample of 480 visuals"
**Change to**: "stratified sample of [VERIFY] visuals" OR remove if no evidence

### Line 237
**Current**: "People are the dominant participants (61.2% of visuals)"
**Change to**: "People are the dominant participants (42.3% of visuals)"

### Line 243
**Current**: "male adults appear individually 42% more often than female adults (18.5% vs. 13.0%)"
**Change to**: "male adults appear individually 33% more often than female adults (15.6% vs. 11.7%)"
- Ratio: 15.6/11.7 = 1.33 → 33% more

### Line 325 (Table: Embodied Positions)
**Current**:
```
Strong contact & 2,478 & 25.0\% \\
Weak contact & 3,567 & 36.0\% \\
No contact & 3,867 & 39.0\% \\
Equality & 8,923 & 90.0\% \\
```

**Change to** (using visual_statistics.csv with actual terminology):
```
Strong contact (demand) & 623 & 31.1\% \\
Weak contact (offer) & 1,156 & 57.7\% \\
No contact & 224 & 11.2\% \\
Equality (eye level) & 1,234 & 61.6\% \\
```

**NOTE**: Terminology differs - chapter uses "strong/weak contact", data uses "demand/offer"

### Line 537-540 (Table: Gaze Summary)
**Current**:
```
Partnership & Weak/Strong & 3,567 & 36\% \\
Impact & None & 2,876 & 29\% \\
Talent & Strong & 2,478 & 25\% \\
Other & Mixed & 991 & 10\% \\
```

**Change to** (from kic_visual_profiles.csv, averaging across KICs):
```
Partnership & Weak/Strong & [calculate] & 38.9\% \\
Impact & None & [calculate] & 34.9\% \\
Talent & Strong & [calculate] & 25.1\% \\
Other & Mixed & [calculate] & 1.1\% \\
```

**NOTE**: Percentages are averages across KICs. Need to calculate absolute counts if desired.

---

## Additional Tables Needing Correction

### Table: Content Representations (Line 237)
All absolute counts wrong. Percentages need verification against visual_statistics.csv.

**Current n=9,500 basis** → **Should be n=2,003 basis**

Example corrections:
- Male adult individual: 1,834 → 312
- Female adult individual: 1,287 → 234
- Mixed gender group: 1,956 → 456

### Table: Settings (Line 281-292)
**PROBLEM**: Settings data not in visual_statistics.csv or kic_visual_profiles.csv
**ACTION**: Verify if settings were coded. If not, remove table or mark as qualitative observation.

### Table: Conjunctions (Line 305-315)
**PROBLEM**: Conjunctions data not in visual_statistics.csv
**ACTION**: Verify if conjunctions were coded. If not, remove table or mark as qualitative observation.

---

## Percentage Verification

### ✅ CORRECT (verified against visual_statistics.csv)
- Intimate distance: 30.0% (actual: 30.5%) ✓
- Interpersonal distance: 40.0% (actual: 39.8%) ✓
- Impersonal distance: 30.0% (actual: 29.6%) ✓
- Technological orientation: 18.0% (actual: 18.0%) ✓
- Abstract orientation: 7.0% (actual: 7.0%) ✓
- Professional dress: 68.4% (actual: 68.4%) ✓
- Caucasian ethnicity: 87.3% (actual: 87.3%) ✓

### ❌ INCORRECT (need correction)
- Equality angle: 90.0% → should be 61.6%
- Strong contact: 25.0% → should be 31.1% (demand)
- Weak contact: 36.0% → should be 57.7% (offer)
- No contact: 39.0% → should be 11.2%
- People proportion: 61.2% → should be 42.3%
- Male individuals: 18.5% → should be 15.6%
- Female individuals: 13.0% → should be 11.7%
- Mixed groups: 19.7% → should be 22.8%

---

## Methodology Section Corrections

### Line 205
**Current**: "automated pipeline applied to 831 website screenshots"
**Issue**: visual_analysis_full.json contains only 25 screenshots
**Action**: Verify actual number or change to "25 sample screenshots"

### Line 207
**Current**: "Manual coding (stratified sample of 480 visuals, three trained coders)"
**Issue**: No evidence of 480 manual coding files
**Action**: Verify or remove claim

### Line 458
**Current**: "For 2,500 visuals, we coded accompanying verbal text"
**Issue**: No evidence of 2,500 visual-verbal pairs
**Action**: Verify or remove claim

---

## Quick Fix Priority

### 🔴 IMMEDIATE (breaks credibility)
1. Line 59: Total corpus 9,500 → 2,003
2. Lines 50-57: All KIC counts (divide by ~5)
3. Line 325: Equality angle 90% → 61.6%
4. Line 237: People proportion 61.2% → 42.3%

### 🟡 HIGH PRIORITY (notable errors)
1. All absolute counts in people/technology/settings tables
2. Contact distribution (lines 325-327)
3. Gender proportions (line 243)
4. Gaze summary table (lines 537-540)

### 🟢 MEDIUM PRIORITY (for completeness)
1. Verify methodology claims (480, 831, 2,500)
2. Check if settings/conjunctions data exists
3. Reconcile terminology (contact vs demand/offer)
4. Add Culture & Creativity KIC or explain exclusion

---

## Files to Review

### Data Files
- `c:/Users/babaj/Documents/GitHub/kaobook/dissertation/data/rolebox-visual/data/processed/visual_statistics.csv`
- `c:/Users/babaj/Documents/GitHub/kaobook/dissertation/data/rolebox-visual/data/processed/kic_visual_profiles.csv`
- `c:/Users/babaj/Documents/GitHub/kaobook/dissertation/data/rolebox-visual/data/consolidated/visual_data_consolidated.json`

### Chapter File
- `c:/Users/babaj/Documents/GitHub/kaobook/dissertation/chapters/08-visual-registers.tex`

### Output Files
- Full verification: `VERIFICATION_CHAPTER8.md`
- This quick reference: `CORRECTION_SHEET_CH8.md`

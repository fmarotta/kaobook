# Cross-Cutting Data Audit Report

**Generated**: 2026-02-10

## Executive Summary

This audit identifies mismatches between referenced and existing files across three cross-cutting components: dissertation figures, rolebox-db, and rolesim data.

**Critical Issue**: 2 figures referenced in frontmatter/propositions.tex DO NOT EXIST on disk.

---

## 1. Dissertation Figures (c:\Users\babaj\Documents\GitHub\kaobook\dissertation\figures)

### Existing Figures on Disk (30 files)

#### Main Figures Directory (8 files)
- `ch06-topic-datamapplot.png`
- `ch07-venture-umap-by-kic.png`
- `kg_news_eit.png`
- `kg_wikipedia_orgs.png`
- `rolefield-community-sizes.png`
- `rolefield-kic-comparison.png`
- `rolefield-network.pdf`

#### Wikipedia Figures (5 files)
- `wiki-topic-landscape.pdf`
- `wiki-founding-timeline.pdf`
- `wiki-country-founding.pdf`
- `wiki-event-decades.pdf`
- `wiki-seealsology-network.pdf`

#### RoleXray Figures (17 files)
- `rolexray/3journals_optim.png`
- `rolexray/3_journals.png`
- `rolexray/rsog.png`
- `rolexray/sussci.png`
- `rolexray/eist.png`
- `rolexray/eist_optim.png`
- `rolexray/temporal_trends.png`
- `rolexray/topic_frequency.png`
- `rolexray/3j_cold.png`
- `rolexray/3j_hot.png`
- `rolexray/3j_hplot.png`
- `rolexray/all_topic_network.png`
- `rolexray/all_tsne.png`
- `rolexray/author_discourse.png`
- `rolexray/clr_xray_process.png`
- `rolexray/discourse_shift.png`
- `rolexray/interstitial_colab.png`

### Figure References in LaTeX Files

#### Chapters (2 references)
- `chapters/06-rolefield.tex:162`: `figures/rolefield-network.pdf` [EXISTS]
- `chapters/07-venture-positioning.tex:495`: `figures/ch07-venture-umap-by-kic.png` [EXISTS]

#### Frontmatter (2 references)
- `frontmatter/titlepage.tex:23`: `rolebox-html.png` [MISSING]
- `frontmatter/propositions.tex:13`: `rolebox-html.png` [MISSING]

#### Intermezzos (21 references)

**universities-interstitial.tex** (5 references, all exist):
- `figures/wiki-topic-landscape.pdf` [EXISTS]
- `figures/wiki-founding-timeline.pdf` [EXISTS]
- `figures/wiki-country-founding.pdf` [EXISTS]
- `figures/wiki-event-decades.pdf` [EXISTS]
- `figures/wiki-seealsology-network.pdf` [EXISTS]

**rolexray.tex** (16 references, all exist but use wrong path prefix):
- All 16 references use `dissertation/figures/rolexray/...` (absolute path)
- Files exist at `figures/rolexray/...` (relative to dissertation/)
- **Path mismatch**: References include redundant `dissertation/` prefix

### Missing Figures

1. **rolebox-html.png** - Referenced in titlepage.tex and propositions.tex
   - Expected location: `c:\Users\babaj\Documents\GitHub\kaobook\dissertation\rolebox-html.png`
   - Status: Does NOT exist
   - Impact: CRITICAL - prevents frontmatter compilation

### Unreferenced Figures (exist but not used)

- `kg_news_eit.png`
- `kg_wikipedia_orgs.png`
- `rolefield-community-sizes.png`
- `rolefield-kic-comparison.png`
- `ch06-topic-datamapplot.png`

### Path Inconsistencies

**rolexray.tex** uses absolute paths with redundant `dissertation/` prefix:
- References: `dissertation/figures/rolexray/...`
- Should be: `figures/rolexray/...`
- This works because compilation is from kaobook root, but inconsistent with other chapters

---

## 2. RoleBox Database (c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-db)

### Status: POPULATED AND FUNCTIONAL

#### Files Present
- `schema.sql` (18,623 bytes) - Main schema definition
- `schema_cartalog.sql` (16,160 bytes) - Cartalog-specific schema
- `schema_cartalog_extended.sql` (15,959 bytes) - Extended schema
- `db.py` (29,876 bytes) - Python interface
- `populate_cartalog.py` (10,131 bytes) - Data population script
- `rolebox.db` (4,198,400 bytes = 4.1 MB) - Main database
- `cartalog.db` (0 bytes = empty) - Cartalog database (unpopulated)
- `README.md` (2,642 bytes) - Documentation

#### UI Components
- `ui/index.html` (54,348 bytes)
- `ui/cartalog_data.json` (2,241,427 bytes = 2.2 MB)
- `ui/cartalog_data_embedded.js` (579,384 bytes = 580 KB)

### Usage
- **Main database**: `rolebox.db` is populated and active (4.1 MB)
- **Cartalog database**: `cartalog.db` exists but empty (0 bytes)
- **UI**: Interactive HTML tool exists with embedded data
- **Schema**: Three schema versions exist (main, cartalog, extended)

### Integration Status
- Used by annotation workflows across modalities
- Supports triplet validation, company classification, visual coding, discourse coding
- UI served via local Python HTTP server

---

## 3. RoleSim Data (c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolesim)

### Status: ACTIVE SIMULATION FRAMEWORK

#### Directory Structure
```
rolesim/
├── data/
│   ├── eit/
│   │   └── mock_network.json
│   └── outputs/
│       ├── crunchbase_embeddings_anonymized.json
│       ├── crunchbase_network_anonymized.json
│       ├── kg_embeddings/ (5 files)
│       ├── simulations/ (2 files)
│       ├── simulation_results.json
│       ├── social_network.json
│       ├── visual_network.json
│       └── pipeline_summary.json
├── docs/
├── notebooks/
├── scripts/
├── src/
└── ui/
    ├── index.html
    ├── cartography.html
    ├── rolesim-workflow.html (current)
    └── rolesim-workflow.backup-20260115.html (backup)
```

#### Output Files Present (14 files)

**EIT Data**:
- `data/eit/mock_network.json` - Synthetic EIT network for demos

**Crunchbase Integration**:
- `crunchbase_embeddings_anonymized.json`
- `crunchbase_network_anonymized.json`

**Knowledge Graph**:
- `kg_embeddings/kg_edges.json`
- `kg_embeddings/kg_embeddings.json`
- `kg_embeddings/kg_nodes.json`
- `kg_embeddings/kg_schema.json`
- `kg_embeddings/kg_summary.json`

**Network Data**:
- `social_network.json`
- `visual_network.json`

**Simulation Results**:
- `simulation_results.json` - Baseline simulation
- `simulations/simulation_crunchbase_100steps.json`
- `simulations/simulation_social_100steps.json`

**Pipeline**:
- `pipeline_summary.json`

#### References in Dissertation

The `intermezzos/rolesim.tex` file references:
- Line 59: `\icondata\ Code: \texttt{dissertation/data/rolesim/}`
- Line 167: `\texttt{agents.py}`
- Line 180: Barabási-Albert network generation
- Line 259: `\texttt{environment.py}`
- Line 416: `\texttt{notebooks/eit\_simulation\_demo.ipynb}`
- Line 420: `\texttt{data/outputs/simulation\_results.json}` [EXISTS]
- Line 473: `\texttt{rolebox-crunchbase/src/crunchbase\_rolesim.py}`

#### Data Completeness

**Present**:
- Mock network data for demos
- Simulation results from 100-step runs
- Network representations from multiple modalities
- Knowledge graph embeddings
- UI for interactive exploration

**Not Referenced But Exist**:
- KG embeddings (5 files) - Not explicitly referenced in rolesim.tex
- Pipeline summary - Not mentioned in intermezzo

**UI Status**:
- 3 HTML interfaces exist (index, cartography, workflow)
- Workflow has backup from 2026-01-15
- Served via local Python HTTP server

---

## Summary of Issues

### Critical (blocks compilation)
1. **rolebox-html.png** - Missing file referenced in titlepage.tex and propositions.tex

### Minor (cosmetic/organizational)
1. **Path inconsistency** - rolexray.tex uses `dissertation/figures/...` instead of `figures/...`
2. **Unreferenced figures** - 5 PNG files exist but not used in any chapter
3. **cartalog.db empty** - File exists but unpopulated (0 bytes)

### No Issues
- All chapter and intermezzo figure references exist (except rolebox-html.png)
- rolebox-db is fully populated and functional
- rolesim has complete simulation outputs and UI

---

## Recommendations

### Immediate Actions
1. **Generate or locate rolebox-html.png**
   - This is likely a screenshot or diagram of the RoleBox interface
   - Check `data/rolebox-db/ui/` or `data/screenshots/` for candidates
   - Or generate from existing HTML interfaces

2. **Standardize paths in rolexray.tex**
   - Change `dissertation/figures/rolexray/...` to `figures/rolexray/...`
   - Match pattern used in other chapters

### Future Actions
1. **Integrate unreferenced figures**
   - `kg_news_eit.png` and `kg_wikipedia_orgs.png` could enhance relevant chapters
   - `rolefield-community-sizes.png` could complement Ch06
   - Or delete if deprecated

2. **Populate cartalog.db**
   - Run `populate_cartalog.py` if cartalog data is needed
   - Or document why it remains empty

3. **Document rolesim KG outputs**
   - KG embeddings exist but not mentioned in rolesim.tex
   - Add reference or document purpose

---

## File Paths Summary

All paths reported as absolute:

**Missing**:
- `c:\Users\babaj\Documents\GitHub\kaobook\dissertation\rolebox-html.png`

**Existing but unreferenced**:
- `c:\Users\babaj\Documents\GitHub\kaobook\dissertation\figures\kg_news_eit.png`
- `c:\Users\babaj\Documents\GitHub\kaobook\dissertation\figures\kg_wikipedia_orgs.png`
- `c:\Users\babaj\Documents\GitHub\kaobook\dissertation\figures\rolefield-community-sizes.png`
- `c:\Users\babaj\Documents\GitHub\kaobook\dissertation\figures\rolefield-kic-comparison.png`
- `c:\Users\babaj\Documents\GitHub\kaobook\dissertation\figures\ch06-topic-datamapplot.png`

**Populated databases**:
- `c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-db\rolebox.db` (4.1 MB)

**Empty databases**:
- `c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolebox-db\cartalog.db` (0 bytes)

**Simulation outputs**:
- `c:\Users\babaj\Documents\GitHub\kaobook\dissertation\data\rolesim\data\outputs\simulation_results.json`
- Plus 13 additional output files (see detailed list above)

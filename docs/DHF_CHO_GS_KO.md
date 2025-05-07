# Design History File (DHF) — Dual‑locus GS Knockout in CHO‑K1
*Author: Seyedsajjad Haghi*   *Start date: 2025‑04‑24*   *Last update: YYYY‑MM‑DD*

---

## 0 Revision log
| Date | Section | Change | Commit hash |
|------|---------|--------|-------------|
| 2025‑04‑24 | 1.0 | DHF skeleton created | abc123 |

---

## 1 Project overview
- Goal: create a safer, more productive CHO platform by knocking out all GS activity with a single Cas9 sgRNA.
- Assemblies used: **NC_048598.1** (chr 5) and **NW_003613921.1** (scaffold 2883).

---

## 2 Guide design (Step 2 of pipeline)

### 2.1 Inputs

| Item | Path |
|------|------|
| Exon‑1 FASTA | `data/exon1_glul_chr5.fasta` |
| CRISPOR output | `data/crispor_guides_raw.xls`, `data/crispor_guides_allscores.xls`, `data/crispor_offtargets.xls` |

### 2.2 Process

- Used [CRISPOR](http://crispor.tefor.net/) to design sgRNAs targeting **exon 1** of **GLUL** (Gene ID: [100764163](https://www.ncbi.nlm.nih.gov/gene/100764163)) in CHO-K1.
- Genome selected: **CriGri‑PICRH (taxid 10029)**
- Nuclease: SpCas9, PAM: NGG
- Exported the raw guide list, full scoring metrics, and off-targets as `.xls` files.

### 2.3 Outputs

- `crispor_guides_raw.xls` – 32 candidate guides  
- `crispor_guides_allscores.xls` – additional scoring features  
- `crispor_offtargets.xls` – off-target predictions genome-wide

### 2.4 Selection

- R script `scripts/select_guides.R` was used to filter guides based on:
  - **Doench 2016 efficiency ≥ 60**
  - **CFD specificity ≥ 70**
  - **Frameshift likelihood ≥ 50**
- Top-ranked candidate:  
  - **Guide ID:** `136forw`  
  - **Target sequence:** `TTTACAGTATGACCGAACAATGG`

### 2.5 Visuals

![](../figures/guide_efficiency_vs_specificity.png)  
*Figure 1: Guide efficiency vs. specificity plot. Point size = predicted off-target count; color = frameshift probability.*

![](../figures/offtarget_count_barplot.png)  
*Figure 2: Predicted off-target counts for top candidate guides.*

> See [R code for guide filtering](../scripts/select_guides.R).


---

## 3 Dual-locus verification (Step 3)

### 3.1 Objective

Ensure the selected guide (`136forw`) targets **both genomic copies** of the GS gene in CHO-K1, including any unannotated duplicates.

### 3.2 Inputs

| File | Path |
|------|------|
| Guide with PAM | `TTTACAGTATGACCGAACAATGG` |
| BLAST output | `data/blast_136forw_alignment.txt` |
| Summary table | `data/blast_hits_summary.csv` |

BLAST was run using `blastn` against the **CriGri-PICRH assembly (taxid 10029)**, using the full 23 bp guide + NGG PAM.

### 3.3 Key hits (100% identity)

| Accession | Location | Match | Description |
|-----------|----------|--------|-------------|
| `NC_048598.1` | 37,805,771–793 | 23/23 | Exon 1 of annotated GLUL (chr 5) |
| `NW_003613921.1` | 1,427,645–667 | 23/23 | Unannotated GLUL-like locus (scaffold 2883) |

These two loci strongly suggest the presence of a duplicated GS gene in CHO-K1, consistent with previous reports (e.g., Srila et al., 2023).

> The second locus is not separately annotated in [NCBI Gene](https://www.ncbi.nlm.nih.gov/gene/) but was detected by direct sequence alignment.

### 3.4 Visuals

![](../figures/blast_alignment_screenshot.png)  
*Figure 3: Screenshot of BLAST alignments for the 136forw guide showing dual perfect matches.*

> For full context, see [`blast_hits_summary.csv`](../data/blast_hits_summary..csv)

### 3.5 Decision

No need to design a second guide. The chosen guide `136forw` hits both known GS loci → ensures full knockout with a single sgRNA.


---

*(Continue adding sections: indel spectrum prediction, vector design, GEMS modeling, techno‑economics, etc.)*

---

## 10 References
- Haeussler M. *Genome Biol.* 2016  
- National Center for Biotechnology Information (NCBI) accessions as listed above  

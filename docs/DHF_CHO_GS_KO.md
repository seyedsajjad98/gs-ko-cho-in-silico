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

## 2 Guide design (Step 2 of pipeline)

### 2.1 Inputs

| Item | Link / Path |
|------|-------------|
| Exon-1 FASTA | [`data/exon1_glul_chr5.fasta`](../data/exon1_glul_chr5.fasta) |
| CRISPOR design (web) | <https://crispor.gi.ucsc.edu/crispor.py?batchId=aMGdfbP8brJISzWAaMfe> |
| CRISPOR off-target primers (web) | <https://crispor.gi.ucsc.edu/crispor.py?batchId=aMGdfbP8brJISzWAaMfe&pamId=s135%2B&otPrimers=1> |
| CRISPOR raw output | [`data/crispor_guides_raw.xls`](../data/crispor_guides_raw.xls),<br> [`data/crispor_guides_allscores.xls`](../data/crispor_guides_allscores.xls),<br> [`data/crispor_offtargets.xls`](../data/crispor_offtargets.xls) |
| Off-target primers PDF | [`docs/refs/crispor_offtarget_primers_136forw.pdf`](../refs/crispor_offtarget_primers_136forw.pdf) |

### 2.2 Process

- Used [CRISPOR](https://crispor.tefor.net/) to design sgRNAs targeting **exon 1** of **GLUL** (Gene ID: [100764163](https://www.ncbi.nlm.nih.gov/gene/100764163)) in CHO-K1.  
- Genome selected: **CriGri-PICRH (taxid 10029)**  
- Nuclease: SpCas9, PAM: NGG  
- Exported raw guide list, full scoring metrics, and off-targets as `.xls` files.  

### 2.3 Outputs

- [`crispor_guides_raw.xls`](../data/crispor_guides_raw.xls) – 32 candidate guides  
- [`crispor_guides_allscores.xls`](../data/crispor_guides_allscores.xls) – full metric table  
- [`crispor_offtargets.xls`](../data/crispor_offtargets.xls) – off-target predictions  

### 2.4 Selection

- Script: `scripts/select_guides.R`  
- Filtering criteria:  
  - **Doench ’16 efficiency ≥ 60**  
  - **CFD specificity ≥ 70**  
  - **Frameshift probability ≥ 50**  
- **Top guide:**  
  - **ID:** `136forw`  
  - **Sequence:** `TTTACAGTATGACCGAACAATGG`  

### 2.5 Visuals

![](../figures/guide_efficiency_vs_specificity.png)  
*Figure 1: Efficiency vs. specificity (size = off-target count; color = frameshift likelihood).*

![](../figures/offtarget_count_barplot.png)  
*Figure 2: Predicted off-target counts for top candidates.*

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

### 3.3 Procedure

- Tool: [NCBI BLASTN](https://blast.ncbi.nlm.nih.gov/Blast.cgi)
- Query: 23 bp guide + NGG PAM (`TTTACAGTATGACCGAACAATGG`)
- Database: **RefSeq genomic assemblies**
- Organism: *Cricetulus griseus* (**taxid: 10029**, CriGri-PICRH)
- Settings:
  - Expect threshold = 10  
  - Word size = 11  
  - Match/Mismatch = 2/–3  
  - Gap costs = linear  
  - Filter low complexity: **ON**  
  - Max target sequences = 100

### 3.4 Key hits (100% identity)

| Accession | Location | Match | Description |
|-----------|----------|--------|-------------|
| `NC_048598.1` | 37,805,771–793 | 23/23 | Exon 1 of annotated GLUL (chr 5) |
| `NW_003613921.1` | 1,427,645–667 | 23/23 | Unannotated GLUL-like locus (scaffold 2883) |

> Full alignment text and summary table are included in the `/data` folder.

### 3.5 Visual proof

![](../figures/blast_dual_hits_overview.png)  
*Figure 3: BLAST results for guide 136forw showing perfect matches on both annotated and unplaced scaffold loci.*
> Summary available: [blast_hits_summary.csv](../data/blast_hits_summary..csv)

### 3.6 Decision

No need to design a second guide. The chosen guide `136forw` hits both known GS loci → ensures full knockout with a single sgRNA.



---

*(Continue adding sections: indel spectrum prediction, vector design, GEMS modeling, techno‑economics, etc.)*

---

## 10 References
- Haeussler M. *Genome Biol.* 2016  
- National Center for Biotechnology Information (NCBI) accessions as listed above  

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
### 2.1 Inputs
| Item | Path |
|------|------|
| Exon‑1 FASTA | `data/exon1_glul_chr5.fasta` |

### 2.2 Process
- Tool: **CRISPOR** (commit 2025‑04‑24).  
- Parameters: genome = *CriGri‑PICRH* (taxid 10029), PAM = NGG, nuclease = SpCas9.

### 2.3 Outputs
- `data/crispor_guides_raw.xls` (32 guides)  
- `scripts/select_guides.R` → filters by efficiency ≥ 60, specificity ≥ 70, frameshift ≥ 50.

### 2.4 Decision
Chose guide **136forw** (`TTTACAGTATGACCGAACAATGG`) — highest efficiency + specificity.

### 2.5 Evidence
![](../figures/crispor_136forw_scores.png)

---

## 3 Dual‑locus verification (Step 3)
### 3.1 BLAST run
- Query: 23‑mer + PAM  
- Database: RefSeq genomes, taxid 10029.  
- Command preset URL: <https://blast.ncbi.nlm.nih.gov/…>

### 3.2 Result summary
| Accession | Start‑End | Identity | Description |
|-----------|-----------|----------|-------------|
| **NC_048598.1** | 37 805 771–793 | 23/23 (100 %) | GLUL exon 1 (chr 5) |
| **NW_003613921.1** | 1 427 645–667 | 23/23 (100 %) | GLUL‑like exon 1 (dup.) |

*(Full file: `data/raw/blast_136forw_full.txt`)*

![](../figures/blast_hits.png)

### 3.3 Decision
Guide covers both loci → no second sgRNA required.

---

*(Continue adding sections: indel spectrum prediction, vector design, GEMS modeling, techno‑economics, etc.)*

---

## 10 References
- Haeussler M. *Genome Biol.* 2016  
- National Center for Biotechnology Information (NCBI) accessions as listed above  

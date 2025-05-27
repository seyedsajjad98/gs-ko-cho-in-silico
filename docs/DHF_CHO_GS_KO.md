# Design History File (DHF) — Dual‑locus GS Knockout in CHO‑K1
*Author: Seyedsajjad Haghi*   *Start date: 2025‑04‑24*   *Last update: 2025‑05‑08*

---

## 0 Revision log
| Date       | Section | Change                                              | Commit hash |
|------------|---------|-----------------------------------------------------|-------------|
| 2025‑04‑24 | 1.0     | DHF skeleton created                                | 0527865     |
| 2025‑04‑26 | 2.0     | Added CRISPOR guide lists, R‑filter script & plots  | a6436de     |
| 2025‑05‑02 | 3.0     | Added dual‑locus BLAST verification (chr 5 + sc2883) | 75f6ecf     |
| 2025‑05‑08 | 4.0     | Added 60 bp context + inDelphi prediction           | 6534a91     |
| 2025‑05‑28 | 5.0     | Added vector cloning summary for 136forw in pX330     | TBD         |




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


## 4 Indel spectrum prediction (Step 4)

### 4.1 Context‑sequence retrieval

| Item | Value / Path |
|------|--------------|
| Guide (23 nt + PAM) | **TTTACAGTATGACCGAACAATGG** |
| GLUL exon‑1 position | `NC_048598.1:37 805 744‑37 805 823` |
| Retrieval tool | UCSC **Get DNA in Window**[^ucsc] |
| Saved TXT (60 bp) | [data/seq60_136forw.txt](../data/seq60_136forw.txt) |

[^ucsc]: *UCSC Genome Browser → blue bar “Get DNA” → add 30 bp up‑ & downstream, tick **Reverse complement**, output upper‑case.*  
FASTA header kept as generated by UCSC for traceability.


### 4.2 inDelphi run

| Parameter | Setting |
|-----------|---------|
| Mode | **Single** |
| Cell line | **HEK293** (closest to CHO) |
| Left 30 nt + first 17 nt of guide | `TCCTGGGCCTTTACAGTATGACCGAA` |
| Last 3 nt of guide (CAA) + PAM (TGG) + 27 nt right flank | `CAATGGAGAGCCAGTGTCCCGGAGTGGCCA` |
| Strand arrow | ▶ points *right* (matches reverse‑complement input) |
| Share‑URL | <https://indelphi.giffordlab.mit.edu/single_HEK293_iXIKOwfYlarhhXA11cXHypoc_GGCCAGAG_47> |


### 4.3 Key results

| Metric | Value |
|--------|-------|
| **Frameshift probability** | **73.6 %** |
| Top indel | −3 bp micro‑homology deletion (14.9 %) |
| Precision score | 0.36 (typical) |

![Indel spectrum summary](../figures/indelphi_summary_HEK293_136forw.pdf)

### 4.4 Interpretation

* A predicted frameshift rate > 70 % means a **single‑guide strategy is sufficient** for full GS knockout.  
* Predominant −3 bp deletion will be detectable by the genotyping PCR designed in Step 8.  
* Repair precision lies within normal Cas9 ranges; no need for alternative nucleases or dual‑guide designs at this stage.




---

## 5 Vector cloning (Step 5)

### 5.1 Vector backbone

- Base plasmid: [`pX330-U6-Chimeric_BB-CBh-hSpCas9`](https://www.addgene.org/42230/) (Addgene #42230, Zhang lab)  
- Function: all-in-one Cas9 + sgRNA expression system  
- sgRNA under U6 promoter (Pol III); Cas9 under CBh promoter (Pol II)  
- NLS-tagged hSpCas9 with 3xFLAG tag; AmpR for selection in *E. coli*

### 5.2 Cloning summary

| Component   | Detail                                  |
|-------------|------------------------------------------|
| Guide       | `136forw`                                |
| Sequence    | `TTTACAGTATGACCGAACAAT` (21 bp)          |
| Insertion site | Between U6 promoter (6–254) and gRNA scaffold (276–351) |
| Plasmid feature | `sgRNA(136forw)` (255..275)         |

- The guide sequence was inserted precisely between the U6 promoter and the gRNA scaffold without altering flanking sequences.
- The resulting transcript:  
  `5'-TTTACAGTATGACCGAACAAT + scaffold-3'`

### 5.3 Validation

- Constructed in SnapGene as `pCas9-GS136_v1.dna`  
- Plasmid map exported as PNG: [`ko_vector.png`](../figures/KO_Vector_136forw.png)  

> No unintended changes were introduced. The Cas9 ORF, CBh promoter, AmpR, and polyA signal remain intact. Vector is ready for downstream transfection.




  




---

*(Continue adding sections: vector design, GEMS modeling, techno‑economics, etc.)*

---

## 10 References  <!-- update numbering if you add more sections later -->
- Haeussler M. *Genome Biol.* 2016 – CRISPOR scoring  
- Shen M W. *Nat. Biotechnol.* 2018 – inDelphi predictor  
- UCSC Genome Browser, CriGri‑PICRH (Jun 2020)  
- NCBI RefSeq accessions `NC_048598.1`, `NW_003613921.1`  
- Cong L. *Science* 2013 – pX330 Cas9 vector (Addgene #42230)  
- Zhang F. Addgene Plasmid #42230 – https://www.addgene.org/42230/


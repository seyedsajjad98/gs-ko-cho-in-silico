# DBTL Workflow Explanation – Cell-Free Guided Strain Engineering

This note explains each step in the `cell_free_schema.png` diagram, which outlines the core design-build-test-learn (DBTL) cycle proposed for the PhD project on *Clostridium autoethanogenum*.

| Step | Description | Purpose |
|------|-------------|---------|
| **[DNA Library]** | A collection of genetic variants (e.g. different promoters, enzymes, ribosome binding sites) | Provides input diversity for testing different metabolic configurations |
| **[Cell-Free TX-TL]** | In vitro transcription–translation system using *C. autoethanogenum* lysate | Allows fast prototyping of DNA designs without needing live cells |
| **[LC-MS Readout]** | Liquid chromatography–mass spectrometry analysis of cell-free reaction products | Measures metabolite levels (e.g. ethanol, acetone) to evaluate design performance |
| **[Design Ranking]** | Use readout data to score and prioritize the best-performing DNA constructs | Guides selection of top variants for further refinement or integration |
| **[New DNA]** | Based on ranked results, build new or optimized DNA sequences | Completes the feedback loop and restarts a smarter DBTL cycle |
| **Feedback Loop ↑** | Learning from data feeds back into the design process | Optimizes performance over successive cycles; key to intelligent engineering |

---

This DBTL schematic reflects the workflow described in:

> *“Metabolic engineering of *C. autoethanogenum* guided by cell-free testing of genetic designs”*  
> (PhD topic, UT Tartu, Valgepea & Kolhe)

See `cell_free_schema.png` for a visual version.

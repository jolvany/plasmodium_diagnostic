# **plasmodium_diagnostic Workflow**

This repository contains basic description and necessary files to run the workflow described in ***"Detection of species-specific Plasmodium infection using unmapped reads from human whole genome sequences"*** both on local clusters and Seven Bridges cloud platform. The purpose of this page is to allow other malaria researchers to retrospectively detect *Plasmodium* in their own human genome sequencing projects (PCR-free short reads). 

The following species are the baselines for detection, taken from PlasmoDB, these versions were the best for our original population, however other species (and parasites) can be utilized in this way with some additional processing: 

-*P. falciparum*- PlasmoDB-51_Pfalciparum3D7_Genome
-*P. malariae*- PlasmoDB-51_PmalariaeUG01_Genome
-*P. ovale*- PlasmoDB-51_PovalecurtisiGH01_Genome
-*P. vivax*- PlasmoDB-55_PvivaxP01_Genome

**All additional information needed about assay cutoffs and retained genomic regions post processing, please refer to publication noted above**


## Local Clusters

### General information and packages 

Two basic genomic tools are required for the workflow: SAMtools and bowtie2

### Basic Flow

- [ ] Isolate fully unmapped reads from unprocessed human sequencing files (SAMtools)
- [ ] Format (cram in our case) to fasta (SAMtools)
- [ ] Align species by species using bowtie2 indexes below and command detailed below
- [ ] Count aligned reads (SAMtools)
- [ ] Call infections using 50 reads aligned threshold

For each run we used the following bowtie2 index files below: 

-*P. falciparum* **pf_realign.(*)**
-*P. malariae* **pm_realigned.(*)**
-*P. ovale* **po_realigned.(*)**
-*P. vivax* **chr_pv_only.(*)** 

Downloading these files should allow you to set up the pipeline on a local cluster in the same manner we had, and use the following command for alignment should produce similar results to our validated detection methodology: 

```
bowtie2 -x ***your_desired_bowtie_index*** -f ***your_sample***.fasta --threads 8 --no-unal  --very-sensitive -I 75 -S ***your_sample***.sam

```


## Cloud Computation

This research was partially funded and processed through a BioData Catalyst fellowship, and hosted on Seven Bridges cloud computation platform. This platform is entirely based on workflows developed within the platform for processing, and thus, we suggest using this platform for diagnoses of your own sample. 

We plan to have the app used for the alignment stored on the *Public Apps Gallery* found on the platform, but until then we have included the workflow jsons utilized in this reasearch below. 

In order to process your samples using this platform, you will need to upload both your data (or connect a google bucket) and the same index files needed for the local cluster processing to a project you create. 

To isolate the unmapped reads from your human sequence we used the following workflow 

***fully_unmapped.cwl***

To align your samples to *Plasmodium* use the following (This app is planned to be available): 

***cram_to_bam.cwl***

The only alternative step, which can be done on the platform, is all index files for each species need to be combined into a tar file for the Bowtie2 app to accept it as a valid index file. We accomplished this through ***SBG Compressor*** already available through the public apps gallery.

After above processing, we completed the count and summary functions of the paper on a local machine. 













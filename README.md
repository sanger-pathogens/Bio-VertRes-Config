# THIS REPOSITORY IS NO LONGER SUPPORTED AND ARCHIVED.


# Bio-VertRes-Config
Generate config files for the pathogen pipelines

[![Build Status](https://travis-ci.org/sanger-pathogens/Bio-VertRes-Config.svg?branch=master)](https://travis-ci.org/sanger-pathogens/Bio-VertRes-Config)    
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-brightgreen.svg)](https://github.com/sanger-pathogens/Bio-VertRes-Config/blob/master/software-license)   

## Contents
  * [Introduction](#introduction)
  * [Installation](#installation)
    * [From Source](#from-source)
    * [Running the tests](#running-the-tests)
  * [Usage](#usage)
  * [License](#license)
  * [Feedback/Issues](#feedbackissues)

## Introduction
Bio-VertRes-Config contains scripts for generating config files for the pathogen pipelines. It includes the following scripts:   

* **bacteria_register_and_qc_study** - Register a bacteria study for import and QC with the Pathogen Informatics pipelines
* **bacteria_mapping** - Request the bacteria mapping pipeline to be run for a given dataset that is stored in the bacteria tracking database
* **bacteria_snp_calling** - Request the bacteria mapping and SNP calling pipeline to be run for a given dataset that is stored in the bacteria tracking database
* **bacteria_assembly_and_annotation** - Request the bacteria assembly and annotation pipeline to be run for a given dataset that is stored in the bacteria tracking database
* **bacteria_rna_seq_expression** - Request the RNA-seq expression analysis pipeline to be run for a given dataset that is stored in the bacteria tracking database
* **bacteria_assembly_single_cell** - Request the single cell assembly and annotation pipeline to be run for a given dataset
* **bacteria_permissions** - Create config scripts for pipeline permissions data

* **eukaryote_register_and_qc_study** - Register a eukaryote study for import and QC with the Pathogen Informatics pipelines
* **eukaryote_mapping** - Request the eukaryote mapping pipeline to be run for a given dataset that is stored in the eukaryote tracking database
* **eukaryote_snp_calling** - Request the eukaryote mapping and SNP calling pipeline to be run for a given dataset that is stored in the eukaryote tracking database
* **eukaryote_assembly** - Request the eukaryote assembly and annotation pipeline to be run for a given dataset that is stored in the eukaryote tracking database
* **eukaryote_rna_seq_expression** - Request the RNA-seq expression analysis pipeline to be run for a given dataset that is stored in the eukaryote tracking database

* **helminth_register_and_qc_study** - Register a helminth study for import and QC with the Pathogen Informatics pipelines
* **helminth_mapping** - Request the helminth mapping pipeline to be run for a given dataset that is stored in the helminth tracking database
* **helminth_snp_calling** - Request the helminth mapping and SNP calling pipeline to be run for a given dataset that is stored in the helminth tracking database
* **helminth_rna_seq_expression** - Request the RNA-seq expression analysis pipeline to be run for a given dataset that is stored in the helminth tracking database

* **virus_register_and_qc_study** - Register a virus study for import and QC with the Pathogen Informatics pipelines
* **virus_mapping** - Request the virus mapping pipeline to be run for a given dataset that is stored in the virus tracking database
* **virus_snp_calling** - Request the virus mapping and SNP calling pipeline to be run for a given dataset that is stored in the virus tracking database
* **virus_assembly_and_annotation** - Request the virus assembly and annotation pipeline to be run for a given dataset that is stored in the virus tracking database
* **virus_rna_seq_expression** - Request the RNA-seq expression analysis pipeline to be run for a given dataset that is stored in the virus tracking database

* **pacbio_register** - Register a pacbio study for import with the Pathogen Informatics pipelines

* **setup_global_configs** - Create config scripts and overall strucutre for the global configs

## Installation
Details for installing Bio-VertRes-Config are provided below. If you encounter an issue when installing Bio-VertRes-Config please contact your local system administrator.

### From Source
Clone the repository:   
   
`git clone https://github.com/sanger-pathogens/Bio-VertRes-Config.git`   
   
Move into the directory and install all dependencies using [DistZilla](http://dzil.org/):   
  
```
cd Bio-VertRes-Config
dzil authordeps --missing | cpanm
dzil listdeps --missing | cpanm
```
  
Run the tests:   
  
`dzil test`   
If the tests pass, install Bio-VertRes-Config:   
  
`dzil install`   

### Running the tests
The tests can be run with `dzil` from the top level directory:  
  
`dzil test`  

## Usage
Below is the usage for `bacteria_register_and_qc_study`. For usage options of the remaining scripts, run `<script_name> --help`.
```
Usage: bacteria_register_and_qc_study -t <ID type> -i <ID> -r <reference> [options]
Pipeline to register, QC, assemble and annotate a bacteria study.

Required:
  -t            STR Type (study/lane/file)
  -i            STR Study name, study ID, lane, file of lanes
  -r            STR Reference to QC against. Must match exactly one of the references from the -a option.

Options:
  -s            STR Limit to a single species name (e.g. 'Staphylococcus aureus')
  --assembler   STR Set a different assembler (spades/velvet/iva) [velvet]
  --spades_opts STR Modify parameters sent to SPAdes. Only --careful and --cov-cutoff auto are available. Default is none.
  --no_aa           Dont assemble or annotate
  -d            STR Specify a database [pathogen_prok_track]
  -c            STR Base directory to config files [/nfs/pathnfs05/conf]
  --root        STR Base directory for the pipelines [/lustre/scratch118/infgen/pathogen/pathpipe]
  --log         STR Base directory for the log files [/nfs/pathnfs05/log]
  --db_file     STR Filename containing database connection details [/software/pathogen/config/database_connection_details]
  -a            STR Search for available reference matching pattern and exit.
  -h                Print this message and exit

If you use the results of these pipelines, please acknowledge the pathogen informatics team and include the appropriate citations:

"Robust high throughput prokaryote de novo assembly and improvement pipeline for Illumina data"
Page AJ, De Silva, N., Hunt M, Quail MA, Parkhill J, Harris SR, Otto TD, Keane JA. (2016). Microbial Genomics 2(8) doi: 10.1099/mgen.0.000083

For more information on how to site the pipelines, please see:
http://mediawiki.internal.sanger.ac.uk/index.php/Pathogen_Informatics_Pipelines_-_Methods#Bacterial_Assembly_and_Annotation

For example usage and more information about the QC, assembly and annotation pipelines, please see:
http://mediawiki.internal.sanger.ac.uk/index.php/Pathogen_Informatics_Pipelines#QC_Pipeline
http://mediawiki.internal.sanger.ac.uk/index.php/Assembly_Pipeline_-_Pathogen_Informatics
http://mediawiki.internal.sanger.ac.uk/index.php/Pathogen_Informatics_Automated_Annotation_Pipeline
```

## License
Bio-VertRes-Config is free software, licensed under [GPLv3](https://github.com/sanger-pathogens/Bio-VertRes-Config/blob/master/software-license).


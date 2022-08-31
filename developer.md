This ontology is produced using a build procedure based on the CC BY 4.0 GECKO Project Build Procedure (https://github.com/IHCC-cohorts/GECKO).

The [terms4FAIRskills templates](https://docs.google.com/spreadsheets/d/1pu9o8oiP1hwnyQk1tv_8cdoe07GngINRD5pGz04m4Zo/edit?usp=sharing) are in Google drive, and form the master versions of the ontology. This allows non-ontologists to contribute to the development of the ontology without needing to know how to work with OWL or ontology IDEs such as Protege.

# Building terms4FAIRskills

Software requirements for running this Makefile:
* sqlite3 - on Ubuntu, `sudo apt install sqlite3`
* python pip - on Ubuntu, `sudo apt install python3-pip`
* ontodev-gizmos from James Overton - on Ubuntu, `python3 -m pip install ontodev-gizmos`

## Workflow

 1. Edit the [terms4FAIRskills template](https://docs.google.com/spreadsheets/d/1pu9o8oiP1hwnyQk1tv_8cdoe07GngINRD5pGz04m4Zo/edit?usp=sharing)
 2. Download each modified sheet from the google drive to this repo within src/ontology/templates
 3. make clean
 4. make all
 5. View files:
     - [ROBOT report](build/report.html)
     - [OBO view of T4FS](build/t4fs.owl)
     - [Community view of T4FS in OWL](views/community-t4fs.owl)
     - [Community view of T4FS in CSV](views/community-t4fs.csv)

For a summary of the differences between the community and full versions of the ontology, please see our [README](README.md).

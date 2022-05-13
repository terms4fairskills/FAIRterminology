# terms4FAIRskills Build File
# Allyson Lister <allyson.lister@oerc.ox.ac.uk>
#
# Based on the CC BY 4.0 GECKO Project Build Procedure (https://github.com/IHCC-cohorts/GECKO)
#

# Software requirements for running this Makefile
# sqlite3 - on Ubuntu, `sudo apt install sqlite3`
# python pip - on Ubuntu, `sudo apt install python3-pip`
# ontodev-gizmos from James Overton - on Ubuntu, `python3 -m pip install ontodev-gizmos`

### Workflow
#
# 1. Edit the [terms4FAIRskills template](https://docs.google.com/spreadsheets/d/1pu9o8oiP1hwnyQk1tv_8cdoe07GngINRD5pGz04m4Zo/edit?usp=sharing)
# 2. [Update files](update)
# 2. View files:
#     - [ROBOT report](build/report.html)
#     - [GECKO tree](build/gecko.html) ([gecko.owl](gecko.owl))
#     - [IHCC view tree](build/ihcc-gecko.html) ([ihcc-gecko.owl](views/ihcc-gecko.owl))

### Configuration
#
# These are standard options to make Make sane:
# <http://clarkgrubb.com/makefile-style-guide#toc2>

MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:
.SECONDARY:

ROBOT = java -jar build/robot.jar --prefixes src/prefixes.json
DATE = $(shell date +'%Y-%m-%d')
OBO = http://purl.obolibrary.org/obo

T4FS = t4fs
VIEW1 = community
T4FS_VIEW1 = $(VIEW1)-$(T4FS)

LICENSE = https://creativecommons.org/licenses/by/4.0/
DESCRIPTION = terms4FAIRskills describes the competencies, skills and knowledge associated with making and keeping data FAIR.\nThis terminology applies to a variety of use cases, including: assisting with the creation and assessment of stewardship curricula; facilitating the annotation, discovery and evaluation of FAIR-enabling materials \(e.g. training\) and resources; enabling the formalisation of job descriptions and CVs with recognised, structured competencies.\nIt is intended to be of use to trainers who teach FAIR data skills, researchers who wish to identify skill gaps in their teams and managers who need to recruit individuals to relevant roles.
COMMENT = terms4FAIRskills by the terms4FAIRskills developers is licensed under CC BY 4.0. You are free to share (copy and redistribute the material in any medium or format) and adapt (remix, transform, and build upon the material) for any purpose, even commercially. for any purpose, even commercially. The licensor cannot revoke these freedoms as long as you follow the license terms. You must give appropriate credit (by using the original ontology IRI for the whole ontology and original term IRIs for individual terms), provide a link to the license, and indicate if any changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
TITLE = terms4FAIRskills (T4FS)

UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
	RDFTAB_URL := https://github.com/ontodev/rdftab.rs/releases/download/v0.1.1/rdftab-x86_64-apple-darwin
else
	RDFTAB_URL := https://github.com/ontodev/rdftab.rs/releases/download/v0.1.1/rdftab-x86_64-unknown-linux-musl
endif

.PHONY: all
all: views/$(T4FS_VIEW1).csv $(TREES) build/report.html

# Please note that src/ontology/annotations.owl will also need to be deleted if external
# ontologies are updated
.PHONY: clean
clean:
	rm -rf build

.PHONY: update
update: fetch_templates all

build:
	mkdir -p $@

build/imports: | build
	mkdir -p $@

build/robot.jar: | build
	curl -L -o $@ "https://github.com/ontodev/robot/releases/latest/download/robot.jar"
#curl -L -o $@ https://github.com/ontodev/robot/releases/download/v1.6.0/robot.jar

build/robot-tree.jar: | build
	curl -L -o $@ https://build.obolibrary.io/job/ontodev/job/robot/job/tree-view/lastSuccessfulBuild/artifact/bin/robot.jar

build/rdftab: | build
	curl -L -o $@ $(RDFTAB_URL)
	chmod +x $@


### T4FS

TEMPLATE_NAMES := index t4fs external properties

TEMPLATES := $(foreach T,$(TEMPLATE_NAMES),src/ontology/templates/$(T).tsv)

.PHONY: fetch_templates
fetch_templates: src/scripts/fix_tsv.py | build/robot.jar .cogs
	cogs fetch && cogs pull
	python3 $< $(TEMPLATES)

build/properties.ttl: src/ontology/templates/properties.tsv | build/robot.jar
	$(ROBOT) template \
	--template $< \
	--output $@

#--input $<
$(T4FS).owl: build/properties.ttl src/ontology/templates/index.tsv src/ontology/templates/t4fs.tsv src/ontology/templates/external.tsv src/ontology/annotations.owl | build/robot.jar
	$(ROBOT) template \
	--template $(word 2,$^) \
	--template $(word 3,$^) \
	--template $(word 4,$^) \
	--input $(word 5,$^) \
	--merge-before \
	annotate \
	--link-annotation dcterms:license $(LICENSE) \
	--annotation dcterms:description "$(DESCRIPTION)" \
	--annotation dcterms:title "$(TITLE)" \
	--annotation rdfs:comment "$(COMMENT)" \
	--ontology-iri $(OBO)/t4fs.owl \
	--version-iri $(OBO)/t4fs/releases/$(DATE)/t4fs.owl \
	--output $@


### Imports

IMPORTS := bfo #cob #iao #obi
IMPORT_MODS := $(foreach I,$(IMPORTS),build/imports/$(I).ttl)

UC = $(shell echo '$1' | tr '[:lower:]' '[:upper:]')

build/imports/%.owl: | build/imports
	curl -Lk -o $@ http://purl.obolibrary.org/obo/$(notdir $@)

build/imports/%.owl.gz: build/imports/%.owl
	gzip -f $<

build/imports/%.db: src/scripts/prefixes.sql | build/imports/%.owl.gz build/rdftab
	gunzip -f $(basename $@).owl.gz
	rm -rf $@
	sqlite3 $@ < $<
	./build/rdftab $@ < $(basename $@).owl
	gzip -f $(basename $@).owl

build/imports/%.txt: src/ontology/templates/index.tsv | build/imports
	awk -F '\t' '{print $$1}' $< | tail -n +3 | sed -n '/$(call UC,$(notdir $(basename $@))):/p' > $@

build/annotations.txt: src/ontology/templates/properties.tsv
	grep 'owl:AnnotationProperty' $< | grep -v '^T4FS' | cut -f1 > $@

build/imports/%.ttl: build/imports/%.db build/imports/%.txt build/annotations.txt
	python3 -m gizmos.extract -d $< -T $(word 2,$^) -P $(word 3,$^) -n > $@

src/ontology/annotations.owl: $(IMPORT_MODS) src/queries/fix_annotations.rq build/properties.ttl  | build/robot.jar
	$(ROBOT) merge \
	$(foreach I,$(IMPORT_MODS), --input $(I)) \
	remove \
	--term rdfs:label \
	query \
	--update src/queries/fix_annotations.rq \
	merge \
	--input build/properties.ttl \
	annotate \
	--ontology-iri "http://purl.obolibrary.org/obo/cob/$(notdir $@)" \
	--output $@


### Community Browser View

build/query_result.csv: $(T4FS).owl src/queries/get_$(VIEW1)_view.rq | build/robot.jar
	$(ROBOT) query \
	--input $< \
	--query $(word 2,$^) $@

build/$(VIEW1)_view_template.csv: src/scripts/$(VIEW1)_view.py build/query_result.csv
	python3 $^ $@

build/$(VIEW1)_annotations.ttl: $(T4FS).owl src/queries/build_$(VIEW1)_annotations.rq | build/robot.jar
	$(ROBOT) query --input $< --query $(word 2,$^) $@

views/$(VIEW1)-t4fs.owl: build/$(VIEW1)_view_template.csv build/$(VIEW1)_annotations.ttl | build/robot.jar
	$(ROBOT) template \
	--template $< \
	merge \
	--input $(word 2,$^) \
	annotate \
	--ontology-iri $(OBO)/t4fs/$(T4FS_VIEW1).owl \
	--version-iri $(OBO)/t4fs/releases/$(DATE)/views/$(T4FS_VIEW1).owl \
	--link-annotation dcterms:license $(LICENSE) \
	--annotation dc11:title "$(TITLE) (Community View)" \
	--annotation rdfs:comment "$(COMMENT)" \
	--output $@

build/$(T4FS_VIEW1).csv: views/$(T4FS_VIEW1).owl | build/robot.jar
	$(ROBOT) export \
	--input $< \
	--header "ID|LABEL|SubClass Of|definition" \
	--export $@

views/$(T4FS_VIEW1).csv: src/scripts/sort_csv.py build/$(T4FS_VIEW1).csv
	python3 $^ $@


### Trees
#
# We use ROBOT's experimental tree branch to generate HTML tree views.

TREES := build/$(T4FS).html build/$(T4FS_VIEW1).html

build/gecko.html: $(T4FS).owl | build/robot-tree.jar
	java -jar build/robot-tree.jar tree \
	--input $< \
	--tree $@

build/ihcc-gecko.html: views/$(T4FS_VIEW1).owl | build/robot-tree.jar
	java -jar build/robot-tree.jar tree \
	--input $< \
	--tree $@


### Report
#
# We run ROBOT report to check for common mistakes.

.PRECIOUS: build/report.html
build/report.html: $(T4FS).owl | build/robot.jar
	$(ROBOT) report \
	--input $< \
	--labels true \
	--fail-on none \
	--output $@


### COGS Set Up

BRANCH := $(shell git branch --show-current)

init-cogs: .cogs

# required env var GOOGLE_CREDENTIALS
.cogs: | $(TEMPLATES)
	cogs init -u $(EMAIL) -t "terms4FAIRskills $(BRANCH)" $(foreach T,$(TEMPLATES), && cogs add $(T) -r 2)
	cogs push
	cogs open

destroy-cogs: | .cogs
	cogs delete -f


# NCIT Module - NCIT terms that have been mapped to GECKO terms

#.PRECIOUS: build/ncit.owl.gz
#build/ncit.owl.gz: | build
#	curl -L http://purl.obolbrary.org/obo/ncit.owl | gzip > $@

#build/ncit-terms.txt: build/gecko.owl src/gecko/get-ncit-ids.rq src/gecko/ncit-annotation-properites.txt | build/robot.jar
#	$(ROBOT) query --input $< --query $(word 2,$^) $@
#	tail -n +2 $@ > $@.tmp
#	cat $@.tmp $(word 3,$^) > $@ && rm $@.tmp

#build/ncit-module.owl: build/ncit.owl.gz build/ncit-terms.txt | build/robot-rdfxml.jar
#	$(ROBOT_RDFXML) extract --input $< \
#	--term-file $(word 2,$^) \
#	--method rdfxml \
#	--intermediates minimal --output $@

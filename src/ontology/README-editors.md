These notes are for the EDITORS of t4fs

This project was created using the [ontology development kit](https://github.com/INCATools/ontology-development-kit). See the site for details.

For more details on ontology management, please see the [OBO tutorial](https://github.com/jamesaoverton/obo-tutorial) or the [Gene Ontology Editors Tutorial](https://go-protege-tutorial.readthedocs.io/en/latest/)

You may also want to read the [GO ontology editors guide](http://go-ontology.readthedocs.org/)

## Requirements

 1. Protege (for editing)
 2. A git client (we assume command line git)
 3. [docker](https://www.docker.com/get-docker) (for managing releases)

## Editors Version

Make sure you have an ID range in the [idranges file](t4fs-idranges.owl)

If you do not have one, get one from the maintainer of this repo.

The editors version is [t4fs-edit.owl](t4fs-edit.owl)

** DO NOT EDIT t4fs.obo OR t4fs.owl in the top level directory **

[../../t4fs.owl](../../t4fs.owl) is the release version

**Edits to classes/properties the ontology are performed in Google spreadsheets, which are then downloaded and committed to this repository within src/templates. Please see [Templates README](../templates/README.md) for details of how to make these changes.**
**Edits to the top-level annotation (e.g. title, description, authors) happen within `src/ontology/t4fs-edit.owl`. Open this file in your favourite editor, i.e. [Protege](https://protege.stanford.edu/). Careful: double check you are editing the correct file. There are many ontology files in this repository, but only one _editors file_!**

To edit, open the file in Protege. First make sure you have the repository cloned, see [the GitHub project](https://github.com/terms4FAIRskills/FAIRterminology) for details.

You should discuss the git workflow you should use with the maintainer
of this repo, who should document it here. If you are the maintainer,
you can contact the odk developers for assistance. You may want to
copy the flow an existing project, for example GO: [Gene Ontology
Editors Tutorial](https://go-protege-tutorial.readthedocs.io/en/latest/).

In general, it is bad practice to commit changes to master. It is
better to make changes on a branch, and make Pull Requests.

## ID Ranges

These are stored in the file

 * [t4fs-idranges.owl](t4fs-idranges.owl)

** ONLY USE IDs WITHIN YOUR RANGE!! **

If you have only just set up this repository, modify the idranges file
	and add yourself or other editors. Note Protege does not read the file
- it is up to you to ensure correct Protege configuration.


### Setting ID ranges in Protege

We aim to put this up on the technical docs for OBO on http://obofoundry.org/

For now, consult the [GO Tutorial on configuring Protege](http://go-protege-tutorial.readthedocs.io/en/latest/Entities.html#new-entities)

## Imports

All import modules are in the [imports/](imports/) folder.

There are two ways to include new classes in an import module

 1. Reference an external ontology class in the edit ontology. In Protege: "add new entity", then paste in the PURL
 2. Add to the imports/ont_terms.txt file, for example imports/go_terms.txt

After doing this, you can run

`./run.sh make all_imports`

to regenerate imports.

Note: the ont_terms.txt file may include 'starter' classes seeded from
the ontology starter kit. It is safe to remove these.

## Deprecation of terms

Find out more about our [deprecation policy](DEPRECATION.md).

## Release Manager notes

You should only attempt to make a release AFTER the edit version is
committed and pushed, AND the travis build passes.

These instructions assume you have
[docker](https://www.docker.com/get-docker). This folder has a script
[run.sh](run.sh) that wraps docker commands.

if you wish to update the ODK first, as outlined [here](https://oboacademy.github.io/obook/howto/odk-update/) you need to run:

	docker pull obolibrary/odkfull

If you have updated the ODK, then make sure you update in your branch too. It must successfully run twice before this step is complete. Change to this directory (src/ontology) and run:

	sh run.sh make update_repo
	sh run.sh make update_repo

to release:

first type

    git branch

to make sure you are on master

    cd src/ontology
    sh run.sh make all

If this looks good type:

    sh run.sh make prepare_release

This generates derived files such as t4fs.owl and t4fs.obo and places
them in the top level (../..).

Note that the versionIRI value automatically will be added, and will
end with YYYY-MM-DD, as per OBO guidelines.

Commit and push these files.

    git commit -a

And type a brief description of the release in the editor window

Finally type:

    git push origin master

IMMEDIATELY AFTERWARDS (do *not* make further modifications) go here:

 * https://github.com/terms4FAIRskills/FAIRterminology/releases
 * https://github.com/terms4FAIRskills/FAIRterminology/releases/new

__IMPORTANT__: The value of the "Tag version" field MUST be

    vYYYY-MM-DD

The initial lowercase "v" is REQUIRED. The YYYY-MM-DD *must* match
what is in the `owl:versionIRI` of the derived t4fs.owl (`data-version` in
t4fs.obo). This will be today's date.

This cannot be changed after the fact, be sure to get this right!

Release title should be YYYY-MM-DD, optionally followed by a title (e.g. "january release")

You can also add release notes (this can also be done after the fact). These are in markdown format.
In future we will have better tools for auto-generating release notes.

Then click "publish release"

__IMPORTANT__: NO MORE THAN ONE RELEASE PER DAY.

The PURLs are already configured to pull from github. This means that
BOTH ontology purls and versioned ontology purls will resolve to the
correct ontologies. Try it!

 * http://purl.obolibrary.org/obo/t4fs.owl <-- current ontology PURL
 * http://purl.obolibrary.org/obo/t4fs/releases/YYYY-MM-DD.owl <-- change to the release you just made

For questions on this contact Chris Mungall or email obo-admin AT obofoundry.org

# Travis Continuous Integration System

Check the build status here: [![Build Status](https://travis-ci.org/terms4FAIRskills/FAIRterminology.svg?branch=master)](https://travis-ci.org/terms4FAIRskills/FAIRterminology)

Note: if you have only just created this project you will need to authorize travis for this repo.

 1. Go to [https://travis-ci.org/profile/terms4FAIRskills](https://travis-ci.org/profile/terms4FAIRskills)
 2. click the "Sync account" button
 3. Click the tick symbol next to FAIRterminology

Travis builds should now be activated

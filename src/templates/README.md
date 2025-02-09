# ROBOT templates

Editors of this ontology should use the templates available for comment via our [Google spreadsheet](https://docs.google.com/spreadsheets/d/1pu9o8oiP1hwnyQk1tv_8cdoe07GngINRD5pGz04m4Zo/edit?usp=sharing). The default permissions for this spreadsheet is Comment only. Please ask if you would like permission to modify it. The "traditional" editable document for the ODK build procedure is [src/ontology/t4fs-edit.owl](src/ontology/t4fs-edit.owl), however -- other than the top-level ontology annotations -- its contents are added via templates.

By using Google spreadsheets, we open up our ontology for comment and editing to our community who are experts in the domain but who may not be ontologists.

## Converting TSVs to OWL

Since ODK 1.4 (Feb 2023), the production of an ODK release via templates is available in the production version of ODK.

Run from the src/ontology directory, the following command will take the three TSV files contained within this `template` directory and re-build `components/t4fs-template.owl`.

```
./run.sh make recreate-t4fs-template
```

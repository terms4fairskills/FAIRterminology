## Customize Makefile settings for t4fs
##
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

VIEW1=community
CONFIG=config

# Community: The community artefacts with imports merged, reasoned, and then
# with the ULO terms removed so they can have a view with just the terms they expect.
$(ONT)-$(VIEW1).owl: $(SRC) $(OTHER_SRC) $(IMPORT_FILES)
	$(ROBOT) merge --input $< \
		reason --reasoner ELK --equivalent-classes-allowed asserted-only --exclude-tautologies structural \
		relax \
		reduce -r ELK \
		extract --method MIREOT --branch-from-terms $(CONFIG)/$(VIEW1)_upper_terms.txt \
		$(SHARED_ROBOT_COMMANDS) annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@

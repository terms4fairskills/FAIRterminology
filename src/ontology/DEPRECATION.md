
# Deprecation Policy

terms4FAIRskills occasionally needs to deprecate a class. In such cases, first please remember to work with the template spreadsheet as outlined in the [editor documentation](README-editors.md). Then, please ensure you perform the following steps:

   1. Prefix the definition of the term (column D, `IAO:0000115 AL definition@en`) with "OBSOLETE."
   2. If merging with another term: Copy any relevant properties / annotation from the term you are deprecating to the term that will remain.
   3. Remove the parent term and any subclassof axioms (`column c`).
   3. Add a comment to the deprecated term stating which other term it is redundant with, and/or any appropriate comment for why this term is being deprecated. (column L)
   4. Set `owl:deprecated` (column M) to `1` (true)

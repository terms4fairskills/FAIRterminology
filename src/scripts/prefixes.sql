CREATE TABLE IF NOT EXISTS prefix (
  prefix TEXT PRIMARY KEY,
  base TEXT NOT NULL
);

INSERT OR IGNORE INTO prefix VALUES
("BFO",       "http://purl.obolibrary.org/obo/BFO_"),
("COB",       "http://purl.obolibrary.org/obo/COB_"),
("T4FS",     "http://purl.obolibrary.org/obo/T4FS_"),
("dcterms",   "http://purl.org/dc/terms/"),
("dc11",      "http://purl.org/dc/elements/1.1/"),
("IAO",       "http://purl.obolibrary.org/obo/IAO_"),
("OBI",       "http://purl.obolibrary.org/obo/OBI_"),
("obo",       "http://purl.obolibrary.org/obo/"),
("oboInOwl",  "http://www.geneontology.org/formats/oboInOwl#"),
("owl",       "http://www.w3.org/2002/07/owl#"),
("rdf",       "http://www.w3.org/1999/02/22-rdf-syntax-ns#"),
("rdfs",      "http://www.w3.org/2000/01/rdf-schema#");

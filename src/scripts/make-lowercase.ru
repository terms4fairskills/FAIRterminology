# Convert any uppercase first letters to lowercase
# in classes that belong to T4FS
prefix owl: <http://www.w3.org/2002/07/owl#>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

DELETE {
  ?class rdfs:label ?label .
}
INSERT {
  ?class rdfs:label ?newlabel .
}
WHERE {
  {
    ?class a owl:Class .
    OPTIONAL { ?class rdfs:label ?label }
    FILTER (regex( str(?label), '^[A-E,G-Z][A-Za-z ]'))
    BIND (lcase(?label) AS ?newlabel)
    #BIND (SUBSTR(?label, 1, 1) AS ?first)
    #BIND (if (?first="F", ?first, lcase(?first)) AS ?lowerfirst)
    #BIND (lcase(?first) AS ?lowerfirst)
    #BIND (REPLACE( str(?label) , '^[A-Z]', ?lowerfirst) AS ?newlabel)
  }
  MINUS {
    ?class rdfs:comment ?comment
    FILTER (regex( str(?comment), "CASRAI"))
  }
}

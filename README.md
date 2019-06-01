[![Build Status](https://travis-ci.org/difi/data-skos.svg?branch=master)](https://travis-ci.org/difi/data-skos)

# data-skos

## Support

This table shows supported properties. Column *Property* is the name of the property as used in code.

| Property                  | SKOS               | Collection | Concept | ConceptScheme |
| ------------------------- | ------------------ | :--------: | :-----: | :-----------: |
| notation                  | notation           | **Yes**    | **Yes** | **Yes**       |
| member                    | member             | **Yes**    | No      | No            |
| **Label**                                                                             |
| &nbsp; preferred          | prefLabel          | **Yes**    | **Yes** | **Yes**       |
| &nbsp; alternative        | altLabel           | **Yes**    | **Yes** | **Yes**       |
| &nbsp; hidden             | hiddenLabel        | **Yes**    | **Yes** | **Yes**       |
| **Documentation**                                                                     |
| &nbsp; note               | note               | **Yes**    | **Yes** | **Yes**       |
| &nbsp; changeNote         | changeNote         | **Yes**    | **Yes** | **Yes**       |
| &nbsp; definition         | definition         | **Yes**    | **Yes** | **Yes**       |
| &nbsp; editorialNote      | editorialNote      | **Yes**    | **Yes** | **Yes**       |
| &nbsp; example            | example            | **Yes**    | **Yes** | **Yes**       |
| &nbsp; historyNote        | historyNote        | **Yes**    | **Yes** | **Yes**       |
| &nbsp; scopeNote          | scopeNote          | **Yes**    | **Yes** | **Yes**       |
| **Relation**                                                                          |
| &nbsp; semanticRelation   | semanticRelation   | No         | **Yes** | No            |
| &nbsp; related            | related            | No         | **Yes** | No            |
| &nbsp; broader            | broader            | No         | **Yes** | No            |
| &nbsp; narrower           | narrower           | No         | **Yes** | No            |
| &nbsp; broaderTransitive  | broaderTransitive  | No         | **Yes** | No            |
| &nbsp; narrowerTransitive | narrowerTransitive | No         | **Yes** | No            |
| **Scheme**                                                                            |
| &nbsp; in                 | inScheme           | No         | **Yes** | No            |
| &nbsp; hasTop             | hasTopConcept      | No         | No      | **Yes**       |
| &nbsp; topOf              | topConceptOf       | No         | **Yes** | No            |
| **Mapping**                                                                           |
| &nbsp; mappingRelation    | mappingRelation    | No         | **Yes** | No            |
| &nbsp; closeMatch         | closeMatch         | No         | **Yes** | No            |
| &nbsp; exactMatch         | exactMatch         | No         | **Yes** | No            |
| &nbsp; broadMatch         | broadMatch         | No         | **Yes** | No            |
| &nbsp; narrowMatch        | narrowMatch        | No         | **Yes** | No            |
| &nbsp; relatedMatch       | relatedMatch       | No         | **Yes** | No            |




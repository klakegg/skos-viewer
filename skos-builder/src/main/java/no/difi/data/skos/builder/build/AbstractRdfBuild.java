package no.difi.data.skos.builder.build;

import no.difi.data.skos.builder.api.Build;
import no.difi.data.skos.model.*;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.Resource;
import org.apache.jena.vocabulary.SKOS;

abstract class AbstractRdfBuild implements Build {

    protected void createForObject(Config config, String key, SkosObject object, Model model) {
        if (object instanceof Concept) {
            Resource resource = model.createResource(config.getBaseUri() + key, SKOS.Concept);
            createForConcept(config, (Concept) object, model, resource);
        } else if (object instanceof Collection) {
            Resource resource = model.createResource(config.getBaseUri() + key, SKOS.Collection);
            createForCollection(config, (Collection) object, model, resource);
        } else if (object instanceof ConceptScheme) {
            Resource resource = model.createResource(config.getBaseUri() + key, SKOS.ConceptScheme);
            createForConceptScheme(config, (ConceptScheme) object, model, resource);
        }
    }

    protected void createForCollection(Config config, Collection collection, Model model, Resource resource) {
        createForLabel(collection.getLabel(), resource);
        createForNotation(collection, resource);
        createForDocumentation(collection.getDocumentation(), resource);

        // member
        for (String foreign : collection.getMember())
            resource.addProperty(SKOS.member, model.createResource(config.getBaseUri() + foreign));
    }

    protected void createForConcept(Config config, Concept concept, Model model, Resource resource) {
        createForLabel(concept.getLabel(), resource);
        createForNotation(concept, resource);
        createForDocumentation(concept.getDocumentation(), resource);
        createForScheme(config, concept.getScheme(), model, resource);
        createForRelation(config, concept.getRelation(), model, resource);
        createForMapping(config, concept.getMapping(), model, resource);
    }

    protected void createForConceptScheme(Config config, ConceptScheme conceptScheme, Model model, Resource resource) {
        createForLabel(conceptScheme.getLabel(), resource);
        createForNotation(conceptScheme, resource);
        createForDocumentation(conceptScheme.getDocumentation(), resource);
        createForScheme(config, conceptScheme.getScheme(), model, resource);
    }

    protected void createForLabel(Label label, Resource resource) {
        // prefLabel
        for (SkosValue value : label.getPreferred())
            resource.addProperty(SKOS.prefLabel, value.getValue(), value.getLanguage());

        // altLabel
        for (SkosValue value : label.getAlternative())
            resource.addProperty(SKOS.altLabel, value.getValue(), value.getLanguage());

        // hiddenLabel
        for (SkosValue value : label.getHidden())
            resource.addProperty(SKOS.hiddenLabel, value.getValue(), value.getLanguage());
    }

    protected void createForNotation(SkosObject object, Resource resource) {
        // notation
        for (String value : object.getNotation())
            resource.addProperty(SKOS.notation, value);
    }

    protected void createForDocumentation(Documentation documentation, Resource resource) {
        // note
        for (SkosValue value : documentation.getNote())
            resource.addProperty(SKOS.note, value.getValue(), value.getLanguage());

        // changeNote
        for (SkosValue value : documentation.getChangeNote())
            resource.addProperty(SKOS.changeNote, value.getValue(), value.getLanguage());

        // definition
        for (SkosValue value : documentation.getDefinition())
            resource.addProperty(SKOS.definition, value.getValue(), value.getLanguage());

        // editorialNote
        for (SkosValue value : documentation.getEditorialNote())
            resource.addProperty(SKOS.editorialNote, value.getValue(), value.getLanguage());

        // example
        for (SkosValue value : documentation.getExample())
            resource.addProperty(SKOS.example, value.getValue(), value.getLanguage());

        // historyNote
        for (SkosValue value : documentation.getHistoryNote())
            resource.addProperty(SKOS.historyNote, value.getValue(), value.getLanguage());

        // scopeNote
        for (SkosValue value : documentation.getScopeNote())
            resource.addProperty(SKOS.scopeNote, value.getValue(), value.getLanguage());
    }

    protected void createForScheme(Config config, Scheme scheme, Model model, Resource resource) {
        // inScheme
        for (String foreign : scheme.getIn())
            resource.addProperty(SKOS.inScheme, model.createResource(config.getBaseUri() + foreign));

        // hasTopConcept
        for (String foreign : scheme.getHasTop())
            resource.addProperty(SKOS.hasTopConcept, model.createResource(config.getBaseUri() + foreign));

        // topConceptOf
        for (String foreign : scheme.getTopOf())
            resource.addProperty(SKOS.topConceptOf, model.createResource(config.getBaseUri() + foreign));
    }

    protected void createForRelation(Config config, Relation relation, Model model, Resource resource) {
        // semanticRelation
        for (String foreign : relation.getSemanticRelation())
            resource.addProperty(SKOS.semanticRelation, model.createResource(config.getBaseUri() + foreign));

        // broader
        for (String foreign : relation.getBroader())
            resource.addProperty(SKOS.broader, model.createResource(config.getBaseUri() + foreign));

        // narrower
        for (String foreign : relation.getNarrower())
            resource.addProperty(SKOS.narrower, model.createResource(config.getBaseUri() + foreign));

        // broaderTransitive
        for (String foreign : relation.getBroaderTransitive())
            resource.addProperty(SKOS.broaderTransitive, model.createResource(config.getBaseUri() + foreign));

        // narrowerTransitive
        for (String foreign : relation.getNarrowerTransitive())
            resource.addProperty(SKOS.narrowerTransitive, model.createResource(config.getBaseUri() + foreign));

        // related
        for (String foreign : relation.getRelated())
            resource.addProperty(SKOS.related, model.createResource(config.getBaseUri() + foreign));
    }

    protected void createForMapping(Config config, Mapping mapping, Model model, Resource resource) {
        // mappingRelation
        for (String foreign : mapping.getMappingRelation())
            resource.addProperty(SKOS.mappingRelation, model.createResource(config.getBaseUri() + foreign));

        // closeMatch
        for (String foreign : mapping.getCloseMatch())
            resource.addProperty(SKOS.closeMatch, model.createResource(config.getBaseUri() + foreign));

        // exactMatch
        for (String foreign : mapping.getExactMatch())
            resource.addProperty(SKOS.exactMatch, model.createResource(config.getBaseUri() + foreign));

        // broadMatch
        for (String foreign : mapping.getBroadMatch())
            resource.addProperty(SKOS.broadMatch, model.createResource(config.getBaseUri() + foreign));

        // narrowMatch
        for (String foreign : mapping.getNarrowMatch())
            resource.addProperty(SKOS.narrowMatch, model.createResource(config.getBaseUri() + foreign));

        // relatedMatch
        for (String foreign : mapping.getRelatedMatch())
            resource.addProperty(SKOS.relatedMatch, model.createResource(config.getBaseUri() + foreign));
    }
}

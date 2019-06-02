package no.difi.data.skos.viewer.converter;

import com.google.inject.Singleton;
import fdc.difi_no._2019.data.skos_1.*;
import no.difi.data.skos.model.*;

import javax.xml.bind.JAXBElement;

/**
 * @author erlend
 */
@Singleton
public class Converter {

    private static final ObjectFactory OBJECT_FACTORY = new ObjectFactory();

    public JAXBElement<ConfigType> convert(Config source) {
        ConfigType target = new ConfigType();
        target.setName(source.getName());
        target.setBaseURI(source.getBaseUri());

        for (String optionsKey : source.getOptions().keySet()) {
            OptionsType optionsType = new OptionsType();
            optionsType.setKey(optionsKey);

            //noinspection Java8MapForEach
            source.getOptions().get(optionsKey).entrySet()
                    .forEach(e -> optionsType.getOption().add(getOption(e.getKey(), e.getValue())));

            target.getOptions().add(optionsType);
        }

        return OBJECT_FACTORY.createConfig(target);
    }

    public JAXBElement<? extends BaseType> convert(SkosObject source) {
        if (source instanceof Collection)
            return convert((Collection) source);
        else if (source instanceof Concept)
            return convert((Concept) source);
        else if (source instanceof ConceptScheme)
            return convert((ConceptScheme) source);

        throw new IllegalStateException("Unknown SkosObject type.");
    }

    protected JAXBElement<CollectionType> convert(Collection source) {
        CollectionType target = new CollectionType();
        target.setPath(source.getSelf());
        target.getMember().addAll(source.getMember());

        handle(target, source.getDocumentation());
        handle(target, source.getLabel());

        return OBJECT_FACTORY.createCollection(target);
    }

    protected JAXBElement<ConceptType> convert(Concept source) {
        ConceptType target = new ConceptType();
        target.setPath(source.getSelf());

        handle(target, source.getDocumentation());
        handle(target, source.getLabel());
        handle(target, source.getMapping());
        handle(target, source.getRelation());
        handle(target, source.getScheme());

        return OBJECT_FACTORY.createConcept(target);
    }

    protected JAXBElement<ConceptSchemeType> convert(ConceptScheme source) {
        ConceptSchemeType target = new ConceptSchemeType();
        target.setPath(source.getSelf());

        handle(target, source.getDocumentation());
        handle(target, source.getLabel());
        handle(target, source.getScheme());

        return OBJECT_FACTORY.createConceptScheme(target);
    }

    protected void handle(BaseType target, Documentation documentation) {
        documentation.getNote().forEach(o -> target.getNote().add(getTrans(o)));
        documentation.getChangeNote().forEach(o -> target.getChangeNote().add(getTrans(o)));
        documentation.getDefinition().forEach(o -> target.getDefinition().add(getTrans(o)));
        documentation.getEditorialNote().forEach(o -> target.getEditorialNote().add(getTrans(o)));
        documentation.getExample().forEach(o -> target.getExample().add(getTrans(o)));
        documentation.getHistoryNote().forEach(o -> target.getHiddenLabel().add(getTrans(o)));
        documentation.getScopeNote().forEach(o -> target.getScopeNote().add(getTrans(o)));
    }

    protected void handle(BaseType target, Label label) {
        label.getPreferred().forEach(o -> target.getPrefLabel().add(getTrans(o)));
        label.getAlternative().forEach(o -> target.getAltLabel().add(getTrans(o)));
        label.getHidden().forEach(o -> target.getHiddenLabel().add(getTrans(o)));
    }

    protected void handle(ConceptType target, Mapping mapping) {
        mapping.getMappingRelation().forEach(target.getMappingRelation()::add);
        mapping.getCloseMatch().forEach(target.getCloseMatch()::add);
        mapping.getExactMatch().forEach(target.getExactMatch()::add);
        mapping.getBroadMatch().forEach(target.getBroadMatch()::add);
        mapping.getNarrowMatch().forEach(target.getNarrowMatch()::add);
        mapping.getRelatedMatch().forEach(target.getRelatedMatch()::add);
    }

    protected void handle(ConceptType target, Relation relation) {
        relation.getSemanticRelation().forEach(target.getMappingRelation()::add);
        relation.getRelated().forEach(target.getRelated()::add);
        relation.getBroader().forEach(target.getBroader()::add);
        relation.getNarrower().forEach(target.getNarrower()::add);
        relation.getBroaderTransitive().forEach(target.getBroaderTransitive()::add);
        relation.getNarrowerTransitive().forEach(target.getNarrowerTransitive()::add);
    }

    protected void handle(ConceptType target, Scheme scheme) {
        scheme.getIn().forEach(target.getInScheme()::add);
        scheme.getTopOf().forEach(target.getTopConceptOf()::add);
    }

    protected void handle(ConceptSchemeType target, Scheme scheme) {
        scheme.getHasTop().forEach(target.getHasTopConcept()::add);
    }

    protected OptionType getOption(String key, String value) {
        OptionType optionType = new OptionType();
        optionType.setKey(key);
        optionType.setValue(value);

        return optionType;
    }

    protected TranslatableStringType getTrans(SkosValue source) {
        TranslatableStringType target = new TranslatableStringType();
        target.setValue(source.getValue());
        target.setLang(source.getLanguage());

        return target;
    }
}

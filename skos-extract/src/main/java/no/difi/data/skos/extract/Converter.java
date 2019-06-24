package no.difi.data.skos.extract;

import com.google.inject.Singleton;
import fdc.difi_no._2019.data.skos_1.*;
import no.difi.data.skos.model.*;

/**
 * @author erlend
 */
@Singleton
public class Converter {

    public SkosObject convert(BaseType source) {
        SkosObject target;

        if (source instanceof ConceptSchemeType) {
            target = convert((ConceptSchemeType) source);
        } else if (source instanceof ConceptType) {
            target = convert((ConceptType) source);
        } else if (source instanceof CollectionType) {
            target = convert((CollectionType) source);
        } else
            throw new IllegalStateException("Unknown source type");

        source.getNotation().forEach(target::addNotation);

        // Label
        source.getPrefLabel().forEach(e -> target.getLabel().addPreferred(convert(e)));
        source.getAltLabel().forEach(e -> target.getLabel().addAlternative(convert(e)));
        source.getHiddenLabel().forEach(e -> target.getLabel().addHidden(convert(e)));

        // Documentation
        source.getNote().forEach(e -> target.getDocumentation().addNote(convert(e)));
        source.getChangeNote().forEach(e -> target.getDocumentation().addChangeNote(convert(e)));
        source.getDefinition().forEach(e -> target.getDocumentation().addDefinition(convert(e)));
        source.getEditorialNote().forEach(e -> target.getDocumentation().addEditorialNote(convert(e)));
        source.getExample().forEach(e -> target.getDocumentation().addExample(convert(e)));
        source.getHistoryNote().forEach(e -> target.getDocumentation().addHistoryNote(convert(e)));
        source.getScopeNote().forEach(e -> target.getDocumentation().addScopeNote(convert(e)));

        return target;
    }

    public ConceptScheme convert(ConceptSchemeType source) {
        ConceptScheme target = new ConceptScheme();

        // Scheme
        source.getHasTopConcept().forEach(target.getScheme()::addHasTop);

        return target;
    }

    public Concept convert(ConceptType source) {
        Concept target = new Concept();

        // Relation
        source.getSemanticRelation().forEach(target.getRelation()::addSemanticRelation);
        source.getRelated().forEach(target.getRelation()::addRelated);
        source.getBroader().forEach(target.getRelation()::addBroader);
        source.getNarrower().forEach(target.getRelation()::addNarrower);
        source.getBroaderTransitive().forEach(target.getRelation()::addBroaderTransitive);
        source.getNarrowerTransitive().forEach(target.getRelation()::addNarrowerTransitive);

        // Scheme
        source.getInScheme().forEach(target.getScheme()::addIn);
        source.getTopConceptOf().forEach(target.getScheme()::addTopOf);

        // Mapping
        source.getMappingRelation().forEach(target.getMapping()::addMappingRelation);
        source.getCloseMatch().forEach(target.getMapping()::addCloseMatch);
        source.getExactMatch().forEach(target.getMapping()::addExactMatch);
        source.getBroadMatch().forEach(target.getMapping()::addBroadMatch);
        source.getNarrowMatch().forEach(target.getMapping()::addNarrowMatch);
        source.getRelatedMatch().forEach(target.getMapping()::addRelatedMatch);

        return target;
    }

    public Collection convert(CollectionType source) {
        Collection target = new Collection();
        source.getMember().forEach(target::addMember);

        return target;
    }

    public Config convert(ConfigType source) {
        Config target = new Config();
        target.setName(source.getName());
        target.setBaseUri(source.getBaseURI());

        for (OptionsType options : source.getOptions())
            for (OptionType option : options.getOption())
                target.addOption(options.getKey(), option.getKey(), option.getValue());

        return target;
    }

    public SkosValue convert(TranslatableStringType source) {
        return new SkosValue(source.getValue(), source.getLang());
    }
}

package no.difi.data.skos.model;

import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Setter
public class Mapping implements SkosGroup {

    private List<String> mappingRelation;

    private List<String> closeMatch;

    private List<String> exactMatch;

    private List<String> broadMatch;

    private List<String> narrowMatch;

    private List<String> relatedMatch;

    @Override
    public boolean isEmpty() {
        return mappingRelation == null && closeMatch == null && exactMatch == null && broadMatch == null && narrowMatch == null && relatedMatch == null;
    }

    public void addMappingRelation(String mappingRelation) {
        this.mappingRelation = add(this.mappingRelation, mappingRelation);
    }

    public List<String> getMappingRelation() {
        return mappingRelation == null ? new ArrayList<>() : mappingRelation;
    }

    public void addCloseMatch(String closeMatch) {
        this.closeMatch = add(this.closeMatch, closeMatch);
    }

    public List<String> getCloseMatch() {
        return closeMatch == null ? new ArrayList<>() : closeMatch;
    }

    public void addExactMatch(String exactMatch) {
        this.exactMatch = add(this.exactMatch, exactMatch);
    }

    public List<String> getExactMatch() {
        return exactMatch == null ? new ArrayList<>() : exactMatch;
    }

    public void addBroadMatch(String broadMatch) {
        this.broadMatch = add(this.broadMatch, broadMatch);
    }

    public List<String> getBroadMatch() {
        return broadMatch == null ? new ArrayList<>() : broadMatch;
    }

    public void addNarrowMatch(String narrowMatch) {
        this.narrowMatch = add(this.narrowMatch, narrowMatch);
    }

    public List<String> getNarrowMatch() {
        return narrowMatch == null ? new ArrayList<>() : narrowMatch;
    }

    public void addRelatedMatch(String relatedMatch) {
        this.relatedMatch = add(this.relatedMatch, relatedMatch);
    }

    public List<String> getRelatedMatch() {
        return relatedMatch == null ? new ArrayList<>() : relatedMatch;
    }

    protected List<String> add(List<String> values, String value) {
        if (values == null)
            values = new ArrayList<>();

        if (!values.contains(value))
            values.add(value);

        return values;
    }
}

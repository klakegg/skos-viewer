package no.difi.data.skos.model;

import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Setter
public class Scheme implements SkosGroup {

    private List<String> in;

    private List<String> hasTop;

    private List<String> topOf;

    @Override
    public boolean isEmpty() {
        return in == null && hasTop == null && topOf == null;
    }

    public void addIn(String in) {
        this.in = add(this.in, in);
    }

    public List<String> getIn() {
        return in == null ? new ArrayList<>() : in;
    }

    public void addHasTop(String hasTop) {
        this.hasTop = add(this.hasTop, hasTop);
    }

    public List<String> getHasTop() {
        return hasTop == null ? new ArrayList<>() : hasTop;
    }

    public void addTopOf(String topOf) {
        this.topOf = add(this.topOf, topOf);
    }

    public List<String> getTopOf() {
        return topOf == null ? new ArrayList<>() : topOf;
    }

    protected List<String> add(List<String> values, String value) {
        if (values == null)
            values = new ArrayList<>();

        if (!values.contains(value))
            values.add(value);

        return values;
    }
}

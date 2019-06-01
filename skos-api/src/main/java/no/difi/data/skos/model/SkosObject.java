package no.difi.data.skos.model;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
public abstract class SkosObject {

    private String self;

    private Label label = new Label();

    private Documentation documentation = new Documentation();

    private List<String> notation;

    public void addNotation(String notation) {
        if (this.notation == null)
            this.notation = new ArrayList<>();

        if (!this.notation.contains(notation))
            this.notation.add(notation);
    }

    public List<String> getNotation() {
        return notation == null ? new ArrayList<>() : notation;
    }

    @SuppressWarnings("unused")
    public void setNotation(List<String> notation) {
        this.notation = notation;
    }
}

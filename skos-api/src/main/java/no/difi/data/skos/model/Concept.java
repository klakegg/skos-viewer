package no.difi.data.skos.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Concept extends SkosObject {

    private Relation relation = new Relation();

    private Scheme scheme = new Scheme();

    private Mapping mapping = new Mapping();

}

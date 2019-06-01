package no.difi.data.skos.yaml;

import no.difi.data.skos.model.*;
import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.TypeDescription;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.constructor.Constructor;
import org.yaml.snakeyaml.nodes.Tag;
import org.yaml.snakeyaml.representer.Representer;

public class YamlInstance {

    private static Yaml yaml;

    static {
        Constructor constructor = new Constructor();
        constructor.addTypeDescription(new TypeDescription(Collection.class, new Tag("!Collection")));
        constructor.addTypeDescription(new TypeDescription(Concept.class, new Tag("!Concept")));
        constructor.addTypeDescription(new TypeDescription(ConceptScheme.class, new Tag("!ConceptScheme")));
        constructor.addTypeDescription(new TypeDescription(Config.class, new Tag("!Config")));

        Representer representer = new SkosRepresenter();
        representer.addClassTag(Collection.class, new Tag("!Collection"));
        representer.addClassTag(Concept.class, new Tag("!Concept"));
        representer.addClassTag(ConceptScheme.class, new Tag("!ConceptScheme"));
        representer.addClassTag(Config.class, new Tag("!Config"));

        DumperOptions options = new DumperOptions();
        options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK);
        options.setCanonical(false);

        yaml = new Yaml(constructor, representer, options);
    }

    public static Yaml getInstance() {
        return yaml;
    }

}

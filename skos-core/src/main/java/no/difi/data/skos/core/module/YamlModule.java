package no.difi.data.skos.core.module;

import com.google.inject.AbstractModule;
import com.google.inject.Module;
import com.google.inject.Provides;
import com.google.inject.Singleton;
import no.difi.data.skos.model.Collection;
import no.difi.data.skos.model.Concept;
import no.difi.data.skos.model.ConceptScheme;
import no.difi.data.skos.model.Config;
import no.difi.data.skos.core.yaml.SkosRepresenter;
import org.kohsuke.MetaInfServices;
import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.TypeDescription;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.constructor.Constructor;
import org.yaml.snakeyaml.nodes.Tag;
import org.yaml.snakeyaml.representer.Representer;

@MetaInfServices(Module.class)
public class YamlModule extends AbstractModule {

    @Provides
    public Constructor getConstructor() {
        Constructor constructor = new Constructor();
        constructor.addTypeDescription(new TypeDescription(Collection.class, new Tag("!Collection")));
        constructor.addTypeDescription(new TypeDescription(Concept.class, new Tag("!Concept")));
        constructor.addTypeDescription(new TypeDescription(ConceptScheme.class, new Tag("!ConceptScheme")));
        constructor.addTypeDescription(new TypeDescription(Config.class, new Tag("!Config")));

        return constructor;
    }

    @Provides
    public Representer getRepresenter() {
        Representer representer = new SkosRepresenter();
        representer.addClassTag(Collection.class, new Tag("!Collection"));
        representer.addClassTag(Concept.class, new Tag("!Concept"));
        representer.addClassTag(ConceptScheme.class, new Tag("!ConceptScheme"));
        representer.addClassTag(Config.class, new Tag("!Config"));

        return representer;
    }

    @Provides
    public DumperOptions getDumperOptions() {
        DumperOptions options = new DumperOptions();
        options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK);
        options.setCanonical(false);

        return options;
    }

    @Provides
    @Singleton
    public Yaml getYaml(Constructor constructor, Representer representer, DumperOptions options) {
        return new Yaml(constructor, representer, options);
    }
}

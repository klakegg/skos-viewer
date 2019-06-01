package no.difi.data.skos.viewer.step;

import com.google.inject.Inject;
import no.difi.data.skos.model.Config;
import no.difi.data.skos.model.SkosObject;
import no.difi.data.skos.viewer.annotation.Info;
import no.difi.data.skos.viewer.api.Step;
import no.difi.data.skos.viewer.converter.Converter;
import no.difi.data.skos.viewer.io.ResourceFileVisitor;
import no.difi.data.skos.viewer.io.SkosWriter;
import org.kohsuke.MetaInfServices;
import org.yaml.snakeyaml.Yaml;

import javax.inject.Named;
import javax.xml.bind.JAXBContext;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * @author erlend
 */
@Info(weight = 20, title = "collecting")
@MetaInfServices
public class CollectingStep implements Step {

    @Inject
    private Converter converter;

    @Inject
    @Named("skos-v1")
    private JAXBContext jaxbContext;

    @Inject
    private Yaml yaml;

    @Override
    public void trigger() throws IOException {
        // Create source.xml
        try (OutputStream outputStream = Files.newOutputStream(Paths.get("target/source.xml"));
             SkosWriter writer = new SkosWriter(outputStream, jaxbContext)) {
            // Load config
            if (Files.exists(Paths.get("config.yaml")))
                writer.add(converter.convert(load(Paths.get("config.yaml"), Config.class)));

            // Load SKOS objects
            for (Path path : ResourceFileVisitor.walk(Paths.get("src"), ".yaml"))
                writer.add(converter.convert(load(path, path.toString().substring(4, path.toString().length() - 5))));
        }
    }

    protected <T> T load(Path path, Class<T> cls) throws IOException {
        try (BufferedReader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
            return yaml.loadAs(reader, cls);
        }
    }

    protected SkosObject load(Path path, String self) throws IOException {
        try (BufferedReader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
            SkosObject skosObject = yaml.load(reader);
            skosObject.setSelf(self);
            return skosObject;
        }
    }
}

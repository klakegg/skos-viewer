package no.difi.data.skos.viewer;

import com.google.common.collect.Lists;
import com.google.common.io.MoreFiles;
import com.google.common.io.RecursiveDeleteOption;
import com.google.inject.Guice;
import com.google.inject.Inject;
import com.google.inject.Module;
import lombok.extern.slf4j.Slf4j;
import no.difi.data.skos.lang.SkosException;
import no.difi.data.skos.model.Config;
import no.difi.data.skos.model.SkosObject;
import no.difi.data.skos.viewer.converter.Converter;
import no.difi.data.skos.viewer.io.ResourceFileVisitor;
import no.difi.data.skos.viewer.io.SkosWriter;
import no.difi.data.skos.viewer.module.ArgumentsModule;
import no.difi.data.skos.viewer.schematron.SchematronFactory;
import no.difi.data.skos.viewer.schematron.SchematronProcessor;
import no.difi.data.skos.viewer.xml.SourceUtil;
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
import java.util.List;
import java.util.ServiceLoader;

/**
 * @author erlend
 */
@Slf4j
public class Main {

    @Inject
    private Converter converter;

    @Inject
    @Named("skos-v1")
    private JAXBContext jaxbContext;

    @Inject
    private Yaml yaml;

    @Inject
    private SchematronFactory schematronFactory;

    public static void main(String... args) throws IOException, SkosException {
        // Find modules
        List<Module> modules = Lists.newArrayList(ServiceLoader.load(Module.class));
        modules.add(new ArgumentsModule(args));

        // Initiate
        Guice.createInjector(modules).getInstance(Main.class).run();
    }

    public void run() throws IOException, SkosException {
        // Delete target folder
        if (Files.exists(Paths.get("target")))
            //noinspection UnstableApiUsage
            MoreFiles.deleteRecursively(Paths.get("target"), RecursiveDeleteOption.ALLOW_INSECURE);

        // Create target folder
        Files.createDirectories(Paths.get("target"));

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

        SchematronProcessor schematronProcessor = schematronFactory
                .create(SourceUtil.classpath("/schematron/skos-1.0.sch"));
        schematronProcessor.validate(Paths.get("target/source.xml"));
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

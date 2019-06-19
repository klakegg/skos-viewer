package no.difi.data.skos.extract;

import com.google.common.collect.Lists;
import com.google.common.io.MoreFiles;
import com.google.common.io.RecursiveDeleteOption;
import com.google.inject.Guice;
import com.google.inject.Inject;
import com.google.inject.Module;
import com.google.inject.name.Named;
import fdc.difi_no._2019.data.skos_1.BaseType;
import fdc.difi_no._2019.data.skos_1.SkosType;
import lombok.extern.slf4j.Slf4j;
import no.difi.data.skos.core.module.ArgumentsModule;
import no.difi.data.skos.lang.SkosException;
import org.yaml.snakeyaml.Yaml;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;
import javax.xml.transform.stream.StreamSource;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
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
    private Yaml yaml;

    @Inject
    @Named("skos-v1")
    private JAXBContext jaxbContext;

    @Inject
    @Named("args")
    private String[] args;

    @Inject
    private Converter converter;

    public static void main(String... args) throws IOException, SkosException {
        // Find modules
        List<Module> modules = Lists.newArrayList(ServiceLoader.load(Module.class));
        modules.add(new ArgumentsModule(args));

        // Initiate
        Guice.createInjector(modules).getInstance(Main.class).run();
    }

    public void run() throws IOException, SkosException {
        log.info("Source file: {}", args[0]);
        log.info("Target folder: {}", args[1]);

        if (Files.exists(Paths.get(args[1]).resolve("src")))
            //noinspection UnstableApiUsage
            MoreFiles.deleteRecursively(Paths.get(args[1]).resolve("src"), RecursiveDeleteOption.ALLOW_INSECURE);

        try (InputStream inputStream = Files.newInputStream(Paths.get(args[0]))) {
            Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();
            handle(unmarshaller.unmarshal(new StreamSource(inputStream), SkosType.class).getValue());
        } catch (JAXBException e) {
            throw new SkosException(e.getMessage(), e);
        }
    }

    public void handle(SkosType skos) throws IOException {
        Path folder = Paths.get(args[1]);

        write(folder.resolve("config.yaml"), converter.convert(skos.getConfig()));

        for (BaseType baseType : skos.getConceptSchemeOrConceptOrCollection()) {
            Path path = folder.resolve("src").resolve(baseType.getPath() + ".yaml");
            write(path, converter.convert(baseType));
        }
    }

    private void write(Path path, Object o) throws IOException {
        log.info("{}", path);
        Files.createDirectories(path.getParent());

        try (OutputStream outputStream = Files.newOutputStream(path);
             OutputStreamWriter writer = new OutputStreamWriter(outputStream)) {
            yaml.dump(o, writer);
        }
    }
}

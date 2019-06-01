package no.difi.data.skos.viewer.schematron;

import com.google.inject.Inject;
import com.google.inject.Injector;
import com.google.inject.Provider;
import com.google.inject.Singleton;
import com.google.inject.name.Named;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XsltExecutable;
import net.sf.saxon.s9api.XsltTransformer;
import no.difi.data.skos.lang.SkosException;

import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;

/**
 * @author erlend
 */
@Singleton
public class SchematronFactory {

    @Inject
    private Injector injector;

    @Inject
    private Processor processor;

    @Inject
    @Named("schematron-step3")
    private Provider<XsltExecutable> schStep3Executable;

    public SchematronProcessor create(Path path) throws SkosException, IOException {
        try (InputStream inputStream = Files.newInputStream(path)) {
            return create(inputStream);
        }
    }

    public SchematronProcessor create(InputStream inputStream) throws SkosException, IOException {
        return create(new StreamSource(inputStream));
    }

    public SchematronProcessor create(Source source) throws SkosException, IOException {
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();

            XsltTransformer xsltTransformer = schStep3Executable.get().load();
            xsltTransformer.setSource(source);
            xsltTransformer.setDestination(processor.newSerializer(baos));
            xsltTransformer.transform();

            XsltExecutable validation;

            try (InputStream is = new ByteArrayInputStream(baos.toByteArray())) {
                validation = processor.newXsltCompiler().compile(new StreamSource(is));
            }

            SchematronProcessor schematronProcessor = new SchematronProcessor(validation);
            injector.injectMembers(schematronProcessor);
            return schematronProcessor;
        } catch (SaxonApiException e) {
            throw new SkosException(e.getMessage(), e);
        }
    }
}

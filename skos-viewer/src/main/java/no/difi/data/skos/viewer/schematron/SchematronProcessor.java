package no.difi.data.skos.viewer.schematron;

import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XsltExecutable;
import net.sf.saxon.s9api.XsltTransformer;
import no.difi.data.skos.lang.SkosException;

import javax.xml.transform.stream.StreamSource;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;

/**
 * @author erlend
 */
public class SchematronProcessor {

    private XsltExecutable validation;

    public SchematronProcessor(XsltExecutable validation) {
        this.validation = validation;
    }

    public void validate(Path path) throws SkosException, IOException {
        try (InputStream inputStream = Files.newInputStream(path)) {
            validate(inputStream);
        }
    }

    public void validate(InputStream inputStream) throws SkosException {
        try {
            XsltTransformer xsltTransformer = validation.load();
            xsltTransformer.setSource(new StreamSource(inputStream));
            xsltTransformer.setDestination(validation.getProcessor().newSerializer(System.out));
            xsltTransformer.transform();
        } catch (SaxonApiException e) {
            throw new SkosException(e.getMessage(), e);
        }
    }
}

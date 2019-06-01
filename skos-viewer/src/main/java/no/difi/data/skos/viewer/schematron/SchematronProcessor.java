package no.difi.data.skos.viewer.schematron;

import com.google.inject.Inject;
import com.google.inject.name.Named;
import fdc.difi_no._2019.data.validation_1.FailedAssertType;
import fdc.difi_no._2019.data.validation_1.ResultType;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XsltExecutable;
import net.sf.saxon.s9api.XsltTransformer;
import no.difi.data.skos.lang.SkosException;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;
import javax.xml.transform.stream.StreamSource;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

/**
 * @author erlend
 */
public class SchematronProcessor {

    @Inject
    private Processor processor;

    @Inject
    @Named("svrl-parser")
    private XsltExecutable parser;

    @Inject
    @Named("validation-v1")
    private JAXBContext jaxbContext;

    private XsltExecutable validation;

    public SchematronProcessor(XsltExecutable validation) {
        this.validation = validation;
    }

    public List<FailedAssertType> validate(Path path) throws SkosException, IOException {
        try (InputStream inputStream = Files.newInputStream(path)) {
            return validate(inputStream);
        }
    }

    public List<FailedAssertType> validate(InputStream inputStream) throws SkosException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {
            XsltTransformer step2 = parser.load();
            step2.setDestination(processor.newSerializer(baos));

            XsltTransformer step1 = validation.load();
            step1.setSource(new StreamSource(inputStream));
            step1.setDestination(step2);
            step1.transform();

            Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();
            return unmarshaller.unmarshal(new StreamSource(new ByteArrayInputStream(baos.toByteArray())), ResultType.class)
                    .getValue()
                    .getFailedAssert();
        } catch (SaxonApiException | JAXBException | IllegalArgumentException e) {
            throw new SkosException(e.getMessage(), e);
        }
    }
}

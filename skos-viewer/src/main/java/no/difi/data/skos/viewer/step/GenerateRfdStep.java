package no.difi.data.skos.viewer.step;

import com.google.inject.Inject;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XsltExecutable;
import net.sf.saxon.s9api.XsltTransformer;
import no.difi.data.skos.lang.SkosException;
import no.difi.data.skos.viewer.annotation.Info;
import no.difi.data.skos.viewer.api.Step;
import no.difi.data.skos.viewer.xml.SourceUtil;
import org.kohsuke.MetaInfServices;

import javax.xml.transform.stream.StreamSource;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * @author erlend
 */
@Info(weight = 100, title = "generate rdf")
@MetaInfServices
public class GenerateRfdStep implements Step {

    @Inject
    private Processor processor;

    @Override
    public void trigger() throws IOException, SkosException {
        try {
            XsltExecutable xsltExecutable = processor.newXsltCompiler()
                    .compile(SourceUtil.classpath("/xslt/rdf-generate.xslt"));

            Path targetFile = Paths.get("target/site/all.rdf");
            Files.createDirectories(targetFile.getParent());

            try (InputStream inputStream = Files.newInputStream(Paths.get("target/populated.xml"))) {
                XsltTransformer xsltTransformer = xsltExecutable.load();
                xsltTransformer.setSource(new StreamSource(inputStream));
                xsltTransformer.setDestination(processor.newSerializer(targetFile.toFile()));
                xsltTransformer.transform();
            }
        } catch (SaxonApiException e) {
            throw new SkosException(e.getMessage(), e);
        }
    }
}

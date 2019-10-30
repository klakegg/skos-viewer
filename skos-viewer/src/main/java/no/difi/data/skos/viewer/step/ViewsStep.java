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
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author erlend
 */
@Info(weight = 200, title = "views")
@MetaInfServices
public class ViewsStep implements Step {

    @Inject
    private Processor processor;

    @SuppressWarnings("Duplicates")
    @Override
    public void trigger() throws IOException, SkosException {
        Path viewFolder = Paths.get("view");

        if (Files.notExists(viewFolder))
            return;

        List<Path> views = Files.walk(viewFolder)
                .filter(FileSystems.getDefault().getPathMatcher("glob:view/*.xslt")::matches)
                .collect(Collectors.toList());

        for (Path path : views) {
            try {
                XsltExecutable xsltExecutable = processor.newXsltCompiler().compile(SourceUtil.path(path));

                Path targetFile = Paths.get(String.format("target/%s/index.html", path.toString().replaceAll(".xslt", "")));
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
}

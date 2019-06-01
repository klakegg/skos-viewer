package no.difi.data.skos.viewer.step;

import com.google.inject.Inject;
import fdc.difi_no._2019.data.validation_1.FailedAssertType;
import lombok.extern.slf4j.Slf4j;
import no.difi.data.skos.lang.SkosException;
import no.difi.data.skos.viewer.annotation.Info;
import no.difi.data.skos.viewer.api.Step;
import no.difi.data.skos.viewer.schematron.SchematronFactory;
import no.difi.data.skos.viewer.schematron.SchematronProcessor;
import no.difi.data.skos.viewer.xml.SourceUtil;
import org.kohsuke.MetaInfServices;

import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

/**
 * @author erlend
 */
@Slf4j
@Info(weight = 30, title = "validation")
@MetaInfServices
public class ValidationStep implements Step {

    @Inject
    private SchematronFactory schematronFactory;

    @Override
    public void trigger() throws IOException, SkosException {
        // Validation
        SchematronProcessor schematronProcessor = schematronFactory
                .create(SourceUtil.classpath("/schematron/skos-1.0.sch"));
        List<FailedAssertType> failedAsserts = schematronProcessor.validate(Paths.get("target/source.xml"));

        for (FailedAssertType fa : failedAsserts)
            log.warn("[{}] {}: {}", fa.getFlag(), fa.getId(), fa.getValue());
    }
}

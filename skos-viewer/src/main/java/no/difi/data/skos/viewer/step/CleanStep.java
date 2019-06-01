package no.difi.data.skos.viewer.step;

import com.google.common.io.MoreFiles;
import com.google.common.io.RecursiveDeleteOption;
import no.difi.data.skos.viewer.annotation.Info;
import no.difi.data.skos.viewer.api.Step;
import org.kohsuke.MetaInfServices;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

/**
 * @author erlend
 */
@Info(weight = 10, title = "cleaning")
@MetaInfServices
public class CleanStep implements Step {

    @Override
    public void trigger() throws IOException {
        // Delete target folder
        if (Files.exists(Paths.get("target")))
            //noinspection UnstableApiUsage
            MoreFiles.deleteRecursively(Paths.get("target"), RecursiveDeleteOption.ALLOW_INSECURE);

        // Create target folder
        Files.createDirectories(Paths.get("target"));
    }
}

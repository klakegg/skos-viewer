package no.difi.data.skos.builder;

import no.difi.data.skos.builder.api.Build;
import no.difi.data.skos.model.Config;
import org.apache.commons.cli.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.nio.file.Paths;

public class Main {

    private static Logger logger = LoggerFactory.getLogger(Main.class);

    public static void main(String... args) throws IOException, ParseException {
        Options options = new Options();
        options.addOption(Option.builder().longOpt("basePath").hasArg(true).build());
        options.addOption(Option.builder().longOpt("baseUri").hasArg(true).build());
        options.addOption(Option.builder("w").longOpt("workspace").hasArg(true).build());
        CommandLineParser parser = new DefaultParser();
        CommandLine cmd = parser.parse(options, args);

        Workspace workspace = new Workspace(Paths.get(cmd.getOptionValue("workspace", ".")));

        Config config = workspace.getConfig();
        logger.info("Project \"{}\".", config.getName());

        workspace.cleanTarget();

        if (cmd.hasOption("basePath"))
            config.setBasePath(cmd.getOptionValue("basePath"));
        if (cmd.hasOption("baseUri"))
            config.setBaseUri(cmd.getOptionValue("baseUri"));

        Objects objects = workspace.getObjects();
        logger.info("Found {} objects.", objects.size());

        objects.populate();

        for (String build : config.getBuild()) {
            try {
                logger.info("Running {}", build);
                Build b = (Build) Class.forName(build).newInstance();
                b.build(config, workspace, objects);
            } catch (Exception e) {
                logger.warn(e.getMessage(), e);
            }
        }
    }
}

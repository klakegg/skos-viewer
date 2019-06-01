package no.difi.data.skos.builder.build;

import no.difi.data.skos.builder.Objects;
import no.difi.data.skos.builder.Workspace;
import no.difi.data.skos.model.Config;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

public class RdfSingleBuild extends AbstractRdfBuild {

    @Override
    public void build(Config config, Workspace workspace, Objects objects) throws IOException {
        Model model = ModelFactory.createDefaultModel();
        model.setNsPrefix("skos", "http://www.w3.org/2004/02/skos/core#");

        for (String key : objects.keySet())
            createForObject(config, key, objects.get(key), model);

        model.write(Files.newBufferedWriter(workspace.getTargetPath("all.rdf"), StandardCharsets.UTF_8));
        model.write(Files.newBufferedWriter(workspace.getTargetPath("all.ttl"), StandardCharsets.UTF_8), "TTL");
        // model.write(Files.newBufferedWriter(workspace.getTargetPath("all.jsonld"), StandardCharsets.UTF_8), "JSONLD");
    }
}

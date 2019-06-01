package no.difi.data.skos.builder.build;

import no.difi.data.skos.builder.Objects;
import no.difi.data.skos.builder.Workspace;
import no.difi.data.skos.model.Config;
import org.apache.jena.ext.com.google.common.collect.Lists;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.Collections;
import java.util.List;

public class RdfMultipleBuild extends AbstractRdfBuild {

    @Override
    public void build(Config config, Workspace workspace, Objects objects) throws IOException {
        List<String> keys = Lists.newArrayList(objects.keySet());
        Collections.sort(keys);

        String lastKey = null;
        Model model = null;

        for (String key : keys) {
            if (!key.split("#")[0].equals(lastKey)) {
                if (model != null && lastKey != null) {
                    model.write(Files.newBufferedWriter(workspace.getTargetPath(lastKey + ".rdf"), StandardCharsets.UTF_8));
                    model.write(Files.newBufferedWriter(workspace.getTargetPath(lastKey + ".ttl"), StandardCharsets.UTF_8), "TTL");
                    // model.write(Files.newBufferedWriter(workspace.getTargetPath(lastKey + ".jsonld"), StandardCharsets.UTF_8), "JSONLD");
                }

                model = ModelFactory.createDefaultModel();
                model.setNsPrefix("skos", "http://www.w3.org/2004/02/skos/core#");
                lastKey = key.split("#")[0];
            }

            createForObject(config, key, objects.get(key), model);
        }

        if (model != null && lastKey != null) {
            model.write(Files.newBufferedWriter(workspace.getTargetPath(lastKey + ".rdf"), StandardCharsets.UTF_8));
            model.write(Files.newBufferedWriter(workspace.getTargetPath(lastKey + ".ttl"), StandardCharsets.UTF_8), "TTL");
            // model.write(Files.newBufferedWriter(workspace.getTargetPath(lastKey + ".jsonld"), StandardCharsets.UTF_8), "JSONLD");
        }
    }
}

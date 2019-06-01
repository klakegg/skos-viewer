package no.difi.data.skos.builder.api;

import no.difi.data.skos.builder.Objects;
import no.difi.data.skos.builder.Workspace;
import no.difi.data.skos.model.Config;

import java.io.IOException;

public interface Build {

    void build(Config config, Workspace workspace, Objects objects) throws IOException;

}

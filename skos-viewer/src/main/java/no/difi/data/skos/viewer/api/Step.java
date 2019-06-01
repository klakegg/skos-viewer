package no.difi.data.skos.viewer.api;

import no.difi.data.skos.lang.SkosException;

import java.io.IOException;

/**
 * @author erlend
 */
public interface Step {

    void trigger() throws IOException, SkosException;

}

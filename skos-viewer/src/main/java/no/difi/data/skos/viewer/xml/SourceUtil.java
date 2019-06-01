package no.difi.data.skos.viewer.xml;

import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;

/**
 * @author erlend
 */
public class SourceUtil {

    public static Source classpath(String resource) {
        // System.out.println(SourceUtil.class.getResource(resource));

        return new StreamSource(SourceUtil.class.getResourceAsStream(resource));
    }
}

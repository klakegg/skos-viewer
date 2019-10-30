package no.difi.data.skos.viewer.xml;

import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import java.nio.file.Path;

/**
 * @author erlend
 */
public class SourceUtil {

    public static Source classpath(String resource) {
        // System.out.println(SourceUtil.class.getResource(resource));

        return new StreamSource(SourceUtil.class.getResourceAsStream(resource));
    }

    public static Source path(Path path) {
        return new StreamSource(path.toFile());
    }
}

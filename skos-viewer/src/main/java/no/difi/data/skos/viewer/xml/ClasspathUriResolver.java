package no.difi.data.skos.viewer.xml;

import javax.xml.transform.Source;
import javax.xml.transform.URIResolver;

/**
 * @author erlend
 */
public class ClasspathUriResolver implements URIResolver {

    private String path;

    public ClasspathUriResolver(String path) {
        this.path = path;
    }

    @Override
    public Source resolve(String s, String s1) {
        return SourceUtil.classpath(path + s);
    }
}

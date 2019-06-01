package no.difi.data.skos.viewer.module;

import com.google.inject.AbstractModule;
import com.google.inject.Module;
import com.google.inject.Provides;
import com.google.inject.Singleton;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltExecutable;
import no.difi.data.skos.viewer.xml.ClasspathUriResolver;
import no.difi.data.skos.viewer.xml.SourceUtil;
import org.kohsuke.MetaInfServices;

import javax.inject.Named;

/**
 * @author erlend
 */
@MetaInfServices(Module.class)
public class SchematronModule extends AbstractModule {

    @Provides
    @Singleton
    @Named("schematron-step3")
    public XsltExecutable getXsltExecutable(Processor processor) throws SaxonApiException {
        XsltCompiler xsltCompiler = processor.newXsltCompiler();
        xsltCompiler.setURIResolver(new ClasspathUriResolver("/iso-schematron/"));

        return xsltCompiler.compile(SourceUtil.classpath("/iso-schematron/iso_svrl_for_xslt2.xsl"));
    }
}

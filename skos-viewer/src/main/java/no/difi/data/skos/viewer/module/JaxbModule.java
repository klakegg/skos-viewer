package no.difi.data.skos.viewer.module;

import com.google.inject.AbstractModule;
import com.google.inject.Module;
import com.google.inject.Provides;
import com.google.inject.Singleton;
import fdc.difi_no._2019.data.skos_1.*;
import org.kohsuke.MetaInfServices;

import javax.inject.Named;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;

/**
 * @author erlend
 */
@MetaInfServices(Module.class)
public class JaxbModule extends AbstractModule {

    @Provides
    @Singleton
    @Named("skos")
    public JAXBContext getSkosJaxbContext() throws JAXBException {
        return JAXBContext.newInstance(CollectionType.class, ConceptType.class,
                ConceptSchemeType.class, ConfigType.class, SkosType.class);
    }
}

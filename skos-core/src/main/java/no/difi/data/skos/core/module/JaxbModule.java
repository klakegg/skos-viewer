package no.difi.data.skos.core.module;

import com.google.inject.AbstractModule;
import com.google.inject.Module;
import com.google.inject.Provides;
import com.google.inject.Singleton;
import com.google.inject.name.Named;
import fdc.difi_no._2019.data.skos_1.*;
import org.kohsuke.MetaInfServices;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;

/**
 * @author erlend
 */
@MetaInfServices(Module.class)
public class JaxbModule extends AbstractModule {

    @Provides
    @Singleton
    @Named("skos-v1")
    public JAXBContext getSkosJaxbContext() throws JAXBException {
        return JAXBContext.newInstance(CollectionType.class, ConceptType.class,
                ConceptSchemeType.class, ConfigType.class, SkosType.class);
    }
}

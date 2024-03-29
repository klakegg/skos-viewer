package no.difi.data.skos.viewer.module;

import com.google.inject.AbstractModule;
import com.google.inject.Module;
import com.google.inject.Provides;
import com.google.inject.Singleton;
import com.google.inject.name.Named;
import fdc.difi_no._2019.data.validation_1.ResultType;
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
    @Named("validation-v1")
    public JAXBContext getValidationJaxbContext() throws JAXBException {
        return JAXBContext.newInstance(ResultType.class);
    }
}

package no.difi.data.skos.core.module;

import com.google.inject.AbstractModule;
import com.google.inject.Provides;
import com.google.inject.Singleton;

import javax.inject.Named;

/**
 * @author erlend
 */
public class ArgumentsModule extends AbstractModule {

    private String[] args;

    public ArgumentsModule(String[] args) {
        this.args = args;
    }

    @Provides
    @Singleton
    @Named("args")
    public String[] getArgs() {
        return args;
    }
}

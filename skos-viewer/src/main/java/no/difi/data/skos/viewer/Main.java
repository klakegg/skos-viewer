package no.difi.data.skos.viewer;

import com.google.common.collect.Lists;
import com.google.inject.Guice;
import com.google.inject.Inject;
import com.google.inject.Injector;
import com.google.inject.Module;
import lombok.extern.slf4j.Slf4j;
import no.difi.data.skos.lang.SkosException;
import no.difi.data.skos.viewer.annotation.Info;
import no.difi.data.skos.viewer.api.Step;
import no.difi.data.skos.core.module.ArgumentsModule;

import java.io.IOException;
import java.util.Comparator;
import java.util.List;
import java.util.ServiceLoader;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

/**
 * @author erlend
 */
@Slf4j
public class Main {

    @Inject
    private Injector injector;

    public static void main(String... args) throws IOException, SkosException {
        // Find modules
        List<Module> modules = Lists.newArrayList(ServiceLoader.load(Module.class));
        modules.add(new ArgumentsModule(args));

        // Initiate
        Guice.createInjector(modules).getInstance(Main.class).run();
    }

    public void run() throws IOException, SkosException {
        List<Step> steps = StreamSupport.stream(ServiceLoader.load(Step.class).spliterator(), false)
                .sorted(Comparator.comparing(s -> s.getClass().getAnnotation(Info.class).weight()))
                .map(s -> {
                    injector.injectMembers(s);
                    return s;
                })
                .collect(Collectors.toList());

        for (Step step : steps) {
            log.info("--- {} ---", step.getClass().getAnnotation(Info.class).title());
            step.trigger();
            log.info("");
        }
    }
}

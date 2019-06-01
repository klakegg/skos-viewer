package no.difi.data.skos.yaml;

import lombok.extern.slf4j.Slf4j;
import no.difi.data.skos.model.Concept;
import no.difi.data.skos.model.SkosGroup;
import no.difi.data.skos.model.SkosObject;
import no.difi.data.skos.model.SkosValue;
import org.yaml.snakeyaml.introspector.MethodProperty;
import org.yaml.snakeyaml.introspector.Property;
import org.yaml.snakeyaml.nodes.*;
import org.yaml.snakeyaml.representer.Represent;
import org.yaml.snakeyaml.representer.Representer;

import java.beans.PropertyDescriptor;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Slf4j
public class SkosRepresenter extends Representer {

    public SkosRepresenter() {
        super();
        this.representers.put(SkosValue.class, new SkosValueRepresent());
    }

    @Override
    protected NodeTuple representJavaBeanProperty(Object javaBean, Property property, Object propertyValue, Tag customTag) {
        if (propertyValue == null)
            return null;
        if (propertyValue instanceof List && ((List) propertyValue).isEmpty())
            return null;
        if (propertyValue instanceof Map && ((Map) propertyValue).isEmpty())
            return null;
        if (propertyValue instanceof SkosGroup && ((SkosGroup) propertyValue).isEmpty())
            return null;

        return super.representJavaBeanProperty(javaBean, property, propertyValue, customTag);
    }

    @Override
    protected MappingNode representJavaBean(Set<Property> properties, Object javaBean) {
        if (javaBean instanceof Concept) {
            LinkedHashSet<Property> newProperties = new LinkedHashSet<>();

            try {
                newProperties.add(new MethodProperty(new PropertyDescriptor("label", SkosObject.class, "getLabel", "setLabel")));
                newProperties.add(new MethodProperty(new PropertyDescriptor("scheme", Concept.class, "getScheme", "setScheme")));
                newProperties.add(new MethodProperty(new PropertyDescriptor("documentation", SkosObject.class, "getDocumentation", "setDocumentation")));
                newProperties.add(new MethodProperty(new PropertyDescriptor("relation", Concept.class, "getRelation", "setRelation")));
                newProperties.add(new MethodProperty(new PropertyDescriptor("mapping", Concept.class, "getMapping", "setMapping")));

                for (Property property : properties)
                    if (!property.getName().equals("label") && !property.getName().equals("documentation") && !property.getName().equals("relation"))
                        newProperties.add(property);

                return super.representJavaBean(newProperties, javaBean);
            } catch (Exception e) {
                log.error(e.getMessage());
            }
        }

        return super.representJavaBean(properties, javaBean);
    }

    protected class SkosValueRepresent implements Represent {
        @Override
        public Node representData(Object data) {
            return new ScalarNode(Tag.STR, data.toString(), null, null, (Character) null);
        }
    }
}
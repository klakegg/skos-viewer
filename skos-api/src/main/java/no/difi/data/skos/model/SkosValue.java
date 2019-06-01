package no.difi.data.skos.model;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
public class SkosValue implements Comparable<SkosValue> {

    private String language;

    private String value;

    @SuppressWarnings("unused")
    public SkosValue(String value) {
        if (value.substring(value.lastIndexOf(" ") + 1).startsWith("@")) {
            this.value = value.substring(0, value.lastIndexOf(" "));
            this.language = value.substring(value.lastIndexOf(" ") + 2);
        } else {
            this.value = value;
        }
    }

    public SkosValue(String value, String language) {
        this.language = language;
        this.value = value;
    }

    @Override
    public String toString() {
        StringBuilder stringBuilder = new StringBuilder().append(value);

        if (language != null)
            stringBuilder.append(" @").append(language);

        return stringBuilder.toString();
    }

    public static List<SkosValue> genericAdd(List<SkosValue> values, SkosValue value) {
        if (values == null)
            values = new ArrayList<>();

        values.add(value);
        return values;
    }

    @Override
    public int compareTo(SkosValue o) {
        if (language == null || o.language == null) {
            if (o.language != null)
                return -1;
            else if (language != null)
                return 1;
            else
                return value.compareTo(o.value);
        } else {
            int result = language.compareTo(o.language);
            return result != 0 ? result : value.compareTo(o.value);
        }
    }
}

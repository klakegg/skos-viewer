package no.difi.data.skos.model;

import java.util.ArrayList;
import java.util.List;

public class Collection extends SkosObject {

    private List<String> member;

    public void addMember(String member) {
        if (this.member == null)
            this.member = new ArrayList<>();

        if (!this.member.contains(member))
            this.member.add(member);
    }

    public List<String> getMember() {
        return member == null ? new ArrayList<>() : member;
    }

    @SuppressWarnings("unused")
    public void setMember(List<String> member) {
        this.member = member;
    }
}

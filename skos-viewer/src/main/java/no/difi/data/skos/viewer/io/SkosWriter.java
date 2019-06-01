package no.difi.data.skos.viewer.io;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;
import java.io.Closeable;
import java.io.IOException;
import java.io.OutputStream;

/**
 * @author erlend
 */
public class SkosWriter implements Closeable {

    private JAXBContext jaxbContext;

    private XMLStreamWriter streamWriter;

    public SkosWriter(OutputStream outputStream, JAXBContext jaxbContext) throws IOException {
        this.jaxbContext = jaxbContext;

        try {
            XMLOutputFactory xmlOutputFactory = XMLOutputFactory.newInstance();
            streamWriter = xmlOutputFactory.createXMLStreamWriter(outputStream, "UTF-8");

            streamWriter.writeStartDocument("UTF-8", "1.0");
            streamWriter.writeStartElement("", "Skos", "urn:fdc:difi.no:2019:data:Skos-1");
            streamWriter.writeDefaultNamespace("urn:fdc:difi.no:2019:data:Skos-1");
        } catch (XMLStreamException e) {
            throw new IOException(e.getMessage(), e);
        }
    }

    public void add(JAXBElement<?> element) throws IOException {
        try {
            Marshaller marshaller = jaxbContext.createMarshaller();
            marshaller.setProperty(Marshaller.JAXB_FRAGMENT, true);
            marshaller.marshal(element, streamWriter);
        } catch (JAXBException e) {
            throw new IOException(e.getMessage(), e);
        }
    }

    @Override
    public void close() throws IOException {
        try {
            streamWriter.writeEndElement();
            streamWriter.writeEndDocument();
            streamWriter.close();
        } catch (XMLStreamException e) {
            throw new IOException(e.getMessage(), e);
        }
    }
}

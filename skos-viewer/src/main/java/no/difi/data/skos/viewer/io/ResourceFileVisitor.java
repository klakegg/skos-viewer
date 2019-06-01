package no.difi.data.skos.viewer.io;

import java.io.IOException;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.List;

/**
 * @author erlend
 */
public class ResourceFileVisitor extends SimpleFileVisitor<Path> {

    private List<Path> paths = new ArrayList<>();

    private String endsWith;

    public static List<Path> walk(Path path, String endsWith) throws IOException {
        return new ResourceFileVisitor(endsWith).walk(path);
    }

    public List<Path> walk(Path path) throws IOException {
        Files.walkFileTree(path, this);
        return paths;
    }

    public ResourceFileVisitor(String endsWith) {
        this.endsWith = endsWith;
    }

    @Override
    public FileVisitResult visitFile(Path path, BasicFileAttributes basicFileAttributes) {
        if (path.toFile().getName().endsWith(endsWith))
            paths.add(path);

        return FileVisitResult.CONTINUE;
    }
}

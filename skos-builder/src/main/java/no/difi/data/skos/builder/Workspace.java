package no.difi.data.skos.builder;

import no.difi.data.skos.model.Config;
import no.difi.data.skos.model.SkosObject;
import no.difi.data.skos.util.DefaultFileVisitor;
import no.difi.data.skos.yaml.YamlInstance;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;

public class Workspace {

    private Path folder;
    private Path srcFolder;
    private Path targetFolder;

    public Workspace(Path folder) {
        this.folder = folder;
        this.srcFolder = folder.resolve("src");
        this.targetFolder = folder.resolve("target");
    }

    public Config getConfig() throws IOException {
        Config config = YamlInstance.getInstance().loadAs(Files.newBufferedReader(folder.resolve("config.yaml"), StandardCharsets.UTF_8), Config.class);

        if (config.getBasePath() == null)
            config.setBasePath(config.getBaseUri());

        return config;
    }

    public Objects getObjects() throws IOException {
        final Objects objects = new Objects();

        Files.walkFileTree(srcFolder, new DefaultFileVisitor() {
            @Override
            public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
                if (file.toString().endsWith(".yaml")) {
                    String key = file.toString();
                    key = key.substring(srcFolder.toString().length() + 1);
                    key = key.replaceAll("\\\\", "/");
                    key = key.replace(".yaml", "");

                    objects.put(key, (SkosObject) YamlInstance.getInstance().load(Files.newBufferedReader(file, StandardCharsets.UTF_8)));
                }
                return FileVisitResult.CONTINUE;
            }
        });
        return objects;
    }

    public void cleanTarget() throws IOException {
        if (Files.exists(targetFolder)) {
            Files.walkFileTree(targetFolder, new DefaultFileVisitor() {
                @Override
                public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
                    Files.delete(file);
                    return FileVisitResult.CONTINUE;
                }

                @Override
                public FileVisitResult postVisitDirectory(Path dir, IOException exc) throws IOException {
                    Files.delete(dir);
                    return FileVisitResult.CONTINUE;
                }
            });
        }
    }

    public Path getTargetPath(String relative) throws IOException {
        Path result = targetFolder.resolve(relative);
        Files.createDirectories(result.getParent());
        return result;
    }
}

package com.bikerental.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.*;
import java.nio.file.*;
import java.util.ArrayList;
import java.util.List;

/**
 * FileHandler utility class for all file read/write operations.
 * Replaces a database — all data is stored as pipe-delimited text files.
 */
@Component
public class FileHandler {

    @Value("${app.data.path:data/}")
    private String dataPath;

    // ─── File Path Resolution ────────────────────────────────────────────────────

    private Path getFilePath(String filename) {
        Path dir = Paths.get(dataPath);
        try {
            if (!Files.exists(dir)) {
                Files.createDirectories(dir);
            }
        } catch (IOException e) {
            System.err.println("Could not create data directory: " + e.getMessage());
        }
        return dir.resolve(filename);
    }

    // ─── Core READ Operation ─────────────────────────────────────────────────────

    /**
     * Read all non-empty lines from a data file.
     * Returns an empty list if the file does not exist yet.
     */
    public List<String> readLines(String filename) {
        List<String> lines = new ArrayList<>();
        Path path = getFilePath(filename);
        if (!Files.exists(path)) return lines;

        try (BufferedReader reader = new BufferedReader(new FileReader(path.toFile()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) {
                    lines.add(line);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading file " + filename + ": " + e.getMessage());
        }
        return lines;
    }

    // ─── Core WRITE Operation ────────────────────────────────────────────────────

    /**
     * Write all lines to a data file (overwrites existing content).
     */
    public void writeLines(String filename, List<String> lines) {
        Path path = getFilePath(filename);
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(path.toFile(), false))) {
            for (String line : lines) {
                writer.write(line);
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error writing file " + filename + ": " + e.getMessage());
        }
    }

    // ─── Append (Create new record) ──────────────────────────────────────────────

    /**
     * Append a single line to a data file.
     */
    public void appendLine(String filename, String line) {
        Path path = getFilePath(filename);
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(path.toFile(), true))) {
            writer.write(line);
            writer.newLine();
        } catch (IOException e) {
            System.err.println("Error appending to file " + filename + ": " + e.getMessage());
        }
    }

    // ─── Delete by ID ────────────────────────────────────────────────────────────

    /**
     * Remove all lines from a file where the first pipe-delimited field matches id.
     */
    public boolean deleteById(String filename, String id) {
        List<String> lines = readLines(filename);
        int before = lines.size();
        lines.removeIf(line -> line.startsWith(id + "|"));
        writeLines(filename, lines);
        return lines.size() < before;
    }

    // ─── Update by ID ────────────────────────────────────────────────────────────

    /**
     * Replace the line whose first field matches id with the new line string.
     */
    public boolean updateById(String filename, String id, String newLine) {
        List<String> lines = readLines(filename);
        boolean updated = false;
        for (int i = 0; i < lines.size(); i++) {
            if (lines.get(i).startsWith(id + "|")) {
                lines.set(i, newLine);
                updated = true;
                break;
            }
        }
        if (updated) writeLines(filename, lines);
        return updated;
    }

    // ─── Find by ID ──────────────────────────────────────────────────────────────

    /**
     * Find the first line whose first field matches the given id.
     */
    public String findById(String filename, String id) {
        List<String> lines = readLines(filename);
        return lines.stream()
                .filter(line -> line.startsWith(id + "|"))
                .findFirst()
                .orElse(null);
    }

    // ─── ID Existence Check ──────────────────────────────────────────────────────

    public boolean existsById(String filename, String id) {
        return findById(filename, id) != null;
    }

    // ─── Count Records ───────────────────────────────────────────────────────────

    public int countRecords(String filename) {
        return readLines(filename).size();
    }
}

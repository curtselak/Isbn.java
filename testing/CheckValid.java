package io.sourceforge.curtthomas.isbn;

import java.io.BufferedReader;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;

public class CheckValid {
	public static void main(String[] argv) {
		System.err.println(argv[0]);
		try (BufferedReader isbns = Files.newBufferedReader(Paths.get(argv[0]));) {
			isbns.lines().forEach(a -> {if (! (Isbn.isValid(a))) System.err.println(a);});
		}
		catch (Exception e) {}
	}
}
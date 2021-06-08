package io.sourceforge.curtthomas.isbn;

import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;

public class Testing {
	public static void main (String[] argv) {
		System.err.println(argv[0]);
		Path testfile = Path.of(argv[0]);
		String line = "";
		//The package structure needs to be replicated within test suite
		//node.js will parse this path in order to determine where to write its respective output
		try (BufferedReader testdata = Files.newBufferedReader(testfile);
			 PrintWriter jsondata = new PrintWriter("io/sourceforge/curtthomas/isbn/temp01/" + 
			 	 argv[0].substring(argv[0].length() - 8) + "json"); ) {
		String[] extent = new String[(int)(Files.lines(testfile).count())];
		ArrayList<String> temp = new ArrayList<>();
		while ((line = testdata.readLine()) != null) {
			temp.add(line);			
		}
		String[] isbns = temp.toArray(extent);
		jsondata.write(Isbn.allComponentsAsJson(isbns));
	}
	
	catch (PoorISBNDataException e) {
		e.printStackTrace();
		System.exit(1);
	}
	
	catch (IOException f) {
		f.printStackTrace();
		}
		}
}
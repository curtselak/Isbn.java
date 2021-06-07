package io.sourceforge.curtthomas.isbn;
/**
Writes one or more JSON strings containing an International Standard Book Numbers components to standard output when invoked.
<p>
The <code>main()</code> method is invoked from the command line as follows:<pre>

			{@code java io.sourceforge.curtthomas.JsonIsbn 3458329021 9780863698774}

</pre>
Or:<pre>

			{@code java io.sourceforge.curtthomas.JsonIsbn true 3458329021 9780863698774}

</pre>
If the {@link java.lang.String String} literal <code>"true"</code> is passed instead of an ISBN as the first argument to the <code>JsonIsbn</code> command, 
the output will include a newline character following each key/value pair. The 
default behavior is to include the newline character only after each JSON string's closing 
brace.
<p>
If the <code>JsonIsbn</code> command is not followed by at least one ISBN number, the <code>main()</code> method will 
send a message to standard output rather than continue running.
<p>
ISBNs passed as parameters are discarded if their respective prefixes cannot be inferred 
based on RangeMessage.xml.
<p>
ISBNs in 13-digit format that do not begin with either 978 or 979, and ISBNs in 10-digit format that do not contain ten digits once that 
characters that are not digits or the roman numeral X (or x) are removed, are discarded.
*/
public class JsonIsbn {
/**
Calls the {@link Isbn Isbn} class's {@link Isbn#allComponentsAsJson(String... isbns) allComponentsAsJson()} 
method and writes the results to standard output.
@param argv One or more International Standard Book Numbers in either 13-digit or 10-digit format, delimited on the command line by a space character or, from code, by a comma.
If the {@link java.lang.String String} literal <code>"true"</code> is used as the first parameter, the output will contain a newline character after 
each key/value pair; otherwise, the only newline character to occur will be at the very end of the 
JSON string, following its closing brace.
<ul>
<li>
If an ISBN's prefix cannot be determined based on RangeMessage.xml, the ISBN is discarded. 
A message is written to the standard error stream and the <code>main()</code> method 
continues to run.
</li>
<li>
ISBNs in 13-digit format are discarded if they do not begin with either 978 or 979, as are 
ISBNs in 10-digit format that do not comprise exactly ten characters once that those 
that are not digits or the roman numeral 10 (x,X) are removed.
</li>
<li>
The <code>JsonIsbn</code> class is intended for use with existing ISBNs. Passing ISBNs as parameters that have 
never been assigned to an item as a consequence of a decision by a publisher or an agency could cause <code>main()</code>, 
{@link Isbn#allComponentsAddedKeys(String isbn) allComponentsAddedKeys()}, {@link Isbn#allComponentsMinKeys(String isbn) allComponentsMinKeys()}, 
{@link Isbn#allComponentsAsJson(String... isbns) allComponentsAsJson()}, 
or the {@link Isbn Isbn} class's {@link Isbn#main(String... argv) main()} method to throw a runtime exception.
</li>
</ul>	
@see Isbn#allComponentsAsJson(String... isbns)
@see Isbn#main(String... argv)
	*/
	public static void main (String... argv) {
	if (argv.length < 1) System.out.println("Please follow the command with at least one ten- or thirteen-digit ISBN number separated by spaces. The first argument can be the word true if you would like a newline to be included after each key/value pair.");
	else {
	//for (String isbn : argv) System.out.print(Isbn.allComponentsAsJson(isbn));
	System.out.print(Isbn.allComponentsAsJson(argv));
	}
	}
}
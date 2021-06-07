package io.sourceforge.curtthomas.isbn;
/**
Thrown by the {@link Isbn Isbn} type's {@link Isbn#isbnThirteen(String isbn) isbnThirteen()} 
method when an ISBN has missing or extraneous digits, or is thirteen digits long but does not 
begin with either 978 or 979.
<ul>
<li>
The {@link Isbn#allComponentsAsArray(String... isbns) allComponentsAsArray()} 
and {@link Isbn#allComponentsAsJson(String... isbns) allComponentsAsJson()} methods 
handle the <code>PoorISBNDataException</code> by discarding the ISBN that caused it 
to be thrown and printing a message to stderr.
</li>
</ul>
@see Isbn#isbnThirteen(String isbn)
*/
public class PoorISBNDataException extends RuntimeException {
	PoorISBNDataException(String message) {
		super(message);
	}
	}
package io.sourceforge.curtthomas.isbn;
/**
Thrown by the {@link Isbn Isbn} type's {@link Isbn#getComponent(String isbn) getComponent()}, 
{@link Isbn#allComponentsMinKeys(String isbn) allComponentsMinKeys()}, 
and {@link Isbn#allComponentsAddedKeys(String isbn) allComponentsAddedKeys()} methods 
when the code cannot infer a prefix for an ISBN based on RangeMessage.<!---->xml.
<p>
The <code>CannotInferPrefixException</code> is not likely to be encountered, because 
it is preempted throughout the API.
@see Isbn#getComponent(String isbn)
@see Isbn#allComponentsMinKeys(String isbn)
@see Isbn#allComponentsAddedKeys(String isbn)
*/
public class CannotInferPrefixException extends RuntimeException {
	CannotInferPrefixException(String message) {
		super(message);
	}
	}
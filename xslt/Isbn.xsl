<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xsl:output method="text"/>
<xsl:template match="/">
<!-- The package declaration, import statements, and javadoc description -->
<xsl:text>package io.sourceforge.curtthomas.isbn;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Set;
import java.util.TreeMap;
</xsl:text>
<xsl:text>/**
Constants corresponding to the data at &lt;a href="https://www.isbn-international.org/range_file_generation"&gt;https://www.isbn-international.org/range_file_generation&lt;/a&gt;.
&lt;p&gt;
International Standard Book Numbers comprise at most fifteen distinct characters (the 
letters that form the acronym ISBN itself [optionally], the Roman numeral X, and 
the digits 0-9), and can remain as intelligible in the context of source code as they 
already are all around the world. Accordingly, the terminological conventions on which the 
following documentation relies are minimal:
&lt;ul&gt;
&lt;li&gt;
"ISBN" is used exclusively as an acronym for International Standard Book Number.
&lt;/li&gt;
&lt;li&gt;
"isbn" (initial lower-case letter) is used exclusively as the name of a method parameter
&lt;/li&gt;
&lt;li&gt;
"Isbn" (initial upper-case letter) is used in reference to this type, preferably in the 
context of the constants and (particularly, static) methods that it defines and the bytecode 
that is generated once that it is compiled.
&lt;/li&gt;
&lt;li&gt;
"AGENCY constant" refers to constants defined herein that are returned when the class's static  
{@link assignAgencyConstant(String isbn) assignAgencyConstant()} method is called. 
&lt;/li&gt;
&lt;li&gt;
"RANGE constant" refers to constants defined herein that are returned when the class's static 
{@link assignRangeConstant(String isbn) assignRangeConstant()} method is called.
&lt;/li&gt;
&lt;li&gt;
The word "component" can be expected to pertain to the constants {@link #PREFIX PREFIX}, {@link #PREFIX_OLD PREFIX_OLD}, 
{@link #AGENCY_NAME AGENCY_NAME}, {@link #REGISTRANT_ELEMENT REGISTRANT_ELEMENT}, {@link #PUBLICATION_ELEMENT PUBLICATION_ELEMENT}, {@link #CHECK_DIGIT CHECK_DIGIT}, {@link #REGISTRANT_ELEMENT_SIZE REGISTRANT_ELEMENT_SIZE}, 
{@link #REGISTRANT_ELEMENT_EXTENT REGISTRANT_ELEMENT_EXTENT}, {@link #PUBLICATION_ELEMENT_SIZE PUBLICATION_ELEMENT_SIZE}, and {@link #PUBLICATION_ELEMENT_EXTENT PUBLICATION_ELEMENT_EXTENT}.
&lt;/li&gt;
&lt;li&gt;
"{@link #AGENCY AGENCY}" and "{@link #RANGE RANGE}" also identify constants, as does "{@link #COMPONENT COMPONENT}".
&lt;/li&gt;
&lt;/ul&gt;
Attributes possessed by AGENCY constants (e.g., {@link #ENGLISH_LANGUAGE_0 ENGLISH_LANGUAGE_0)}) always ever 
determine the respective values of {@link #PREFIX PREFIX}, {@link #PREFIX_OLD PREFIX_OLD}, 
and {@link #AGENCY_NAME AGENCY_NAME}, while the attributes of each RANGE constant (e.g. {@link #ENGLISH_LANGUAGE_0__00_TO_19_RANGE ENGLISH_LANGUAGE_0__00_TO_19_RANGE}) 
determine the respective values of {@link #REGISTRANT_ELEMENT REGISTRANT_ELEMENT}, {@link #PUBLICATION_ELEMENT PUBLICATION_ELEMENT}, 
{@link #REGISTRANT_ELEMENT_SIZE REGISTRANT_ELEMENT_SIZE}, {@link #REGISTRANT_ELEMENT_EXTENT REGISTRANT_ELEMENT_EXTENT}, 
{@link #PUBLICATION_ELEMENT_SIZE PUBLICATION_ELEMENT_SIZE}, and {@link #PUBLICATION_ELEMENT_EXTENT PUBLICATION_ELEMENT_EXTENT}.
&lt;p&gt;
The &lt;code&gt;Isbn&lt;/code&gt; type's static methods usually accept ISBNs as their parameters. The 
only static methods that do not are overloaded versions of the {@link #values() values()} method added automatically when 
the type was compiled. With the exception of {@link #getComponent(String isbn) getComponent()}, the 
remaining methods do not accept parameters, and are only called directly from constants.
@see JsonIsbn
@author Curt Selak
@version 21.5.05
*/
</xsl:text>
<!-- The type declaration -->
<xsl:text>public enum Isbn {
</xsl:text>
<!-- The declaration of the first group of constants, comprising constructor parameters and declarations of overridden methods -->
<xsl:for-each select="ISBNRangeMessage/RegistrationGroups/Group">
<xsl:variable name="name" as="xs:string" select="Agency/text()"/>
<xsl:text>/**
*  The corresponding constant for the agency identified by the name </xsl:text>
<xsl:value-of select="replace(Agency/@name,'\.','.&lt;!----&gt;','!')"/><xsl:text> and the EAN/Registration Group prefix </xsl:text>
<xsl:value-of select="Prefix"/><xsl:text>.
</xsl:text>
<xsl:for-each select="../Group[Agency[starts-with(.,replace(current()/Agency,'_[0-9]','')) and not(text()=current()/Agency)]]">
<xsl:text>@see #</xsl:text><xsl:value-of select="Agency"/><xsl:text>
</xsl:text>
</xsl:for-each>
<xsl:text>@see #assignAgencyConstant(String isbn)
@see #ranges()
</xsl:text>
<xsl:for-each select="Rules/Rule">
<xsl:text>@see #</xsl:text><xsl:value-of select="Name"/><xsl:text>
</xsl:text>
</xsl:for-each>
<xsl:text>@see #extent()
@see #getPrefix(String isbn)
@see #getAgencyName(String isbn)
@see #AGENCY
*/
</xsl:text>
<xsl:value-of select="Agency"/>
<xsl:text>("</xsl:text><xsl:value-of select="replace(Prefix,'-','')"/><xsl:text>","</xsl:text>
<xsl:value-of select="Agency/@name"/><xsl:text>"){
public String getComponent(String isbn)
{
</xsl:text>
<xsl:variable name="prfx" select="string-length(replace(Prefix,'[^0-9]',''))"/>
<xsl:text>String pf;
</xsl:text>
<xsl:text>String pffinal = null;
</xsl:text>
<xsl:text>isbn = isbnThirteen(isbn);
</xsl:text>
<xsl:for-each select="Rules/Rule">
<xsl:if test="not(Length eq '0')">
<xsl:text>
pf = isbn.substring(</xsl:text>
<xsl:value-of select="$prfx"/>
<xsl:text>,</xsl:text><xsl:value-of select="$prfx + Length"/><xsl:text>);</xsl:text>
<xsl:text>
</xsl:text>
<xsl:text>if (pf.compareTo("</xsl:text><xsl:value-of select="substring(Range,1,Length)"/>
<xsl:text>") &gt;= 0</xsl:text>
<xsl:text> &amp;&amp; pf.compareTo("</xsl:text><xsl:value-of select="substring(Range,9,Length)"/>
<xsl:text>") &lt;= 0</xsl:text>
<xsl:text>)</xsl:text>
<xsl:text>{
</xsl:text>
<xsl:text>pffinal = prefix + pf;
MAXIMUM_ASSIGNED = (</xsl:text><xsl:value-of select="replace(replace(substring(Range,9,Length),'^0+(?=[1-9])','','!'),'^0+','0','!')"/>
<xsl:text> - </xsl:text><xsl:value-of select="replace(replace(substring(Range,1,Length),'^0+(?=[1-9])','','!'),'^0+','0','!')"/>
<xsl:text>) + 1;
</xsl:text>
<xsl:text>}
</xsl:text>
</xsl:if>
</xsl:for-each>
<xsl:text>if (pffinal == null) return "";
else return pffinal;</xsl:text>
<xsl:text>}
},
</xsl:text>
</xsl:for-each>
<!-- Further constants are declared -->
<xsl:for-each select="ISBNRangeMessage/RegistrationGroups/Group">
<xsl:variable name="name" select="Agency"/>
<xsl:variable name="nlname" select="replace(Agency/@name,'\.','.&lt;!----&gt;','!')"/>
<xsl:variable name="prefix" select="Prefix"/>
<xsl:variable name="prfx" select="string-length(replace(Prefix,'[^0-9]',''))"/>
<xsl:for-each select="Rules/Rule">
<xsl:if test="not(Length eq '0')">
<xsl:variable name="rbeginstr" select="substring(Range,1,Length)"/>
<xsl:variable name="rbegin" select="replace(replace(substring(Range,1,Length),'^0+(?=[1-9])','','!'),'^0+','0','!')"/>
<xsl:variable name="rendstr" select="substring(Range,9,Length)"/>
<xsl:variable name="rend" select="replace(replace(substring(Range,9,Length),'^0+(?=[1-9])','','!'),'^0+','0','!')"/>
<xsl:text>/**
The constant corresponding to the range beginning with the registrant element assigned the 
number </xsl:text><xsl:value-of select="$rbeginstr"/><xsl:text> and ending with the registrant 
element assigned the number </xsl:text><xsl:value-of select="$rendstr"/><xsl:text> within the 
registration group bearing the agency name </xsl:text><xsl:value-of select="$nlname"/>
<xsl:text> and the EAN/Registration Group prefix </xsl:text><xsl:value-of select="$prefix"/>
<xsl:text>.
</xsl:text>
<xsl:variable name="LegalName" as="xs:string" select="Name/text()"/>
<xsl:for-each select="../Rule/Name[not(text() = $LegalName)]">
<xsl:text>@see #</xsl:text><xsl:value-of select="."/><xsl:text>
</xsl:text>
</xsl:for-each>
<xsl:text>@see #assignRangeConstant(String isbn)
@see #</xsl:text><xsl:value-of select="../../Agency"/><xsl:text>
</xsl:text>
<xsl:text>@see #getAgencyConstant()
@see #getMaximumAssigned()
@see #ranges()
@see #RANGE
*/
</xsl:text>
<xsl:value-of select="$name"/><xsl:text>__</xsl:text><xsl:value-of select="$rbeginstr"/>
<xsl:text>_TO_</xsl:text><xsl:value-of select="$rendstr"/><xsl:text>_RANGE (</xsl:text>
<xsl:value-of select="number($rend) - number($rbegin) + 1"/><xsl:text>) {
public int getMaximumAssigned() {
return MAXIMUM_ASSIGNED;
}
public Isbn getAgencyConstant() {
return </xsl:text><xsl:value-of select="$name"/><xsl:text>;
}
},
</xsl:text>
</xsl:if>
</xsl:for-each>
</xsl:for-each>
<!-- The remaining constants. CONTEXT will be the last declared -->
<xsl:text>/**
The agency's prefix preceded by the EAN/UCC prefix.
@see #getComponent(String isbn)
@see #getPrefix(String isbn)
@see #PREFIX_OLD
*/
</xsl:text>
<xsl:text>PREFIX ()
	{public String getComponent(String isbn)
	{
     if (Isbn.assignAgencyConstant(Isbn.isbnThirteen(isbn)) == Isbn.UNKNOWN |
	Isbn.assignAgencyConstant(Isbn.isbnThirteen(isbn)).getComponent(Isbn.isbnThirteen(isbn)).equals("")) 
	throw new CannotInferPrefixException("\nThere was a difficulty with\n" + isbn + ".\n\n" 
	+ "The Enum Constant Summary section of the Isbn type's javadoc,\n" +
	"or RangeMessage.xml, should be consulted in order to determine\n" +
	"whether it is possible that " + isbn + " is de jure invalid.");
	 return assignAgencyConstant(isbnThirteen(isbn)).prefix;
	 }
	},
</xsl:text>
<!-- A type for the ISBN-10 prefix -->
<xsl:text>/**
The agency's prefix without the EAN/UCC prefix that 13-digit ISBNs incorporate.
@see #getComponent(String isbn)
@see #getPrefixOld(String isbn)
@see #REGISTRANT_ELEMENT
@see #PUBLICATION_ELEMENT
@see #CHECK_DIGIT
@see #PREFIX
*/
</xsl:text>
<xsl:text>PREFIX_OLD ()
	{public String getComponent(String isbn)
	{
	if (Isbn.assignAgencyConstant(Isbn.isbnThirteen(isbn)) == Isbn.UNKNOWN |
	Isbn.assignAgencyConstant(Isbn.isbnThirteen(isbn)).getComponent(Isbn.isbnThirteen(isbn)).equals("")) 
	throw new CannotInferPrefixException("\nThere was a difficulty with\n" + isbn + ".\n\n" 
	+ "The Enum Constant Summary section of the Isbn type's javadoc,\n" +
	"or RangeMessage.xml, should be consulted in order to determine\n" +
	"whether it is possible that " + isbn + " is de jure invalid.");
	 return assignAgencyConstant(isbnThirteen(isbn)).prefix.substring(3);
	 }
	},
</xsl:text>
<!-- A type for the agency -->
<xsl:text>/**
The name that occurs in RangeMessage.&lt;!----&gt;xml's Agency element. 
@see #getComponent(String isbn)
@see #getAgencyName(String isbn)
*/
</xsl:text>
<xsl:text>AGENCY_NAME ()
{public String getComponent(String isbn)
	{
	if (Isbn.assignAgencyConstant(Isbn.isbnThirteen(isbn)) == Isbn.UNKNOWN |
	Isbn.assignAgencyConstant(Isbn.isbnThirteen(isbn)).getComponent(Isbn.isbnThirteen(isbn)).equals("")) 
	throw new CannotInferPrefixException("\nThere was a difficulty with\n" + isbn + ".\n\n" 
	+ "The Enum Constant Summary section of the Isbn type's javadoc,\n" +
	"or RangeMessage.xml, should be consulted in order to determine\n" +
	"whether it is possible that " + isbn + " is de jure invalid.");
	 return assignAgencyConstant(isbnThirteen(isbn)).agencyname;
	 }
	},
</xsl:text>
<!-- A type for the registrant element -->
<xsl:text>/**
The portion of the ISBN that identifies the publisher (i.e., the registrant prefix).
@see #getComponent(String isbn)
@see #getRegistrantElement(String isbn)
@see #PREFIX
@see #PUBLICATION_ELEMENT
@see #CHECK_DIGIT
@see #REGISTRANT_ELEMENT_SIZE
@see #REGISTRANT_ELEMENT_EXTENT
*/
</xsl:text>
<xsl:text>REGISTRANT_ELEMENT ()
	{public String getComponent(String isbn)
	{
	isbn = isbnThirteen(isbn);
	if (Isbn.assignAgencyConstant(isbn) == Isbn.UNKNOWN |
	Isbn.assignAgencyConstant(isbn).getComponent(isbn).equals("")) 
	throw new CannotInferPrefixException("\nThere was a difficulty with\n" + isbn + ".\n\n" 
	+ "The Enum Constant Summary section of the Isbn type's javadoc,\n" +
	"or RangeMessage.xml, should be consulted in order to determine\n" +
	"whether it is possible that " + isbn + " is de jure invalid.");
return assignAgencyConstant(isbn).getComponent(isbn).substring(assignAgencyConstant(isbn).prefix.length());
	}
	},
</xsl:text>
<!-- A type for the publication element -->
<xsl:text>/**
The portion of the ISBN occurring in between the registrant element and the check digit.
@see #getComponent(String isbn)
@see #getPublicationElement(String isbn)
@see #PREFIX
@see #REGISTRANT_ELEMENT
@see #CHECK_DIGIT
@see #PUBLICATION_ELEMENT_SIZE
@see #PUBLICATION_ELEMENT_EXTENT

*/
</xsl:text>
<xsl:text>PUBLICATION_ELEMENT ()
	{public String getComponent(String isbn)
	{
	isbn = isbnThirteen(isbn);
	if (Isbn.assignAgencyConstant(isbn) == Isbn.UNKNOWN |
	Isbn.assignAgencyConstant(isbn).getComponent(isbn).equals("")) 
	throw new CannotInferPrefixException("\nThere was a difficulty with\n" + isbn + ".\n\n" 
	+ "The Enum Constant Summary section of the Isbn type's javadoc,\n" +
	"or RangeMessage.xml, should be consulted in order to determine\n" +
	"whether it is possible that " + isbn + " is de jure invalid.");
	return isbn.substring(assignAgencyConstant(isbn).getComponent(isbn).length(),12);
	}
	},
</xsl:text>
<!-- A type for the check-digit -->
<xsl:text>/**
The check digit.
&lt;ul&gt;
&lt;li&gt;
Isbn.CHECK_DIGIT is only ever the check digit as calculated for an ISBN in 13-digit format.
&lt;/li&gt;
&lt;li&gt;
Isbn.CHECK_DIGIT is never the characters x or X, nor is it ever the check digit of an ISBN 
in 10-digit format.
&lt;/li&gt;
&lt;/ul&gt;
@see #getComponent(String isbn)
@see #getCheckDigit(String isbn)
@see #isbnThirteen(String isbn)
@see #isValid(String isbn)
@see #PREFIX
@see #REGISTRANT_ELEMENT
@see #PUBLICATION_ELEMENT
*/
</xsl:text>
<xsl:text>CHECK_DIGIT ()
	{public String getComponent(String isbn)
	{
	if (Isbn.assignAgencyConstant(Isbn.isbnThirteen(isbn)) == Isbn.UNKNOWN |
	Isbn.assignAgencyConstant(Isbn.isbnThirteen(isbn)).getComponent(Isbn.isbnThirteen(isbn)).equals("")) 
	throw new CannotInferPrefixException("\nThere was a difficulty with\n" + isbn + ".\n\n" 
	+ "The Enum Constant Summary section of the Isbn type's javadoc,\n" +
	"or RangeMessage.xml, should be consulted in order to determine\n" +
	"whether it is possible that " + isbn + " is de jure invalid.");
	return isbnThirteen(isbn).substring(12);
	}
	},
</xsl:text>
<!-- The size of the registrant element -->
<xsl:text>/**
The number of digits in (length of) the registrant element (publisher prefix).
@see #getComponent(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #PUBLICATION_ELEMENT
@see #PUBLICATION_ELEMENT_SIZE
*/
</xsl:text>
<xsl:text>REGISTRANT_ELEMENT_SIZE ()
	{public String getComponent(String isbn)
	{
	isbn = isbnThirteen(isbn);
	if (Isbn.assignAgencyConstant(isbn) == Isbn.UNKNOWN |
	Isbn.assignAgencyConstant(isbn).getComponent(isbn).equals("")) 
	throw new CannotInferPrefixException("\nThere was a difficulty with\n" + isbn + ".\n\n" 
	+ "The Enum Constant Summary section of the Isbn type's javadoc,\n" +
	"or RangeMessage.xml, should be consulted in order to determine\n" +
	"whether it is possible that " + isbn + " is de jure invalid.");
	return Integer.toString(REGISTRANT_ELEMENT.getComponent(isbn).length());
	}
	},
</xsl:text>
<!-- The extent of the registrant element -->
<xsl:text>/**
The length of the range to which the registrant element belongs: in effect, the 
maximum number of registrants who can be assigned to the range in which the registrant 
element of the ISBN that is to hand falls.
@see #getComponent(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #PUBLICATION_ELEMENT
@see #PUBLICATION_ELEMENT_EXTENT
*/
</xsl:text>
<xsl:text>REGISTRANT_ELEMENT_EXTENT ()
	{public String getComponent(String isbn)
	{
	isbn = isbnThirteen(isbn);
	if (Isbn.assignAgencyConstant(isbn) == Isbn.UNKNOWN |
	Isbn.assignAgencyConstant(isbn).getComponent(isbn).equals("")) 
	throw new CannotInferPrefixException("\nThere was a difficulty with\n" + isbn + ".\n\n" 
	+ "The Enum Constant Summary section of the Isbn type's javadoc,\n" +
	"or RangeMessage.xml, should be consulted in order to determine\n" +
	"whether it is possible that " + isbn + " is de jure invalid.");
	return Integer.toString(Isbn.assignRangeConstant(isbn).getMaximumAssigned());
	}
	},
</xsl:text>
<!-- The size of the publication element -->
<xsl:text>/**
The number of digits in (length of) the publication element.
@see #getComponent(String isbn)
@see #getPublicationElementSize(String isbn)
@see #REGISTRANT_ELEMENT
@see #REGISTRANT_ELEMENT_SIZE
*/
</xsl:text>
<xsl:text>PUBLICATION_ELEMENT_SIZE ()
	{public String getComponent(String isbn)
	{
	isbn = isbnThirteen(isbn);
	if (Isbn.assignAgencyConstant(isbn) == Isbn.UNKNOWN |
	Isbn.assignAgencyConstant(isbn).getComponent(isbn).equals("")) 
	throw new CannotInferPrefixException("\nThere was a difficulty with\n" + isbn + ".\n\n" 
	+ "The Enum Constant Summary section of the Isbn type's javadoc,\n" +
	"or RangeMessage.xml, should be consulted in order to determine\n" +
	"whether it is possible that " + isbn + " is de jure invalid.");
	return Integer.toString(PUBLICATION_ELEMENT.getComponent(isbn).length());
	}
	},
</xsl:text>
<!-- The extent of the publication element -->
<xsl:text>/**
The maximum number of times the ISBN's registrant element/publisher prefix can be used.
@see #getComponent(String isbn)
@see #getPublicationElementExtent(String isbn)
@see #getMaximumAssigned()
@see REGISTRANT_ELEMENT
@see REGISTRANT_ELEMENT_EXTENT
*/
</xsl:text>
<xsl:text>PUBLICATION_ELEMENT_EXTENT ()
	{public String getComponent(String isbn)
	{
	isbn = isbnThirteen(isbn);
	if (Isbn.assignAgencyConstant(isbn) == Isbn.UNKNOWN |
	Isbn.assignAgencyConstant(isbn).getComponent(isbn).equals("")) 
	throw new CannotInferPrefixException("\nThere was a difficulty with\n" + isbn + ".\n\n" 
	+ "The Enum Constant Summary section of the Isbn type's javadoc,\n" +
	"or RangeMessage.xml, should be consulted in order to determine\n" +
	"whether it is possible that " + isbn + " is de jure invalid.");
	return Integer.valueOf(Double.valueOf(Math.pow(10.0,(double)(PUBLICATION_ELEMENT.getComponent(isbn).length()))).intValue()).toString();
	}
	},
</xsl:text>
<!-- An unknown type is needed as default -->
<xsl:text>/**
Constant returned by the &lt;code&gt;Isbn&lt;/code&gt; type's {@link #assignAgencyConstant(String isbn) assignAgencyConstant()} 
method when RangeMessage.&lt;!----&gt;xml cannot furnish a prefix that matches the beginning of the 
International Standard Book Number passed as a parameter. If UNKNOWN is returned, a possible cause 
is that the most recent RangeMessage.&lt;!----&gt;xml needs must be obtained, and the &lt;code&gt;Isbn&lt;/code&gt; type's source code updated.
@see #assignAgencyConstant(String isbn)
*/
</xsl:text>
<xsl:text>UNKNOWN ()
	{public String getComponent(String isbn)
	{return "";}
	},
</xsl:text>	
<xsl:text>/**
Constant returned by {@link assignRangeConstant(String isbn) assignRangeConstant()} when 
it cannot execute.
&lt;ul&gt;
&lt;li&gt;
UNKNOWN_RANGE is returned as an alternative to handling an exception. Method calls consequent 
on {@link assignRangeConstant(String isbn) assignRangeConstant()} having returned UNKNOWN_RANGE 
will produce data that is of no use whatever.
&lt;/li&gt;
&lt;/ul&gt;
@see #assignRangeConstant(String isbn)
*/
</xsl:text>
<xsl:text>UNKNOWN_RANGE (0)
	{public int getMaximumAssigned()
	{return 0;}
	},
</xsl:text>
<xsl:text>/**
Constant returned by {@link assignRangeConstant(String isbn) assignRangeConstant()} if the 
registration group element in RangeMessage.&lt;!----&gt;xml enclosed just one rule, and if 
the value assigned to the unique rule's Length element was 0.
@see #assignRangeConstant(String isbn)
*/
</xsl:text>
<xsl:text>NO_CURRENTLY_USED_RANGE (0)
	{public int getMaximumAssigned()
	{return 0;}
	},
</xsl:text>
<xsl:text>/**
Constant returned by {@link #getContext() getContext()} when the caller 
is the type of constant returned by {@link assignAgencyConstant(String isbn) assignAgencyConstant()}. 
&lt;ul&gt;
&lt;li&gt;
Constants returned by {@link assignAgencyConstant(String isbn) assignAgencyConstant()} also are 
referred to throughout this documentation as AGENCY constants for convenience.
&lt;/li&gt;
&lt;/ul&gt;
@see #getContext()
@see #CONTEXT
*/
</xsl:text>
<xsl:text>
	AGENCY(),
</xsl:text>
<xsl:text>/**
Constant returned by {@link #getContext() getContext()} when the caller 
is the type of constant returned by {@link assignRangeConstant(String isbn) assignRangeConstant()}. 
&lt;ul&gt;
&lt;li&gt;
Constants returned by {@link assignRangeConstant(String isbn) assignRangeConstant()} also are 
referred to throughout this documentation as RANGE constants for convenience.
&lt;/li&gt;
&lt;/ul&gt;
@see #getContext()
@see #CONTEXT
*/
</xsl:text>
<xsl:text>
	RANGE(),
</xsl:text>
<xsl:text>/**
Constant returned by {@link #getContext() getContext()} when its caller is one of the following:
&lt;table align="center" cellspacing="7"&gt;
&lt;tr&gt;
&lt;td&gt;
{@link #PREFIX PREFIX}
&lt;/td&gt;
&lt;td&gt;
{@link #PREFIX_OLD PREFIX_OLD}
&lt;/td&gt;
&lt;td&gt;
{@link #AGENCY_NAME AGENCY_NAME}
&lt;/td&gt;
&lt;td&gt;
{@link #REGISTRANT_ELEMENT REGISTRANT_ELEMENT}
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
{@link #PUBLICATION_ELEMENT PUBLICATION_ELEMENT}
&lt;/td&gt;
&lt;td&gt;
{@link #CHECK_DIGIT CHECK_DIGIT}
&lt;/td&gt;
&lt;td&gt;
{@link #REGISTRANT_ELEMENT REGISTRANT_ELEMENT}
&lt;/td&gt;
&lt;td&gt;
{@link #REGISTRANT_ELEMENT_EXTENT REGISTRANT_ELEMENT_EXTENT}
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
{@link #PUBLICATION_ELEMENT_SIZE PUBLICATION_ELEMENT_SIZE}
&lt;/td&gt;
&lt;td&gt;
{@link #PUBLICATION_ELEMENT_EXTENT PUBLICATION_ELEMENT_EXTENT}
&lt;/td&gt;
&lt;/tr&gt;
&lt;/table&gt;.
&lt;ul&gt;
&lt;li&gt;
The above were referred to &lt;a href="#componentconst"&gt;elsewhere in this documentation&lt;/a&gt; as COMPONENT constants for 
convenience.
&lt;/li&gt;
&lt;/ul&gt;
@see #getContext()
@see #allComponentsAsJson(String... isbns)
@see #allComponentsAsArray(String... isbns)
@see #allComponentsMinKeys(String isbn)
@see #allComponentsAddedKeys(String isbn)
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementExtent(String isbn)
@see #getComponent(String isbn)
@see #CONTEXT
*/
</xsl:text>
<xsl:text>
	COMPONENT(),
</xsl:text>
<xsl:text>/**
Constant returned when {@link #getContext() getContext()} is called by {@link #AGENCY AGENCY}, {@link #RANGE RANGE}, 
{@link #COMPONENT COMPONENT}, or &lt;code&gt;CONTEXT&lt;/code&gt; itself.
@see #getContext()
@see #values(Isbn... flags)
@see #values(Comparator comparator,Isbn... flags)
@see #AGENCY
@see #RANGE
@see #COMPONENT
*/
</xsl:text>
<xsl:text>
	CONTEXT()
</xsl:text>
<!-- Semicolon must conclude list of types -->
<xsl:text>;
</xsl:text>
<!-- attributes are declared with default access -->
<xsl:text>/**
Value of Prefix element from RangeMessage document; used in constructor for constants returned by {@link #assignAgencyConstant(String isbn) assignAgencyConstant()}.
&lt;ul&gt;
&lt;li&gt;
Constants returned by {@link assignRangeConstant(String isbn) assignRangeConstant()} also are 
referred to throughout this documentation as RANGE constants for convenience.
&lt;/li&gt;
&lt;/ul&gt;
*/
</xsl:text>
<xsl:text>
String prefix;
</xsl:text>
<xsl:text>/**
Value of Agency element from RangeMessage document; used in constructor for constants returned by {@link #assignAgencyConstant(String isbn) assignAgencyConstant()}.
&lt;ul&gt;
&lt;li&gt;
Constants returned by {@link assignRangeConstant(String isbn) assignRangeConstant()} also are 
referred to throughout this documentation as RANGE constants for convenience.
&lt;/li&gt;
&lt;/ul&gt;
*/
</xsl:text>
<xsl:text>
String agencyname;
</xsl:text>
<xsl:text>
int MAXIMUM_ASSIGNED;
</xsl:text>
<!-- constructors -->
<xsl:text>/**
Constructor for constants returned by {@link #assignAgencyConstant(String isbn) assignAgencyConstant()}.
*/
</xsl:text>
<xsl:text>
Isbn(String prfx, String aname){
		prefix = prfx;
		agencyname = aname;
		MAXIMUM_ASSIGNED = 0;
	}
</xsl:text>	
<xsl:text>
Isbn(int MaximumAssigned) {
		MAXIMUM_ASSIGNED = MaximumAssigned;
}
</xsl:text>
<xsl:text>/**
Constructor for {@link #PREFIX PREFIX}, {@link #PREFIX_OLD PREFIX_OLD}, {@link #AGENCY_NAME AGENCY_NAME}, {@link #REGISTRANT_ELEMENT REGISTRANT_ELEMENT}, {@link #PUBLICATION_ELEMENT PUBLICATION_ELEMENT}, {@link #CHECK_DIGIT CHECK_DIGIT}, {@link #REGISTRANT_ELEMENT_SIZE REGISTRANT_ELEMENT_SIZE}, {@link #PUBLICATION_ELEMENT_SIZE PUBLICATION_ELEMENT_SIZE}, {@link #PUBLICATION_ELEMENT_EXTENT PUBLICATION_ELEMENT_EXTENT}, and {@link #UNKNOWN UNKNOWN}.  
*/
</xsl:text>
<xsl:text>
Isbn(){
}
</xsl:text>
<!-- first overloaded values() method -->
<xsl:text>/**
Overloads the {@link #values() values()} method added to the &lt;code&gt;Isbn&lt;/code&gt; type once that it was compiled in order 
to filter the constants.
@param flags  One or more of {@link #CONTEXT Isbn.CONTEXT}, {@link #AGENCY Isbn.AGENCY}, 
{@link #RANGE Isbn.RANGE}, or {@link #COMPONENT Isbn.COMPONENT}.
&lt;p&gt;
&lt;ul&gt;
&lt;li&gt;
Parameters that are AGENCY constants (constants returned by {@link #assignAgencyConstant(String isbn) assignAgencyConstant()}),  
RANGE constants (constants returned by {@link #assignRangeConstant(String isbn) assignRangeConstant()}), or 
constants that return &lt;code&gt;COMPONENT&lt;/code&gt; when they call {@link #getContext() getContext()} are ignored.
&lt;/li&gt;
&lt;li&gt;
If identical parameters are passed, the duplicates are preserved not discarded:&lt;pre&gt;
				{@code Isbn[] unique = Isbn.values(Isbn.AGENCY); //unique.length is 257
				Isbn[] redundant = Isbn.values(Isbn.AGENCY,Isbn.AGENCY); //redundant.length is 514}
&lt;/pre&gt;

The length of the array returned by the {@link #values() values()} method furnished by the compiler and 
called by the overloaded versions only ever remains the same throughout runtime.
&lt;/li&gt;
&lt;/ul&gt;
@return
&lt;ul&gt;
&lt;li&gt;
Returns an array of Isbn constants the length of which ultimately depends on the parameters passed.
&lt;/li&gt;
&lt;li&gt;
Returns an array of zero length if only constants of the respective types returned by 
either {@link #assignAgencyConstant(String isbn) assignAgencyConstant()} (AGENCY constants) or   
{@link #assignRangeConstant(String isbn) assignRangeConstant()} (RANGE constants), 
or constants that return &lt;code&gt;COMPONENT&lt;/code&gt; when they call 
{@link #getContext() getContext()}, are passed as parameters.
&lt;/li&gt;
&lt;/ul&gt;
@see
#values(Comparator comparator,Isbn... flags)
*/
</xsl:text>
<xsl:text>
public static Isbn[] values(Isbn... flags) {
ArrayList&lt;Isbn&gt; constants = new ArrayList&lt;&gt;();
for (Isbn constant : flags) { 
if (constant.getContext() == CONTEXT) {
for (Isbn currentconstant : Isbn.values())
if (currentconstant.getContext() == constant) constants.add(currentconstant);
}
}
Collections.sort(constants);
Isbn[] returnedconstants = new Isbn[constants.size()];
return constants.toArray(returnedconstants);
}
</xsl:text>
<!-- second overloaded values() method -->
<xsl:text>/**
Overloads the {@link #values() values()} method added to the &lt;code&gt;Isbn&lt;/code&gt; type once that it was compiled in order 
to filter the constants, and sorts the result prior to returning it.
&lt;p&gt;
For example:&lt;pre&gt;
				{@code Comparator&lt;Isbn&gt; nonordinal = (a,b) -&gt; a.name().compareTo(b.name());
				Isbn[] constantsAtoZ = Isbn.values(nonordinal, Isbn.CONTEXT);}&lt;/pre&gt;
produces &lt;code&gt;[AGENCY,COMPONENT,CONTEXT,RANGE]&lt;/code&gt;, where  {@link #values(Isbn... flags) values()} called only with the &lt;code&gt;flags&lt;/code&gt;  
parameter would have produced &lt;code&gt;[AGENCY,RANGE,COMPONENT,CONTEXT]&lt;/code&gt;.
@param comparator A Comparator&lt;Isbn&gt; type.
@param flags  One or more of {@link #CONTEXT Isbn.CONTEXT}, {@link #AGENCY Isbn.AGENCY}, 
{@link #RANGE Isbn.RANGE}, or {@link #COMPONENT Isbn.COMPONENT}.
&lt;p&gt;
&lt;ul&gt;
&lt;li&gt;
Parameters that are AGENCY constants (constants returned by {@link #assignAgencyConstant(String isbn) assignAgencyConstant()}),  
RANGE constants (constants returned by {@link #assignRangeConstant(String isbn) assignRangeConstant()}), or 
constants that return &lt;code&gt;COMPONENT&lt;/code&gt; when they call {@link #getContext() getContext()} are ignored.
&lt;/li&gt;
&lt;li&gt;
If identical parameters are passed, the duplicates are preserved not discarded:&lt;pre&gt;
				{@code Comparator&lt;Isbn&gt; nonordinal = (a,b) -&gt; a.name().compareTo(b.name()); 
				Isbn[] unique = Isbn.values(nonordinal, Isbn.AGENCY); //unique.length is 257
				Isbn[] redundant = Isbn.values(nonordinal, Isbn.AGENCY,Isbn.AGENCY); //redundant.length is 514}
&lt;/pre&gt;

The length of the array returned by the {@link #values() values()} method furnished by the compiler and 
called by the overloaded versions only ever remains the same throughout runtime.
&lt;/li&gt;
&lt;/ul&gt;
@return
&lt;ul&gt;
&lt;li&gt;
Returns an array of Isbn constants the length of which ultimately depends on the parameters passed. 
The assignment of the constants' respective indexes ultimately is determined by the 
Comparator&lt;Isbn&gt; type passed as the first parameter.
&lt;/li&gt;
&lt;li&gt;
Returns an array of zero length if only constants of the respective types returned by 
either {@link #assignAgencyConstant(String isbn) assignAgencyConstant()} (AGENCY constants) or   
{@link #assignRangeConstant(String isbn) assignRangeConstant()} (RANGE constants), 
or constants that return &lt;code&gt;COMPONENT&lt;/code&gt; when they call 
{@link #getContext() getContext()}, are passed as parameters.
&lt;/li&gt;
&lt;/ul&gt;
@see #values(Isbn... flags)
@see #extent()
@see #getMaximumAssigned()
@see #ranges()
*/
</xsl:text>
<xsl:text>
public static Isbn[] values(Comparator&lt;Isbn&gt; comparator,Isbn... flags) {
ArrayList&lt;Isbn&gt; constants = new ArrayList&lt;&gt;();
for (Isbn constant : flags) { 
if (constant.getContext() == CONTEXT) {
for (Isbn currentconstant : Isbn.values())
if (currentconstant.getContext() == constant) constants.add(currentconstant);
}
}
Collections.sort(constants, comparator);
Isbn[] returnedconstants = new Isbn[constants.size()];
return constants.toArray(returnedconstants);
}
</xsl:text>
<!-- getContext -->
<xsl:text>/**
Supplies the caller's corresponding CONTEXT constant: ({@link #AGENCY AGENCY}, 
{@link #RANGE RANGE}, {@link #COMPONENT COMPONENT}, or {@link #CONTEXT CONTEXT}).
@return
&lt;ul&gt;
&lt;li&gt;
Returns &lt;code&gt;CONTEXT&lt;/code&gt; if the caller is {@link #AGENCY AGENCY}, 
{@link #RANGE RANGE}, {@link #COMPONENT COMPONENT}, or {@link #CONTEXT CONTEXT} itself.
&lt;/li&gt;
&lt;li&gt;
Returns &lt;code&gt;COMPONENT&lt;/code&gt; if the caller is {@link #PREFIX PREFIX}, {@link #PREFIX_OLD PREFIX_OLD}, 
{@link #AGENCY_NAME AGENCY_NAME}, {@link #REGISTRANT_ELEMENT REGISTRANT_ELEMENT}, 
{@link #PUBLICATION_ELEMENT PUBLICATION_ELEMENT}, {@link #CHECK_DIGIT CHECK_DIGIT}, 
{@link #REGISTRANT_ELEMENT_SIZE REGISTRANT_ELEMENT_SIZE}, {@link #REGISTRANT_ELEMENT_EXTENT REGISTRANT_ELEMENT_EXTENT}, 
{@link #PUBLICATION_ELEMENT_SIZE PUBLICATION_ELEMENT_SIZE}, or {@link #PUBLICATION_ELEMENT_EXTENT PUBLICATION_ELEMENT_EXTENT},
&lt;/li&gt;
&lt;li&gt;
Returns &lt;code&gt;RANGE&lt;/code&gt; if the caller's name ends with the {@link java.lang.String String} &lt;code&gt;"RANGE"&lt;/code&gt;,
&lt;/li&gt;
&lt;li&gt;
Returns &lt;code&gt;AGENCY&lt;/code&gt; otherwise, including when the caller is {@link #UNKNOWN UNKNOWN}.
&lt;/li&gt;
&lt;/ul&gt;
@see #getAgencyConstant()
@see #ranges()
@see #values(Isbn... flags)
@see #values(Comparator comparator,Isbn... flags)
@see #CONTEXT
@see #AGENCY
@see #RANGE
@see #COMPONENT
*/
</xsl:text>
<xsl:text>public Isbn getContext() {
if (this.name() == "AGENCY" | this.name() == "RANGE" | this.name() == "COMPONENT" | this.name() == "CONTEXT") return CONTEXT;
else if (this.name().contains("__") | this.name().endsWith("_RANGE")) return RANGE;
else if (this.name() == "PREFIX" | this.name() == "PREFIX_OLD" | this.name() == "AGENCY_NAME" | this.name() == "REGISTRANT_ELEMENT" | this.name() == "PUBLICATION_ELEMENT" | this.name() == "CHECK_DIGIT"
 | this.name() == "REGISTRANT_ELEMENT_SIZE" | this.name() == "REGISTRANT_ELEMENT_EXTENT" | this.name() == "PUBLICATION_ELEMENT_SIZE" | this.name() == "PUBLICATION_ELEMENT_EXTENT") 
return COMPONENT; 
else return AGENCY;
}
</xsl:text>
<!-- assignAgencyConstant() -->
<xsl:text>/**
Locates the constant uniquely corresponding to an ISBN's agency prefix.
&lt;p&gt;
Because access to the API can depend on access to the constants it defines, the 
&lt;code&gt;assignAgencyConstant()&lt;/code&gt; and {@link #assignRangeConstant(String isbn) assignRangeConstant()} 
methods are of some little importance as entry points. An &lt;a href="#example01"&gt;example&lt;/a&gt; 
elsewhere in this documentation defined an array of three ISBNS, the respective agency 
prefixes of which were 978-0, 978-2, and 978-3:&lt;pre&gt;
			{@code String[] isbns = {"0415083699","2738424155","3518576348"};
			Arrays.sort(isbns); //still ["0415083699","2738424155","3518576348"]}
&lt;/pre&gt;Above, sorting the array was necessary only in order to demonstrate that the array indexes 
already were assigned to the {@link java.lang.String String} objects based on their natural 
order. Calling &lt;code&gt;assignAgencyConstant()&lt;/code&gt; introduces other possibilities 
where the criteria for sorting are concerned:&lt;pre&gt;
			{@code Comparator&lt;String&gt; comparator = 
			(a,b) -> 
			Integer.valueOf(Isbn.assignAgencyConstant(a).extent())
			.compareTo(Integer.valueOf(Isbn.assignAgencyConstant(b).extent()));
			Arrays.sort(isbns, comparator); //isbns is now ["3518576348","2738424155","0415083699"]}
&lt;/pre&gt;The array was sorted a second time in ascending order, but the key was assigned to a 
characteristic of each ISBN number's corresponding AGENCY constant, namely the number of possible 
registrant elements (publisher prefixes) available within it to assign: 250,453 for 978-3, 568,126 
for 978-2, and 579,052 for 978-0. Respective calls to &lt;code&gt;assignAgencyConstant()&lt;/code&gt; 
were each chained to a call to the &lt;code&gt;Isbn&lt;/code&gt; type's nonstatic {@link #extent() extent()} method in 
order to produce the key.
@param isbn An International Standard Book Number in either 10-digit or 13-digit format.
@return
A constant defined by the Isbn type, the identifier of which consists of the agency name, 
concatenated where necessary with an ordinal number. For example, the following code&lt;pre&gt; 
			{@code Isbn.assignAgencyConstant("3499290111");}
&lt;/pre&gt;returns &lt;code&gt;GERMAN_LANGUAGE&lt;/code&gt;.
&lt;p&gt;
The type of the value returned is &lt;code&gt;Isbn&lt;/code&gt;, not {@link java.lang.String String}. In order to obtain 
a {@link java.lang.String String} object, the following is necessary:&lt;pre&gt;
			{@code Isbn.assignAgencyConstant("3499290111").name();}
&lt;/pre&gt;The call to the constant's inherited {@link java.lang.Enum#name() name()} method returns 
&lt;code&gt;"GERMAN_LANGUAGE"&lt;/code&gt;.
@see #assignRangeConstant(String isbn)
@see #extent()
@see #ranges()
*/
</xsl:text>
<xsl:text>public static Isbn assignAgencyConstant(String isbn) {
isbn = isbnThirteen(isbn);
</xsl:text>
<xsl:for-each select="ISBNRangeMessage/RegistrationGroups/Group">
<xsl:choose>
<xsl:when test="position()=1">
<xsl:text>if (isbn.startsWith("</xsl:text><xsl:value-of select="replace(Prefix,'-','')"/>
<xsl:text>")) return </xsl:text>
<xsl:value-of select="Agency"/>
<xsl:text>;
</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:text>else if (isbn.startsWith("</xsl:text><xsl:value-of select="replace(Prefix,'-','')"/>
<xsl:text>")) return </xsl:text>
<xsl:value-of select="Agency"/>
<xsl:text>;
</xsl:text>
</xsl:otherwise>
</xsl:choose>
		</xsl:for-each>
<xsl:text>else return UNKNOWN;
</xsl:text>
<xsl:text>}
</xsl:text>
<!-- ranges() -->
<xsl:text>/**
Supplies the calling AGENCY constant's applicable RANGE constants as an array.
&lt;p&gt;
For example, &lt;code&gt;Isbn.LEBANON_1.ranges()[1]&lt;/code&gt; returns 
&lt;code&gt;LEBANON_1__10_TO_39_RANGE&lt;/code&gt;.
@return
&lt;ul&gt;
&lt;li&gt;
If the caller is an AGENCY constant, returns an array containing one RANGE constant for each 
of the caller's applicable ranges.
&lt;/li&gt;
&lt;li&gt;
Returns an empty &lt;code&gt;Isbn&lt;/code&gt; array if the caller is a RANGE, COMPONENT, 
or CONTEXT constant.
&lt;/li&gt;
&lt;/ul&gt;
@see #extent()
@see #getAgencyConstant()
*/
</xsl:text>
<xsl:text>
public Isbn[] ranges() {
if (this.getContext() == AGENCY) {
ArrayList&lt;Isbn&gt; ranges = new ArrayList&lt;&gt;();
for (Isbn constant : Isbn.values()) 
if (constant.getContext() == RANGE &amp;&amp; constant.name().startsWith(this.name() + "__")) 
ranges.add(constant);
Collections.sort(ranges);
Isbn[] returnedRanges = new Isbn[ranges.size()];
return ranges.toArray(returnedRanges);
}
else return new Isbn[0];
}
</xsl:text>
<!-- extent() -->
<xsl:text>/**
Supplies the maximum number of registrant elements/publisher prefixes that a given agency can 
currently assign according to RangeMessage.&lt;!----&gt;xml.
&lt;p&gt;
@return
&lt;ul&gt;
&lt;li&gt;
When called by an AGENCY constant, returns an &lt;code&gt;int&lt;/code&gt; 
representing the maximum number of registrant elements (publisher prefixes) that the 
AGENCY constant can encompass.
&lt;code&gt;Isbn.LEBANON_0.extent()&lt;/code&gt;, for example, returns &lt;code&gt;6940&lt;/code&gt;.
&lt;/li&gt;
&lt;ul&gt;
&lt;li&gt;
When called by &lt;code&gt;Isbn.UNKNOWN&lt;/code&gt;, returns &lt;code&gt;0&lt;/code&gt;.
&lt;/li&gt;
&lt;/ul&gt;
&lt;li&gt;
Returns &lt;code&gt;-1&lt;/code&gt; when called by a RANGE, COMPONENT, or CONTEXT constant.
&lt;/li&gt;
&lt;/ul&gt;
@see #ranges()
@see #getMaximumAssigned()
@see #AGENCY
*/
</xsl:text>
<xsl:text>
public int extent() {
if (this.getContext() == AGENCY) {
int total = 0;
for (Isbn range : this.ranges()) total += range.getMaximumAssigned();
return total;
}
else return -1;
}
</xsl:text>
<!-- assignRangeConstant() -->
<xsl:text>/**
Locates the constant uniquely corresponding to the range within which an ISBN's registrant element occurs, 
respective to the code for the agency responsible for assigning the registrant element.   

&lt;p&gt;
Because access to the API can depend on access to the constants it defines, the 
&lt;code&gt;assignRangeConstant()&lt;/code&gt; and {@link #assignAgencyConstant(String isbn) assignAgencyConstant()} 
methods are of some little importance as entry points. An &lt;a href="#example01"&gt;example&lt;/a&gt; 
elsewhere in this documentation defined an array of three ISBNS, the respective agency 
prefixes of which were 978-0, 978-2, and 978-3:&lt;pre&gt;
			{@code String[] isbns = {"0415083699","2738424155","3518576348"};
			Arrays.sort(isbns); //still ["0415083699","2738424155","3518576348"]}
&lt;/pre&gt;Above, sorting the array was necessary only in order to demonstrate that the array indexes 
already were assigned to the {@link java.lang.String String} objects based on their natural 
order. Calling &lt;code&gt;assignRangeConstant()&lt;/code&gt; introduces other possibilities 
where the criteria for sorting are concerned:&lt;pre&gt;
			{@code Comparator&lt;String&gt; comparator = 
			(a,b) -> 
			Integer.valueOf(Isbn.assignRangeConstant(a).getMaximumAssigned())
			.compareTo(Integer.valueOf(Isbn.assignRangeConstant(b).getMaximumAssigned()));
			Arrays.sort(isbns, comparator); //isbns is now ["0415083699","3518576348","2738424155"]}
&lt;/pre&gt;The array was sorted a second time in ascending order, but the key was assigned to a 
characteristic of each ISBN number's corresponding RANGE constant, namely the number of possible 
registrant elements (publisher prefixes) available to assign given the specific range's bounds: 
269 for &lt;code&gt;ENGLISH_LANGUAGE_0__370_TO_638_RANGE&lt;/code&gt;, 500 for &lt;code&gt;GERMAN_LANGUAGE__200_TO_699_RANGE&lt;/code&gt;, 
and 1400 for &lt;code&gt;FRENCH_LANGUAGE__7000_TO_8399_RANGE&lt;/code&gt;. Respective calls to &lt;code&gt;assignRangeConstant()&lt;/code&gt; 
were each chained to a call to the &lt;code&gt;Isbn&lt;/code&gt; type's nonstatic {@link #getMaximumAssigned() getMaximumAssigned()} 
method in order to produce the key.
@param isbn An International Standard Book Number in either 10-digit or 13-digit format.
@return
A constant defined by the Isbn type, the identifier of which consists of the agency name, 
concatenated where necessary with an ordinal number, followed by two further underscore 
characters, followed by a concatenation of the lower bound of the range, the word "TO", 
the upper bound of the range, and the word "RANGE". For example, the following code&lt;pre&gt;
			{@code Isbn.assignRangeConstant("3499290111");}
&lt;/pre&gt;returns &lt;code&gt;GERMAN_LANGUAGE__200_TO_699_RANGE&lt;/code&gt;.
&lt;p&gt;
The type of the value returned is &lt;code&gt;Isbn&lt;/code&gt;, not {@link java.lang.String String}. In order to obtain 
a {@link java.lang.String String} object, the following is necessary:&lt;pre&gt;
			{@code Isbn.assignRangeConstant("3499290111").name();}
&lt;/pre&gt;The call to the constant's inherited {@link java.lang.Enum#name() name()} method returns 
&lt;code&gt;"GERMAN_LANGUAGE__200_TO_600_RANGE"&lt;/code&gt;.
@see #getMaximumAssigned()
@see #getAgencyConstant()
@see #ranges()
*/
</xsl:text>
<xsl:text>public static Isbn assignRangeConstant(String isbn){
isbn = isbnThirteen(isbn);</xsl:text>
<xsl:for-each select="ISBNRangeMessage/RegistrationGroups/Group">
<xsl:choose>
<xsl:when test="position() = 1">
<xsl:text>
if (Integer.parseInt(PREFIX.getComponent(isbn)) == </xsl:text><xsl:value-of select="replace(Prefix,'[^0-9]','')"/>
<xsl:text>) return assignRangeConstant</xsl:text><xsl:value-of select="replace(Prefix,'[^0-9]','')"/>
<xsl:text>(isbn);</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:text>
else if (Integer.parseInt(PREFIX.getComponent(isbn)) == </xsl:text><xsl:value-of select="replace(Prefix,'[^0-9]','')"/>
<xsl:text>) return assignRangeConstant</xsl:text><xsl:value-of select="replace(Prefix,'[^0-9]','')"/>
<xsl:text>(isbn);</xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
<xsl:text>
else return UNKNOWN_RANGE;
}
</xsl:text>
<!-- first helper method for assignRangeConstant() - declared with default access -->
<xsl:for-each select="ISBNRangeMessage/RegistrationGroups/Group[count(Rules/Rule) gt 1 and not(number(Rules/Rule[1]/Length) eq 0)]">
<xsl:variable name="position" select="position()"/>
<xsl:variable name="name" select="Agency"/>
<xsl:variable name="nlname" select="replace(Agency/@name,'\.','.&lt;!-¡-¡&gt;','!')"/>
<xsl:variable name="prefix" select="Prefix"/>
<xsl:variable name="prfx" select="replace(Prefix,'[^0-9]','')"/>
<xsl:text>private static Isbn assignRangeConstant</xsl:text><xsl:value-of select="$prfx"/>
<xsl:text>(String isbn) { try {
</xsl:text>
<xsl:for-each select="Rules/Rule">
<xsl:if test="not(Length eq '0')">
<xsl:variable name="rbeginstr" select="substring(Range,1,Length)"/>
<xsl:variable name="rbegin" select="replace(replace(substring(Range,1,Length),'^0+(?=[1-9])','','!'),'^0+','0','!')"/>
<xsl:variable name="rendstr" select="substring(Range,9,Length)"/>
<xsl:variable name="rend" select="replace(replace(substring(Range,9,Length),'^0+(?=[1-9])','','!'),'^0+','0','!')"/>
<xsl:choose>
<xsl:when test="position() = 1">
<xsl:text>if ((Integer.parseInt(REGISTRANT_ELEMENT.getComponent(isbn)) &gt;= </xsl:text>
<xsl:value-of select="$rbegin"/><xsl:text>) &amp;&amp; </xsl:text>
<xsl:text>(Integer.parseInt(REGISTRANT_ELEMENT.getComponent(isbn)) &lt;= </xsl:text>
<xsl:value-of select="$rend"/><xsl:text>)</xsl:text>
<xsl:text>
)
</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:text>else if ((Integer.parseInt(REGISTRANT_ELEMENT.getComponent(isbn)) &gt;= </xsl:text>
<xsl:value-of select="$rbegin"/><xsl:text>) &amp;&amp; </xsl:text>
<xsl:text>(Integer.parseInt(REGISTRANT_ELEMENT.getComponent(isbn)) &lt;= </xsl:text>
<xsl:value-of select="$rend"/><xsl:text>)</xsl:text>
<xsl:text>
)
</xsl:text>
</xsl:otherwise>
</xsl:choose>
<xsl:text>return </xsl:text>
<xsl:value-of select="$name"/><xsl:text>__</xsl:text><xsl:value-of select="$rbeginstr"/>
<xsl:text>_TO_</xsl:text><xsl:value-of select="$rendstr"/><xsl:text>_RANGE;
</xsl:text>
</xsl:if>
</xsl:for-each>
<xsl:text>
else return UNKNOWN_RANGE;
}
catch (Exception e) {return UNKNOWN_RANGE;}
</xsl:text>
<xsl:text>}
</xsl:text>
</xsl:for-each>
<xsl:for-each select="ISBNRangeMessage/RegistrationGroups/Group[count(Rules/Rule) gt 1 and number(Rules/Rule[1]/Length) eq 0]">
<xsl:variable name="position" select="position()"/>
<xsl:variable name="name" select="Agency"/>
<xsl:variable name="nlname" select="replace(Agency/@name,'\.','.&lt;!-¡-¡&gt;','!')"/>
<xsl:variable name="prefix" select="Prefix"/>
<xsl:variable name="prfx" select="replace(Prefix,'[^0-9]','')"/>
<xsl:text>private static Isbn assignRangeConstant</xsl:text><xsl:value-of select="$prfx"/>
<xsl:text>(String isbn) { try {
</xsl:text>
<xsl:for-each select="Rules/Rule">
<xsl:if test="not(Length eq '0')">
<xsl:variable name="rbeginstr" select="substring(Range,1,Length)"/>
<xsl:variable name="rbegin" select="replace(replace(substring(Range,1,Length),'^0+(?=[1-9])','','!'),'^0+','0','!')"/>
<xsl:variable name="rendstr" select="substring(Range,9,Length)"/>
<xsl:variable name="rend" select="replace(replace(substring(Range,9,Length),'^0+(?=[1-9])','','!'),'^0+','0','!')"/>
<xsl:choose>
<xsl:when test="position() = 2">
<xsl:text>if ((Integer.parseInt(REGISTRANT_ELEMENT.getComponent(isbn)) &gt;= </xsl:text>
<xsl:value-of select="$rbegin"/><xsl:text>) &amp;&amp; </xsl:text>
<xsl:text>(Integer.parseInt(REGISTRANT_ELEMENT.getComponent(isbn)) &lt;= </xsl:text>
<xsl:value-of select="$rend"/><xsl:text>)</xsl:text>
<xsl:text>
)
</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:text>else if ((Integer.parseInt(REGISTRANT_ELEMENT.getComponent(isbn)) &gt;= </xsl:text>
<xsl:value-of select="$rbegin"/><xsl:text>) &amp;&amp; </xsl:text>
<xsl:text>(Integer.parseInt(REGISTRANT_ELEMENT.getComponent(isbn)) &lt;= </xsl:text>
<xsl:value-of select="$rend"/><xsl:text>)</xsl:text>
<xsl:text>
)
</xsl:text>
</xsl:otherwise>
</xsl:choose>
<xsl:text>return </xsl:text>
<xsl:value-of select="$name"/><xsl:text>__</xsl:text><xsl:value-of select="$rbeginstr"/>
<xsl:text>_TO_</xsl:text><xsl:value-of select="$rendstr"/><xsl:text>_RANGE;
</xsl:text>
</xsl:if>
</xsl:for-each>
<xsl:text>
else return UNKNOWN_RANGE;
}
catch (Exception e) {return UNKNOWN_RANGE;}
</xsl:text>
<xsl:text>}
</xsl:text>
</xsl:for-each>
<xsl:for-each select="ISBNRangeMessage/RegistrationGroups/Group[count(Rules/Rule) eq 1 and not(number(Rules/Rule[1]/Length) eq 0)]">
<xsl:variable name="position" select="position()"/>
<xsl:variable name="name" select="Agency"/>
<xsl:variable name="nlname" select="replace(Agency/@name,'\.','.&lt;!-¡-¡&gt;','!')"/>
<xsl:variable name="prefix" select="Prefix"/>
<xsl:variable name="prfx" select="replace(Prefix,'[^0-9]','')"/>
<xsl:text>private static Isbn assignRangeConstant</xsl:text><xsl:value-of select="$prfx"/>
<xsl:text>(String isbn) { try {
</xsl:text>
<xsl:for-each select="Rules/Rule">
<xsl:if test="not(Length eq '0')">
<xsl:variable name="rbeginstr" select="substring(Range,1,Length)"/>
<xsl:variable name="rbegin" select="replace(replace(substring(Range,1,Length),'^0+(?=[1-9])','','!'),'^0+','0','!')"/>
<xsl:variable name="rendstr" select="substring(Range,9,Length)"/>
<xsl:variable name="rend" select="replace(replace(substring(Range,9,Length),'^0+(?=[1-9])','','!'),'^0+','0','!')"/>
<xsl:choose>
<xsl:when test="position() = 1">
<xsl:text>if ((Integer.parseInt(REGISTRANT_ELEMENT.getComponent(isbn)) &gt;= </xsl:text>
<xsl:value-of select="$rbegin"/><xsl:text>) &amp;&amp; </xsl:text>
<xsl:text>(Integer.parseInt(REGISTRANT_ELEMENT.getComponent(isbn)) &lt;= </xsl:text>
<xsl:value-of select="$rend"/><xsl:text>)</xsl:text>
<xsl:text>
)
</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:text>else if ((Integer.parseInt(REGISTRANT_ELEMENT.getComponent(isbn)) &gt;= </xsl:text>
<xsl:value-of select="$rbegin"/><xsl:text>) &amp;&amp; </xsl:text>
<xsl:text>(Integer.parseInt(REGISTRANT_ELEMENT.getComponent(isbn)) &lt;= </xsl:text>
<xsl:value-of select="$rend"/><xsl:text>)</xsl:text>
<xsl:text>
)
</xsl:text>
</xsl:otherwise>
</xsl:choose>
<xsl:text>return </xsl:text>
<xsl:value-of select="$name"/><xsl:text>__</xsl:text><xsl:value-of select="$rbeginstr"/>
<xsl:text>_TO_</xsl:text><xsl:value-of select="$rendstr"/><xsl:text>_RANGE;
</xsl:text>
</xsl:if>
</xsl:for-each>
<xsl:text>
else return UNKNOWN_RANGE;
}
catch (Exception e) {return UNKNOWN_RANGE;}
</xsl:text>
<xsl:text>}
</xsl:text>
</xsl:for-each>
<xsl:for-each select="ISBNRangeMessage/RegistrationGroups/Group[count(Rules/Rule) eq 1 and number(Rules/Rule[1]/Length) eq 0]">
<xsl:variable name="prfx" select="replace(Prefix,'[^0-9]','')"/>
<xsl:text>private static Isbn assignRangeConstant</xsl:text><xsl:value-of select="$prfx"/>
<xsl:text>(String isbn) {
return NO_CURRENTLY_USED_RANGE;
}
</xsl:text>
</xsl:for-each>
<!-- getAgencyConstant() -->
<xsl:text>
/**
Called by constants that {@link #assignRangeConstant(String isbn) assignRangeConstant()} 
returns (RANGE constants) in order to obtain the corresponding type of constant that  
{@link #assignAgencyConstant(String isbn) assignAgencyConstant()} returns (an AGENCY constant); in other words, 
called by a RANGE constant (i.e., a constant that returns {@link #RANGE RANGE} when it calls {@link #getContext() getContext()}) in 
order to obtain an AGENCY constant (i.e., a constant that returns {@link #AGENCY AGENCY} when it calls {@link #getContext() getContext()}).
&lt;p&gt;
Can be seen as effectively converting a constant that represents a range to one that 
represents an agency:&lt;pre&gt;
	{@code Isbn nominallycovariantconstant = Isbn.ENGLISH_LANGUAGE_0__00_TO_19_RANGE;
	nominallycovariantconstant = nominallycovariantconstant.getAgencyConstant(); //now assigned to Isbn.ENGLISH_LANGUAGE_0}
&lt;pre&gt;
@return
&lt;ul&gt;
&lt;li&gt;
Returns the constant for the corresponding registration group when called by a constant that 
has a corresponding range instead of a corresponding registration group (i.e., the type returned when 
{@link #assignRangeConstant(String isbn) assignRangeConstant()} is called: a RANGE constant).
&lt;/li&gt;
&lt;li&gt;
Returns null when called by any other type of constant.
&lt;/li&gt;
&lt;/ul&gt;
*/
</xsl:text>
public Isbn getAgencyConstant() {
return null;
}
<!-- getMaximumAssigned() -->
<xsl:text>/**
Called principally by constants returned by {@link #assignRangeConstant(String isbn) assignRangeConstant()} 
(RANGE constants) in order to determine the number of prefixes available in a given range.
&lt;p&gt;
@return
&lt;ul&gt;
&lt;li&gt;
When called by a RANGE constant (i.e., the type of constant returned by {@link #assignRangeConstant(String isbn) assignRangeConstant()}), 
returns an integer representing the number of prefixes available in the range. For example, either &lt;pre&gt;
{@code Isbn.ENGLISH_LANGUAGE_0__00_TO_19_RANGE.getMaximumAssigned()}
&lt;/pre&gt;
or&lt;pre&gt;
{@code Isbn.assignRangeConstant("0192816179").getMaximumAssigned()}
&lt;/pre&gt;

returns 20.
&lt;/li&gt;
&lt;li&gt;
If a constant is the type returned when {@link #assignAgencyConstant(String isbn) assignAgencyConstant()} 
is called (an AGENCY constant), its &lt;code&gt;MAXIMUM_ASSIGNED&lt;/code&gt; attribute is set initially by the compiler to 0, and subsequently 
updated as a side effect each time that the constant's {@link #getComponent(String isbn) getComponent()} 
method is called. The constant in question will return its current value should it call &lt;code&gt;getMaximumAssigned()&lt;/code&gt;. 
The following declarations are equivalent:&lt;pre&gt;
{@code Isbn agencyconstant = Isbn.ENGLISH_LANGUAGE_0;
Isbn sameagencyconstant = Isbn.ENGLISH_LANGUAGE_0__00_TO_19_RANGE.getAgencyConstant();}

&lt;/pre&gt;
If either variable calls {@link #getComponent(String isbn) getComponent()}, one and the same 
&lt;code&gt;MAXIMUM_ASSIGNED&lt;/code&gt; integer attribute is updated:&lt;pre&gt;
{@code agencyconstant.getComponent("9780007236084");
//both agencyconstant.getMaximumAssigned() and sameagencyconstant.getMaximumAssigned() now return 20
sameagencyconstant.getComponent("0552137529");
//both agencyconstant.getMaximumAssigned() and sameagencyconstant.getMaximumAssigned() now return 269
agencyconstant.getComponent("0140114157");
//both agencyconstant.getMaximumAssigned() and sameagencyconstant.getMaximumAssigned() return 20 again}

&lt;/pre&gt;
The &lt;code&gt;Isbn&lt;/code&gt; type can change the value of &lt;code&gt;MAXIMUM_ASSIGNED&lt;/code&gt; at runtime for constants returned by 
{@link #assignAgencyConstant(String isbn) assignAgencyConstant()} (AGENCY constants), but never does so for 
constants returned by {@link #assignRangeConstant(String isbn) assignRangeConstant()} (RANGE constants).
&lt;/li&gt;
&lt;li&gt;
Constants that return {@link #COMPONENT Isbn.COMPONENT} or {@link #CONTEXT Isbn.CONTEXT} 
after calling {@link #getContext() getContext()} return 0 when they call &lt;code&gt;getMaximumAssigned()&lt;/code&gt;.
&lt;/li&gt;
&lt;/ul&gt;
*/
</xsl:text>
<xsl:text>public int getMaximumAssigned() {
return MAXIMUM_ASSIGNED;
}
</xsl:text>
<!-- allComponentsAsArray() -->
<xsl:text>/**
Furnishes the different parts of one or more ISBNs as a multidimensional array.
&lt;p&gt;
An ISBN is discarded if its prefix cannot be inferred based on RangeMessage.xml.
&lt;p&gt;
If an ISBN causes a {@link PoorISBNDataException PoorISBNDataException} to be 
thrown, &lt;code&gt;allComponentsAsArray()&lt;/code&gt; handles the exception, 
prints a message to stderr, and discards the ISBN.
&lt;p&gt;
The value returned by &lt;code&gt;allComponentsAsArray()&lt;/code&gt; is assigned to a variable as follows:&lt;pre id="example01"&gt;
			{@code String[] isbns = {"0415083699","2738424155","3518576348"};
			String[][][] results = Isbn.allComponentsAsArray(isbns);
			//String[][][] results = Isbn.allComponentsAsArray("0415083699","2738424155","3518576348"); //varargs}
&lt;/pre&gt;
Using the following syntax, the respective dimensions of the array produced by the above code 
can be accessed:
&lt;table cellspacing="35"&gt;
&lt;tr&gt;
&lt;td&gt;
SYNTAX:
&lt;/td&gt;
&lt;td&gt;
LENGTH:
&lt;/td&gt;
&lt;td&gt;
Details:
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
&lt;code&gt;results&lt;/code&gt;
&lt;/td&gt;
&lt;td&gt;
3 
&lt;/td&gt;
&lt;td&gt;
&lt;ul&gt;
&lt;li&gt;
The length is equal to the number of parameters passed to &lt;code&gt;allComponentsAsArray()&lt;/code&gt; (or to the length 
of the array object passed instead of varargs).
&lt;/li&gt;
&lt;li&gt;
The value of the variable is all three dimensions of the array, which is to say the array object overall. 
&lt;/li&gt;
&lt;/ul&gt;
&lt;hr&gt;
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
&lt;code&gt;results[0]&lt;/code&gt;
&lt;/td&gt;
&lt;td&gt;
13
&lt;/td&gt;
&lt;td&gt;
&lt;ul&gt;
&lt;li&gt;
The length is equal to the number of key/value pairs, which is only ever 13.
&lt;/li&gt;
&lt;li&gt;
The value that the brackets operator returns is the array of key-value pairs located at the specified index.
&lt;/li&gt;
&lt;ul&gt;
&lt;li&gt;
&lt;code&gt;results[1]&lt;/code&gt; would return the second array, which was generated when &lt;code&gt;"2738424155"&lt;/code&gt; was processed.
&lt;/li&gt;
&lt;li&gt;
&lt;code&gt;results[3]&lt;/code&gt; would cause an ArrayIndexOutofBoundsException: the maximum index is 2, because there 
are three arrays. Each array has exactly 13 members, but they cannot be accessed unless the 
brackets operator is repeated.
&lt;/li&gt;
&lt;/ul&gt;
&lt;/ul&gt;
&lt;hr&gt;
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
&lt;code&gt;results[0][0]&lt;/code&gt;&lt;pre&gt;
&lt;pre&gt;(optionally,&lt;pre&gt;&lt;pre&gt;results[0][0][0])
&lt;/td&gt;
&lt;td&gt;
2
&lt;/td&gt;
&lt;td&gt;
&lt;ul&gt;
&lt;li&gt;
The length is only ever equal to that of a key/value pair, which is to say 2.
&lt;/li&gt;
&lt;li&gt;
The value that the second brackets operator returns is a key/value pair.
&lt;/li&gt;
&lt;li&gt;
Furnishing the argument &lt;code&gt;0&lt;/code&gt; to a third (succeeding) brackets operator only ever causes a key to 
be returned, and furnishing the argument &lt;code&gt;1&lt;/code&gt; to a third (succeeding) brackets operator only ever causes 
a value to be returned.
&lt;/li&gt;
&lt;/ul&gt;
&lt;/td&gt;
&lt;/tr&gt;
&lt;/table&gt;
The very last of the above points is paramount. The only two possible values to pass to the 
third brackets operator without causing a runtime exception are &lt;code&gt;0&lt;/code&gt; (e.g., 0 % x, where x is greater 
than 0) and &lt;code&gt;1&lt;/code&gt; (e.g., 1 % x, where x is greater than one).
&lt;p&gt;
In order to read the &lt;code&gt;String&lt;/code&gt; values, a loop ultimately needs to take account of at least 
two array dimensions regardless of whether more than one parameter was passed to &lt;code&gt;allComponentsAsArray()&lt;/code&gt;, 
or whether there was only a single parameter:&lt;pre&gt;

			{@code for (int i = 0;i &lt; results.length;i++)
				   for (int j = 0;j &lt; results[i].length;j++) {
				   System.out.print(results[i][j][0] + " is ");
				   System.out.println(results[i][j][1]);}}
			
&lt;/pre&gt;Above, a second inner loop would have iterated over only two &lt;code&gt;String&lt;/code&gt;s, 
which already were different in kind to one another: the one assigned the 
even index was required by the code as a key, while that assigned the odd index was required 
by it as a value.
&lt;p&gt;
Not each and every conceivable iteration requires an inner loop in order to retrieve data:&lt;pre&gt;

			{@code for (int i = 0;i &lt; results.length;i++) {
				System.out.println(results[i][3][1]);
				System.out.println(results[i][0][1]);
			}
				   //Prints:
				   //9780  //the prefix of the first parameter ("0415083699")
				   //English language
				   //9782  //the prefix of the second parameter ("2738424155")
				   //French language
				   //9783  //the prefix of the third parameter ("3518576348")
				   //German language
				   }
				   
&lt;/pre&gt;The index of the PREFIX key/value pair already was known to be &lt;code&gt;3&lt;/code&gt;, and 
the index of the AGENCY_NAME key/value pair already was known to be &lt;code&gt;0&lt;/code&gt;. The mapping 
of the key/value pairs to array indexes is given below.
@param isbns One or more International Standard Book Numbers.
&lt;ul&gt;
&lt;li&gt;
ISBNs that cause {@link #assignAgencyConstant(String isbn) assignAgencyConstant()} 
to return {@link #UNKNOWN UNKNOWN} when passed as its parameter are discarded, and 
a message is written to stderr.
&lt;/li&gt;
&lt;li&gt;
ISBNs that cause a {@link PoorISBNDataException PoorISBNDataException} to be thrown 
are discarded.
&lt;/li&gt;
&lt;/ul&gt;
@return
Returns a three-dimensional array.&lt;pre&gt;&lt;/pre&gt;
&lt;ul&gt;
&lt;li&gt;
The size of the first array dimension is equal to the number of parameters passed, or the 
size of the array object passed as a parameter instead of varargs. Each element is an 
array of key/value pairs. The indexes and corresponding keys are as follows:&lt;table cellspacing="10"&gt;
&lt;tr&gt;&lt;td&gt;Index&lt;/td&gt;&lt;td&gt;Key&lt;/td&gt;&lt;td&gt;Index&lt;/td&gt;&lt;td&gt;Key&lt;/td&gt;&lt;/tr&gt;
&lt;tr&gt;&lt;td&gt;0&lt;/td&gt;&lt;td&gt;AGENCY_NAME&lt;/td&gt;&lt;td&gt;1&lt;/td&gt;&lt;td&gt;Agency constant&lt;/td&gt;&lt;/tr&gt;
&lt;tr&gt;&lt;td&gt;2&lt;/td&gt;&lt;td&gt;CHECK_DIGIT&lt;/td&gt;&lt;td&gt;3&lt;/td&gt;&lt;td&gt;PREFIX&lt;/td&gt;&lt;/tr&gt;
&lt;tr&gt;&lt;td&gt;4&lt;/td&gt;&lt;td&gt;PREFIX_OLD&lt;/td&gt;&lt;td&gt;5&lt;/td&gt;&lt;td&gt;PUBLICATION_ELEMENT&lt;/td&gt;&lt;/tr&gt;
&lt;tr&gt;&lt;td&gt;6&lt;/td&gt;&lt;td&gt;PUBLICATION_ELEMENT_EXTENT&lt;/td&gt;&lt;td&gt;7&lt;/td&gt;&lt;td&gt;PUBLICATION_ELEMENT_SIZE&lt;/td&gt;&lt;/tr&gt;
&lt;tr&gt;&lt;td&gt;8&lt;/td&gt;&lt;td&gt;Qualified registrant element&lt;/td&gt;&lt;td&gt;9&lt;/td&gt;&lt;td&gt;REGISTRANT_ELEMENT&lt;/td&gt;&lt;/tr&gt;
&lt;tr&gt;&lt;td&gt;10&lt;/td&gt;&lt;td&gt;REGISTRANT_ELEMENT_EXTENT&lt;/td&gt;&lt;td&gt;11&lt;/td&gt;&lt;td&gt;REGISTRANT_ELEMENT_SIZE&lt;/td&gt;&lt;/tr&gt;
&lt;tr&gt;&lt;td&gt;12&lt;/td&gt;&lt;td&gt;Range constant&lt;/td&gt;&lt;/tr&gt;
&lt;/table&gt;
&lt;/li&gt;
&lt;li&gt;
The size of the second array dimension is only ever 13. Each element is an array consisting of 
one key and one value. The integer indexes are as follows:&lt;table cellspacing="10"&gt;
&lt;tr&gt;&lt;td&gt;0&lt;/td&gt;&lt;td&gt;Key&lt;/td&gt;&lt;/tr&gt;
&lt;tr&gt;&lt;td&gt;1&lt;/td&gt;&lt;td&gt;Value&lt;/td&gt;&lt;/tr&gt;
&lt;/table&gt;
&lt;/li&gt;
&lt;li&gt;
The size of the third array dimension is only ever 2. The third array dimension stores the 
String data itself: the first element is a key, and the second element is a value.
&lt;/li&gt;
&lt;/ul&gt;
&lt;pre&gt;&lt;/pre&gt;
The first dimension of the array is accessed by using the name of the variable to which it is 
assigned followed by the brackets operator and the index of the desired array of key/value 
pairs (e.g. &lt;code&gt;results[0]&lt;/code&gt; for the first array).
&lt;p&gt;
The second dimension of the array is accessed by using the name of the variable to which it is 
assigned followed by the brackets operator and the index number of the desired array of key/value 
pairs, followed by a second brackets operator and the index number (0-12) of the desired key/value 
pair (e.g. &lt;code&gt;results[0][0]&lt;/code&gt; for the first key/value pair in the first array).
&lt;p&gt;
The third dimension of the array is accessed by using the name of the variable to which it is 
assigned followed by the brackets operator and the index number of the desired array of key/value 
pairs, followed by a second brackets operator and the index number (0-12) of the desired key/value pair, 
followed by a third (and final) brackets operator and the index number of either the key (index 0) or 
the value (index 1): for example, &lt;code&gt;results[0][0][1]&lt;/code&gt; for the value of the 
first key/value pair in the first array.
@see #allComponentsMinKeys(String isbn)
@see #allComponentsAddedKeys(String isbn)
@see #allComponentsAsJson(String... isbns)
@see JsonIsbn
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementExtent(String isbn)
*/
</xsl:text>
<xsl:text>public static String[][][] allComponentsAsArray(String... isbns) {
//String[][][] results = new String[isbns.length][13][2];
ArrayList&lt;String[][]&gt; arrays = new ArrayList&lt;&gt;();  
for (int i = 0;i &lt; isbns.length;i++) {
String isbn = isbns[i];
try {
isbn = isbnThirteen(isbns[i]);
}
catch (PoorISBNDataException e) {
System.err.println(isbn);
e.printStackTrace();
continue;
}
if (Isbn.assignAgencyConstant(isbn) == Isbn.UNKNOWN |
	Isbn.assignAgencyConstant(isbn).getComponent(isbn).equals("")) {
System.err.println("There was a difficulty with " + isbn + ",");
System.err.println("so it has been discarded.");
System.err.println("The Enum Constant Summary section of the Isbn type's");
System.err.println("javadoc, or the current version of RangeMessage.xml,");
System.err.println("should be consulted in order to determine whether");
System.err.println("it is possible that the ISBN is de jure invalid.");
continue;
}
String[][] result = new String[13][2];
//AGENCY_NAME.name(),AGENCY_NAME.getComponent(isbn)
result[0][0] = AGENCY_NAME.name(); 
result[0][1] = AGENCY_NAME.getComponent(isbn);
//"Agency constant",assignAgencyConstant(isbn).name()
result[1][0] = "Agency constant"; 
result[1][1] = assignAgencyConstant(isbn).name();
//CHECK_DIGIT.name(),CHECK_DIGIT.getComponent(isbn)
result[2][0] = CHECK_DIGIT.name();
result[2][1] = CHECK_DIGIT.getComponent(isbn);
//PREFIX.name(),PREFIX.getComponent(isbn)
result[3][0] = PREFIX.name();
result[3][1] = PREFIX.getComponent(isbn);
//PREFIX_OLD.name(),PREFIX_OLD.getComponent(isbn)
result[4][0] = PREFIX_OLD.name();
result[4][1] = PREFIX_OLD.getComponent(isbn);
//PUBLICATION_ELEMENT.name(),PUBLICATION_ELEMENT.getComponent(isbn)
result[5][0] = PUBLICATION_ELEMENT.name();
result[5][1] = PUBLICATION_ELEMENT.getComponent(isbn);
//PUBLICATION_ELEMENT_EXTENT.name(),PUBLICATION_ELEMENT_EXTENT.getComponent(isbn)
result[6][0] = PUBLICATION_ELEMENT_EXTENT.name();
result[6][1] = PUBLICATION_ELEMENT_EXTENT.getComponent(isbn);
//PUBLICATION_ELEMENT_SIZE.name(),PUBLICATION_ELEMENT_SIZE.getComponent(isbn)
result[7][0] = PUBLICATION_ELEMENT_SIZE.name();
result[7][1] = PUBLICATION_ELEMENT_SIZE.getComponent(isbn);
//"Qualified registrant element",assignAgencyConstant(isbn).getComponent(isbn)
result[8][0] = "Qualified registrant element";
result[8][1] = assignAgencyConstant(isbn).getComponent(isbn);
//REGISTRANT_ELEMENT.name(),REGISTRANT_ELEMENT.getComponent(isbn)
result[9][0] = REGISTRANT_ELEMENT.name();
result[9][1] = REGISTRANT_ELEMENT.getComponent(isbn);
//REGISTRANT_ELEMENT_EXTENT.name(),REGISTRANT_ELEMENT_EXTENT.getComponent(isbn)
result[10][0] = REGISTRANT_ELEMENT_EXTENT.name();
result[10][1] = REGISTRANT_ELEMENT_EXTENT.getComponent(isbn);
//REGISTRANT_ELEMENT_SIZE.name(),REGISTRANT_ELEMENT_SIZE.getComponent(isbn)
result[11][0] = REGISTRANT_ELEMENT_SIZE.name();
result[11][1] = REGISTRANT_ELEMENT_SIZE.getComponent(isbn);
//"Range constant",assignRangeConstant(isbn).name()
result[12][0] = "Range constant";
result[12][1] = assignRangeConstant(isbn).name();
arrays.add(result);
}
String[][][] results = new String[arrays.size()][13][2];
for (int i = 0;i &lt; arrays.size();i++) results[i] = arrays.get(i); 
return results;
}
</xsl:text>
<!-- allComponentsAsJson() with one parameter -->
<xsl:text>/**
Calls {@link allComponentsMinKeys(String isbn) allComponentsMinKeys()} and subsequently produces a 
&lt;code&gt;String&lt;/code&gt; in JSON format; if multiple parameters are passed, a JSON string is produced for each. By 
default, a newline character is included only after the closing brace of the JSON string that is 
produced.
&lt;p&gt;
An ISBN is discarded if its prefix cannot be inferred based on RangeMessage.xml.
&lt;p&gt;
If an ISBN causes a {@link PoorISBNDataException PoorISBNDataException} to be 
thrown, &lt;code&gt;allComponentsAsJson()&lt;/code&gt; handles the exception, 
prints a message to stderr, and discards the ISBN.
@param isbns One or more International Standard Book Numbers in either 10-digit or 13-digit format.
&lt;p&gt;
&lt;ul&gt;
&lt;li&gt;
If the first parameter passed is the &lt;code&gt;String&lt;/code&gt; literal &lt;code&gt;"true"&lt;/code&gt; or its equivalent, the output will 
contain newlines after each key/value pair. An overloaded version of the &lt;code&gt;allComponentsAsJson()&lt;/code&gt;  
method ({@link #allComponentsAsJson(boolean newlines,String... isbn) allComponentsAsJson(boolean newlines,String... isbn)}) 
permits the caller to explicitly turn newlines off and on.
&lt;/li&gt;
&lt;li&gt;
Otherwise, the output will contain newline characters only after each JSON string's closing brace.
&lt;/li&gt;
&lt;li&gt;
ISBNs that cause {@link #assignAgencyConstant(String isbn) assignAgencyConstant()} 
to return {@link #UNKNOWN UNKNOWN} when passed as its parameter are discarded, and 
a message is written to stderr.
&lt;/li&gt;
&lt;li&gt;
ISBNs that cause a {@link PoorISBNDataException PoorISBNDataException} to be thrown 
are discarded, and a message is written to stderr.
&lt;/li&gt;
&lt;/ul&gt;
@return
A {@link java.lang.String String} object in JSON format, or a concatenation of two or more {@link java.lang.String String} 
objects in JSON format, all of which contain the following keys:&lt;pre&gt;
&lt;/pre&gt;&lt;table align="center" 
cellspacing="1" cellpadding="7"&gt;
&lt;tr&gt;
&lt;td&gt;
AGENCY_NAME
&lt;/td&gt;
&lt;td&gt;
Agency constant
&lt;/td&gt;
&lt;td&gt;
CHECK_DIGIT
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
PREFIX
&lt;/td&gt;
&lt;td&gt;
PREFIX_OLD
&lt;/td&gt;
&lt;td&gt;
PUBLICATION_ELEMENT
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
PUBLICATION_ELEMENT_EXTENT
&lt;/td&gt;
&lt;td&gt;
PUBLICATION_ELEMENT_SIZE
&lt;/td&gt;
&lt;td&gt;
Qualified registrant element
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
REGISTRANT_ELEMENT
&lt;/td&gt;
&lt;td&gt;
REGISTRANT_ELEMENT_EXTENT
&lt;/td&gt;
&lt;td&gt;
REGISTRANT_ELEMENT_SIZE
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
Range constant
&lt;/td&gt;
&lt;/tr&gt;
&lt;/table&gt;
@see #allComponentsAsJson(boolean newlines,String... isbn)
@see #allComponentsAsArray(String... isbns)
@see #allComponentsMinKeys(String isbn)
@see JsonIsbn
@see #allComponentsAddedKeys(String isbn)
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementExtent(String isbn)
*/
</xsl:text>
<xsl:text>public static String allComponentsAsJson(String... isbns) {
if (isbns[0].equals("true")) {
StringBuilder json = new StringBuilder();
for (int i = 1;i &lt; isbns.length;i++) {
String isbn = isbns[i];
try {
isbn = isbnThirteen(isbns[i]);
}
catch (PoorISBNDataException e){
System.err.println(isbn);
e.printStackTrace();
continue;
}
if (Isbn.assignAgencyConstant(isbn) == Isbn.UNKNOWN |
	Isbn.assignAgencyConstant(isbn).getComponent(isbn).equals("")) {
System.err.println("There was a difficulty with " + isbn + ",");
System.err.println("so it has been discarded.");
System.err.println("The Enum Constant Summary section of the Isbn type's");
System.err.println("javadoc, or the current version of RangeMessage.xml,");
System.err.println("should be consulted in order to determine whether");
System.err.println("it is possible that the ISBN is de jure invalid.");
continue;
}
TreeMap&lt;String,String&gt; components = allComponentsMinKeys(isbn);
json.append("{\n");
String[] keys = components.keySet().toArray(new String[components.size()]);
for (int ii = 0;ii &lt; keys.length;ii++) {
	if (ii == keys.length - 1) {
	json.append("\"" + keys[ii] + "\" : \"" + components.get(keys[ii]) + "\"\n");
	}
	else {
	json.append("\"" + keys[ii] + "\" : \"" + components.get(keys[ii]) + "\",\n"); 
	}
}
json.append("}\n");
}
return json.toString();
}
else {
StringBuilder json = new StringBuilder();
for (int i = 0;i &lt; isbns.length;i++) {
String isbn = isbns[i];
try {
isbn = isbnThirteen(isbns[i]);
}
catch (PoorISBNDataException e) {
System.err.println(isbn);
e.printStackTrace();
continue;
}
if (Isbn.assignAgencyConstant(isbn) == Isbn.UNKNOWN |
	Isbn.assignAgencyConstant(isbn).getComponent(isbn).equals("")) {
System.err.println("There was a difficulty with " + isbn + ",");
System.err.println("so it has been discarded.");
System.err.println("The Enum Constant Summary section of the Isbn type's");
System.err.println("javadoc, or the current version of RangeMessage.xml,");
System.err.println("should be consulted in order to determine whether");
System.err.println("it is possible that the ISBN is de jure invalid.");
continue;
}
TreeMap&lt;String,String&gt; components = allComponentsMinKeys(isbn);
json.append("{");
String[] keys = components.keySet().toArray(new String[components.size()]);
for (int ii = 0;ii &lt; keys.length;ii++) {
	if (ii == keys.length - 1) {
	json.append("\"" + keys[ii] + "\" : \"" + components.get(keys[ii]) + "\"");
	}
	else {
	json.append("\"" + keys[ii] + "\" : \"" + components.get(keys[ii]) + "\","); 
	}
}
json.append("}\n");
}
return json.toString();
}
}
</xsl:text>
<!-- allComponentsAsJson() with two parameters() -->
<xsl:text>/**
Calls {@link allComponentsMinKeys(String isbn) allComponentsMinKeys()} and subsequently produces a 
&lt;code&gt;String&lt;/code&gt; in JSON format; if multiple parameters are passed, a JSON string is produced for each.
&lt;p&gt;
An ISBN is discarded if its prefix cannot be inferred based on RangeMessage.xml.
&lt;p&gt;
If an ISBN causes a {@link PoorISBNDataException PoorISBNDataException} to be 
thrown, &lt;code&gt;allComponentsAsJson()&lt;/code&gt; handles the exception, 
prints a message to stderr, and discards the ISBN.
@param newlines &lt;ul&gt;
&lt;li&gt;
If &lt;code&gt;true&lt;/code&gt; is passed as the value of newlines, the output will contain newlines after each key/value pair. 
&lt;/li&gt;
&lt;li&gt;
If &lt;code&gt;false&lt;/code&gt; is passed as the value of newlines, the output will contain newline characters only after each 
JSON string's closing brace. This is the default behavior when {@link #allComponentsAsJson(String... isbn) allComponentsAsJson(String... isbn)} 
is called.
&lt;/li&gt;
&lt;/ul&gt;
@param isbns One or more International Standard Book Numbers in either 10-digit or 13-digit format.
&lt;ul&gt;
&lt;li&gt;
ISBNs that cause {@link #assignAgencyConstant(String isbn) assignAgencyConstant()} 
to return {@link #UNKNOWN UNKNOWN} when passed as its parameter are discarded, and 
a message is written to stderr.
&lt;/li&gt;
&lt;li&gt;
ISBNs that cause a {@link PoorISBNDataException PoorISBNDataException} to be thrown 
are discarded, and a message is written to stderr.
&lt;/li&gt;
&lt;/ul&gt;
@return
A {@link java.lang.String String} object in JSON format, or a concatenation of two or more {@link java.lang.String String} 
objects in JSON format, all of which contain the following keys:&lt;pre&gt;
&lt;/pre&gt;&lt;table align="center" 
cellspacing="1" cellpadding="7"&gt;
&lt;tr&gt;
&lt;td&gt;
AGENCY_NAME
&lt;/td&gt;
&lt;td&gt;
Agency constant
&lt;/td&gt;
&lt;td&gt;
CHECK_DIGIT
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
PREFIX
&lt;/td&gt;
&lt;td&gt;
PREFIX_OLD
&lt;/td&gt;
&lt;td&gt;
PUBLICATION_ELEMENT
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
PUBLICATION_ELEMENT_EXTENT
&lt;/td&gt;
&lt;td&gt;
PUBLICATION_ELEMENT_SIZE
&lt;/td&gt;
&lt;td&gt;
Qualified registrant element
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
REGISTRANT_ELEMENT
&lt;/td&gt;
&lt;td&gt;
REGISTRANT_ELEMENT_EXTENT
&lt;/td&gt;
&lt;td&gt;
REGISTRANT_ELEMENT_SIZE
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
Range constant
&lt;/td&gt;
&lt;/tr&gt;
&lt;/table&gt;
@see #allComponentsAsJson(String... isbn)
@see #allComponentsAsArray(String... isbns)
@see #allComponentsMinKeys(String isbn)
@see JsonIsbn
@see #allComponentsAddedKeys(String isbn)
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementExtent(String isbn)
*/
</xsl:text>
<xsl:text>public static String allComponentsAsJson(boolean newlines,String... isbns) {
if (newlines == true) {
StringBuilder json = new StringBuilder();
for (int i = 0;i &lt; isbns.length;i++) {
String isbn = isbns[i];
try {
isbn = isbnThirteen(isbns[i]);
}
catch (PoorISBNDataException e) {
System.err.println(isbn);
e.printStackTrace();
continue;
}
if (Isbn.assignAgencyConstant(isbn) == Isbn.UNKNOWN |
	Isbn.assignAgencyConstant(isbn).getComponent(isbn).equals("")) {
System.err.println("There was a difficulty with " + isbn + ",");
System.err.println("so it has been discarded.");
System.err.println("The Enum Constant Summary section of the Isbn type's");
System.err.println("javadoc, or the current version of RangeMessage.xml,");
System.err.println("should be consulted in order to determine whether");
System.err.println("it is possible that the ISBN is de jure invalid.");
continue;
}
TreeMap&lt;String,String&gt; components = allComponentsMinKeys(isbn);
json.append("{\n");
String[] keys = components.keySet().toArray(new String[components.size()]);
for (int ii = 0;ii &lt; keys.length;ii++) {
	if (ii == keys.length - 1) {
	json.append("\"" + keys[ii] + "\" : \"" + components.get(keys[ii]) + "\"\n");
	}
	else {
	json.append("\"" + keys[ii] + "\" : \"" + components.get(keys[ii]) + "\",\n"); 
	}
}
json.append("}\n");
}
return json.toString();
}
else {
StringBuilder json = new StringBuilder();
for (int i = 0;i &lt; isbns.length;i++) {
String isbn = isbns[i];
try {
isbn = isbnThirteen(isbns[i]);
}
catch (PoorISBNDataException e) {
System.err.println(isbn);
e.printStackTrace();
continue;
}
if (Isbn.assignAgencyConstant(isbn) == Isbn.UNKNOWN |
	Isbn.assignAgencyConstant(isbn).getComponent(isbn).equals("")) {
System.err.println("There was a difficulty with " + isbn + ",");
System.err.println("so it has been discarded.");
System.err.println("The Enum Constant Summary section of the Isbn type's");
System.err.println("javadoc, or the current version of RangeMessage.xml,");
System.err.println("should be consulted in order to determine whether");
System.err.println("it is possible that the ISBN is de jure invalid.");
continue;
}
TreeMap&lt;String,String&gt; components = allComponentsMinKeys(isbn);
json.append("{");
String[] keys = components.keySet().toArray(new String[components.size()]);
for (int ii = 0;ii &lt; keys.length;ii++) {
	if (ii == keys.length - 1) {
	json.append("\"" + keys[ii] + "\" : \"" + components.get(keys[ii]) + "\"");
	}
	else {
	json.append("\"" + keys[ii] + "\" : \"" + components.get(keys[ii]) + "\","); 
	}
}
json.append("}\n");
}
return json.toString();
}
}
</xsl:text>
<!-- allComponentsMinKeys() -->
<xsl:text>/**
Furnishes a sorted map containing the corresponding data for the International Standard Book Number passed as an argument; 
omits two of the keys produced when {@link #allComponentsAddedKeys(String isbn) allComponentsAddedKeys()} is called instead.
&lt;p&gt;
&lt;ul&gt;
&lt;li&gt;
&lt;code&gt;allComponentsMinKeys()&lt;/code&gt;  produces the same set of keys each time that it is called
&lt;/li&gt;
&lt;li&gt;
{@link #allComponentsAddedKeys(String isbn) allComponentsAddedKeys()} produces an additional two keys the names of which are 
assigned at runtime, and can be called if one is planning to pass an arbitrary AGENCY or RANGE 
constant's &lt;code&gt;String&lt;/code&gt; equivalent to the &lt;code&gt;TreeMap&lt;/code&gt; class's {@link java.util.TreeMap#get(Object key) get()} method later.
&lt;/li&gt;
&lt;/ul&gt;
&lt;p&gt;
Called by the &lt;code&gt;Isbn&lt;/code&gt; type's &lt;code&gt;main()&lt;/code&gt; method.
@param isbn An International Standard Book Number, in either 10-digit or 13-digit format.
@return Returns a {@link java.util.TreeMap TreeMap} containing the following keys:&lt;pre&gt;
&lt;/pre&gt;&lt;table align="center" 
cellspacing="1" cellpadding="7"&gt;
&lt;tr&gt;
&lt;td&gt;
AGENCY_NAME
&lt;/td&gt;
&lt;td&gt;
Agency constant
&lt;/td&gt;
&lt;td&gt;
CHECK_DIGIT
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
PREFIX
&lt;/td&gt;
&lt;td&gt;
PREFIX_OLD
&lt;/td&gt;
&lt;td&gt;
PUBLICATION_ELEMENT
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
PUBLICATION_ELEMENT_EXTENT
&lt;/td&gt;
&lt;td&gt;
PUBLICATION_ELEMENT_SIZE
&lt;/td&gt;
&lt;td&gt;
Qualified registrant element
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
REGISTRANT_ELEMENT
&lt;/td&gt;
&lt;td&gt;
REGISTRANT_ELEMENT_EXTENT
&lt;/td&gt;
&lt;td&gt;
REGISTRANT_ELEMENT_SIZE
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
Range constant
&lt;/td&gt;
&lt;/tr&gt;
&lt;/table&gt;
@exception Throws a {@link CannotInferPrefixException CannotInferPrefixException} if {@link #UNKNOWN UNKNOWN} 
is returned upon a call to {@link #assignAgencyConstant(String isbn) assignAgencyConstant()}.
&lt;ul&gt;
&lt;li&gt;
{@link #UNKNOWN UNKNOWN} is returned by {@link #assignAgencyConstant(String isbn) assignAgencyConstant()} 
if the ISBN's prefix cannot be inferred based on RangeMessage.xml.
&lt;/li&gt;
&lt;li&gt;
In the same circumstances, {@link #allComponentsAsJson(String... isbns) allComponentsAsJson()}  
and {@link #allComponentsAsArray(String... isbns) allComponentsAsArray()} discard the ISBN 
and print a message to stderr rather than throw an exception.
&lt;/li&gt;
&lt;ul&gt;
&lt;li&gt;
{@link #allComponentsAddedKeys(String isbn) allComponentsAddedKeys()}, by contrast, throws a 
{@link CannotInferPrefixException CannotInferPrefixException}.
&lt;/li&gt;
&lt;/ul&gt;
&lt;/ul&gt;
@see #allComponentsAsArray(String... isbns)
@see #allComponentsAsJson(String... isbns)
@see JsonIsbn
@see #allComponentsAddedKeys(String isbn)
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementExtent(String isbn)
*/
</xsl:text>
<xsl:text>public static TreeMap&lt;String,String&gt; allComponentsMinKeys(String isbn){
	isbn = isbnThirteen(isbn);
	if (Isbn.assignAgencyConstant(isbn) == Isbn.UNKNOWN) 
	throw new CannotInferPrefixException("\nThere was a difficulty with\n" + isbn + ".\n\n" 
	+ "The similar methods declared by the Isbn type that accept\n" +
	"varargs (allComponentsAsArray(), allComponentsAsJson()) can\n" +
	"take " + isbn + " as a parameter without throwing an exception.\n" +
	"They will print a message to the standard error stream instead, \n" +
	"discard " + isbn + ", and continue running. The JsonIsbn class\n" +
	"defined elsewhere in this package offers the same functionality\n" +
	"from the command line as allComponentsAsJson() does from code.\n\n" +
	"The Enum Constant Summary section of the Isbn type's javadoc,\n" +
	"or RangeMessage.xml, should be consulted in order to determine\n" +
	"whether it is possible that " + isbn + " is de jure invalid.");
	TreeMap&lt;String,String&gt; components = new TreeMap&lt;&gt;();
	// Qualified registrant element
	components.put("Qualified registrant element",assignAgencyConstant(isbn).getComponent(isbn));
	// Agency constant
	components.put("Agency constant",assignAgencyConstant(isbn).name());
	// PREFIX
	components.put(PREFIX.name(),PREFIX.getComponent(isbn));
	// PREFIX_OLD
	components.put(PREFIX_OLD.name(),PREFIX_OLD.getComponent(isbn));
	// AGENCY_NAME
	components.put(AGENCY_NAME.name(),AGENCY_NAME.getComponent(isbn));
	// REGISTRANT_ELEMENT
	components.put(REGISTRANT_ELEMENT.name(),REGISTRANT_ELEMENT.getComponent(isbn));
	// PUBLICATION_ELEMENT
	components.put(PUBLICATION_ELEMENT.name(),PUBLICATION_ELEMENT.getComponent(isbn));
	// CHECK_DIGIT
	components.put(CHECK_DIGIT.name(),CHECK_DIGIT.getComponent(isbn));
	// REGISTRANT_ELEMENT_SIZE
	components.put(REGISTRANT_ELEMENT_SIZE.name(),REGISTRANT_ELEMENT_SIZE.getComponent(isbn));
	// PUBLICATION_ELEMENT_SIZE
	components.put(PUBLICATION_ELEMENT_SIZE.name(),PUBLICATION_ELEMENT_SIZE.getComponent(isbn));
	// PUBLICATION_ELEMENT_EXTENT
	components.put(PUBLICATION_ELEMENT_EXTENT.name(),PUBLICATION_ELEMENT_EXTENT.getComponent(isbn));
	// REGISTRANT_ELEMENT_EXTENT
	components.put(REGISTRANT_ELEMENT_EXTENT.name(),REGISTRANT_ELEMENT_EXTENT.getComponent(isbn));
	// Range constant
	components.put("Range constant",assignRangeConstant(isbn).name());
	return components;
	}
</xsl:text>
<!-- allComponentsAddedKeys() -->
<xsl:text>/**
Furnishes a sorted map containing the corresponding data for the International Standard Book Number passed as an argument.
&lt;p&gt;
&lt;ul&gt;
&lt;li&gt;
{@link allComponentsMinKeys(String isbn) allComponentsMinKeys()} produces the same set of keys each time that it is called
&lt;/li&gt;
&lt;li&gt;
&lt;code&gt;allComponentsAddedKeys()&lt;/code&gt; produces an additional two keys the names of which are 
assigned at runtime, and can be called if one is planning to pass an arbitrary AGENCY or RANGE 
constant's &lt;code&gt;String&lt;/code&gt; equivalent to the &lt;code&gt;TreeMap&lt;/code&gt; class's {@link java.util.TreeMap#get(Object key) get()} method later.
&lt;/li&gt;
&lt;/ul&gt;
@param isbn An International Standard Book Number, in either 10-digit or 13-digit format.
@return A {@link java.util.TreeMap TreeMap} the keys of which are the names of the relevant constants, plus one called "Agency constant"
for the name of the ISBN's corresponding type, one called "Range constant" for the range in which the ISBN 
falls within its registrant group, one called "Qualified registrant element" concatenating the prefix  
and the registrant element, and also one consisting of the name of the ISBN's corresponding AGENCY constant.
&lt;p&gt;
To put it differently, the keys in tabular form are as follows (the position in the sorted order of those 
in brackets shall vary):
&lt;table align="center" 
cellspacing="1" cellpadding="7"&gt;
&lt;tr&gt;
&lt;td&gt;
[AGENCY constant identifier]
&lt;/td&gt;
&lt;td&gt;
[RANGE constant identifier]
&lt;/td&gt;
&lt;td&gt;
Agency Constant
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
AGENCY_NAME
&lt;/td&gt;
&lt;td&gt;
CHECK_DIGIT
&lt;/td&gt;
&lt;td&gt;
PREFIX
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
PREFIX_OLD
&lt;/td&gt;
&lt;td&gt;
PUBLICATION_ELEMENT
&lt;/td&gt;
&lt;td&gt;
PUBLICATION_ELEMENT_EXTENT
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
PUBLICATION_ELEMENT_SIZE
&lt;/td&gt;
&lt;td&gt;
Qualified registrant element
&lt;/td&gt;
&lt;td&gt;
REGISTRANT_ELEMENT
&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;
REGISTRANT_ELEMENT_EXTENT
&lt;/td&gt;
&lt;td&gt;
REGISTRANT_ELEMENT_SIZE
&lt;/td&gt;
&lt;td&gt;
Range constant
&lt;/td&gt;
&lt;/tr&gt;
&lt;/table&gt;
@exception Throws a {@link CannotInferPrefixException CannotInferPrefixException} if {@link #UNKNOWN UNKNOWN} 
is returned upon a call to {@link #assignAgencyConstant(String isbn) assignAgencyConstant()}.
&lt;ul&gt;
&lt;li&gt;
{@link #UNKNOWN UNKNOWN} is returned by {@link #assignAgencyConstant(String isbn) assignAgencyConstant()} 
if the ISBN's prefix cannot be inferred based on RangeMessage.xml.
&lt;/li&gt;
&lt;li&gt;
In the same circumstances, {@link #allComponentsAsJson(String... isbns) allComponentsAsJson()}  
and {@link #allComponentsAsArray(String... isbns) allComponentsAsArray()} discard the ISBN 
and print a message to stderr rather than throw an exception.
&lt;/li&gt;
&lt;ul&gt;
&lt;li&gt;
{@link #allComponentsMinKeys(String isbn) allComponentsMinKeys()}, by contrast, throws a 
{@link CannotInferPrefixException CannotInferPrefixException}.
&lt;/li&gt;
&lt;/ul&gt;
&lt;/ul&gt;
@see #allComponentsMinKeys(String isbn)
@see #allComponentsAsArray(String... isbns)
@see #allComponentsAsJson(String... isbns)
@see JsonIsbn
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementExtent(String isbn)
*/
</xsl:text>
<xsl:text>public static TreeMap&lt;String,String&gt; allComponentsAddedKeys(String isbn){
	isbn = isbnThirteen(isbn);
	if (Isbn.assignAgencyConstant(isbn) == Isbn.UNKNOWN) 
	throw new CannotInferPrefixException("\nThere was a difficulty with\n" + isbn + ".\n\n" 
	+ "The similar methods declared by the Isbn type that accept\n" +
	"varargs (allComponentsAsArray(), allComponentsAsJson()) can\n" +
	"take " + isbn + " as a parameter without throwing an exception.\n" +
	"They will print a message to the standard error stream instead, \n" +
	"discard " + isbn + ", and continue running. The JsonIsbn class\n" +
	"defined elsewhere in this package offers the same functionality\n" +
	"from the command line as allComponentsAsJson() does from code.\n\n" +
	"The Enum Constant Summary section of the Isbn type's javadoc,\n" +
	"or RangeMessage.xml, should be consulted in order to determine\n" +
	"whether it is possible that " + isbn + " is de jure invalid.");
	TreeMap&lt;String,String&gt; components = new TreeMap&lt;&gt;();
	components.put(assignAgencyConstant(isbn).name(),assignAgencyConstant(isbn).getComponent(isbn));
	components.put("Qualified registrant element",assignAgencyConstant(isbn).getComponent(isbn));
	components.put("Agency constant",assignAgencyConstant(isbn).name());
	components.put(PREFIX.name(),PREFIX.getComponent(isbn));
	components.put(PREFIX_OLD.name(),PREFIX_OLD.getComponent(isbn));
	components.put(AGENCY_NAME.name(),AGENCY_NAME.getComponent(isbn));
	components.put(PREFIX.name(),PREFIX.getComponent(isbn));
	components.put(REGISTRANT_ELEMENT.name(),REGISTRANT_ELEMENT.getComponent(isbn));
	components.put(PUBLICATION_ELEMENT.name(),PUBLICATION_ELEMENT.getComponent(isbn));
	components.put(CHECK_DIGIT.name(),CHECK_DIGIT.getComponent(isbn));
	components.put(REGISTRANT_ELEMENT_SIZE.name(),REGISTRANT_ELEMENT_SIZE.getComponent(isbn));
	components.put(PUBLICATION_ELEMENT_SIZE.name(),PUBLICATION_ELEMENT_SIZE.getComponent(isbn));
	components.put(PUBLICATION_ELEMENT_EXTENT.name(),PUBLICATION_ELEMENT_EXTENT.getComponent(isbn));
	components.put(REGISTRANT_ELEMENT_EXTENT.name(),REGISTRANT_ELEMENT_EXTENT.getComponent(isbn));
	components.put("Range constant",assignRangeConstant(isbn).name());
	components.put(assignRangeConstant(isbn).name(),Integer.toString(assignRangeConstant(isbn).getMaximumAssigned()));
	return components;
	}
</xsl:text>
<!-- getPrefix() -->
<xsl:text>/**
Accepts an ISBN in 10-digit or 13-digit format as input and returns a {@link java.lang.String String} consisting of 
the agency's prefix preceded by the EAN/UCC prefix. For example:&lt;pre&gt;
			{@code Isbn.getPrefix("9780143127055"); //returns "9780"}
.&lt;/pre&gt;
@param isbn An International Standard Book Number in either 10-digit or 13-digit format.
@return
A {@link java.lang.String String} consisting of the agency's prefix preceded by the EAN/UCC prefix.
@see #allComponentsAsArray(String... isbns)
@see #allComponentsAsJson(String... isbns)
@see JsonIsbn
@see #allComponentsAddedKeys(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementSizeAsInt(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getRegistrantElementExtentAsInt(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementSizeAsInt(String isbn)
@see #getPublicationElementExtent(String isbn)
@see #getPublicationElementExtentAsInt(String isbn)
@see #PREFIX
*/
</xsl:text>
<xsl:text>
public static String getPrefix(String isbn) {
isbn = isbnThirteen(isbn);
return PREFIX.getComponent(isbn);
}
</xsl:text>
<!-- getPrefixOld -->
<xsl:text>/**
Accepts an ISBN in 10-digit or 13-digit format as input and returns a {@link java.lang.String String} consisting of 
the agency's prefix without the EAN/UCC prefix that 13-digit ISBNs incorporate. For example:&lt;pre&gt;
			{@code Isbn.getPrefixOld("0140029648"); //returns "0"
			Isbn.getPrefix("0140029648"); //returns "9780"}
.&lt;/pre&gt;
@param isbn An International Standard Book Number in either 10-digit or 13-digit format.
@return
A {@link java.lang.String String} consisting of the agency's prefix without the EAN/UCC prefix that 13-digit ISBNs incorporate.
@see #allComponentsAsArray(String... isbns)
@see #allComponentsAsJson(String... isbns)
@see JsonIsbn
@see #allComponentsAddedKeys(String isbn)
@see #getPrefix(String isbn)
@see #getAgencyName(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementSizeAsInt(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getRegistrantElementExtentAsInt(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementSizeAsInt(String isbn)
@see #getPublicationElementExtent(String isbn)
@see #getPublicationElementExtentAsInt(String isbn)
@see #PREFIX_OLD
*/
</xsl:text>
<xsl:text>
public static String getPrefixOld(String isbn) {
isbn = isbnThirteen(isbn);
return PREFIX_OLD.getComponent(isbn);
}
</xsl:text>
<!-- getAgencyName() -->
<xsl:text>/**
Accepts an ISBN in 10-digit or 13-digit format as input and returns a {@link java.lang.String String} consisting of 
the name that occurs in RangeMessage.&lt;!----&gt;xml's Agency element. For example:&lt;pre&gt;
			{@code Isbn.getAgencyName("9789953335643"); //returns "Lebanon"}
.&lt;/pre&gt;
@param isbn An International Standard Book Number in either 10-digit or 13-digit format.
@return
A {@link java.lang.String String} consisting of the name that occurs in 
RangeMessage.&lt;!----&gt;xml's Agency element.
@see #allComponentsAsArray(String... isbns)
@see #allComponentsAsJson(String... isbns)
@see JsonIsbn
@see #allComponentsAddedKeys(String isbn)
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementSizeAsInt(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getRegistrantElementExtentAsInt(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementSizeAsInt(String isbn)
@see #getPublicationElementExtent(String isbn)
@see #getPublicationElementExtentAsInt(String isbn)
@see #AGENCY_NAME
*/
</xsl:text>
<xsl:text>
public static String getAgencyName(String isbn) {
isbn = isbnThirteen(isbn);
return AGENCY_NAME.getComponent(isbn);
}
</xsl:text>
<!-- getQualifiedRegistrantElement() -->
<xsl:text>/**
Accepts an ISBN in 10-digit or 13-digit format as input and returns a {@link java.lang.String String} consisting of 
a concatenation of the prefix and the registrant element. For example:&lt;pre&gt;
			{@code Isbn.getQualifiedRegistrantElement("9791091530088"); //returns "9791091530"}
.&lt;/pre&gt;
@param isbn An International Standard Book Number in either 10-digit or 13-digit format.
@return
A {@link java.lang.String String} consisting of a concatenation of the prefix and the 
registrant element.
@see #allComponentsAsArray(String... isbns)
@see #allComponentsAsJson(String... isbns)
@see JsonIsbn
@see #allComponentsAddedKeys(String isbn)
@see #getComponent(String isbn)
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementSizeAsInt(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getRegistrantElementExtentAsInt(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementSizeAsInt(String isbn)
@see #getPublicationElementExtent(String isbn)
@see #getPublicationElementExtentAsInt(String isbn)
*/
</xsl:text>
<xsl:text>
public static String getQualifiedRegistrantElement(String isbn) {
isbn = isbnThirteen(isbn);
return assignAgencyConstant(isbn).getComponent(isbn);
}
</xsl:text>
<!-- getRegistrantElement() -->
<xsl:text>/**
Accepts an ISBN in 10-digit or 13-digit format as input and returns a {@link java.lang.String String} consisting of 
the portion of the ISBN that identifies the publisher (i.e., the registrant prefix). For example:&lt;pre&gt;
			{@code Isbn.getRegistrantElement("0710092733"); //returns "7100"}
.&lt;/pre&gt;
@param isbn An International Standard Book Number in either 10-digit or 13-digit format.
@return
A {@link java.lang.String String} consisting of the portion of the ISBN that identifies the 
publisher (i.e., the registrant prefix).
@see #allComponentsAsArray(String... isbns)
@see #allComponentsAsJson(String... isbns)
@see JsonIsbn
@see #allComponentsAddedKeys(String isbn)
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementSizeAsInt(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getRegistrantElementExtentAsInt(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementSizeAsInt(String isbn)
@see #getPublicationElementExtent(String isbn)
@see #getPublicationElementExtentAsInt(String isbn)
@see REGISTRANT_ELEMENT
*/
</xsl:text>
<xsl:text>
public static String getRegistrantElement(String isbn) {
isbn = isbnThirteen(isbn);
return REGISTRANT_ELEMENT.getComponent(isbn);
}
</xsl:text>
<!-- getPublicationElement() -->
<xsl:text>/**
Accepts an ISBN in 10-digit or 13-digit format as input and returns a {@link java.lang.String String} consisting of 
the portion of the ISBN occurring in between the registrant element and the check digit. For example:&lt;pre&gt;
			{@code Isbn.getPublicationElement("0965721361"); //returns "6"}
.&lt;/pre&gt;
@param isbn An International Standard Book Number in either 10-digit or 13-digit format.
@return
A {@link java.lang.String String} consisting of the portion of the ISBN occurring in between 
the registrant element and the check digit.
@see #allComponentsAsArray(String... isbns)
@see #allComponentsAsJson(String... isbns)
@see JsonIsbn
@see #allComponentsAddedKeys(String isbn)
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getRegistrantElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementSizeAsInt(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getRegistrantElementExtentAsInt(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementSizeAsInt(String isbn)
@see #getPublicationElementExtent(String isbn)
@see #getPublicationElementExtentAsInt(String isbn)
@see #PUBLICATION_ELEMENT
*/
</xsl:text>
<xsl:text>
public static String getPublicationElement(String isbn) {
isbn = isbnThirteen(isbn);
return PUBLICATION_ELEMENT.getComponent(isbn);
}
</xsl:text>
<!--getCheckDigit() -->
<xsl:text>/**
Accepts an ISBN in 10-digit or 13-digit format as input and returns a {@link java.lang.String String} consisting of 
the check digit. For example:&lt;pre&gt;
			{@code Isbn.getCheckDigit("9780955282263"); //returns "3"
			Isbn.getCheckDigit("0955282268"); //also returns "3"}
.&lt;/pre&gt;
@param isbn An International Standard Book Number in either 10-digit or 13-digit format.
@return
A {@link java.lang.String String} consisting of the check digit.
&lt;ul&gt;
&lt;li&gt;
getCheckDigit() only ever returns the check digit as calculated for an ISBN in 13-digit format.
&lt;/li&gt;
&lt;li&gt;
getCheckDigit() never returns the characters x or X, nor the check digit of an ISBN 
in 10-digit format.
&lt;/li&gt;
&lt;/ul&gt;
@see #allComponentsAsArray(String... isbns)
@see #allComponentsAsJson(String... isbns)
@see JsonIsbn
@see #allComponentsAddedKeys(String isbn)
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementSizeAsInt(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getRegistrantElementExtentAsInt(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementSizeAsInt(String isbn)
@see #getPublicationElementExtent(String isbn)
@see #getPublicationElementExtentAsInt(String isbn)
@see CHECK_DIGIT
*/
</xsl:text>
<xsl:text>
public static String getCheckDigit(String isbn) {
isbn = isbnThirteen(isbn);
return CHECK_DIGIT.getComponent(isbn);
}
</xsl:text>
<!-- getRegistrantElementSize() -->
<xsl:text>/**
Accepts an ISBN in 10-digit or 13-digit format as input and returns a {@link java.lang.String String} indicating  
the number of digits in (length of) the registrant element (publisher prefix). For example:&lt;pre&gt;
			{@code Isbn.getRegistrantElementSize("0932274277"); //returns "6"
			Isbn.getRegistrantElement("0932274277"; //returns "932274"}
.&lt;/pre&gt;
@param isbn An International Standard Book Number in either 10-digit or 13-digit format.
@return
A {@link java.lang.String String} indicating the number of digits in (length of) the 
registrant element (publisher prefix).
@see #allComponentsAsArray(String... isbns)
@see #allComponentsAsJson(String... isbns)
@see JsonIsbn
@see #allComponentsAddedKeys(String isbn)
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSizeAsInt(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getRegistrantElementExtentAsInt(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementSizeAsInt(String isbn)
@see #getPublicationElementExtent(String isbn)
@see #getPublicationElementExtentAsInt(String isbn)
@see REGISTRANT_ELEMENT_SIZE
*/
</xsl:text>
<xsl:text>
public static String getRegistrantElementSize(String isbn) {
isbn = isbnThirteen(isbn);
return REGISTRANT_ELEMENT_SIZE.getComponent(isbn);
}
</xsl:text>
<!-- getRegistrantElementSizeAsInt() -->
<xsl:text>/**
Accepts an ISBN in 10-digit or 13-digit format as input and returns an &lt;code&gt;int&lt;/code&gt; indicating  
the number of digits in (length of) the registrant element (publisher prefix). For example:&lt;pre&gt;
			{@code Isbn.getRegistrantElementSizeAsInt("0932274277"); //returns 6
			Isbn.getRegistrantElement("0932274277"; //returns "932274"}
.&lt;/pre&gt;
@param isbn An International Standard Book Number in either 10-digit or 13-digit format.
@return
An &lt;code&gt;int&lt;/code&gt; indicating the number of digits in (length of) the 
registrant element (publisher prefix).
@see #allComponentsAsArray(String... isbns)
@see #allComponentsAsJson(String... isbns)
@see JsonIsbn
@see #allComponentsAddedKeys(String isbn)
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getRegistrantElementExtentAsInt(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementSizeAsInt(String isbn)
@see #getPublicationElementExtent(String isbn)
@see #getPublicationElementExtentAsInt(String isbn)
@see REGISTRANT_ELEMENT_SIZE
*/
</xsl:text>
<xsl:text>
public static int getRegistrantElementSizeAsInt(String isbn) {
isbn = isbnThirteen(isbn);
return Integer.parseInt(REGISTRANT_ELEMENT_SIZE.getComponent(isbn));
}
</xsl:text>
<!-- getRegistrantElementExtent() -->
<xsl:text>/**
Accepts an ISBN in 10-digit or 13-digit format as input and returns a {@link java.lang.String String} indicating  
the length of the range to which the registrant element belongs; in effect, the maximum number 
of registrants who can be assigned to the range in which the registrant element of the ISBN that 
is to hand falls. For example:&lt;pre&gt;
			{@code Isbn.getRegistrantElementExtent("0684717611"); //returns "44"
			Isbn.getRegistrantElement("0684717611"); // returns "684"}
.&lt;/pre&gt;
@param isbn An International Standard Book Number in either 10-digit or 13-digit format.
@return
A {@link java.lang.String String} indicating the length of the range to which the registrant 
element belongs.
@see #allComponentsAsArray(String... isbns)
@see #allComponentsAsJson(String... isbns)
@see JsonIsbn
@see #allComponentsAddedKeys(String isbn)
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementSizeAsInt(String isbn)
@see #getRegistrantElementExtentAsInt(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementSizeAsInt(String isbn)
@see #getPublicationElementExtent(String isbn)
@see #getPublicationElementExtentAsInt(String isbn)
@see #REGISTRANT_ELEMENT_EXTENT
*/
</xsl:text>
<xsl:text>
public static String getRegistrantElementExtent(String isbn) {
isbn = isbnThirteen(isbn);
return REGISTRANT_ELEMENT_EXTENT.getComponent(isbn);
}
</xsl:text>
<!-- getRegistrantElementExtentAsInt() -->
<xsl:text>/**
Accepts an ISBN in 10-digit or 13-digit format as input and returns an &lt;code&gt;int&lt;/code&gt; indicating  
the length of the range to which the registrant element belongs; in effect, the maximum number 
of registrants who can be assigned to the range in which the registrant element of the ISBN that 
is to hand falls. For example:&lt;pre&gt;
			{@code Isbn.getRegistrantElementExtentAsInt("0684717611"); //returns 44
			Isbn.getRegistrantElement("0684717611"); // returns "684"}
.&lt;/pre&gt;
@param isbn An International Standard Book Number in either 10-digit or 13-digit format.
@return
An &lt;code&gt;int&lt;/code&gt; indicating the length of the range to which the registrant 
element belongs.
@see #allComponentsAsArray(String... isbns)
@see #allComponentsAsJson(String... isbns)
@see JsonIsbn
@see #allComponentsAddedKeys(String isbn)
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementSizeAsInt(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementSizeAsInt(String isbn)
@see #getPublicationElementExtent(String isbn)
@see #getPublicationElementExtentAsInt(String isbn)
@see #REGISTRANT_ELEMENT_EXTENT
*/
</xsl:text>
<xsl:text>
public static int getRegistrantElementExtentAsInt(String isbn) {
isbn = isbnThirteen(isbn);
return Integer.parseInt(REGISTRANT_ELEMENT_EXTENT.getComponent(isbn));
}
</xsl:text>
<!-- getPublicationElementSize() -->
<xsl:text>/**
Accepts an ISBN in 10-digit or 13-digit format as input and returns a {@link java.lang.String String} indicating  
the number of digits in (length of) the publication element. For example:&lt;pre&gt;
			{@code Isbn.getPublicationElementSize("0975892800"); //returns "1"
			Isbn.getQualifiedRegistrantElement("0975892800}; //returns "97809758928"
.&lt;/pre&gt;
@param isbn An International Standard Book Number in either 10-digit or 13-digit format.
@return
A {@link java.lang.String String} indicating the number of digits in (length of) the 
publication element.
@see #allComponentsAsArray(String... isbns)
@see #allComponentsAsJson(String... isbns)
@see JsonIsbn
@see #allComponentsAddedKeys(String isbn)
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementSizeAsInt(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getRegistrantElementExtentAsInt(String isbn)
@see #getPublicationElementSizeAsInt(String isbn)
@see #getPublicationElementExtent(String isbn)
@see #getPublicationElementExtentAsInt(String isbn)
@see #PUBLICATION_ELEMENT_SIZE
*/
</xsl:text>
<xsl:text>
public static String getPublicationElementSize(String isbn) {
isbn = isbnThirteen(isbn);
return PUBLICATION_ELEMENT_SIZE.getComponent(isbn);
}
</xsl:text>
<!-- getPublicationElementSizeAsInt() -->
<xsl:text>/**
Accepts an ISBN in 10-digit or 13-digit format as input and returns an &lt;code&gt;int&lt;/code&gt; indicating  
the number of digits in (length of) the publication element. For example:&lt;pre&gt;
			{@code Isbn.getPublicationElementSizeAsInt("0975892800"); //returns 1
			Isbn.getQualifiedRegistrantElement("0975892800}; //returns "97809758928"
.&lt;/pre&gt;
@param isbn An International Standard Book Number in either 10-digit or 13-digit format.
@return
An &lt;code&gt;int&lt;/code&gt; indicating the number of digits in (length of) the 
publication element.
@see #allComponentsAsArray(String... isbns)
@see #allComponentsAsJson(String... isbns)
@see JsonIsbn
@see #allComponentsAddedKeys(String isbn)
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementSizeAsInt(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getRegistrantElementExtentAsInt(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementExtent(String isbn)
@see #getPublicationElementExtentAsInt(String isbn)
@see #PUBLICATION_ELEMENT_SIZE
*/
</xsl:text>
<xsl:text>
public static int getPublicationElementSizeAsInt(String isbn) {
isbn = isbnThirteen(isbn);
return Integer.parseInt(PUBLICATION_ELEMENT_SIZE.getComponent(isbn));
}
</xsl:text>
<!-- getPublicationElementExtent() -->
<xsl:text>/**
Accepts an ISBN in 10-digit or 13-digit format as input and returns a {@link java.lang.String String} indicating  
the maximum number of times the ISBN's registrant element/publisher prefix can be used. For example:&lt;pre&gt;
			{@code Isbn.getPublicationElementExtent("0192545183"); //returns "1000000"
			Isbn.getQualifiedRegistrantElement("0192545183"); //returns "978019"}
.&lt;/pre&gt;
@param isbn An International Standard Book Number in either 10-digit or 13-digit format.
@return
A {@link java.lang.String String} indicating the maximum number of times the ISBN's registrant 
element/publisher prefix can be used.
@see #allComponentsAsArray(String... isbns)
@see #allComponentsAsJson(String... isbns)
@see JsonIsbn
@see #allComponentsAddedKeys(String isbn)
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementSizeAsInt(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getRegistrantElementExtentAsInt(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementSizeAsInt(String isbn)
@see #getPublicationElementExtentAsInt(String isbn)
@see #PUBLICATION_ELEMENT_EXTENT
*/
</xsl:text>
<xsl:text>
public static String getPublicationElementExtent(String isbn) {
isbn = isbnThirteen(isbn);
return PUBLICATION_ELEMENT_EXTENT.getComponent(isbn);
}
</xsl:text>
<!-- getPublicationElementExtentAsInt() -->
<xsl:text>/**
Accepts an ISBN in 10-digit or 13-digit format as input and returns an &lt;code&gt;int&lt;/code&gt; indicating  
the maximum number of times the ISBN's registrant element/publisher prefix can be used. For example:&lt;pre&gt;
			{@code Isbn.getPublicationElementExtentAsInt("0192545183"); //returns 1000000
			Isbn.getQualifiedRegistrantElement("0192545183"); //returns "978019"}
.&lt;/pre&gt;
@param isbn An International Standard Book Number in either 10-digit or 13-digit format.
@return
An &lt;code&gt;int&lt;/code&gt; indicating the maximum number of times the ISBN's registrant 
element/publisher prefix can be used.
@see #allComponentsAsArray(String... isbns)
@see #allComponentsAsJson(String... isbns)
@see JsonIsbn
@see #allComponentsAddedKeys(String isbn)
@see #getPrefix(String isbn)
@see #getPrefixOld(String isbn)
@see #getAgencyName(String isbn)
@see #getQualifiedRegistrantElement(String isbn)
@see #getRegistrantElement(String isbn)
@see #getPublicationElement(String isbn)
@see #getCheckDigit(String isbn)
@see #getRegistrantElementSize(String isbn)
@see #getRegistrantElementSizeAsInt(String isbn)
@see #getRegistrantElementExtent(String isbn)
@see #getRegistrantElementExtentAsInt(String isbn)
@see #getPublicationElementSize(String isbn)
@see #getPublicationElementSizeAsInt(String isbn)
@see #getPublicationElementExtent(String isbn)
@see #PUBLICATION_ELEMENT_EXTENT
*/
</xsl:text>
<xsl:text>
public static int getPublicationElementExtentAsInt(String isbn) {
isbn = isbnThirteen(isbn);
return Integer.parseInt(PUBLICATION_ELEMENT_EXTENT.getComponent(isbn));
}
</xsl:text>
<!-- getComponent() -->
<xsl:text>/**
A method overridden by constants returned by {@link #assignAgencyConstant(String isbn) assignAgencyConstant()} 
(AGENCY constants) and constants that return {@link #COMPONENT Isbn.COMPONENT} when they call {@link #getContext() getContext()} 
&lt;span id="componentconst"&gt;(COMPONENT constants)&lt;/span&gt;.
@param isbn An International Standard Book Number, in either 10-digit or 13-digit format.
@return
&lt;ul&gt;
&lt;li&gt;
Constants returned by {@link #assignAgencyConstant(String isbn) assignAgencyConstant()} (AGENCY constants) return a {@link java.lang.String String} that 
concatenates the agency prefix and the registrant prefix (except for {@link #UNKNOWN Isbn.UNKNOWN}, which returns 
an empty {@link java.lang.String String}); also, when AGENCY constants (i.e., constants returned by {@link #assignAgencyConstant(String isbn) assignAgencyConstant()}) 
call &lt;code&gt;getComponent()&lt;/code&gt;, the constant's &lt;code&gt;MAXIMUM_ASSIGNED&lt;/code&gt; attribute is calculated and is subsequently 
set as a side effect.
&lt;/li&gt;
&lt;li&gt;
{@link #PREFIX Isbn.PREFIX} returns a {@link java.lang.String String} consisting of the agency's prefix preceded by the EAN/UCC prefix
&lt;/li&gt;
&lt;li&gt;
{@link #PREFIX_OLD Isbn.PREFIX_OLD} returns a {@link java.lang.String String} consisting of the agency's prefix without the EAN/UCC prefix that 13-digit ISBNs incorporate.
&lt;/li&gt;
&lt;li&gt;
{@link #AGENCY_NAME Isbn.AGENCY_NAME} returns a {@link java.lang.String String} consisting of the name that occurred in RangeMessage.xml's Agency element
&lt;/li&gt;
&lt;li&gt;
{@link #REGISTRANT_ELEMENT Isbn.REGISTRANT_ELEMENT} returns a {@link java.lang.String String} consisting only of the part of the ISBN that identifies the publisher
 (i.e., the registrant prefix).
&lt;/li&gt;
&lt;li&gt;
{@link #PUBLICATION_ELEMENT Isbn.PUBLICATION_ELEMENT} returns a {@link java.lang.String String} comprising the portion of the ISBN between the registrant 
element and the check digit.
&lt;/li&gt;
&lt;li&gt;
{@link #CHECK_DIGIT Isbn.CHECK_DIGIT} returns a {@link java.lang.String String} comprising only the check digit. 
If the parameter was a 10-digit ISBN, the check digit returned is 
the check digit calculated for use in 13-digit ISBNs.
&lt;/li&gt;
&lt;li&gt;
{@link #REGISTRANT_ELEMENT_SIZE Isbn.REGISTRANT_ELEMENT_SIZE} returns a {@link java.lang.String String} indicating the number of digits in (length of) 
the registrant element (publisher prefix).
&lt;/li&gt;
&lt;li&gt;
{@link #REGISTRANT_ELEMENT_EXTENT Isbn.REGISTRANT_ELEMENT_EXTENT} returns a {@link java.lang.String String} indicating the length of the range to which 
the registrant element belongs: in effect, the maximum number of registrants who can be assigned  
to the range in which the registrant element of the ISBN that is to hand falls.
&lt;/li&gt;
&lt;li&gt;
{@link #PUBLICATION_ELEMENT_SIZE Isbn.PUBLICATION_ELEMENT_SIZE} returns a {@link java.lang.String String} indicating the number of digits in (length of) 
the publication element.
&lt;/li&gt;
&lt;li&gt;
{@link #PUBLICATION_ELEMENT_EXTENT Isbn.PUBLICATION_ELEMENT_EXTENT} returns a {@link java.lang.String String} that in effect indicates the maximum number 
of times the ISBN's registrant element/publisher prefix can be used.
&lt;/li&gt;
&lt;li&gt;
{@link #UNKNOWN Isbn.UNKNOWN} returns an empty {@link java.lang.String String} after calling &lt;code&gt;getComponent()&lt;/code&gt;.
&lt;/li&gt;
&lt;li&gt;
Elements returned by {@link #assignRangeConstant(String isbn) assignRangeConstant()} (RANGE constants) 
return null after calling &lt;code&gt;getComponent()&lt;/code&gt;.
&lt;/li&gt;
&lt;li&gt;
{@link #AGENCY Isbn.AGENCY}, {@link #RANGE Isbn.RANGE}, {@link #COMPONENT Isbn.COMPONENT}, and {@link #CONTEXT Isbn.CONTEXT} return null after calling 
&lt;code&gt;getComponent()&lt;/code&gt;.
&lt;/li&gt;
&lt;/ul&gt;
@exception Throws a {@link CannotInferPrefixException CannotInferPrefixException} if {@link #UNKNOWN UNKNOWN} 
is returned upon a call to {@link #assignAgencyConstant(String isbn) assignAgencyConstant()} and 
the caller is a constant that returns {@link #COMPONENT COMPONENT} when it calls 
{@link #getContext() getContext()}.
&lt;ul&gt;
&lt;li&gt;
{@link #UNKNOWN UNKNOWN} is returned by {@link #assignAgencyConstant(String isbn) assignAgencyConstant()} 
if the ISBN's prefix cannot be inferred based on RangeMessage.xml.
&lt;/li&gt;
&lt;li&gt;
Internally, the &lt;code&gt;Isbn&lt;/code&gt; type's API preempts most calls to &lt;code&gt;getComponent()&lt;/code&gt; that 
ultimately would cause it to throw a {@link CannotInferPrefixException CannotInferPrefixException}.
&lt;/li&gt;
&lt;/ul&gt;
*/
</xsl:text>
<xsl:text>public String getComponent(String isbn) {
return null;
}
</xsl:text>
<!-- isValid() -->
<xsl:text>/**
Validates an International Standard Book Number.
&lt;p&gt;
&lt;ul&gt;
&lt;li&gt;
The &lt;code&gt;isValid()&lt;/code&gt; method is suitable for screening data 
that consists of ISBNs for typos.
&lt;/li&gt;
&lt;li&gt;
Only software expressly dedicated to processing ISBNs that have yet to be assigned 
need be used in order to determine whether an ISBN is &lt;i&gt;de jure&lt;/i&gt; valid.
&lt;/li&gt;
&lt;/ul&gt;
&lt;p&gt;
This method is never called internally by the &lt;code&gt;Isbn&lt;/code&gt; type and is included for completeness. The 
&lt;code&gt;Isbn&lt;/code&gt; type's other methods all call {@link #isbnThirteen(String isbn) isbnThirteen()} before proceeding 
to do anything.
@param isbn An International Standard Book Number in either 10-digit or 13-digit format.
@return
Returns &lt;code&gt;true&lt;/code&gt; if the ISBN is valid.
&lt;p&gt;
Returns &lt;code&gt;true&lt;/code&gt; when a valid ISBN in 10-digit format is passed as its parameter, and 
also when its equivalent in 13-digit format is passed as its parameter.
&lt;p&gt;
Returns &lt;code&gt;false&lt;/code&gt; if the ISBN is not valid; returns &lt;code&gt;false&lt;/code&gt; and writes a message to stderr
if the ISBN is missing out digits or (for 13-digit ISBNs) does not begin with 978 or 979.
@see #isbnThirteen(String isbn)
@see #CHECK_DIGIT
*/
</xsl:text>
<xsl:text>public static boolean isValid(String isbn) {
isbn = isbn.replaceAll("[^0-9xX]","");
if (isbn.length() == 13 &amp;&amp; (isbn.startsWith("978") | isbn.startsWith("979"))) {
char[] digits = isbn.toCharArray();
int sum = 0;
for (int i = 0; i &lt; digits.length;i++){
	if (i % 2 == 0) sum += Character.digit(digits[i],10);
	else sum += Character.digit(digits[i],10) * 3;
}
if (sum % 10 == 0) return true;
else return false;
}
else if (isbn.length() == 10) {
char[] digits = isbn.toCharArray();
int sum = 0;
for (int i = 0, j = 10; i &lt; digits.length - 1; i++) {
	sum += Character.digit(digits[i],10) * j;
	j--;
}
if (digits[9] == 'x' || digits[9] == 'X') {
	if ((sum + 10) % 11 == 0) return true;
	else return false;
}
else {
	sum += Character.digit(digits[9],10);
	if (sum % 11 == 0) return true;
	else return false;
}
}
else {
System.err.println("The number need have been either 10 or 13 digits long, and if the latter, need have started with either 978 or 979.");
return false;
}
}
</xsl:text>
<!-- isbnThirteen() -->
<xsl:text>/**
Called each and every time the &lt;code&gt;Isbn&lt;/code&gt; type begins performing an operation that concerns  
one or more of an ISBN's components.
&lt;p&gt;
The &lt;code&gt;isbnThirteen()&lt;/code&gt; and {@link #isValid(String isbn) isValid()} methods can be invoked 
by means of the &lt;code&gt;Isbn&lt;/code&gt; type, and respectively convert a 10-digit ISBN to one in 13-digit 
format or determine whether an ISBN in either format is valid. 
@param isbn An International Standard Book Number in either 10-digit or 13-digit format. 
The &lt;code&gt;isbnThirteen()&lt;/code&gt; method at no point attempts to validate the ISBN passed to it as its 
argument: it discards the check digit if the ISBN was passed to it in 10-digit format.
@return
A {@link java.lang.String String} comprising an International Standard Book Number in 13-digit format. If the ISBN 
passed as a parameter is in 10-digit format, a 13-digit ISBN is nonetheless returned: the 
&lt;code&gt;isbnThirteen()&lt;/code&gt; method will have recalculated the check digit.
@exception Throws a {@link PoorISBNDataException PoorISBNDataException} in case of missing or 
extraneous digits, or if an ISBN in 13-digit format does not begin with either 978 or 979.
@see #isValid(String isbn)
*/
</xsl:text>
<xsl:text>public static String isbnThirteen(String isbn) {
		StringBuilder sb = new StringBuilder();
		String isbnargument = isbn; 
		isbn = isbn.replaceAll("[^0-9xX]","");
		if (isbn.length() == 13 &amp;&amp; (isbn.startsWith("978") | isbn.startsWith("979"))) {sb.append(isbn); return sb.toString();}
		else {
			//if (isbn.length() &lt; 10) throw new PoorISBNDataException("There need have been either 10 or 13 characters, and in the latter case the first three need have been either 978 or 979.");
			if (isbn.length() != 10) {
			System.err.println(isbnargument);
			throw new PoorISBNDataException("There need have been either 10 or 13 characters, and in the latter case the first three need have been either 978 or 979.");
			}
			char[] digits = ("978" + isbn).toCharArray();
		    for (int i = 0; i &lt; digits.length -1;i++) sb.append(digits[i]);
		    //System.out.println(sb);
		    for (int i = 0, j = 0; i &lt;= digits.length - 1;i++) {
		    	if (i == digits.length -1) {
				int k = 10 - (j % 10);
				//System.out.println(k);
				if (k == 10) sb.append("0");
				else sb.append(Integer.toString(k));
				break;
			}
			if (i % 2 == 0) {
				j += Character.digit(digits[i],10);
			}
			else {
				j += Character.digit(digits[i],10) * 3;
			}
			}
			return sb.toString();
	}
	}
</xsl:text>	
<!-- main() -->
<xsl:text>/**
Calls {@link #allComponentsMinKeys(String isbn) allComponentsMinKeys()} and prints an iteration over 
the result to standard output.
&lt;p&gt;
The &lt;code&gt;main()&lt;/code&gt; method is invoked from the command line as follows:&lt;pre&gt;

			{@code java io.sourceforge.curtthomas.Isbn 3458329021 9780863698774}

&lt;/pre&gt;
If the &lt;code&gt;Isbn&lt;/code&gt; command is not followed by at least one ISBN number, the &lt;code&gt;main()&lt;/code&gt; method will 
send a message to standard output rather than continue running.
@param argv One or more International Standard Book Numbers in either 13-digit or 10-digit format, delimited on the command line by a space character or, from code, by a comma.
&lt;ul&gt;
&lt;li&gt;
The &lt;code&gt;Isbn&lt;/code&gt; type is intended for use with existing ISBNs. Passing ISBNs as parameters that have 
never been assigned to an item as a consequence of a decision by a publisher or an agency could cause &lt;code&gt;main()&lt;/code&gt;, 
{@link #allComponentsAsArray(String... isbn) allComponentsAsArray()}, {@link #allComponentsMinKeys(String isbn) allComponentsMinKeys()}, 
{@link #allComponentsAddedKeys(String isbn) allComponentsAddedKeys()}, {@link #allComponentsAsJson(String... isbns) allComponentsAsJson()}, 
or the {@link JsonIsbn JsonIsbn} class to throw a runtime exception.
&lt;/li&gt;
&lt;/ul&gt;
@see JsonIsbn#main(String... argv)
*/
</xsl:text>
<xsl:text>public static void main(String... argv) {
		if (argv.length &lt; 1) System.out.println("Please follow the command with at least one ten- or thirteen-digit ISBN number separated by spaces");
		else {
		for (String isbn : argv) {
		TreeMap&lt;String,String&gt; all = allComponentsMinKeys(isbn);
		for (String key : all.keySet()) {
		System.out.print(key + ": ");
		System.out.println(all.get(key));
		}
		System.out.println();
		}
		}
		}
</xsl:text>
<!-- closing brace for enum type -->
<xsl:text>}</xsl:text>
</xsl:template>
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- For making another RangeMessage.xml with the Agency names changed to Java language identifiers. -->
<!-- RangeMessage.xml's current URL is https://www.isbn-international.org/range_file_generation -->
<!-- The original file should be grepped for invalid characters (e.g. [^a-zA-Z0-9 ]).
	 Characters that the terminal doesn't rasterize should be detected through elimination.
	 These characters and the single quote should be removed manually. -->
<!-- The file produced by this stylesheet can bear any name whatever. Isbn.xsl does not use the 
	 document() function or anything like that. -->
<!-- After running this stylesheet, it is imperative that ranges.xsl be run in order to add an 
	 element to RangeMessage.xml that bears a legal Java identifier respective to the Rule element. -->
<xsl:output method="xml" indent="yes"/>
<xsl:template match="/">
<ISBNRangeMessage>
<RegistrationGroups>
<xsl:for-each select="ISBNRangeMessage/RegistrationGroups/Group">
<Group>
<xsl:copy-of select="Prefix"/>
<xsl:variable name="agency" select="Agency"/>
<xsl:variable name="position" select="count(following-sibling::Group[Agency=$agency])"/>
<xsl:variable name="position2" select="count(preceding-sibling::Group[Agency=$agency])"/>
<Agency>
<xsl:attribute name="name"><xsl:value-of select="Agency"/></xsl:attribute>
<xsl:value-of select="upper-case(replace(replace(Agency,'[,.]',''),' ','_'))"/>
<xsl:choose>
<xsl:when test="$position eq 0 and $position2 eq 0">
</xsl:when>
<xsl:otherwise>
<xsl:text>_</xsl:text><xsl:value-of select="$position2"/>
</xsl:otherwise>
</xsl:choose>
</Agency>
<Rules>
<xsl:for-each select="Rules/Rule">
<Rule>
<Name>
</Name>
<xsl:copy-of select="Range"/>
<xsl:copy-of select="Length"/>
</Rule>
</xsl:for-each>
</Rules>
</Group>
</xsl:for-each>
</RegistrationGroups>
</ISBNRangeMessage>
</xsl:template>
</xsl:stylesheet>
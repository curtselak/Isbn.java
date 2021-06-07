<?xml version="1.0" encoding="UTF-8"?>
<!-- It is necessary to run groups.xsl prior to running this stylesheet -->
<!-- Merges file with legal Java identifiers for Agency into new file
     with legal Java identifiers for Isbn.java's Range constants -->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes"/>
<xsl:template match="/">
<ISBNRangeMessage>
<RegistrationGroups>
<xsl:for-each select="ISBNRangeMessage/RegistrationGroups/Group">
<Group>
<xsl:copy-of select="Prefix"/>
<xsl:copy-of select="Agency"/>
<Rules>
<xsl:for-each select="Rules/Rule">
<Rule>
<Name>
<xsl:if test="not(Length eq '0')">
<xsl:variable name="rbeginstr" select="substring(Range,1,Length)"/>
<xsl:variable name="rendstr" select="substring(Range,9,Length)"/>
<xsl:value-of select="../../Agency"/><xsl:text>__</xsl:text>
<xsl:value-of select="$rbeginstr"/><xsl:text>_TO_</xsl:text>
<xsl:value-of select="$rendstr"/><xsl:text>_RANGE</xsl:text>
</xsl:if>
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
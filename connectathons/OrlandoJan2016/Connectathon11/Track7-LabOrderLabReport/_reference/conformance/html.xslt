<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:con="http://hl7.org/fhir">
<xsl:strip-space elements="*"/>  
	<xsl:template match="con:Conformance">
		<html>
			<body>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="con:implementation/con:description">
		<p>
			<b>
				<xsl:value-of select="name(.)"/>: </b>
			<xsl:value-of select="@value"/>
		</p>
	</xsl:template>
	<xsl:template match="con:format">
		<p>
			<b>
				<xsl:value-of select="name(.)"/>: </b>
			<xsl:value-of select="@value"/>
		</p>
	</xsl:template>
	<xsl:template match="con:rest">
		<p>
			<b>
				<xsl:value-of select="con:mode/name()"/>: </b>
			<xsl:value-of select="con:mode/@value"/>
		</p>
	<xsl:for-each select="con:resource">
	<p>
			<b>
				<xsl:value-of select="con:type/name(.)"/>: </b>
			<xsl:value-of select="con:type/@value"/> CRUD
			<xsl:for-each select="con:interaction"><xsl:text> </xsl:text>
			<xsl:value-of select="con:code/@value"/>
			</xsl:for-each>
		</p>
	
	</xsl:for-each>
	</xsl:template>
	
	
</xsl:stylesheet>

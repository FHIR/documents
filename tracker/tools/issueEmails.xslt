<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:template match="/issues">
    <xsl:value-of select="concat('tolist.issues=', string-join(distinct-values(assignee/@email), ','))"/>
	</xsl:template>
</xsl:stylesheet>

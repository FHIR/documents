<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="fn" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs fn">
  <xsl:output indent="yes"/>
  <xsl:param name="file1"/>
  <xsl:param name="file2"/>
  <xsl:param name="file3"/>
  <xsl:param name="file4"/>
  <xsl:param name="file5"/>
  <xsl:param name="file6"/>
  <xsl:template match="/">
    <xsl:apply-templates mode="convertCSV" select="."/>
  </xsl:template>
  <xsl:template mode="convertCSV" match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates mode="convertCSV" select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template mode="convertCSV" match="file[normalize-space(.)='']"/>
  <xsl:template mode="convertCSV" match="file">
    <xsl:variable name="name">
      <xsl:choose>
        <xsl:when test="position()=2">
          <xsl:value-of select="$file1"/>
        </xsl:when>
        <xsl:when test="position()=3">
          <xsl:value-of select="$file2"/>
        </xsl:when>
        <xsl:when test="position()=4">
          <xsl:value-of select="$file3"/>
        </xsl:when>
        <xsl:when test="position()=5">
          <xsl:value-of select="$file4"/>
        </xsl:when>
        <xsl:when test="position()=6">
          <xsl:value-of select="$file5"/>
        </xsl:when>
        <xsl:when test="position()=7">
          <xsl:value-of select="$file6"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:copy-of select="fn:convertCSV(., $name)"/>
  </xsl:template>
  <xsl:function name="fn:convertCSV">
    <xsl:param name="csv" as="xs:string"/>
    <xsl:param name="name" as="xs:string"/>
    <xsl:variable name="lines" select="tokenize($csv, '&#x0a;')" as="xs:string+"/>
    <xsl:variable name="elemNames" select="fn:getTokens($lines[1])" as="xs:string+"/>
    <xsl:element name="{translate($name, ' ', '_')}">
      <xsl:for-each select="$lines[position() &gt; 1]">
        <row>
          <xsl:variable name="lineItems" select="fn:getTokens(.)" as="xs:string+"/>
          <xsl:for-each select="$elemNames">
            <xsl:variable name="pos" select="position()"/>
            <xsl:element name="{.}">
              <xsl:value-of select="$lineItems[$pos]"/>
            </xsl:element>
          </xsl:for-each>
        </row>
      </xsl:for-each>
    </xsl:element>
  </xsl:function>
  <xsl:function name="fn:getTokens" as="xs:string+">
    <xsl:param name="str" as="xs:string"/>
    <xsl:analyze-string select="concat($str, ',')" regex='(("[^"]*")+|[^,]*),'>
      <xsl:matching-substring>
        <xsl:sequence select='replace(regex-group(1), "^""|""$|("")""", "$1")'/>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:function>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" omit-xml-declaration="yes"/>
	<xsl:template match="/">
    <xsl:if test="not(Tracker/@id=677)">
      <xsl:message terminate="yes">This transform only works on the FHIR Change Requests tracker</xsl:message>
    </xsl:if>
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>Tracker Items</title>
      </head>
      <body>
        <h3>Comment Submitters</h3>
        <xsl:text>&#x0a;</xsl:text>
        <ul>
        <xsl:text>&#x0a;</xsl:text>
          <xsl:for-each select="Tracker/TrackerItem/ExtraFields/ExtraField[@name='Real Submitter']">
            <xsl:sort select="."/>
            <xsl:if test="not(preceding::ExtraField[@name='Real Submitter'][.=current()])">
              <li>
                <xsl:value-of select="."/>
              </li>
              <xsl:text>&#x0a;</xsl:text>
            </xsl:if>
          </xsl:for-each>
        </ul>
        <xsl:text>&#x0a;</xsl:text>
        <h3>Line Items</h3>
        <xsl:text>&#x0a;</xsl:text>
        <p>
          <xsl:for-each select="Tracker/TrackerItem">
            <xsl:sort select="ExtraFields/ExtraField[@name='Ballot Resolution']"/>
            <xsl:sort select="@id" data-type="number"/>
            <a href="http://gforge.hl7.org/gf/project/fhir/tracker/?action=TrackerItemEdit&amp;tracker_item_id={@id}">
              <xsl:value-of select="@id"/>
            </a>
            <xsl:value-of select="concat(' ', Summary, ' (')"/>
            <span style="color:blue">
              <xsl:value-of select="ExtraFields/ExtraField[@name='Real Submitter']"/>
            </span>
            <xsl:text>) </xsl:text>
            <xsl:if test="ExtraFields/ExtraField[@name='In-Person?']='Yes'">
              <b>In Person </b>
            </xsl:if>
            <xsl:for-each select="ExtraFields/ExtraField[@name='Ballot Resolution']">
              <xsl:if test="not(.='None')">
                <xsl:value-of select="."/>
              </xsl:if>
            </xsl:for-each>
            <br/>
            <xsl:text>&#x0a;</xsl:text>
          </xsl:for-each>
        </p>
        <h3>Wiki</h3>
        <xsl:text>&#x0a;</xsl:text>
        <p>
          <xsl:for-each select="Tracker/TrackerItem">
            <xsl:sort select="ExtraFields/ExtraField[@name='Ballot Resolution']"/>
            <xsl:sort select="@id" data-type="number"/>
            <xsl:value-of select="concat('*[http://gforge.hl7.org/gf/project/fhir/tracker/?action=TrackerItemEdit&amp;tracker_item_id=', @id, ' ', @id, '] ', Summary, ' (', ExtraFields/ExtraField[@name='Real Submitter'], ') ', ExtraFields/ExtraField[@name='Ballot Resolution'])"/>
            <xsl:if test="ExtraFields/ExtraField[@name='In-Person?']='Yes'">
              <xsl:text> '''In Person'''</xsl:text>
            </xsl:if>
            <br/>
            <xsl:text>&#x0a;</xsl:text>
          </xsl:for-each>
        </p>
      </body>
    </html>
	</xsl:template>
</xsl:stylesheet>

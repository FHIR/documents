<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/issues">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title>Tracker Issues</title>
      </head>
      <body>
        <h1>Tracker Validation Issues</h1>
        <p>
          <xsl:value-of select="concat('Last tracker change: ', @lastChange)"/>
        </p>
        <h2>(Presumed) Responsible individual</h2>
        <p>Responsibility is presumed based on what user last edited the elements of the tracker item implicated in the issue</p>
        <ul>
          <xsl:for-each select="assignee[@name]">
            <xsl:sort select="@name"/>
            <li>
              <xsl:value-of select="concat(@name, ' (high: ', count(item[@priority=1]), '; low:', count(item[@priority=9]), ')')"/>
            </li>
          </xsl:for-each>
          <xsl:for-each select="assignee[@email]">
            <xsl:sort select="@email"/>
            <li>
              <a href="#{generate-id()}">
                <xsl:value-of select="@email"/>
              </a>
              <xsl:value-of select="concat(' (', count(item), ')')"/>
            </li>
          </xsl:for-each>
        </ul>
        <xsl:for-each select="assignee">
          <xsl:sort select="@name" order="descending"/>
          <xsl:sort select="@email"/>
          <a name="{generate-id()}"/>
          <h2>
            <xsl:value-of select="@name|@email"/>
          </h2>
          <xsl:for-each select="item">
            <xsl:sort select="@priority" data-type="number" order="ascending"/>
            <xsl:sort select="@number" data-type="number" order="ascending"/>
            <p>
              <a href="http://gforge.hl7.org/gf/project/fhir/tracker/?action=TrackerItemEdit&amp;tracker_item_id={@number}">
                <xsl:value-of select="@number"/>
              </a>
              <xsl:value-of select="concat(' - ', @summary, ' (Priority:', @priority, ')')"/>
            </p>
            <xsl:for-each select="issue">
              <ul>
                <li>
                  <xsl:value-of select="@message"/>
                </li>              
              </ul>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:for-each>
      </body>
    </html>
	</xsl:template>
</xsl:stylesheet>

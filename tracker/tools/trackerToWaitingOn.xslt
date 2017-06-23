<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="xml" encoding="UTF-8" version="1.0" indent="yes"/>
	<xsl:param name="baseDir" as="xs:string" select="''"/>
	<xsl:param name="emailFileName" as="xs:string" select="''"/>
	<xsl:variable name="items" as="element(item)+" select="/trackerItems/item"/>
  <xsl:variable name="emails" as="xs:string*" select="for $email in distinct-values(/trackerItems/item[@status='Waiting for Input']/@waitingforInpute-mails) return tokenize($email, ',')"/>
  <xsl:variable name="emails2" as="xs:string*" select="for $email in $emails return tokenize($email, ' ')"/>
  <xsl:variable name="trimmedEmails" as="xs:string*" select="for $email in ($emails2) return if (normalize-space($email)='') then () else normalize-space($email)"/>
  <xsl:variable name="uniqueEmails" as="xs:string*">
    <xsl:for-each select="distinct-values($trimmedEmails)">
      <xsl:sort select="."/>
      <xsl:value-of select="."/>
    </xsl:for-each>
  </xsl:variable>
	<xsl:template match="/trackerItems">
    <xsl:if test="$emailFileName!=''">
      <xsl:result-document method="text" encoding="UTF-8" href="../{substring-after($emailFileName, $baseDir)}">
        <xsl:value-of select="concat('tolist.waitingOn=', string-join($uniqueEmails, ','))"/>
      </xsl:result-document>
    </xsl:if>
    <html xmlns="http://www.w3.org/1999/xhtml">
      <xsl:variable name="title" select="'Waiting for Input FHIR Tracker Items'"/>
      <head>
        <title>
          <xsl:value-of select="$title"/>
        </title>
      </head>
      <body>
        <h1>
          <xsl:value-of select="$title"/>
        </h1>
        <p>Click your email address to jump to the items assigned to you:</p>
        <ul>
          <xsl:for-each select="$uniqueEmails">
            <xsl:sort select="."/>
            <li>
              <a href="#email_{position()}">
                <xsl:value-of select="."/>
              </a>
            </li>
          </xsl:for-each>
        </ul>
        <h2>Waiting on Individuals</h2>
        <xsl:for-each select="$uniqueEmails">
          <xsl:sort select="."/>
          <a name="email_{position()}">
            <xsl:text>&#x0a;</xsl:text>
          </a>
          <h3>
            <xsl:value-of select="."/>
          </h3>
          <ul>
            <xsl:for-each select="$items[contains(@waitingforInpute-mails, current())]">
              <li>
                <a href="http://gforge.hl7.org/gf/project/fhir/tracker/?action=TrackerItemEdit&amp;tracker_item_id={@number}">
                  <xsl:value-of select="concat(@number, ' - ', @summary)"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:for-each>
      </body>
    </html>
	</xsl:template>
</xsl:stylesheet>

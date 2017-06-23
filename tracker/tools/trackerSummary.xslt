<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" saxon:byte-order-mark="yes" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:calendar="java:java.util.Calendar" xmlns:datef="java:java.text.SimpleDateFormat" xmlns:saxon="http://saxon.sf.net/" exclude-result-prefixes="xs calendar datef saxon">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="days" as="xs:integer" select="7"/>
	<xsl:param name="offset" as="xs:integer" select="0"/>
	<xsl:param name="baseDir" as="xs:string" select="''"/>
	<xsl:param name="staleDays" as="xs:integer" select="90"/>
	<xsl:param name="staleCutoff" as="xs:integer" select="50"/>
	<xsl:param name="interestedEmailFileName" as="xs:string" select="''"/>
	<xsl:param name="interestedReportFileName" as="xs:string" select="''"/>
	<xsl:variable name="htmlNS" select="'http://www.w3.org/1999/xhtml'"/>
	<xsl:variable name="doneStatus" as="xs:string+" select="('Duplicate', 'Deferred', 'Resolved - No change')"/>
	<xsl:variable name="calendar" select="calendar:getInstance()"/>
	<xsl:variable name="interestedParties" select="document('../interestedParties.xml')/interestedParties" as="element(interestedParties)"/>
	<xsl:variable name="endDate">
    <xsl:message select="concat('Current:', datef:format(datef:new(&quot;yyyy-MM-dd&quot;), calendar:getTime($calendar)))"/>
    <xsl:if test="count(calendar:add($calendar, 5, -1*$offset))=0">
      <xsl:value-of select="datef:format(datef:new(&quot;yyyy-MM-dd&quot;), calendar:getTime($calendar))"/>
    </xsl:if>
  </xsl:variable>
	<xsl:variable name="startDate">
    <xsl:message select="concat('End:', $endDate)"/>
    <xsl:if test="count(calendar:add($calendar, 5, -1*$days))=0">
      <xsl:value-of select="datef:format(datef:new(&quot;yyyy-MM-dd&quot;), calendar:getTime($calendar))"/>
    </xsl:if>
	</xsl:variable>
	<xsl:variable name="displayEndDate">
    <xsl:message select="concat('Start:', $startDate)"/>
    <xsl:if test="count(calendar:add($calendar, 5, $days -1))=0">
      <xsl:value-of select="datef:format(datef:new(&quot;yyyy-MM-dd&quot;), calendar:getTime($calendar))"/>
    </xsl:if>
	</xsl:variable>
	<xsl:variable name="staleDate">
    <xsl:message select="concat('Display:', $displayEndDate)"/>
    <xsl:variable name="secondCalendar" select="calendar:getInstance()"/>
    <xsl:if test="count(calendar:add($secondCalendar, 5, -1*($offset+$staleDays)))=0">
      <xsl:value-of select="datef:format(datef:new(&quot;yyyy-MM-dd&quot;), calendar:getTime($secondCalendar))"/>
    </xsl:if>
	</xsl:variable>
	<xsl:variable name="summary" as="element(item)*">
    <xsl:message select="concat('Stale:', $staleDate)"/>
    <xsl:apply-templates mode="summarize" select="trackerItems/item"/>
	</xsl:variable>
	<xsl:variable name="changed" as="element(item)*" select="$summary[change or comment[@changed]]"/>
	<xsl:template match="/">
    <xsl:if test="not($summary[change])">
      <!-- For some reason, including this if statement changes the processing -->
      <xsl:message>No changes</xsl:message>
    </xsl:if>
    <xsl:if test="$interestedEmailFileName!=''">
      <xsl:result-document encoding="UTF-8" method="text" href="../{substring-after($interestedEmailFileName, $baseDir)}">
        <xsl:copy-of select="concat('tolist.interested=', string-join(distinct-values($changed/interestedIndividual/@email), ','))"/>
      </xsl:result-document>
    </xsl:if>
    <xsl:if test="$interestedReportFileName!=''">
      <xsl:result-document encoding="UTF-8" method="xml" version="1.0" indent="yes" href="../{substring-after($interestedReportFileName, $baseDir)}">
        <xsl:call-template name="createInterestedReport"/>
      </xsl:result-document>
    </xsl:if>
    <xsl:call-template name="createSummaryPage"/>
	</xsl:template>
	<xsl:template name="createInterestedReport">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <xsl:variable name="title" select="concat('FHIR Tracker Items of Interest: ', $startDate, ' to ', $displayEndDate)"/>
      <head>
        <title>
          <xsl:value-of select="$title"/>
        </title>
      </head>
      <body>
        <h1>
          <xsl:value-of select="$title"/>
        </h1>
        <p>This report lists the items flagged as "of interest" to registered co-chairs and facilitators that have had a significant change within the above time-period.</p>
        <p>Click your name to jump to the list of items you're interested in or click <a href="summary">here</a> to jump to a summary of all changes.</p>
        <p>If the character-encoding is wonky, try downloading the file and opening the downloaded file rather than opening directly from the email.  (If someone knows how to get Ant email file encodings to work properly, contact your FMG rep . . .</p>
        <ul>
          <xsl:for-each select="distinct-values($changed/interestedIndividual/@name)">
            <xsl:sort select="."/>
            <li>
              <a href="#name_{position()}">
                <xsl:value-of select="."/>
              </a>
            </li>
          </xsl:for-each>
        </ul>
        <h2>Interested Individuals</h2>
        <xsl:if test="not($changed/interestedIndividual)">
          <p>N/A</p>
        </xsl:if>
        <xsl:for-each select="distinct-values($changed/interestedIndividual/@name)">
          <xsl:sort select="."/>
          <a name="name_{position()}">
            <xsl:text>&#x0a;</xsl:text>
          </a>
          <h3>
            <xsl:value-of select="."/>
          </h3>
          <ul>
            <xsl:for-each select="$changed[interestedIndividual[@name=current()]]">
              <xsl:sort select="@number"/>
              <li>
                <a href="#{@number}-chg">
                  <xsl:value-of select="@number"/>
                </a>
                <xsl:value-of select="concat(' - ', @summary)"/>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:for-each>
        <a name="summary">
          <xsl:text>&#x0a;</xsl:text>
        </a>
        <h3>Summary of all changed items</h3>
        <ul>
          <xsl:for-each select="$changed">
            <xsl:sort select="@number"/>
            <li>
              <a href="#{@number}-chg">
                <xsl:value-of select="@number"/>
              </a>
              <xsl:value-of select="concat(' - ', @summary)"/>
            </li>
          </xsl:for-each>
        </ul>
        <xsl:call-template name="showChanges"/>
      </body>
    </html>
  </xsl:template>
  <xsl:template name="createSummaryPage">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <xsl:variable name="title" select="concat('FHIR Tracker Summary from ', $startDate, ' to ', $displayEndDate)"/>
      <head>
        <title>
          <xsl:value-of select="$title"/>
        </title>
      </head>
      <body>
        <h1>
          <xsl:value-of select="$title"/>
        </h1>
        <p>
          <xsl:value-of select="concat('This shows the current state of tracker resolution as of the end of ', $displayEndDate, '.  ')"/>
          <xsl:text> (UTC).  It also provides a summary of the significant FHIR tracker item changes for the period from</xsl:text>
          <xsl:value-of select="concat(' ', $startDate, ' to ', $displayEndDate, ', inclusive.')"/>
        </p>
        <a href="#stats">Summary Statistics</a>
        <br/>
        <a href="#changes">Change list</a>
        <div>
          <a name="stats">
            <xsl:text>&#x0a;</xsl:text>
          </a>
          <h1>Statistics</h1>
          <p>Numbers in brackets represent approximate net change in the specified time period</p>
          <p><span style="color:red">Red</span> indicates open ballot items.  <span style="color:green">Green</span> indicates closed ballot items.</p>
          <p>Rows in <i>Italics</i> are for items related to resources/pages/projects that are "of interest" to the work group but aren't owned by the work group.</p>
          <table border="1" style="border-collapse:collapse">
            <tbody>
              <tr>
                <th/>
                <th>Triaged</th>
                <th>Waiting for Input</th>
                <th>Resolved-Unapplied</th>
                <th>Closed</th>
                <th>Updated</th>
                <th>
                  <xsl:value-of select="concat('Stale (&gt;', $staleDays, ' days)')"/>
                </th>
                <th>Total</th>
              </tr>
              <xsl:call-template name="doSummary">
                <xsl:with-param name="label" select="'Everything'"/>
                <xsl:with-param name="items" select="$summary"/>
              </xsl:call-template>
              <tr>
                <td colspan="7" style="font-size:12pt;font-weight:bold">By Specification</td>
              </tr>
              <xsl:call-template name="doSummary">
                <xsl:with-param name="label" select="'FHIR Core'"/>
                <xsl:with-param name="items" select="$summary[@specification='FHIR Core']"/>
              </xsl:call-template>
              <xsl:for-each select="distinct-values($summary/@specification[not(.='FHIR Core')])">
                <xsl:sort select="."/>
                <xsl:call-template name="doSummary">
                  <xsl:with-param name="label" select="."/>
                  <xsl:with-param name="items" select="$summary[@specification=current()]"/>
                </xsl:call-template>
              </xsl:for-each>
              <tr>
                <td colspan="7" style="font-size:12pt;font-weight:bold">By Responsible Group</td>
              </tr>
              <xsl:for-each select="distinct-values(/trackerItems/item/*[self::reviewingWorkGroup or self::interestedWG][not(.=('None', 'IG Project'))])">
                <xsl:sort select="."/>
                <xsl:call-template name="doSummary">
                  <xsl:with-param name="label" select="."/>
                  <xsl:with-param name="items" select="$summary[reviewingWorkGroup=current()]"/>
                  <xsl:with-param name="interestedItems" select="$summary[interestedWG=current()]"/>
                </xsl:call-template>
              </xsl:for-each>
              <xsl:for-each select="distinct-values($summary[reviewingWorkGroup='IG Project']/@specification)">
                <xsl:sort select="."/>
                <xsl:call-template name="doSummary">
                  <xsl:with-param name="label" select="concat(., ' project')"/>
                  <xsl:with-param name="items" select="$summary[reviewingWorkGroup='IG Project' and @specification=current()]"/>
                </xsl:call-template>
              </xsl:for-each>
              <tr>
                <td colspan="7" style="font-size:12pt;font-weight:bold">By Resource</td>
              </tr>
              <xsl:for-each select="distinct-values($summary/resources[not(.=('None'))])">
                <xsl:sort select="."/>
                <xsl:call-template name="doSummary">
                  <xsl:with-param name="label" select="."/>
                  <xsl:with-param name="items" select="$summary[resources=current()]"/>
                </xsl:call-template>
              </xsl:for-each>
            </tbody>
          </table>
        </div>
        <div>
          <a name="changes">
            <xsl:text>&#x0a;</xsl:text>
          </a>
          <h1>
            <xsl:value-of select="concat('Significant tracker changes in the last ', $days, ' day(s)')"/>
          </h1>
          <p>Significant changes include status change, re-assignment or addition of comments or attachments.  Some items may be listed under more than one work group and/or resource/page</p>
          <p><b>Bold</b> items are owned by the associated work groups.  Non-bold items are "of interest" to the work group (see interestedParties.xml).</p>
          <p>
            <span>Jump to </span>
            <a href="#details">Details</a>
          </p>
          <p>
            <span>Jump to spec: </span>
            <xsl:for-each select="distinct-values($changed/@specification)">
              <xsl:if test="position()!=1">
                <xsl:if test="position()&gt;2">, </xsl:if>
                <a href="#spec-{position()}">
                  <xsl:value-of select="."/>
                </a>
              </xsl:if>
            </xsl:for-each>
          </p>
          <table border="1" style="border-collapse:collapse">
            <tbody>
              <tr>
                <th>Specification</th>
                <th>Work Group</th>
                <th>Resource/page</th>
                <th>Item(s)</th>
              </tr>
              <xsl:for-each select="distinct-values($changed/@specification)">
                <xsl:sort select="."/>
                <xsl:variable name="spec" select="."/>
                <xsl:variable name="specPos" select="position()"/>
                <xsl:for-each select="distinct-values($changed[@specification=$spec]/*[self::reviewingWorkGroup or self::interestedWG])">
                  <xsl:sort select="."/>
                  <xsl:variable name="wg" select="."/>
                  <xsl:variable name="wgPos" select="position()"/>
                  <xsl:variable name="resourcesExist" select="exists($changed[@specification=$spec and (reviewingWorkGroup=$wg or interestedWG=$wg)]/resources[not(.='None')])"/> 
                  <xsl:for-each select="distinct-values($changed[@specification=$spec and (reviewingWorkGroup=$wg or interestedWG=$wg)]/resources[not(.='None')])">
                    <xsl:sort select="."/>
                    <xsl:variable name="resource" select="."/>
                    <xsl:variable name="resourcePos" select="position()"/>
                    <tr>
                      <td>
                        <xsl:if test="$wgPos=1 and $resourcePos=1">
                          <a name="spec-{$specPos}">
                            <xsl:text>&#x0a;</xsl:text>
                          </a>
                          <xsl:value-of select="$spec"/>
                        </xsl:if>
                      </td>
                      <td>
                        <xsl:if test="$resourcePos=1">
                          <xsl:value-of select="$wg"/>
                        </xsl:if>
                      </td>
                      <td>
                        <a href="http://hl7-fhir.github.io/{lower-case($resource)}.html">
                          <xsl:value-of select="$resource"/>
                        </a>
                      </td>
                      <td>
                        <xsl:for-each select="$changed[@specification=$spec and (reviewingWorkGroup=$wg or interestedWG=$wg) and resources=$resource]">
                          <xsl:sort select="@number"/>
                          <xsl:if test="position()!=1">, </xsl:if>
                          <a href="#{@number}-chg" title="{@summary}" style="{if (reviewingWorkGroup=$wg) then 'font-weight:bold' else ''}">
                            <xsl:value-of select="@number"/>
                          </a>
                        </xsl:for-each>
                      </td>
                    </tr>
                  </xsl:for-each>
                  <xsl:for-each select="distinct-values($changed[@specification=$spec and (reviewingWorkGroup=$wg or interestedWG=$wg)]/hTMLPages[not(.='None')])">
                    <xsl:sort select="."/>
                    <xsl:variable name="page" select="."/>
                    <xsl:variable name="pagePos" select="position()"/>
                    <tr>
                      <td>
                        <xsl:if test="$wgPos=1 and $pagePos=1 and not($resourcesExist)">
                          <a name="spec-{$specPos}">
                            <xsl:text>&#x0a;</xsl:text>
                          </a>
                          <xsl:value-of select="$spec"/>
                        </xsl:if>
                      </td>
                      <td>
                        <xsl:if test="$pagePos=1 and not($resourcesExist)">
                          <xsl:value-of select="$wg"/>
                        </xsl:if>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="contains($page, '(')">
                            <xsl:value-of select="$page"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <a href="http://hl7-fhir.github.io/{$page}.html">
                              <xsl:value-of select="$page"/>
                            </a>
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:for-each select="$changed[@specification=$spec and (reviewingWorkGroup=$wg or interestedWG=$wg) and hTMLPages=$page]">
                          <xsl:sort select="@number"/>
                          <xsl:if test="position()!=1">, </xsl:if>
                          <a href="#{@number}-chg" title="{@summary}" style="{if (reviewingWorkGroup=$wg) then 'font-weight:bold' else ''}">
                            <xsl:value-of select="@number"/>
                          </a>
                        </xsl:for-each>
                      </td>
                    </tr>
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:for-each>
            </tbody>
          </table>
          <xsl:call-template name="showChanges"/>
        </div>
      </body>
    </html>
  </xsl:template>
  <xsl:template name="showChanges">
    <a xmlns="http://www.w3.org/1999/xhtml" name="details"/>
    <h2 xmlns="http://www.w3.org/1999/xhtml">Change Details</h2>
    <xsl:for-each select="$changed">
      <xsl:sort select="@number"/>
      <a xmlns="http://www.w3.org/1999/xhtml" name="{@number}-chg"/>
      <h3 xmlns="http://www.w3.org/1999/xhtml">
        <a href="http://gforge.hl7.org/gf/project/fhir/tracker/?action=TrackerItemEdit&amp;tracker_item_id={@number}">
          <xsl:value-of select="@number"/>
        </a>
        <xsl:value-of select="concat(' - ', @summary)"/>
      </h3>
      <table xmlns="http://www.w3.org/1999/xhtml">
        <tbody>
          <tr>
            <td style="vertical-align:top;padding:5pt;font-weight:normal;text-indent:5pt;font-family:sans-serif">Categorization</td>
            <td style="vertical-align:top;">
              <table>
                <tbody>
                  <tr>
                    <td style="font-family:sans-serif;font-style:italic">Specification:</td>
                    <td>
                      <xsl:value-of select="@specification"/>
                    </td>
                  </tr>
                  <tr>
                    <td style="font-family:sans-serif;font-style:italic">Work Group(s):</td>
                    <td>
                      <xsl:value-of select="string-join(reviewingWorkGroup, ', ')"/>
                    </td>
                  </tr>
                  <xsl:if test="resources[.!='None']">
                    <tr>
                      <td style="font-family:sans-serif;font-style:italic">Resource(s):</td>
                      <td>
                        <xsl:for-each select="resources[.!='None']">
                          <xsl:if test="position()!=1">, </xsl:if>
                          <a href="http://hl7-fhir.github.io/{lower-case(.)}.html">
                            <xsl:value-of select="."/>
                          </a>
                        </xsl:for-each>
                      </td>
                    </tr>
                  </xsl:if>
                  <xsl:if test="hTMLPages[.!='None']">
                    <tr>
                      <td style="font-family:sans-serif;font-style:italic">HTML Page(s):</td>
                      <td>
                        <xsl:for-each select="hTMLPages[.!='None']">
                          <xsl:if test="position()!=1">, </xsl:if>
                          <xsl:choose>
                            <xsl:when test="contains(., '(')">
                              <xsl:value-of select="."/>
                            </xsl:when>
                            <xsl:otherwise>
                              <a href="http://hl7-fhir.github.io/{.}.html">
                                <xsl:value-of select="."/>
                              </a>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:for-each>
                      </td>
                    </tr>
                  </xsl:if>
                </tbody>
              </table>
            </td>
          </tr>
          <xsl:if test="change">
            <tr>
              <td style="vertical-align:top;padding:5pt;font-weight:normal;text-indent:5pt;font-family:sans-serif">Changes</td>
              <td style="vertical-align:top;">
                <ul style="padding:0px;padding-left:15px;margin:0px;font-weight:bold">
                  <xsl:for-each select="change[@name='_created_']">
                    <li>New Tracker item</li>
                  </xsl:for-each>
                  <xsl:for-each select="change[@name='specification']">
                    <li>
                      <xsl:value-of select="concat('Tracker reassigned specification from &quot;', @old, '&quot; to &quot;', @new, '&quot;')"/>
                    </li>
                  </xsl:for-each>
                  <xsl:for-each select="change[@name='summary']">
                    <li>
                      <xsl:value-of select="concat('Summary changed from &quot;', @old, '&quot; to &quot;', @new, '&quot;')"/>
                    </li>
                  </xsl:for-each>
                  <xsl:for-each select="change[@name='pre-applied']">
                    <li>
                      <xsl:value-of select="concat('Pre-applied was set to &quot;', @new, '&quot;')"/>
                    </li>
                  </xsl:for-each>
                  <xsl:for-each select="change[@name='retractWithdraw']">
                    <li>
                      <xsl:value-of select="concat('Retract/Withdraw was set to &quot;', @new, '&quot;')"/>
                    </li>
                  </xsl:for-each>
                  <xsl:for-each select="change[@name='moverSeconderFor-Against-Abstain']">
                    <li>
                      <xsl:value-of select="if (@new='') then 'Vote information was cleared' else 'Vote information was recorded'"/>
                    </li>
                  </xsl:for-each>
                  <xsl:for-each select="change[@name='status']">
                    <li>
                      <xsl:choose>
                        <xsl:when test="@new='Triaged'">Item was triaged</xsl:when>
                        <xsl:when test="@new='Waiting for Input' and @old=('Submitted', 'Triaged')">
                          <xsl:value-of select="concat('Item is now waiting for input on: ', string-join(waiting-on, ', '))"/>
                        </xsl:when>
                        <xsl:when test="@new='Deferred' and @old=('Submitted', 'Triaged')">
                          <xsl:value-of select="'Item is has been deferred to a future release'"/>
                        </xsl:when>
                        <xsl:when test="@new='Duplicate' and @old=('Submitted', 'Triaged')">
                          <xsl:value-of select="concat('Item was marked as a duplicate of ', dup)"/>
                        </xsl:when>
                        <xsl:when test="@new='Resolved - No change' and @old!=('Applied', 'Published')">Item was resolved - No change</xsl:when>
                        <xsl:when test="@new='Resolved - Change required' and @old!=('Applied', 'Published')">Item was resolved - Change required</xsl:when>
                        <xsl:when test="@new='Applied'">Tracker change was applied</xsl:when>
                        <xsl:when test="@new='Published'">Tracker change was published</xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="concat('Status changed from ', @old, ' to ', @new)"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </li>
                  </xsl:for-each>
<!-- TODO: attachment -->
                </ul>
              </td>
            </tr>
          </xsl:if>
          <tr>
            <td style="vertical-align:top;padding:5pt;font-weight:normal;text-indent:5pt;font-family:sans-serif">Detail</td>
            <td style="vertical-align:top;padding:0pt">
              <xsl:apply-templates mode="copy-html" select="details/*"/>
            </td>
          </tr>
          <xsl:if test="comment">
            <tr>
              <td style="vertical-align:top;padding:5pt;font-weight:normal;text-indent:5pt;font-family:sans-serif">Comments</td>
              <td style="vertical-align:top;padding:0pt">
                <table>
                  <tbody>
                    <xsl:for-each select="comment">
                      <tr>
                        <td>
                          <xsl:if test="@changed">
                            <xsl:attribute name="style" select="'font-weight:bold'"/>
                          </xsl:if>
                          <xsl:value-of select="substring(@date,1,10)"/>
                          <br/>
                          <xsl:value-of select="@authorName"/>
                        </td>
                        <td>
                          <xsl:apply-templates mode="copy-html" select="*"/>
                        </td>
                      </tr>
                    </xsl:for-each>
                  </tbody>
                </table>
              </td>
            </tr>
          </xsl:if>
          <xsl:if test="resolution!=''">
            <tr>
              <td style="vertical-align:top;padding:5pt;font-weight:normal;text-indent:5pt;font-family:sans-serif">Resolution</td>
              <td style="vertical-align:top;padding:0pt">
                <xsl:apply-templates mode="copy-html" select="resolution/*"/>
              </td>
            </tr>
          </xsl:if>
        </tbody>
      </table>
    </xsl:for-each>
  </xsl:template>
	<xsl:template name="doSummary">
    <xsl:param name="label" as="xs:string"/>
    <xsl:param name="items" as="element(item)*"/>
    <xsl:param name="interestedItems" as="element(item)*"/>
    <xsl:if test="count($items)+count($interestedItems)&gt;0">
      <tr xmlns="http://www.w3.org/1999/xhtml">
        <td>
          <xsl:value-of select="$label"/>
        </td>
        <xsl:choose>
          <xsl:when test="count($items)&gt;0">
            <xsl:call-template name="doSummaryDetails">
              <xsl:with-param name="items" select="$items"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="doSummaryDetails">
              <xsl:with-param name="items" select="$interestedItems"/>
              <xsl:with-param name="italic" select="true()"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </tr>
    </xsl:if>
    <xsl:if test="count($items)>0 and count($interestedItems)>0">
      <tr xmlns="http://www.w3.org/1999/xhtml">
        <td>&#xA0;&#xA0;(interested)</td>
        <xsl:call-template name="doSummaryDetails">
          <xsl:with-param name="items" select="$interestedItems"/>
          <xsl:with-param name="italic" select="true()"/>
        </xsl:call-template>
      </tr>
    </xsl:if>
	</xsl:template>
	<xsl:template name="doSummaryDetails">
    <xsl:param name="items" as="element(item)+"/>
    <xsl:param name="italic" as="xs:boolean" select="false()"/>
    <xsl:call-template name="doSummaryColumn">
      <xsl:with-param name="status" select="('Triaged')"/>
      <xsl:with-param name="items" select="$items"/>
      <xsl:with-param name="italic" select="$italic"/>
    </xsl:call-template>
    <xsl:call-template name="doSummaryColumn">
      <xsl:with-param name="status" select="('Waiting for Input')"/>
      <xsl:with-param name="items" select="$items"/>
      <xsl:with-param name="italic" select="$italic"/>
    </xsl:call-template>
    <xsl:call-template name="doSummaryColumn">
      <xsl:with-param name="status" select="'Resolved - Change required'"/>
      <xsl:with-param name="items" select="$items"/>
      <xsl:with-param name="italic" select="$italic"/>
    </xsl:call-template>
    <xsl:call-template name="doSummaryColumn">
      <xsl:with-param name="status" select="$doneStatus"/>
      <xsl:with-param name="items" select="$items"/>
      <xsl:with-param name="italic" select="$italic"/>
    </xsl:call-template>
    <td xmlns="http://www.w3.org/1999/xhtml" style="font-family:monospace;text-align:right{if ($italic) then ';font-style:italic' else ''}">
      <xsl:value-of select="count($items[change|comment])"/>
    </td>
    <td xmlns="http://www.w3.org/1999/xhtml" style="font-family:monospace;text-align:right{if ($italic) then ';font-style:italic' else ''}">
      <xsl:variable name="openItems" as="element(item)*" select="$items[@status=('Triaged', 'Waiting for Input')]"/>
      <xsl:variable name="staleItems" as="xs:integer" select="count($openItems[@stale='true'])"/>
      <xsl:choose>
        <xsl:when test="$italic"/>
        <xsl:when test="count($openItems)=0">N/A</xsl:when>
        <xsl:otherwise>
          <xsl:variable name="stalePercent" select="round($staleItems * 100 div count($openItems))"/>
          <xsl:variable name="staleString" select="concat($staleItems, ' (', $stalePercent, '%)')"/>
          <xsl:choose>
            <xsl:when test="$stalePercent &gt; $staleCutoff">
              <b style="color:red">
                <xsl:value-of select="$staleString"/>
              </b>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$staleString"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </td>
    <td xmlns="http://www.w3.org/1999/xhtml" style="font-family:monospace;text-align:right{if ($italic) then ';font-style:italic' else ''}">
      <xsl:value-of select="count($items)"/>
    </td>
	</xsl:template>
	<xsl:template name="doSummaryColumn">
    <xsl:param name="status" as="xs:string+"/>
    <xsl:param name="items" as="element(item)+"/>
    <xsl:param name="italic" as="xs:boolean"/>
    <xsl:variable name="current" as="xs:integer" select="count($items[@status=$status])"/>
    <xsl:variable name="ballot" as="xs:integer" select="count($items[@status=$status and ballot!='None'])"/>
    <xsl:variable name="removed" as="xs:integer" select="count($items/change[@name='status' and @old=$status])"/>
    <xsl:variable name="added" as="xs:integer" select="count($items/change[@name='status' and @new=$status])"/>
    <xsl:variable name="delta" as="xs:integer" select="$added - $removed"/>
    <xsl:variable name="deltaString" as="xs:string" select="concat('(', if ($delta &lt; 0) then $delta else concat('+', $delta), ')')"/>
    <td xmlns="http://www.w3.org/1999/xhtml" style="font-family:monospace;text-align:right">
      <xsl:if test="$ballot!=0">
        <span style="color:{if ($status=$doneStatus) then 'green' else 'red'}{if ($italic) then ';font-style:italic' else ''}">
          <xsl:value-of select="$ballot"/>
        </span>
      </xsl:if>
      <span style="{if ($italic) then ';font-style:italic' else ''}">
        <xsl:value-of select="concat(substring('&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;', 1, 5-string-length(concat($current, ''))), $current, substring('&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;', 1, 7-string-length($deltaString)), $deltaString)"/>
      </span>
    </td>
	</xsl:template>
	<xsl:template mode="copy-html" match="@*|text()">
    <xsl:copy-of select="."/>
  </xsl:template>
	<xsl:template mode="copy-html" match="*">
    <xsl:element name="{name(.)}" namespace="{$htmlNS}">
      <xsl:apply-templates mode="copy-html" select="@*|node()"/>
    </xsl:element>
	</xsl:template>
	<xsl:template mode="copy-html" priority="5" match="*:p[normalize-space(translate(., '&#xA0;', ' '))='']">
	</xsl:template>
		<xsl:template mode="copy-html" priority="5" match="br[count(preceding-sibling::*[normalize-space(.)!=''])=0 or count(following-sibling::*[normalize-space(.)=''])=0]">
	</xsl:template>
	<xsl:template mode="summarize" match="item">
    <xsl:copy>
      <xsl:copy-of select="@number|@summary|@status|@specification"/>
      <xsl:variable name="changesSinceStale" as="element()*">
        <xsl:call-template name="checkChanges">
          <xsl:with-param name="start" select="$staleDate"/>
          <xsl:with-param name="end" select="$endDate"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="count($changesSinceStale)=0">
        <xsl:attribute name="stale" select="'true'"/>
      </xsl:if>
      <xsl:copy-of select="ballot|resolution|resources|hTMLPages|reviewingWorkGroup"/>
      <xsl:for-each select="$interestedParties/workGroup[resource/@name=current()/resources or page/@name=current()/hTMLPages or guide/@name=current()/@specification]">
        <interestedWG>
          <xsl:value-of select="@name"/>
        </interestedWG>
      </xsl:for-each>
      <xsl:for-each select="$interestedParties/individual[resource/@name=current()/resources or page/@name=current()/hTMLPages or guide/@name=current()/@specification or (@newItems='true' and substring(current()/@opened,1,10)&lt;=$endDate and substring(current()/@opened,1,10)&gt;=$startDate)]">
        <interestedIndividual>
          <xsl:copy-of select="@*"/>
        </interestedIndividual>
      </xsl:for-each>
      <xsl:variable name="changeInfo" as="element()*">
        <xsl:call-template name="checkChanges">
          <xsl:with-param name="start" select="$startDate"/>
          <xsl:with-param name="end" select="$endDate"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$changeInfo">
        <xsl:copy-of select="details|$changeInfo"/>
      </xsl:if>
    </xsl:copy>
	</xsl:template>
  <xsl:template name="checkChanges">
    <xsl:param name="start" required="yes"/>
    <xsl:param name="end" required="yes"/>
    <xsl:variable name="changes" as="element(changes)">
      <changes>
        <xsl:for-each select="change[substring(@date,1,10)&lt;=$end and substring(@date,1,10)&gt;=$start]">
          <xsl:sort select="@date"/>
          <xsl:apply-templates mode="summarize" select="."/>
        </xsl:for-each>
      </changes>
    </xsl:variable>
    <xsl:for-each select="distinct-values($changes/change/element/@name)">
      <xsl:variable name="old">
        <xsl:for-each select="$changes/change/element[@name=current()][1]/@old">
          <xsl:if test="position()=last()">
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="new">
        <xsl:for-each select="$changes/change/element[@name=current()]/@new">
          <xsl:if test="position()=last()">
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:if test="$old!=$new">
        <change name="{.}" old="{$old}" new="{$new}"/>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="comment[substring(@date,1,10)&lt;=$end and substring(@date,1,10)&gt;=$start and not(contains(normalize-space(.), 'svn revision'))]">
      <!-- If any comments have changed in the time range, then we want all comments (to give context) -->
      <xsl:apply-templates mode="summarize" select="comment[not(contains(normalize-space(.), 'svn revision'))]"/>
    </xsl:if>
  </xsl:template>
	<xsl:template mode="summarize" match="change" as="element(change)?">
    <xsl:variable name="elements" select="element[@name=('_created_', 'status', 'specification', 'summary', 'pre-applied', 'moverSeconderFor-Against-Abstain', 'attachment', 'retractWithdraw')]"/>
    <xsl:if test="$elements">
      <xsl:copy>
        <xsl:copy-of select="@date|$elements"/>
      </xsl:copy>
    </xsl:if>
	</xsl:template>
	<xsl:template mode="summarize" match="comment">
    <xsl:copy>
      <xsl:if test="substring(@date,1,10)&lt;$endDate and substring(@date,1,10)&gt;=$startDate">
        <xsl:attribute name="changed" select="'true'"/>
      </xsl:if>
      <xsl:copy-of select="@*|node()"/>
    </xsl:copy>
	</xsl:template>
</xsl:stylesheet>

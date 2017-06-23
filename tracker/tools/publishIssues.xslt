<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="droppedResources" as="xs:string+" select="('DeviceUseRequest', 'DeviceUseStatement', 'RiskAssessment', 'ImplementationGuide', 'TestScript', 'Claim', 'ClaimResponse', 'Contract', 'Coverage', 'EligibilityRequest', 'EligibilityResponse', 'EnrollmentRequest', 'EnrollmentResponse', 'ExplanationOfBenefit', 'PaymentNotice', 'PaymentReconciliation', 'ProcessRequest', 'ProcessResponse', 'VisionPrescription', 'BodySite', 'Order', 'OrderResponse', 'SupplyDelivery', 'SupplyRequest', 'Account', 'ClinicalImpression')"/>
	<xsl:variable name="inScopeItems" as="element(item)*" select="trackerItems/item[(resources='None' or resources[not(.=$droppedResources)]) and not(reviewingWorkGroup='FHIR Test Servers')]"/>
	<xsl:variable name="openItems" as="element(item)*" select="$inScopeItems[not(@status=('Applied', 'Published', 'Resolved - No change', 'Duplicate', 'Deferred', 'Submitted'))]"/>
	<xsl:variable name="resolvedNegativeItems" as="element(item)*" select="$inScopeItems[not(@status=('Triaged', 'Waiting for Input', 'Submitted', 'Duplicate')) and starts-with(@ballot-weight, 'Negative') and not(ballot='2015-Jan Core') and @category!='Typo' and (@category!='Correction' or not(reviewingWorkGroup='FHIR Tooling/Pubs')) and not(@retractWithdraw)]"/>
	<xsl:variable name="ballotItems" as="element(item)*" select="$openItems[ballot!='None']"/>
	<xsl:variable name="negativeItems" as="element(item)*" select="$ballotItems[starts-with(@ballot-weight, 'Negative')]"/>
	<xsl:variable name="substantiveItems" as="element(item)*" select="$openItems[not(@number=$negativeItems/@number) and not(@changeType='Non-substantive')]"/>
	<xsl:variable name="otherItems" as="element(item)*" select="$openItems[not(@number=$negativeItems/@number) and @changeType='Non-substantive']"/>
	<xsl:variable name="issueTypes" as="element(type)*">
    <type issueNum="1" description="Critical (Negative vote) - Need work group vote (and ideally application) by Feb 5th, 2016"/>
    <type issueNum="2" description="Critical (Negative vote) - Approved change must be applied by Feb 19th (Feb 26th if non-substantive)"/>
    <type issueNum="3" description="Priority (Substantive) - Should apply change by Feb 19 - substantive change"/>
    <type issueNum="4" description="Priority (Substantive) - Should determine if substantive (and prioritize applying change if they are) by Feb 19th"/>
    <type issueNum="5" description="Low (Non-negative, non-substantive) - Should resolve and apply - ideally with WG vote (but can be editor decision if not major) by Feb 26"/>
    <type issueNum="6" description="Low (Non-negative, non-substantive) - Should apply by Feb 26"/>
    <type issueNum="7" description="Critical (Negative vote) - Issue marked as resolved but no ballotResolution captured - Must be fixed by Feb 5"/>
    <type issueNum="8" description="Critical (Negative vote) - Issue marked other than Persuasive/Not Persuasive and no resolution specified - Must be fixed by Feb 5"/>
    <type issueNum="9" description="Priority (Negative vote) - Vote is not captured or recorded in invalid format - Must be fixed by Feb 5"/>
    <type issueNum="10" description="Priority (Negative vote) - Vote date is missing - Must be fixed by Feb 5"/>
    <type issueNum="11" description="Low - Change is required but change type not specified - Should be fixed by Feb 5"/>
  </xsl:variable>
  <xsl:variable name="issues" as="element(issue)*">
    <xsl:call-template name="addIssues">
      <xsl:with-param name="issueNum" select="1"/>
      <xsl:with-param name="items" select="$negativeItems[@status=('Triaged','Waiting for Input')]"/>
    </xsl:call-template>
    <xsl:call-template name="addIssues">
      <xsl:with-param name="issueNum" select="2"/>
      <xsl:with-param name="items" select="$negativeItems[@status='Resolved - Change required']"/>
    </xsl:call-template>
    <xsl:call-template name="addIssues">
      <xsl:with-param name="issueNum" select="3"/>
      <xsl:with-param name="items" select="$substantiveItems[@changeType]"/>
    </xsl:call-template>
    <xsl:call-template name="addIssues">
      <xsl:with-param name="issueNum" select="4"/>
      <xsl:with-param name="items" select="$substantiveItems[not(@changeType)]"/>
    </xsl:call-template>
    <xsl:call-template name="addIssues">
      <xsl:with-param name="issueNum" select="5"/>
      <xsl:with-param name="items" select="$otherItems[@status=('Triaged','Waiting for Input')]"/>
    </xsl:call-template>
    <xsl:call-template name="addIssues">
      <xsl:with-param name="issueNum" select="6"/>
      <xsl:with-param name="items" select="$otherItems[@status='Resolved - Change required']"/>
    </xsl:call-template>
    <xsl:call-template name="addIssues">
      <xsl:with-param name="issueNum" select="7"/>
      <xsl:with-param name="items" select="$resolvedNegativeItems[not(@ballotResolution)]"/>
    </xsl:call-template>
    <xsl:call-template name="addIssues">
      <xsl:with-param name="issueNum" select="8"/>
      <xsl:with-param name="items" select="$resolvedNegativeItems[not(@ballotResolution=('Persuasive', 'Not Persuasive')) and not(resolution/descendant::text()[normalize-space(.)!=''])]"/>
    </xsl:call-template>
    <xsl:call-template name="addIssues">
      <xsl:with-param name="issueNum" select="9"/>
      <xsl:with-param name="items" as="element(item)*">
        <xsl:copy-of select="$resolvedNegativeItems[not(@moverSeconderFor-Against-Abstain)]"/>
        <xsl:for-each select="$resolvedNegativeItems[@moverSeconderFor-Against-Abstain]">
          <xsl:variable name="voteIssues" as="xs:string*">
            <xsl:variable name="parts" as="xs:string*" select="tokenize(@moverSeconderFor-Against-Abstain, ':')"/>
            <xsl:choose>
              <xsl:when test="count($parts)!=2">Must have exactly one colon</xsl:when>
              <xsl:otherwise>
                <xsl:variable name="names" as="xs:string*" select="tokenize($parts[1], '/')"/>
                <xsl:variable name="vote" as="xs:string*" select="tokenize($parts[2], '-')"/>
                <xsl:if test="count($names)!=2">Must specify mover and seconder separated by '/'</xsl:if>
                <xsl:choose>
                  <xsl:when test="count($vote[normalize-space(.)!=''])!=3">Must specify for-against-abstain separated by '-'</xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="number($vote[1])&lt;=number($vote[2])">Affirmatives must be more than negatives in vote.  If not, don't capture the resolution</xsl:if>
                    <xsl:if test="normalize-space($vote[1])='1'">Need more than 1 affirmative vote to pass a motion</xsl:if>
                    <xsl:for-each select="$vote">
                      <xsl:if test="normalize-space(string(number(.)))!=normalize-space(.)">
                        <xsl:value-of select="concat('Votes must be numeric - ', .)"/>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:if test="count($voteIssues)!=0">
            <xsl:copy-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:with-param> 
    </xsl:call-template>
    <xsl:call-template name="addIssues">
      <xsl:with-param name="issueNum" select="10"/>
      <xsl:with-param name="items" select="$resolvedNegativeItems[not(@resolutionDate)]"/>
    </xsl:call-template>
    <xsl:call-template name="addIssues">
      <xsl:with-param name="issueNum" select="11"/>
      <xsl:with-param name="items" select="$openItems[@status='Resolved - Change required' and not(@changeType)]"/>
    </xsl:call-template>
  </xsl:variable>
	<xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title>Outstanding issues</title>
      </head>
      <body>
        <h1>
          <xsl:value-of select="concat('Tracker Publishing issues as of: ', trackerItems/@lastChange)"/>
        </h1>
        <p>This report is generrated continuously (with up to ~30 minute delay from the application of a tracker change).  It lists tracker items (or issues with them) that must or should be dealt with prior to specification publication.</p>
        <p><b>Critical</b> issues must be resolved for a resource/artifact to be published as DSTU.</p>
        <p><b>High</b> issues should be resolved.</p>
        <p>The remainder can be handled on a "time permitting" basis or (if non-substantive and depending on FMG decision) be applied in the first week of Sept.</p>
        <p>Note that in addition to the issues listed here, build warnings must also be addressed.  RIM mapping warnings will be addressed during the QA period.</p>
        <p>
          Jump to details by work group for <a href="#core">Core</a> or <a href="#igs">Implementation Guides</a>
        </p>
        <h1>Summary</h1>
        <xsl:for-each select="distinct-values($issues/@issueNum)">
          <xsl:sort select="." data-type="number"/>
          <xsl:variable name="issueNum" select="."/>
          <h2>
            <xsl:value-of select="$issueTypes[@issueNum=current()]/@description"/>
          </h2>
          <table>
            <tbody>
              <tr>
                <td>
                  <b>Total</b>
                </td>
                <td>
                  <b>
                    <xsl:value-of select="count($issues[@issueNum=current()])"/>
                  </b>
                </td>
              </tr>
              <xsl:for-each select="distinct-values($issues[@issueNum=$issueNum]/@workGroup)">
                <xsl:sort select="."/>
                <tr>
                  <td>
                    <a href="#{translate(., ' ()/\&amp;','')}">
                      <xsl:value-of select="."/>
                    </a>
                  </td>
                  <td>
                    <xsl:value-of select="count($issues[@issueNum=$issueNum and @workGroup=current()])"/>
                  </td>
                </tr>
              </xsl:for-each>
            </tbody>
          </table>
        </xsl:for-each>
        <a name="core">
          <xsl:text>&#x0a;</xsl:text>
        </a>
        <h1>
          <xsl:value-of select="concat('Details - Core (', count($issues/@workGroup[not(ends-with(.,'IG Project'))]), ')')"/>
        </h1>
        <xsl:for-each select="distinct-values($issues/@workGroup[not(ends-with(.,'IG Project'))])">
          <xsl:sort select="."/>
          <xsl:variable name="group" select="."/>
          <a name="{translate(., ' ()/\&amp;','')}">
            <xsl:text>&#x0a;</xsl:text>
          </a>
          <h2>
            <xsl:value-of select="concat(., ' (', count($issues[@workGroup=$group]), ')')"/>
          </h2>
          <p>
            <xsl:text>Impacted Resources: </xsl:text>
            <xsl:for-each select="distinct-values($issues[@workGroup=$group]/resources)">
              <xsl:sort select="."/>
              <xsl:if test="position()!=1">, </xsl:if>
              <xsl:value-of select="."/>
            </xsl:for-each>
          </p>
          <table>
            <tbody>
              <xsl:for-each select="distinct-values($issues[@workGroup=$group]/@issueNum)">
                <xsl:sort select="." data-type="number" order="ascending"/>
                <xsl:variable name="matchingIssues" as="element(issue)*" select="$issues[@workGroup=$group and @issueNum=current()]"/>
                <tr>
                  <td>
                    <xsl:value-of select="concat($issueTypes[@issueNum=current()]/@description, ' (', count($matchingIssues), ')')"/>
                  </td>
                  <td>
                    <xsl:for-each select="$matchingIssues">
                      <xsl:sort select="@number"/>
                      <xsl:if test="position()!=1">
                        <xsl:text>, </xsl:text>
                      </xsl:if>
                      <a href="http://gforge.hl7.org/gf/project/fhir/tracker/?action=TrackerItemEdit&amp;tracker_item_id={@number}"  target="_blank" title="{@summary}">
                        <xsl:value-of select="@number"/>
                      </a>
                    </xsl:for-each>
                  </td>
                </tr>
              </xsl:for-each>
            </tbody>
          </table>
        </xsl:for-each>
        <a name="igs">
          <xsl:text>&#x0a;</xsl:text>
        </a>
        <h1>
          <xsl:value-of select="concat('Details - Implementation Guides (', count($issues/@workGroup[ends-with(.,'IG Project')]), ')')"/>
        </h1>
        <xsl:for-each select="distinct-values($issues/@workGroup[ends-with(.,'IG Project')])">
          <xsl:sort select="."/>
          <xsl:variable name="group" select="."/>
          <a name="{translate(., ' ()/\&amp;','')}">
            <xsl:text>&#x0a;</xsl:text>
          </a>
          <h2>
            <xsl:value-of select="concat(., ' (', count($issues[@workGroup=$group]), ')')"/>
          </h2>
          <table>
            <tbody>
              <xsl:for-each select="distinct-values($issues[@workGroup=$group]/@issueNum)">
                <xsl:sort select="." data-type="number" order="ascending"/>
                <xsl:variable name="matchingIssues" as="element(issue)*" select="$issues[@workGroup=$group and @issueNum=current()]"/>
                <tr>
                  <td>
                    <xsl:value-of select="concat($issueTypes[@issueNum=current()]/@description, ' (', count($matchingIssues), ')')"/>
                  </td>
                  <td>
                    <xsl:for-each select="$matchingIssues">
                      <xsl:sort select="@number"/>
                      <xsl:if test="position()!=1">
                        <xsl:text>, </xsl:text>
                      </xsl:if>
                      <a href="http://gforge.hl7.org/gf/project/fhir/tracker/?action=TrackerItemEdit&amp;tracker_item_id={@number}"  target="_blank" title="{@summary}">
                        <xsl:value-of select="@number"/>
                      </a>
                    </xsl:for-each>
                  </td>
                </tr>
              </xsl:for-each>
            </tbody>
          </table>
        </xsl:for-each>
      </body>
    </html>
	</xsl:template>
  <xsl:template name="addIssues">
    <xsl:param name="issueNum" as="xs:integer"/>
    <xsl:param name="items" as="element(item)*"/>
    <xsl:for-each select="$items">
      <issue issueNum="{$issueNum}" issue="{$issueTypes[@issueNum=$issueNum]/@description}">
        <xsl:variable name="workGroup">
          <xsl:choose>
            <xsl:when test="count(reviewingWorkGroup)=1">
              <xsl:value-of select="reviewingWorkGroup"/>
            </xsl:when>
            <xsl:when test="reviewingWorkGroup='FHIR Infrastructure'">
              <xsl:text>FHIR Infrastructure</xsl:text>
            </xsl:when>
            <xsl:when test="reviewingWorkGroup='Patient Administration'">
              <xsl:text>Patient Administration</xsl:text>
            </xsl:when>
            <xsl:when test="reviewingWorkGroup='Patient Care'">
              <xsl:text>Patient Care</xsl:text>
            </xsl:when>
            <xsl:when test="reviewingWorkGroup='Orders &amp;amp; Observations'">
              <xsl:text>Orders &amp;amp; Observations</xsl:text>
            </xsl:when>
            <xsl:when test="reviewingWorkGroup='Financial Mgmt'">
              <xsl:text>Financial Mgmt</xsl:text>
            </xsl:when>
            <xsl:when test="reviewingWorkGroup='Devices'">
              <xsl:text>Devices</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="reviewingWorkGroup[1]"/>
<xsl:message select="concat($issueNum, ':', string-join(reviewingWorkGroup, ', '))"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="correctedWorkGroup">
          <xsl:choose>
            <xsl:when test="$workGroup='IG Project'">
              <xsl:value-of select="concat(@specification, ' ', 'IG Project')"/>
            </xsl:when>
            <xsl:when test="contains($workGroup, '&amp;amp;')">
              <xsl:value-of select="concat(substring-before($workGroup, '&amp;amp;'), '&amp;', substring-after($workGroup, '&amp;amp;'))"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$workGroup"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="workGroup" select="$correctedWorkGroup"/>
        <xsl:copy-of select="@number|@summary|resources"/>
      </issue>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>

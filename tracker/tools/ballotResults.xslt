<?xml version="1.0" encoding="UTF-8"?>
<!-- Todo: need to capture submitter ballot row going forward -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"  xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xs">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:variable name="inScopeItems" as="xs:string*" select="/*:Tracker/*:TrackerItem/@id"/>
<!--  <xsl:variable name="inScopeItems" as="xs:string*" select="tokenize(/*:items, ',')"/>-->
  <xsl:variable name="allItems" as="element(item)*" select="document('tracker.xml')/trackerItems/item"/>
  <xsl:variable name="items" as="element(item)*" select="$allItems[@number=$inScopeItems]"/>
<!--  <xsl:variable name="allItems" as="element(item)*" select="/trackerItems/item"/>
  <xsl:variable name="items" as="element(item)*" select="$allItems[ballot='2015-May Core']"/>-->
  <xsl:template match="/">
<xsl:message select="count($inScopeItems)"/>
<xsl:message select="$inScopeItems[1]"/>
    <xsl:if test="count($items)=0">
      <xsl:message terminate="yes" select="'Must have a file named tracker.xml that is the download from https://docs.google.com/a/lmckenzie.com/uc?id=0B285oCHDUr09Q2VENW9Ta005QkE'"/>
    </xsl:if>
    <html>
      <head>
        <title>Ballot Responses</title>
        <style type="text/css">tr {vertical-align: text-top;} br {mso-data-placement:same-cell;}</style>
      </head>
      <body>
        <table>
          <tbody>
            <tr>
              <th>Comment Number</th>
              <th>Ballot</th>
              <th>Chapter</th>
              <th>Section</th>
              <th>Page #</th>
              <th>Line #</th>
              <th>Artifact ID</th>
              <th>Resource(s)</th>
              <th>HTML Page name(s)</th>
              <th>URL</th>
              <th>Vote and Type</th>
              <th>Sub-category</th>
              <th>Tracker #</th>
              <th>Pubs</th>
              <th>Existing Wording</th>
              <th>Proposed Wording</th>
              <th>Ballot Comment</th>
              <th>Summary</th>
              <th>In person resolution requested</th>
              <th>Comment grouping</th>
              <th>Schedule</th>
              <th>Triage Note</th>
              <th>Disposition WG</th>
              <th>Disposition</th>
              <th>Disposition Comment or Retract/Withdraw details</th>
              <th>Disposition/Retract/Withdrawal Date</th>
              <th>Mover / seconder</th>
              <th>For</th>
              <th>Against</th>
              <th>Abstain</th>
              <th>Retracted / Withdrawn</th>
              <th>Disposition External Organization</th>
              <th>Responsible Person</th>
              <th>Change Applied</th>
              <th>Substantive Change</th>
              <th>Submitted By</th>
              <th>Organization</th>
              <th>On behalf of</th>
              <th>Commenter Email</th>
              <th>Submitter Tracking ID</th>
              <th>Referred To</th>
              <th>Received From</th>
              <th>Notes</th>
            </tr>
            <xsl:variable name="itemRows" as="element()*">
              <xsl:apply-templates select="$items"/>
            </xsl:variable>
            <xsl:for-each select="$itemRows">
              <xsl:sort select="*:td[1]" data-type="number"/>
              <xsl:copy-of select="."/>
            </xsl:for-each>
          </tbody>
        </table>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="item">
    <xsl:variable name="metadata" as="element()+">
      <xsl:choose>
        <xsl:when test="@submittedName='FHIR Bot' and @number&lt;10000">
          <xsl:for-each select="details">
            <metadata>
              <number>
                <xsl:value-of select="substring-before(substring-after(parent::item/@summary, '#'), ' ')"/>
              </number>
              <summary>
                <xsl:value-of select="normalize-space(substring-after(substring-after(parent::item/@summary, '#'), '-'))"/>
              </summary>
              <xsl:call-template name="processJosh"/>
            </metadata>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="@submittedName='FHIR Bot'">
          <xsl:for-each select="details">
            <metadata>
              <xsl:variable name="number" select="substring-after(substring-after(parent::item/@summary, ' - '), ' #')"/>
              <number>
                <xsl:value-of select="$number"/>
              </number>
              <summary>
                <xsl:value-of select="normalize-space(substring-before(@summary, concat(' #', $number)))"/>
              </summary>
              <xsl:call-template name="processJosh"/>
            </metadata>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="comment[@authorName='FHIR Bot' and p[1][starts-with(., 'Vote: ')]]">
          <!-- May 2015 ballot -->
          <xsl:for-each select="comment[@authorName='FHIR Bot' and p[1][starts-with(., 'Vote: ')]]">
            <metadata>
              <summary>
                <xsl:value-of select="parent::item/@summary"/>
              </summary>
              <xsl:call-template name="processJosh"/>
            </metadata>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="@submittedName='Ewout Kramer' and starts-with(@summary, 'Jan 2015 Ballot Comment')">
          <!-- Jan 2015 ballot -->
          <xsl:variable name="formattedDetails" as="element()+">
            <xsl:apply-templates mode="formatEwout" select="details/p/strong"/>
          </xsl:variable>
          <metadata>
            <number>
              <xsl:value-of select="substring-after(@summary, '#')"/>
            </number>
            <xsl:for-each select="$formattedDetails[@type='Vote and Type']">
              <vote>
                <xsl:value-of select="normalize-space(.)"/>
              </vote>
            </xsl:for-each>
            <xsl:for-each select="$formattedDetails[@type='Submitted By']">
              <submitter>
                <xsl:value-of select="normalize-space(.)"/>
              </submitter>
            </xsl:for-each>
            <xsl:for-each select="$formattedDetails[@type='Organization']">
              <org>
                <xsl:value-of select="normalize-space(.)"/>
              </org>
            </xsl:for-each>
            <xsl:for-each select="$formattedDetails[@type='In person resolution requested']">
              <inperson>
                <xsl:value-of select="substring(normalize-space(.), 1, 1)"/>
              </inperson>
            </xsl:for-each>
            <xsl:for-each select="$formattedDetails[@type='On behalf of']">
              <onbehalf>
                <xsl:value-of select="normalize-space(.)"/>
              </onbehalf>
            </xsl:for-each>
            <xsl:for-each select="$formattedDetails[@type='On Behalf of Email']">
              <email>
                <xsl:value-of select="normalize-space(.)"/>
              </email>
            </xsl:for-each>
            <xsl:for-each select="$formattedDetails[@type='Comments']">
              <comment>
                <xsl:apply-templates mode="fixParagraphs" select="node()"/>
              </comment>
            </xsl:for-each>
            <xsl:for-each select="$formattedDetails[@type='Existing Wording']">
              <existing>
                <xsl:apply-templates mode="fixParagraphs" select="node()"/>
              </existing>
            </xsl:for-each>
            <xsl:for-each select="$formattedDetails[@type='Proposed Wording']">
              <proposed>
                <xsl:apply-templates mode="fixParagraphs" select="node()"/>
              </proposed>
            </xsl:for-each>
            <xsl:for-each select="$formattedDetails[@type='Grahame''s Comments']">
              <additionalComments>
                <xsl:apply-templates mode="fixParagraphs" select="node()"/>
              </additionalComments>
            </xsl:for-each>
            <!-- Should we include these?: Disposition, Disposition Comment -->
          </metadata>
        </xsl:when>
        <xsl:otherwise>
          <metadata>
            <number>
              <xsl:choose>
                <xsl:when test="contains(@summary, '#') and contains(@summary, '-')">
                  <xsl:value-of select="normalize-space(substring-before(substring-after(@summary, '#'), '-'))"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@number"/>
                </xsl:otherwise>
              </xsl:choose>
            </number>
            <submitter>
              <xsl:value-of select="@realSubmitter"/>
            </submitter>
            <summary>
              <xsl:value-of select="@summary"/>
            </summary>
            <xsl:copy-of select="dup"/>
          </metadata>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vote">
      <xsl:choose>
        <xsl:when test="@status='Duplicate'">
          <xsl:for-each select="$allItems[@number=current()/dup]">
            <xsl:call-template name="doVote"/>
            <resolution>
              <xsl:text>See resolution and comments from </xsl:text>
              <a href="http://gforge.hl7.org/gf/project/fhir/tracker/?action=TrackerItemEdit&amp;tracker_item_id={@number}">
                <xsl:value-of select="concat('tracker item ', @number)"/>
              </a>
            </resolution>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="doVote"/>
          <xsl:copy-of select="resolution"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="item" select="."/>
    <xsl:for-each select="$metadata">
      <tr>
        <td>
          <xsl:value-of select="*:number"/>
        </td>
        <td>
          <xsl:value-of select="$item/ballot"/>
        </td>
        <td><!--Chapter--></td>
        <td>
          <xsl:value-of select="$item/@sectionnumber"/>
        </td>
        <td><!--Page #--></td>
        <td><!--Line #--></td>
        <td><!--Artifact ID--></td>
        <td>
          <xsl:for-each select="$item/resources[not(.='None')]">
            <xsl:if test="position()&gt;1">
              <br/>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:for-each>
        </td>
        <td>
          <xsl:for-each select="$item/hTMLPages[not(.='None')]">
            <xsl:if test="position()&gt;1">
              <br/>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:for-each>
        </td>
        <td>
          <xsl:value-of select="$item/@url"/>
        </td>
        <td>
          <xsl:choose>
            <xsl:when test="*:vote">
              <xsl:value-of select="*:vote"/>
            </xsl:when>
            <xsl:when test="$item/@ballot-weight='Negative-Major'">Neg-Mj</xsl:when>
            <xsl:when test="$item/@ballot-weight='Negative-Minor'">Neg-Mi</xsl:when>
            <xsl:when test="$item/@ballot-weight='Affirmative' and @category='Typo'">A-T</xsl:when>
            <xsl:when test="$item/@ballot-weight='Affirmative' and @category='Question'">A-Q</xsl:when>
            <xsl:when test="$item/@ballot-weight='Affirmative' and @category='Comment'">A-C</xsl:when>
            <xsl:when test="$item/@ballot-weight='Affirmative'">A-S</xsl:when>
          </xsl:choose>
        </td>
        <td>
          <xsl:value-of select="$item/@category[.=('Correction', 'Clarification', 'Enhancement')]"/>
        </td>
        <td>
          <xsl:value-of select="$item/@number"/>
        </td>
        <td><!--Pubs--></td>
        <td>
          <xsl:copy-of select="*:existing/node()"/>
        </td>
        <td>
          <xsl:copy-of select="*:proposed/node()"/>
        </td>
        <td>
          <xsl:copy-of select="*:comment/node()"/>
        </td>
        <td>
          <xsl:value-of select="*:summary"/>
        </td>
        <td>
          <xsl:value-of select="if (*:inperson) then *:inperson else $item/@in-Person"/>
        </td>
        <td>
          <xsl:value-of select="$item/@group"/>
        </td>
        <td>
          <xsl:value-of select="$item/@schedule"/>
        </td>
        <td>
          <xsl:for-each select="*:additionalComment">Initial Triage:<br/>
            <xsl:apply-templates mode="fixParagraphs" select="node()"/>
          </xsl:for-each>
          <xsl:for-each select="$item/*:comment[not(@authorName='FHIR Bot')]">
            <xsl:value-of select="concat(@date, ' ', @authorName)"/>
            <br/>
            <xsl:apply-templates mode="fixParagraphs" select="node()"/>
          </xsl:for-each>
        </td>
        <td>
          <xsl:value-of select="string-join($item/reviewingWorkGroup, ', ')"/>
        </td>
        <td>
          <xsl:value-of select="$vote/*:ballotResolution"/>
        </td>
        <td>
          <xsl:apply-templates mode="fixParagraphs" select="$vote/*:resolution/node()"/>
        </td>
        <td>
          <xsl:value-of select="$vote/*:resolutionDate"/>
        </td>
        <td>
          <xsl:value-of select="$vote/*:mover"/>
        </td>
        <td>
          <xsl:value-of select="$vote/*:for"/>
        </td>
        <td>
          <xsl:value-of select="$vote/*:against"/>
        </td>
        <td>
          <xsl:value-of select="$vote/*:abstain"/>
        </td>
        <td>
          <xsl:value-of select="$item/@retractWithdraw"/>
        </td>
        <td><!--Disposition External Organization--></td>
        <td>
          <xsl:value-of select="string-join($item/assignee, ', ')"/>
        </td>
        <td>
          <xsl:choose>
            <xsl:when test="$item/@status='Applied' or $item/@pre-applied='Yes'">Y</xsl:when>
            <xsl:when test="$item/@status='Resolved - Change required'">N</xsl:when>
          </xsl:choose>
        </td>
        <td>
          <xsl:if test="$item/@changeType=('Compatible, substantive', 'Non-compatible')">Y</xsl:if>
        </td>
        <td>
          <xsl:value-of select="*:submitter"/>
        </td>
        <td>
          <xsl:value-of select="*:org"/>
        </td>
        <td>
          <xsl:value-of select="*:onbehalf"/>
        </td>
        <td>
          <xsl:value-of select="*:email"/>
        </td>
        <td>
          <xsl:value-of select="*:id"/>
        </td>
        <td><!--Referred To--></td>
        <td><!--Received From--></td>
        <td><!--Notes--></td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="doVote">
    <xsl:for-each select="@moverSeconderFor-Against-Abstain">
      <mover>
        <xsl:value-of select="normalize-space(substring-before(., ':'))"/>
      </mover>
      <xsl:variable name="vote" select="tokenize(normalize-space(substring-after(., ':')), '-')"/>
      <for>
        <xsl:value-of select="normalize-space($vote[1])"/>
      </for>
      <against>
        <xsl:value-of select="normalize-space($vote[2])"/>
      </against>
      <abstain>
        <xsl:value-of select="normalize-space($vote[3])"/>
      </abstain>
    </xsl:for-each>
    <resolutionDate>
      <xsl:value-of select="@resolutionDate"/>
    </resolutionDate>
    <ballotResolution>
      <xsl:value-of select="@ballotResolution"/>
    </ballotResolution>
  </xsl:template>
  <xsl:template name="processJosh">
    <xsl:for-each select="p[not(preceding-sibling::p[.='---'])]">
      <xsl:choose>
        <xsl:when test="starts-with(., 'Vote:')">
          <number>
            <xsl:value-of select="translate(substring-before(substring-after(., 'Vote:'), '-'), '# ','')"/>
          </number>
          <vote>
            <xsl:value-of select="normalize-space(substring-after(., '-'))"/>
          </vote>
        </xsl:when>
        <xsl:when test="starts-with(., 'Submitted by:')">
          <xsl:variable name="string" select="normalize-space(substring-after(., 'Submitted by:'))"/>
          <xsl:for-each select="if (contains($string, '(')) then normalize-space(substring-before($string, '(')) else $string">
            <submitter>
              <xsl:value-of select="."/>
            </submitter>
          </xsl:for-each>
          <xsl:for-each select="substring-before(substring-after($string, '('), ')')">
            <org>
              <xsl:value-of select="."/>
            </org>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="starts-with(., 'In person:')">
          <inperson>Y</inperson>
        </xsl:when>
        <xsl:when test="starts-with(., 'On behalf of')">
          <xsl:variable name="string" select="normalize-space(substring-after(substring-after(., 'On behalf of'), ' '))"/>
          <xsl:for-each select="if (contains($string, '(')) then normalize-space(substring-before($string, '(')) else $string">
            <onbehalf>
              <xsl:value-of select="."/>
            </onbehalf>
          </xsl:for-each>
          <xsl:for-each select="substring-before(substring-after($string, '('), ')')">
            <email>
              <xsl:value-of select="."/>
            </email>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="starts-with(., 'Existing Wording:')">
          <existing>
            <xsl:value-of select="substring-after(text()[1], 'Existing Wording: ')"/>
            <xsl:apply-templates mode="fixParagraphs" select="text()[1]/following-sibling::node()"/>
            <xsl:apply-templates mode="fixParagraphs" select="following-sibling::p[not(starts-with(., 'Proposed Wording:') or starts-with(., '---') or preceding-sibling::p[starts-with(., 'Proposed Wording:') or starts-with(., '---')])]"/>
          </existing>
        </xsl:when>
        <xsl:when test="starts-with(., 'Proposed Wording:')">
          <proposed>
            <xsl:value-of select="substring-after(text()[1], 'Proposed Wording: ')"/>
            <xsl:apply-templates mode="fixParagraphs" select="text()[1]/following-sibling::node()"/>
            <xsl:apply-templates mode="fixParagraphs" select="following-sibling::p[not(starts-with(., '---') or preceding-sibling::p[starts-with(., '---')])]"/>
          </proposed>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <comment>
      <xsl:if test="self::comment">
        <xsl:apply-templates mode="fixParagraphs" select="parent::item/details/node()"/>
      </xsl:if>
      <xsl:apply-templates mode="fixParagraphs" select="p[.='---']/following-sibling::p[not(.='Comment:')]"/>
    </comment>
  </xsl:template>
  <xsl:template mode="formatEwout" match="strong" as="element()">
    <xsl:variable name="strongCount" select="count(following-sibling::strong)"/>
    <content type="{.}">
      <xsl:copy-of select="following-sibling::node()[count(following-sibling::strong)=$strongCount and not(.=':')]"/>
    </content>
  </xsl:template>
  <xsl:template mode="fixParagraphs" match="*:p">
    <xsl:apply-templates mode="fixParagraphs" select="node()"/>
    <xsl:if test="following-sibling::*[not(normalize-space(.)='')]">
      <br/>
    </xsl:if>
  </xsl:template>
  <xsl:template mode="fixParagraphs" match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates mode="fixParagraphs" select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template mode="fixParagraphs" match="*:br">
    <xsl:if test="preceding-sibling::text()[normalize-space(.)!=''] and following-sibling::text()[normalize-space(.)!='']">
      <br/>
    </xsl:if>
  </xsl:template>
  <xsl:template mode="fixParagraphs" match="text()[normalize-space(.)='']"/>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<!--
  - Takes the tracker XML and identifies situations where tracker items don't pass validation rules
  -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="processAll" select="'N'">
    <!-- If set to 'Y', indicates that rules should be enforced on all tracker items, not just those addressed as part of past releases -->
	</xsl:param>
	<xsl:param name="releaseDate" select="'2015-09-21'">
    <!-- Identifies the date the last release was published.  'Closed' items prior to this date will be excluded from validation unless processAll='Y' -->
	</xsl:param>
	<xsl:key name="item" match="/trackerItems/item" use="@number"/>
	<xsl:variable name="frozenRelease" select="''"/>
	<xsl:variable name="frozenResources" as="xs:string*" select="()"/>
	<xsl:variable name="frozenPages" as="xs:string*" select="()"/>
<!--	<xsl:variable name="frozenRelease" select="'DSTURelease2.1'"/>
	<xsl:variable name="frozenResources" as="xs:string*" select="('AllergyItolerance', 'Bundle', 'ConceptMap', 'Conformance', 'DiagnosticReport', 'DocumentManifest', 
    'DocumentReference', 'ImagingStudy', 'ImageObjectSelection', 'List', 'Medication', 'MedicationStatement', 'NamingSystem', 'Observation', 'OperationDefinition', 
    'OperationOutcome', 'Organization', 'Parameters', 'Patient', 'Procedure', 'RelatedPerson', 'SearchParameter', 'StructureDefinition', 'ValueSet')"/>
	<xsl:variable name="frozenPages" as="xs:string*" select="('compartments', 'datatypes', 'extensibility', 'json', 'narrative', 'xml')"/>-->
<!--	<xsl:variable name="relevantItems" as="element(item)*" select="if ($processAll='Y') then /trackerItems/item else /trackerItems/item[not(@status='Published' or (@status=('Resolved - No change', 'Duplicate') and substring(@close_date,1,10) &lt; $releaseDate))]"/>-->
	<xsl:variable name="relevantItems" as="element(item)*" select="if ($processAll='Y') then /trackerItems/item else /trackerItems/item[not(@status='Published' or (@status=('Resolved - No change', 'Duplicate') and substring(@closed,1,10) &lt; $releaseDate))]"/>
	<xsl:template match="/trackerItems">
    <xsl:variable name="issues" as="element(issue)*">
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@status='Submitted']"/>
        <xsl:with-param name="message" select="'Tracker items not yet triaged'"/>
        <xsl:with-param name="elements" select="('status')"/>
        <xsl:with-param name="assignedTo" select="'Admin'"/>
        <xsl:with-param name="priority" select="1"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@status!='Submitted' and not(reviewingWorkGroup[.!='None'])]"/>
        <xsl:with-param name="message" select="'Not assigned to any work group'"/>
        <xsl:with-param name="elements" select="('status', 'reviewingWorkGroup')"/>
        <xsl:with-param name="assignedTo" select="'Admin'"/>
        <xsl:with-param name="priority" select="1"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[reviewingWorkGroup='IG Project' and @specification='FHIR Core']"/>
        <xsl:with-param name="message" select="'FHIR Core cannot have a reviewing work group of ''IG Project'''"/>
        <xsl:with-param name="elements" select="('reviewingWorkGroup', 'specification')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@status!='Submitted' and not(hTMLPages[.!='None'] or resources[.!='None'])]"/>
        <xsl:with-param name="message" select="'Item isn''t tied to an HTML page or a resource'"/>
        <xsl:with-param name="assignedTo" select="'Admin'"/>
        <xsl:with-param name="elements" select="('status', 'hTMLPages', 'resources')"/>
        <xsl:with-param name="priority" select="1"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@status!='Submitted' and not(@realSubmitter)]"/>
        <xsl:with-param name="message" select="'Real Submitter not specified'"/>
        <xsl:with-param name="elements" select="('status', 'realSubmitter')"/>
        <xsl:with-param name="assignedTo" select="'Admin'"/>
        <xsl:with-param name="priority" select="1"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@status='Triaged' and @category='Typo' and ballot='None']"/>
        <xsl:with-param name="message" select="'Typo should be auto-approved'"/>
        <xsl:with-param name="elements" select="('status', 'category', 'ballot')"/>
        <xsl:with-param name="assignedTo" select="'Admin'"/>
        <xsl:with-param name="priority" select="1"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@status='Triaged' and @category='Correction' and reviewingWorkGroup=('FHIR Core Tooling/Pubs', 'FHIR IG Tooling/Pubs') and ballot='None']"/>
        <xsl:with-param name="message" select="'Tooling/Pubs corrections should be auto-approved'"/>
        <xsl:with-param name="elements" select="('status', 'category', 'reviewingWorkGroup', 'ballot')"/>
        <xsl:with-param name="assignedTo" select="'Admin'"/>
        <xsl:with-param name="priority" select="1"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[count(reviewingWorkGroup)&gt;1]"/>
        <xsl:with-param name="message" select="'Can only have one Responsible Work Group (support for multiples is an artifact of historical behavior).  Work groups interested in a resource or page can add the information to interestedParties.  Individuals (including co-chairs) interested in a particular item can subscribe.'"/>
        <xsl:with-param name="elements" select="('reviewingWorkGroup')"/>
        <xsl:with-param name="priority" select="1"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[count(hTMLPages)&gt;1 and hTMLPages[.='None']]"/>
        <xsl:with-param name="message" select="'HTML Page(s) includes both ''None'' and an actual page'"/>
        <xsl:with-param name="elements" select="('hTMLPages')"/>
        <xsl:with-param name="priority" select="1"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[count(resources)&gt;1 and resources[.='None']]"/>
        <xsl:with-param name="message" select="'Resource(s) includes both ''None'' and an actual resource'"/>
        <xsl:with-param name="elements" select="('resources')"/>
        <xsl:with-param name="priority" select="1"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@retractWithdraw and @status=('Submitted','Triaged','Waiting for Input')]"/>
        <xsl:with-param name="message" select="'Item is retracted or withdrawn but status is not closed'"/>
        <xsl:with-param name="elements" select="('retractWithdraw', 'status')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@pre-applied='Yes' and @status='Resolved - No change']"/>
        <xsl:with-param name="message" select="'Item has change pre-applied but resolution is no change'"/>
        <xsl:with-param name="elements" select="('pre-applied', 'status')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@pre-applied='Yes' and @status='Resolved - Change required']"/>
        <xsl:with-param name="message" select="'Item has change pre-applied but resolution is sitting at ''change required'' - check that applied change is same as agreed change and then change status to Applied, otherwise remove the ''pre-applied'' flag and note any reversal needed in the resolution'"/>
        <xsl:with-param name="elements" select="('pre-applied', 'status')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[not(@changeType) and @status=('Resolved - Change required', 'Applied')]"/>
        <xsl:with-param name="message" select="'Item is marked as requiring change but no change type identified'"/>
        <xsl:with-param name="elements" select="('changeType', 'status')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[ballot[not(.=('None', '2015-Jan Core'))] and not(@retractWithdraw) and not(@moverSeconderFor-Against-Abstain) and not(@status=('Submitted', 'Triaged', 'Waiting for Input', 'Duplicate')) and not(@category='Typo') and not(@category='Correction' and reviewingWorkGroup=('FHIR Core Tooling/Pubs', 'FHIR IG Tooling/Pubs'))]"/>
        <xsl:with-param name="message" select="'Item has a closed status but no vote is recorded'"/>
        <xsl:with-param name="elements" select="('ballot', 'moverSeconderFor-Against-Abstain', 'status', 'retractWithdraw')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" as="element(item)*">
          <xsl:for-each select="$relevantItems[@moverSeconderFor-Against-Abstain]">
            <xsl:variable name="issues" as="xs:string*">
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
            <xsl:if test="count($issues)!=0">
              <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:attribute name="issueDetail" select="string-join($issues, '; ')"/>
                <xsl:copy-of select="node()"/>
              </xsl:copy>
            </xsl:if>
          </xsl:for-each>
        </xsl:with-param>
        <xsl:with-param name="message" select="'Vote is invalid'"/>
        <xsl:with-param name="elements" select="('moverSeconderFor-Against-Abstain')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@moverSeconderFor-Against-Abstain and not(@resolutionDate)]"/>
        <xsl:with-param name="message" select="'A vote is recorded but no resolution date is specified'"/>
        <xsl:with-param name="elements" select="('moverSeconderFor-Against-Abstain', 'resolutionDate')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@retractWithdraw and not(@resolutionDate)]"/>
        <xsl:with-param name="message" select="'Item is retracted or withdrawn but no resolution date is specified'"/>
        <xsl:with-param name="elements" select="('retractWithdraw', 'resolutionDate')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@status=('Resolved - Change required', 'Applied') and not(@targetrelease) and (resources=$frozenResources or hTMLPages=$frozenPages)]"/>
        <xsl:with-param name="message" select="'Item is expecting a change to a frozen artifact but no target release is specified'"/>
        <xsl:with-param name="elements" select="('status', 'targetrelease', 'resources', 'hTMLPages')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
<!-- Todo: check this -->
        <xsl:with-param name="items" select="$relevantItems[@targetrelease=$frozenRelease and @changeType=('Compatible, substantive','Non-compatible') and (resources=$frozenResources or hTMLPages=$frozenPages)]"/>
        <xsl:with-param name="message" select="'Item is making a substantive change to a frozen artifact for a frozen release - FMG approval is required'"/>
        <xsl:with-param name="elements" select="('targetrelease', 'changeType', 'resources', 'hTMLPages')"/>
      </xsl:call-template>
<!-- Todo: check this -->
<!--      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@targetrelease and not(@status=('Resolved - Change required', 'Applied'))]"/>
        <xsl:with-param name="message" select="'A target release has been specified but no change has yet been agreed.  (Indicate desired release for a proposed change via comment).'"/>
        <xsl:with-param name="elements" select="('status', 'targetrelease')"/>
      </xsl:call-template>-->
      <!-- Change is substantive to frozen artifact and targetRelease is frozen release -->
      <!-- Target release is specified and status isn't Resolved - Change required or Applied -->
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@moverSeconderFor-Against-Abstain and not(@ballotResolution)]"/>
        <xsl:with-param name="message" select="'A vote is recorded but no ballot resolution is specified'"/>
        <xsl:with-param name="elements" select="('moverSeconderFor-Against-Abstain', 'ballotResolution')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[not(@status=('Submitted', 'Triaged', 'Waiting for Input', 'Duplicate', 'Deferred')) and not(@ballotResolution or @retractWithdraw[.!='None'])]"/>
<!--        <xsl:with-param name="items" select="$relevantItems[not(@status=('Submitted', 'Triaged', 'Waiting for Input', 'Duplicate')) and not(@ballotResolution or @retractWithdraw[.!='None'])]"/>-->
        <xsl:with-param name="message" select="'Item is closed and not withdrawn, but no ballot resolution recorded'"/>
        <xsl:with-param name="elements" select="('status', 'retractWithdraw', 'ballotResolution')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
<!--        <xsl:with-param name="items" select="$relevantItems[@resolutionDate and not(@ballot-weight='Affirmative') and not(@moverSeconderFor-Against-Abstain or @retractWithdraw) and @category!='Typo' and not(@category='Correction' and reviewingWorkGroup=('FHIR Core Tooling/Pubs', 'FHIR IG Tooling/Pubs'))]"/>-->
        <xsl:with-param name="items" select="$relevantItems[@resolutionDate and ballot!='None' and not(@ballot-weight='Affirmative') and not(@moverSeconderFor-Against-Abstain or @retractWithdraw) and @category!='Typo' and not(@category='Correction' and reviewingWorkGroup=('FHIR Core Tooling/Pubs', 'FHIR IG Tooling/Pubs'))]"/>
        <xsl:with-param name="message" select="'A resolution date is recorded but no vote is specified and the element isn''t marked as retracted or withdrawn and item isn''t an affirmative vote'"/>
        <xsl:with-param name="elements" select="('ballot', 'resolutionDate', 'moverSeconderFor-Against-Abstain', 'retractWithdraw', 'ballot-weight')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@resolutionDate and ballot!='None' and not(@ballotResolution=('Persuasive', 'Not Related', 'Considered - No action required', 'Considered for Future Use', 'Duplicate')) and not(resolution[normalize-space(.)!=''])]"/>
        <xsl:with-param name="message" select="'A resolution date is recorded and resolution isn''t Persuasive, Not Related, Considered - No action required or Considered for Future Use but there is no text in resolution'"/>
        <xsl:with-param name="elements" select="('resolutionDate', 'ballot', 'ballotResolution', 'resolution')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[ballot!='None' and not(@ballotResolution=('Persuasive', 'Considered - No action required')) and not(@status=('Submitted','Triaged','Waiting for Input','Duplicate')) and not(resolution[descendant::text()[normalize-space(.)!='']])]"/>
        <xsl:with-param name="message" select="'Ballot item is closed with ballot resolution other than Persuasive or Considered - No action required and doesn''t have a resolution specified'"/>
        <xsl:with-param name="elements" select="('ballot', 'ballotResolution', 'status', 'resolution')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@status='Waiting for Input' and not(@waitingforInpute-mails)]"/>
        <xsl:with-param name="message" select="'Tracker item is marked as ''Waiting for Input'' but there are no ''Waiting for input email(s)'' specified.  At least one address must be present'"/>
        <xsl:with-param name="elements" select="('status', 'waitingforInpute-mails')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" as="element(item)*">
          <xsl:for-each select="$relevantItems[@waitingforInpute-mails[normalize-space(.)!='']]">
            <xsl:if test="not(matches(@waitingforInpute-mails, '([^(\s@)]+@[^(\s\.)]+\.[^\s]+[,\s]*)+'))">
              <xsl:copy-of select="."/>
            </xsl:if>
          </xsl:for-each>
        </xsl:with-param>
        <xsl:with-param name="message" select="'Waiting for input e-mails contains content other than emails separated by whitespace'"/>
        <xsl:with-param name="elements" select="('status', 'waitingforInpute-mails')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[not(@status='Waiting for Input') and @waitingforInpute-mails]"/>
        <xsl:with-param name="message" select="'Tracker item has ''Waiting for input email(s)'' specified but the status is not marked as ''Waiting for Input''.  Either change the status or remove the emails.'"/>
        <xsl:with-param name="elements" select="('status', 'waitingforInpute-mails')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[starts-with(@ballot-weight, 'Negative') and starts-with(@ballotResolution, 'Considered')]"/>
        <xsl:with-param name="message" select="'Negative ballot submissions cannot have a resolution of ''Considered'''"/>
        <xsl:with-param name="elements" select="('ballot-weight', 'ballotResolution')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[ballot='None' and @ballot-weight]"/>
        <xsl:with-param name="message" select="'Can''t specify a ballot weight if ballot is not specified'"/>
        <xsl:with-param name="elements" select="('ballot', 'ballot-weight')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[not(ballot=('None', '2015-Jan Core')) and not(@ballot-weight)]"/>
        <xsl:with-param name="message" select="'Must specify a ballot weight if ballot is specified'"/>
        <xsl:with-param name="elements" select="('ballot', 'ballot-weight')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@status=('Resolved - Change required', 'Applied', 'Published') and @ballotResolution and not(@ballotResolution=('Persuasive', 'Persuasive with Mod', 'Not Persuasive with Mod'))]"/>
        <xsl:with-param name="message" select="'Status can''t be ''Resolved - Change required'' if resolution isn''t persuasive, persuasive with mod or not persuasive with mod'"/>
        <xsl:with-param name="elements" select="('status', 'ballotResolution')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@status='Deferred' and @ballotResolution and not(@ballotResolution=('Not Persuasive', 'Not Related', 'Considered for Future Use'))]"/>
        <xsl:with-param name="message" select="'Status is deferred, so resolution must be future use, not persuasive or not related'"/>
        <xsl:with-param name="elements" select="('status', 'ballotResolution')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[dup and not(@status='Duplicate')]"/>
        <xsl:with-param name="message" select="'Item has a duplicate listed but doesn''t have a status of Duplicate'"/>
        <xsl:with-param name="elements" select="('duplicate', 'status')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[not(dup) and @status='Duplicate']"/>
        <xsl:with-param name="message" select="'Item doesn''t have a duplicate listed but has a status of Duplicate'"/>
        <xsl:with-param name="elements" select="('duplicate', 'status')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[dup and not(key('item', dup))]"/>
        <xsl:with-param name="message" select="'Referenced duplicate doesn''t exist as a FHIR tracker item'"/>
        <xsl:with-param name="elements" select="('duplicate')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[count(dup)&gt;1]"/>
        <xsl:with-param name="message" select="'Item has multiple duplicates listed - duplicate items must point to a single non-duplicate item'"/>
        <xsl:with-param name="elements" select="('duplicate')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" as="element(item)*">
          <xsl:for-each select="$relevantItems[count(dup)=1]">
            <xsl:if test="key('item', dup)/dup">
              <xsl:copy-of select="."/>
            </xsl:if>
          </xsl:for-each>
        </xsl:with-param>
        <xsl:with-param name="message" select="'Item is a duplicate and duplicate target is also marked as a duplicate.  Target must have a status other than duplicate.'"/>
        <xsl:with-param name="elements" select="('duplicate')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" as="element(item)*">
          <xsl:for-each select="$relevantItems[count(dup)=1 and @in-Person='Yes']">
            <xsl:if test="not(key('item', dup)/@in-Person='Yes')">
              <xsl:copy-of select="."/>
            </xsl:if>
          </xsl:for-each>
        </xsl:with-param>
        <xsl:with-param name="message" select="'Item is marked as in-person but referenced duplicate item is not.  (Surviving duplicates must be marked as in-person if any linked items are - and identify the associated person as a comment).'"/>
        <xsl:with-param name="elements" select="('duplicate', 'in-Person')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" as="element(item)*">
          <xsl:for-each select="$relevantItems[count(dup)=1]">
            <xsl:if test="(@ballot-weight='Negative-Major' and not(key('item', dup)/@ballot-weight='Negative-Major')) or
                          (@ballot-weight='Negative-Minor' and not(starts-with(key('item', dup)/@ballot-weight, 'Negative'))) or
                          (@ballot-weight='Affirmative' and not(key('item', dup)/@ballot-weight))">
              <xsl:copy-of select="."/>
            </xsl:if>
          </xsl:for-each>
        </xsl:with-param>
        <xsl:with-param name="message" select="'This item is a duplicate and the ballot strength of the referenced resource is less than the ballot strength of this item.  (Surviving duplicates should be updated to the strongest ballot strength of all references.)'"/>
        <xsl:with-param name="elements" select="('duplicate', 'ballot-weight')"/>
      </xsl:call-template>
      <xsl:call-template name="showError">
        <xsl:with-param name="items" select="$relevantItems[@status='Resolved - No change' and @ballotResolution and @ballotResolution=('Persuasive', 'Persuasive with Mod', 'Not Persuasive with Mod')]"/>
        <xsl:with-param name="message" select="'Status is no change, but ballot resolution indicates change'"/>
        <xsl:with-param name="elements" select="('status', 'ballotResolution')"/>
      </xsl:call-template>
      <!-- Check:
        Withdrawn/retracted - does description explain circumstances of withdrawal/retraction
        Resolution changed after vote date **can't do right now**
        Ballot-weight changed by someone other than bot
        ballot changed by someone other than bot
        resolutionDate changed
        ballotResolution changed after date specified
        Resolution changed after date specified **can't do right now**
Mover/Seconder/etc changed after date specified
        Real submitter changed
        Submitted by changed
Tracker is a dup without identical wording, check that comment covers differences
-->
    </xsl:variable>
    <issues>
      <xsl:copy-of select="@lastChange"/>
      <xsl:for-each select="distinct-values($issues/@assignedTo)">
        <xsl:variable name="assignee" select="."/>
        <assignee name="{.}">
          <xsl:for-each select="distinct-values($issues[@assignedTo=$assignee]/item/@number)">
            <item>
              <xsl:variable name="item" select="."/>
              <xsl:copy-of select="$issues[@assignedTo=$assignee]/item[@number=$item]/@*"/>
              <xsl:attribute name="priority" select="min($issues[@assignedTo=$assignee and item/@number=$item]/@priority)"/>
              <xsl:for-each select="$issues[@assignedTo=$assignee and item/@number=$item]">
                <issue>
                  <xsl:copy-of select="@message"/>
                </issue>
              </xsl:for-each>
            </item>
          </xsl:for-each>
        </assignee>
      </xsl:for-each>
      <xsl:for-each select="distinct-values($issues[not(@assignedTo)]/item/@email)">
        <xsl:variable name="assignee" select="."/>
        <assignee email="{.}">
          <xsl:for-each select="distinct-values($issues[not(@assignedTo)]/item[@email=$assignee]/@number)">
            <item>
              <xsl:variable name="item" select="."/>
              <xsl:copy-of select="$issues[not(@assignedTo)]/item[@email=$assignee and @number=$item]/@*[not(name(.)='email')]"/>
              <xsl:attribute name="priority" select="min($issues[item[@email=$assignee and @number=$item]]/@priority)"/>
              <xsl:for-each select="$issues[not(@assignedTo) and item[@email=$assignee and @number=$item]]">
                <issue>
                  <xsl:copy-of select="@message"/>
                </issue>
              </xsl:for-each>
            </item>
          </xsl:for-each>
        </assignee>
      </xsl:for-each>
    </issues>
	</xsl:template>
	<xsl:template name="showError">
    <xsl:param name="items" as="element(item)*"/>
    <xsl:param name="message" as="xs:string"/>
    <xsl:param name="assignedTo" as="xs:string?"/>
    <xsl:param name="elements" as="xs:string+"/>
    <xsl:param name="priority" as="xs:integer" select="9"/>
    <xsl:if test="$items">
      <issue message="{$message}" priority="{$priority}">
        <xsl:if test="$assignedTo">
          <xsl:attribute name="assignedTo" select="$assignedTo"/>
        </xsl:if>
        <xsl:for-each select="$items">
          <xsl:copy>
            <xsl:copy-of select="@number|@summary|@issueDetail"/>
            <xsl:choose>
              <xsl:when test="change[element/@name=$elements]">
                <xsl:for-each select="change[element/@name=$elements]">
                  <xsl:sort select="@date" order="descending"/>
                  <xsl:if test="position()=1">
                    <xsl:attribute name="email" select="@authorEmail"/>
                  </xsl:if>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="change">
                  <xsl:sort select="@date" order="descending"/>
                  <xsl:if test="position()=1">
                    <xsl:attribute name="email" select="@authorEmail"/>
                  </xsl:if>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:copy>
        </xsl:for-each>
      </issue>
    </xsl:if>
	</xsl:template>
</xsl:stylesheet>

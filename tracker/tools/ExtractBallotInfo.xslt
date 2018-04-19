<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://hl7.org/fhir/function" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="fn xs">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="userTranslations" as="element(name)+">
    <name old="François MACARY" new="Francois Macary"/>
    <name old="Josh Mandel" new="Joshua Mandel"/>
    <name old="Michelle M Miller" new="Michelle Miller"/>
    <name old="Everyone at the MITRE Corporation" new="Mark Kramer"/>
    <name old="Lisa Lang &amp; Christophe Ludet" new="Lisa Lang"/>
    <name old="Reed Gelzer" new="R Gelzer">
      <!-- Rename back to Reed after migration -->
    </name>
    <name old="Clem McDonald" new="Clement McDonald"/>
    <name old="Jean Duteau" new="Jean-Henri Duteau"/>
    <name old="Amnon Shabo" new="Amnon Shvo"/>
    <name old="Douglas Andrew Harley" new="Douglas Harley"/>
    <name old="Ed Larsen" new="Edward Larsen"/>
    <name old="Kevin Geminiuc" new="kevin geminiuc"/>
    <name old="Pu" new="Pu Qin"/>
    <name old="Andy Stechshin" new="Andy Stechishin"/>
    <name old="Russ Hamm" new="Russell Hamm"/>
    <name old="Nancy Orvis, Wei Guo, Ollie Gray" new="Nancy Orvis"/>
    <name old="Williams, Timothy A" new="Timothy Williams"/>
    <name old="Claude Nanjo, Kensaku Kawamoto" new="Claude Nanjo"/>
    <name old="Rick.Geimer@lantanagroup.com" new="Rick Geimer"/>
    <name old="Nagesh" new="Nagesh Bashyam"/>
    <name old="Andrew Gregorowicz" new="Andy Gregorowicz"/>
    <name old="Rob Hausam" new="Robert Hausam"/>
	</xsl:variable>
	<xsl:variable name="orgTranslations" as="element(name)+">
    <name old="0" new=""/>
    <name old="Academy of Nutrition and Dietetics." new="Academy of Nutrition &amp; Dietetics"/>
    <name old="BCBSA" new="Blue Cross Blue Shield Association"/>
    <name old="CBORD" new="The CBORD Group Inc."/>
    <name old="CDC/NIOSH" new="Centers for Disease Control and Prevention/CDC"/>
    <name old="NIOSH" new="Centers for Disease Control and Prevention/CDC"/>
    <name old="CMS" new="Centers for Medicare &amp; Medicaid Services (CMS)"/>
    <name old="Cerner" new="Cerner Corporation"/>
    <name old="CSTE- on behalf of the RCKMS project" new="Council of State and Teritorial Epidemiologists"/>
    <name old="Datuit" new="Datuit, LLC"/>
    <name old="Department of Defense" new="PEO DHMS - DoD/VA Interagency Program Office"/>
    <name old="DoD/DHA/HIT/IATDD" new="PEO DHMS - DoD/VA Interagency Program Office"/>
    <name old="ESAC" new="Enterprise Science and Computing (ESAC)"/>
    <name old="ESAC, Inc." new="Enterprise Science and Computing (ESAC)"/>
    <name old="ESC" new=""/>
    <name old="Edmond Scientific Company" new=""/>
    <name old="Eversolve (on behalf of SAMHSA)" new="Eversolve, LLC"/>
    <name old="FHIR Core" new="Partners Healthcare"/>
    <name old="Hl7 Australia" new="HL7 Australia"/>
    <name old="HL7 Nutrition Workgroup and on Behalf of Association of Public Health Laboratories (APHL)" new="Association of Public Health Laboratories"/>
    <name old="Hausam Consulting LLC" new=""/>
    <name old="Health eData Inc" new=""/>
    <name old="Health eData Inc." new=""/>
    <name old="ICSA Labs" new=""/>
    <name old="Intelligent Medical Objects" new="Intelligent Medical Objects (IMO)"/>
    <name old="Jenaker Consulting" new=""/>
    <name old="Knapp Consulting Inc." new=""/>
    <name old="Life Over Time Solutions" new=""/>
    <name old="MD Partners, Inc." new=""/>
    <name old="MITRE" new="MITRE Corporation"/>
    <name old="Mathematica Policy Research" new=""/>
    <name old="McKesson" new="McKesson Corporation"/>
    <name old="NEHTA" new="Australian Digital Health Agency"/>
    <name old="NLM" new="National Library of Medicine"/>
    <name old="" new=""/>
    <name old="" new=""/>
    <name old="" new=""/>
  </xsl:variable>
  <xsl:variable name="orgEmails" as="element(orgEmail)+">
    <orgEmail name="Academy of Nutrition &amp; Dietetics" suffix="eatright.org"/>
    <orgEmail name="Accenture" suffix="accenture.com"/>
    <orgEmail name="Allscripts" suffix="allscripts.com"/>
    <orgEmail name="American College of Physicians" suffix="acponline.org"/>
    <orgEmail name="Blue Cross Blue Shield Association" suffix="bcbsa.com"/>
    <orgEmail name="Blue Cross Blue Shield of Louisiana" suffix="bcbsla.com"/>
    <orgEmail name="The CBORD Group Inc." suffix="cbord.com"/>
    <orgEmail name="Centers for Disease Control and Prevention/CDC" suffix="cdc.gov"/>
    <orgEmail name="Center for Medicare &amp; Medicaid Services (CMS)" suffix="cms.hhs.gov"/>
    <orgEmail name="Council of State and Teritorial Epidemiologists" suffix="cste.org"/>
    <orgEmail name="CentriHealth" suffix="centrihealth.com"/>
    <orgEmail name="Cerner Corporation" suffix="cerner.com"/>
    <orgEmail name="Cognitive Medical Systems" suffix="cognitivemedicine.com"/>
    <orgEmail name="Datuit, LLC" suffix="datuit.com"/>
    <orgEmail name="PEO DHMS - DoD/VA Interagency Program Office" suffix="mil.gov"/>
    <orgEmail name="PEO DHMS - DoD/VA Interagency Program Office" suffix="va.gov"/>
    <orgEmail name="Enterprise Science and Computing (ESAC)" suffix="esacinc.com"/>
    <orgEmail name="Edmund Scientific Company" suffix="edmundsci.com">
      <!-- Not current -->
    </orgEmail>
    <orgEmail name="EnableCare, LLC" suffix="enablecare.us"/>
    <orgEmail name="Epic" suffix="epic.com"/>
    <orgEmail name="EverSolve, LLC" suffix="eversolve"/>
    <orgEmail name="Partners Healthcare" suffix="partners.org"/>
    <orgEmail name="Food and Drug Administration" suffix="fda.hhs.gov"/>
    <orgEmail name="GE Healthcare" suffix="ge.com"/>
    <orgEmail name="AEGIS.net, Inc." suffix="aegis.net"/>
    <orgEmail name="AHIS - St. John Providence Health" suffix="ascension.org"/>
    <orgEmail name="Albany Medical Center" suffix="albanymedicalcenter.com"/>
    <orgEmail name="American College of Surgeons, NTDB" suffix="facs.org"/>
    <orgEmail name="American Health Information Management Association" suffix="ahima.org"/>
    <orgEmail name="American Immunization Registry Association (AIRA)" suffix="immregistries.org"/>
    <orgEmail name="American Society of Clinical Oncology" suffix="asco.org"/>
    <orgEmail name="Amtelco" suffix="1call.com"/>
    <orgEmail name="Apprio, Inc." suffix="apprioinc.com"/>
    <orgEmail name="ARUP Laboratories, Inc." suffix="aruplab.com"/>
    <orgEmail name="Australian Digital Health Agency" suffix="digitalhealth.gov.au"/>
    <orgEmail name="Australian Digital Health Agency" suffix="nehta.gov.au"/>
    <orgEmail name="Availity, LLC" suffix="availity.com"/>
    <orgEmail name="Botswana Institute for Technology Research and Inn" suffix="bitri.co.bw"/>
    <orgEmail name="CAL2CAL Corporation" suffix="cal2cal.com"/>
    <orgEmail name="California Department of Health Care Services" suffix="dhcs.ca.gov"/>
    <orgEmail name="Cedars-Sinai Medical Center" suffix="cshs.org"/>
    <orgEmail name="Clinicomp, Intl" suffix="clinicomp.com"/>
    <orgEmail name="College of American Pathologists" suffix="cap.org"/>
    <orgEmail name="College of Healthcare Information Mgmt. Executives" suffix="chimecentral.org"/>
    <orgEmail name="Computrition, Inc." suffix="computrition.com"/>
    <orgEmail name="Corepoint Health" suffix="corepointhealth.com"/>
    <orgEmail name="Duke Clinical &amp; Translational Science Institute" suffix="dm.duke.edu"/>
    <orgEmail name="eHealth Initiative" suffix="ehidc.org"/>
    <orgEmail name="Health Care Software, Inc." suffix="hcssupport.com"/>
    <orgEmail name="Healthland" suffix="healthland.com"/>
    <orgEmail name="Hendricks Regional Health" suffix="hendricks.org"/>
    <orgEmail name="HL7 Argentina" suffix=".ar"/>
    <orgEmail name="HL7 Australia" suffix=".au"/>
    <orgEmail name="HL7 Austria" suffix=".at"/>
    <orgEmail name="HL7 Bosnia and Herzegovina" suffix=".ba"/>
    <orgEmail name="HL7 Canada" suffix=".ca"/>
    <orgEmail name="HL7 China" suffix=".cn"/>
    <orgEmail name="HL7 Croatia" suffix=".hr"/>
    <orgEmail name="HL7 Czech Republic" suffix=".cz"/>
    <orgEmail name="HL7 Denmark" suffix=".dk"/>
    <orgEmail name="HL7 Finland" suffix=".fi"/>
    <orgEmail name="HL7 France" suffix=".fr"/>
    <orgEmail name="HL7 Germany" suffix=".de"/>
    <orgEmail name="HL7 Greece" suffix=".gr"/>
    <orgEmail name="HL7 Hong Kong" suffix=".hk"/>
    <orgEmail name="HL7 India" suffix=".in"/>
    <orgEmail name="HL7 Italy" suffix=".it"/>
    <orgEmail name="HL7 Japan" suffix=".jp"/>
    <orgEmail name="HL7 Korea" suffix=".kp"/>
    <orgEmail name="HL7 Netherlands" suffix=".nl"/>
    <orgEmail name="HL7 New Zealand" suffix=".nz"/>
    <orgEmail name="HL7 Norway" suffix=".no"/>
    <orgEmail name="HL7 Philippines" suffix=".ph"/>
    <orgEmail name="HL7 Poland" suffix=".pl"/>
    <orgEmail name="HL7 Romania" suffix=".ro"/>
    <orgEmail name="HL7 Russia" suffix=".ru"/>
    <orgEmail name="HL7 Singapore" suffix=".sg"/>
    <orgEmail name="HL7 Slovenia" suffix=".si"/>
    <orgEmail name="HL7 Spain" suffix=".es"/>
    <orgEmail name="HL7 Sweden" suffix=".se"/>
    <orgEmail name="HL7 Switzerland" suffix=".ch"/>
    <orgEmail name="HL7 Taiwan" suffix=".tw"/>
    <orgEmail name="HL7 UAE" suffix=".ae"/>
    <orgEmail name="HL7 UK" suffix=".gb"/>
    <orgEmail name="HL7 Uruguay" suffix=".uy"/>
    <orgEmail name="Association of Public Health Laboratories" suffix="aphl.org"/>
    <orgEmail name="Health Intersections Pty Ltd" suffix="healthintersections.com.au"/>
    <orgEmail name="Intelligent Medical Objects (IMO)" suffix="imo-online.com"/>
    <orgEmail name="Intermountain Healthcare" suffix="ihc.com"/>
    <orgEmail name="Kaiser Permanente" suffix="kp.org"/>
    <orgEmail name="HLN Consulting, LLC" suffix="hln.com"/>
    <orgEmail name="ICCBBA, Inc." suffix="iccbba.org"/>
    <orgEmail name="Info World" suffix="infoworld.ro"/>
    <orgEmail name="iNTERFACEWARE, Inc." suffix="interfaceware.com"/>
    <orgEmail name="InterSystems" suffix="intersystems.com"/>
    <orgEmail name="Johns Hopkins Aramco Healthcare" suffix="jhah.com"/>
    <orgEmail name="Johns Hopkins Hospital" suffix="jhmi.edu"/>
    <orgEmail name="Laboratory Corporation of America" suffix="labcorp.com"/>
    <orgEmail name="Lantana Consulting Group" suffix="lantanagroup.com"/>
    <orgEmail name="Leidos, Inc." suffix="leidos.com"/>
    <orgEmail name="MITRE Corporation" suffix="mitre.org"/>
    <orgEmail name="LINK Medical Computing, Inc." suffix="linkmed.com"/>
    <orgEmail name="Loyola University Health System" suffix="lumc.edu"/>
    <orgEmail name="Mayo Clinic" suffix="mayo.edu"/>
    <orgEmail name="McKesson Corporation" suffix="mckesson.com"/>
    <orgEmail name="Medicity" suffix="medicity.com"/>
    <orgEmail name="National Library of Medicine" suffix="nlm.nih.gov"/>
    <orgEmail name="Medtronic" suffix="medtronic.com"/>
    <orgEmail name="Mercer University" suffix="mercer.edu"/>
    <orgEmail name="Milton S. Hershey Medical Center" suffix="psu.edu"/>
    <orgEmail name="National Association of Dental Plans" suffix="nadp.org"/>
    <orgEmail name="National Institute of Standards and Technology" suffix="nist.gov"/>
    <orgEmail name="National Marrow Donor Program" suffix="nmdp.org"/>
    <orgEmail name="" suffix=""/>
    <orgEmail name="" suffix=""/>
    <orgEmail name="" suffix=""/>
    <orgEmail name="" suffix=""/>
    <orgEmail name="" suffix=""/>
    <orgEmail name="" suffix=""/>
    <orgEmail name="" suffix=""/>
    <orgEmail name="NICTIZ Nat.ICT.Inst.Healthc.Netherlands" suffix="nictiz.nl"/>
    <orgEmail name="NJDOH" suffix="doh.nj.gov"/>
    <orgEmail name="North Carolina Baptist Hospitals, Inc." suffix="wfubmc.edu"/>
    <orgEmail name="Optum" suffix="optum.com"/>
    <orgEmail name="Orchard Software" suffix="orchardsoft.com"/>
    <orgEmail name="Partners HealthCare System, Inc." suffix="partners.org"/>
    <orgEmail name="PEO DHMS - DoD/VA Interagency Program Office" suffix="mail.mil"/>
    <orgEmail name="Practice Fusion" suffix="practicefusion.com"/>
    <orgEmail name="Professional Laboratory Management, Inc." suffix="plmweb.org"/>
    <orgEmail name="SLI Compliance" suffix="slicompliance.com"/>
    <orgEmail name="Social Security Administration" suffix="ssa.gov"/>
    <orgEmail name="Spectrum Health" suffix="spectrumhealth.org"/>
    <orgEmail name="Sunquest Information Systems" suffix="sunquestinfo.com"/>
    <orgEmail name="Surescripts" suffix="surescripts.com"/>
    <orgEmail name="Tennessee Department of Health" suffix="tn.gov"/>
    <orgEmail name="The SSI Group, Inc." suffix="ssigroup.com"/>
    <orgEmail name="Transcend Insights" suffix="transcendinsights.com"/>
    <orgEmail name="UK HealthCare" suffix="uky.edu"/>
    <orgEmail name="Washington State Department of Health" suffix="doh.wa.gov"/>
    <orgEmail name="Wellsoft Corporation" suffix="wellsoft.com"/>
    
    
  </xsl:variable>
	<xsl:variable name="newUsers" as="element(user)">
    <user name="Kanwarpreet Sethi" email="kp.sethi@lantanagroup.com"/>
    <user name="Greg Staudenmaier" email="greg.staudenmaier@va.gov"/>
    <user name="Chris Hills" email="christopher.j.hills.civ@mail.mil"/>
    <user name="Genny Luensman" email="gluensman@cdc.gov"/>
    <user name="Lorraine Doo" email="lorraine.doo@cms.hhs.gov"/>
    <user name="Nancy Orvis" email="nancy.j.orvis.civ@mail.mil"/>
    <user name="Marilyn Parenzan" email="mparenzan@jointcommission.org"/>
    <user name="Perry Mar" email="pmar@partners.org"/>
    <user name="Angela Flanagan" email="angela.flanagan@lantanagroup.com"/>
    <user name="Michelle Dardis" email="MDardis@jointcommission.org"/>
    <user name="Daniella Meeker" email="dmeeker@usc.edu"/>
    <user name="Hugh Gordon" email="hugh@akidolabs.com"/>
    <user name="Bill Clarke" email="bclarke@lincolnpeak.com"/>
    <user name="Rohan Pachhapurkar" email="rohan_pachhapurkar@persistent.com"/>
    <user name="Patty Craig" email="pcraig@jointcommission.org"/>
    <user name="Jamalynne Deckard" email="jkdeckar@regenstrief.org"/>
    <user name="Mags Tamilarasu" email=""/>
    <user name="Russell Davis" email="Russell.J.Davis.Civ@Mail.Mil"/>
    <user name="Lisa Anderson" email="LAnderson2@jointcommission.org"/>
    <user name="Nilesh Sawal" email="nilesh.sawal@ge.com"/>
    <user name="Divya Ahuja" email="divya.ahuja1@ge.com"/>
    <user name="Nayan Mergu" email="nayan.mergu@ge.com"/>
    <user name="Rohan Chavan" email="rohan.chavan@ge.com"/>
    <user name="Sunny Goyal" email="sunny.goyal@ge.com"/>
    <user name="Rashmi MS" email="Rashmi.MS@ge.com"/>
    <user name="Abhijeet Badale" email="abhijeet.badale@ge.com"/>
    <user name="Dileep Ravindranath" email="dileep.ravindranath@ge.com"/>
    <user name="Abrar Salam" email="asalam@jointcommission.org"/>
    <user name="Manisha Khatta" email="khatta_manisha@bah.com"/>
    <user name="Kimberly Glenn" email="kimberly.glenn@lantanagroup.com"/>
    <user name="Ali Nakoulima" email="ali.nakoulima@cerner.com"/>
    <user name="Terrie Reed" email="Terrie.Reed@fda.hhs.gov"/>
    <user name="Ana Kostadinovska" email="ana.kostadinovska@philips.com"/>
    <user name="Aziz Boxwala" email="aziz.boxwala@meliorix.com"/>
    <user name="Al Amyot" email="alamyot@sierrasystems.com"/>
    <user name="Zabrina Gonzaga" email="zabrina.gonzaga@lantanagroup.com"/>
    <user name="Rute Martins" email="amartinsbaptista@jointcommission.org"/>
    <user name="Carl Burnett" email="cburnett@healthwise.org"/>
    <user name="Timothy Williams" email="timowilliams@DELOITTE.com"/>
	</xsl:variable>
	<xsl:key name="user" match="/trackerItems/user" use="@name"/>
	<xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
	</xsl:template>
	<xsl:template match="trackerItems">
    <xsl:copy>
      <xsl:for-each select="user">
        <xsl:sort select="@name"/>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
      <xsl:for-each select="item">
        <xsl:sort select="@number"/>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:copy>
	</xsl:template>
	<xsl:template match="item">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:if test="@submittedName='Ewout Kramer' and starts-with(@summary, 'Jan 2015 Ballot Comment')">
        <xsl:attribute name="submittedName" select="'FHIR Bot'"/>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
      <xsl:choose>
        <xsl:when test="@submittedName='FHIR Bot' and @number&lt;10000">
          <xsl:for-each select="details">
            <ballotInfo>
              <xsl:call-template name="ballotForDate">
                <xsl:with-param name="date" select="parent::item/@opened"/>
                <xsl:with-param name="item" select="parent::item"/>
              </xsl:call-template>
              <xsl:attribute name="number" select="substring-before(substring-after(parent::item/@summary, '#'), ' ')"/>
              <xsl:call-template name="processJosh"/>
            </ballotInfo>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="@submittedName='FHIR Bot'">
          <xsl:for-each select="details">
            <ballotInfo>
              <xsl:call-template name="ballotForDate">
                <xsl:with-param name="date" select="parent::item/@opened"/>
                <xsl:with-param name="item" select="parent::item"/>
              </xsl:call-template>
              <xsl:variable name="number" select="substring-after(substring-after(parent::item/@summary, ' - '), ' #')"/>
              <xsl:attribute name="number" select="$number"/>
              <xsl:call-template name="processJosh"/>
            </ballotInfo>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="comment[@authorName='FHIR Bot' and p[1][starts-with(., 'Vote: ')]]">
          <!-- May 2015 ballot -->
          <xsl:for-each select="comment[@authorName='FHIR Bot' and p[1][starts-with(., 'Vote: ')]]">
            <ballotInfo>
              <xsl:call-template name="ballotForDate">
                <xsl:with-param name="date" select="@date"/>
                <xsl:with-param name="item" select="parent::item"/>
              </xsl:call-template>
              <xsl:call-template name="processJosh"/>
            </ballotInfo>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="@submittedName='Ewout Kramer' and starts-with(@summary, 'Jan 2015 Ballot Comment')">
          <!-- Jan 2015 ballot -->
          <xsl:variable name="formattedDetails" as="element()+">
            <xsl:apply-templates mode="formatEwout" select="details/p/strong"/>
          </xsl:variable>
          <ballotInfo>
            <xsl:attribute name="ballot" select="'2015-Jan Core'"/>
            <xsl:attribute name="number" select="normalize-space(substring-after(@summary, '#'))"/>
            <xsl:for-each select="$formattedDetails[@type='Vote and Type']">
              <xsl:attribute name="vote" select="normalize-space(.)"/>
            </xsl:for-each>
            <xsl:if test="$formattedDetails[@type='Submitted By']">
              <xsl:variable name="name" select="normalize-space($formattedDetails[@type='Submitted By'])"/>
              <xsl:attribute name="submitter" select="$name"/>
              <xsl:call-template name="userId">
                <xsl:with-param name="name" select="$name"/>
                <xsl:with-param name="prefix" select="'submitter'"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:for-each select="$formattedDetails[@type='Organization']">
              <xsl:variable name="org">
                <xsl:call-template name="translateOrg">
                  <xsl:with-param name="name" select="normalize-space(.)"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:if test="$org!=''">
                <xsl:attribute name="organization" select="$org"/>
              </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$formattedDetails[@type='In person resolution requested']">
              <xsl:attribute name="inPerson" select="substring(normalize-space(.), 1, 1)"/>
            </xsl:for-each>
            <xsl:if test="$formattedDetails[@type='On behalf of']">
              <xsl:variable name="name" select="normalize-space($formattedDetails[@type='On behalf of'])"/>
              <xsl:attribute name="onBehalf" select="$name"/>
              <xsl:call-template name="userId">
                <xsl:with-param name="name" select="$name"/>
                <xsl:with-param name="prefix" select="'onBehalf'"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:for-each select="$formattedDetails[@type='On Behalf of Email']">
              <xsl:attribute name="email" select="normalize-space(.)"/>
            </xsl:for-each>
          </ballotInfo>
        </xsl:when>
        <xsl:when test="ballot[not(.='None')]">
          <ballotInfo>
            <xsl:call-template name="ballotForDate">
              <xsl:with-param name="date" select="@opened"/>
              <xsl:with-param name="item" select="self::item"/>
            </xsl:call-template>
            <xsl:variable name="number">
              <xsl:choose>
                <xsl:when test="contains(@summary, '#') and contains(@summary, '-')">
                  <xsl:value-of select="normalize-space(substring-before(substring-after(@summary, '#'), '-'))"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@number"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="number" select="$number"/>
            <xsl:attribute name="submitter" select="@realSubmitter"/>
            <xsl:call-template name="userId">
              <xsl:with-param name="name" select="@realSubmitter"/>
              <xsl:with-param name="prefix" select="'submitter'"/>
            </xsl:call-template>
            <xsl:attribute name="vote" select="@ballot-weight"/>
            <xsl:if test="@in-Person='Yes'">
              <xsl:attribute name="inPerson" select="'Y'"/>
            </xsl:if>
          </ballotInfo>
        </xsl:when>
      </xsl:choose>
    </xsl:copy>
	</xsl:template>
	<xsl:template match="comment[@authorName='FHIR Bot'][p]">
    <xsl:variable name="paragraphs" as="element(p)*">
      <xsl:for-each select="p[not(starts-with(., 'Submitted by:') or starts-with(., 'On behalf of') or starts-with(., 'Vote:') or starts-with(.,'In person:') or starts-with(.,'---') or starts-with(., 'Comment:') or normalize-space(.)='')]">
        <xsl:copy>
          <xsl:choose>
            <xsl:when test="starts-with(., 'Triaged: ')">
              <xsl:value-of select="substring-after(., 'Triaged: ')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="node()"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:copy>
      </xsl:for-each>
    </xsl:variable>
    <xsl:if test="count($paragraphs)>1">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:copy-of select="$paragraphs"/>
    </xsl:copy>
    </xsl:if>
	</xsl:template>
  <xsl:template name="processJosh">
    <xsl:for-each select="p[not(preceding-sibling::p[.='---'])]">
      <xsl:choose>
        <xsl:when test="starts-with(., 'Vote:')">
          <xsl:attribute name="number" select="translate(substring-before(substring-after(translate(., '&#xA0;', ' '), 'Vote:'), '-'), '# ','')"/>
          <xsl:attribute name="vote" select="normalize-space(substring-after(translate(., '&#xA0;', ' '), '-'))"/>
        </xsl:when>
        <xsl:when test="starts-with(., 'Submitted by:')">
          <xsl:variable name="string" select="normalize-space(substring-after(translate(., '&#xA0;', ' '), 'Submitted by:'))"/>
          <xsl:variable name="name" select="if (contains($string, '(')) then normalize-space(substring-before($string, '(')) else $string"/>
          <xsl:if test="$name!=''">
            <xsl:attribute name="submitter" select="$name"/>
            <xsl:call-template name="userId">
              <xsl:with-param name="name" select="$name"/>
              <xsl:with-param name="prefix" select="'submitter'"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:variable name="org">
            <xsl:variable name="baseName" select="substring-after($string, '(')"/>
            <xsl:call-template name="translateOrg">
              <xsl:with-param name="name" select="substring($baseName, 1, string-length($baseName) - 1)"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$org!=''">
            <xsl:attribute name="organization" select="$org"/>
          </xsl:if>
        </xsl:when>
        <xsl:when test="starts-with(., 'In person:')">
          <xsl:attribute name="inPerson" select="'Y'"/>
        </xsl:when>
        <xsl:when test="starts-with(., 'On behalf of')">
          <xsl:variable name="string" select="normalize-space(substring-after(substring-after(translate(., '&#xA0;', ' '), 'On behalf of'), ' '))"/>
          <xsl:variable name="name" select="if (contains($string, '(')) then normalize-space(substring-before($string, '(')) else $string"/>
          <xsl:if test="$name!=''">
            <xsl:attribute name="onBehalf" select="$name"/>
            <xsl:call-template name="userId">
              <xsl:with-param name="name" select="$name"/>
              <xsl:with-param name="prefix" select="'onBehalf'"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:variable name="email" select="lower-case(normalize-space(substring-before(substring-after($string, '('), ')')))"/>
          <xsl:if test="$email!=''">
            <xsl:attribute name="email" select="$email"/>
          </xsl:if>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template mode="formatEwout" match="strong" as="element()">
    <xsl:variable name="strongCount" select="count(following-sibling::strong)"/>
    <content type="{.}">
      <xsl:copy-of select="following-sibling::node()[count(following-sibling::strong)=$strongCount and not(.=':')]"/>
    </content>
  </xsl:template>
	<xsl:template mode="formatEwout" priority="5" match="text()">
    <xsl:value-of select="translate(., '&#xA0;', ' ')"/>
	</xsl:template>
	<xsl:template mode="formatEwout" match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates mode="formatEwout" select="@*|node()"/>
    </xsl:copy>
	</xsl:template>
  <xsl:template name="ballotForDate">
    <xsl:param name="date" as="xs:string"/>
    <xsl:param name="item" as="element(item)"/>
    <xsl:variable name="year" select="substring($date,1,4)"/>
    <xsl:variable name="month" select="substring($date,6,2)"/>
    <xsl:variable name="monthAbbrev" select="if ($month=('01', '02')) then 'Jan' else if ($month=('05','06')) then 'May' else if ($month='09') then 'Sept' else '??'"/>
    <xsl:variable name="ballotPrefix" select="concat($year, '-', $monthAbbrev)"/>
    <xsl:choose>
      <xsl:when test="count($item/ballot[starts-with(., $ballotPrefix)])!=1">
        <xsl:message select="concat($item/@number, ' ', $item/@submittedName, ' Incorrect ballot match for prefix ', $ballotPrefix, ' ', $item/@specification)"/>
        <xsl:message select="$item/ballot"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="ballot" select="$item/ballot[starts-with(., $ballotPrefix)]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
	<xsl:template name="userId">
    <xsl:param name="name"/>
    <xsl:param name="prefix"/>
    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when test="$userTranslations[@old=$name]">
          <xsl:variable name="translatedId" as="attribute()">
            <xsl:call-template name="userId">
              <xsl:with-param name="name" select="$userTranslations[@old=$name]/@new"/>
              <xsl:with-param name="prefix" select="$prefix"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="$translatedId"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="id" select="key('user', $name)/@id"/>
          <xsl:choose>
            <xsl:when test="$id=''">
              <xsl:variable name="user" as="element(user)?" select="$newUsers[@name=$name]"/>
              <xsl:choose>
                <xsl:when test="$user=''">
                  <xsl:message select="concat(ancestor-or-self::item/@number, ' Unable to find match for user: ', $name)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="translate(lower-case($name), ' &#xA0;', '__')"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$id"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:attribute name="{$prefix}-id" select="$id"/>
	</xsl:template>
	<xsl:template name="translateOrg" as="xs:string?">
    <xsl:param name="name" as="xs:string"/>
    <xsl:variable name="translatedName" select="if($orgTranslations[@old=$name]) then $orgTranslations[@old=$name]/@new else $name"/>
    <xsl:if test="not($orgEmails[@name=$translatedName])">
      <xsl:message select="concat(ancestor-or-self::item/@number, ' Unable to find organization with name: ', $translatedName)"/>
    </xsl:if>
    <xsl:value-of select="$translatedName"/>
	</xsl:template>
</xsl:stylesheet>
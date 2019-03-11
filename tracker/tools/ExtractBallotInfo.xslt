<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:key name="user" match="/trackerItems/user" use="@name"/>
  <xsl:variable name="userReplacements" as="element(name)+">
    <name old="??? ?" first="Wanghai" last="Sheng"/>
    <name old="Andy Gregorowicz" first="Andrew" last="Gregorowicz"/>
    <name old="Amnon Shvo" first="Amnon" last="Shabo"/>
    <name old="Anthony (Tony) Julian" first="Anthony" last="Julian"/>
    <name old="Brian  Pech" first="Brian" last="Pech"/>
    <name old="Jim Kretz" first="James" last="Kretz"/>
    <name old="Paul Knapp!" first="Paul" last="Knapp"/>
    <name old="R Gelzer" first="Reed" last="Gelzer"/>
    <name old="Raj Muthukkannan" first="Rajarajan" last="Muthukkannan"/>
    <name old="Tim MCNeil" first="Tim" last="McNeil"/>
    <name old="Tmi Tisdall" first="Tim" last="Tisdall"/>
  </xsl:variable>
  <xsl:variable name="userTranslations" as="element(name)+">
    <name old="Andy Gregorowitz" new="Andrew Gregorowitz"/>
    <name old="Amnon Shabo" new="Amnon Shvo"/>
    <name old="Andrew Gregorowicz" new="Andy Gregorowicz"/>
    <name old="Andy Stechshin" new="Andy Stechishin"/>
    <name old="Andy Stetchshin" new="Andy Stechishin"/>
    <name old="BCBSA" new="Lenel James"/>
    <name old="Chis Courvile" new="Chris Courville"/>
    <name old="Chris Brancato" new="Chris Bracanto"/>
    <name old="Claude Nanjo, Kensaku Kawamoto" new="Claude Nanjo"/>
    <name old="Clem McDonald" new="Clement McDonald"/>
    <name old="Clement J. McDonald" new="Clement McDonald"/>
    <name old="Douglas Andrew Harley" new="Douglas Harley"/>
    <name old="Ed Larsen" new="Edward Larsen"/>
    <name old="Everyone at the MITRE Corporation" new="Jason Walonoski"/>
    <name old="François MACARY" new="Francois Macary"/>
    <name old="FranÃ§ois Macary" new="Francois Macary"/>
    <name old="Grahame G2" new="Grahame Grieve"/>
    <name old="Jean Duteau" new="Jean-Henri Duteau"/>
    <name old="James Kretz" new="Jim Kretz"/>
    <name old="Jeff Danford" new="Jeffrey Danford"/>
    <name old="Jose Costa Tiexiera" new="Jose Costa Teixeira"/>
    <name old="Josh Mandel" new="Joshua Mandel"/>
    <name old="Keith W. Boone" new="Keith Boone"/>
    <name old="Kevin Geminiuc" new="kevin geminiuc"/>
    <name old="KEVIN POWER" new="Kevin Power"/>
    <name old="Kensaku Kawamoto, MD, PhD, MHS" new="Kensaku Kawamoto"/>
    <name old="Lantana Consulting Group" new="Rick Geimer"/>
    <name old="Lisa Lang &amp; Christophe Ludet" new="Lisa Lang"/>
    <name old="Michelle M Miller" new="Michelle Miller"/>
    <name old="Mollie Ullman-Coliere" new="Mollie Ullman-Cullere"/>
    <name old="Mr. Chris Hills" new="Chris Hills"/>
    <name old="Nagesh" new="Nagesh Bashyam"/>
    <name old="Nancy Orvis, Wei Guo, Ollie Gray" new="Nancy Orvis"/>
    <name old="Ollie B. Gray" new="Ollie Gray"/>
    <name old="Pu" new="Pu Qin"/>
    <name old="Rajarajan Muthukkannan" new="Raj Muthukkannan"/>
    <name old="Reed Gelzer" new="R Gelzer"/>
    <name old="Reed D. Gelzer, MD, MPH" new="R Gelzer"/>
    <name old="Rick.Geimer@lantanagroup.com" new="Rick Geimer"/>
    <name old="Rob Hausam" new="Robert Hausam"/>
    <name old="Rob McClure" new="Robert McClure"/>
    <name old="Russ Hamm" new="Russell Hamm"/>
    <name old="Thomson Khun" new="Thomson Kuhn"/>
    <name old="Surescripts" new="Tim MCNeil"/>
    <name old="Tim McNeil" new="Tim MCNeil"/>
    <name old="Vassil Peytchev, Epic" new="Vassil Peytchev"/>
    <name old="Vince McCauley" new="Vincent McCauley"/>
    <name old="Williams, Timothy A" new="Timothy Williams"/>
    <name old="William Goosen" new="William Goossen"/>
  </xsl:variable>
  <xsl:variable name="newUsersInfo" as="element(user)+">
    <user first="Abhijeet" last="Badale" email="abhijeet.badale@ge.com"/>
    <user first="Abrar" last="Salam" email="asalam@jointcommission.org"/>
    <user first="Al" last="Amyot" email="alamyot@sierrasystems.com"/>
    <user first="Alan" last="Abilla" email="alan.abilla@kp.org"/>
    <user first="Ali" last="Nakoulima" email="ali.nakoulima@cerner.com"/>
    <user first="Ana" last="Kostadinovska" email="ana.kostadinovska@philips.com"/>
    <user first="Angela" last="Flanagan" email="angela.flanagan@lantanagroup.com"/>
    <user first="Angela" last="Brown" email="brown_angela@bah.com"/>
    <user first="Aziz" last="Boxwala" email="aziz.boxwala@meliorix.com"/>
    <user first="Ben" last="Atkinson" email="batkinso@u.washington.edu"/>
    <user first="Bill" last="Clarke" email="bclarke@lincolnpeak.com"/>
    <user first="Bonnie" last="Briggs" email="bonnie.briggs@wolterskluwer.com"/>
    <user first="Carl" last="Burnett" email="cburnett@healthwise.org"/>
    <user first="Casey" last="Thompson" email="casey.thompson@lantanagroup.com"/>
    <user first="Catherine" last="Staes" email="catherine.staes@hsc.utah.edu"/>
    <user first="Chris" last="Hills" email="christopher.j.hills.civ@mail.mil"/>
    <user first="Colleen" last="Skau" email="skau@augs.org"/>
    <user first="Constantina" last="Papoutsakis" email="cpapoutsakis@eatright.org"/>
    <user first="Daniella" last="Meeker" email="dmeeker@usc.edu"/>
    <user first="David" last="Roeder" email="DavidRoeder@ge.com"/>
    <user first="David" last="Parker" email="David.Parker@defined-it.com"/>
    <user first="Dileep" last="Ravindranath" email="dileep.ravindranath@ge.com"/>
    <user first="Divya" last="Ahuja" email="divya.ahuja1@ge.com"/>
    <user first="Elizabeth" last="Hartley" email="Elizabeth.Hartley@bcbsla.com"/>
    <user first="Erin" last="Holt" email="Erin.Holt@tn.gov"/>
    <user first="Evelyn" last="Gallego" email="evelyn.gallego@emiadvisors.net"/>
    <user first="Farrah" last="Kahn" email="farrah.khan@bcbsa.com"/>
    <user first="Genny" last="Luensman" email="gluensman@cdc.gov"/>
    <user first="Greg" last="Staudenmaier" email="greg.staudenmaier@va.gov"/>
    <user first="Gunter" last="Haroske" email="haroske@icloud.com"/>
    <user first="Harri" last="Honko" email="hari.honko@w2e.fi"/>
    <user first="Hugh" last="Gordon" email="hugh@akidolabs.com"/>
    <user first="Jamalynne" last="Deckard" email="jkdeckar@regenstrief.org"/>
    <user first="Jamie" last="Parker" email="jamie.parker@esacinc.com"/>
    <user first="Jaqui" last="Parker" email="Parker_Jaqui@bah.com"/>
    <user first="Jeremy" last="Kasmann" email="jeremy.kasmann@wolterskluwer.com"/>
    <user first="Jocylen" last="Keegan" email="jocelyn.keegan@pocp.com"/>
    <user first="John" last="Loonsk" email="lbk1@cdc.gov"/>
    <user first="Julia" last="Skapik" email="Julia.skapik@hhs.gov"/>
    <user first="Juliet" last="Rubini" email="julietkrubini@gmail.com"/>
    <user first="Kanwarpreet" last="Sethi" email="kp.sethi@lantanagroup.com"/>
    <user first="Kathy" last="Walsh" email="walshk@labcorp.com"/>
    <user first="Keith" last="Salzman" email="keith.salzman@gmail.com"/>
    <user first="Kenneth" last="Salyards" email="kenneth.salyards@samhsa.hhs.gov"/>
    <user first="Kimberly" last="Glenn" email="kimberly.glenn@lantanagroup.com"/>
    <user first="Leslie" last="Tompkins" email="Leslie.Tompkins@fda.hhs.gov"/>
    <user first="Lisa" last="Anderson" email="landerson2@jointcommission.org"/>
    <user first="Lorraine" last="Doo" email="lorraine.doo@cms.hhs.gov"/>
    <user first="Mags" last="Tamilarasu" email="christopher.j.hills.civ@mail.mil"/>
    <user first="Mamata" last="Thakkar" email="mamata.thakkar@allscripts.com"/>
    <user first="Manisha" last="Khatta" email="khatta_manisha@bah.com"/>
    <user first="Marilyn" last="Parenzan" email="mparenzan@jointcommission.org"/>
    <user first="Mark" last="Bellezza" email="mark.bellezza@va.gov"/>
    <user first="Mark" last="Cacciapouti" email="mark.cacciapouti@wolterskluwer.com"/>
    <user first="Melanie" last="Edwards" email="Melanie.Edwards@cms.hhs.gov"/>
    <user first="Michelle" last="Dardis" email="mdardis@jointcommission.org"/>
    <user first="Minh-Huong" last="Doan" email="minh-huong.l.doan.mil@mail.mil"/>
    <user first="Nancy" last="Orvis" email="nancy.j.orvis.civ@mail.mil"/>
    <user first="Nayan" last="Mergu" email="nayan.mergu@ge.com"/>
    <user first="Nilesh" last="Sawal" email="nilesh.sawal@ge.com"/>
    <user first="Ollie" last="Gray" email="ollie.b.gray.civ@mail.mil"/>
    <user first="Patty" last="Craig" email="pcraig@jointcommission.org"/>
    <user first="Perry" last="Mar" email="pmar@partners.org"/>
    <user first="Randy" last="Bates" email="randy.bates@vanderbilt.edu"/>
    <user first="Rashmi" last="MS" email="rashmi.ms@ge.com"/>
    <user first="Richard" last="Moldwin" email="rmoldwin@cap.org"/>
    <user first="Richard" last="Hornaday" email="richard.hornaday@allscripts.com"/>
    <user first="Robert" last="Stegwee" email="robert.stegwee@cgi.com"/>
    <user first="Robin" last="Williams" email="robin.williams@lantanagroup.com"/>
    <user first="Rohan" last="Pachhapurkar" email="rohan_pachhapurkar@persistent.com"/>
    <user first="Rohan" last="Chavan" email="rohan.chavan@ge.com"/>
    <user first="Russ" last="Ott" email="rott@deloitte.com"/>
    <user first="Russell" last="Davis" email="Russell.J.Davis.civ@mail.mil"/>
    <user first="Rute" last="Martins" email="amartinsbaptista@jointcommission.org"/>
    <user first="Scott" last="Hollington" email="scott.hollington@provationmedical.com"/>
    <user first="Sharon" last="Moore" email="moore_sharon2@bah.com"/>
    <user first="Sofia" last="Stokholm" email="svs@ds.dk"/>
    <user first="Steve" last="Eichner" email="steve.eichner@dshs.texas.gov"/>
    <user first="Steven" last="Bratt" email="sbratt@mitre.org"/>
    <user first="Sunny" last="Goyal" email="sunny.goyal@ge.com"/>
    <user first="Swapna" last="Abhyankar" email="sabhyank@regenstrief.org"/>
    <user first="Terrie" last="Reed" email="Terrie.Reed@fda.hhs.gov"/>
    <user first="Timothy" last="Williams" email="timowilliams@deloitte.com"/>
    <user first="Virginia" last="Hussong" email="virginia.hussong@fda.hhs.gov"/>
    <user first="Walter" last="Suarez" email="walter.g.suarez@kp.org"/>
    <user first="Zabrina" last="Gonzaga" email="zabrina.gonzaga@lantanagroup.com"/>
  </xsl:variable>
  <xsl:variable name="newUsers" as="element(user)+">
    <xsl:apply-templates mode="newUser" select="$newUsersInfo"/>
  </xsl:variable>
  <xsl:variable name="orgTranslations" as="element(name)+">
    <name old="0" new=""/>
    <name old="Academy of Nutrition and Dietetics" new="Academy of Nutrition &amp; Dietetics"/>
    <name old="Academy of Nutrition and Dietetics." new="Academy of Nutrition &amp; Dietetics"/>
    <name old="ACP" new="American College of Physicians"/>
    <name old="Aegis" new="AEGIS.net, Inc."/>
    <name old="AllScripts" new="Allscripts"/>
    <name old="BCBSA" new="Blue Cross Blue Shield Association"/>
    <name old="CBORD" new="The CBORD Group Inc."/>
    <name old="CDC" new="Centers for Disease Control and Prevention/CDC"/>
    <name old="CDC/NIOSH" new="Centers for Disease Control and Prevention/CDC"/>
    <name old="Center for Medicare &amp; Medicaid Services (CMS)" new="Centers for Medicare &amp; Medicaid Services (CMS)"/>
    <name old="Cerner" new="Cerner Corporation"/>
    <name old="CERNER" new="Cerner Corporation"/>
    <name old="CMS" new="Centers for Medicare &amp; Medicaid Services (CMS)"/>
    <name old="Cognosante" new="Cognosante, LLC"/>
    <name old="CSTE- on behalf of the RCKMS project" new="Council of State and Teritorial Epidemiologists"/>
    <name old="Datuit" new="Datuit, LLC"/>
    <name old="Department of Defense" new="PEO DHMS - DoD/VA Interagency Program Office"/>
    <name old="Defense Health Agency/Military Health System" new="PEO DHMS - DoD/VA Interagency Program Office"/>
    <name old="DoD/VA IPO" new="PEO DHMS - DoD/VA Interagency Program Office"/>
    <name old="DoD/VA Interagency Program Office" new="PEO DHMS - DoD/VA Interagency Program Office"/>
    <name old="DoD/DHA/HIT/IATDD" new="PEO DHMS - DoD/VA Interagency Program Office"/>
    <name old="Department of State Health Services" new="Department of State Health Services (Texas)"/>
    <name old="e-HealthSign, LLC" new=""/>
    <name old="Edmond Scientific Company" new=""/>
    <name old="eHealth Data, Inc." new=""/>
    <name old="Elimu Informatics" new=""/>
    <name old="ESAC" new="Enterprise Science and Computing (ESAC)"/>
    <name old="ESAC, Inc." new="Enterprise Science and Computing (ESAC)"/>
    <name old="ESAC Inc." new="Enterprise Science and Computing (ESAC)"/>
    <name old="ESC" new=""/>
    <name old="Eversolve (on behalf of SAMHSA)" new="Eversolve, LLC"/>
    <name old="FHIR Core" new="Partners Healthcare"/>
    <name old="GE Healthcare Digital" new="GE Healthcare"/>
    <name old="Hausam Consulting LLC" new=""/>
    <name old="Health eData Inc" new=""/>
    <name old="Health eData Inc." new=""/>
    <name old="Hl7 Australia" new="HL7 Australia"/>
    <name old="HL7 France / PHAST" new="HL7 France"/>
    <name old="HL7 France / Phast" new="HL7 France"/>
    <name old="HL7 Nutrition Workgroup and on Behalf of Association of Public Health Laboratories (APHL)" new="Association of Public Health Laboratories"/>
    <name old="ICSA Labs" new=""/>
    <name old="IMO" new="Intelligent Medical Objects (IMO)"/>
    <name old="Intelligent Medical Objects" new="Intelligent Medical Objects (IMO)"/>
    <name old="iParsimony LLC" new=""/>
    <name old="Jenaker Consulting" new=""/>
    <name old="Knapp Consulting Inc." new=""/>
    <name old="LabCorp" new="Laboratory Corporation of America"/>
    <name old="Lamprey Networks, Inc." new=""/>
    <name old="Life Over Time Solutions" new=""/>
    <name old="Mathematica Policy Research" new=""/>
    <name old="McKesson" new="McKesson Corporation"/>
    <name old="MD Partners, Inc." new=""/>
    <name old="mhadley@mitre.org" new="MITRE Corporation"/>
    <name old="MITRE" new="MITRE Corporation"/>
    <name old="National Marrow Donnor" new="National Marrow Donor Program"/>
    <name old="Nagesh" new=""/>
    <name old="Nancy Orvis, CherylAnn Kraft) (DHA/HIT/IATDD" new="PEO DHMS - DoD/VA Interagency Program Office"/>
    <name old="Nancy Orvis, CherylAnn Kraft)  (DHA/HIT/IATDD" new="PEO DHMS - DoD/VA Interagency Program Office"/>
    <name old="NEHTA" new="Australian Digital Health Agency"/>
    <name old="NIOSH" new="Centers for Disease Control and Prevention/CDC"/>
    <name old="NICTIZ" new="NICTIZ Nat.ICT.Inst.Healthc.Netherlands"/>
    <name old="NLM" new="National Library of Medicine"/>
    <name old="NHS Digital" new="HL7 UK"/>
    <name old="Northrop Grumman" new="Northrop Grumman Technology Services"/>
    <name old="Ockham Information" new="Ockham Information Services LLC"/>
    <name old="on Behalf of Association of Public Health Laboratories (APHL)" new="Association of Public Health Laboratories"/>
    <name old="Patient Care WG" new=""/>
    <name old="pcraig@jointcommission.org" new="Joint Commission"/>
    <name old="PEO DHMS-DOD/VA IPO" new="PEO DHMS - DoD/VA Interagency Program Office"/>
    <name old="Philips" new="Philips Healthcare"/>
    <name old="Phillips Healthcare" new="Philips Healthcare"/>
    <name old="Shvo) (Philips" new="Philips Healthcare"/>
    <name old="Regenstrief" new="Regenstrief Institute"/>
    <name old="Rick Geimer" new="Lantana Consulting Group"/>
    <name old="Rob Savage, LLC" new=""/>
    <name old="SAMHSA" new="Substance Abuse and Mental Health Services Administration (SAMHSA)"/>
    <name old="Shvo" new=""/>
    <name old="Shvo) (0" new=""/>
    <name old="Standards Australia" new="Australian Digital Health Agency"/>
    <name old="The Joint Commisison" new="Joint Commission"/>
    <name old="The Joint Commission" new="Joint Commission"/>
    <name old="The MITRE Corporation" new="MITRE Corporation"/>
    <name old="TN Dept of Health" new="Tennessee Department of Health"/>
    <name old="TN Dept. of Health" new="Tennessee Department of Health"/>
    <name old="Trusted Solutions Foundry" new=""/>
    <name old="U.S. Department of Veterans Affairs" new="PEO DHMS - DoD/VA Interagency Program Office"/>
    <name old="Univ. of Utah Health Care" new="University of Utah Health Care"/>
    <name old="University of Utah" new="University of Utah Health Care"/>
    <name old="U.S. Department of Defense, Military Health System" new="PEO DHMS - DoD/VA Interagency Program Office"/>
    <name old="US Department of Veterans Affairs" new="PEO DHMS - DoD/VA Interagency Program Office"/>
    <name old="USFDSA" new="Food and Drug Administration"/>
    <name old="VA" new="PEO DHMS - DoD/VA Interagency Program Office"/>
    <name old="Vernetzt, LLC / APHL" new="Vernetzt, LLC"/>
    <name old="Vernetzt, LLC on behalf of APHL" new="Vernetzt, LLC"/>
  </xsl:variable>
  <xsl:variable name="orgEmails" as="element(orgEmail)+">
    <orgEmail name="Academy of Nutrition &amp; Dietetics" suffix="eatright.org"/>
    <orgEmail name="Accenture" suffix="accenture.com"/>
    <orgEmail name="AEGIS.net, Inc." suffix="aegis.net"/>
    <orgEmail name="AHIS - St. John Providence Health" suffix="ascension.org"/>
    <orgEmail name="Albany Medical Center" suffix="albanymedicalcenter.com"/>
    <orgEmail name="Allscripts" suffix="allscripts.com"/>
    <orgEmail name="American College of Physicians" suffix="acponline.org"/>
    <orgEmail name="American College of Surgeons, NTDB" suffix="facs.org"/>
    <orgEmail name="American Health Information Management Association" suffix="ahima.org"/>
    <orgEmail name="American Immunization Registry Association (AIRA)" suffix="immregistries.org"/>
    <orgEmail name="American Society of Clinical Oncology" suffix="asco.org"/>
    <orgEmail name="Amtelco" suffix="1call.com"/>
    <orgEmail name="Apprio, Inc." suffix="apprioinc.com"/>
    <orgEmail name="ARUP Laboratories, Inc." suffix="aruplab.com"/>
    <orgEmail name="Association of Public Health Laboratories" suffix="aphl.org"/>
    <orgEmail name="Audacious Inquiry" suffix="ainq.com"/>
    <orgEmail name="Australian Digital Health Agency" suffix="nehta.gov.au"/>
    <orgEmail name="Australian Digital Health Agency" suffix="digitalhealth.gov.au"/>
    <orgEmail name="Availity, LLC" suffix="availity.com"/>
    <orgEmail name="Blue Cross Blue Shield Association" suffix="bcbsa.com"/>
    <orgEmail name="Blue Cross Blue Shield of Louisiana" suffix="bcbsla.com"/>
    <orgEmail name="Botswana Institute for Technology Research and Inn" suffix="bitri.co.bw"/>
    <orgEmail name="By Light" suffix="bylight.com"/>
    <orgEmail name="CAL2CAL Corporation" suffix="cal2cal.com"/>
    <orgEmail name="California Department of Health Care Services" suffix="dhcs.ca.gov"/>
    <orgEmail name="Cedars-Sinai Medical Center" suffix="cshs.org"/>
    <orgEmail name="Centers for Disease Control and Prevention/CDC" suffix="cdc.gov"/>
    <orgEmail name="Centers for Medicare &amp; Medicaid Services (CMS)" suffix="cms.hhs.gov"/>
    <orgEmail name="CentriHealth" suffix="centrihealth.com"/>
    <orgEmail name="Cerner Corporation" suffix="cerner.com"/>
    <orgEmail name="Change Healthcare" suffix="changehealthcare.com"/>
    <orgEmail name="Clinicomp, Intl" suffix="clinicomp.com"/>
    <orgEmail name="Cognitive Medical Systems" suffix="cognitivemedicine.com"/>
    <orgEmail name="Cognosante, LLC" suffix="cognosante.com"/>
    <orgEmail name="College of American Pathologists" suffix="cap.org"/>
    <orgEmail name="College of Healthcare Information Mgmt. Executives" suffix="chimecentral.org"/>
    <orgEmail name="Computrition, Inc." suffix="computrition.com"/>
    <orgEmail name="Corepoint Health" suffix="corepointhealth.com"/>
    <orgEmail name="Council of State and Teritorial Epidemiologists" suffix="cste.org"/>
    <orgEmail name="Datuit, LLC" suffix="datuit.com"/>
    <orgEmail name="Department of State Health Services (Texas)" suffix="state.tx.us"/>
    <orgEmail name="Duke Clinical &amp; Translational Science Institute" suffix="dm.duke.edu"/>
    <orgEmail name="Edmund Scientific Company" suffix="edmundsci.com" member="false"/>
    <orgEmail name="eHealth Initiative" suffix="ehidc.org"/>
    <orgEmail name="EMR Direct" suffix="emrdirect.com"/>
    <orgEmail name="EnableCare, LLC" suffix="enablecare.us"/>
    <orgEmail name="Enterprise Science and Computing (ESAC)" suffix="esacinc.com"/>
    <orgEmail name="Epic" suffix="epic.com"/>
    <orgEmail name="Eversolve, LLC" suffix="eversolve.com"/>
    <orgEmail name="FEI.com" suffix="feisystems.com"/>
    <orgEmail name="Food and Drug Administration" suffix="fda.hhs.gov"/>
    <orgEmail name="GE Healthcare" suffix="ge.com"/>
    <orgEmail name="Health Care Software, Inc." suffix="hcssupport.com"/>
    <orgEmail name="Health Intersections Pty Ltd" suffix="healthintersections.com.au"/>
    <orgEmail name="Healthland" suffix="healthland.com"/>
    <orgEmail name="Healthwise" suffix="healthwise.org"/>
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
    <orgEmail name="HLN Consulting, LLC" suffix="hln.com"/>
    <orgEmail name="ICCBBA, Inc." suffix="iccbba.org"/>
    <orgEmail name="Info World" suffix="infoworld.ro"/>
    <orgEmail name="Infor" suffix="inform.com"/>
    <orgEmail name="Intelligent Medical Objects (IMO)" suffix="imo-online.com"/>
    <orgEmail name="iNTERFACEWARE, Inc." suffix="interfaceware.com"/>
    <orgEmail name="Intermountain Healthcare" suffix="ihc.com"/>
    <orgEmail name="InterSystems" suffix="intersystems.com"/>
    <orgEmail name="Johns Hopkins Aramco Healthcare" suffix="jhah.com"/>
    <orgEmail name="Johns Hopkins Hospital" suffix="jhmi.edu"/>
    <orgEmail name="Joint Commission" suffix="jointcommission.org"/>
    <orgEmail name="Kaiser Permanente" suffix="kp.org"/>
    <orgEmail name="Laboratory Corporation of America" suffix="labcorp.com"/>
    <orgEmail name="Lantana Consulting Group" suffix="lantanagroup.com"/>
    <orgEmail name="Leidos, Inc." suffix="leidos.com"/>
    <orgEmail name="LINK Medical Computing, Inc." suffix="linkmed.com"/>
    <orgEmail name="Loyola University Health System" suffix="lumc.edu"/>
    <orgEmail name="Mayo Clinic" suffix="mayo.edu"/>
    <orgEmail name="McKesson Corporation" suffix="mckesson.com"/>
    <orgEmail name="Medicity" suffix="medicity.com"/>
    <orgEmail name="Medtronic" suffix="medtronic.com"/>
    <orgEmail name="Mercer University" suffix="mercer.edu"/>
    <orgEmail name="Milton S. Hershey Medical Center" suffix="psu.edu"/>
    <orgEmail name="MITRE Corporation" suffix="mitre.org"/>
    <orgEmail name="National Association of Dental Plans" suffix="nadp.org"/>
    <orgEmail name="National Institute of Standards and Technology" suffix="nist.gov"/>
    <orgEmail name="National Library of Medicine" suffix="nlm.nih.gov"/>
    <orgEmail name="National Library of Medicine" suffix="nlm.nih.gov"/>
    <orgEmail name="National Marrow Donor Program" suffix="nmdp.org"/>
    <orgEmail name="NICTIZ Nat.ICT.Inst.Healthc.Netherlands" suffix="nictiz.nl"/>
    <orgEmail name="NJDOH" suffix="doh.nj.gov"/>
    <orgEmail name="North Carolina Baptist Hospitals, Inc." suffix="wfubmc.edu"/>
    <orgEmail name="Northrop Grumman Technology Services" suffix="northropgrumman.com"/>
    <orgEmail name="Ockham Information Services LLC" suffix="lyle.net"/>
    <orgEmail name="Optum" suffix="optum.com"/>
    <orgEmail name="Oracle" suffix="oracle.com" member="false"/>
    <orgEmail name="Orchard Software" suffix="orchardsoft.com"/>
    <orgEmail name="Partners Healthcare" suffix="partners.org"/>
    <orgEmail name="Partners HealthCare System, Inc." suffix="partners.org"/>
    <orgEmail name="PEO DHMS - DoD/VA Interagency Program Office" suffix="va.gov"/>
    <orgEmail name="PEO DHMS - DoD/VA Interagency Program Office" suffix="mil.gov"/>
    <orgEmail name="PEO DHMS - DoD/VA Interagency Program Office" suffix="mail.mil"/>
    <orgEmail name="Philips Healthcare" suffix="philips.com"/>
    <orgEmail name="Point-of-Care Partners" suffix="pocp.com"/>
    <orgEmail name="Practice Fusion" suffix="practicefusion.com"/>
    <orgEmail name="Professional Laboratory Management, Inc." suffix="plmweb.org"/>
    <orgEmail name="Quest Diagnostics" suffix="questdiagnostics.com"/>
    <orgEmail name="Regenstrief Institute" suffix="regenstrief.org"/>
    <orgEmail name="River Rock Associates" suffix="riverrockassociates.com"/>
    <orgEmail name="Siemens Healthcare" suffix="siemens.com" member="false"/>
    <orgEmail name="SLI Compliance" suffix="slicompliance.com"/>
    <orgEmail name="Social Security Administration" suffix="ssa.gov"/>
    <orgEmail name="Spectrum Health" suffix="spectrumhealth.org"/>
    <orgEmail name="Substance Abuse and Mental Health Services Administration (SAMHSA)" suffix="samhsa.gov"/>
    <orgEmail name="Sunquest Information Systems" suffix="sunquestinfo.com"/>
    <orgEmail name="Surescripts" suffix="surescripts.com"/>
    <orgEmail name="Surescripts" suffix="surescripts.com"/>
    <orgEmail name="Tennessee Department of Health" suffix="tn.gov"/>
    <orgEmail name="The CBORD Group Inc." suffix="cbord.com"/>
    <orgEmail name="The SSI Group, Inc." suffix="ssigroup.com"/>
    <orgEmail name="Transcend Insights" suffix="transcendinsights.com"/>
    <orgEmail name="UK HealthCare" suffix="uky.edu"/>
    <orgEmail name="University of Utah Health Care" suffix="utah.edu"/>
    <orgEmail name="Vernetzt, LLC" suffix=""/>
    <orgEmail name="Washington State Department of Health" suffix="doh.wa.gov"/>
    <orgEmail name="Wellsoft Corporation" suffix="wellsoft.com"/>
    <orgEmail name="Wolters Kluwer Health" suffix="wolterskluwer.com"/>
  </xsl:variable>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*[not(.='null')]|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="trackerItems">
    <xsl:copy>
      <xsl:for-each select="user|$newUsers">
        <xsl:sort select="@name"/>
        <xsl:apply-templates mode="fixUser" select="."/>
      </xsl:for-each>
      <xsl:copy-of select="$orgEmails"/>
      <xsl:for-each select="item">
        <xsl:sort select="@number"/>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="item">
    <xsl:copy>
      <xsl:apply-templates select="@*[not(.='null')]"/>
      <xsl:if test="@submittedName='Ewout Kramer' and starts-with(@summary, 'Jan 2015 Ballot Comment')">
        <xsl:attribute name="submittedName" select="'FHIR Bot'"/>
        <xsl:attribute name="submittedEmail" select="'fhirbot@dilute.net'"/>
        <xsl:attribute name="submittedId" select="'fhir_bot'"/>
      </xsl:if>
      <xsl:if test="@submittedName='AAAA NonCommitter'">
        <xsl:attribute name="submittedName" select="'Simone Heckmann'"/>
        <xsl:attribute name="submittedEmail" select="'sh@gefyra.de'"/>
        <xsl:attribute name="submittedId" select="'simoneheckmann'"/>
      </xsl:if>
      <xsl:if test="@in-Person='Yes'">
        <xsl:call-template name="userId">
          <xsl:with-param name="name" select="@realSubmitter"/>
          <xsl:with-param name="prefix" select="'inPerson'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:apply-templates select="node()[not(self::comment or self::change)]"/>
      <xsl:for-each select="comment">
        <xsl:sort select="@date"/>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
      <xsl:for-each select="change">
        <xsl:sort select="@date"/>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
      <xsl:choose>
        <xsl:when test="@submittedName='FHIR Bot' and @number&lt;10000">
          <xsl:for-each select="details">
            <ballotInfo>
              <xsl:call-template name="ballotForDate">
                <xsl:with-param name="date" select="parent::item/@opened"/>
                <xsl:with-param name="item" select="parent::item"/>
              </xsl:call-template>
              <xsl:attribute name="number" select="normalize-space(substring-before(substring-after(parent::item/@summary, '#'), ' '))"/>
              <xsl:call-template name="processJosh"/>
              <xsl:copy-of select="parent::item/change[element/@name='_created_']"/>
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
              <xsl:variable name="number" select="normalize-space(substring-after(substring-after(parent::item/@summary, ' - '), ' #'))"/>
              <xsl:attribute name="number" select="$number"/>
              <xsl:call-template name="processJosh"/>
              <xsl:copy-of select="parent::item/change[element/@name='_created_']"/>
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
              <change date="{@date}">
                <element name="_created_"/>
              </change>
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
            <xsl:copy-of select="change[element/@name='_created_']"/>
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
                  <xsl:value-of select="normalize-space(@number)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="number" select="$number"/>
            <xsl:attribute name="submitter" select="@realSubmitter"/>
            <xsl:call-template name="userId">
              <xsl:with-param name="name" select="@realSubmitter"/>
              <xsl:with-param name="prefix" select="'submitter'"/>
            </xsl:call-template>
            <xsl:if test="@in-Person='Yes'">
              <xsl:attribute name="inPerson" select="'Y'"/>
            </xsl:if>
            <xsl:copy-of select="change[element/@name='ballot'][1]"/>
          </ballotInfo>
        </xsl:when>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="item[@submittedName='FHIR Bot']/details">
    <xsl:copy>
      <xsl:for-each select="node()">
        <xsl:if test="not(self::p[count(node())=count(text()[normalize-space(.)='']) or starts-with(., '---') or starts-with(., 'Vote:') or starts-with(., 'Submitted by:') or starts-with(., 'In person:') or starts-with(., 'On behalf of') or self::p[normalize-space(.)='']])">
          <xsl:apply-templates select="."/>
        </xsl:if>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="item[@submittedName='Ewout Kramer' and starts-with(@summary, 'Jan 2015 Ballot Comment')]/details">
    <xsl:copy>
      <xsl:variable name="formattedDetails" as="element()+">
        <xsl:apply-templates mode="formatEwout" select="p/strong"/>
      </xsl:variable>
      <xsl:for-each select="$formattedDetails[not(@type=('Vote and Type','Submitted By','Organization','In person resolution requested','On behalf of','On Behalf of Email'))]">
        <strong>
          <xsl:value-of select="@type"/>
        </strong>
        <xsl:value-of select="' '"/>
        <xsl:apply-templates select="node()"/>
      </xsl:for-each>
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
        <xsl:apply-templates select="@*[not(.='null')]"/>
        <xsl:copy-of select="$paragraphs"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
  <xsl:template name="processJosh">
    <xsl:for-each select="p[not(preceding-sibling::p[.='---'])]">
      <xsl:choose>
        <xsl:when test="starts-with(., 'Vote:')">
          <xsl:attribute name="number" select="normalize-space(translate(substring-before(substring-after(translate(., '&#xA0;', ' '), 'Vote:'), '-'), '# ',''))"/>
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
      <xsl:apply-templates mode="formatEwout" select="@*[not(.='null')]|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template name="ballotForDate">
    <xsl:param name="date" as="xs:string"/>
    <xsl:param name="item" as="element(item)"/>
    <xsl:variable name="year" select="substring($date,1,4)"/>
    <xsl:variable name="month" select="substring($date,6,2)"/>
    <xsl:variable name="monthAbbrev" select="if ($month=('01', '02')) then 'Jan' else if ($month=('05','06')) then 'May' else if ($month='09') then 'Sep' else '??'"/>
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
        <xsl:when test="count($userTranslations[@old=$name])>1">
          <xsl:message select="concat('Multiple translations found for name: ', $name)"/>
        </xsl:when>
        <xsl:when test="count($userTranslations[@old=$name])>0">
          <xsl:variable name="translatedId" as="attribute()">
            <xsl:call-template name="userId">
              <xsl:with-param name="name" select="$userTranslations[@old=$name]/@new"/>
              <xsl:with-param name="prefix" select="$prefix"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="$translatedId"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="id" as="xs:string*" select="key('user', $name)/@unix"/>
          <xsl:choose>
            <xsl:when test="count($id)=0">
              <xsl:variable name="user" as="element(user)?" select="$newUsers[@name=$name]"/>
              <xsl:choose>
                <xsl:when test="count($user)=0">
                  <xsl:message select="concat(ancestor-or-self::item/@number, ' Unable to find match for user *', $name, '*')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$user[1]/@unix"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$id[last()]"/>
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
    <xsl:if test="$translatedName!='' and not($orgEmails[@name=$translatedName])">
      <xsl:message select="concat(ancestor-or-self::item/@number, ' Unable to find orgEmail with name: ', $translatedName)"/>
    </xsl:if>
    <xsl:value-of select="$translatedName"/>
  </xsl:template>
  <xsl:template mode="newUser" match="user">
    <xsl:copy>
      <xsl:attribute name="name" select="concat(@first, ' ', @last)"/>
      <xsl:copy-of select="@*[not(.='null')]"/>
      <xsl:attribute name="unix" select="lower-case(concat(@first, '_', @last))"/>
      <xsl:attribute name="id" select="0"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template mode="fixUser" match="user">
    <xsl:copy>
      <xsl:variable name="replacement" select="$userReplacements[@old=translate(current()/@name, '&#xA0;', ' ')]" as="element(name)?"/>
      <xsl:variable name="first" select="normalize-space(if ($replacement) then $replacement/@first else concat(upper-case(substring(@first,1,1)), substring(@first,2,100)))"/>
      <xsl:variable name="last" select="normalize-space(if ($replacement) then $replacement/@last else if (starts-with(@last, 'de ') or starts-with(@last, 'van ')) then @last else concat(upper-case(substring(@last,1,1)), substring(@last,2,100)))"/>
      <xsl:attribute name="first" select="$first"/>
      <xsl:attribute name="last" select="$last"/>
      <xsl:attribute name="name" select="concat($first, if ($last!='') then concat(' ', $last) else '')"/>
      <xsl:copy-of select="@email|@unix|@id|@role|@monitor"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>

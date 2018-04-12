<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/" xmlns:fn="fn" exclude-result-prefixes="xs saxon fn">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:key name="user" match="/files/user/row" use="user_id"/>
	<xsl:key name="extra" match="/files/extra/row" use="element_id"/>
	<xsl:key name="extrafield" match="/files/extrafields/row" use="field_name"/>
	<xsl:key name="dups" match="/files/dups/row" use="tracker_item_id"/>
	<xsl:key name="custom" match="/files/custom/row" use="tracker_item_id"/>
	<xsl:key name="assignee" match="/files/assignee/row" use="tracker_item_id"/>
	<xsl:key name="monitor" match="/files/monitor/row" use="tracker_item_id"/>
	<xsl:key name="comments" match="/files/comments/row" use="tracker_item_id"/>
	<xsl:key name="audit" match="/files/audit/row" use="tracker_item_id"/>
	<xsl:key name="files" match="/files/files/row" use="tracker_item_id"/>
	<xsl:template match="/">
    <trackerItems>
      <xsl:attribute name="lastChange" select="/files/date/row/last_date"/>
      <xsl:for-each select="/files/user/row">
        <xsl:sort select="firstname"/>
        <xsl:sort select="lastname"/>
        <user name="{normalize-space(concat(firstname, ' ', lastname))}" first="{firstname}" last="{lastname}" email="{email}" unix="{unix_name}" id="{user_id}">
          <xsl:if test="role_name!='null'">
            <xsl:attribute name="role" select="role_name"/>
          </xsl:if>
          <xsl:if test="monitor!='null'">
            <xsl:attribute name="monitor" select="monitor"/>
          </xsl:if>
        </user>
      </xsl:for-each>
      <xsl:for-each select="/files/trackers/row">
        <xsl:sort select="tracker_item_id" data-type="number"/>
        <xsl:variable name="id" select="tracker_item_id"/>
        <item number="{$id}" summary="{summary}" opened="{open_date}" priority="{priority}">
          <xsl:if test="close_date!=''">
            <xsl:attribute name="closed" select="close_date"/>
          </xsl:if>
          <xsl:copy-of select="fn:user(submitted_by, 'submitted')"/>
          <xsl:if test="last_modified_date!=''">
            <xsl:attribute name="modified" select="last_modified_date"/>
            <xsl:copy-of select="fn:user(last_modified_by, 'modified')"/>
          </xsl:if>
          <xsl:variable name="custom" select="key('custom', $id)" as="element(row)+"/>
          <xsl:for-each select="$custom[not(field_type=(5, 6)) and field_data!='']">
            <!-- 1=Select, 2=Checkbox, 3=Radio, 4=text field, 5=Multi-select 6=Text area  7=Status 8=Release 9=date 10=numeric 11=serial 12=multi-select members -->
            <xsl:variable name="value" as="xs:string">
              <xsl:choose>
                <xsl:when test="field_type=(1,2,3,7,8)">
                  <xsl:value-of select="key('extra',field_data)/element_name"/>
                </xsl:when>
                <xsl:when test="substring(field_data,1,1)='&amp;' or substring(field_data,1,1)='&lt;'">
                  <xsl:value-of select="substring-before(substring-after(field_data, '&gt;'), '&lt;')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="field_data"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:if test="$value!=''">
              <xsl:attribute name="{fn:fixName(field_name)}" select="$value"/>
            </xsl:if>
          </xsl:for-each>
          <xsl:if test="assignee!=100">
            <xsl:copy-of select="fn:user(assignee, 'assignee')"/>
          </xsl:if>
          <xsl:for-each select="$custom[field_type=(5) and normalize-space(field_data)!='']">
            <xsl:element name="{fn:fixName(field_name)}">
              <xsl:choose>
                <xsl:when test="field_data=100">
                  <xsl:text>None</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="key('extra', field_data)/element_name"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
          </xsl:for-each>
          <xsl:for-each select="details[normalize-space(.)!='']">
            <details>
              <xsl:copy-of select="fn:expandXML(.)"/>
            </details>
          </xsl:for-each>
          <xsl:for-each select="$custom[field_type=(6) and normalize-space(field_data)!='']">
            <xsl:element name="{fn:fixName(field_name)}">
              <xsl:copy-of select="fn:expandXML(field_data)"/>
            </xsl:element>
          </xsl:for-each>
          <xsl:for-each select="key('dups', $id)">
            <dup>
              <xsl:value-of select="duplicate_of_tracker_item_id"/>
            </dup>
          </xsl:for-each>
          <xsl:for-each select="key('monitor', $id)">
            <monitor>
              <xsl:copy-of select="fn:user(user_id, '')"/>
            </monitor>
          </xsl:for-each>
          <xsl:for-each select="key('files', $id)">
            <attachment>
              <xsl:attribute name="fileName" select="file_name"/>
              <xsl:copy-of select="fn:user(posted_by, 'posting')"/>
              <xsl:attribute name="posted" select="created"/>
              <xsl:attribute name="url" select="concat('https://gforge.hl7.org/gf/download/trackeritem/', $id, '/', filesystem_id, '/', encode-for-uri(file_name))"/>
            </attachment>
          </xsl:for-each>
          <xsl:for-each select="key('comments', $id)">
            <xsl:sort select="comment_date"/>
            <comment date="{comment_date}">
              <xsl:copy-of select="fn:user(submitted_by, 'author')"/>
              <xsl:copy-of select="fn:expandXML(comment)"/>
            </comment>
          </xsl:for-each>
          <xsl:variable name="changes" select="key('audit', $id)[not(old_value=new_value)]" as="element(row)*"/>
          <xsl:for-each select="distinct-values($changes/change_date)">
            <xsl:sort select="."/>
            <change date="{.}">
              <xsl:for-each select="$changes[change_date=current()][1]/user_id">
                <xsl:copy-of select="fn:user(., 'author')"/>
              </xsl:for-each>
              <xsl:for-each select="$changes[change_date=current()]">
                <element name="{fn:fixName(key('extrafield', field_name)/new_name)}" old="{old_value}" new="{new_value}"/>
              </xsl:for-each>
            </change>
          </xsl:for-each>
        </item>
      </xsl:for-each>
    </trackerItems>
	</xsl:template>
	<xsl:function name="fn:user" as="attribute()*">
    <xsl:param name="id" as="element()"/>
    <xsl:param name="prefix" as="xs:string"/>
    <xsl:if test="$id!=0">
      <xsl:for-each select="$id">
        <xsl:variable name="user" as="element(row)?" select="key('user', .)"/>
        <xsl:if test="not($user)">
          <xsl:message terminate="yes" select="concat('Missing User: ', .)"/>
        </xsl:if>
        <xsl:attribute name="{concat($prefix, 'Name')}" select="concat($user/firstname, ' ', $user/lastname)"/>
        <xsl:attribute name="{concat($prefix, 'Email')}" select="$user/email"/>
        <xsl:attribute name="{concat($prefix, 'Id')}" select="$user/unix_name"/>
      </xsl:for-each>
    </xsl:if>
	</xsl:function>
	<xsl:function name="fn:fixName" as="xs:string">
    <xsl:param name="name" as="xs:string"/>
    <xsl:variable name="baseName" select="translate(normalize-space($name), ' ?()/: ', '')"/>
    <xsl:value-of select="concat(lower-case(substring($baseName,1,1)), substring($baseName,2))"/>
	</xsl:function>
	<xsl:function name="fn:expandXML" as="node()*">
    <xsl:param name="string" as="xs:string"/>
    <xsl:copy-of select="saxon:parse(concat('&lt;t&gt;', $string, '&lt;/t&gt;'))/t/node()"/>
	</xsl:function>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/" xmlns:fn="fn" exclude-result-prefixes="xs saxon fn">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:key name="user" match="/files/user/row" use="user_id"/>
	<xsl:key name="extra" match="/files/extra/row" use="element_id"/>
	<xsl:key name="extrafield" match="/files/extrafields/row" use="field_name"/>
	<xsl:template match="/">
    <trackerItems>
      <xsl:attribute name="lastChange" select="/files/date/row/last_date"/>
      <xsl:for-each select="/files/trackers/row">
        <xsl:variable name="id" select="tracker_item_id"/>
        <item number="{$id}" summary="{summary}" opened="{open_date}">
          <xsl:if test="close_date!=''">
            <xsl:attribute name="closed" select="close_date"/>
          </xsl:if>
          <xsl:copy-of select="fn:user(submitted_by, 'submitted')"/>
          <xsl:if test="last_modified_date!=''">
            <xsl:attribute name="modified" select="last_modified_date"/>
            <xsl:copy-of select="fn:user(last_modified_by, 'modified')"/>
          </xsl:if>
          <xsl:variable name="custom" select="/files/custom/row[tracker_item_id=$id]" as="element(row)+"/>
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
          <xsl:for-each select="/files/dups/row[tracker_item_id=$id]">
            <dup>
              <xsl:value-of select="duplicate_of_tracker_item_id"/>
            </dup>
          </xsl:for-each>
          <xsl:for-each select="/files/dups/assignee[tracker_item_id=$id]">
            <assignee>
              <xsl:value-of select="fn:user(assignee, '')"/>
            </assignee>
          </xsl:for-each>
          <xsl:for-each select="/files/comments/row[tracker_item_id=$id]">
            <comment date="{comment_date}">
              <xsl:copy-of select="fn:user(submitted_by, 'author')"/>
              <xsl:copy-of select="fn:expandXML(comment)"/>
            </comment>
          </xsl:for-each>
          <xsl:variable name="changes" select="/files/audit/row[tracker_item_id=$id and not(old_value=new_value)]" as="element(row)*"/>
          <xsl:for-each select="distinct-values($changes/change_date)">
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

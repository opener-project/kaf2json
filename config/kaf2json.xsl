<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
KAF2JOSN
This module convert an xml kaf document into Jsonversion 1.2

date 23/05/2014
Author Andrea Marchetti 
OpeNER Project
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-->
<xsl:output method="text" encoding="utf-8" omit-xml-declaration="yes"/>

<xsl:template match="/">{
	"text"      : "<xsl:apply-templates select="KAF/text/wf"                           />",
	"language"  : "<xsl:value-of        select="KAF/@xml:lang"                         />",
	"terms"     : {<xsl:apply-templates select="KAF/terms/term"                        />},
	"sentiments": {<xsl:apply-templates select="KAF/terms/term/sentiment"              />},
	"entities"  : {<xsl:apply-templates select="KAF/entities/entity"                   />},
	"opinions"  : {<xsl:apply-templates select="KAF/opinions/opinion"                  />},
	"lp"        : [<xsl:apply-templates select="KAF/kafHeader//lp"                     />]
}
</xsl:template>

<xsl:template match="wf">
	<xsl:value-of select="."/><xsl:text> </xsl:text>
</xsl:template>

<!-- Levels -->
<xsl:template match="lp">
{
	"name"     :"<xsl:value-of select="@name"     />",
	"timestamp":"<xsl:value-of select="@timestamp"/>",
	"version"  :"<xsl:value-of select="@version"  />",
	"layer"    :"<xsl:value-of select="../@layer" />"
}<xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>


<xsl:template match="term">
	<xsl:variable name="termId" select="@tid"/>
 	"<xsl:value-of select="$termId"/>":
	{
		"type"       :"<xsl:value-of select="@type"              />",
		"lemma"      :"<xsl:value-of select="@lemma"             />",
		"text"       :"<xsl:call-template name="termInside2"     />",
		"pos"        :"<xsl:value-of select="@pos"               />",
		"morphofeat" :"<xsl:value-of select="@morphofeat"        />"<xsl:if test="sentiment">,
		"sentiment"  :<xsl:apply-templates select="sentiment" mode="inside"   /> </xsl:if>                  <xsl:if test="//entity//target/@id=$termId">,
		"entity"     :"<xsl:value-of select="//entity[.//target/@id=$termId]/@eid"/>"</xsl:if> <xsl:if test="//opinion//target/@id=$termId">,
		"opinion"    :"<xsl:value-of select="//opinion[.//target/@id=$termId]/@oid"/>"</xsl:if>
	}<xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>


<xsl:template match="sentiment">
	"s<xsl:value-of select="position()"/>":
	{
		"lexicon" :"<xsl:value-of select="@resource"        />",
		<xsl:if test="@polarity">"polarity":"<xsl:value-of select="@polarity"/>",</xsl:if>
		<xsl:if test="@sentiment_modifier">"sentiment_modifier":"<xsl:value-of select="@sentiment_modifier"/>",</xsl:if>
		"termId"  :"<xsl:value-of select="parent::term/@tid"/>",
		"text"    :"<xsl:call-template name="termInside"    />"
	}<xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="sentiment" mode="inside">
		{
			"lexicon" :"<xsl:value-of select="@resource"        />"<xsl:if test="@polarity">,
			"polarity":"<xsl:value-of select="@polarity"/>"</xsl:if><xsl:if test="@sentiment_modifier">,
			"sentiment_modifier":"<xsl:value-of select="@sentiment_modifier"/>"</xsl:if>
		}
</xsl:template>

<xsl:template match="entity">
 	"<xsl:value-of select="@eid"/>":
	{
		"type"     :"<xsl:value-of select="@type"                                      />",
		"text"     :"<xsl:call-template name="entityInside"                            />",
		"reference":"<xsl:value-of select="externalReferences/externalRef/@reference"  />",
		"terms"    :[<xsl:apply-templates select="references"/>]
	}<xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="references">
	<xsl:call-template name="termList"/>
</xsl:template>


<xsl:template match="opinion">
 	"<xsl:value-of select="@oid"/>":
	{   <xsl:if test="opinion_holder"    >
		"holder"    :[<xsl:apply-templates select="opinion_holder"/>],</xsl:if><xsl:if test="opinion_target"    >
		"target"    :[<xsl:apply-templates select="opinion_target"/>],</xsl:if><xsl:if test="opinion_expression">
		"expression":[<xsl:apply-templates select="opinion_expression"/>],
		"polarity"  :"<xsl:value-of        select="opinion_expression/@polarity"/>",
		"strength"  :"<xsl:value-of        select="opinion_expression/@strength"/>",</xsl:if>
		"text"      :"<xsl:call-template name="opinionInside" />"
	}<xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>


<xsl:template match="opinion_expression|opinion_target|opinion_holder">
	<xsl:call-template name="termList"/>
</xsl:template>

<!-- Routines -->

<xsl:template name="termInside">
	<xsl:for-each select="parent::term/span/target">
		<xsl:call-template name="word">
			<xsl:with-param name="id" select="@id"/>
		</xsl:call-template>
		<xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if>
	</xsl:for-each>
</xsl:template>

<xsl:template name="termInside2">
	<xsl:for-each select="span/target">
		<xsl:call-template name="word">
			<xsl:with-param name="id" select="@id"/>
		</xsl:call-template>
		<xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if>
	</xsl:for-each>
</xsl:template>

<xsl:template name="entityInside">
	<xsl:for-each select="references/span/target">
		<xsl:call-template name="term">
			<xsl:with-param name="id" select="@id"/>
		</xsl:call-template>
		<xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if>
	</xsl:for-each>
</xsl:template>


<xsl:template name="termList">
	<xsl:for-each select="span/target">"<xsl:value-of select="@id"/>"<xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>
</xsl:template>

<xsl:template name="opinionInside">
	<xsl:for-each select="opinion_expression/span/target">
		<xsl:call-template name="term">
			<xsl:with-param name="id" select="@id"/>
		</xsl:call-template>
		<xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if>
	</xsl:for-each>
</xsl:template>

<!-- Generic Routines -->
<xsl:template name="term">
	<xsl:param name="id"/>
	<xsl:for-each select="//term[@tid=$id]/span/target">
		<xsl:call-template name="word">
			<xsl:with-param name="id" select="@id"/>
		</xsl:call-template>
	</xsl:for-each>
</xsl:template>

<xsl:template name="word">
	<xsl:param name="id"/>
	<xsl:value-of select="//wf[@wid=$id]"/>
</xsl:template>
</xsl:stylesheet>
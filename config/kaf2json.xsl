<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="utf-8" omit-xml-declaration="yes"/>

<xsl:template match="/">{	
	"text"      : "<xsl:apply-templates select="KAF/text/wf"              />",
	"language"  : "<xsl:value-of select="KAF/@xml:lang"                   />",
	"terms"     : {<xsl:apply-templates select="KAF/terms/term"           />},
	"sentiments": [<xsl:apply-templates select="KAF/terms/term/sentiment" />],
	"entities"  : {<xsl:apply-templates select="KAF/entities/entity"      />},
	"opinions"  : {<xsl:apply-templates select="KAF/opinions/opinion"     />}
}
</xsl:template>

<xsl:template match="wf">
	<xsl:value-of select="."/><xsl:text> </xsl:text>
</xsl:template>

<!-- Levels -->
<xsl:template match="term">
	<xsl:variable name="termId" select="@tid"/>
 	"<xsl:value-of select="$termId"/>":
	{
		"type"       :"<xsl:value-of select="@type"              />",
		"lemma"      :"<xsl:value-of select="@lemma"             />",
		"text"       :"<xsl:call-template name="termInside2"     />",
		"pos"        :"<xsl:value-of select="@pos"               />",
		"morphofeat" :"<xsl:value-of select="@morphofeat"        />"<xsl:if test="//entity//target/@id=$termId">,
		"entity"     :"<xsl:value-of select="//entity[.//target/@id=$termId]/@eid"/>"</xsl:if><xsl:if test="sentiment">,
		"polarity"   :"<xsl:value-of select="sentiment/@polarity"/>"</xsl:if>
	}<xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="sentiment">
{
	"lexicon" :"<xsl:value-of select="@resource"        />",
	"polarity":"<xsl:value-of select="@polarity"        />",
	"termId"  :"<xsl:value-of select="parent::term/@tid"/>",
	"text"    :"<xsl:call-template name="termInside"    />"
}<xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="entity">
 	"<xsl:value-of select="@eid"/>":
	{
		"type"     :"<xsl:value-of select="@type"                                      />",
		"text"     :"<xsl:call-template name="entityInside"                            />",
		"reference":"<xsl:value-of select="externalReferences/externalRef/@reference"  />",
		"terms"    :[<xsl:call-template name="entityTerms"/>]
	}<xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="opinion">
 	"<xsl:value-of select="@oid"/>":
	{
		"holder"    :"",
		"target"    :"",
		"polarity"  :"<xsl:value-of select="opinion_expression/@polarity"/>",
		"strength"  :"<xsl:value-of select="opinion_expression/@strength"/>",
		"text"      :"<xsl:call-template name="opinionInside"            />",
		"terms"     :[<xsl:call-template name="opinionTerms"/>]
	}<xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if>
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

<xsl:template name="entityTerms">
	<xsl:for-each select="references/span/target">"<xsl:value-of select="@id"/>"<xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>
</xsl:template>

<xsl:template name="opinionTerms">
	<xsl:for-each select="opinion_expression/span/target">"<xsl:value-of select="@id"/>"<xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>
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
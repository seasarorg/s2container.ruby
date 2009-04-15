<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0'>

  <!--xsl:import href="../lib/docbook-xsl/html/docbook.xsl"/ -->
  <xsl:import href="../lib/docbook-xsl/html/chunk.xsl"/>

  <xsl:param name="html.stylesheet">../../theme/docbook.css</xsl:param>
  <xsl:param name="toc.section.depth" select="2"/>
  <xsl:param name="use.id.as.filename" select="1"/>
  <xsl:param name="chapter.autolabel" select="1"/>
  <xsl:param name="section.autolabel" select="1"/>
  <xsl:param name="section.label.includes.component.label" select="1"/>
  <xsl:param name="use.extensions" select="1"/>
  <xsl:param name="admon.graphics" select="1"/>
  <xsl:param name="admon.graphics.path">../../images/docbook/</xsl:param>

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  <xsl:template name="user.header.navigation">
    <a href="../index.html"><img src="../../images/seasar_logo_blue.gif"/></a><br/>
  </xsl:template>
  <xsl:template name="user.header.content">
  </xsl:template>

  <xsl:template name="user.footer.content">
  </xsl:template>

  <xsl:template name="user.footer.navigation">
    <br />
    <br />
    <table width="100%"><tr><td align="center"><font size="-2">
    © Copyright The Seasar Foundation and the others 2008-2009, all rights reserved.
    </font></td></tr></table>
  </xsl:template>

  <xsl:template name="person.name.family-given">
    <xsl:param name="node" select="."/>
    <xsl:apply-templates select="$node//surname[1]"/>
    <xsl:if test="$node//surname and $node//firstname">
      <xsl:apply-templates select="$node//firstname[1]"/>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>

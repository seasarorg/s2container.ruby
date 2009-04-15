<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  version='1.0'>

  <xsl:import href="../lib/docbook-xsl/fo/docbook.xsl"/>

  <xsl:param name="chunker.output.encoding" select="'UTF-8'" />  
  <xsl:param name="fop.extensions" select="0" />
  <xsl:param name="paper.type" select="'A4'" />
  <xsl:param name="draft.mode" select="'no'" />
  <xsl:param name="section.autolabel" select="1" />
  <xsl:param name="section.label.includes.component.label" select="1" />
  <xsl:param name="hyphenate">false</xsl:param>
  <xsl:param name="chapter.autolabel" select="'1'"/>
  <xsl:param name="callout.graphics.extension" select="'.gif'"/>
  
  <xsl:param name="title.font.family" select="'MS Gothic'" />
  <xsl:param name="body.font.family" select="'MS Mincho'" />
  <xsl:param name="sans.font.family" select="'MS Gothic'" />
  <xsl:param name="monospace.font.family" select="'MS Mincho'" />

  <xsl:param name="admon.graphics" select="1"/>
  <xsl:param name="admon.graphics.path">doc/images/docbook/</xsl:param>

  <xsl:param name="page.margin.inner">0.4in</xsl:param>
  <xsl:param name="page.margin.outer">0.4in</xsl:param>
  <xsl:param name="body.start.indent">2pc</xsl:param>

  <xsl:attribute-set name="component.title.properties">
    <xsl:attribute name="font-size">16pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="font-size">14pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level2.properties">
    <xsl:attribute name="font-size">12pt</xsl:attribute>
  </xsl:attribute-set>  

  <xsl:attribute-set name="section.title.level3.properties">
    <xsl:attribute name="font-size">10pt</xsl:attribute>
  </xsl:attribute-set>  
</xsl:stylesheet>

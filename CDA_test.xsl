<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>Human-Readable CDA Viewer</title>
        <meta charset="UTF-8"/>
        <style>
          body { font-family: Segoe UI, sans-serif; padding: 20px; }
          h1 { font-size: 1.5em; margin-bottom: 0.2em; }
          h2 { font-size: 1.2em; margin-top: 1em; }
          details { border: 1px solid #ccc; border-radius: 5px; margin-bottom: 10px; padding: 10px; }
          summary { font-weight: bold; cursor: pointer; }
          .icon { margin-right: 6px; }
        </style>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
      </head>
      <body>
        <h1>CDA Document Summary</h1>
        <!-- Patient Demographics -->
        <xsl:call-template name="patient-demographics"/>

        <!-- Author -->
        <xsl:call-template name="document-author"/>

        <!-- Document Type -->
        <xsl:call-template name="document-type"/>

        <!-- Encounter Info -->
        <xsl:call-template name="encounter-info"/>

        <!-- Custodian -->
        <xsl:call-template name="custodian-info"/>

        <!-- Legal Authenticator -->
        <xsl:call-template name="legal-authenticator"/>

        <!-- Related Documents -->
        <xsl:call-template name="related-documents"/>

        <h2>📑 Structured Body</h2>
        <xsl:apply-templates select="ClinicalDocument/component/structuredBody/component"/>
      </body>
    </html>
  </xsl:template>

  <!-- Simplified patient demographics example -->
  <xsl:template name="patient-demographics">
    <h2><span class="icon">👤</span>Patient Demographics</h2>
    <p>
      <xsl:value-of select="ClinicalDocument/recordTarget/patientRole/patient/name/given"/> 
      <xsl:value-of select="ClinicalDocument/recordTarget/patientRole/patient/name/family"/>
    </p>
  </xsl:template>

  <!-- Example structured body section template -->
  <xsl:template match="component">
    <xsl:variable name="sectionCode" select="section/code/@code"/>
    <xsl:variable name="title" select="section/title"/>
    <details>
      <summary><span class="icon">📄</span><xsl:value-of select="$title"/></summary>
      <div>
        <xsl:apply-templates select="section/text"/>
      </div>
    </details>
  </xsl:template>

  <!-- Render embedded HTML text blocks (common in CDA) -->
  <xsl:template match="section/text">
    <xsl:copy-of select="node()"/>
  </xsl:template>

  <!-- Additional templates (document-author, custodian-info, etc.) would follow the same model -->
</xsl:stylesheet>

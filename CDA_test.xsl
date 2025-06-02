<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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
          #toc { background: #f0f0f0; padding: 10px; margin-bottom: 20px; border-radius: 5px; }
          #toc a { display: block; margin: 4px 0; text-decoration: none; color: #0056b3; }
          .back-to-top { margin-top: 10px; display: block; font-size: .9em; text-align: right; }
          button { margin-right: 10px; background: #0078D4; color: white; padding: 8px 12px; border: none; border-radius: 4px; cursor: pointer; }
          button:hover { background: #005a9e; }
        </style>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
      </head>
      <body id="top">
        <h1>CDA Document Summary</h1>
        <div id="toc">
          <strong>Table of Contents:</strong><br/>
        </div>
        <button id="downloadBtn">Download as HTML</button>
        <button id="printBtn">Print to PDF</button>
        <hr/>

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

        <script>
          window.onload = function() {
            const content = document.body;
            const toc = document.getElementById("toc");
            content.querySelectorAll("h1,h2,h3").forEach((el, i) => {
              el.id = "section" + i;
              const link = document.createElement("a");
              link.href = "#section" + i;
              link.textContent = el.textContent;
              toc.appendChild(link);

              const back = document.createElement("a");
              back.href = "#top";
              back.className = "back-to-top";
              back.innerText = "↑ Back to Top";
              el.insertAdjacentElement("afterend", back);
            });

            document.getElementById("downloadBtn").onclick = () => {
              const blob = new Blob(["<!DOCTYPE html><html>" + document.documentElement.innerHTML + "</html>"], { type: "text/html" });
              const url = URL.createObjectURL(blob);
              const a = document.createElement("a");
              a.href = url;
              a.download = "cda_transformed.html";
              a.click();
              URL.revokeObjectURL(url);
            };

            document.getElementById("printBtn").onclick = () => {
              window.print();
            };
          };
        </script>
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

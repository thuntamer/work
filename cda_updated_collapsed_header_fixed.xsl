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
        <h2><span class="icon">👤</span>Patient Demographics</h2>
        <p>
          <strong>Name:</strong> <xsl:value-of select="ClinicalDocument/recordTarget/patientRole/patient/name/given"/> <xsl:value-of select="ClinicalDocument/recordTarget/patientRole/patient/name/family"/><br/>
          <strong>Gender:</strong> <xsl:value-of select="ClinicalDocument/recordTarget/patientRole/patient/administrativeGenderCode/@displayName"/><br/>
          <strong>Birth Date:</strong> <xsl:value-of select="ClinicalDocument/recordTarget/patientRole/patient/birthTime/@value"/><br/>
          <strong>Race:</strong> <xsl:value-of select="ClinicalDocument/recordTarget/patientRole/patient/raceCode/@displayName"/><br/>
          <strong>Ethnicity:</strong> <xsl:value-of select="ClinicalDocument/recordTarget/patientRole/patient/ethnicGroupCode/@displayName"/><br/>
          <strong>Address:</strong> <xsl:value-of select="ClinicalDocument/recordTarget/patientRole/addr/streetAddressLine"/>, <xsl:value-of select="ClinicalDocument/recordTarget/patientRole/addr/city"/>, <xsl:value-of select="ClinicalDocument/recordTarget/patientRole/addr/state"/> <xsl:value-of select="ClinicalDocument/recordTarget/patientRole/addr/postalCode"/><br/>
          <strong>Phone:</strong> <xsl:value-of select="ClinicalDocument/recordTarget/patientRole/telecom[@use='HP']/@value"/><br/>
          <strong>Email:</strong> <xsl:value-of select="ClinicalDocument/recordTarget/patientRole/telecom[@use='H']/@value"/>
        </p>

        <!-- Document Author -->
        <h2><span class="icon">✍️</span>Document Author</h2>
        <p>
          <strong>Name:</strong> <xsl:value-of select="ClinicalDocument/author/assignedAuthor/assignedPerson/name/given"/> <xsl:value-of select="ClinicalDocument/author/assignedAuthor/assignedPerson/name/family"/><br/>
          <strong>Organization:</strong> <xsl:value-of select="ClinicalDocument/author/assignedAuthor/representedOrganization/name"/><br/>
          <strong>Time:</strong> <xsl:value-of select="ClinicalDocument/author/time/@value"/>
        </p>

        <!-- Document Type -->
        <h2><span class="icon">📄</span>Document Type</h2>
        <p>
          <strong>Type:</strong> <xsl:value-of select="ClinicalDocument/code/@displayName"/>
        </p>

        <!-- Encounter Info -->
        <h2><span class="icon">🏥</span>Encounter Information</h2>
        <p>
          <xsl:for-each select="ClinicalDocument/componentOf/encompassingEncounter" >
            <strong>Encounter Time:</strong> <xsl:value-of select="effectiveTime/@value"/><br/>
            <strong>Facility:</strong> <xsl:value-of select="location/healthCareFacility/location/name"/>
          </xsl:for-each>
        </p>

        <!-- Custodian -->
        <h2><span class="icon">📁</span>Custodian</h2>
        <p>
          <strong>Organization:</strong> <xsl:value-of select="ClinicalDocument/custodian/assignedCustodian/representedCustodianOrganization/name"/>
        </p>

        <!-- Legal Authenticator -->
        <h2><span class="icon">🖊</span>Legal Authenticator</h2>
        <p>
          <strong>Name:</strong> <xsl:value-of select="ClinicalDocument/legalAuthenticator/assignedEntity/assignedPerson/name/given"/> <xsl:value-of select="ClinicalDocument/legalAuthenticator/assignedEntity/assignedPerson/name/family"/><br/>
          <strong>Time:</strong> <xsl:value-of select="ClinicalDocument/legalAuthenticator/time/@value"/>
        </p>

        <!-- Related Documents -->
        <h2><span class="icon">🔗</span>Related Documents</h2>
        <p>
          <xsl:for-each select="ClinicalDocument/relatedDocument">
            <strong>Type:</strong> <xsl:value-of select="@typeCode"/><br/>
            <strong>Document ID:</strong> <xsl:value-of select="parentDocument/id/@root"/><br/>
          </xsl:for-each>
        </p>

        <h2>📑 Structured Body</h2>
        <xsl:apply-templates select="ClinicalDocument/component/structuredBody/component"/>

        <script><![CDATA[
          window.onload = function() {
            const toc = document.getElementById("toc");
            document.body.querySelectorAll("h1,h2,h3").forEach((el,i)=>{
              el.id="section"+i;
              const link=document.createElement("a");
              link.href="#section"+i;
              link.textContent=el.textContent;
              toc.appendChild(link);
              const back=document.createElement("a");
              back.href="#top";
              back.className="back-to-top";
              back.innerText="↑ Back to Top";
              el.insertAdjacentElement("afterend",back);
            });
            document.getElementById("downloadBtn").onclick=()=>{
              const blob=new Blob(["<!DOCTYPE html><html>"+document.documentElement.innerHTML+"</html>"],{type:"text/html"});
              const url=URL.createObjectURL(blob);
              const a=document.createElement("a");a.href=url;a.download="cda_view.html";a.click();URL.revokeObjectURL(url);
            };
            document.getElementById("printBtn").onclick=()=>window.print();
          };
        ]]></script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="component">
    <details>
      <summary><span class="icon">📄</span><xsl:value-of select="section/title"/></summary>
      <div><xsl:apply-templates select="section/text"/></div>
    </details>
  </xsl:template>

  <xsl:template match="section/text">
    <xsl:copy-of select="node()"/>
  </xsl:template>

</xsl:stylesheet>

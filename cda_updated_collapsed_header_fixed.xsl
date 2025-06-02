<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:hl7="urn:hl7-org:v3"
  exclude-result-prefixes="hl7">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- Shortcuts -->
  <xsl:variable name="doc" select="hl7:ClinicalDocument"/>
  <xsl:variable name="patient" select="$doc/hl7:recordTarget/hl7:patientRole"/>
  
  <xsl:template match="/">
    <html>
      <head>
        <title>Human‑Readable CDA Viewer</title>
        <meta charset="UTF-8"/>
        <style>
          body { font-family: Segoe UI, sans-serif; padding: 20px; }
          h1 { font-size: 1.5em; margin-bottom: .2em; }
          h2 { font-size: 1.2em; margin-top: 1em; }
          details { border: 1px solid #ccc; border-radius: 5px; margin-bottom: 10px; padding: 10px; }
          summary { font-weight: bold; cursor: pointer; }
          .icon { margin-right: 6px; }
          #toc { background:#f0f0f0; padding:10px; margin-bottom:20px; border-radius:5px; }
          #toc a { display:block; margin:4px 0; text-decoration:none; color:#0056b3; }
          .back-to-top { margin-top:10px; display:block; font-size:.9em; text-align:right; }
          button { margin-right:10px; background:#0078D4; color:#fff; padding:8px 12px; border:none; border-radius:4px; cursor:pointer; }
          button:hover { background:#005a9e; }
        </style>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
      </head>
      <body id="top">
        <h1>CDA Document Summary</h1>
        <div id="toc"><strong>Table of Contents:</strong><br/></div>
        <button id="downloadBtn">Download as HTML</button>
        <button id="printBtn">Print to PDF</button>
        <hr/>

        <!-- Patient Demographics -->
        <h2><span class="icon">👤</span>Patient Demographics</h2>
        <p>
          <strong>Name:</strong>
          <xsl:value-of select="$patient/hl7:patient/hl7:name[1]/hl7:given"/> <xsl:value-of select="$patient/hl7:patient/hl7:name[1]/hl7:family"/><br/>
          <strong>Gender:</strong> <xsl:value-of select="$patient/hl7:patient/hl7:administrativeGenderCode/@displayName"/><br/>
          <strong>Birth&nbsp;Date:</strong> <xsl:value-of select="$patient/hl7:patient/hl7:birthTime/@value"/><br/>
          <strong>Race:</strong> <xsl:value-of select="$patient/hl7:patient/hl7:raceCode/@displayName"/><br/>
          <strong>Ethnicity:</strong> <xsl:value-of select="$patient/hl7:patient/hl7:ethnicGroupCode/@displayName"/><br/>
          <strong>Address:</strong>
          <xsl:value-of select="$patient/hl7:addr[1]/hl7:streetAddressLine"/>,
          <xsl:value-of select="$patient/hl7:addr[1]/hl7:city"/>,
          <xsl:value-of select="$patient/hl7:addr[1]/hl7:state"/>
          <xsl:value-of select="$patient/hl7:addr[1]/hl7:postalCode"/><br/>
          <strong>Phone:</strong> <xsl:value-of select="$patient/hl7:telecom[starts-with(@value,'tel')][1]/@value"/><br/>
          <strong>Email:</strong> <xsl:value-of select="$patient/hl7:telecom[starts-with(@value,'mailto')][1]/@value"/>
        </p>

        <!-- Document Author -->
        <h2><span class="icon">✍️</span>Document Author</h2>
        <xsl:variable name="author" select="$doc/hl7:author[1]"/>
        <p>
          <strong>Name:</strong>
          <xsl:value-of select="$author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:given"/> <xsl:value-of select="$author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:family"/><br/>
          <strong>Organization:</strong> <xsl:value-of select="$author/hl7:assignedAuthor/hl7:representedOrganization/hl7:name"/><br/>
          <strong>Time:</strong> <xsl:value-of select="$author/hl7:time/@value"/>
        </p>

        <!-- Document Type -->
        <h2><span class="icon">📄</span>Document Type</h2>
        <p><strong>Type:</strong> <xsl:value-of select="$doc/hl7:code/@displayName"/></p>

        <!-- Encounter Information -->
        <h2><span class="icon">🏥</span>Encounter Information</h2>
        <xsl:for-each select="$doc/hl7:componentOf/hl7:encompassingEncounter">
          <p>
            <strong>Encounter&nbsp;Time:</strong>
            <xsl:value-of select="hl7:effectiveTime/hl7:low/@value"/> – <xsl:value-of select="hl7:effectiveTime/hl7:high/@value"/><br/>
            <strong>Facility:</strong> <xsl:value-of select="hl7:location/hl7:healthCareFacility/hl7:location/hl7:name"/>
          </p>
        </xsl:for-each>

        <!-- Custodian -->
        <h2><span class="icon">📁</span>Custodian</h2>
        <p><strong>Organization:</strong> <xsl:value-of select="$doc/hl7:custodian/hl7:assignedCustodian/hl7:representedCustodianOrganization/hl7:name"/></p>

        <!-- Legal Authenticator -->
        <h2><span class="icon">🖊</span>Legal Authenticator</h2>
        <xsl:variable name="legal" select="$doc/hl7:legalAuthenticator"/>
        <p>
          <strong>Name:</strong>
          <xsl:value-of select="$legal/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given"/> <xsl:value-of select="$legal/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family"/><br/>
          <strong>Time:</strong> <xsl:value-of select="$legal/hl7:time/@value"/>
        </p>

        <!-- Related Documents -->
        <h2><span class="icon">🔗</span>Related Documents</h2>
        <xsl:for-each select="$doc/hl7:relatedDocument">
          <p>
            <strong>Type:</strong> <xsl:value-of select="@typeCode"/><br/>
            <strong>Document&nbsp;ID:</strong> <xsl:value-of select="hl7:parentDocument/hl7:id/@root"/>
          </p>
        </xsl:for-each>

        <!-- Structured Body -->
        <h2><span class="icon">📑</span>Structured Body</h2>
        <xsl:apply-templates select="$doc/hl7:component/hl7:structuredBody/hl7:component"/>

        <!-- JS (same as before) -->
        <script>
          window.onload=function(){
            const toc=document.getElementById('toc');
            document.body.querySelectorAll('h1,h2,h3').forEach((el,i)=>{
              el.id='s'+i;
              const a=document.createElement('a');a.href='#s'+i;a.textContent=el.textContent;toc.appendChild(a);
              const back=document.createElement('a');back.href='#top';back.className='back-to-top';back.innerText='↑ Back to Top';
              el.after(back);
            });
            document.getElementById('downloadBtn').onclick=()=>{
              const blob=new Blob(['<!DOCTYPE html><html>'+document.documentElement.innerHTML+'</html>'],{type:'text/html'});
              const url=URL.createObjectURL(blob);const a=document.createElement('a');a.href=url;a.download='cda.html';a.click();URL.revokeObjectURL(url);
            };
            document.getElementById('printBtn').onclick=()=>window.print();
          };
        </script>
      </body>
    </html>
  </xsl:template>

  <!-- SECTION / TEXT rendering (unchanged except for namespace) -->
  <xsl:template match="hl7:component">
    <xsl:variable name="title" select="hl7:section/hl7:title"/>
    <details>
      <summary><span class="icon">📄</span><xsl:value-of select="$title"/></summary>
      <div><xsl:apply-templates select="hl7:section/hl7:text"/></div>
    </details>
  </xsl:template>

  <xsl:template match="hl7:section/hl7:text"><xsl:copy-of select="node()"/></xsl:template>
</xsl:stylesheet>

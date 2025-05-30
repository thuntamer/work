<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:hl7="urn:hl7-org:v3"
    exclude-result-prefixes="hl7">

  <xsl:output method="html" indent="yes"/>

  <!-- Entry-point: match the ClinicalDocument in HL7 namespace -->
  <xsl:template match="/hl7:ClinicalDocument">
    <html>
      <head>
        <title><xsl:value-of select="hl7:title"/></title>
        <style>
          body { font-family: Arial,sans-serif; margin:20px; }
          table { border-collapse: collapse; width:100%; margin-bottom:20px; }
          th, td { border:1px solid #ccc; padding:8px; text-align:left; }
          th { background:#f0f0f0; }
          h1 { margin-bottom:10px; }
          h2 { margin-top:30px; color:#003366; }
          #toc { background:#f9f9f9; padding:10px; margin-bottom:20px; border-left:4px solid #0078D4; }
          #toc a { display:block; margin:4px 0; text-decoration:none; color:#0078D4; font-weight:bold; }
          .back-to-top { display:block; font-size:0.8em; text-align:right; margin-bottom:10px; }
          @media print { #toc, .back-to-top { display:none; } }
        </style>
        <script>
          window.onload = function() {
            var toc = document.getElementById('toc');
            var sections = document.querySelectorAll('h2');
            for (var i=0; i<sections.length; i++) {
              var sec = sections[i];
              var id = 'section'+i; sec.id = id;
              var link = document.createElement('a');
              link.href = '#'+id; link.textContent = sec.textContent;
              toc.appendChild(link);
              var back = document.createElement('a');
              back.href='#top'; back.className='back-to-top'; back.textContent='↑ Back to Top';
              sec.parentNode.insertBefore(back, sec.nextSibling);
            }
          };
        </script>
      </head>
      <body id="top">
        <h1><xsl:value-of select="hl7:title"/></h1>
        <div id="toc"><strong>Table of Contents:</strong></div>

        <!-- Demographics -->
        <h2>Patient Demographics</h2>
        <table>
          <tr><th>Name</th>
            <td>
              <xsl:for-each select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name">
                <xsl:value-of select="hl7:given"/> <xsl:value-of select="hl7:family"/><br/>
              </xsl:for-each>
            </td>
          </tr>
          <tr><th>Gender</th>
            <td><xsl:value-of select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode/@displayName"/></td>
          </tr>
          <tr><th>Date of Birth</th>
            <td><xsl:value-of select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthTime/@value"/></td>
          </tr>
          <tr><th>Address</th>
            <td>
              <xsl:for-each select="hl7:recordTarget/hl7:patientRole/hl7:addr">
                <xsl:value-of select="hl7:streetAddressLine"/>,
                <xsl:value-of select="hl7:city"/>,
                <xsl:value-of select="hl7:state"/>
                <xsl:value-of select="hl7:postalCode"/><br/>
              </xsl:for-each>
            </td>
          </tr>
        </table>

        <!-- Author & Responsible Party -->
        <h2>Author & Responsible Party</h2>
        <table>
          <tr><th>Author</th>
            <td><xsl:value-of select="hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:given"/> <xsl:value-of select="hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:family"/></td>
          </tr>
          <tr><th>Organization</th>
            <td><xsl:value-of select="hl7:author/hl7:assignedAuthor/hl7:representedOrganization/hl7:name"/></td>
          </tr>
        </table>

        <!-- Section Mapping -->
        <xsl:variable name="sectionMap">
          <map>
            <entry code="10164-2" title="History of Present Illness"/>
            <entry code="11369-6" title="Immunizations"/>
            <entry code="29549-3" title="Medications Administered"/>
            <entry code="18776-5" title="Plan of Care"/>
            <entry code="11450-4" title="Problems"/>
          </map>
        </xsl:variable>

        <!-- Render Sections -->
        <xsl:for-each select="hl7:component/hl7:structuredBody/hl7:component/hl7:section">
          <xsl:variable name="code" select="hl7:code/@code"/>
          <xsl:variable name="linkedTitle" select="$sectionMap/map/entry[@code=$code]/@title"/>
          <xsl:variable name="title">
            <xsl:choose>
              <xsl:when test="string-length($linkedTitle) &gt; 0"><xsl:value-of select="$linkedTitle"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="hl7:title"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <h2><xsl:value-of select="$title"/></h2>

          <xsl:choose>
            <!-- Narrative HTML table if exists -->
            <xsl:when test="hl7:text/hl7:table">
              <xsl:copy-of select="hl7:text/hl7:table"/>
            </xsl:when>
            <!-- Immunizations -->
            <xsl:when test="$code='11369-6'">
              <table>
                <tr><th>Vaccine</th><th>Date</th><th>Status</th></tr>
                <xsl:for-each select="hl7:entry/hl7:substanceAdministration">
                  <tr>
                    <td><xsl:value-of select="hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/@displayName"/></td>
                    <td><xsl:value-of select="hl7:effectiveTime/@value"/></td>
                    <td><xsl:value-of select="hl7:statusCode/@code"/></td>
                  </tr>
                </xsl:for-each>
              </table>
            </xsl:when>
            <!-- Medications -->
            <xsl:when test="$code='29549-3'">
              <table>
                <tr><th>Medication</th><th>Dose</th><th>Route</th><th>Date</th></tr>
                <xsl:for-each select="hl7:entry/hl7:substanceAdministration">
                  <tr>
                    <td><xsl:value-of select="hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/@displayName"/></td>
                    <td><xsl:value-of select="hl7:doseQuantity/@value"/></td>
                    <td><xsl:value-of select="hl7:routeCode/@displayName"/></td>
                    <td><xsl:value-of select="hl7:effectiveTime/@value"/></td>
                  </tr>
                </xsl:for-each>
              </table>
            </xsl:when>
            <!-- Problems -->
            <xsl:when test="$code='11450-4'">
              <table>
                <tr><th>Condition</th><th>Status</th><th>ICD-10 Code</th><th>Onset</th></tr>
                <xsl:for-each select="hl7:entry/hl7:observation">
                  <tr>
                    <td><xsl:value-of select="hl7:code/@displayName"/></td>
                    <td><xsl:value-of select="hl7:value/@displayName"/></td>
                    <td><xsl:value-of select="hl7:value/@code"/></td>
                    <td><xsl:value-of select="hl7:effectiveTime/hl7:low/@value"/></td>
                  </tr>
                </xsl:for-each>
              </table>
            </xsl:when>
            <!-- Fallback narrative -->
            <xsl:otherwise>
              <div><xsl:copy-of select="hl7:text/node()"/></div>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>

      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>

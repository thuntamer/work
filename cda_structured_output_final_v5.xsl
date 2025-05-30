<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="urn:hl7-org:v3"
  exclude-result-prefixes="xsl">

  <xsl:output method="html" indent="yes"/>

  <!-- Title -->
  <xsl:template match="/ClinicalDocument">
    <html>
      <head>
        <title><xsl:value-of select="title"/></title>
        <style>
          body { font-family: Arial, sans-serif; margin: 20px; }
          table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
          th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
          th { background-color: #f0f0f0; }
          h1 { margin-bottom: 10px; }
          h2 { margin-top: 30px; color: #003366; }
          #toc { background-color: #f9f9f9; padding: 10px; margin-bottom: 20px; border-left: 4px solid #0078D4; }
          #toc a { display: block; margin: 4px 0; text-decoration: none; color: #0078D4; font-weight: bold; }
          .back-to-top { display: block; font-size: 0.8em; text-align: right; margin-bottom: 10px; }
          @media print { button, .back-to-top, #toc { display: none; } }
        </style>
        <script>
        window.onload = function () {
          const toc = document.getElementById('toc');
          document.querySelectorAll('h2').forEach((section, index) => {
            const id = 'section-' + index;
            section.setAttribute('id', id);
            const link = document.createElement('a');
            link.href = '#' + id;
            link.textContent = section.textContent;
            toc.appendChild(link);
            const back = document.createElement('a');
            back.href = '#top';
            back.className = 'back-to-top';
            back.textContent = '↑ Back to Top';
            section.insertAdjacentElement('afterend', back);
          });
        }
        </script>
      </head>
      <body id="top">
        <h1><xsl:value-of select="title"/></h1>
        <div id="toc"><strong>Table of Contents:</strong></div>

        <!-- Patient Demographics -->
        <h2>Patient Demographics</h2>
        <table>
          <tr><th>Name</th><td>
            <xsl:for-each select="recordTarget/patientRole/patient/name">
              <xsl:value-of select="given"/> <xsl:value-of select="family"/><br/>
            </xsl:for-each>
          </td></tr>
          <tr><th>Gender</th><td><xsl:value-of select="recordTarget/patientRole/patient/administrativeGenderCode/@displayName"/></td></tr>
          <tr><th>Date of Birth</th><td><xsl:value-of select="recordTarget/patientRole/patient/birthTime/@value"/></td></tr>
          <tr><th>Address</th><td>
            <xsl:for-each select="recordTarget/patientRole/addr">
              <xsl:value-of select="streetAddressLine"/>, <xsl:value-of select="city"/>, <xsl:value-of select="state"/> <xsl:value-of select="postalCode"/><br/>
            </xsl:for-each>
          </td></tr>
        </table>

        <!-- Author and Custodian -->
        <h2>Author &amp; Responsible Party</h2>
        <table>
          <tr><th>Author</th><td>
            <xsl:for-each select="author/assignedAuthor/assignedPerson/name">
              <xsl:value-of select="given"/> <xsl:value-of select="family"/>
            </xsl:for-each>
          </td></tr>
          <tr><th>Organization</th><td><xsl:value-of select="author/assignedAuthor/representedOrganization/name"/></td></tr>
          <tr><th>Custodian</th><td><xsl:value-of select="custodian/assignedCustodian/representedCustodianOrganization/name"/></td></tr>
        </table>

        <!-- Section Rendering with Mapping Dictionary, Narrative Table First, and Fallback -->
        <xsl:variable name="sectionMap">
          <map>
            <entry code="10164-2" title="History of Present Illness"/>
            <entry code="11369-6" title="Immunizations"/>
            <entry code="29549-3" title="Medications Administered"/>
            <entry code="18776-5" title="Plan of Care"/>
            <entry code="11450-4" title="Problems"/>
          </map>
        </xsl:variable>

        <xsl:for-each select="component/structuredBody/component/section">
          <xsl:variable name="sectionCode" select="code/@code"/>
          <xsl:variable name="sectionTitle" select="title"/>
          <xsl:variable name="mappedTitle" select="$sectionMap/map/entry[@code=$sectionCode]/@title"/>
          <xsl:variable name="displayTitle">
            <xsl:choose>
              <xsl:when test="string-length($mappedTitle) &gt; 0">
                <xsl:value-of select="$mappedTitle"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$sectionTitle"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <h2><xsl:value-of select="$displayTitle"/></h2>

          <xsl:choose>
            <!-- 1) Narrative HTML table -->
            <xsl:when test="text//table">
              <xsl:copy-of select="text//table"/>
            </xsl:when>

            <!-- 2) Immunizations -->
            <xsl:when test="$sectionCode = '11369-6'">
              <table>
                <tr><th>Vaccine</th><th>Date</th><th>Status</th></tr>
                <xsl:for-each select="entry/substanceAdministration">
                  <tr>
                    <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
                    <td><xsl:value-of select="effectiveTime/@value"/></td>
                    <td><xsl:value-of select="statusCode/@code"/></td>
                  </tr>
                </xsl:for-each>
              </table>
            </xsl:when>

            <!-- 3) Medications Administered -->
            <xsl:when test="$sectionCode = '29549-3'">
              <table>
                <tr><th>Medication</th><th>Dose</th><th>Route</th><th>Date</th></tr>
                <xsl:for-each select="entry/substanceAdministration">
                  <tr>
                    <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
                    <td><xsl:value-of select="doseQuantity/@value"/></td>
                    <td><xsl:value-of select="routeCode/@displayName"/></td>
                    <td><xsl:value-of select="effectiveTime/@value"/></td>
                  </tr>
                </xsl:for-each>
              </table>
            </xsl:when>

            <!-- 4) Problems -->
            <xsl:when test="$sectionCode = '11450-4'">
              <table>
                <tr><th>Condition</th><th>Status</th><th>ICD-10 Code</th><th>Onset Date</th></tr>
                <xsl:for-each select="entry/observation">
                  <tr>
                    <td><xsl:value-of select="code/@displayName"/></td>
                    <td><xsl:value-of select="value/@displayName"/></td>
                    <td><xsl:value-of select="value/@code"/></td>
                    <td><xsl:value-of select="effectiveTime/low/@value"/></td>
                  </tr>
                </xsl:for-each>
              </table>
            </xsl:when>

            <!-- 5) Fallback: raw narrative -->
            <xsl:otherwise>
              <div class="narrative">
                <xsl:copy-of select="text/node()"/>
              </div>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>

      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>


<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="urn:hl7-org:v3"
  exclude-result-prefixes="xsl">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="/ClinicalDocument">
    <html>
      <head>
        <title><xsl:value-of select="title"/></title>
        <style>#toc { margin-bottom: 2em; }</style>

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
@media print {
  button, .back-to-top, #toc { display: none; }
}
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
<style>
          body { font-family: Arial, sans-serif; margin: 20px; }
          table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
          th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
          th { background-color: #f0f0f0; }
          h2 { margin-top: 30px; color: #003366; }
        </style>
      </head>
      <body>
        <h1><xsl:value-of select="title"/></h1>

        <!-- Patient Demographics -->
        <h2>Patient Demographics</h2>
        <table>
          <tr><th>Name</th><td>
            <xsl:for-each select="recordTarget/patientRole/patient/name">
              <xsl:value-of select="given"/> <xsl:value-of select="family"/><br/>
            </xsl:for-each>
          </td></tr>
          <tr><th>Gender</th><td><xsl:value-of select="recordTarget/patientRole/patient/administrativeGenderCode/@displayName"/></td></tr>
          <tr><th>DOB</th><td><xsl:value-of select="recordTarget/patientRole/patient/birthTime/@value"/></td></tr>
          <tr><th>Race</th><td><xsl:value-of select="recordTarget/patientRole/patient/raceCode/@displayName"/></td></tr>
          <tr><th>Ethnicity</th><td><xsl:value-of select="recordTarget/patientRole/patient/ethnicGroupCode/@displayName"/></td></tr>
        </table>

        <!-- Author Info -->
        <h2>Author(s)</h2>
        <xsl:for-each select="author">
          <table>
            <tr><th>Name</th>
              <td><xsl:value-of select="assignedAuthor/assignedPerson/name/given"/> <xsl:value-of select="assignedAuthor/assignedPerson/name/family"/></td>
            </tr>
            <tr><th>Organization</th><td><xsl:value-of select="assignedAuthor/representedOrganization/name"/></td></tr>
          </table>
        </xsl:for-each>

        <!-- Lab Results -->
        <h2>Lab Results</h2>
        
<!-- Dynamically rendered sections based on code -->

<!-- Section Rendering with Mapping Dictionary and Fallback -->
<xsl:variable name="sectionMap">
  <map>
    <entry code="10164-2" title="History of Present Illness"/>
    <entry code="11369-6" title="Immunizations"/>
    <entry code="29549-3" title="Medications Administered"/>
    <entry code="18776-5" title="Plan of Care"/>
    <entry code="11450-4" title="Problems"/>
  </map>
</xsl:variable>

<!-- Render all sections using dynamic logic -->
<xsl:for-each select="component/structuredBody/component/section">
  <xsl:variable name="sectionCode" select="code/@code"/>
  <xsl:variable name="sectionTitle" select="title"/>
  <xsl:variable name="matchedTitle" select="$sectionMap/map/entry[@code=$sectionCode]/@title"/>
  <xsl:variable name="displayTitle">
    <xsl:choose>
      <xsl:when test="string-length($matchedTitle) &gt; 0">
        <xsl:value-of select="$matchedTitle"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$sectionTitle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <h2><xsl:value-of select="$displayTitle"/></h2>

  <!-- Known patterns -->
  <xsl:choose>
    <!-- Immunizations -->
    <xsl:when test="$sectionCode = '11369-6'">
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Vaccine</th><th>Date</th><th>Status</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
            <td><xsl:value-of select="statusCode/@code"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Medications Administered -->
    <xsl:when test="$sectionCode = '29549-3'">
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Medication</th><th>Dose</th><th>Route</th><th>Date</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="doseQuantity/@value"/></td>
            <td><xsl:value-of select="routeCode/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Problems -->
    <xsl:when test="$sectionCode = '11450-4'">
      <xsl:for-each select="entry/observation">
        <table>
          <tr><th>Condition</th><th>Status</th><th>ICD-10 Code</th><th>Onset Date</th></tr>
          <tr>
            <td><xsl:value-of select="code/@displayName"/></td>
            <td><xsl:value-of select="value/@displayName"/></td>
            <td><xsl:value-of select="value/@code"/></td>
            <td><xsl:value-of select="effectiveTime/low/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Generic fallback: show raw text if no structured match -->
    <xsl:otherwise>
      <div>
        <xsl:copy-of select="text()"/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:for-each>

    </xsl:when>

    <!-- Medications Administered -->
    <xsl:when test="$sectionCode = '29549-3'">
      <h2>Medications Administered</h2>
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Medication</th><th>Dose</th><th>Route</th><th>Date</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="doseQuantity/@value"/></td>
            <td><xsl:value-of select="routeCode/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Plan of Care -->
    <xsl:when test="$sectionCode = '18776-5'">
      <h2>Plan of Care</h2>
      <div><xsl:value-of select="text"/></div>
    </xsl:when>

    <!-- Problems -->
    <xsl:when test="$sectionCode = '11450-4'">
      <h2>Problems</h2>
      <xsl:for-each select="entry/observation">
        <table>
          <tr><th>Condition</th><th>Status</th><th>ICD-10 Code</th><th>Onset Date</th></tr>
          <tr>
            <td><xsl:value-of select="code/@displayName"/></td>
            <td><xsl:value-of select="value/@displayName"/></td>
            <td><xsl:value-of select="value/@code"/></td>
            <td><xsl:value-of select="effectiveTime/low/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>
  </xsl:choose>
</xsl:for-each>

          </table>
        </xsl:for-each>

        <!-- Medications -->
        <h2>Medications</h2>
        
<!-- Dynamically rendered sections based on code -->

<!-- Section Rendering with Mapping Dictionary and Fallback -->
<xsl:variable name="sectionMap">
  <map>
    <entry code="10164-2" title="History of Present Illness"/>
    <entry code="11369-6" title="Immunizations"/>
    <entry code="29549-3" title="Medications Administered"/>
    <entry code="18776-5" title="Plan of Care"/>
    <entry code="11450-4" title="Problems"/>
  </map>
</xsl:variable>

<!-- Render all sections using dynamic logic -->
<xsl:for-each select="component/structuredBody/component/section">
  <xsl:variable name="sectionCode" select="code/@code"/>
  <xsl:variable name="sectionTitle" select="title"/>
  <xsl:variable name="matchedTitle" select="$sectionMap/map/entry[@code=$sectionCode]/@title"/>
  <xsl:variable name="displayTitle">
    <xsl:choose>
      <xsl:when test="string-length($matchedTitle) &gt; 0">
        <xsl:value-of select="$matchedTitle"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$sectionTitle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <h2><xsl:value-of select="$displayTitle"/></h2>

  <!-- Known patterns -->
  <xsl:choose>
    <!-- Immunizations -->
    <xsl:when test="$sectionCode = '11369-6'">
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Vaccine</th><th>Date</th><th>Status</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
            <td><xsl:value-of select="statusCode/@code"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Medications Administered -->
    <xsl:when test="$sectionCode = '29549-3'">
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Medication</th><th>Dose</th><th>Route</th><th>Date</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="doseQuantity/@value"/></td>
            <td><xsl:value-of select="routeCode/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Problems -->
    <xsl:when test="$sectionCode = '11450-4'">
      <xsl:for-each select="entry/observation">
        <table>
          <tr><th>Condition</th><th>Status</th><th>ICD-10 Code</th><th>Onset Date</th></tr>
          <tr>
            <td><xsl:value-of select="code/@displayName"/></td>
            <td><xsl:value-of select="value/@displayName"/></td>
            <td><xsl:value-of select="value/@code"/></td>
            <td><xsl:value-of select="effectiveTime/low/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Generic fallback: show raw text if no structured match -->
    <xsl:otherwise>
      <div>
        <xsl:copy-of select="text()"/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:for-each>

    </xsl:when>

    <!-- Medications Administered -->
    <xsl:when test="$sectionCode = '29549-3'">
      <h2>Medications Administered</h2>
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Medication</th><th>Dose</th><th>Route</th><th>Date</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="doseQuantity/@value"/></td>
            <td><xsl:value-of select="routeCode/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Plan of Care -->
    <xsl:when test="$sectionCode = '18776-5'">
      <h2>Plan of Care</h2>
      <div><xsl:value-of select="text"/></div>
    </xsl:when>

    <!-- Problems -->
    <xsl:when test="$sectionCode = '11450-4'">
      <h2>Problems</h2>
      <xsl:for-each select="entry/observation">
        <table>
          <tr><th>Condition</th><th>Status</th><th>ICD-10 Code</th><th>Onset Date</th></tr>
          <tr>
            <td><xsl:value-of select="code/@displayName"/></td>
            <td><xsl:value-of select="value/@displayName"/></td>
            <td><xsl:value-of select="value/@code"/></td>
            <td><xsl:value-of select="effectiveTime/low/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>
  </xsl:choose>
</xsl:for-each>

          </table>
        </xsl:for-each>

        <!-- Problems/Diagnoses -->
        <h2>Problems / Diagnoses</h2>
        
<!-- Dynamically rendered sections based on code -->

<!-- Section Rendering with Mapping Dictionary and Fallback -->
<xsl:variable name="sectionMap">
  <map>
    <entry code="10164-2" title="History of Present Illness"/>
    <entry code="11369-6" title="Immunizations"/>
    <entry code="29549-3" title="Medications Administered"/>
    <entry code="18776-5" title="Plan of Care"/>
    <entry code="11450-4" title="Problems"/>
  </map>
</xsl:variable>

<!-- Render all sections using dynamic logic -->
<xsl:for-each select="component/structuredBody/component/section">
  <xsl:variable name="sectionCode" select="code/@code"/>
  <xsl:variable name="sectionTitle" select="title"/>
  <xsl:variable name="matchedTitle" select="$sectionMap/map/entry[@code=$sectionCode]/@title"/>
  <xsl:variable name="displayTitle">
    <xsl:choose>
      <xsl:when test="string-length($matchedTitle) &gt; 0">
        <xsl:value-of select="$matchedTitle"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$sectionTitle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <h2><xsl:value-of select="$displayTitle"/></h2>

  <!-- Known patterns -->
  <xsl:choose>
    <!-- Immunizations -->
    <xsl:when test="$sectionCode = '11369-6'">
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Vaccine</th><th>Date</th><th>Status</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
            <td><xsl:value-of select="statusCode/@code"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Medications Administered -->
    <xsl:when test="$sectionCode = '29549-3'">
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Medication</th><th>Dose</th><th>Route</th><th>Date</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="doseQuantity/@value"/></td>
            <td><xsl:value-of select="routeCode/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Problems -->
    <xsl:when test="$sectionCode = '11450-4'">
      <xsl:for-each select="entry/observation">
        <table>
          <tr><th>Condition</th><th>Status</th><th>ICD-10 Code</th><th>Onset Date</th></tr>
          <tr>
            <td><xsl:value-of select="code/@displayName"/></td>
            <td><xsl:value-of select="value/@displayName"/></td>
            <td><xsl:value-of select="value/@code"/></td>
            <td><xsl:value-of select="effectiveTime/low/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Generic fallback: show raw text if no structured match -->
    <xsl:otherwise>
      <div>
        <xsl:copy-of select="text()"/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:for-each>

    </xsl:when>

    <!-- Medications Administered -->
    <xsl:when test="$sectionCode = '29549-3'">
      <h2>Medications Administered</h2>
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Medication</th><th>Dose</th><th>Route</th><th>Date</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="doseQuantity/@value"/></td>
            <td><xsl:value-of select="routeCode/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Plan of Care -->
    <xsl:when test="$sectionCode = '18776-5'">
      <h2>Plan of Care</h2>
      <div><xsl:value-of select="text"/></div>
    </xsl:when>

    <!-- Problems -->
    <xsl:when test="$sectionCode = '11450-4'">
      <h2>Problems</h2>
      <xsl:for-each select="entry/observation">
        <table>
          <tr><th>Condition</th><th>Status</th><th>ICD-10 Code</th><th>Onset Date</th></tr>
          <tr>
            <td><xsl:value-of select="code/@displayName"/></td>
            <td><xsl:value-of select="value/@displayName"/></td>
            <td><xsl:value-of select="value/@code"/></td>
            <td><xsl:value-of select="effectiveTime/low/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>
  </xsl:choose>
</xsl:for-each>

          </table>
        </xsl:for-each>

        <!-- Social History -->
        <h2>Social History</h2>
        
<!-- Dynamically rendered sections based on code -->

<!-- Section Rendering with Mapping Dictionary and Fallback -->
<xsl:variable name="sectionMap">
  <map>
    <entry code="10164-2" title="History of Present Illness"/>
    <entry code="11369-6" title="Immunizations"/>
    <entry code="29549-3" title="Medications Administered"/>
    <entry code="18776-5" title="Plan of Care"/>
    <entry code="11450-4" title="Problems"/>
  </map>
</xsl:variable>

<!-- Render all sections using dynamic logic -->
<xsl:for-each select="component/structuredBody/component/section">
  <xsl:variable name="sectionCode" select="code/@code"/>
  <xsl:variable name="sectionTitle" select="title"/>
  <xsl:variable name="matchedTitle" select="$sectionMap/map/entry[@code=$sectionCode]/@title"/>
  <xsl:variable name="displayTitle">
    <xsl:choose>
      <xsl:when test="string-length($matchedTitle) &gt; 0">
        <xsl:value-of select="$matchedTitle"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$sectionTitle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <h2><xsl:value-of select="$displayTitle"/></h2>

  <!-- Known patterns -->
  <xsl:choose>
    <!-- Immunizations -->
    <xsl:when test="$sectionCode = '11369-6'">
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Vaccine</th><th>Date</th><th>Status</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
            <td><xsl:value-of select="statusCode/@code"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Medications Administered -->
    <xsl:when test="$sectionCode = '29549-3'">
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Medication</th><th>Dose</th><th>Route</th><th>Date</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="doseQuantity/@value"/></td>
            <td><xsl:value-of select="routeCode/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Problems -->
    <xsl:when test="$sectionCode = '11450-4'">
      <xsl:for-each select="entry/observation">
        <table>
          <tr><th>Condition</th><th>Status</th><th>ICD-10 Code</th><th>Onset Date</th></tr>
          <tr>
            <td><xsl:value-of select="code/@displayName"/></td>
            <td><xsl:value-of select="value/@displayName"/></td>
            <td><xsl:value-of select="value/@code"/></td>
            <td><xsl:value-of select="effectiveTime/low/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Generic fallback: show raw text if no structured match -->
    <xsl:otherwise>
      <div>
        <xsl:copy-of select="text()"/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:for-each>

    </xsl:when>

    <!-- Medications Administered -->
    <xsl:when test="$sectionCode = '29549-3'">
      <h2>Medications Administered</h2>
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Medication</th><th>Dose</th><th>Route</th><th>Date</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="doseQuantity/@value"/></td>
            <td><xsl:value-of select="routeCode/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Plan of Care -->
    <xsl:when test="$sectionCode = '18776-5'">
      <h2>Plan of Care</h2>
      <div><xsl:value-of select="text"/></div>
    </xsl:when>

    <!-- Problems -->
    <xsl:when test="$sectionCode = '11450-4'">
      <h2>Problems</h2>
      <xsl:for-each select="entry/observation">
        <table>
          <tr><th>Condition</th><th>Status</th><th>ICD-10 Code</th><th>Onset Date</th></tr>
          <tr>
            <td><xsl:value-of select="code/@displayName"/></td>
            <td><xsl:value-of select="value/@displayName"/></td>
            <td><xsl:value-of select="value/@code"/></td>
            <td><xsl:value-of select="effectiveTime/low/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>
  </xsl:choose>
</xsl:for-each>

          </table>
        </xsl:for-each>

      
        <!-- Allergies -->
        <h2>Allergies</h2>
        
<!-- Dynamically rendered sections based on code -->

<!-- Section Rendering with Mapping Dictionary and Fallback -->
<xsl:variable name="sectionMap">
  <map>
    <entry code="10164-2" title="History of Present Illness"/>
    <entry code="11369-6" title="Immunizations"/>
    <entry code="29549-3" title="Medications Administered"/>
    <entry code="18776-5" title="Plan of Care"/>
    <entry code="11450-4" title="Problems"/>
  </map>
</xsl:variable>

<!-- Render all sections using dynamic logic -->
<xsl:for-each select="component/structuredBody/component/section">
  <xsl:variable name="sectionCode" select="code/@code"/>
  <xsl:variable name="sectionTitle" select="title"/>
  <xsl:variable name="matchedTitle" select="$sectionMap/map/entry[@code=$sectionCode]/@title"/>
  <xsl:variable name="displayTitle">
    <xsl:choose>
      <xsl:when test="string-length($matchedTitle) &gt; 0">
        <xsl:value-of select="$matchedTitle"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$sectionTitle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <h2><xsl:value-of select="$displayTitle"/></h2>

  <!-- Known patterns -->
  <xsl:choose>
    <!-- Immunizations -->
    <xsl:when test="$sectionCode = '11369-6'">
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Vaccine</th><th>Date</th><th>Status</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
            <td><xsl:value-of select="statusCode/@code"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Medications Administered -->
    <xsl:when test="$sectionCode = '29549-3'">
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Medication</th><th>Dose</th><th>Route</th><th>Date</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="doseQuantity/@value"/></td>
            <td><xsl:value-of select="routeCode/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Problems -->
    <xsl:when test="$sectionCode = '11450-4'">
      <xsl:for-each select="entry/observation">
        <table>
          <tr><th>Condition</th><th>Status</th><th>ICD-10 Code</th><th>Onset Date</th></tr>
          <tr>
            <td><xsl:value-of select="code/@displayName"/></td>
            <td><xsl:value-of select="value/@displayName"/></td>
            <td><xsl:value-of select="value/@code"/></td>
            <td><xsl:value-of select="effectiveTime/low/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Generic fallback: show raw text if no structured match -->
    <xsl:otherwise>
      <div>
        <xsl:copy-of select="text()"/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:for-each>

    </xsl:when>

    <!-- Medications Administered -->
    <xsl:when test="$sectionCode = '29549-3'">
      <h2>Medications Administered</h2>
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Medication</th><th>Dose</th><th>Route</th><th>Date</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="doseQuantity/@value"/></td>
            <td><xsl:value-of select="routeCode/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Plan of Care -->
    <xsl:when test="$sectionCode = '18776-5'">
      <h2>Plan of Care</h2>
      <div><xsl:value-of select="text"/></div>
    </xsl:when>

    <!-- Problems -->
    <xsl:when test="$sectionCode = '11450-4'">
      <h2>Problems</h2>
      <xsl:for-each select="entry/observation">
        <table>
          <tr><th>Condition</th><th>Status</th><th>ICD-10 Code</th><th>Onset Date</th></tr>
          <tr>
            <td><xsl:value-of select="code/@displayName"/></td>
            <td><xsl:value-of select="value/@displayName"/></td>
            <td><xsl:value-of select="value/@code"/></td>
            <td><xsl:value-of select="effectiveTime/low/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>
  </xsl:choose>
</xsl:for-each>

          </table>
        </xsl:for-each>

        <!-- Procedures -->
        <h2>Procedures</h2>
        
<!-- Dynamically rendered sections based on code -->

<!-- Section Rendering with Mapping Dictionary and Fallback -->
<xsl:variable name="sectionMap">
  <map>
    <entry code="10164-2" title="History of Present Illness"/>
    <entry code="11369-6" title="Immunizations"/>
    <entry code="29549-3" title="Medications Administered"/>
    <entry code="18776-5" title="Plan of Care"/>
    <entry code="11450-4" title="Problems"/>
  </map>
</xsl:variable>

<!-- Render all sections using dynamic logic -->
<xsl:for-each select="component/structuredBody/component/section">
  <xsl:variable name="sectionCode" select="code/@code"/>
  <xsl:variable name="sectionTitle" select="title"/>
  <xsl:variable name="matchedTitle" select="$sectionMap/map/entry[@code=$sectionCode]/@title"/>
  <xsl:variable name="displayTitle">
    <xsl:choose>
      <xsl:when test="string-length($matchedTitle) &gt; 0">
        <xsl:value-of select="$matchedTitle"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$sectionTitle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <h2><xsl:value-of select="$displayTitle"/></h2>

  <!-- Known patterns -->
  <xsl:choose>
    <!-- Immunizations -->
    <xsl:when test="$sectionCode = '11369-6'">
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Vaccine</th><th>Date</th><th>Status</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
            <td><xsl:value-of select="statusCode/@code"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Medications Administered -->
    <xsl:when test="$sectionCode = '29549-3'">
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Medication</th><th>Dose</th><th>Route</th><th>Date</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="doseQuantity/@value"/></td>
            <td><xsl:value-of select="routeCode/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Problems -->
    <xsl:when test="$sectionCode = '11450-4'">
      <xsl:for-each select="entry/observation">
        <table>
          <tr><th>Condition</th><th>Status</th><th>ICD-10 Code</th><th>Onset Date</th></tr>
          <tr>
            <td><xsl:value-of select="code/@displayName"/></td>
            <td><xsl:value-of select="value/@displayName"/></td>
            <td><xsl:value-of select="value/@code"/></td>
            <td><xsl:value-of select="effectiveTime/low/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Generic fallback: show raw text if no structured match -->
    <xsl:otherwise>
      <div>
        <xsl:copy-of select="text()"/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:for-each>

    </xsl:when>

    <!-- Medications Administered -->
    <xsl:when test="$sectionCode = '29549-3'">
      <h2>Medications Administered</h2>
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Medication</th><th>Dose</th><th>Route</th><th>Date</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="doseQuantity/@value"/></td>
            <td><xsl:value-of select="routeCode/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Plan of Care -->
    <xsl:when test="$sectionCode = '18776-5'">
      <h2>Plan of Care</h2>
      <div><xsl:value-of select="text"/></div>
    </xsl:when>

    <!-- Problems -->
    <xsl:when test="$sectionCode = '11450-4'">
      <h2>Problems</h2>
      <xsl:for-each select="entry/observation">
        <table>
          <tr><th>Condition</th><th>Status</th><th>ICD-10 Code</th><th>Onset Date</th></tr>
          <tr>
            <td><xsl:value-of select="code/@displayName"/></td>
            <td><xsl:value-of select="value/@displayName"/></td>
            <td><xsl:value-of select="value/@code"/></td>
            <td><xsl:value-of select="effectiveTime/low/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>
  </xsl:choose>
</xsl:for-each>

          </table>
        </xsl:for-each>

        <!-- Vital Signs -->
        <h2>Vital Signs</h2>
        
<!-- Dynamically rendered sections based on code -->

<!-- Section Rendering with Mapping Dictionary and Fallback -->
<xsl:variable name="sectionMap">
  <map>
    <entry code="10164-2" title="History of Present Illness"/>
    <entry code="11369-6" title="Immunizations"/>
    <entry code="29549-3" title="Medications Administered"/>
    <entry code="18776-5" title="Plan of Care"/>
    <entry code="11450-4" title="Problems"/>
  </map>
</xsl:variable>

<!-- Render all sections using dynamic logic -->
<xsl:for-each select="component/structuredBody/component/section">
  <xsl:variable name="sectionCode" select="code/@code"/>
  <xsl:variable name="sectionTitle" select="title"/>
  <xsl:variable name="matchedTitle" select="$sectionMap/map/entry[@code=$sectionCode]/@title"/>
  <xsl:variable name="displayTitle">
    <xsl:choose>
      <xsl:when test="string-length($matchedTitle) &gt; 0">
        <xsl:value-of select="$matchedTitle"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$sectionTitle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <h2><xsl:value-of select="$displayTitle"/></h2>

  <!-- Known patterns -->
  <xsl:choose>
    <!-- Immunizations -->
    <xsl:when test="$sectionCode = '11369-6'">
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Vaccine</th><th>Date</th><th>Status</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
            <td><xsl:value-of select="statusCode/@code"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Medications Administered -->
    <xsl:when test="$sectionCode = '29549-3'">
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Medication</th><th>Dose</th><th>Route</th><th>Date</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="doseQuantity/@value"/></td>
            <td><xsl:value-of select="routeCode/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Problems -->
    <xsl:when test="$sectionCode = '11450-4'">
      <xsl:for-each select="entry/observation">
        <table>
          <tr><th>Condition</th><th>Status</th><th>ICD-10 Code</th><th>Onset Date</th></tr>
          <tr>
            <td><xsl:value-of select="code/@displayName"/></td>
            <td><xsl:value-of select="value/@displayName"/></td>
            <td><xsl:value-of select="value/@code"/></td>
            <td><xsl:value-of select="effectiveTime/low/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Generic fallback: show raw text if no structured match -->
    <xsl:otherwise>
      <div>
        <xsl:copy-of select="text()"/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:for-each>

    </xsl:when>

    <!-- Medications Administered -->
    <xsl:when test="$sectionCode = '29549-3'">
      <h2>Medications Administered</h2>
      <xsl:for-each select="entry/substanceAdministration">
        <table>
          <tr><th>Medication</th><th>Dose</th><th>Route</th><th>Date</th></tr>
          <tr>
            <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/></td>
            <td><xsl:value-of select="doseQuantity/@value"/></td>
            <td><xsl:value-of select="routeCode/@displayName"/></td>
            <td><xsl:value-of select="effectiveTime/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>

    <!-- Plan of Care -->
    <xsl:when test="$sectionCode = '18776-5'">
      <h2>Plan of Care</h2>
      <div><xsl:value-of select="text"/></div>
    </xsl:when>

    <!-- Problems -->
    <xsl:when test="$sectionCode = '11450-4'">
      <h2>Problems</h2>
      <xsl:for-each select="entry/observation">
        <table>
          <tr><th>Condition</th><th>Status</th><th>ICD-10 Code</th><th>Onset Date</th></tr>
          <tr>
            <td><xsl:value-of select="code/@displayName"/></td>
            <td><xsl:value-of select="value/@displayName"/></td>
            <td><xsl:value-of select="value/@code"/></td>
            <td><xsl:value-of select="effectiveTime/low/@value"/></td>
          </tr>
        </table>
      </xsl:for-each>
    </xsl:when>
  </xsl:choose>
</xsl:for-each>

          </table>
        </xsl:for-each>

</body>
    </html>
  </xsl:template>

  <xsl:template name="formatDate">
    <xsl:param name="date"/>
    <xsl:choose>
      <xsl:when test="string-length($date) = 8">
        <xsl:value-of select="concat(substring($date, 5, 2), '/', substring($date, 7, 2), '/', substring($date, 1, 4))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$date"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

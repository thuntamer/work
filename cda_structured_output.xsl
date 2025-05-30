
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="urn:hl7-org:v3"
  exclude-result-prefixes="xsl">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="/ClinicalDocument">
    <html>
      <head>
        <title><xsl:value-of select="title"/></title>
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
        <xsl:for-each select="component/structuredBody/component/section[code/@code='30954-2']">
          <table>
            <tr><th>Test</th><th>Value</th><th>Unit</th><th>Date</th><th>LOINC Code</th></tr>
            <xsl:for-each select="entry/observation">
              <tr>
                <td><xsl:value-of select="code/@displayName"/></td>
                <td><xsl:value-of select="value/@value"/></td>
                <td><xsl:value-of select="value/@unit"/></td>
                <td><xsl:value-of select="effectiveTime/@value"/></td>
                <td><xsl:value-of select="code/@code"/></td>
              </tr>
            </xsl:for-each>
          </table>
        </xsl:for-each>

        <!-- Medications -->
        <h2>Medications</h2>
        <xsl:for-each select="component/structuredBody/component/section[code/@code='10160-0']">
          <table>
            <tr><th>Medication</th><th>Dose</th><th>Route</th><th>Frequency</th><th>RxNorm Code</th></tr>
            <xsl:for-each select="entry/substanceAdministration">
              <tr>
                <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/originalText"/></td>
                <td><xsl:value-of select="doseQuantity/@value"/></td>
                <td><xsl:value-of select="routeCode/@displayName"/></td>
                <td><xsl:value-of select="effectiveTime/frequency/@value"/></td>
                <td><xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@code"/></td>
              </tr>
            </xsl:for-each>
          </table>
        </xsl:for-each>

        <!-- Problems/Diagnoses -->
        <h2>Problems / Diagnoses</h2>
        <xsl:for-each select="component/structuredBody/component/section[code/@code='11450-4']">
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
        </xsl:for-each>

        <!-- Social History -->
        <h2>Social History</h2>
        <xsl:for-each select="component/structuredBody/component/section[code/@code='29762-2']">
          <table>
            <tr><th>Type</th><th>Status</th><th>Start</th><th>End</th></tr>
            <xsl:for-each select="entry/observation">
              <tr>
                <td><xsl:value-of select="code/@displayName"/></td>
                <td><xsl:value-of select="value/@displayName"/></td>
                <td><xsl:value-of select="effectiveTime/low/@value"/></td>
                <td><xsl:value-of select="effectiveTime/high/@value"/></td>
              </tr>
            </xsl:for-each>
          </table>
        </xsl:for-each>

      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>

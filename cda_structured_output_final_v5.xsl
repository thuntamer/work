<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:hl7="urn:hl7-org:v3"
    exclude-result-prefixes="hl7">

  <!-- 1) Output HTML -->
  <xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

  <!-- Entry point -->
  <xsl:template match="/hl7:ClinicalDocument">
    <html>
      <head>
        <title>CDA Summary</title>
        <style>
          body { font-family: sans-serif; margin:1em; }
          h1,h2 { color: #2a4d69; }
          table { border-collapse: collapse; width:100%; margin-bottom:1.5em; }
          th, td { border:1px solid #ccc; padding:0.4em; text-align:left; }
          th { background:#e0e0e0; }
          pre { background:#f7f7f7; padding:1em; overflow:auto; }
        </style>
      </head>
      <body>
        <h1>Patient Summary</h1>

        <!-- Demographics -->
        <h2>Patient Demographics</h2>
        <table>
          <tr><th>Field</th><th>Value</th></tr>
          <tr>
            <td>Name</td>
            <td>
              <xsl:for-each select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name">
                <xsl:value-of select="hl7:given"/> <xsl:value-of select="hl7:family"/>
              </xsl:for-each>
            </td>
          </tr>
          <tr>
            <td>Gender</td>
            <td>
              <xsl:value-of select="hl7:recordTarget/hl7:patientRole/hl7:patient/
                                   hl7:administrativeGenderCode/@displayName"/>
            </td>
          </tr>
          <tr>
            <td>Birth Time</td>
            <td>
              <xsl:value-of select="hl7:recordTarget/hl7:patientRole/hl7:patient/
                                   hl7:birthTime/@value"/>
            </td>
          </tr>
          <xsl:for-each select="hl7:recordTarget/hl7:patientRole/hl7:addr">
            <tr>
              <td>Address</td>
              <td>
                <xsl:value-of select="hl7:streetAddressLine"/>,
                <xsl:value-of select="hl7:city"/>,
                <xsl:value-of select="hl7:state"/>
                <xsl:value-of select="hl7:postalCode"/>
              </td>
            </tr>
          </xsl:for-each>
        </table>

        <!-- Immunizations -->
        <h2>Immunizations</h2>
        <table>
          <tr><th>Vaccine</th><th>LOINC</th><th>Date</th><th>Status</th></tr>
          <xsl:for-each select="hl7:component/hl7:structuredBody/
                                hl7:component/hl7:section[hl7:code/@code='11369-6']/
                                hl7:entry/hl7:substanceAdministration">
            <tr>
              <td>
                <xsl:value-of select="hl7:consumable/hl7:manufacturedProduct/
                                     hl7:manufacturedMaterial/hl7:code/@displayName"/>
              </td>
              <td>
                <xsl:value-of select="hl7:consumable/hl7:manufacturedProduct/
                                     hl7:manufacturedMaterial/hl7:code/@code"/>
              </td>
              <td><xsl:value-of select="hl7:effectiveTime/@value"/></td>
              <td><xsl:value-of select="hl7:statusCode/@code"/></td>
            </tr>
          </xsl:for-each>
        </table>

        <!-- Medications -->
        <h2>Medications</h2>
        <table>
          <tr><th>Name</th><th>RxNorm</th><th>Dose</th><th>Route</th><th>Date</th></tr>
          <xsl:for-each select="hl7:component/hl7:structuredBody/
                                hl7:component/hl7:section[hl7:code/@code='29549-3']/
                                hl7:entry/hl7:substanceAdministration">
            <tr>
              <td>
                <xsl:value-of select="hl7:consumable/.../hl7:code/@displayName"/>
              </td>
              <td><xsl:value-of select="hl7:consumable/.../hl7:code/@code"/></td>
              <td><xsl:value-of select="hl7:doseQuantity/@value"/></td>
              <td><xsl:value-of select="hl7:routeCode/@displayName"/></td>
              <td><xsl:value-of select="hl7:effectiveTime/@value"/></td>
            </tr>
          </xsl:for-each>
        </table>

        <!-- Problems -->
        <h2>Problems</h2>
        <table>
          <tr><th>Condition</th><th>ICD-10</th><th>Status</th><th>Onset</th></tr>
          <xsl:for-each select="hl7:component/hl7:structuredBody/
                                hl7:component/hl7:section[hl7:code/@code='11450-4']/
                                hl7:entry/hl7:observation">
            <tr>
              <td><xsl:value-of select="hl7:code/@displayName"/></td>
              <td><xsl:value-of select="hl7:code/@code"/></td>
              <td><xsl:value-of select="hl7:value/@displayName"/></td>
              <td><xsl:value-of select="hl7:effectiveTime/hl7:low/@value"/></td>
            </tr>
          </xsl:for-each>
        </table>

        <!-- Lab Results -->
        <h2>Lab Results</h2>
        <table>
          <tr><th>Test</th><th>LOINC</th><th>Value</th><th>Units</th><th>Date</th></tr>
          <xsl:for-each select="hl7:component/hl7:structuredBody/
                                hl7:component/hl7:section[hl7:code/@code='30954-2']/
                                hl7:entry/hl7:observation">
            <tr>
              <td><xsl:value-of select="hl7:code/@displayName"/></td>
              <td><xsl:value-of select="hl7:code/@code"/></td>
              <td><xsl:value-of select="hl7:value/@value"/></td>
              <td><xsl:value-of select="hl7:value/@unit"/></td>
              <td><xsl:value-of select="hl7:effectiveTime/hl7:low/@value"/></td>
            </tr>
          </xsl:for-each>
        </table>

        <!-- Encounters -->
        <h2>Encounters</h2>
        <table>
          <tr><th>Type</th><th>Date</th><th>Location</th></tr>
          <xsl:for-each select="hl7:component/hl7:structuredBody/
                                hl7:component/hl7:section[hl7:code/@code='46241-6']/
                                hl7:entry/hl7:encounter">
            <tr>
              <td><xsl:value-of select="hl7:code/@displayName"/></td>
              <td><xsl:value-of select="hl7:effectiveTime/@value"/></td>
              <td>
                <xsl:value-of select="hl7:location/hl7:healthCareFacility/
                                     hl7:location/hl7:name"/>
              </td>
            </tr>
          </xsl:for-each>
        </table>

        <!-- 2) XML Summary for QA -->
        <h2>XML Summary (for Data Quality)</h2>
        <pre>
<xsl:text disable-output-escaping="yes">&lt;CDA_Summary&gt;</xsl:text>
  <!-- copy exactly what you see in the HTML tables, but as raw XML -->
  <xsl:for-each select="hl7:recordTarget">
    <xsl:text disable-output-escaping="yes">&#10;  &lt;PatientDemographics&gt;</xsl:text>
      <!-- name, gender, birthTime, addr -->
    <xsl:copy-of select="hl7:patientRole"/>
    <xsl:text disable-output-escaping="yes">&#10;  &lt;/PatientDemographics&gt;</xsl:text>
  </xsl:for-each>
  <!-- immunizations, medications, problems, labs, encounters sections -->
  <!-- you can replicate each block with <xsl:copy-of select="..."/> -->
<xsl:text disable-output-escaping="yes">&#10;&lt;/CDA_Summary&gt;</xsl:text>
        </pre>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>


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
          body {{ font-family: Arial; }}
          table {{ border-collapse: collapse; width: 100%; margin-bottom: 20px; }}
          th, td {{ border: 1px solid #ccc; padding: 8px; }}
          th {{ background-color: #f0f0f0; text-align: left; }}
          h2 {{ background-color: #efefef; padding: 8px; }}
        </style>
      </head>
      <body>
        <h1><xsl:value-of select="title"/></h1>

        <h2>Patient Demographics</h2>
        <table>
          <tbody>
            <tr><th>Name</th><td>
              <xsl:for-each select="recordTarget/patientRole/patient/name">
                <xsl:value-of select="given"/> <xsl:value-of select="family"/><br/>
              </xsl:for-each>
            </td></tr>
            <tr><th>Gender</th><td><xsl:value-of select="recordTarget/patientRole/patient/administrativeGenderCode/@displayName"/></td></tr>
            <tr><th>Date of Birth</th><td><xsl:value-of select="recordTarget/patientRole/patient/birthTime/@value"/></td></tr>
            <tr><th>Race</th><td><xsl:value-of select="recordTarget/patientRole/patient/raceCode/@displayName"/></td></tr>
            <tr><th>Ethnicity</th><td><xsl:value-of select="recordTarget/patientRole/patient/ethnicGroupCode/@displayName"/></td></tr>
            <tr><th>Language</th><td><xsl:value-of select="recordTarget/patientRole/patient/languageCommunication/languageCode/@code"/></td></tr>
            <tr><th>Addresses</th><td>
              <xsl:for-each select="recordTarget/patientRole/addr">
                <xsl:value-of select="streetAddressLine"/>, <xsl:value-of select="city"/>, <xsl:value-of select="state"/> <xsl:value-of select="postalCode"/><br/>
              </xsl:for-each>
            </td></tr>
            <tr><th>Contact</th><td>
              <xsl:for-each select="recordTarget/patientRole/telecom">
                <xsl:value-of select="@value"/><br/>
              </xsl:for-each>
            </td></tr>
          </tbody>
        </table>

        <h2>Author Information</h2>
        <xsl:for-each select="author">
          <table>
            <tbody>
              <tr><th>Author Name</th>
                <td><xsl:value-of select="assignedAuthor/assignedPerson/name/given"/> <xsl:value-of select="assignedAuthor/assignedPerson/name/family"/></td>
              </tr>
              <tr><th>Organization</th><td><xsl:value-of select="assignedAuthor/representedOrganization/name"/></td></tr>
              <tr><th>Phone</th><td><xsl:value-of select="assignedAuthor/telecom/@value"/></td></tr>
            </tbody>
          </table>
        </xsl:for-each>

        <h2>Encounter Information</h2>
        <table>
          <tbody>
            <tr><th>Location</th><td>
              <xsl:value-of select="componentOf/encompassingEncounter/location/healthCareFacility/location/name"/>
            </td></tr>
            <tr><th>Start</th><td><xsl:value-of select="componentOf/encompassingEncounter/effectiveTime/low/@value"/></td></tr>
            <tr><th>End</th><td><xsl:value-of select="componentOf/encompassingEncounter/effectiveTime/high/@value"/></td></tr>
            <tr><th>Responsible Party</th>
              <td>
                <xsl:value-of select="componentOf/encompassingEncounter/responsibleParty/assignedEntity/assignedPerson/name/given"/> 
                <xsl:value-of select="componentOf/encompassingEncounter/responsibleParty/assignedEntity/assignedPerson/name/family"/>
              </td>
            </tr>
          </tbody>
        </table>

        <h2>Immunizations</h2>
        <xsl:copy-of select="component/structuredBody/component/section[code/@code='11369-6']/text/table"/>

        <h2>Lab Results</h2>
        <xsl:for-each select="component/structuredBody/component/section[code/@code='30954-2']">
          
    <xsl:if test="text/table">
      <xsl:copy-of select="text/table"/>
    </xsl:if>
    <xsl:if test="not(text/table)">
      <table>
        <thead>
          <tr>
            <th>Code</th><th>Display</th><th>System</th><th>Value</th><th>Date</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="entry/*">
            <tr>
              <td><xsl:value-of select="code/@code"/></td>
              <td><xsl:value-of select="code/@displayName"/></td>
              <td>
                <xsl:choose>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.88'">RxNorm</xsl:when>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.96'">SNOMED CT</xsl:when>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.1'">LOINC</xsl:when>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.3'">ICD-10</xsl:when>
                  <xsl:otherwise><xsl:value-of select="code/@codeSystem"/></xsl:otherwise>
                </xsl:choose>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="value/@value"><xsl:value-of select="value/@value"/> <xsl:value-of select="value/@unit"/></xsl:when>
                  <xsl:when test="text"><xsl:value-of select="text"/></xsl:when>
                </xsl:choose>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="effectiveTime/@value"><xsl:value-of select="effectiveTime/@value"/></xsl:when>
                  <xsl:when test="effectiveTime/low/@value"><xsl:value-of select="effectiveTime/low/@value"/></xsl:when>
                </xsl:choose>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:if>
    
        </xsl:for-each>

        <h2>Medications</h2>
        <xsl:for-each select="component/structuredBody/component/section[code/@code='10160-0']">
          
    <xsl:if test="text/table">
      <xsl:copy-of select="text/table"/>
    </xsl:if>
    <xsl:if test="not(text/table)">
      <table>
        <thead>
          <tr>
            <th>Code</th><th>Display</th><th>System</th><th>Value</th><th>Date</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="entry/*">
            <tr>
              <td><xsl:value-of select="code/@code"/></td>
              <td><xsl:value-of select="code/@displayName"/></td>
              <td>
                <xsl:choose>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.88'">RxNorm</xsl:when>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.96'">SNOMED CT</xsl:when>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.1'">LOINC</xsl:when>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.3'">ICD-10</xsl:when>
                  <xsl:otherwise><xsl:value-of select="code/@codeSystem"/></xsl:otherwise>
                </xsl:choose>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="value/@value"><xsl:value-of select="value/@value"/> <xsl:value-of select="value/@unit"/></xsl:when>
                  <xsl:when test="text"><xsl:value-of select="text"/></xsl:when>
                </xsl:choose>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="effectiveTime/@value"><xsl:value-of select="effectiveTime/@value"/></xsl:when>
                  <xsl:when test="effectiveTime/low/@value"><xsl:value-of select="effectiveTime/low/@value"/></xsl:when>
                </xsl:choose>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:if>
    
        </xsl:for-each>

        <h2>Social History</h2>
        <xsl:for-each select="component/structuredBody/component/section[code/@code='29762-2']">
          
    <xsl:if test="text/table">
      <xsl:copy-of select="text/table"/>
    </xsl:if>
    <xsl:if test="not(text/table)">
      <table>
        <thead>
          <tr>
            <th>Code</th><th>Display</th><th>System</th><th>Value</th><th>Date</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="entry/*">
            <tr>
              <td><xsl:value-of select="code/@code"/></td>
              <td><xsl:value-of select="code/@displayName"/></td>
              <td>
                <xsl:choose>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.88'">RxNorm</xsl:when>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.96'">SNOMED CT</xsl:when>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.1'">LOINC</xsl:when>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.3'">ICD-10</xsl:when>
                  <xsl:otherwise><xsl:value-of select="code/@codeSystem"/></xsl:otherwise>
                </xsl:choose>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="value/@value"><xsl:value-of select="value/@value"/> <xsl:value-of select="value/@unit"/></xsl:when>
                  <xsl:when test="text"><xsl:value-of select="text"/></xsl:when>
                </xsl:choose>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="effectiveTime/@value"><xsl:value-of select="effectiveTime/@value"/></xsl:when>
                  <xsl:when test="effectiveTime/low/@value"><xsl:value-of select="effectiveTime/low/@value"/></xsl:when>
                </xsl:choose>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:if>
    
        </xsl:for-each>

        <h2>Allergies</h2>
        <xsl:for-each select="component/structuredBody/component/section[code/@code='48765-2']">
          
    <xsl:if test="text/table">
      <xsl:copy-of select="text/table"/>
    </xsl:if>
    <xsl:if test="not(text/table)">
      <table>
        <thead>
          <tr>
            <th>Code</th><th>Display</th><th>System</th><th>Value</th><th>Date</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="entry/*">
            <tr>
              <td><xsl:value-of select="code/@code"/></td>
              <td><xsl:value-of select="code/@displayName"/></td>
              <td>
                <xsl:choose>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.88'">RxNorm</xsl:when>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.96'">SNOMED CT</xsl:when>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.1'">LOINC</xsl:when>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.3'">ICD-10</xsl:when>
                  <xsl:otherwise><xsl:value-of select="code/@codeSystem"/></xsl:otherwise>
                </xsl:choose>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="value/@value"><xsl:value-of select="value/@value"/> <xsl:value-of select="value/@unit"/></xsl:when>
                  <xsl:when test="text"><xsl:value-of select="text"/></xsl:when>
                </xsl:choose>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="effectiveTime/@value"><xsl:value-of select="effectiveTime/@value"/></xsl:when>
                  <xsl:when test="effectiveTime/low/@value"><xsl:value-of select="effectiveTime/low/@value"/></xsl:when>
                </xsl:choose>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:if>
    
        </xsl:for-each>

        <h2>Procedures</h2>
        <xsl:for-each select="component/structuredBody/component/section[code/@code='47519-4']">
          
    <xsl:if test="text/table">
      <xsl:copy-of select="text/table"/>
    </xsl:if>
    <xsl:if test="not(text/table)">
      <table>
        <thead>
          <tr>
            <th>Code</th><th>Display</th><th>System</th><th>Value</th><th>Date</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="entry/*">
            <tr>
              <td><xsl:value-of select="code/@code"/></td>
              <td><xsl:value-of select="code/@displayName"/></td>
              <td>
                <xsl:choose>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.88'">RxNorm</xsl:when>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.96'">SNOMED CT</xsl:when>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.1'">LOINC</xsl:when>
                  <xsl:when test="code/@codeSystem='2.16.840.1.113883.6.3'">ICD-10</xsl:when>
                  <xsl:otherwise><xsl:value-of select="code/@codeSystem"/></xsl:otherwise>
                </xsl:choose>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="value/@value"><xsl:value-of select="value/@value"/> <xsl:value-of select="value/@unit"/></xsl:when>
                  <xsl:when test="text"><xsl:value-of select="text"/></xsl:when>
                </xsl:choose>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="effectiveTime/@value"><xsl:value-of select="effectiveTime/@value"/></xsl:when>
                  <xsl:when test="effectiveTime/low/@value"><xsl:value-of select="effectiveTime/low/@value"/></xsl:when>
                </xsl:choose>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:if>
    
        </xsl:for-each>

      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:hl7="urn:hl7-org:v3"
    exclude-result-prefixes="hl7">

  <xsl:output method="xml" indent="yes"/>

  <!-- Entry-point: match the ClinicalDocument in HL7 namespace -->
  <xsl:template match="/hl7:ClinicalDocument">
    <CDA_Summary>
      <!-- Patient Demographics -->
      <PatientDemographics>
        <Name>
          <xsl:for-each select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name">
            <Given><xsl:value-of select="hl7:given"/></Given>
            <Family><xsl:value-of select="hl7:family"/></Family>
          </xsl:for-each>
        </Name>
        <Gender><xsl:value-of select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode/@displayName"/></Gender>
        <BirthTime><xsl:value-of select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthTime/@value"/></BirthTime>
        <Addresses>
          <xsl:for-each select="hl7:recordTarget/hl7:patientRole/hl7:addr">
            <Address>
              <Street><xsl:value-of select="hl7:streetAddressLine"/></Street>
              <City><xsl:value-of select="hl7:city"/></City>
              <State><xsl:value-of select="hl7:state"/></State>
              <PostalCode><xsl:value-of select="hl7:postalCode"/></PostalCode>
            </Address>
          </xsl:for-each>
        </Addresses>
      </PatientDemographics>

      <!-- Author & Responsible Party -->
      <AuthorResponsibleParty>
        <Author>
          <Person>
            <Given><xsl:value-of select="hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:given"/></Given>
            <Family><xsl:value-of select="hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:family"/></Family>
          </Person>
          <Organization><xsl:value-of select="hl7:author/hl7:assignedAuthor/hl7:representedOrganization/hl7:name"/></Organization>
        </Author>
      </AuthorResponsibleParty>

      <!-- Sections -->
      <Sections>
        <xsl:for-each select="hl7:component/hl7:structuredBody/hl7:component/hl7:section">
          <xsl:variable name="code" select="hl7:code/@code"/>
          <xsl:variable name="title" select="hl7:title"/>
          <Section Code="{string($code)}" Title="{string($title)}">
            <!-- Narrative tables take priority -->
            <xsl:choose>
              <xsl:when test="hl7:text/hl7:table">
                <NarrativeTable>
                  <xsl:copy-of select="hl7:text/hl7:table"/>
                </NarrativeTable>
              </xsl:when>
              <!-- Immunizations -->
              <xsl:when test="$code='11369-6'">
                <Immunizations>
                  <xsl:for-each select="hl7:entry/hl7:substanceAdministration">
                    <Immunization>
                      <Vaccine>
                        <Name><xsl:value-of select="hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/@displayName"/></Name>
                        <LoincCode><xsl:value-of select="hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/@code"/></LoincCode>
                      </Vaccine>
                      <Date><xsl:value-of select="hl7:effectiveTime/@value"/></Date>
                      <Status><xsl:value-of select="hl7:statusCode/@code"/></Status>
                    </Immunization>
                  </xsl:for-each>
                </Immunizations>
              </xsl:when>
              <!-- Medications Administered -->
              <xsl:when test="$code='29549-3'">
                <Medications>
                  <xsl:for-each select="hl7:entry/hl7:substanceAdministration">
                    <Medication>
                      <Name><xsl:value-of select="hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/@displayName"/></Name>
                      <RxNormCode><xsl:value-of select="hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/@code"/></RxNormCode>
                      <Dose><xsl:value-of select="hl7:doseQuantity/@value"/></Dose>
                      <Route><xsl:value-of select="hl7:routeCode/@displayName"/></Route>
                      <Date><xsl:value-of select="hl7:effectiveTime/@value"/></Date>
                    </Medication>
                  </xsl:for-each>
                </Medications>
              </xsl:when>
              <!-- Problems -->
              <xsl:when test="$code='11450-4'">
                <Problems>
                  <xsl:for-each select="hl7:entry/hl7:observation">
                    <Problem>
                      <Condition><xsl:value-of select="hl7:code/@displayName"/></Condition>
                      <ICD10Code><xsl:value-of select="hl7:code/@code"/></ICD10Code>
                      <Status><xsl:value-of select="hl7:value/@displayName"/></Status>
                      <Onset><xsl:value-of select="hl7:effectiveTime/hl7:low/@value"/></Onset>
                    </Problem>
                  </xsl:for-each>
                </Problems>
              </xsl:when>
              <!-- Fallback narrative -->
              <xsl:otherwise>
                <Narrative>
                  <xsl:copy-of select="hl7:text/node()"/>
                </Narrative>
              </xsl:otherwise>
            </xsl:choose>
          </Section>
        </xsl:for-each>
      </Sections>
    </CDA_Summary>
  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<!--
  ClinicalDocument → Human‑readable audit view
  ─────────────────────────────────────────────
  XSLT 1.0 stylesheet rendering key audit data (patient, facility, labs,
  diagnoses, treatments) from an eICR/CDA into a collapsible HTML report that
  opens directly in Chrome or via bookmarklet.
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:hl7="urn:hl7-org:v3"
  exclude-result-prefixes="hl7">

  <!-- ============================================================= -->
  <!--                       OUTPUT SET‑UP                           -->
  <!-- ============================================================= -->
  <xsl:output method="html" doctype-system="about:legacy-compat" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>

  <!-- ============================================================= -->
  <!--                         ENTRY POINT                           -->
  <!-- ============================================================= -->
  <xsl:template match="/">
    <xsl:apply-templates select="hl7:ClinicalDocument"/>
  </xsl:template>

  <!-- ============================================================= -->
  <!--                   TOP‑LEVEL DOCUMENT FRAME                    -->
  <!-- ============================================================= -->
  <xsl:template match="hl7:ClinicalDocument">
    <html lang="en">
      <head>
        <title><xsl:value-of select="normalize-space(hl7:title)"/></title>
        <style type="text/css"><![CDATA[
          body{font-family:system-ui,-apple-system,Segoe UI,Roboto,sans-serif;margin:0;padding:1rem;background:#f9fafb;color:#111}
          h1{font-size:1.5rem;margin:.2rem 0 .8rem;text-align:center}
          h2{font-size:1.25rem;margin:1.2rem 0 .4rem;border-bottom:2px solid #d1d5db}
          table{border-collapse:collapse;width:100%;margin:.4rem 0}
          th,td{border:1px solid #d1d5db;padding:.3rem .4rem;font-size:.9rem}
          th{background:#e5e7eb;font-weight:600;text-align:left}
          tbody tr:nth-child(even){background:#f3f4f6}
          details{margin:.6rem 0;padding:.4rem;border:1px solid #e5e7eb;border-radius:.5rem;background:#fff}
          summary{cursor:pointer;font-weight:600}
        ]]></style>
      </head>
      <body>
        <h1>Clinical Document Audit</h1>

        <!-- ==================== Header Summaries ==================== -->
        <xsl:call-template name="patient-summary"/>
        <xsl:call-template name="reporting-summary"/>
        <xsl:call-template name="diagnostic-summary"/>

        <!-- ===================== Repeating Sets ===================== -->
        <xsl:call-template name="labs-table"/>
        <xsl:call-template name="treatment-table"/>
        <xsl:call-template name="disease-table"/>
        <!-- TODO: pregnancies, encounters, clinicians -->
      </body>
    </html>
  </xsl:template>

  <!-- ============================================================= -->
  <!--                       PATIENT SECTION                         -->
  <!-- ============================================================= -->
  <xsl:template name="patient-summary">
    <details open="open"><summary>Patient Demographics</summary>
      <table><tbody>
        <tr><th>Last name</th><td><xsl:value-of select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name[not(@use='P')]/hl7:family[1]"/></td></tr>
        <tr><th>First name</th><td><xsl:value-of select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name[not(@use='P')]/hl7:given[1]"/></td></tr>
        <tr><th>Middle name</th><td><xsl:value-of select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name[not(@use='P')]/hl7:given[2]"/></td></tr>
        <tr><th>Gender</th><td><xsl:value-of select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode/@code"/></td></tr>
        <tr><th>DOB</th><td><xsl:value-of select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthTime/@value"/></td></tr>
        <tr><th>Race</th><td><xsl:value-of select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:raceCode/@code"/></td></tr>
        <tr><th>Ethnicity</th><td><xsl:value-of select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:ethnicGroupCode/@code"/></td></tr>
        <tr><th>Email</th><td><xsl:value-of select="substring-after((hl7:recordTarget/hl7:patientRole/hl7:telecom[starts-with(@value,'mailto')])[1]/@value,'mailto:')"/></td></tr>
        <!-- TODO: phones, address, language -->
      </tbody></table>
    </details>
  </xsl:template>

  <!-- ============================================================= -->
  <!--                       REPORTING SECTION                       -->
  <!-- ============================================================= -->
  <xsl:template name="reporting-summary">
    <xsl:if test="hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization/hl7:name">
      <details><summary>Reporting Facility</summary>
        <table><tbody>
          <tr><th>Agency</th><td><xsl:value-of select="hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization/hl7:name"/></td></tr>
          <!-- TODO: report_date when present -->
        </tbody></table>
      </details>
    </xsl:if>
  </xsl:template>

  <!-- ============================================================= -->
  <!--                       DIAGNOSTIC SITE                         -->
  <!-- ============================================================= -->
  <xsl:template name="diagnostic-summary">
    <xsl:if test="hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:location/hl7:name">
      <details><summary>Diagnostic Location</summary>
        <table><tbody>
          <tr><th>Name</th><td><xsl:value-of select="hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:location/hl7:name"/></td></tr>
          <tr><th>City</th><td><xsl:value-of select="(hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:location/hl7:addr/hl7:city)[1]"/></td></tr>
          <tr><th>State</th><td><xsl:value-of select="(hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:location/hl7:addr/hl7:state)[1]"/></td></tr>
          <tr><th>Zip</th><td><xsl:value-of select="(hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:location/hl7:addr/hl7:postalCode)[1]"/></td></tr>
        </tbody></table>
      </details>
    </xsl:if>
  </xsl:template>

  <!-- ============================================================= -->
  <!--                          LAB TABLE                            -->
  <!-- ============================================================= -->
  <xsl:template name="labs-table">
    <xsl:variable name="labs" select="hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code/@code='30954-2']/hl7:entry/hl7:organizer/hl7:component/hl7:observation[not(hl7:code/@code='31208-2') and not(hl7:code/@code='NAR')]"/>
    <xsl:if test="count($labs) &gt; 0">
      <h2>Laboratory Results (<xsl:value-of select="count($labs)"/>)</h2>
      <table>
        <thead>
          <tr><th>Segment #</th><th>LOINC</th><th>Test Name</th><th>Result</th><th>Unit</th><th>Ref Range</th><th>Flag</th><th>Collected</th><th>Tested</th></tr>
        </thead>
        <tbody>
          <xsl:for-each select="$labs">
            <tr>
              <td><xsl:value-of select="hl7:id[@root='UDOH_Segment_Index']/@extension"/></td>
              <td><xsl:value-of select="hl7:code/@code"/></td>
              <td><xsl:value-of select="hl7:code/hl7:originalText"/></td>
              <td>
                <xsl:choose>
                  <xsl:when test="hl7:value[@type='ST']"><xsl:value-of select="hl7:value[@type='ST']"/></xsl:when>
                  <xsl:when test="hl7:value[@type='CD']"><xsl:value-of select="hl7:value[@type='CD']/@code"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="hl7:value/@value | hl7:value[@value]"/></xsl:otherwise>
                </xsl:choose>
              </td>
              <td><xsl:value-of select="hl7:value/@unit"/></td>
              <td>
                <xsl:if test="hl7:referenceRange/hl7:observationRange/hl7:value/hl7:low/@value">

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:hl7="urn:hl7-org:v3"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:sdtc="urn:hl7-org:sdtc"
  exclude-result-prefixes="hl7 xsi sdtc">

  <xsl:output method="html" indent="yes"/>
  <xsl:template match="/">
    <html><head><title>CDA Data</title></head><body>
      <h1>CDA Extracted Data</h1>
      <table border="1">
        <tr><th>Data Element</th><th>Value</th></tr>
  <tr><td>Date of the Report</td><td><xsl:value-of select="//hl7:ClinicalDocument/effectiveTime"/></td></tr>
  <tr><td>Id</td><td><xsl:value-of select="//hl7:ClinicalDocument/id"/></td></tr>
  <tr><td>Set Id</td><td><xsl:value-of select="//hl7:ClinicalDocument/setId"/></td></tr>
  <tr><td>Version Number</td><td><xsl:value-of select="//hl7:ClinicalDocument/versionNumber"/></td></tr>
  <tr><td>Patient ID Number</td><td><xsl:value-of select="//hl7:ClinicalDocument/recordTarget/patientRole/id"/></td></tr>
  <tr><td>Patient Name</td><td><xsl:value-of select="//hl7:ClinicalDocument/recordTarget/patientRole/patient/name"/></td></tr>
  <tr><td>Patient Phone</td><td><xsl:value-of select="//hl7:ClinicalDocument/recordTarget/patientRole/telecom[tel:]"/></td></tr>
  <tr><td>Patient Email</td><td><xsl:value-of select="//hl7:ClinicalDocument/recordTarget/patientRole/telecom[mailto:]"/></td></tr>
  <tr><td>Parent/ Guardian Name</td><td><xsl:value-of select="//hl7:Clinical Document/record target/patientRole/patient/guardian/guardianPerson/name"/></td></tr>
  <tr><td>Parent/ Guardian Phone</td><td><xsl:value-of select="//hl7:Clinical Document/record target/patientRole/patient/guardian/telecom[tel:]"/></td></tr>
  <tr><td>Parent/ Guardian Email</td><td><xsl:value-of select="//hl7:Clinical Document/record target/patientRole/patient/guardian/telecom[mailto:]"/></td></tr>
  <tr><td>Street Address</td><td><xsl:value-of select="//hl7:ClinicalDocument/recordTarget/patientRole/addr"/></td></tr>
  <tr><td>Birth Date</td><td><xsl:value-of select="//hl7:ClinicalDocument/recordTarget/patientRole/patient/birthTime"/></td></tr>
  <tr><td>Patient Gender</td><td><xsl:value-of select="//hl7:ClinicalDocument/recordTarget/patientRole/patient/administrativeGenderCode"/></td></tr>
  <tr><td>Race</td><td><xsl:value-of select="//hl7:recordTarget/patientRole/patient/race"/></td></tr>
  <tr><td>Race</td><td><xsl:value-of select="//hl7:recordTarget/patientRole/patient/sdtc:race"/></td></tr>
  <tr><td>Ethnicity</td><td><xsl:value-of select="//hl7:recordTarget/patientRole/patient/ethnicGroupCode"/></td></tr>
  <tr><td>Ethnicity</td><td><xsl:value-of select="//hl7:recordTarget/patientRole/patient/sdtc:ethnicGroupCode"/></td></tr>
  <tr><td>Preferred Language</td><td><xsl:value-of select="//hl7:ClinicalDocument/recordTarget/patientRole/patient/languageCommunication/languageCode"/></td></tr>
  <tr><td>Death Indicator</td><td><xsl:value-of select="//hl7:ClinicalDocument/recordTarget/patientRole/patient/sdtc:deceasedInd"/></td></tr>
  <tr><td>Date of Death</td><td><xsl:value-of select="//hl7:ClinicalDocument/recordTarget/patientRole/patient/sdtc:deceasedTime"/></td></tr>
  <tr><td>EncompassingEncounter</td><td><xsl:value-of select="//hl7:ClinicalDocument/componentOf/encompassingEncounter"/></td></tr>
  <tr><td>Provider ID</td><td><xsl:value-of select="//hl7:ClinicalDocument/componentOf/encompassingEncounter/responsibleParty/assignedEntity/id"/></td></tr>
  <tr><td>Provider Name</td><td><xsl:value-of select="//hl7:ClinicalDocument/componentOf/encompassingEncounter/responsibleParty/assignedEntity/assignedPerson/name"/></td></tr>
  <tr><td>Provider Phone</td><td><xsl:value-of select="//hl7:ClinicalDocument/componentOf/encompassingEncounter/responsibleParty/assignedEntity/telecom/[tel:]"/></td></tr>
  <tr><td>Provider Fax</td><td><xsl:value-of select="//hl7:ClinicalDocument/componentOf/encompassingEncounter/responsibleParty/assignedEntity/telecom/[fax:]"/></td></tr>
  <tr><td>Provider Email</td><td><xsl:value-of select="//hl7:ClinicalDocument/componentOf/encompassingEncounter/responsibleParty/assignedEntity/telecom/[mailto:]"/></td></tr>
  <tr><td>Provider Facility/Office Name</td><td><xsl:value-of select="//hl7:ClinicalDocument/componentOf/encompassingEncounter/responsibleParty/assignedEntity/representedOrganization/name"/></td></tr>
  <tr><td>Provider Address</td><td><xsl:value-of select="//hl7:ClinicalDocument/componentOf/encompassingEncounter/responsibleParty/assignedEntity/representedOrganization/addr"/></td></tr>
  <tr><td>Facility ID Number</td><td><xsl:value-of select="//hl7:ClinicalDocument/componentOf/encompassingEncounter/location/healthCareFacility/id"/></td></tr>
  <tr><td>Facility Name</td><td><xsl:value-of select="//hl7:ClinicalDocument/componentOf/encompassingEncounter/location/healthCareFacility/serviceProviderOrganization/name"/></td></tr>
  <tr><td>Facility Type/Hospital Unit</td><td><xsl:value-of select="//hl7:ClinicalDocument/componentOf/encompassingEncounter/location/healthCareFacility/code"/></td></tr>
  <tr><td>Facility Phone</td><td><xsl:value-of select="//hl7:ClinicalDocument/componentOf/encompassingEncounter/location/healthCareFacility/serviceProviderOrganization/telecom[tel:]"/></td></tr>
  <tr><td>Facility FAX</td><td><xsl:value-of select="//hl7:ClinicalDocument/componentOf/encompassingEncounter/location/healthCareFacility/serviceProviderOrganization/telecom[fax:]"/></td></tr>
  <tr><td>Facility Address</td><td><xsl:value-of select="//hl7:ClinicalDocument/componentOf/encompassingEncounter/location/healthCareFacility/serviceProviderOrganization/addr"/></td></tr>
  <tr><td>Author</td><td><xsl:value-of select="//hl7:ClinicalDocument/author"/></td></tr>
  <tr><td>Custodian</td><td><xsl:value-of select="//hl7:ClinicalDocument/custodian"/></td></tr>
  <tr><td>Patient Sex</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.22.4.200']/value[xsi:type="CD"]"/></td></tr>
  <tr><td>Occupation</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.22.4.38']/value[xsi:type="CD"]"/></td></tr>
  <tr><td>Pregnant</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.15.3.8']/value"/></td></tr>
  <tr><td>Visit Date/Time (outpatient)</td><td><xsl:value-of select="//hl7:ClinicalDocument/encompassingEncounter/effectiveTime/low"/></td></tr>
  <tr><td>Admission Date/Time</td><td><xsl:value-of select="//hl7:ClinicalDocument/encompassingEncounter/effectiveTime/low"/></td></tr>
  <tr><td>Discharge Date/Time</td><td><xsl:value-of select="//hl7:ClinicalDocument/encompassingEncounter/effectiveTime/high"/></td></tr>
  <tr><td>History of Present Illness</td><td><xsl:value-of select="//hl7:section[templateId/root='1.3.6.1.4.1.19376.1.5.3.1.3.4']/text"/></td></tr>
  <tr><td>Reason for Visit</td><td><xsl:value-of select="//hl7:section[templateId/root='2.16.840.1.113883.10.20.22.2.12']/text"/></td></tr>
  <tr><td>Lab Order Code (ordered)</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.22.4.44']/code"/></td></tr>
  <tr><td>Lab Order Id</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.22.4.44']/id"/></td></tr>
  <tr><td>Lab Order Time (time should occur)</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.22.4.44']/effectiveTime"/></td></tr>
  <tr><td>Lab Order Orderer</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.22.4.44']/author"/></td></tr>
  <tr><td>Lab Order Perfomer</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.22.4.44']/performer"/></td></tr>
  <tr><td>Lab Order Body Site/Location</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.22.4.44']/targetSiteCode"/></td></tr>
  <tr><td>Lab Order Code (Trigger) (ordered)</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.15.2.3.4']/code/@code"/></td></tr>
  <tr><td>Lab Order Code Value Set (Trigger) (ordered)</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.15.2.3.4']/code/@sdtc:valueSet"/></td></tr>
  <tr><td>Lab Order Code Value Set Version (Trigger) (ordered)</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.15.2.3.4']/code/@sdtc:valueSetVersion"/></td></tr>
  <tr><td>Result Organizer Code</td><td><xsl:value-of select="//hl7:organizer[templateId/root='2.16.840.1.113883.10.20.22.4.1']/code"/></td></tr>
  <tr><td>Result Organizer Time</td><td><xsl:value-of select="//hl7:organizer[templateId/root='2.16.840.1.113883.10.20.22.4.1']/effectiveTime"/></td></tr>
  <tr><td>Result Organizer Status</td><td><xsl:value-of select="//hl7:organizer[templateId/root='2.16.840.1.113883.10.20.22.4.1']/statusCode"/></td></tr>
  <tr><td>Result Organizer Author</td><td><xsl:value-of select="//hl7:organizer[templateId/root='2.16.840.1.113883.10.20.22.4.1']/author"/></td></tr>
  <tr><td>Lab Order Code (resulted)</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.22.4.2']/code"/></td></tr>
  <tr><td>Lab Order Code (resulted)</td><td><xsl:value-of select="//hl7:organizer[templateId/root='2.16.840.1.113883.10.20.22.4.1']/code"/></td></tr>
  <tr><td>Lab Order Code (Trigger) (resulted)</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.15.2.3.2']/code"/></td></tr>
  <tr><td>Laboratory Results</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.22.4.2']/value"/></td></tr>
  <tr><td>Laboratory Result (Trigger)</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.15.2.3.2']/value"/></td></tr>
  <tr><td>Filler Order Number</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.22.4.2']/id"/></td></tr>
  <tr><td>Filler Order Number</td><td><xsl:value-of select="//hl7:organizer[templateId/root='2.16.840.1.113883.10.20.22.4.1']/id"/></td></tr>
  <tr><td>Result Observation Status</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.22.4.2']/statusCode"/></td></tr>
  <tr><td>Result Organizer Status</td><td><xsl:value-of select="//hl7:organizer[templateId/root='2.16.840.1.113883.10.20.22.4.1']/statusCode"/></td></tr>
  <tr><td>Result Observation Time</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.22.4.2']/effectiveTime"/></td></tr>
  <tr><td>Result Observation Status</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.22.4.2']/interpretationCode"/></td></tr>
  <tr><td>Result Observation Method</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.22.4.2']/methodCode"/></td></tr>
  <tr><td>Result Observation Target Site</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.22.4.2']/targetSiteCode"/></td></tr>
  <tr><td>Result Observation Author</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.22.4.2']/author"/></td></tr>
  <tr><td>Result Observation Reference Range</td><td><xsl:value-of select="//hl7:observation[templateId/root='2.16.840.1.113883.10.20.22.4.2']/referenceRange"/></td></tr>
  <tr><td>Diagnoses (Problem List)</td><td><xsl:value-of select="//hl7:observation[templateId/@root='2.16.840.1.113883.10.20.22.4.4']/value"/></td></tr>
  <xsl:for-each select="//hl7:observation">
    <tr><td>Diagnoses (Encounter)</td><td><xsl:value-of select="value"/></td></tr>
  </xsl:for-each>
  <tr><td>Diagnosis (Trigger)</td><td><xsl:value-of select="//hl7:observation[templateId/@root='2.16.840.1.113883.10.20.22.4.4']/value"/></td></tr>
  <tr><td>Problem Type</td><td><xsl:value-of select="//hl7:observation[templateId/@root='2.16.840.1.113883.10.20.22.4.4']/code
observation[templateId/@root='2.16.840.1.113883.10.20.22.4.4']/code/translation"/></td></tr>
  <xsl:for-each select="//hl7:act">
    <tr><td>Date of Diagnosis</td><td><xsl:value-of select="effectiveTime
encounter/effectiveTime"/></td></tr>
  </xsl:for-each>
  <tr><td>Date of Diagnosis</td><td><xsl:value-of select="//hl7:encounter/effectiveTime"/></td></tr>
  <tr><td>Date of Onset (Diagnosis)</td><td><xsl:value-of select="//hl7:observation[templateId/@root='2.16.840.1.113883.10.20.22.4.4']/effectiveTime"/></td></tr>
  <tr><td>Date of Onset (Symptom)</td><td><xsl:value-of select="//hl7:observation[templateId/@root='2.16.840.1.113883.10.20.22.4.4'][code='symptom']/effectiveTime"/></td></tr>
  <tr><td>Symptoms (list)</td><td><xsl:value-of select="//hl7:observation[templateId/@root='2.16.840.1.113883.10.20.22.4.4'][code='symptom']"/></td></tr>
  <tr><td>Medications Administered (list)</td><td><xsl:value-of select="//hl7:manufacturedProduct/manufacturedMaterial/code"/></td></tr>
  <tr><td>Medication Administration Id</td><td><xsl:value-of select="//hl7:substanceAdministration[templateId/root='2.16.840.1.113883.10.20.22.4.16']/id"/></td></tr>
  <tr><td>Medication Administration Status</td><td><xsl:value-of select="//hl7:substanceAdministration[templateId/root='2.16.840.1.113883.10.20.22.4.16']/statusCode"/></td></tr>
  <tr><td>Medication Administration Time</td><td><xsl:value-of select="//hl7:substanceAdministration[templateId/root='2.16.840.1.113883.10.20.22.4.16']/effectiveTime[ivl_ts]"/></td></tr>
  <tr><td>Medication Administration Route</td><td><xsl:value-of select="//hl7:substanceAdministration[templateId/root='2.16.840.1.113883.10.20.22.4.16']/routeCode"/></td></tr>
  <tr><td>Medication Administration Dose Quantity</td><td><xsl:value-of select="//hl7:substanceAdministration[templateId/root='2.16.840.1.113883.10.20.22.4.16']/doseQuantity"/></td></tr>
  <tr><td>Medication Administration Rate Quantity</td><td><xsl:value-of select="//hl7:substanceAdministration[templateId/root='2.16.840.1.113883.10.20.22.4.16']/rateQuantity"/></td></tr>
  <tr><td>Immunization Status</td><td><xsl:value-of select="//hl7:substanceAdministration[templateId/root='2.16.840.1.113883.10.20.22.4.52']/@negationInd"/></td></tr>
  <tr><td>Immunization Status</td><td><xsl:value-of select="//hl7:substanceAdministration[templateId/root='2.16.840.1.113883.10.20.22.4.52']/@moodCode"/></td></tr>
  <tr><td>Immunization Status</td><td><xsl:value-of select="//hl7:substanceAdministration[templateId/root='2.16.840.1.113883.10.20.22.4.52']/@moodCode"/></td></tr>
  <tr><td>Immunization Id</td><td><xsl:value-of select="//hl7:substanceAdministration[templateId/root='2.16.840.1.113883.10.20.22.4.52']/@moodCode"/></td></tr>
  <tr><td>Immunization Status Code</td><td><xsl:value-of select="//hl7:substanceAdministration[templateId/root='2.16.840.1.113883.10.20.22.4.52']/id"/></td></tr>
  <tr><td>Immunization Date</td><td><xsl:value-of select="//hl7:substanceAdministration[templateId/root='2.16.840.1.113883.10.20.22.4.52']/effectiveTime"/></td></tr>
  <tr><td>Immunization Dose Quantity</td><td><xsl:value-of select="//hl7:substanceAdministration[templateId/root='2.16.840.1.113883.10.20.22.4.52']/doseQuantity"/></td></tr>
  <tr><td>Immunization Performer</td><td><xsl:value-of select="//hl7:substanceAdministration[templateId/root='2.16.840.1.113883.10.20.22.4.52']/performer"/></td></tr>
  <tr><td>Immunization Vaccine Code</td><td><xsl:value-of select="//hl7:manufacturedProduct[templateId/root='2.16.840.1.113883.10.20.22.4.54']/manufacturedMaterial/code"/></td></tr>
  <tr><td>Travel History Dates</td><td><xsl:value-of select="//hl7:act[templateId/root='2.16.840.1.113883.10.20.15.2.3.1']/effectiveTime"/></td></tr>
  <tr><td>Travel History Location - Free Text</td><td><xsl:value-of select="//hl7:act[templateId/root='2.16.840.1.113883.10.20.15.2.3.1']/text"/></td></tr>
  <tr><td>Travel History Location - Coded</td><td><xsl:value-of select="//hl7:act[templateId/root='2.16.840.1.113883.10.20.15.2.3.1']/participant/participantRole/code"/></td></tr>
  <tr><td>Travel History Location - Address</td><td><xsl:value-of select="//hl7:act[templateId/root='2.16.840.1.113883.10.20.15.2.3.1']/participant/participantRole/addr"/></td></tr>
      </table>
    </body></html>
  </xsl:template>
</xsl:stylesheet>
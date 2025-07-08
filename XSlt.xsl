<?xml version="1.0" encoding="UTF-8"?>
<!--
    Document   : eICR_v55751-2_to_master_base.xsl
    Author     : UDOH
    Description: Purpose of transformation follows.
    Last Updated
    3/24/24 - updated specimen source to look at second location if first location is missing
    6/4/25 - updated performing lab to look at second location (reporting agency) if first location is missing
    6/4/25 - updated collection dates to look at one additional location (encounter date) in addition to two current locations (collection date and lab test date)
    6/4/25 - added local result value type of IVL_Real/low and high
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml"/>
  <xsl:strip-space elements="*"/>
  <xsl:key name="rslt-comment" match="/ClinicalDocument/component/structuredBody/component/section/text/list/item/table/tbody/tr/td/content/content" use="@ID"/>
  <xsl:template match="entryRelationship/act/text/reference">
    <comment>
      <xsl:value-of select="key('rslt-comment', translate(@value,'#',''))"/>
    </comment>
  </xsl:template>
  <xsl:key name="rslt-value-comment" match="/ClinicalDocument/component/structuredBody/component/section/text/paragraph/content" use="@ID"/>
  <xsl:template match="value/reference">
    <comment>
      <xsl:value-of select="key('rslt-value-comment', translate(@value,'#',''))"/>
    </comment>
  </xsl:template>
  <xsl:key name="treatment-name" match="/ClinicalDocument/component/structuredBody/component/section/text/table/tbody/tr/td/paragraph" use="@ID"/>
  <xsl:template match="consumable/manufacturedProduct/manufacturedMaterial/code/originalText/reference">
    <name>
      <xsl:value-of select="key('treatment-name', translate(@value,'#',''))"/>
    </name>
  </xsl:template>
  <xsl:key name="local-test-name" match="/ClinicalDocument/component/structuredBody/component/section/text/list/item/table/tbody/tr/td" use="@ID"/>
  <xsl:template match="code/originalText/reference">
    <local_test_name>
      <xsl:value-of select="key('local-test-name', translate(@value,'#',''))"/>
    </local_test_name>
  </xsl:template>
  <xsl:key name="local-specimen" match="/ClinicalDocument/component/structuredBody/component/section/text/list/item/table/tbody/tr/td" use="@ID"/>
  <!--
  <xsl:key name="accession-number" match="/ClinicalDocument/component/structuredBody/component/section/text/list/item/table/tbody/tr/td/paragraph" use="../@ID"/>
  <xsl:template match="observation[code/translation/@code='NAR']/value/reference">
    <accession_number>
      <xsl:value-of select="number(translate(key('accession-number', translate(@value,'#','')), translate(key('accession-number', translate(@value,'#','')), '0123456789',''),''))"/>
    </accession_number>
  </xsl:template>
  -->
  <!--
  <xsl:key name="facility-visit-type" match="/ClinicalDocument/component/structuredBody/component/section/text/table/tbody/tr/td" use="@ID"/>
  <xsl:template match="component/structuredBody/component/section/entry/encounter/code/originalText/reference">
    <facility_visit_type>
      <xsl:value-of select="key('facility-visit-type', translate(@value,'#',''))"/>
    </facility_visit_type>
  </xsl:template>
  -->
  <xsl:template match="ClinicalDocument">
    <health>
      <person>
        <xsl:if test="/ClinicalDocument/recordTarget/patientRole/patient/name[not(@use='P')]/family[1]/text()">
          <last_name>
            <xsl:value-of select="/ClinicalDocument/recordTarget/patientRole/patient/name[not(@use='P')]/family[1]/text()"/>
          </last_name>
        </xsl:if>
        <xsl:if test="/ClinicalDocument/recordTarget/patientRole/patient/name[not(@use='P')]/given[1]/text()">
          <first_name>
            <xsl:value-of select="/ClinicalDocument/recordTarget/patientRole/patient/name[not(@use='P')]/given[1]/text()"/>
          </first_name>
        </xsl:if>
        <xsl:if test="/ClinicalDocument/recordTarget/patientRole/patient/name[not(@use='P')]/given[2]/text()">
          <middle_name>
            <xsl:value-of select="/ClinicalDocument/recordTarget/patientRole/patient/name[not(@use='P')]/given[2]/text()"/>
          </middle_name>
        </xsl:if>
        <xsl:if test="recordTarget/patientRole/patient/administrativeGenderCode/@code">
          <gender>
            <xsl:value-of select="recordTarget/patientRole/patient/administrativeGenderCode/@code"/>
          </gender>
        </xsl:if>
        <xsl:if test="recordTarget/patientRole/patient/raceCode/@code">
          <race>
            <xsl:value-of select="recordTarget/patientRole/patient/raceCode/@code"/>
          </race>
        </xsl:if>
        <xsl:if test="recordTarget/patientRole/patient/ethnicGroupCode/@code">
          <ethnicity>
            <xsl:value-of select="recordTarget/patientRole/patient/ethnicGroupCode/@code"/>
          </ethnicity>
        </xsl:if>
        <xsl:if test="recordTarget/patientRole/patient/birthTime/@value">
          <date_of_birth>
            <xsl:value-of select="concat(substring(recordTarget/patientRole/patient/birthTime/@value,0,5),'-',substring(recordTarget/patientRole/patient/birthTime/@value,5,2),'-',substring(recordTarget/patientRole/patient/birthTime/@value,7,2))"/>
          </date_of_birth>
        </xsl:if>
        <xsl:if test="recordTarget/patientRole/telecom[(@use='HP' or @use='MC') and starts-with(@value, 'tel')]/@value">
          <area_code>
            <xsl:value-of select="substring(translate((recordTarget/patientRole/telecom[(@use='HP' or @use='MC') and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''), string-length(translate((recordTarget/patientRole/telecom[(@use='HP' or @use='MC') and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''))-9, 3)"/>
          </area_code>
        </xsl:if>
        <xsl:if test="recordTarget/patientRole/telecom[(@use='HP' or @use='MC') and starts-with(@value, 'tel')]/@value">
          <phone>
            <xsl:value-of select="substring(translate((recordTarget/patientRole/telecom[(@use='HP' or @use='MC') and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''), string-length(translate((recordTarget/patientRole/telecom[(@use='HP' or @use='MC') and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''))-6, 7)"/>
          </phone>
        </xsl:if>
        <xsl:if test="(recordTarget/patientRole/addr[not(@use) or @use='H' or @use='HP']/city)[1]/text()">
          <city>
            <xsl:value-of select="(recordTarget/patientRole/addr[not(@use) or @use='H' or @use='HP']/city)[1]/text()"/>
          </city>
        </xsl:if>
        <xsl:if test="(recordTarget/patientRole/addr[not(@use) or @use='H' or @use='HP']/county)[1]/text()">
          <county>
            <xsl:value-of select="(recordTarget/patientRole/addr[not(@use) or @use='H' or @use='HP']/county)[1]/text()"/>
          </county>
        </xsl:if>
        <xsl:if test="(recordTarget/patientRole/addr[not(@use) or @use='H' or @use='HP']/postalCode)[1]/text()">
          <zip>
            <xsl:value-of select="(recordTarget/patientRole/addr[not(@use) or @use='H' or @use='HP']/postalCode)[1]/text()"/>
          </zip>
        </xsl:if>
        <xsl:if test="(recordTarget/patientRole/addr[not(@use) or @use='H' or @use='HP']/state)[1]/text()">
          <state>
            <xsl:value-of select="(recordTarget/patientRole/addr[not(@use) or @use='H' or @use='HP']/state)[1]/text()"/>
          </state>
        </xsl:if>
        <xsl:if test="(recordTarget/patientRole/addr[not(@use) or @use='H' or @use='HP']/streetAddressLine)[1]/text()">
          <street_name>
            <xsl:value-of select="(recordTarget/patientRole/addr[not(@use) or @use='H' or @use='HP']/streetAddressLine)[1]/text()"/>
          </street_name>
        </xsl:if>
        <xsl:if test="(recordTarget/patientRole/addr[not(@use) or @use='H' or @use='HP']/streetAddressLine2)/text()">
          <unit>
            <xsl:value-of select="(recordTarget/patientRole/addr[not(@use) or @use='H' or @use='HP']/streetAddressLine2)/text()"/>
          </unit>
        </xsl:if>
        <xsl:if test="(recordTarget/patientRole/telecom[starts-with(@value, 'mailto') and not(@value='mailto:BLANK')])[1]/@value">
          <email>
            <xsl:value-of select="substring((recordTarget/patientRole/telecom[starts-with(@value, 'mailto')])[1]/@value, string-length('mailto: '))"/>
          </email>
        </xsl:if>
        <xsl:if test="recordTarget/patientRole/patient/languageCommunication/languageCode/@code">
          <language>
            <xsl:value-of select="recordTarget/patientRole/patient/languageCommunication/languageCode/@code"/>
          </language>
        </xsl:if>
      </person>
      <xsl:for-each select="component/structuredBody/component/section[code[@code='30954-2']]/entry/organizer/component/observation[not(code/@code='31208-2') and not(code/@code='NAR')]">
        <!--/organizer/component/observation[not((./templateId/@extension='2016-12-01' and ./templateId/@root='2.16.840.1.113883.10.20.15.2.3.2') or ./code/@nullFlavor='NI' or contains(./code/originalText/text(),'Cmt:') or ./code/@code='17636008')]-->
        <!--  <xsl:if test="(code/@code) and (code[@code='94559-2'] or code[@code='94534-5'] or code[@code='94309-2']  or code[@code='94500-6'] or code[@code='94565-9'])">-->
        <xsl:if test="code/@code">
          <labs>
            <xsl:if test="../../id/@extension">
              <obr_id>
                <xsl:value-of select="../../id/@extension"/>
              </obr_id>
              <accession_number>
                <xsl:value-of select="../../id/@extension"/>
              </accession_number>
            </xsl:if>
            <xsl:if test="../../component/observation[code/translation/@code='NAR']/value/reference/@value">
              <xsl:apply-templates select="../../component/observation[code/translation/@code='NAR']/value/reference"/>
              <!--accession-number-->
            </xsl:if>
            <!-- Use reporting lab name if performing lab name is absent -->
            <xsl:choose>
              <xsl:when test="../../performer/assignedEntity/representedOrganization/name/text()">
                <lab>
                  <xsl:value-of select="../../performer/assignedEntity/representedOrganization/name/text()"/>
                </lab>
              </xsl:when>
              <xsl:when test="/ClinicalDocument/componentOf/encompassingEncounter/location/healthCareFacility/serviceProviderOrganization/name/text()">
                <lab>
                  <xsl:value-of select="/ClinicalDocument/componentOf/encompassingEncounter/location/healthCareFacility/serviceProviderOrganization/name/text()"/>
                </lab>
              </xsl:when>
            </xsl:choose>
            <xsl:if test="entryRelationship/act/text/reference/@value">
              <xsl:apply-templates select="entryRelationship/act/text/reference"/>
              <!--lab-result-comment-->
            </xsl:if>
            <xsl:if test="effectiveTime/@value">
              <lab_test_date>
                <!--<xsl:value-of select="concat(substring(organizer/component/observation[not(code/@code='31208-2')]/effectiveTime/@value,0,5),'-',substring(organizer/component/observation[not(code/@code='31208-2')]/effectiveTime/@value,5,2),'-',substring(organizer/component/observation[not(code/@code='31208-2')]/effectiveTime/@value,7,2),'T',substring(organizer/component/observation[not(code/@code='31208-2')]/effectiveTime/@value,9,2),':',substring(organizer/component/observation[not(code/@code='31208-2')]/effectiveTime/@value,11,2),':',substring(translate(organizer/component/observation[not(code/@code='31208-2')]/effectiveTime/@value,'+','-'),13))"/>-->
                <xsl:value-of select="effectiveTime/@value"/>
              </lab_test_date>
            </xsl:if>
            <segment_index>
              <xsl:value-of select="id[@root='UDOH_Segment_Index']/@extension"/>
            </segment_index>
            <xsl:if test="value[@type='ST']/text()">
              <local_result_value>
                <xsl:value-of select="value[@type='ST']/text()"/>
              </local_result_value>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="../../component/procedure[code/@code='17636008']/effectiveTime/@value">
                <collection_date>
                  <!--<xsl:value-of select="concat(substring(organizer/component/procedure/effectiveTime/@value,0,5),'-',substring(organizer/component/procedure/effectiveTime/@value,5,2),'-',substring(organizer/component/procedure/effectiveTime/@value,7,2),'T',substring(organizer/component/procedure/effectiveTime/@value,9,2),':',substring(organizer/component/procedure/effectiveTime/@value,11,2),':',substring(organizer/component/procedure/effectiveTime/@value,13))"/>-->
                  <xsl:value-of select="../../component/procedure[code/@code='17636008']/effectiveTime/@value"/>
                </collection_date>
              </xsl:when>
              <xsl:when test="/ClinicalDocument/componentOf/encompassingEncounter/effectiveTime/low/@value">
                <collection_date>
                  <xsl:value-of select="/ClinicalDocument/componentOf/encompassingEncounter/effectiveTime/low/@value"/>
                </collection_date>
              </xsl:when>
              <xsl:when test="effectiveTime/@value">
                <collection_date>
                  <xsl:value-of select="effectiveTime/@value"/>
                </collection_date>
              </xsl:when>
            </xsl:choose>
            <xsl:choose>
              <xsl:when test="../../component/procedure[code/@code='17636008']/targetSiteCode/originalText/text()">
                <local_specimen_source>
                  <xsl:value-of select="../../component/procedure[code/@code='17636008']/targetSiteCode/originalText/text()"/>
                </local_specimen_source>
              </xsl:when>
              <xsl:when test="../../id/@extension">
                <xsl:variable name="entryRoot" select="../../id/@root"/>
                <xsl:variable name="entryId" select="../../id/@extension"/>
                <xsl:variable name="specimenId" select="concat('Result.', $entryRoot, '.' , $entryId, '.Specimen')"/>
                <local_specimen_source>
                  <xsl:value-of select="key('local-specimen', $specimenId)"/>
                </local_specimen_source>
              </xsl:when>
            </xsl:choose>
            <xsl:if test="(referenceRange/observationRange/value/low/@value) or (referenceRange/observationRange/value/high/@value)">
              <local_reference_range>
                <xsl:if test="referenceRange/observationRange/value/low/@value">
                  <xsl:text> low: </xsl:text>
                  <xsl:value-of select="referenceRange/observationRange/value/low/@value"/>
                  <xsl:value-of select="referenceRange/observationRange/value/low/@unit"/>
                </xsl:if>
                <xsl:if test="referenceRange/observationRange/value/high/@value">
                  <xsl:text> high: </xsl:text>
                  <xsl:value-of select="referenceRange/observationRange/value/high/@value"/>
                  <xsl:value-of select="referenceRange/observationRange/value/high/@unit"/>
                </xsl:if>
              </local_reference_range>
            </xsl:if>
            <xsl:if test="interpretationCode/@code">
              <abnormal_flag>
                <xsl:value-of select="interpretationCode/@code"/>
              </abnormal_flag>
            </xsl:if>
            <xsl:if test="code/@code">
              <local_loinc_code>
                <xsl:value-of select="code/@code"/>
              </local_loinc_code>
            </xsl:if>
            <xsl:if test="code/originalText/reference/@value">
              <!--local-test-name-->
              <xsl:apply-templates select="code/originalText/reference"/>
            </xsl:if>
            <xsl:if test="value[@type='CD']/@code">
              <local_result_value>
                <xsl:value-of select="value[@type='CD']/@code"/>
              </local_result_value>
            </xsl:if>
            <xsl:if test="value[@type='PQ']/@value">
              <local_result_value>
                <xsl:value-of select="value[@type='PQ']/@value"/>
              </local_result_value>
            </xsl:if>
            <xsl:if test="value[@type='PQ']/@unit">
              <local_result_unit>
                <xsl:value-of select="value[@type='PQ']/@unit"/>
              </local_result_unit>
            </xsl:if>
            <xsl:if test="value[@type='CO']/@code">
              <local_result_value_2>
                <xsl:value-of select="value[@type='CO']/@code"/>
              </local_result_value_2>
            </xsl:if>
            <xsl:if test="value[@type='IVL_PQ']/high/@value">
              <local_result_value>
                <xsl:value-of select="value[@type='IVL_PQ']/high/@value"/>
              </local_result_value>
            </xsl:if>
            <xsl:if test="value[@type='IVL_PQ']/high/@unit">
              <local_result_unit>
                <xsl:value-of select="value[@type='IVL_PQ']/high/@unit"/>
              </local_result_unit>
            </xsl:if>
            <xsl:if test="value[@type='REAL']/@value">
              <local_result_value>
                <xsl:value-of select="value[@type='REAL']/@value"/>
              </local_result_value>
            </xsl:if>
            <xsl:if test="value[@type='IVL_REAL']/low/@value">
              <local_result_value>
                <xsl:value-of select="value[@type='IVL_REAL']/low/@value"/>
              </local_result_value>
            </xsl:if>
            <xsl:if test="value[@type='IVL_REAL']/high/@value">
              <local_result_value>
                <xsl:value-of select="value[@type='IVL_REAL']/high/@value"/>
              </local_result_value>
            </xsl:if>
            <xsl:if test="statusCode/@code">
              <test_status>
                <xsl:value-of select="statusCode/@code"/>
              </test_status>
            </xsl:if>
            <!--<xsl:if test="value/@type">
              <data_type>
                <xsl:value-of select="value/@type"/>
              </data_type>
            </xsl:if>-->
          </labs>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="/ClinicalDocument/component/structuredBody/component/section[code[@code='11450-4']]/entry/act/entryRelationship/observation/value">
        <!--<xsl:for-each select="/ClinicalDocument/component/structuredBody/component/section[code[@code='11450-4']]/entry/act[statusCode/@code = 'active']/entryRelationship/observation/value">-->
        <xsl:if test="translation[@conditionName and string-length(@conditionName)!=0]/@codeSystemName | translation[@conditionName and string-length(@conditionName)!=0]/@conditionName | translation[@conditionName and string-length(@conditionName)!=0]/@code">
          <disease>
            <segment_index>
              <xsl:value-of select="translation/@udohSegmentIndex"/>
            </segment_index>
            <xsl:if test="translation/@codeSystemName">
              <codingSystem>
                <xsl:value-of select="translation/@codeSystemName"/>
              </codingSystem>
            </xsl:if>
            <xsl:if test="translation/@code">
              <code>
                <xsl:value-of select="translation/@code"/>
              </code>
            </xsl:if>
            <xsl:if test="translation/@conditionName">
              <name>
                <xsl:value-of select="translation/@conditionName"/>
              </name>
            </xsl:if>
            <!--
            <xsl:if test="../../effectiveTime/low/@value">
              <onset_date>
                <xsl:value-of select="concat(substring(../../effectiveTime/low/@value,0,5),'-',substring(../../effectiveTime/low/@value,5,2),'-',substring(../../effectiveTime/low/@value,7,2))"/>
              </onset_date>
            </xsl:if>
            -->
          </disease>
        </xsl:if>
      </xsl:for-each>
      <xsl:if test="component/structuredBody/component/section[code[@code='11450-4']]/entry/act/entryRelationship/observation/value/translation[@pregnancyStatus and string-length(@pregnancyStatus)!=0]/@pregnancyStatus">
        <pregnancy>
          <pregnancy_diagnosis>
            <xsl:value-of select="component/structuredBody/component/section[code[@code='11450-4']]/entry/act/entryRelationship/observation/value/translation[@pregnancyStatus and string-length(@pregnancyStatus)!=0]/@pregnancyStatus"/>
          </pregnancy_diagnosis>
        </pregnancy>
      </xsl:if>
      <xsl:if test="componentOf/encompassingEncounter/effectiveTime/low/@value">
        <encounter>
          <encounter_date>
            <!--<xsl:value-of select="concat(substring(componentOf/encompassingEncounter/effectiveTime/low/@value,0,5),'-',substring(componentOf/encompassingEncounter/effectiveTime/low/@value,5,2),'-',substring(componentOf/encompassingEncounter/effectiveTime/low/@value,7,2),'T',substring(componentOf/encompassingEncounter/effectiveTime/low/@value,9,2),':',substring(componentOf/encompassingEncounter/effectiveTime/low/@value,11,2),':',substring(componentOf/encompassingEncounter/effectiveTime/low/@value,13))"/>-->
            <xsl:value-of select="componentOf/encompassingEncounter/effectiveTime/low/@value"/>
          </encounter_date>
        </encounter>
      </xsl:if>
      <xsl:if test="component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/assignedPerson/name | component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom">
        <clinicians>
          <xsl:if test="component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/assignedPerson/name/family/text()">
            <last_name>
              <xsl:value-of select="component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/assignedPerson/name/family/text()"/>
            </last_name>
          </xsl:if>
          <xsl:if test="component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/assignedPerson/name/given[1]/text()">
            <first_name>
              <xsl:value-of select="component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/assignedPerson/name/given[1]/text()"/>
            </first_name>
          </xsl:if>
          <xsl:if test="component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/assignedPerson/name/given[2]/text()">
            <middle_name>
              <xsl:value-of select="component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/assignedPerson/name/given[2]/text()"/>
            </middle_name>
          </xsl:if>
          <xsl:if test="substring(translate((component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom[@use='WP' and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''), string-length(translate((component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom[@use='WP' and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''))-6, 7)">
            <phone>
              <xsl:value-of select="substring(translate((component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom[@use='WP' and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''), string-length(translate((component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom[@use='WP' and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''))-6, 7)"/>
            </phone>
          </xsl:if>
          <xsl:if test="substring(translate((component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom[@use='WP' and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''), string-length(translate((component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom[@use='WP' and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''))-9, 3)">
            <area_code>
              <xsl:value-of select="substring(translate((component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom[@use='WP' and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''), string-length(translate((component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom[@use='WP' and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''))-9, 3)"/>
            </area_code>
          </xsl:if>
        </clinicians>
      </xsl:if>
      <xsl:if test="componentOf/encompassingEncounter/responsibleParty/assignedEntity/representedOrganization/name/text()">
        <person_facilities>
          <xsl:if test="component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/assignedPerson/name | component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom">
            <provider>
              <xsl:if test="component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/assignedPerson/name/family/text()">
                <last_name>
                  <xsl:value-of select="component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/assignedPerson/name/family/text()"/>
                </last_name>
              </xsl:if>
              <xsl:if test="component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/assignedPerson/name/given[1]/text()">
                <first_name>
                  <xsl:value-of select="component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/assignedPerson/name/given[1]/text()"/>
                </first_name>
              </xsl:if>
              <xsl:if test="component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/assignedPerson/name/given[2]/text()">
                <middle_name>
                  <xsl:value-of select="component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/assignedPerson/name/given[2]/text()"/>
                </middle_name>
              </xsl:if>
              <xsl:if test="substring(translate((component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom[@use='WP' and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''), string-length(translate((component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom[@use='WP' and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''))-6, 7)">
                <phone>
                  <xsl:value-of select="substring(translate((component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom[@use='WP' and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''), string-length(translate((component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom[@use='WP' and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''))-6, 7)"/>
                </phone>
              </xsl:if>
              <xsl:if test="substring(translate((component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom[@use='WP' and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''), string-length(translate((component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom[@use='WP' and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''))-9, 3)">
                <area_code>
                  <xsl:value-of select="substring(translate((component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom[@use='WP' and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''), string-length(translate((component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom[@use='WP' and starts-with(@value, 'tel')]/@value)[1], 'tel:+-() ', ''))-9, 3)"/>
                </area_code>
              </xsl:if>
              <xsl:if test="(component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom/@use)[1]">
                <phone_type>
                  <xsl:value-of select="(component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom/@use)[1]"/>
                </phone_type>
              </xsl:if>
              <xsl:if test="(component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom[starts-with(@value, 'mailto')])[1]/@value">
                <email>
                  <xsl:value-of select="substring((component/structuredBody/component/section[code[@code='46240-8']]/entry/encounter/performer/assignedEntity/telecom[starts-with(@value, 'mailto')])[1]/@value, string-length('mailto: '))"/>
                </email>
              </xsl:if>
            </provider>
          </xsl:if>
          <facility>
            <xsl:if test="componentOf/encompassingEncounter/location/healthCareFacility/location/name/text()">
              <name>
                <xsl:value-of select="componentOf/encompassingEncounter/location/healthCareFacility/location/name/text()"/>
              </name>
            </xsl:if>
            <xsl:if test="(componentOf/encompassingEncounter/location/healthCareFacility/location/addr/city)[1]/text()">
              <city>
                <xsl:value-of select="(componentOf/encompassingEncounter/location/healthCareFacility/location/addr/city)[1]/text()"/>
              </city>
            </xsl:if>
            <xsl:if test="(componentOf/encompassingEncounter/location/healthCareFacility/location/addr/postalCode)[1]/text()">
              <zipcode>
                <xsl:value-of select="(componentOf/encompassingEncounter/location/healthCareFacility/location/addr/postalCode)[1]/text()"/>
              </zipcode>
            </xsl:if>
            <xsl:if test="(componentOf/encompassingEncounter/location/healthCareFacility/location/addr/state)[1]/text()">
              <state>
                <xsl:value-of select="(componentOf/encompassingEncounter/location/healthCareFacility/location/addr/state)[1]/text()"/>
              </state>
            </xsl:if>
            <xsl:if test="(componentOf/encompassingEncounter/location/healthCareFacility/location/addr/streetAddressLine)[1]/text()">
              <street_name>
                <xsl:value-of select="(componentOf/encompassingEncounter/location/healthCareFacility/location/addr/streetAddressLine)[1]/text()"/>
              </street_name>
            </xsl:if>
          </facility>
          <xsl:if test="componentOf/encompassingEncounter/code/originalText/text()">
            <facility_visit_type>
              <xsl:value-of select="componentOf/encompassingEncounter/code/originalText/text()"/>
            </facility_visit_type>
            <!--<xsl:apply-templates select="component/structuredBody/component/section/entry/encounter/code/originalText/reference"/>-->
          </xsl:if>
          <!--
          <xsl:if test="componentOf/encompassingEncounter/dischargeDispositionCode/@displayName">
            <discharge_disposition>
              <xsl:value-of select="componentOf/encompassingEncounter/dischargeDispositionCode/@displayName"/>
            </discharge_disposition>
          </xsl:if>
          -->
          <xsl:if test="componentOf/encompassingEncounter/effectiveTime/low/@value">
            <admission_date>
              <!--<xsl:value-of select="concat(substring(componentOf/encompassingEncounter/effectiveTime/low/@value,0,5),'-',substring(componentOf/encompassingEncounter/effectiveTime/low/@value,5,2),'-',substring(componentOf/encompassingEncounter/effectiveTime/low/@value,7,2),'T',substring(componentOf/encompassingEncounter/effectiveTime/low/@value,9,2),':',substring(componentOf/encompassingEncounter/effectiveTime/low/@value,11,2),':',substring(componentOf/encompassingEncounter/effectiveTime/low/@value,13))"/>-->
              <xsl:value-of select="componentOf/encompassingEncounter/effectiveTime/low/@value"/>
            </admission_date>
          </xsl:if>
          <xsl:if test="componentOf/encompassingEncounter/effectiveTime/high/@value">
            <discharge_date>
              <!--<xsl:value-of select="concat(substring(componentOf/encompassingEncounter/effectiveTime/high/@value,0,5),'-',substring(componentOf/encompassingEncounter/effectiveTime/high/@value,5,2),'-',substring(componentOf/encompassingEncounter/effectiveTime/high/@value,7,2),'T',substring(componentOf/encompassingEncounter/effectiveTime/high/@value,9,2),':',substring(componentOf/encompassingEncounter/effectiveTime/high/@value,11,2),':',substring(componentOf/encompassingEncounter/effectiveTime/high/@value,13))"/>-->
              <xsl:value-of select="componentOf/encompassingEncounter/effectiveTime/high/@value"/>
            </discharge_date>
          </xsl:if>
          <xsl:if test="(/ClinicalDocument/recordTarget/patientRole/id[not(@root='2.16.840.1.113883.4.1') and @root='1.2.840.114350.1.13.162.2.7.5.737384.14']/@extension)">
            <medical_record_number>
              <xsl:value-of select="number(/ClinicalDocument/recordTarget/patientRole/id[not(@root='2.16.840.1.113883.4.1') and @root='1.2.840.114350.1.13.162.2.7.5.737384.14']/@extension)"/>
            </medical_record_number>
          </xsl:if>
        </person_facilities>
      </xsl:if>
      <!--
      <xsl:for-each select="component/structuredBody/component/section[code[@code='29549-3']]/entry/substanceAdministration">
        <treatments>
          <xsl:if test="consumable/manufacturedProduct/manufacturedMaterial/code/originalText/text()">
            <name>
              <xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/originalText/text()"/>
            </name>
          </xsl:if>
          <xsl:if test="consumable/manufacturedProduct/manufacturedMaterial/code/originalText/reference/@value">
            <xsl:apply-templates select="consumable/manufacturedProduct/manufacturedMaterial/code/originalText/reference"/>
          </xsl:if>
          <xsl:if test="consumable/manufacturedProduct/manufacturedMaterial/code/@code">
            <code>
              <xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@code"/>
            </code>
          </xsl:if>
          <xsl:if test="consumable/manufacturedProduct/manufacturedMaterial/code/@codeSystemName">
            <code_system>
              <xsl:value-of select="consumable/manufacturedProduct/manufacturedMaterial/code/@codeSystemName"/>
            </code_system>
          </xsl:if>
          <xsl:if test="../../title/text()">
            <status>
              <xsl:value-of select="../../title/text()"/>
            </status>
          </xsl:if>
          <xsl:if test="effectiveTime/low/@value">
            <date_of_treatment>
             <xsl:value-of select="concat(substring(effectiveTime/low/@value,0,5),'-',substring(effectiveTime/low/@value,5,2),'-',substring(effectiveTime/low/@value,7,2),'T',substring(effectiveTime/low/@value,9,2),':',substring(effectiveTime/low/@value,11,2),':',substring(effectiveTime/low/@value,13))"/>
             <xsl:value-of select="effectiveTime/low/@value"/>
            </date_of_treatment>
          </xsl:if>
          <xsl:if test="effectiveTime/high/@value">
            <treatment_stopped>
              <xsl:value-of select="concat(substring(effectiveTime/high/@value,0,5),'-',substring(effectiveTime/high/@value,5,2),'-',substring(effectiveTime/high/@value,7,2),'T',substring(effectiveTime/high/@value,9,2),':',substring(effectiveTime/high/@value,11,2),':',substring(effectiveTime/high/@value,13))"/>
              <xsl:value-of select="effectiveTime/high/@value"/>
            </treatment_stopped>
          </xsl:if>
          <xsl:if test="doseQuantity/@value">
            <dose_quantity>
              <xsl:value-of select="concat(doseQuantity/@value,' ', doseQuantity/@unit)"/>
            </dose_quantity>
          </xsl:if>
        </treatments>
      </xsl:for-each>
      -->
      <xsl:if test="componentOf/encompassingEncounter/location/healthCareFacility/location/name/text()">
        <diagnostic>
          <xsl:if test="componentOf/encompassingEncounter/location/healthCareFacility/location/name/text()">
            <name>
              <xsl:value-of select="componentOf/encompassingEncounter/location/healthCareFacility/location/name/text()"/>
            </name>
          </xsl:if>
          <xsl:if test="(componentOf/encompassingEncounter/location/healthCareFacility/location/addr/city)[1]/text()">
            <city>
              <xsl:value-of select="(componentOf/encompassingEncounter/location/healthCareFacility/location/addr/city)[1]/text()"/>
            </city>
          </xsl:if>
          <xsl:if test="(componentOf/encompassingEncounter/location/healthCareFacility/location/addr/postalCode)[1]/text()">
            <zipcode>
              <xsl:value-of select="(componentOf/encompassingEncounter/location/healthCareFacility/location/addr/postalCode)[1]/text()"/>
            </zipcode>
          </xsl:if>
          <xsl:if test="(componentOf/encompassingEncounter/location/healthCareFacility/location/addr/state)[1]/text()">
            <state>
              <xsl:value-of select="(componentOf/encompassingEncounter/location/healthCareFacility/location/addr/state)[1]/text()"/>
            </state>
          </xsl:if>
          <xsl:if test="(componentOf/encompassingEncounter/location/healthCareFacility/location/addr/streetAddressLine)[1]/text()">
            <street_name>
              <xsl:value-of select="(componentOf/encompassingEncounter/location/healthCareFacility/location/addr/streetAddressLine)[1]/text()"/>
            </street_name>
          </xsl:if>
        </diagnostic>
      </xsl:if>
      <xsl:if test="componentOf/encompassingEncounter/location/healthCareFacility/serviceProviderOrganization/name/text()">
        <reporting>
          <report_date>
            <xsl:value-of select="dateReported/text()"/>
          </report_date>
          <agency>
            <xsl:value-of select="componentOf/encompassingEncounter/location/healthCareFacility/serviceProviderOrganization/name/text()"/>
          </agency>
        </reporting>
      </xsl:if>
    </health>
  </xsl:template>
</xsl:stylesheet>

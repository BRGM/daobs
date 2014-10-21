<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:daobs="http://daobs.org"
                version="2.0">

  <xsl:output method="xml"
              encoding="UTF-8"
              include-content-type="yes"
              indent="yes"/>

  <!-- Aggregation criteria for searches. Could be null to report
  on all harvested records. Should be a valid member states code.
  TODO: Report territory with no data ?
  -->
  <xsl:param name="territory" select="''" as="xs:string"/>

  <xsl:param name="language" select="'eng'" as="xs:string"/>

  <!-- Date of creation of the report. Default current date time. -->
  <xsl:param name="creationDate" select="current-dateTime()"/>

  <!-- Date covered by the data used to compute the indicators.
  TODO: Should be based on the harvesting time of the records.
  -->
  <xsl:param name="reportingDate" select="current-dateTime()"/>

  <!-- TODO: What is the organization. Use user session information ?  -->
  <xsl:param name="organisationName" select="''"/>
  <xsl:param name="email" select="'you@organisation.org'"/>



  <xsl:variable name="dateFormat" as="xs:string"
                select="'[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]Z'"/>


  <xsl:template match="/">

    <xsl:message>##<xsl:value-of select="$territory"/></xsl:message>
    <ns2:Monitoring xmlns:ns2="http://inspire.jrc.ec.europa.eu/monitoringreporting/monitoring"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:schemaLocation="http://inspire.jrc.ec.europa.eu/monitoringreporting/monitoring
                      http://inspire-geoportal.ec.europa.eu/monitoringreporting/monitoring.xsd">
      <documentYear>
        <year><xsl:value-of select="format-dateTime($creationDate, '[Y0001]')"/></year>
        <month><xsl:value-of select="format-dateTime($creationDate, '[M01]')"/></month>
        <day><xsl:value-of select="format-dateTime($creationDate, '[D01]')"/></day>
      </documentYear>
      <memberState><xsl:value-of select="upper-case($territory)"/></memberState>
      <MonitoringMD>
        <organizationName><xsl:value-of select="$organisationName"/></organizationName>
        <email><xsl:value-of select="$email"/></email>
        <monitoringDate>
          <year><xsl:value-of select="format-dateTime($reportingDate, '[Y0001]')"/></year>
          <month><xsl:value-of select="format-dateTime($reportingDate, '[M01]')"/></month>
          <day><xsl:value-of select="format-dateTime($reportingDate, '[D01]')"/></day>
        </monitoringDate>
        <language><xsl:value-of select="$language"/></language>
      </MonitoringMD>
      <Indicators>
        <NnConformityIndicators>
          <NSi41><xsl:value-of select="//daobs:indicator[@id='NSi41']/daobs:value"/></NSi41>
          <NSi42><xsl:value-of select="//daobs:indicator[@id='NSi42']/daobs:value"/></NSi42>
          <NSi43><xsl:value-of select="//daobs:indicator[@id='NSi43']/daobs:value"/></NSi43>
          <NSi44><xsl:value-of select="//daobs:indicator[@id='NSi44']/daobs:value"/></NSi44>
          <NSi45><xsl:value-of select="//daobs:indicator[@id='NSi45']/daobs:value"/></NSi45>
          <NSi4><xsl:value-of select="//daobs:indicator[@id='NSi4']/daobs:value"/></NSi4>
          <NnConformity>
            <NSv41><xsl:value-of select="//daobs:variable[@id='NSv41']/daobs:value"/></NSv41>
            <NSv42><xsl:value-of select="//daobs:variable[@id='NSv42']/daobs:value"/></NSv42>
            <NSv43><xsl:value-of select="//daobs:variable[@id='NSv43']/daobs:value"/></NSv43>
            <NSv44><xsl:value-of select="//daobs:variable[@id='NSv44']/daobs:value"/></NSv44>
            <NSv45><xsl:value-of select="//daobs:variable[@id='NSv45']/daobs:value"/></NSv45>
            <NSv4><xsl:value-of select="//daobs:indicator[@id='NSv4']/daobs:value"/></NSv4>
          </NnConformity>
        </NnConformityIndicators>
        <GeoCoverageIndicators>
          <DSi11><xsl:value-of select="//daobs:indicator[@id='DSi11']/daobs:value"/></DSi11>
          <DSi12><xsl:value-of select="//daobs:indicator[@id='DSi12']/daobs:value"/></DSi12>
          <DSi13><xsl:value-of select="//daobs:indicator[@id='DSi13']/daobs:value"/></DSi13>
          <DSi1><xsl:value-of select="//daobs:indicator[@id='DSi1']/daobs:value"/></DSi1>
          <GeoCoverageSDS>
            <DSv11_ActArea><xsl:value-of select="//daobs:indicator[@id='DSv11_ActArea']/daobs:value"/></DSv11_ActArea>
            <DSv12_ActArea><xsl:value-of select="//daobs:indicator[@id='DSv12_ActArea']/daobs:value"/></DSv12_ActArea>
            <DSv13_ActArea><xsl:value-of select="//daobs:indicator[@id='DSv13_ActArea']/daobs:value"/></DSv13_ActArea>
            <DSv1_ActArea><xsl:value-of select="//daobs:indicator[@id='DSv1_ActArea']/daobs:value"/></DSv1_ActArea>
            <DSv11_RelArea><xsl:value-of select="//daobs:indicator[@id='DSv11_RelArea']/daobs:value"/></DSv11_RelArea>
            <DSv12_RelArea><xsl:value-of select="//daobs:indicator[@id='DSv12_RelArea']/daobs:value"/></DSv12_RelArea>
            <DSv13_RelArea><xsl:value-of select="//daobs:indicator[@id='DSv13_RelArea']/daobs:value"/></DSv13_RelArea>
            <DSv1_RelArea><xsl:value-of select="//daobs:indicator[@id='DSv1_RelArea']/daobs:value"/></DSv1_RelArea>
          </GeoCoverageSDS>
        </GeoCoverageIndicators>
        <UseNNindicators>
          <NSi31><xsl:value-of select="//daobs:indicator[@id='NSi31']/daobs:value"/></NSi31>
          <NSi32><xsl:value-of select="//daobs:indicator[@id='NSi32']/daobs:value"/></NSi32>
          <NSi33><xsl:value-of select="//daobs:indicator[@id='NSi33']/daobs:value"/></NSi33>
          <NSi34><xsl:value-of select="//daobs:indicator[@id='NSi34']/daobs:value"/></NSi34>
          <NSi35><xsl:value-of select="//daobs:indicator[@id='NSi35']/daobs:value"/></NSi35>
          <NSi3><xsl:value-of select="//daobs:indicator[@id='NSi3']/daobs:value"/></NSi3>
          <UseNN>
            <NSv31><xsl:value-of select="//daobs:variable[@id='NSv31']/daobs:value"/></NSv31>
            <NSv32><xsl:value-of select="//daobs:variable[@id='NSv32']/daobs:value"/></NSv32>
            <NSv33><xsl:value-of select="//daobs:variable[@id='NSv33']/daobs:value"/></NSv33>
            <NSv34><xsl:value-of select="//daobs:variable[@id='NSv34']/daobs:value"/></NSv34>
            <NSv35><xsl:value-of select="//daobs:variable[@id='NSv35']/daobs:value"/></NSv35>
            <NSv3><xsl:value-of select="//daobs:indicator[@id='NSv3']/daobs:value"/></NSv3>
          </UseNN>
        </UseNNindicators>
        <MetadataExistenceIndicators>
          <MDi11><xsl:value-of select="//daobs:indicator[@id='MDi11']/daobs:value"/></MDi11>
          <MDi12><xsl:value-of select="//daobs:indicator[@id='MDi12']/daobs:value"/></MDi12>
          <MDi13><xsl:value-of select="//daobs:indicator[@id='MDi13']/daobs:value"/></MDi13>
          <MDi14><xsl:value-of select="//daobs:indicator[@id='MDi14']/daobs:value"/></MDi14>
          <MDi1><xsl:value-of select="//daobs:indicator[@id='MDi1']/daobs:value"/></MDi1>
          <MetadataExistence>
            <MDv11><xsl:value-of select="//daobs:variable[@id='MDv11']/daobs:value"/></MDv11>
            <MDv12><xsl:value-of select="//daobs:variable[@id='MDv12']/daobs:value"/></MDv12>
            <MDv13><xsl:value-of select="//daobs:variable[@id='MDv13']/daobs:value"/></MDv13>
            <MDv1_DS><xsl:value-of select="//daobs:indicator[@id='MDv1_DS']/daobs:value"/></MDv1_DS>
            <MDv14><xsl:value-of select="//daobs:variable[@id='MDv14']/daobs:value"/></MDv14>
          </MetadataExistence>
        </MetadataExistenceIndicators>
        <DiscoveryMetadataIndicators>
          <NSi11><xsl:value-of select="//daobs:indicator[@id='NSi11']/daobs:value"/></NSi11>
          <NSi12><xsl:value-of select="//daobs:indicator[@id='NSi12']/daobs:value"/></NSi12>
          <NSi1><xsl:value-of select="//daobs:indicator[@id='NSi1']/daobs:value"/></NSi1>
          <DiscoveryMetadata>
            <NSv11><xsl:value-of select="//daobs:variable[@id='NSv11']/daobs:value"/></NSv11>
            <NSv12><xsl:value-of select="//daobs:variable[@id='NSv12']/daobs:value"/></NSv12>
          </DiscoveryMetadata>
        </DiscoveryMetadataIndicators>
        <ViewDownloadAccessibilityIndicators>
          <NSi21><xsl:value-of select="//daobs:indicator[@id='NSi21']/daobs:value"/></NSi21>
          <NSi22><xsl:value-of select="//daobs:indicator[@id='NSi22']/daobs:value"/></NSi22>
          <NSi2><xsl:value-of select="//daobs:indicator[@id='NSi2']/daobs:value"/></NSi2>
          <ViewDownloadAccessibility>
            <NSv21><xsl:value-of select="//daobs:variable[@id='NSv21']/daobs:value"/></NSv21>
            <NSv22><xsl:value-of select="//daobs:variable[@id='NSv22']/daobs:value"/></NSv22>
            <NSv23><xsl:value-of select="//daobs:variable[@id='NSv23']/daobs:value"/></NSv23>
          </ViewDownloadAccessibility>
        </ViewDownloadAccessibilityIndicators>
        <SpatialDataAndService>
          <DSv_Num1><xsl:value-of select="//daobs:variable[@id='DSv_Num1']/daobs:value"/></DSv_Num1>
          <DSv_Num2><xsl:value-of select="//daobs:variable[@id='DSv_Num2']/daobs:value"/></DSv_Num2>
          <DSv_Num3><xsl:value-of select="//daobs:variable[@id='DSv_Num3']/daobs:value"/></DSv_Num3>
          <DSv_Num><xsl:value-of select="//daobs:variable[@id='DSv_Num']/daobs:value"/></DSv_Num>
          <SDSv_Num><xsl:value-of select="//daobs:variable[@id='SDSv_Num']/daobs:value"/></SDSv_Num>
          <NSv_NumDiscServ><xsl:value-of select="//daobs:variable[@id='NSv_NumDiscServ']/daobs:value"/></NSv_NumDiscServ>
          <NSv_NumViewServ><xsl:value-of select="//daobs:variable[@id='NSv_NumViewServ']/daobs:value"/></NSv_NumViewServ>
          <NSv_NumDownServ><xsl:value-of select="//daobs:variable[@id='NSv_NumDownlServ']/daobs:value"/></NSv_NumDownServ>
          <NSv_NumInvkServ><xsl:value-of select="//daobs:variable[@id='NSv_NumInvkServ']/daobs:value"/></NSv_NumInvkServ>
          <NSv_NumAllServ><xsl:value-of select="//daobs:variable[@id='NSv_NumAllServ']/daobs:value"/></NSv_NumAllServ>
          <NSv_NumTransfServ><xsl:value-of select="//daobs:indicator[@id='NSv_NumTransfServ']/daobs:value"/></NSv_NumTransfServ>
        </SpatialDataAndService>
        <MetadataConformityIndicators>
          <MDi21><xsl:value-of select="//daobs:indicator[@id='MDi21']/daobs:value"/></MDi21>
          <MDi22><xsl:value-of select="//daobs:indicator[@id='MDi22']/daobs:value"/></MDi22>
          <MDi23><xsl:value-of select="//daobs:indicator[@id='MDi23']/daobs:value"/></MDi23>
          <MDi24><xsl:value-of select="//daobs:indicator[@id='MDi24']/daobs:value"/></MDi24>
          <MDi2><xsl:value-of select="//daobs:indicator[@id='MDi2']/daobs:value"/></MDi2>
          <MetadataConformity>
            <MDv21><xsl:value-of select="//daobs:variable[@id='MDv21']/daobs:value"/></MDv21>
            <MDv22><xsl:value-of select="//daobs:variable[@id='MDv22']/daobs:value"/></MDv22>
            <MDv23><xsl:value-of select="//daobs:variable[@id='MDv23']/daobs:value"/></MDv23>
            <MDv2_DS><xsl:value-of select="//daobs:variable[@id='MDv2_DS']/daobs:value"/></MDv2_DS>
            <MDv24><xsl:value-of select="//daobs:variable[@id='MDv24']/daobs:value"/></MDv24>
          </MetadataConformity>
        </MetadataConformityIndicators>
        <SdsConformantIndicators>
          <DSi21><xsl:value-of select="//daobs:indicator[@id='DSi21']/daobs:value"/></DSi21>
          <DSi22><xsl:value-of select="//daobs:indicator[@id='DSi22']/daobs:value"/></DSi22>
          <DSi23><xsl:value-of select="//daobs:indicator[@id='DSi23']/daobs:value"/></DSi23>
          <DSi2><xsl:value-of select="//daobs:indicator[@id='DSi2']/daobs:value"/></DSi2>
          <SdsConformant>
            <DSv21><xsl:value-of select="//daobs:variable[@id='DSv21']/daobs:value"/></DSv21>
            <DSv22><xsl:value-of select="//daobs:variable[@id='DSv22']/daobs:value"/></DSv22>
            <DSv23><xsl:value-of select="//daobs:variable[@id='DSv23']/daobs:value"/></DSv23>
            <DSv2><xsl:value-of select="//daobs:indicator[@id='DSv2']/daobs:value"/></DSv2>
          </SdsConformant>
        </SdsConformantIndicators>
      </Indicators>
    </ns2:Monitoring>
  </xsl:template>
</xsl:stylesheet>
<?xml version="1.0"?>
<?mso-application progid="Excel.Sheet"?>
<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40">
 <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
  <Author>Administrator</Author>
  <LastAuthor>EIT</LastAuthor>
  <Created>2017-11-28T10:16:20Z</Created>
  <LastSaved>2017-11-28T10:18:50Z</LastSaved>
  <Version>15.00</Version>
 </DocumentProperties>
 <CustomDocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
  <KSOProductBuildVer dt:dt="string">2052-8.1.0.2424</KSOProductBuildVer>
 </CustomDocumentProperties>
 <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
  <AllowPNG/>
 </OfficeDocumentSettings>
 <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
  <WindowHeight>12480</WindowHeight>
  <WindowWidth>28800</WindowWidth>
  <WindowTopX>0</WindowTopX>
  <WindowTopY>0</WindowTopY>
  <ProtectStructure>False</ProtectStructure>
  <ProtectWindows>False</ProtectWindows>
 </ExcelWorkbook>
 <Styles>
  <Style ss:ID="Default" ss:Name="Normal">
   <Alignment ss:Vertical="Center"/>
   <Borders/>
   <Font ss:FontName="宋体" x:CharSet="134" ss:Size="12"/>
   <Interior/>
   <NumberFormat/>
   <Protection/>
  </Style>
  <Style ss:ID="s63">
   <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
   <Font ss:FontName="DengXian" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s65">
   <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
   <Font ss:FontName="DengXian" x:Family="Swiss" ss:Size="12" ss:Color="#FF0000"/>
  </Style>
  <Style ss:ID="s66">
   <Alignment ss:Vertical="Bottom"/>
   <Font ss:FontName="DengXian" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s68">
   <Alignment ss:Vertical="Bottom"/>
   <Font ss:FontName="宋体" x:CharSet="134" ss:Size="12" ss:Color="#000000"/>
  </Style>
 </Styles>
 <Worksheet ss:Name="Sheet1">
  <Table ss:ExpandedColumnCount="18" ss:ExpandedRowCount="${members?size + 10}" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="54" ss:DefaultRowHeight="14.25">
   <Column ss:Index="9" ss:Width="101.25"/>
   <Column ss:Index="13" ss:Width="61.5"/>
   <Column ss:Index="15" ss:Width="69.75"/>
   <Column ss:Index="17" ss:AutoFitWidth="0" ss:Width="66"/>
   <Column ss:AutoFitWidth="0" ss:Width="72"/>
   <Row ss:Height="15">
    <Cell ss:StyleID="s63"><Data ss:Type="String">姓名</Data></Cell>
    <Cell ss:StyleID="s63"><Data ss:Type="String">证件类型</Data></Cell>
    <Cell ss:StyleID="s63"><Data ss:Type="String">证件编号</Data></Cell>
    <Cell ss:StyleID="s63"><Data ss:Type="String">手机号</Data></Cell>
    <Cell ss:StyleID="s63"><Data ss:Type="String">学历</Data></Cell>
    <Cell ss:StyleID="s63"><Data ss:Type="String">服务类型</Data></Cell>
    <Cell ss:StyleID="s63"><Data ss:Type="String">服务名称</Data></Cell>
    <Cell ss:StyleID="s63"><Data ss:Type="String">变更内容</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">社保/公积金编号</Data></Cell>
    <Cell ss:StyleID="s63"><Data ss:Type="String">缴金地</Data></Cell>
    <Cell ss:StyleID="s63"><Data ss:Type="String">经办机构</Data></Cell>
    <Cell ss:StyleID="s63"><Data ss:Type="String">办理方</Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String">档次/比例</Data></Cell>
    <Cell ss:StyleID="s63"><Data ss:Type="String">基数</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">服务起始月</Data></Cell>
    <Cell ss:StyleID="s63"><Data ss:Type="String">备注</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">办理结果</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">原因</Data></Cell>
   </Row>
    [#list members as m]
        <Row>
            <Cell><Data ss:Type="String">${m.memberName}</Data></Cell>
            <Cell><Data ss:Type="String">${m.idCardType}</Data></Cell>
            <Cell><Data ss:Type="String">${m.idCard}</Data></Cell>
            <Cell><Data ss:Type="String">${m.phone}</Data></Cell>
            <Cell><Data ss:Type="String">${m.educationName}</Data></Cell>
            <Cell><Data ss:Type="String">${m.serviceType}</Data></Cell>
            <Cell><Data ss:Type="String">${m.serviceName}</Data></Cell>
            <Cell><Data ss:Type="String">${m.contentOfChange}</Data></Cell>
            <Cell><Data ss:Type="String">${m.serialNumber}</Data></Cell>
            <Cell><Data ss:Type="String">${m.payPlaceName}</Data></Cell>
            <Cell><Data ss:Type="String">${m.orgnaizationName}</Data></Cell>
            <Cell><Data ss:Type="String">${m.transactName}</Data></Cell>
            <Cell><Data ss:Type="String">${m.levelName}</Data></Cell>
            <Cell><Data ss:Type="String">${m.baseNumber}</Data></Cell>
            <Cell><Data ss:Type="String">${(m.serviceStartMonth?string("yyyy-MM-dd"))?default("--")}</Data></Cell>
            <Cell><Data ss:Type="String">${m.remark}</Data></Cell>
            <Cell><Data ss:Type="String"></Data></Cell>
            <Cell><Data ss:Type="String"></Data></Cell>
        </Row>
    [/#list]
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.51180555555555551"/>
    <Footer x:Margin="0.51180555555555551"/>
   </PageSetup>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <HorizontalResolution>600</HorizontalResolution>
    <VerticalResolution>600</VerticalResolution>
   </Print>
   <PageBreakZoom>100</PageBreakZoom>
   <Selected/>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>14</ActiveRow>
     <ActiveCol>11</ActiveCol>
     <RangeSelection>R15C11:R15C12</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="Sheet2">
  <Table ss:ExpandedColumnCount="1" ss:ExpandedRowCount="1" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="54" ss:DefaultRowHeight="14.25">
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.51180555555555551"/>
    <Footer x:Margin="0.51180555555555551"/>
   </PageSetup>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <VerticalResolution>0</VerticalResolution>
   </Print>
   <PageBreakZoom>100</PageBreakZoom>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="Sheet3">
  <Table ss:ExpandedColumnCount="1" ss:ExpandedRowCount="1" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="54" ss:DefaultRowHeight="14.25">
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.51180555555555551"/>
    <Footer x:Margin="0.51180555555555551"/>
   </PageSetup>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <VerticalResolution>0</VerticalResolution>
   </Print>
   <PageBreakZoom>100</PageBreakZoom>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
</Workbook>

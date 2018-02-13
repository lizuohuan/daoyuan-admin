<?xml version="1.0"?>
<?mso-application progid="Excel.Sheet"?>
<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40">
 <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
  <Author>EIT</Author>
  <LastAuthor>EIT</LastAuthor>
  <Created>2017-11-28T07:05:17Z</Created>
  <LastSaved>2017-11-28T07:07:37Z</LastSaved>
  <Company>www.zmeit.jd.com</Company>
  <Version>15.00</Version>
 </DocumentProperties>
 <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
  <AllowPNG/>
 </OfficeDocumentSettings>
 <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
  <WindowHeight>13035</WindowHeight>
  <WindowWidth>27870</WindowWidth>
  <WindowTopX>0</WindowTopX>
  <WindowTopY>0</WindowTopY>
  <ProtectStructure>False</ProtectStructure>
  <ProtectWindows>False</ProtectWindows>
 </ExcelWorkbook>
 <Styles>
  <Style ss:ID="Default" ss:Name="Normal">
   <Alignment ss:Vertical="Center"/>
   <Borders/>
   <Font ss:FontName="宋体" x:CharSet="134" ss:Size="11" ss:Color="#000000"/>
   <Interior/>
   <NumberFormat/>
   <Protection/>
  </Style>
  <Style ss:ID="s62">
   <NumberFormat ss:Format="@"/>
  </Style>
 </Styles>
 <Worksheet ss:Name="Sheet1">
  <Table ss:ExpandedColumnCount="7" ss:ExpandedRowCount="2" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="54" ss:DefaultRowHeight="13.5">
   <Column ss:Index="2" ss:StyleID="s62" ss:Width="123"/>
   <Column ss:Index="5" ss:StyleID="s62" ss:AutoFitWidth="0" ss:Span="2"/>
   <Row>
    <Cell><Data ss:Type="String">姓名</Data></Cell>
    <Cell><Data ss:Type="String">身份证号码</Data></Cell>
    <Cell><Data ss:Type="String">人员类别</Data></Cell>
    <Cell><Data ss:Type="String">文化程度</Data></Cell>
    <Cell><Data ss:Type="String">参保时间</Data></Cell>
    <Cell><Data ss:Type="String">申报工资</Data></Cell>
    <Cell><Data ss:Type="String">电话号码</Data></Cell>
   </Row>
   [#list members as m]
       <Row>
           <Cell><Data ss:Type="String">${m.userName}</Data></Cell>
           <Cell><Data ss:Type="String">${m.certificateNum}</Data></Cell>
           <Cell><Data ss:Type="String">${m.categoryName}</Data></Cell>
           <Cell><Data ss:Type="String">${m.educationName}</Data></Cell>
           <Cell><Data ss:Type="String">${m.createTime?string("yyyy-MM-dd")}</Data></Cell>
           <Cell><Data ss:Type="String">${m.salary!"0"}</Data></Cell>
           <Cell><Data ss:Type="String">${m.phone!"--"}</Data></Cell>
       </Row>
   [/#list]

  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Selected/>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>15</ActiveRow>
     <ActiveCol>9</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
</Workbook>

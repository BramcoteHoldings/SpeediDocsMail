object frmNewFee: TfrmNewFee
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'New Fee'
  ClientHeight = 406
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object lblMatterDesc: TLabel
    Left = 180
    Top = 11
    Width = 153
    Height = 33
    AutoSize = False
    WordWrap = True
  end
  object lblClient: TLabel
    Left = 76
    Top = 49
    Width = 260
    Height = 15
    AutoSize = False
  end
  object Label3: TLabel
    Left = 33
    Top = 10
    Width = 38
    Height = 15
    Caption = 'Matter:'
  end
  object Label4: TLabel
    Left = 44
    Top = 73
    Width = 27
    Height = 15
    Caption = 'Date:'
  end
  object Label5: TLabel
    Left = 31
    Top = 100
    Width = 40
    Height = 15
    Caption = 'Author:'
  end
  object Label6: TLabel
    Left = 19
    Top = 126
    Width = 52
    Height = 15
    Caption = 'Template:'
  end
  object Label7: TLabel
    Left = 8
    Top = 149
    Width = 63
    Height = 15
    Caption = 'Description:'
  end
  object lblUnits: TLabel
    Left = 44
    Top = 252
    Width = 27
    Height = 15
    Caption = 'Units'
  end
  object Label9: TLabel
    Left = 126
    Top = 252
    Width = 23
    Height = 15
    Caption = 'Rate'
  end
  object Label10: TLabel
    Left = 217
    Top = 252
    Width = 44
    Height = 15
    Caption = 'Amount'
  end
  object Label11: TLabel
    Left = 28
    Top = 354
    Width = 43
    Height = 15
    Caption = 'Minutes'
  end
  object Label12: TLabel
    Left = 54
    Top = 327
    Width = 17
    Height = 15
    Caption = 'Tax'
  end
  object Label13: TLabel
    Left = 28
    Top = 279
    Width = 43
    Height = 15
    Caption = 'Tax Rate'
  end
  object Label14: TLabel
    Left = 8
    Top = 304
    Width = 63
    Height = 15
    Caption = 'Department'
  end
  object cmbTemplate: TJvDBLookupEdit
    Left = 76
    Top = 123
    Width = 261
    Height = 23
    DropDownCount = 10
    LookupDisplay = 'DESCR;BILLTYPE'
    LookupField = 'CODE'
    LookupSource = dsFeeBasisList
    TabOrder = 2
    Text = ''
    OnCloseUp = TemplateChange
  end
  object dfItems: TEdit
    Left = 47
    Top = 223
    Width = 24
    Height = 25
    TabOrder = 4
    Text = '0'
    Visible = False
  end
  object neUnits: TEdit
    Left = 76
    Top = 249
    Width = 29
    Height = 25
    Alignment = taRightJustify
    TabOrder = 5
    Text = '1'
    OnChange = neUnitsChange
  end
  object cbTaxType: TJvDBLookupEdit
    Left = 76
    Top = 276
    Width = 261
    Height = 23
    LookupDisplay = 'CODE'
    LookupField = 'CODE'
    LookupSource = dsTaxType
    TabOrder = 6
    Text = ''
    OnChange = cbTaxTypeChange
  end
  object cbDept: TJvDBLookupEdit
    Left = 76
    Top = 301
    Width = 261
    Height = 23
    LookupDisplay = 'CODE'
    LookupField = 'CODE'
    LookupSource = dsEmpDept
    TabOrder = 7
    Text = ''
  end
  object dtpCreated: TDateTimePicker
    Left = 76
    Top = 70
    Width = 99
    Height = 23
    Date = 40764.667509444440000000
    Time = 40764.667509444440000000
    TabOrder = 0
  end
  object neRate: TJvCalcEdit
    Left = 155
    Top = 249
    Width = 48
    Height = 23
    AutoSize = False
    DisplayFormat = '$,0.##'
    ShowButton = False
    TabOrder = 8
    DecimalPlacesAlwaysShown = False
  end
  object neAmount: TJvCalcEdit
    Left = 262
    Top = 249
    Width = 77
    Height = 23
    DisplayFormat = '$,0.##'
    ShowButton = False
    TabOrder = 9
    DecimalPlacesAlwaysShown = False
  end
  object neMinutes: TJvCalcEdit
    Left = 76
    Top = 353
    Width = 45
    Height = 23
    Enabled = False
    ShowButton = False
    TabOrder = 10
    DecimalPlacesAlwaysShown = False
  end
  object neTax: TJvCalcEdit
    Left = 76
    Top = 326
    Width = 88
    Height = 23
    DisplayFormat = '$,0.##'
    Enabled = False
    ReadOnly = True
    ShowButton = False
    TabOrder = 11
    DecimalPlacesAlwaysShown = False
  end
  object cbFeeBasis: TJvDBLookupEdit
    Left = 8
    Top = 492
    Width = 261
    Height = 23
    LookupDisplay = 'CODE'
    LookupField = 'CODE'
    TabOrder = 12
    Text = ''
  end
  object BitBtn1: TBitBtn
    Left = 177
    Top = 354
    Width = 75
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 13
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 258
    Top = 354
    Width = 75
    Height = 25
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 15
  end
  object cbAuthor: TcxLookupComboBox
    Left = 76
    Top = 97
    Properties.ClearKey = 46
    Properties.KeyFieldNames = 'CODE'
    Properties.ListColumns = <
      item
        FieldName = 'NAME'
      end>
    Properties.ListOptions.GridLines = glNone
    Properties.ListOptions.ShowHeader = False
    Properties.ListSource = dsFeeEarners
    Properties.OnChange = AuthorChange
    TabOrder = 1
    Width = 261
  end
  object mmoDesc: TcxMemo
    Left = 76
    Top = 150
    TabOrder = 3
    Height = 95
    Width = 262
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 387
    Width = 354
    Height = 19
    Panels = <
      item
        Width = 340
      end>
    ParentFont = True
    UseSystemFont = False
  end
  object btnEditMatter: TcxButtonEdit
    Left = 75
    Top = 7
    Properties.Buttons = <
      item
        Default = True
        Glyph.SourceDPI = 96
        Glyph.Data = {
          89504E470D0A1A0A0000000D4948445200000010000000100403000000EDDDE2
          520000000373424954080808DBE14FE000000027504C5445FFFFFFFF9900FF99
          00FF9900FF9900FF9900FF9900FF9900FF9900FF9900FF9900FF9900FF990080
          633F910000000D74524E5300334466778899AABBCCDDEEFFD17E4CC500000009
          7048597300000AF000000AF00142AC34980000002074455874536F6674776172
          65004D6163726F6D656469612046697265776F726B73204D58BB912A24000000
          3E49444154789C6360800113170108E388EB0208E300438B3110280019222E40
          3011C80083248603191D20B09DE1C01908208DB105C6009BEBE2E20C770500A3
          673AAFB9E89D040000000049454E44AE426082}
        Kind = bkGlyph
      end>
    Properties.OnButtonClick = btnEditMatterPropertiesButtonClick
    TabOrder = 16
    OnExit = btnEditMatterExit
    Width = 118
  end
  object qryMRUList: TOraQuery
    Session = dmSaveDoc.orsInsight
    SQL.Strings = (
      
        'SELECT trim(M.FILEID) as FILEID,trim(P.SEARCH) AS SEARCH, trim(M' +
        '.SHORTDESCR) AS SHORTDESCR, idx'
      'FROM MATTER M, PHONEBOOK P,OPENLIST O'
      'WHERE upper(O.AUTHOR) = upper(:P_Author)'
      'AND O.TYPE = :P_Type'
      'AND O.CODE = M.FILEID'
      'AND M.NCLIENT = P.NCLIENT'
      'union'
      'SELECT '#39'Search...'#39','#39#39','#39#39',999'
      'FROM dual'
      'ORDER BY 3')
    Left = 187
    Top = 34
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'P_Author'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'P_Type'
        Value = nil
      end>
  end
  object dsMRUList: TOraDataSource
    DataSet = qryMRUList
    Left = 326
    Top = 6
  end
  object dsFeeEarners: TOraDataSource
    DataSet = qFeeEarners
    Left = 352
    Top = 72
  end
  object dsFee: TOraDataSource
    DataSet = qryFee
    Left = 360
    Top = 168
  end
  object dsEmpDept: TOraDataSource
    DataSet = qryEmpDept
    Left = 328
    Top = 240
  end
  object dsFeeBasisList: TOraDataSource
    DataSet = qryFeeBasisList
    Left = 320
    Top = 280
  end
  object dsTaxType: TOraDataSource
    DataSet = qryTaxType
    Left = 320
    Top = 328
  end
  object qFeeEarners: TOraQuery
    Session = dmSaveDoc.orsInsight
    SQL.Strings = (
      'SELECT DISTINCT CODE, NAME, DEPT'
      'FROM'
      '(SELECT '
      'CODE, '
      'NAME,'
      'DEPT '
      'FROM EMPLOYEE '
      'WHERE'
      'ACTIVE = '#39'Y'#39' AND '
      'ISFEEEARNER = '#39'Y'#39
      'UNION ALL'
      'SELECT'
      'CODE,'
      'NAME,'
      'DEPT'
      'FROM EMPLOYEE'
      'WHERE'
      'CODE = :CODE)'
      'ORDER BY CODE')
    AutoCommit = False
    Left = 304
    Top = 72
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODE'
        Value = nil
      end>
    object qFeeEarnersCODE: TStringField
      FieldName = 'CODE'
      Size = 3
    end
    object qFeeEarnersNAME: TStringField
      FieldName = 'NAME'
      Size = 40
    end
    object qFeeEarnersDEPT: TStringField
      FieldName = 'DEPT'
      Size = 3
    end
  end
  object qryScaleCost: TOraQuery
    Session = dmSaveDoc.orsInsight
    SQL.Strings = (
      
        'SELECT nvl(AMOUNT,0) as amount, nvl(RATE,0) as rate, DESCR, UNIT' +
        ', ZERO_FEE '
      'FROM SCALECOST '
      'WHERE CODE = :P_Code')
    Left = 344
    Top = 120
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'P_Code'
        Value = nil
      end>
  end
  object qryFee: TSmartQuery
    Session = dmSaveDoc.orsInsight
    SQL.Strings = (
      'SELECT F.*, F.ROWID '
      'FROM '
      'FEE F '
      'WHERE F.NFEE = :P_Nfee')
    Left = 328
    Top = 168
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'P_Nfee'
        Value = nil
      end>
  end
  object qryEmpDept: TOraQuery
    Session = dmSaveDoc.orsInsight
    SQL.Strings = (
      'select * from empdept'
      'order by descr')
    Left = 197
    Top = 182
  end
  object qryFeeBasisList: TOraQuery
    Session = dmSaveDoc.orsInsight
    SQL.Strings = (
      'select CODE, CODE ||'#39' - '#39'||DESCR as descr, BILLTYPE '
      'from scalecost'
      'order by descr')
    Left = 257
    Top = 288
  end
  object qryTaxType: TOraQuery
    Session = dmSaveDoc.orsInsight
    SQL.Strings = (
      'select code,descr from taxtype')
    Left = 265
    Top = 328
  end
  object qryBillType: TOraQuery
    Session = dmSaveDoc.orsInsight
    SQL.Strings = (
      'SELECT f.billtype as BillType FROM FeeBasis f, Matter m'
      'WHERE f.code = m.feebasis'
      'AND m.nmatter = :p_nmatter')
    Left = 392
    Top = 360
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'p_nmatter'
        Value = nil
      end>
  end
end

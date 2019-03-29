object dmInsight: TdmInsight
  OldCreateOrder = False
  Height = 346
  Width = 447
  object orsInsight: TUniConnection
    ProviderName = 'Oracle'
    Options.KeepDesignConnected = False
    Options.LocalFailover = True
    Username = 'axiom'
    Password = 'AXIOM'
    Server = 'MARKETING'
    Connected = True
    LoginPrompt = False
    Left = 16
    Top = 14
  end
  object qryEmps: TUniQuery
    Connection = orsInsight
    Left = 33
    Top = 87
  end
  object dsPrecClassification: TUniDataSource
    DataSet = qryPrecClassification
    Left = 355
    Top = 210
  end
  object qryPrecClassification: TUniQuery
    Connection = orsInsight
    SQL.Strings = (
      'select * from PRECCLASSIFICATION')
    Left = 200
    Top = 193
  end
  object qryTmp: TUniQuery
    Connection = orsInsight
    Left = 252
    Top = 170
  end
  object qrySysFile: TUniQuery
    Connection = orsInsight
    SQL.Strings = (
      'SELECT * FROM SYSTEMFILE')
    Left = 120
    Top = 188
  end
  object qryEmployee: TUniQuery
    Connection = orsInsight
    SQL.Strings = (
      'select code, name from employee where active = '#39'Y'#39' order by code')
    Left = 35
    Top = 167
  end
  object dsEmployee: TUniDataSource
    DataSet = qryEmployee
    Left = 43
    Top = 232
  end
  object qryPrecCategory: TUniQuery
    Connection = orsInsight
    SQL.Strings = (
      'select * from PRECCATEGORY')
    Left = 103
    Top = 64
  end
  object dsPrecCategory: TUniDataSource
    DataSet = qryPrecCategory
    Left = 155
    Top = 24
  end
  object qryGetEntity: TUniQuery
    Connection = orsInsight
    SQL.Strings = (
      'SELECT VALUE,INTVALUE'
      'FROM SETTINGS '
      'WHERE EMP = :Emp'
      '  AND OWNER = :Owner'
      '  AND ITEM = :Item')
    Left = 238
    Top = 32
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'Emp'
      end
      item
        DataType = ftUnknown
        Name = 'Owner'
      end
      item
        DataType = ftUnknown
        Name = 'Item'
      end>
  end
  object qryMatterAttachments: TUniQuery
    Connection = orsInsight
    SQL.Strings = (
      'SELECT'
      '  DOC.DOCUMENT,'
      '  DOC.IMAGEINDEX,'
      '  DOC.FILE_EXTENSION,'
      '  DOC.DOC_NAME,'
      '  DOC.SEARCH,'
      '  DOC.DOC_CODE,'
      '  DOC.JURIS,'
      '  DOC.D_CREATE,'
      '  DOC.AUTH1,'
      '  DOC.D_MODIF,'
      '  DOC.AUTH2,'
      '  DOC.PATH,'
      '  DOC.DESCR,'
      '  DOC.FILEID,'
      '  DOC.DOCID,'
      '  DOC.NPRECCATEGORY,'
      '  DOC.NMATTER,'
      '  DOC.PRECEDENT_DETAILS,'
      '  DOC.NPRECCLASSIFICATION,'
      '  DOC.KEYWORDS,'
      '  DOC.DISPLAY_PATH,'
      '  DOC.EXTERNAL_ACCESS,'
      '  DOC.ROWID'
      'FROM'
      '  DOC'
      'where'
      '  DOCID = :DOCID')
    CachedUpdates = True
    AfterInsert = qryMatterAttachmentsAfterInsert
    Left = 290
    Top = 103
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DOCID'
      end>
    object qryMatterAttachmentsDOCUMENT: TBlobField
      FieldName = 'DOCUMENT'
      BlobType = ftOraBlob
    end
    object qryMatterAttachmentsIMAGEINDEX: TFloatField
      FieldName = 'IMAGEINDEX'
    end
    object qryMatterAttachmentsFILE_EXTENSION: TStringField
      FieldName = 'FILE_EXTENSION'
      Size = 5
    end
    object qryMatterAttachmentsDOC_NAME: TStringField
      FieldName = 'DOC_NAME'
      Size = 60
    end
    object qryMatterAttachmentsSEARCH: TStringField
      FieldName = 'SEARCH'
      Size = 85
    end
    object qryMatterAttachmentsDOC_CODE: TStringField
      FieldName = 'DOC_CODE'
      Size = 50
    end
    object qryMatterAttachmentsJURIS: TStringField
      FieldName = 'JURIS'
      Size = 50
    end
    object qryMatterAttachmentsD_CREATE: TDateTimeField
      FieldName = 'D_CREATE'
    end
    object qryMatterAttachmentsAUTH1: TStringField
      FieldName = 'AUTH1'
      Size = 3
    end
    object qryMatterAttachmentsD_MODIF: TDateTimeField
      FieldName = 'D_MODIF'
    end
    object qryMatterAttachmentsAUTH2: TStringField
      FieldName = 'AUTH2'
      Size = 3
    end
    object qryMatterAttachmentsPATH: TStringField
      FieldName = 'PATH'
      Size = 255
    end
    object qryMatterAttachmentsDESCR: TStringField
      FieldName = 'DESCR'
      Size = 400
    end
    object qryMatterAttachmentsFILEID: TStringField
      FieldName = 'FILEID'
    end
    object qryMatterAttachmentsDOCID: TFloatField
      FieldName = 'DOCID'
      Required = True
    end
    object qryMatterAttachmentsNPRECCATEGORY: TFloatField
      FieldName = 'NPRECCATEGORY'
    end
    object qryMatterAttachmentsNMATTER: TFloatField
      FieldName = 'NMATTER'
    end
    object qryMatterAttachmentsPRECEDENT_DETAILS: TStringField
      FieldName = 'PRECEDENT_DETAILS'
      Size = 2048
    end
    object qryMatterAttachmentsNPRECCLASSIFICATION: TFloatField
      FieldName = 'NPRECCLASSIFICATION'
    end
    object qryMatterAttachmentsKEYWORDS: TStringField
      FieldName = 'KEYWORDS'
      Size = 2048
    end
    object qryMatterAttachmentsDISPLAY_PATH: TStringField
      FieldName = 'DISPLAY_PATH'
      Size = 255
    end
    object qryMatterAttachmentsEXTERNAL_ACCESS: TStringField
      FieldName = 'EXTERNAL_ACCESS'
      Size = 1
    end
    object qryMatterAttachmentsROWID: TStringField
      FieldName = 'ROWID'
      ReadOnly = True
      Size = 18
    end
  end
  object qryFeeInsert: TUniQuery
    Connection = orsInsight
    SQL.Strings = (
      'INSERT INTO FEE '
      '    (CREATED, DESCR, MINS, AUTHOR, PARTNER, RATE, AMOUNT,'
      '     NMATTER, BILLED, UNIT, BANK_ACCT, TASK,'
      
        '     DEPT, EMP_TYPE, UNITS, NCLIENT, FILEID, PRIVATE, TYPE, TAXC' +
        'ODE, TAX)'
      'VALUES'
      '    (:CREATED, :DESCR, :MINS, :AUTHOR, :PARTNER, :RATE, :AMOUNT,'
      '     :NMATTER, '#39'N'#39', :UNIT, :BANK_ACCT, :TASK, '
      
        '     :DEPT, :EMP_TYPE, :UNITS, :NCLIENT, :FILEID, '#39'N'#39', '#39'N'#39', :TAX' +
        'CODE, :TAX)')
    Left = 160
    Top = 124
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CREATED'
      end
      item
        DataType = ftUnknown
        Name = 'DESCR'
      end
      item
        DataType = ftUnknown
        Name = 'MINS'
      end
      item
        DataType = ftUnknown
        Name = 'AUTHOR'
      end
      item
        DataType = ftUnknown
        Name = 'PARTNER'
      end
      item
        DataType = ftUnknown
        Name = 'RATE'
      end
      item
        DataType = ftUnknown
        Name = 'AMOUNT'
      end
      item
        DataType = ftUnknown
        Name = 'NMATTER'
      end
      item
        DataType = ftUnknown
        Name = 'UNIT'
      end
      item
        DataType = ftUnknown
        Name = 'BANK_ACCT'
      end
      item
        DataType = ftUnknown
        Name = 'TASK'
      end
      item
        DataType = ftUnknown
        Name = 'DEPT'
      end
      item
        DataType = ftUnknown
        Name = 'EMP_TYPE'
      end
      item
        DataType = ftUnknown
        Name = 'UNITS'
      end
      item
        DataType = ftUnknown
        Name = 'NCLIENT'
      end
      item
        DataType = ftUnknown
        Name = 'FILEID'
      end
      item
        DataType = ftUnknown
        Name = 'TAXCODE'
      end
      item
        DataType = ftUnknown
        Name = 'TAX'
      end>
  end
  object qryEntity: TUniQuery
    Connection = orsInsight
    SQL.Strings = (
      'SELECT CODE, NAME, LOCKDATE, ABN'
      'FROM ENTITY '
      'WHERE CODE = :Entity')
    ReadOnly = True
    Left = 132
    Top = 248
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'Entity'
      end>
    object qryEntityCODE: TStringField
      FieldName = 'CODE'
      Size = 2
    end
    object qryEntityNAME: TStringField
      FieldName = 'NAME'
      Size = 60
    end
    object qryEntityLOCKDATE2: TDateTimeField
      FieldName = 'LOCKDATE'
    end
    object qryEntityABN: TStringField
      FieldName = 'ABN'
      Size = 30
    end
  end
  object qryGetSeq: TUniQuery
    Connection = orsInsight
    SQL.Strings = (
      'select DOC_DOCID.nextval as nextdoc from dual')
    Left = 319
    Top = 29
  end
  object OracleUniProvider1: TOracleUniProvider
    Left = 80
    Top = 8
  end
  object qryMRUList: TUniQuery
    Connection = orsInsight
    SQL.Strings = (
      
        'SELECT trim(M.FILEID) as FILEID,trim(P.SEARCH) AS SEARCH, trim(M' +
        '.SHORTDESCR) AS SHORTDESCR, idx'
      'FROM MATTER M, PHONEBOOK P,OPENLIST O'
      'WHERE O.AUTHOR = :P_Author'
      'AND O.TYPE = :P_Type'
      'AND O.CODE = M.FILEID'
      'AND M.NCLIENT = P.NCLIENT'
      'union'
      'SELECT '#39'Search...'#39','#39#39','#39#39',999'
      'FROM dual'
      'ORDER BY 3')
    Left = 368
    Top = 80
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'P_Author'
      end
      item
        DataType = ftUnknown
        Name = 'P_Type'
      end>
  end
  object qryMatter: TUniQuery
    Connection = orsInsight
    Left = 240
    Top = 264
  end
  object qryFee: TUniQuery
    Connection = orsInsight
    Left = 336
    Top = 280
  end
end

object dmSaveDoc: TdmSaveDoc
  OldCreateOrder = True
  Height = 462
  Width = 550
  object qryFeeInsert: TOraSQL
    SQL.Strings = (
      'INSERT INTO FEE '
      '    (NFEE, CREATED, DESCR, MINS, AUTHOR, PARTNER, RATE, AMOUNT,'
      '     NMATTER, BILLED, UNIT, BANK_ACCT, TASK,'
      
        '     DEPT, EMP_TYPE, UNITS, NCLIENT, FILEID, PRIVATE, TYPE, TAXC' +
        'ODE, TAX, PROGRAM_NAME)'
      'VALUES'
      
        '    (SQNC_NFEE.NEXTVAL,:CREATED, :DESCR, :MINS, :AUTHOR, :PARTNE' +
        'R, :RATE, :AMOUNT,'
      '     :NMATTER, '#39'N'#39', :UNIT, :BANK_ACCT, :TASK, '
      
        '     :DEPT, :EMP_TYPE, :UNITS, :NCLIENT, :FILEID, '#39'N'#39', '#39'N'#39', :TAX' +
        'CODE, :TAX, '#39'SPEEDIDOCS'#39')')
    Left = 250
    Top = 76
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CREATED'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DESCR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'MINS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'AUTHOR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PARTNER'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'RATE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'AMOUNT'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NMATTER'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'UNIT'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'BANK_ACCT'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TASK'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DEPT'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'EMP_TYPE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'UNITS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NCLIENT'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'FILEID'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TAXCODE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TAX'
        Value = nil
      end>
  end
  object procTemp: TOraStoredProc
    Session = orsInsight
    Left = 33
    Top = 202
  end
  object qryGetMatter: TOraQuery
    Session = orsInsight
    SQL.Strings = (
      'select fileid, nmatter '
      'from'
      'matter'
      'where'
      'fileid = :fileid')
    Left = 165
    Top = 68
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'fileid'
        Value = nil
      end>
  end
  object orsInsight: TOraSession
    Options.EnableLargeint = True
    Options.Direct = True
    Options.IPVersion = ivIPBoth
    Options.KeepDesignConnected = False
    Options.LocalFailover = True
    Username = 'abc'
    Server = '192.168.0.22:1521:marketing'
    LoginPrompt = False
    OnError = orsInsightError
    OnConnectionLost = orsInsightConnectionLost
    Left = 34
    Top = 8
    EncryptedPassword = '9EFF9DFF9CFF'
  end
  object qryEmps: TOraQuery
    Session = orsInsight
    Left = 170
    Top = 11
  end
  object qryGetSeq: TOraQuery
    Session = orsInsight
    SQL.Strings = (
      'select DOC_DOCID.nextval as nextdoc from dual')
    Left = 112
    Top = 8
  end
  object qryMatterAttachments: TSmartQuery
    Session = orsInsight
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
      '  DOC.EMAIL_FROM,'
      '  DOC.EMAIL_SENT_TO,'
      '  DOC.FOLDER_ID,'
      '  DOC.ROWID'
      'FROM'
      '  DOC'
      'where'
      '  DOCID = :DOCID')
    CachedUpdates = True
    OnNewRecord = qryMatterAttachmentsNewRecord
    Left = 49
    Top = 65
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DOCID'
        Value = nil
      end>
  end
  object qryGetEntity: TOraQuery
    Session = orsInsight
    SQL.Strings = (
      'SELECT VALUE,INTVALUE'
      'FROM SETTINGS '
      'WHERE EMP = :Emp'
      '  AND OWNER = :Owner'
      '  AND ITEM = :Item')
    Left = 33
    Top = 125
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'Emp'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'Owner'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'Item'
        Value = nil
      end>
  end
  object qrySysFile: TOraQuery
    Session = orsInsight
    SQL.Strings = (
      'SELECT * FROM SYSTEMFILE')
    Left = 107
    Top = 123
  end
  object qryTmp: TSmartQuery
    Session = orsInsight
    Left = 180
    Top = 123
  end
  object qryCheckEmail: TOraQuery
    Session = orsInsight
    SQL.Strings = (
      'select 1 as rec_found'
      'from '
      'doc'
      'where'
      'trim(descr)= trim(:descr)'
      'and'
      
        'To_date(TO_CHAR(:d_create, '#39'DD/MM/YYYY HH:MI:SS'#39'),'#39'DD/MM/YYYY HH' +
        ':MI:SS'#39') between To_date(TO_CHAR(d_create - (2 / (24*60*60)), '#39'D' +
        'D/MM/YYYY HH:MI:SS'#39'),'#39'DD/MM/YYYY HH:MI:SS'#39') '
      
        '  and To_date(TO_CHAR(d_create + (10 / (24*60*60)), '#39'DD/MM/YYYY ' +
        'HH:MI:SS'#39'),'#39'DD/MM/YYYY HH:MI:SS'#39')'
      'and '
      'fileid = :fileid')
    Left = 106
    Top = 202
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'descr'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'd_create'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'fileid'
        Value = nil
      end>
  end
  object tbDocGroups: TOraTable
    TableName = 'WORKFLOWDOCGROUPS'
    OrderFields = 'name'
    KeyFields = 'groupid'
    Session = orsInsight
    Left = 260
    Top = 12
  end
  object qryDoctemplate: TSmartQuery
    Session = orsInsight
    SQL.Strings = (
      'SELECT '
      'W.DOCID, W.DOCTYPE, W.PARTYTYPE, '
      '   W.DOCUMENTNAME, W.DOCUMENTPATH, W.TEMPLATEPATH, '
      '   W.DATAFILEPATH, W.WORKFLOWTYPECODE, W.OTHERPARTY1, '
      '   W.OTHERPARTY2, W.OTHERPARTY3, W.GROUPID, '
      '   W.REFERREDOPTIONAL, W.DATAFORM, W.WORKFLOW_ONLY, '
      '   W.ACTIVE, W.NPRECCATEGORY, W.NPRECCLASSIFICATION, '
      '   W.IMANAGE_DOC,W.DESCRIPTION, W.TEMPLATETYPE, W.ROWID'
      'FROM WORKFLOWDOCTEMPLATES W'
      'WHERE'
      'W.DOCID = :DOCID')
    CachedUpdates = True
    OnNewRecord = qryDocTemplateNewRecord
    Left = 259
    Top = 129
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DOCID'
        Value = nil
      end>
  end
  object qryFeeTmpInsert: TOraSQL
    Session = orsInsight
    SQL.Strings = (
      'INSERT INTO FEETMP '
      '    (CREATED, REASON, MINS, AUTHOR, RATE, AMOUNT,'
      '     NMATTER, UNIT, FEE_TEMPLATE, TIME_TYPE,'
      
        '     EMP_TYPE, UNITS, FILEID, TYPE, TAXCODE, TAX, EMPCODE, LABEL' +
        'COLOUR, STATE,'
      
        '     RESOURCEID, OPTIONS,EVENT_TYPE, MATLOCATE, CAPTION, PROGRAM' +
        '_NAME, VERSION,'
      '     START_DATE, END_DATE)'
      'VALUES'
      '    (:CREATED, :DESCR, :MINS, :AUTHOR, :RATE, :AMOUNT,'
      '     :NMATTER, :UNIT, :TASK, '#39'M'#39','
      
        '     :EMP_TYPE, :UNITS, :FILEID, '#39'N'#39', :TAXCODE, :TAX, :EMPCODE, ' +
        '794108, 2,'
      
        '     7, 2, 0, :MATLOCATE, :CAPTION, '#39'SPEEDIDOCS'#39', :VERSION, SYSD' +
        'ATE, SYSDATE+:MINS/1440)')
    Left = 352
    Top = 8
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CREATED'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DESCR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'MINS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'AUTHOR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'RATE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'AMOUNT'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NMATTER'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'UNIT'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TASK'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'EMP_TYPE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'UNITS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'FILEID'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TAXCODE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TAX'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'EMPCODE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'MATLOCATE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CAPTION'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VERSION'
        Value = nil
      end>
  end
  object qrySaveEmailAttachments: TOraQuery
    Session = orsInsight
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
      '  DOC.URL,'
      '  DOC.DISPLAY_PATH,'
      '  DOC.PARENTDOCID,'
      '  DOC.IS_ATTACHMENT,'
      '  DOC.FOLDER_ID,'
      '  DOC.ROWID'
      'FROM'
      '  DOC'
      'where'
      '  DOCID = :DOCID')
    CachedUpdates = True
    OnNewRecord = qrySaveEmailAttachmentsNewRecord
    Left = 350
    Top = 67
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DOCID'
        Value = nil
      end>
  end
  object qryDocs: TSmartQuery
    Session = orsInsight
    SQL.Strings = (
      'SELECT '
      '   DOCid, NMATTER,DOC_NAME,'
      '   D_CREATE, AUTH1, D_MODIF,'
      '   PATH,DESCR, FILEID, DOC_CODE,'
      
        '   IMAGEINDEX, FILE_EXTENSION, EMAIL_SENT_TO,'#39'DATAFILEPATH'#39',null' +
        ' as DATAFORM,'
      
        '   null as TEMPLATELINEID,'#39'FROMDOC'#39' as source, auth2, display_pa' +
        'th, URL,'
      
        '   tablevalue('#39'preccategory'#39','#39'npreccategory'#39',nvl(npreccategory,0' +
        '),'#39'descr'#39') as npreccategory ,'
      
        '   tablevalue('#39'precclassification'#39','#39'nprecclassification'#39',nvl(npr' +
        'ecclassification,0),'#39'descr'#39') as nprecclassification, external_ac' +
        'cess,'
      '   DOC_NOTES, ot_version, email_from, rowid'
      'FROM DOC'
      'where nmatter = nvl(:nmatter, nmatter)'
      'and PARENTDOCID is null'
      'order by 4 desc, 5 desc')
    Left = 193
    Top = 201
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'nmatter'
        Value = Null
      end>
  end
  object dsDocs: TOraDataSource
    DataSet = qryDocs
    Left = 29
    Top = 254
  end
  object qryMatterList: TOraQuery
    Session = orsInsight
    SQL.Strings = (
      'select m.fileid||'#39' '#39'||m.title matter_disp, m.nmatter '
      'from '
      'matter m, openlist o'
      'where m.closed = 0 and m.entity = nvl(:P_Entity, m.entity)'
      
        'AND O.AUTHOR = (select code from employee where upper(user_name)' +
        ' = upper(:P_Author)) '
      'AND O.TYPE = '#39'MATTER'#39' '
      'AND O.CODE = M.FILEID')
    FetchAll = True
    Left = 191
    Top = 256
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'P_Entity'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'P_Author'
        Value = nil
      end>
  end
  object dsMatterList: TOraDataSource
    DataSet = qryMatterList
    Left = 297
    Top = 261
  end
  object qryMatterDocs: TOraQuery
    Session = orsInsight
    SQL.Strings = (
      
        'SELECT   docid, nmatter, doc_name, d_create, auth1, d_modif, PAT' +
        'H, descr,'
      
        '         fileid, doc_code, imageindex, file_extension, display_p' +
        'ath,'
      '         ot_version, max_ot_version'
      
        '    FROM (SELECT docid, nmatter, doc_name, d_create, auth1, d_mo' +
        'dif, PATH,'
      
        '                 descr, fileid, doc_code, imageindex, file_exten' +
        'sion,'
      '                 display_path, external_access, ot_version,'
      
        '                 MAX (ot_version) OVER (PARTITION BY parentdocid' +
        ')'
      
        '                                                               m' +
        'ax_ot_version'
      '            FROM doc'
      '           WHERE nmatter = :nmatter AND is_attachment = '#39'N'#39')'
      '   WHERE ot_version = max_ot_version'
      'ORDER BY ot_version DESC, d_create DESC'
      ''
      ''
      '/*'
      'SELECT '
      '   DOCid, NMATTER,DOC_NAME,'
      '   D_CREATE, AUTH1, D_MODIF,'
      '   PATH,DESCR, FILEID, DOC_CODE,'
      
        '   IMAGEINDEX, FILE_EXTENSION, EMAIL_SENT_TO,'#39'DATAFILEPATH'#39',null' +
        ' as DATAFORM,'
      
        '   null as TEMPLATELINEID,'#39'FROMDOC'#39' as source, auth2, display_pa' +
        'th, URL,'
      
        '   tablevalue('#39'preccategory'#39','#39'npreccategory'#39',nvl(npreccategory,0' +
        '),'#39'descr'#39') as npreccategory ,'
      
        '   tablevalue('#39'precclassification'#39','#39'nprecclassification'#39',nvl(npr' +
        'ecclassification,0),'#39'descr'#39') as nprecclassification, external_ac' +
        'cess,'
      '   DOC_NOTES, ot_version, email_from, rowid'
      'FROM DOC'
      'where nmatter = :nmatter'
      'and PARENTDOCID is null'
      'order by 4 desc'
      '*/')
    Left = 273
    Top = 189
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'nmatter'
        Value = nil
      end>
  end
  object dsMatterDocs: TOraDataSource
    DataSet = qryMatterDocs
    Left = 356
    Top = 121
  end
  object qryMatters: TOraQuery
    Session = orsInsight
    SQL.Strings = (
      'select * from matter'
      'where closed = 0 and entity = nvl(:P_Entity, entity)')
    Left = 69
    Top = 327
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'P_Entity'
        Value = nil
      end>
  end
  object dsMatters: TOraDataSource
    DataSet = qryMatters
    Left = 133
    Top = 327
  end
  object qryPrecClassification: TOraQuery
    Session = orsInsight
    SQL.Strings = (
      'select * from PRECCLASSIFICATION'
      'order by descr')
    Left = 44
    Top = 380
  end
  object dsPrecClassification: TOraDataSource
    DataSet = qryPrecClassification
    Left = 174
    Top = 393
  end
  object qryPrecCategory: TOraQuery
    Session = orsInsight
    SQL.Strings = (
      'select * from PRECCATEGORY'
      'order by descr')
    Left = 237
    Top = 330
  end
  object dsPrecCategory: TOraDataSource
    DataSet = qryPrecCategory
    Left = 313
    Top = 326
  end
  object qryEmployee: TOraQuery
    Session = orsInsight
    SQL.Strings = (
      'select code, name '
      'from '
      'employee '
      'where active = '#39'Y'#39' '
      'order by code')
    Left = 389
    Top = 205
  end
  object dsEmployee: TOraDataSource
    DataSet = qryEmployee
    Left = 396
    Top = 264
  end
  object dsScaleCost: TOraDataSource
    DataSet = qryScaleCost
    Left = 458
    Top = 147
  end
  object qryScaleCost: TOraQuery
    Session = orsInsight
    SQL.Strings = (
      'SELECT '
      
        '  CODE, TYPE, CREATED, DESCR, NOTES, UNIT, PARENT, DAYS, DEFAULT' +
        'TIME, nvl(AMOUNT,0) AS AMOUNT,  '
      
        '  NVL(RATE,0) AS RATE, BILLTYPE, ZERO_FEE, PAID_YN, LEAVE_YN, AC' +
        'TIVE'
      ' FROM SCALECOST '
      'where active = '#39'Y'#39
      'ORDER BY CODE')
    Left = 466
    Top = 206
  end
  object dsMatterFolderList: TOraDataSource
    DataSet = qryMatterFolderList
    Left = 463
    Top = 295
  end
  object qryMatterFolderList: TOraQuery
    Session = orsInsight
    SQL.Strings = (
      
        'SELECT LPAD('#39'*'#39', 2*(level-1),'#39'*'#39' )||descr, folder_id, parent_id,' +
        ' folder_level, level'
      'FROM  document_folders'
      'where nmatter = :nmatter'
      'start with parent_id = 0'
      'connect by prior folder_id = parent_id'
      'ORDER siblings BY 2, 3')
    Left = 471
    Top = 354
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'nmatter'
        Value = nil
      end>
  end
  object qryNew: TOraQuery
    Session = orsInsight
    Left = 357
    Top = 386
  end
  object qryGetSeqPrec: TOraQuery
    Session = orsInsight
    SQL.Strings = (
      'select SEQ_WORKFLOWDOCTEMPLATES.NEXTVAL AS nextprec from dual')
    Left = 456
    Top = 16
  end
end

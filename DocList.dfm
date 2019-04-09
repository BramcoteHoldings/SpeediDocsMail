object frmDocList: TfrmDocList
  Left = 0
  Top = 0
  Caption = 'Document List'
  ClientHeight = 541
  ClientWidth = 655
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 508
    Width = 655
    Height = 33
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 490
    DesignSize = (
      655
      33)
    object edtMatter: TcxTextEdit
      Left = 56
      Top = 6
      TabOrder = 0
      Width = 119
    end
    object cxButton1: TcxButton
      Left = 490
      Top = 5
      Width = 73
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Select'
      ModalResult = 1
      TabOrder = 1
    end
    object cxButton2: TcxButton
      Left = 574
      Top = 5
      Width = 73
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 2
    end
    object btnSearch: TcxButton
      Left = 175
      Top = 5
      Width = 73
      Height = 25
      Caption = 'Search'
      OptionsImage.Glyph.SourceDPI = 96
      OptionsImage.Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00669999FF669999FFFF00FF00FF00FF000099
        99FF009999FF009999FF009999FF009999FF009999FFFF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00669999FF3399CCFF33CCCCFFFF00FF000099CCFF33CC
        FFFF33CCFFFF33CCFFFF66CCFFFF66CCFFFF33CCCCFF009999FFFF00FF00FF00
        FF00FF00FF00669999FF3399CCFF33CCFFFF66CCFFFF0099CCFF99FFFFFF66CC
        FFFF33CCFFFF33CCFFFF66CCFFFF66CCFFFF33CCFFFF3399CCFF009999FFFF00
        FF00808080FF3399CCFF33CCFFFF66CCFFFFFF00FF000099CCFF99FFFFFF66CC
        FFFF33CCFFFF33CCFFFF66CCCCFFB2B2B2FFCC9999FFCC9999FF969696FF8686
        86FF669999FF66CCFFFF66CCFFFFFF00FF00FF00FF000099CCFF99FFFFFF66CC
        FFFF33CCFFFF33CCFFFF996699FFFFECCCFFFFECCCFFF1F1F1FFFFECCCFFCCCC
        99FF969696FF66CCFFFFFF00FF00FF00FF00FF00FF000099CCFF99FFFFFFCCFF
        FFFFCCFFFFFFB2B2B2FFFFECCCFFF1F1F1FFFFECCCFFF1F1F1FFFFECCCFFFFEC
        CCFFCC9999FFFF00FF00FF00FF00FF00FF00FF00FF000099CCFFCCFFFFFF33CC
        CCFF3399CCFF868686FFF1F1F1FFFFECCCFFFFECCCFFF1F1F1FFFFECCCFFF0CA
        A6FFF0CAA6FF996699FFFF00FF00FF00FF00FF00FF000099CCFF33CCFFFF66CC
        FFFF33CCFFFFB2B2B2FFF1F1F1FFFFECCCFFF1F1F1FFF1F1F1FFF0CAA6FFF0CA
        A6FFF0CAA6FF996699FFFF00FF00FF00FF00FF00FF000099CCFF99FFFFFF66CC
        FFFF33CCFFFF868686FFFFECCCFFFFECCCFFFFECCCFFF0CAA6FFF0CAA6FFFFEC
        CCFFF0CAA6FF996699FFFF00FF00FF00FF00FF00FF000099CCFF99FFFFFF66CC
        FFFF33CCFFFF3399CCFFCCCC99FFFFECCCFFF0CAA6FFF0CAA6FFF1F1F1FFF1F1
        F1FF996699FFFF00FF00FF00FF00FF00FF00FF00FF000099CCFF99FFFFFF66CC
        FFFF33CCFFFF33CCFFFFB2B2B2FFCC9999FFF0CAA6FFF0CAA6FFF0CAA6FF9966
        99FF996699FFFF00FF00FF00FF00FF00FF00FF00FF000099CCFF99FFFFFF99FF
        FFFF66CCFFFF66CCFFFF99FFFFFF99CCCCFF868686FF808080FF868686FFFF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000099CCFFF1F1F1FFF1F1
        F1FFCCFFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF66CCFFFF009999FFFF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000099CCFFF1F1
        F1FFD6E7E7FFCCFFFFFF99FFFFFF99FFFFFF99FFFFFF009999FFFF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000099
        CCFF0099CCFF0099CCFF0099CCFF0099CCFF0099CCFFFF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      TabOrder = 3
      OnClick = btnSearchClick
    end
  end
  object gridDocList: TcxGrid
    Left = 0
    Top = 0
    Width = 655
    Height = 508
    Align = alClient
    TabOrder = 1
    ExplicitHeight = 490
    object tvDocList: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataModeController.GridMode = True
      DataController.DataSource = dmSaveDoc.dsDocs
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.Deleting = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.MultiSelect = True
      OptionsView.CellEndEllipsis = True
      OptionsView.NavigatorOffset = 49
      OptionsView.CellAutoHeight = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      OptionsView.IndicatorWidth = 11
      Preview.LeftIndent = 19
      object tvDocListFILEID: TcxGridDBColumn
        Caption = 'Matter'
        DataBinding.FieldName = 'FILEID'
        MinWidth = 18
        Options.Editing = False
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Width = 53
      end
      object tvDocListD_CREATE: TcxGridDBColumn
        Caption = 'Created'
        DataBinding.FieldName = 'D_CREATE'
        MinWidth = 18
        Options.Editing = False
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Width = 57
      end
      object tvDocListDOC_NAME: TcxGridDBColumn
        Caption = 'Document Name'
        DataBinding.FieldName = 'DOC_NAME'
        MinWidth = 18
        Options.Editing = False
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Width = 88
      end
      object tvDocListDESCR: TcxGridDBColumn
        Caption = 'Description'
        DataBinding.FieldName = 'DESCR'
        MinWidth = 18
        Options.Editing = False
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Width = 106
      end
      object tvDocListEMAIL_SENT_TO: TcxGridDBColumn
        Caption = 'Email Sent To'
        DataBinding.FieldName = 'EMAIL_SENT_TO'
        MinWidth = 18
        Options.Editing = False
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Width = 106
      end
      object tvDocListEMAIL_FROM: TcxGridDBColumn
        Caption = 'Email From'
        DataBinding.FieldName = 'EMAIL_FROM'
        MinWidth = 18
        Options.Editing = False
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Width = 106
      end
      object tvDocListNMATTER: TcxGridDBColumn
        DataBinding.FieldName = 'NMATTER'
        Visible = False
        MinWidth = 18
        Options.Editing = False
        Options.Focusing = False
        VisibleForCustomization = False
      end
      object tvDocListDOCID: TcxGridDBColumn
        DataBinding.FieldName = 'DOCID'
        Visible = False
        MinWidth = 18
        Options.Editing = False
        Options.Focusing = False
        VisibleForCustomization = False
      end
      object tvDocListPATH: TcxGridDBColumn
        DataBinding.FieldName = 'PATH'
        Visible = False
        MinWidth = 18
        VisibleForCustomization = False
      end
    end
    object lvDocList: TcxGridLevel
      GridView = tvDocList
    end
  end
end

object frmLoginSetup: TfrmLoginSetup
  Left = 430
  Top = 340
  BorderStyle = bsDialog
  Caption = 'Configuration'
  ClientHeight = 480
  ClientWidth = 254
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  DesignSize = (
    254
    480)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 7
    Top = 6
    Width = 239
    Height = 209
    Caption = 'Login Details'
    TabOrder = 0
    object Label1: TLabel
      Left = 17
      Top = 139
      Width = 51
      Height = 13
      Caption = 'Username'
    end
    object Label2: TLabel
      Left = 17
      Top = 167
      Width = 49
      Height = 13
      Caption = 'Password'
    end
    object edUserName: TEdit
      Left = 79
      Top = 135
      Width = 121
      Height = 21
      AutoSize = False
      TabOrder = 1
    end
    object edPassword: TEdit
      Left = 79
      Top = 163
      Width = 121
      Height = 21
      AutoSize = False
      PasswordChar = '*'
      TabOrder = 2
    end
    object Database: TGroupBox
      Left = 6
      Top = 22
      Width = 224
      Height = 105
      Caption = 'Database Details'
      TabOrder = 0
      object Label3: TLabel
        Left = 5
        Top = 26
        Width = 31
        Height = 13
        Caption = 'Server'
      end
      object Label4: TLabel
        Left = 5
        Top = 54
        Width = 48
        Height = 13
        Caption = 'Database'
      end
      object Label5: TLabel
        Left = 5
        Top = 81
        Width = 21
        Height = 13
        Caption = 'Port'
      end
      object edServerName: TEdit
        Left = 73
        Top = 22
        Width = 146
        Height = 21
        AutoSize = False
        TabOrder = 0
      end
      object edDatabase: TEdit
        Left = 73
        Top = 50
        Width = 121
        Height = 21
        TabOrder = 1
        Text = 'Insight'
      end
      object edPort: TEdit
        Left = 73
        Top = 77
        Width = 57
        Height = 21
        TabOrder = 2
        Text = '1521'
      end
    end
    object chkUseDirectConn: TcxCheckBox
      Left = 11
      Top = 185
      AutoSize = False
      Caption = 'Use Direct Connection'
      State = cbsChecked
      TabOrder = 3
      OnClick = chkUseDirectConnClick
      Height = 21
      Width = 140
    end
  end
  object Button1: TButton
    Left = 91
    Top = 433
    Width = 75
    Height = 26
    Anchors = [akRight, akBottom]
    Caption = 'Save'
    ModalResult = 1
    TabOrder = 1
    OnClick = Button1Click
  end
  object GroupBox2: TGroupBox
    Left = 7
    Top = 218
    Width = 239
    Height = 208
    Caption = 'Outlook Options'
    TabOrder = 2
    object chkShowMatterList: TCheckBox
      Left = 7
      Top = 18
      Width = 126
      Height = 17
      Caption = 'Show Matter List'
      Enabled = False
      TabOrder = 0
      OnClick = chkShowMatterListClick
    end
    object chkSaveIncoming: TCheckBox
      Left = 7
      Top = 38
      Width = 226
      Height = 17
      Caption = 'Save Incoming Emails in separate folder'
      Enabled = False
      TabOrder = 1
      OnClick = chkSaveIncomingClick
    end
    object chkSaveOutgoing: TCheckBox
      Left = 7
      Top = 78
      Width = 207
      Height = 17
      Caption = 'Save Sent Emails in separate folder'
      Enabled = False
      TabOrder = 2
      OnClick = chkSaveOutgoingClick
    end
    object chkSaveSentEmail: TCheckBox
      Left = 7
      Top = 98
      Width = 190
      Height = 17
      Hint = 
        'Select this option if you want a prompt to appear to save Sent e' +
        'mail.'
      Caption = 'Prompt to save Sent Email'
      TabOrder = 3
      OnClick = chkSaveSentEmailClick
    end
    object chkRemoveEmail: TCheckBox
      Left = 7
      Top = 58
      Width = 212
      Height = 17
      Caption = 'Remove Email from Inbox once saved'
      Enabled = False
      TabOrder = 4
      OnClick = chkRemoveEmailClick
    end
    object chkSaveIncomingAlways: TCheckBox
      Left = 7
      Top = 117
      Width = 178
      Height = 17
      Caption = 'Prompt to save Incoming Email'
      TabOrder = 5
      OnClick = chkSaveIncomingAlwaysClick
    end
  end
  object btnCancel: TButton
    Left = 171
    Top = 433
    Width = 75
    Height = 26
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 355
    Width = 234
    Height = 67
    TabOrder = 4
    object chkLogEvents: TCheckBox
      Left = 3
      Top = 4
      Width = 226
      Height = 30
      Hint = 
        'Select this option if you want a prompt to appear to save Sent e' +
        'mail.'
      Caption = 'Log Outlook events (set only if asked by BHL representative)'
      Enabled = False
      TabOrder = 0
      WordWrap = True
      OnClick = chkLogEventsClick
    end
    object edLogPath: TEdit
      Left = 3
      Top = 40
      Width = 203
      Height = 21
      TabOrder = 1
      OnExit = edLogPathExit
    end
    object BitBtn2: TBitBtn
      Left = 205
      Top = 39
      Width = 26
      Height = 23
      Glyph.Data = {
        36050000424D3605000000000000360400002800000010000000100000000100
        0800000000000001000000000000000000000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A60033000000000033003300330033330000161616001C1C1C00222222002929
        2900555555004D4D4D004242420039393900807CFF005050FF009300D600FFEC
        CC00C6D6EF00D6E7E70090A9AD0000FF330000006600000099000000CC000033
        00000033330000336600003399000033CC000033FF0000660000006633000066
        6600006699000066CC000066FF00009900000099330000996600009999000099
        CC000099FF0000CC000000CC330000CC660000CC990000CCCC0000CCFF0000FF
        660000FF990000FFCC0033FF0000FF00330033006600330099003300CC003300
        FF00FF3300003333330033336600333399003333CC003333FF00336600003366
        330033666600336699003366CC003366FF003399000033993300339966003399
        99003399CC003399FF0033CC000033CC330033CC660033CC990033CCCC0033CC
        FF0033FF330033FF660033FF990033FFCC0033FFFF0066000000660033006600
        6600660099006600CC006600FF00663300006633330066336600663399006633
        CC006633FF00666600006666330066666600666699006666CC00669900006699
        330066996600669999006699CC006699FF0066CC000066CC330066CC990066CC
        CC0066CCFF0066FF000066FF330066FF990066FFCC00CC00FF00FF00CC009999
        000099339900990099009900CC009900000099333300990066009933CC009900
        FF00996600009966330099336600996699009966CC009933FF00999933009999
        6600999999009999CC009999FF0099CC000099CC330066CC660099CC990099CC
        CC0099CCFF0099FF000099FF330099CC660099FF990099FFCC0099FFFF00CC00
        000099003300CC006600CC009900CC00CC0099330000CC333300CC336600CC33
        9900CC33CC00CC33FF00CC660000CC66330099666600CC669900CC66CC009966
        FF00CC990000CC993300CC996600CC999900CC99CC00CC99FF00CCCC0000CCCC
        3300CCCC6600CCCC9900CCCCCC00CCCCFF00CCFF0000CCFF330099FF6600CCFF
        9900CCFFCC00CCFFFF00CC003300FF006600FF009900CC330000FF333300FF33
        6600FF339900FF33CC00FF33FF00FF660000FF663300CC666600FF669900FF66
        CC00CC66FF00FF990000FF993300FF996600FF999900FF99CC00FF99FF00FFCC
        0000FFCC3300FFCC6600FFCC9900FFCCCC00FFCCFF00FFFF3300CCFF6600FFFF
        9900FFFFCC006666FF0066FF660066FFFF00FF666600FF66FF00FFFF66002100
        A5005F5F5F00777777008686860096969600CBCBCB00B2B2B200D7D7D700DDDD
        DD00E3E3E300EAEAEA00F1F1F100F8F8F800F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBEBFFFFFFEA6DEAEAEA
        EAEAEAEA6DED73EAFFFF5252522B2A2A2A2A2A4BED525213FFFF5252C37A7A7A
        7A7A7A92527A2A4AEBFF5252C3A099EE07EF1C747A7A2A2AEAFF52529AEEF3F5
        E219BB997AA0525112FF52585209FFFFF4191907A0A07A2A4AEB527A5209F4F5
        E21919BCA0A07A522A13527A5209E2E2191919DDFFFF9A7A2AEA52A07AEC1919
        19F5F174525252522AFF52A0A0A0070909EEF2FFFFFF2AEBFFFF52FFA0A0A0A0
        FF52525252522BFFFFFFFF52FFFFFFFF52FFFFFFFFFFFFFFFFFFFFFF52525252
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      TabOrder = 2
      OnClick = BitBtn2Click
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 461
    Width = 254
    Height = 19
    Panels = <
      item
        Width = 340
      end>
    ParentFont = True
    UseSystemFont = False
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 433
    Width = 79
    Height = 26
    Caption = 'Additional'
    TabOrder = 6
    Visible = False
    OnClick = BitBtn1Click
  end
  object OpenDialog: TOpenDialog
    Left = 202
    Top = 214
  end
end

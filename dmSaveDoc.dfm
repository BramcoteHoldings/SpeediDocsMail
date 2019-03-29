object DataModule2: TDataModule2
  OldCreateOrder = False
  Height = 235
  Width = 337
  object orsAxiom: TUniConnection
    ProviderName = 'Oracle'
    Username = 'axiom'
    Password = 'axiom'
    Server = 'AXIOMNW'
    LoginPrompt = False
    Left = 29
    Top = 9
  end
  object OraQuery1: TUniQuery
    Connection = orsAxiom
    Left = 37
    Top = 70
  end
  object OraDataSource1: TUniDataSource
    Left = 83
    Top = 71
  end
end

unit dmSaveDoc;

interface

uses
  SysUtils, Classes, DB, OracleUniProvider, Uni, DBAccess, MemDS;

type
  TDataModule2 = class(TDataModule)
    orsAxiom: TUniConnection;
    OraQuery1: TUniQuery;
    OraDataSource1: TUniDataSource;
  private
    { Private declarations }
    FUserID : string;
  public
    { Public declarations }
    property UserID : string read FUserID write FUserID;
  end;

var
  DataModule2: TDataModule2;

implementation

{$R *.dfm}

end.

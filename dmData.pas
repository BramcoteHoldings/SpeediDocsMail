unit dmData;

interface

uses
  SysUtils, Classes, DB, DBAccess, OracleUniProvider, Uni, MemDS,
  UniProvider;

type
  TdmInsight = class(TDataModule)
    orsInsight: TUniConnection;
    qryEmps: TUniQuery;
    dsPrecClassification: TUniDataSource;
    qryPrecClassification: TUniQuery;
    qryTmp: TUniQuery;
    qrySysFile: TUniQuery;
    qryEmployee: TUniQuery;
    dsEmployee: TUniDataSource;
    qryPrecCategory: TUniQuery;
    dsPrecCategory: TUniDataSource;
    qryGetEntity: TUniQuery;
    qryMatterAttachments: TUniQuery;
    qryMatterAttachmentsDOCUMENT: TBlobField;
    qryMatterAttachmentsIMAGEINDEX: TFloatField;
    qryMatterAttachmentsFILE_EXTENSION: TStringField;
    qryMatterAttachmentsDOC_NAME: TStringField;
    qryMatterAttachmentsSEARCH: TStringField;
    qryMatterAttachmentsDOC_CODE: TStringField;
    qryMatterAttachmentsJURIS: TStringField;
    qryMatterAttachmentsD_CREATE: TDateTimeField;
    qryMatterAttachmentsAUTH1: TStringField;
    qryMatterAttachmentsD_MODIF: TDateTimeField;
    qryMatterAttachmentsAUTH2: TStringField;
    qryMatterAttachmentsPATH: TStringField;
    qryMatterAttachmentsDESCR: TStringField;
    qryMatterAttachmentsFILEID: TStringField;
    qryMatterAttachmentsDOCID: TFloatField;
    qryMatterAttachmentsNPRECCATEGORY: TFloatField;
    qryMatterAttachmentsNMATTER: TFloatField;
    qryMatterAttachmentsPRECEDENT_DETAILS: TStringField;
    qryMatterAttachmentsNPRECCLASSIFICATION: TFloatField;
    qryMatterAttachmentsKEYWORDS: TStringField;
    qryMatterAttachmentsDISPLAY_PATH: TStringField;
    qryMatterAttachmentsEXTERNAL_ACCESS: TStringField;
    qryMatterAttachmentsROWID: TStringField;
    qryFeeInsert: TUniQuery;
    qryEntity: TUniQuery;
    qryEntityCODE: TStringField;
    qryEntityNAME: TStringField;
    qryEntityLOCKDATE2: TDateTimeField;
    qryEntityABN: TStringField;
    qryGetSeq: TUniQuery;
    OracleUniProvider1: TOracleUniProvider;
    qryMRUList: TUniQuery;
    qryMatter: TUniQuery;
    qryFee: TUniQuery;
    procedure qryMatterAttachmentsAfterInsert(DataSet: TDataSet);
  private
    { Private declarations }
    FUserID : string;
    FEntity : string;
    FDocID   : string;
    FDocName: string;
    FURLOnly: boolean;
    FDefaultTax: string;
    FUserDept: string;
  public
    { Public declarations }
    property UserID : string read FUserID write FUserID;
    property Entity : string read FEntity write FEntity;
    property DocID  : string read FDocID write FDocID;
    property DocName: string read FDocName write FDocName;
    property URLOnly: boolean read FURLOnly write FURLOnly;
    property DefaultTax: string read FDefaultTax write FDefaultTax;
    property UserDept: string read FUserDept write FUserDept;
    procedure SetUserID(sUserID: string);
    procedure SetEntity(Value: string);
  end;

var
  dmInsight: TdmInsight;

implementation

{$R *.dfm}

uses
   SaveDocFunc;

procedure TdmInsight.SetUserID(sUserID: string);
var
  DefaultEntity : String;
begin
   FUserID := sUserID;
//   FUserType := TableString('EMPLOYEE', 'CODE', sUserID, 'TYPE');
//   FUserBranch := TableString('EMPLOYEE', 'CODE', sUserID, 'BRANCH');
   FUserDept := TableString('EMPLOYEE', 'CODE', sUserID, 'DEPT');
{   FUserCPrinter := TableString('EMPLOYEE', 'CODE', sUserID, 'CHEQUE_PRINTER');
   FUserRPrinter := TableString('EMPLOYEE', 'CODE', sUserID, 'RECEIPT_PRINTER');
   FUserAccessLevel := TableInteger('EMPLOYEE', 'CODE', sUserID, 'ACCESSLEVEL');
   DefaultEntity := TableString('EMPLOYEE', 'CODE', sUserID, 'DEFAULT_ENTITY');
   FResourceId := TableInteger('EMPLOYEE', 'CODE', sUserID, 'NEMPLOYEE');
   FUserName := TableString('EMPLOYEE', 'CODE', sUserID, 'NAME');
   FViewType := TableInteger('EMPLOYEE', 'CODE', sUserID, 'VIEW_TYPE');
   FUseClassicDesktop := TableString('EMPLOYEE','CODE', sUserID, 'CLASSIC_VERSION');
   FShowMenuBar := TableString('EMPLOYEE','CODE', sUserID, 'SHOW_NAV_BAR');
   FEmpDefaultURL := TableString('EMPLOYEE','CODE', sUserID, 'EMP_DEFAULT_URL');
   FFeeEarner := TableString('EMPLOYEE','CODE', sUserID, 'ISFEEEARNER');
   FEmailInbox := TableString('EMPLOYEE','CODE', sUserID, 'EMAIL_INCOMING_FLDR');
   FEMailProfileDefault := TableString('EMPLOYEE','CODE', sUserID, 'EMAIL_PROFILE_DEFAULT'); }
   if DefaultEntity <> '' then
    setEntity(DefaultEntity);
{   frmDesktop.beEntity.Text := TableString('ENTITY','CODE', dmAxiom.Entity, 'NAME');
   FLoginName := TableString('EMPLOYEE','CODE', sUserID, 'USER_NAME');
   FLabelPrinter := TableString('EMPLOYEE','CODE', sUserID, 'LABEL_PRINTER');
   FUserMatterGSTDefault := TableString('EMPLOYEE','CODE', sUserID, 'MAT_LEDG_GST_TICK');
   FReOpenLength := TableInteger('EMPLOYEE','CODE', sUserID, 'REOPENLENGTH');
   FGridFont := TableInteger('EMPLOYEE','CODE',sUserID,'GRID_FONT_SIZE');
   FMatterTabsMultiLine := TableString('EMPLOYEE','CODE',sUserID, 'MATTER_MULTILINE_TABS');    }
end;

procedure TdmInsight.qryMatterAttachmentsAfterInsert(DataSet: TDataSet);
begin
   qryGetSeq.ExecSQL;
   DocID := qryGetSeq.FieldByName('nextdoc').AsString;
end;

procedure TdmInsight.SetEntity(Value: string);
begin
  with qryEntity do
  begin
    Close;
    ParamByName('ENTITY').AsString := Value;
    Open;
  end;
end;

end.

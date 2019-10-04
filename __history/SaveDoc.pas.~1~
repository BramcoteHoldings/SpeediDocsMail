unit SaveDoc;

{****************************************************
AES 24/6/2018 added FindMatter function that searches for matter based on search criteria (client/matter descr/fileid


*****************************************************}

interface

uses
  SysUtils, Classes, DB, DBAccess, MemDS, Dialogs, OraSmart, Ora, OraCall,
  Registry, Forms, Windows, Controls, MemData;

const
   csRegistryRoot = 'Software\Colateral\Axiom\SpeediDocs';


type
   TWordProperties = record
      PropName: variant;
      PropValue: variant;
   end;
   TWordProps = array[0..20] of TWordProperties;

  TdmSaveDoc = class(TDataModule)
    qryFeeInsert: TOraSQL;
    procTemp: TOraStoredProc;
    qryGetMatter: TOraQuery;
    orsInsight: TOraSession;
    qryEmps: TOraQuery;
    qryGetSeq: TOraQuery;
    qryMatterAttachments: TSmartQuery;
    qryGetEntity: TOraQuery;
    qrySysFile: TOraQuery;
    qryTmp: TSmartQuery;
    qryCheckEmail: TOraQuery;
    tbDocGroups: TOraTable;
    qryDoctemplate: TSmartQuery;
    qryFeeTmpInsert: TOraSQL;
    qrySaveEmailAttachments: TOraQuery;
    qryDocs: TSmartQuery;
    dsDocs: TOraDataSource;
    qryMatterList: TOraQuery;
    dsMatterList: TOraDataSource;
    qryMatterDocs: TOraQuery;
    dsMatterDocs: TOraDataSource;
    qryMatters: TOraQuery;
    dsMatters: TOraDataSource;
    qryPrecClassification: TOraQuery;
    dsPrecClassification: TOraDataSource;
    qryPrecCategory: TOraQuery;
    dsPrecCategory: TOraDataSource;
    qryEmployee: TOraQuery;
    dsEmployee: TOraDataSource;
    dsScaleCost: TOraDataSource;
    qryScaleCost: TOraQuery;
    dsMatterFolderList: TOraDataSource;
    qryMatterFolderList: TOraQuery;
    qryNew: TOraQuery;
    qryGetSeqPrec: TOraQuery;
    procedure qryMatterAttachmentsNewRecord(DataSet: TDataSet);
    procedure orsInsightError(Sender: TObject; E: EDAError; var Fail: Boolean);
    procedure qrySaveEmailAttachmentsNewRecord(DataSet: TDataSet);
    procedure qryDocTemplateNewRecord(DataSet: TDataSet);
    procedure orsInsightConnectionLost(Sender: TObject; Component: TComponent;
      ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
  private
    { Private declarations }
    FUserID : string;
    FEntity : string;
    FDocID   : integer;
    FPrecID  : integer;
    FDefaultTax: string;
    FUserDept: string;
    FAttDocID: string;
    FSecureMatterAccess: string;

    function GetUserCode: string;
  	 property SecureMatterAccess: string read FSecureMatterAccess write FSecureMatterAccess;


  public
    { Public declarations }
    property UserID : string read FUserID write FUserID;
    property Entity : string read FEntity write FEntity;
    property DocID  : integer read FDocID write FDocID;
    property PrecID : integer read FPrecID write FPrecID;
    property DefaultTax: string read FDefaultTax write FDefaultTax;
    property UserDept: string read FUserDept write FUserDept;
    property UserCode: string read GetUserCode;
    property AttDocID  : string read FAttDocID write FAttDocID;


    function GetUserID: boolean;

    function SystemDate(sField: string): TDateTime;
    function SystemInteger(sField: string): integer;
    function SystemString(sField: string): string;
    function SystemFloat(sField: string): double;
    function GetSeqNumber(sSequence : string) : string;
    function GetEnvVar(const varName : string) : string;
    procedure FindMatter(var AFoundFileID: string; var ANMatter: integer; AFileID: string);
    function IsValidMatter(sFileId: string): boolean;
  end;

var
  dmSaveDoc: TdmSaveDoc;

implementation

{$R *.dfm}

uses
   LoginDetails, SaveDocFunc, MatterSearch;


procedure TdmSaveDoc.orsInsightConnectionLost(Sender: TObject;
  Component: TComponent; ConnLostCause: TConnLostCause;
  var RetryMode: TRetryMode);
begin
   RetryMode := rmReconnectExecute;
end;

procedure TdmSaveDoc.orsInsightError(Sender: TObject; E: EDAError;
  var Fail: Boolean);
var
   bLoginSetup: integer;
begin
   case E.ErrorCode of
      1005:    Fail := False;
      3113:    begin
                  Fail := False;
                  GetUserID();
               end;
      3114:    begin
                  Fail := False;
                  GetUserID();
               end;
      12541:   begin
                  frmLoginSetup := TfrmLoginSetup.Create(Self);
                  try
                     bLoginSetup := frmLoginSetup.ShowModal;
                  finally
                     frmLoginSetup.Free;
                     GetUserID();
                  end;
               end;
      12571:
           Fail := False;
      12505:  begin
                 Fail := False;
                 GetUserID();
              end;
      12560:  begin
                 Fail := False;

              end;
   else
      MessageDlg('Insight Database Error:'#13#10 + e.Message, mtError, [mbOK], 0);
   end;
end;

procedure TdmSaveDoc.qryMatterAttachmentsNewRecord(DataSet: TDataSet);
begin
   qryGetSeq.ExecSQL;
   FDocID := qryGetSeq.FieldByName('nextdoc').AsInteger;
   DataSet.FieldByName('docid').AsInteger := FDocID;
end;

procedure TdmSaveDoc.qrySaveEmailAttachmentsNewRecord(DataSet: TDataSet);
begin
   qryGetSeq.ExecSQL;
   AttDocID := qryGetSeq.FieldByName('nextdoc').AsString;
   DataSet.FieldByName('docid').AsString := AttDocID;
end;

procedure TdmSaveDoc.qryDocTemplateNewRecord(DataSet: TDataSet);
begin
   qryGetSeqPrec.ExecSQL;
   FPrecID := qryGetSeqPrec.FieldByName('nextprec').AsInteger;
   DataSet.FieldByName('docid').AsInteger := FPrecID;
end;

function TdmSaveDoc.GetUserCode: string;
begin
   Result := TableString('employee','user_name', UserID,'code');
end;

function TdmSaveDoc.GetUserID: boolean;
var
  regAxiom: TRegistry;
  sRegistryRoot: string;
  NotSetup,
  bReturn: boolean;
begin
   NotSetup := False;
   bReturn  := True;
   sRegistryRoot := 'Software\Colateral\Axiom\SpeediDocs';
   regAxiom := TRegistry.Create;
   try
      if orsInsight <> nil then
      begin
         if (not orsInsight.Connected) then
         begin
            regAxiom.RootKey := HKEY_CURRENT_USER;
            if regAxiom.OpenKey(sRegistryRoot, False) then
            begin
               if (regAxiom.ReadString('Password') <> '') then
               begin
                  try
                     if orsInsight.Connected then
                        orsInsight.Disconnect;
                     if regAxiom.ReadString('Net') = 'Y' then
                        orsInsight.Options.Direct := True
                     else
                         orsInsight.Options.Direct := False;
                     orsInsight.Server := regAxiom.ReadString('Server Name');
                     orsInsight.Username := regAxiom.ReadString('User Name');
                     orsInsight.Password := regAxiom.ReadString('Password');
                     try
                        orsInsight.Connect;
                        UserID := UpperCase(regAxiom.ReadString('User Name'));
                     except
                       Application.MessageBox('Connection details not valid. Please correct...','Insight');
                       NotSetup := True;
                     end;
                  except
                     Application.MessageBox('Could not connect to Insight database.','Insight');
                     bReturn := False;
                  end;
               end
               else
               begin
                  Application.MessageBox('Connection details not valid. Please correct...','Insight');
                  NotSetup := True;
               end;
               regAxiom.CloseKey;

               if orsInsight.Connected = True then
               begin
                  with qryEmps do
                  begin
                     Close;
                     SQL.Text := 'SELECT CODE FROM EMPLOYEE WHERE upper(USER_NAME) = ' + quotedstr(uppercase(UserID)) + ' AND ACTIVE = ''Y''';
                     Prepare;
                     Open;
                     // Make sure that the UserID is valid
                     if IsEmpty then
                     begin
                        Application.MessageBox('Failed to authenticate user.','Insight');
                        bReturn := False;
                     end;
                     Close;
                  end;

                  qryGetEntity.ParamByName('Emp').AsString := UserID;
                  qryGetEntity.ParamByName('Owner').AsString := 'Desktop';
                  qryGetEntity.ParamByName('Item').AsString := 'Entity';
                  qryGetEntity.Open();
                  Entity := qryGetEntity.FieldByName('value').AsString;
               end;
            end else
            begin
               Application.MessageBox('Connection details not recorded. Please enter...','Insight');
               NotSetup := True;
            end;
            if NotSetup then
            begin
               frmLoginSetup := TfrmLoginSetup.Create(Application);
               try
                  if frmLoginSetup.ShowModal = mrOK then
                     GetUserID();
               finally
                  frmLoginSetup.Free;
               end;
            end;
         end;
      end;
   finally
      regAxiom.Free;
   end;
   Result := bReturn;
end;

function TdmSaveDoc.SystemDate(sField: string): TDateTime;
begin
  with qrySysfile do
  begin
    SQL.Text := 'SELECT ' + sField + ' FROM SYSTEMFILE';
    Open;
    SystemDate := FieldByName(sField).AsDateTime;
    Close;
  end;
end;


function TdmSaveDoc.SystemInteger(sField: string): integer;
begin
  with qrySysfile do
  begin
    SQL.Text := 'SELECT ' + sField + ' FROM SYSTEMFILE';
    Open;
    SystemInteger := FieldByName(sField).AsInteger;
    Close;
  end;
end;


function TdmSaveDoc.SystemString(sField: string): string;
begin
   with qrySysfile do
   begin
      SQL.Text := 'SELECT ' + sField + ' FROM SYSTEMFILE';
      try
         Open;
         SystemString := FieldByName(sField).AsString;
         Close;
      except
      //
      end;
   end;
end;

function TdmSaveDoc.SystemFloat(sField: string): double;
begin
  with qrySysfile do
  begin
    SQL.Text := 'SELECT ' + sField + ' FROM SYSTEMFILE';
    Open;
    SystemFloat := FieldByName(sField).AsFloat;
    Close;
  end;
end;

function TdmSaveDoc.GetSeqNumber(sSequence : string) : string;
var
  sTmp : string;
begin
  sTmp := '';
  with qryTmp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT ' + sSequence + '.NEXTVAL AS SQNC FROM DUAL');
      Open;
      if RecordCount > 0 then
        sTmp := FieldbyName('SQNC').AsString;
      Close;
    end;
  GetSeqNumber := sTmp;
end;

function TdmSaveDoc.GetEnvVar(const varName : string) : string;
var
  BufSize: Integer;  // buffer size required for value
begin
  // Get required buffer size (inc. terminal #0)
  BufSize := GetEnvironmentVariable(PChar(VarName), nil, 0);
  if BufSize > 0 then
  begin
    // Read env var value into result string
    SetLength(Result, BufSize - 1);
    GetEnvironmentVariable(PChar(VarName),PChar(Result), BufSize);
  end
  else
    // No such environment variable
    Result := '';
end;

procedure TdmSaveDoc.FindMatter(var AFoundFileID: string; var ANMatter: integer; AFileID: string);
var
   LFileID: String;
   frmMtrSearch: TfrmMtrSearch;
begin
   LFileID := Uppercase(AFileID);
   with qryNew do
   begin
      Close;
      SQL.Text := 'SELECT matter.fileid , phonebook.search as title, matter.longdescr, '+
                  'matter.partner, matter.author, matter.type, phonebook.clientid, matter.archived, matter.status, nmatter '+
                  'FROM phonebook, matter WHERE matter.nclient = phonebook.nclient and closed = 0';
{      if dmAxiom.Security.Employee.ChangeEntity = False then
      begin
         SQL.Text := SQL.Text + ' AND efematteraccess (matter.nmatter, :author, :entity, :defentity) = 0 ';
         ParamByName('AUTHOR').AsString := UserID;
         ParamByName('DEFENTITY').AsString := EmpEntity;
         ParamByName('ENTITY').AsString := Entity;
      end
      else}
         SQL.Text := SQL.Text + 'and matter.entity = '+ QuotedStr(Entity) ;

      if (Trim(LFileID) <> '') then
         SQL.Text := SQL.Text + ' and contains(matter.dummy,'+ QuotedStr(LFileID) +') > 0';
      Prepare;
      Open;
      if (qryNew.RecordCount > 1) and (Trim(LFileID) <> '') then
      begin
         try
            FreeAndNil(frmMtrSearch);
            frmMtrSearch := TfrmMtrSearch.Create(Application);
            frmMtrSearch.SQL := SQL.Text;
            if frmMtrSearch.ShowModal = mrOK then
            begin
               LFileID := frmMtrSearch.tvMattersFILEID.EditValue;
               ANMatter := frmMtrSearch.tvMattersNMATTER.EditValue;
            end
            else
               LFileID := '';
         finally
            begin
               frmMtrSearch.Free();
               Close;
            end;
         end;
      end
      else
      if (qryNew.RecordCount = 1) then
      begin
         LFileID := qryNew.FieldByName('code').AsString;
         ANMatter := qryNew.FieldByName('nmatter').AsInteger;
      end
      else
      begin
         MsgErr('The selected Matter is not valid.  Please check and re-try.');
         LFileID := '';
         Exit;
      end;
   end;

   if ((Trim(LFileID) <> '') and MatterExists(LFileID)) then
   begin
      if (IsMatterPrivate(StrToInt(MatterString(LFileID, 'NMATTER')),MatterString(LFileID, 'RESTRICT_ACCESS')) AND
          (SecureMatterAccess = 'N')) then
      begin
         MsgInfo('This matter is marked as private. You do not have permission to view it.');
      end
      else
      begin
         try
            AFoundFileID := LFileID;
         finally
//
         end;
      end;
   end
   else
      if (LFileID <> '') then
         MsgErr('The selected Matter is not valid.  Please check and re-try.');
end;

function TdmSaveDoc.IsValidMatter(sFileId: string): boolean;
var
  loQry : TOraQuery;
begin
   try
      loQry := nil;

      try
         loQry := TOraQuery.Create(nil);
         loQry.Connection := orsInsight;

         loQry.Close;
         loQry.SQL.Clear;
         loQry.SQL.Add('SELECT ''x'' FROM MATTER WHERE FILEID = :sFileId ');

         loQry.ParamByName('sFileId').AsString := sFileId;
         loQry.Open;
         Result := not loQry.IsEmpty;
      finally
      loQry.Close;
      FreeAndNil(loQry);
    end;    //  end try-finally
    except
       on E : Exception do
       begin
          Raise;
       end;
    end;
end;


end.

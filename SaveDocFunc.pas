unit SaveDocFunc;

interface

uses
   Forms, SysUtils, Variants, Windows, Ora,
   DBAccess, MemDS, dmData, System.Classes, Dialogs,
   ActiveX, ShlObj, ComObj, ShellAPI;
const


  C_MACRO_USERHOME      = '[USERHOME]';
  C_MACRO_NMATTER       = '[NMATTER]';
  C_MACRO_FILEID        = '[FILEID]';
  C_MACRO_TEMPDIR       = '[TEMPDIR]';
  C_MACRO_TEMPFILE      = '[TEMPFILE]';
  C_MACRO_DATE          = '[DATE]';
  C_MACRO_TIME          = '[TIME]';
  C_MACRO_DATETIME      = '[DATETIME]';
  C_MACRO_CLIENTID      = '[CLIENTID]';
  C_MACRO_AUTHOR        = '[AUTHOR]';
  C_MACRO_USERINITIALS  = '[USERINITIALS]';
  C_MACRO_DOCSEQUENCE   = '[DOCSEQUENCE]';
  C_MACRO_DOCID         = '[DOCID]';
  C_WORKFLOW            = 'WORKFLOW';
  C_WKF                 = 'WKF';
  C_MERGETYPE           = 'MERGETYPE';
  C_MACRO_DOCDESCR      = '[DOCDESCR]';

//AES 07/09/2018
type
  TFileSystemBindData = class (TInterfacedObject, IFileSystemBindData)
    fw32fd: TWin32FindData;

    function SetFindData(var w32fd: TWin32FindData): HRESULT; stdcall;
    function GetFindData(var w32fd: TWin32FindData): HRESULT; stdcall;
  end;


//   function GetUserID: boolean;
   function GetSeqNumber(sSequence: string): Integer;
   function TableString(Table, LookupField, LookupValue, ReturnField: string): string; overload;
   function TableString(Table, LookupField: string; LookupValue:integer; ReturnField: string): string; overload;
   function TableInteger(Table, LookupField, LookupValue, ReturnField: string): integer; overload;
   function ParseMacros(AFileName: String; ANMatter: Integer; ADocID: Integer; ADocDescr: string): String;
   function SystemString(sField: string): string;
   function SystemInteger(sField: string): integer;
   function ProcString(Proc: string; LookupValue: integer): string;
   function ReportVersion( const sgFileName: string): string;
   function IndexPath(PathText, PathLoc: string): string;
   function TokenizePath(var s,w:string): boolean;
   function MoveMatterDoc(var ANewDocName: string; AOldDocName: string): boolean;
   procedure FeeInsert(NMatter: integer; Author: string; Reason: string; Amount: Currency;
                       ATask: string; AUnits: integer; AMinutes: real; ARate: currency;
                       ATaxType: string = 'GST');
   procedure FeeTmpInsert(NMatter: integer; AAuthor: string; Reason: string; Amount: Currency;
                       ATask: string; AUnits: integer; AMinutes: real; ARate: currency;
                       ATaxType: string = 'GST');
   function TaxRate(RateType, TaxCode: string; Commence: TDateTime): Double;
   function get_default_gst(sform : String) : String;
   function MatterString(sFile: string; sField: string): string; overload;
   function MatterString(iFile: integer; sField: string): string; overload;
   function TableCurrency(Table, LookupField, LookupValue, ReturnField: string): currency; overload;
   function TableCurrency(Table, LookupField: string; LookupValue: integer; ReturnField: string): currency; overload;
   function TaxCalc(var Amount: Currency; RateType, TaxCode: string; TaxDate: TDateTime): Currency;
   function FormExists(frmInput : TForm):boolean;
   function IsMatterArchived(FileId: string): boolean;
   function MatterIsCurrent(sFile: string): boolean;
   function MatterExists(sFile: string): boolean;
   function FeeRate(sFeeType, sFileID, sAuthor: string; Fee_Date: TDateTime): Currency;
   function GetNextToken(Const S: string; Separator: char; var StartPos: integer): String;
   procedure Split(const S: String; Separator: Char; MyStringList: TStringList) ;
   function IsFileInUse(fName: string) : boolean;
   function CalcRate(pAuthor, lTask: string; lReceivedDate: TDateTime; pFileID: string): double;
   function  IsMatterPrivate(ANMatter: integer; ARestrictMatter: string): boolean;
   function PadFileID(AFileID: string): string;
   procedure MsgErr(sMsg: string);
   procedure MsgInfo(sMsg: string);
   // AES 07/09/2018
   function CopyFileIFileOperationForceDirectories(const srcFile, destFile : string; DeleteOrigDoc: boolean = False) : boolean;
   function MsgAsk(sMsg: string): integer;
   function WriteFileToDisk(var ANewDocName: string; AOldDocName: string; ADeleteFile: boolean = False): boolean;
   function StripNonAscii(s: string): string;

implementation

uses
   LoginDetails, SpeediDocsMail_IMPL;

var // for macros..
  GTempPath,
  GHomePath: String;


function GetSeqNumber(sSequence: string): Integer;
begin
  try
     with dmConnection.qryTmp do
     begin
       Close;
       SQL.Clear;
       SQL.Add('SELECT ' + sSequence + '.currval');
       SQL.Add('FROM DUAL');
       ExecSQL;
       Result := Fields[0].AsInteger;
       Close;
     end;
  except
      //
  end;
end;

function ParseMacros(AFileName: String; ANMatter: Integer; ADocID: Integer; ADocDescr: string): String;
var
  LBfr: Array[0..MAX_PATH] of Char;
begin
  if(GHomePath = '') then
    GHomePath := GetEnvironmentVariable('HOMEDRIVE') + GetEnvironmentVariable('HOMEPATH');

  if(GTempPath = '') then
  begin
    GetTempPath(MAX_PATH,Lbfr);
    GTempPath := String(LBfr);
  end;

  Result := AFileName;

  Result := StringReplace(Result,C_MACRO_USERHOME,GHomePath,[rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result,C_MACRO_TEMPDIR,GTempPath,[rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result,C_MACRO_NMATTER,IntToStr(ANMatter),[rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result,C_MACRO_FILEID, TableString('MATTER','NMATTER',IntToStr(ANMatter),'FILEID'),[rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result,C_MACRO_CLIENTID, TableString('MATTER','NMATTER',IntToStr(ANMatter),'CLIENTID'),[rfReplaceAll, rfIgnoreCase]);

  Result := StringReplace(Result,C_MACRO_DATE,FormatDateTime('dd-mm-yyyy',Now()) ,[rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result,C_MACRO_TIME,FormatDateTime('hh-nn-ss',Now()),[rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result,C_MACRO_DATETIME,FormatDateTime('dd-mm-yyyy-hh-nn-ss',Now()),[rfReplaceAll, rfIgnoreCase]);

  Result := StringReplace(Result,C_MACRO_AUTHOR, TableString('MATTER','NMATTER',IntToStr(ANMatter),'AUTHOR'),[rfReplaceAll, rfIgnoreCase]);
  if (ADocDescr <> '')  then
     Result := StringReplace(Result,C_MACRO_DOCDESCR, ADocDescr ,[rfReplaceAll, rfIgnoreCase]);
  if (pos(C_MACRO_DOCSEQUENCE,UpperCase(Result)) > 0) then
     Result := StringReplace(Result,C_MACRO_DOCSEQUENCE, ProcString('getDocSequence',ANMatter),[rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result,C_MACRO_USERINITIALS, dmConnection.UserID ,[rfReplaceAll, rfIgnoreCase]);
  if ADocID > 0 then
     Result := StringReplace(Result,C_MACRO_DOCID, IntToStr(ADocID),[rfReplaceAll, rfIgnoreCase]);

  if(Pos(C_MACRO_TEMPFILE,Result) > 0) then
  begin
    GetTempFileName(PChar(GTempPath),'axm',0,LBfr);
    Result := StringReplace(Result,C_MACRO_TEMPFILE,String(LBfr),[rfReplaceAll, rfIgnoreCase]);
  end;
end;

function TableString(Table, LookupField, LookupValue, ReturnField: string): string; overload;
var
  qryLookup: TOraQuery;
begin
  qryLookup := TOraQuery.Create(nil);
  qryLookup.Session := dmConnection.orsInsight;
  with qryLookup do
  begin
    SQL.Text := 'SELECT ' + ReturnField + ' FROM ' + Table + ' WHERE upper(' + LookupField + ') = upper(:' + LookupField + ')';
    Params[0].AsString := LookupValue;
    Open;
    Result := Fields[0].AsString;
    Close;
  end;
  qryLookup.Free;
end;

function TableString(Table, LookupField: string; LookupValue: integer; ReturnField: string): string; overload;
var
  qryLookup: TOraQuery;
begin
  qryLookup := TOraQuery.Create(nil);
  qryLookup.Session := dmConnection.orsInsight;
  with qryLookup do
  begin
    SQL.Text := 'SELECT ' + ReturnField + ' FROM ' + Table + ' WHERE ' + LookupField + ' = :' + LookupField;
    Params[0].AsInteger := LookupValue;
    Open;
    Result := Fields[0].AsString;
    Close;
  end;
  qryLookup.Free;
end;

function TableInteger(Table, LookupField, LookupValue, ReturnField: string): integer; overload;
var
  qryLookup: TOraQuery;
begin
  qryLookup := TOraQuery.Create(nil);
  qryLookup.Connection := dmConnection.orsInsight;
  with qryLookup do
  begin
    SQL.Text := 'SELECT ' + ReturnField + ' FROM ' + Table + ' WHERE ' + LookupField + ' = :' + LookupField;
    Params[0].AsString := LookupValue;
    Open;
    Result := Fields[0].AsInteger;
    Close;
  end;
  qryLookup.Free;
end;

function SystemString(sField: string): string;
begin
   with dmConnection.qrySysfile do
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

function SystemInteger(sField: string): integer;
begin
   SystemInteger := -1;
   with dmConnection.qrySysfile do
   begin
      SQL.Text := 'SELECT ' + sField + ' FROM SYSTEMFILE';
      try
         Open;
         SystemInteger := FieldByName(sField).AsInteger;
         Close;
      except
      //
      end;
   end;
end;

function ProcString(Proc: string; LookupValue: integer): string;
begin
   Result := IntToStr(dmConnection.orsInsight.ExecProc('getDocSequence',[lookupValue]));
end;

function ReportVersion( const sgFileName: string): string;
var
  wVersionMajor, wVersionMinor, wVersionRelease, wVersionBuild : Word;
  VerInfoSize:  DWORD;
  verBuf:      Pointer;
  VerValueSize: DWORD;
  VerValue:     PVSFixedFileInfo;
  Dummy:        DWORD;
  wnd:          UINT;
  FixedFileInfo : PVSFixedFileInfo;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(sgFileName), wnd);

  result := '';

   if VerInfoSize <> 0 then
  begin
    GetMem(verBuf, VerInfoSize);
    try
      if GetFileVersionInfo(PChar(sgFileName), wnd, VerInfoSize, verBuf) then
      begin
        VerQueryValue(verBuf, '\', Pointer(FixedFileInfo), VerInfoSize);

        result := IntToStr(FixedFileInfo.dwFileVersionMS div $10000) + '.' +
                  IntToStr(FixedFileInfo.dwFileVersionMS and $0FFFF) + '.' +
                  IntToStr(FixedFileInfo.dwFileVersionLS div $10000) + '.' +
                  IntToStr(FixedFileInfo.dwFileVersionLS and $0FFFF);
      end;
    finally
      FreeMem(verBuf);
    end;
  end;
end;

function IndexPath(PathText, PathLoc: string): string;
var
   iWords, i: integer;
   NewPath, sWord, sNewline, AUNCPath: string;
   LImportFile: array of string;
begin
   AUNCPath := ExpandUNCFileName(PathText);
   NewPath := SystemString(PathLoc);
   if NewPath <> '' then
   begin
      iWords := 0;
      SetLength(LImportFile,length(PathText));
      sNewline := copy(PathText,3,length(PathText));
      while TokenizePath(sNewline ,sWord) do
      begin
         LImportFile[iWords] := sWord;
         inc(iWords);
      end;

      for i := 0 to (length(LImportFile) - 1) do
      begin
         if LImportFile[i] <> '' then
            NewPath := NewPath + '/' + LImportFile[i];
      end;
      Result := NewPath;
   end
   else
      Result := AUNCPath;  //PathText;
end;

function TokenizePath(var s,w:string):boolean;
{Note that this a "destructive" getword.
  The first word of the input string s is returned in w and
  the word is deleted from the input string}
const
  delims:set of char = ['/','\'];
var
  i:integer;
begin
  w:='';
  if length(s)>0 then
  begin
    i:=1;
    while (i<length(s))  and (s[i] in delims) do inc(i);
    delete(s,1,i-1);
    i:=1;
    while (i<=length(s)) and (not (s[i] in delims)) do inc(i);
    w:=copy(s,1,i-1);
    delete(s,1,i);
  end;
  result := (length(w) >0);
end;

function MoveMatterDoc(var ANewDocName: string; AOldDocName: string): boolean;
var
   ADocumentSaved: boolean;
   AError: integer;
begin
   ADocumentSaved := True;
   try
      // Check if directory exists
      if not DirectoryExists(ExtractFileDir(ANewDocName)) then
         ForceDirectories(ExtractFileDir(ANewDocName));
      // try to copy file
      if not CopyFile(PChar(AOldDocName) ,pchar(ANewDocName), true) then
      begin
         AError := GetLastError;
         case AError of
            80: begin
                   if Application.MessageBox('File already exists. Do you want to overwrite it?' , 'SpeediDocs', MB_YESNO + MB_ICONQUESTION) = IDYES then
                      ADocumentSaved := CopyFile(PChar(AOldDocName) ,pchar(ANewDocName), false);
                end;
            82: begin
                  Application.MessageBox(pchar('There was an error during the saving of the document.  The directory or file could not be created. ['+ ANewDocName + ']'), 'SpeediDocs', MB_OK + MB_ICONERROR);
                  ADocumentSaved := False;
                end;
            5:  begin
                  Application.MessageBox('There was an error during the saving of the document.  Access denied.', 'SpeediDocs', MB_OK + MB_ICONERROR);
                  ADocumentSaved := False;
                end;
            39,112: begin
                  Application.MessageBox('There was an error during the saving of the document.  The disk is full!', 'SpeediDocs', MB_OK + MB_ICONERROR);
                  ADocumentSaved := False;
                end;
            111:begin
                  Application.MessageBox('There was an error during the saving of the document.  The filename is to long!', 'SpeediDocs', MB_OK + MB_ICONERROR);
                  ADocumentSaved := False;
                end;
            53 :begin
                  Application.MessageBox(pchar('There was an error during the saving of the document.  The network path was not found! ['+pchar(ANewDocName)+']'), 'SpeediDocs', MB_OK + MB_ICONERROR);
                  ADocumentSaved := False;
                end;
            3  :begin
                  Application.MessageBox(pchar('There was an error during the saving of the document.  The system cannot find the path specified! ['+pchar(ANewDocName)+']'), 'SpeediDocs', MB_OK + MB_ICONERROR);
                  ADocumentSaved := False;
                end;
         else
            Application.MessageBox(pchar(pchar('There was an error during the saving of the document.  The document was not saved. Error: ' + IntTostr(AError)) +' ['+ANewDocName+']'), 'SpeediDocs', MB_OK + MB_ICONERROR);
            ADocumentSaved := False;
         end;
      end;
      // delete file if succesfull
//      if ADocumentSaved then
//         DeleteFile(pChar(AOldDocName));
   except
      on E: Exception do
      begin
         Application.MessageBox(pchar('There was an Error during the saving of the document.  The document was not saved: ' + E.Message), 'SpeediDocs', MB_OK + MB_ICONERROR);
         ADocumentSaved := False;
      end;
   end;
   Result := ADocumentSaved;
end;

function MatterString(sFile: string; sField: string): string; overload;
var
  sGetField: string;
  qryThisMatter: TOraQuery;
begin
  Result := '';
  qryThisMatter := TOraQuery.Create(nil);
  try
    sGetField := sField;

    with qryThisMatter do
    begin
      Connection := dmConnection.orsInsight;
      SQL.Text := 'SELECT ' + sGetField + ' FROM MATTER M WHERE FILEID = :FILEID';
      Params[0].AsString := sFile;
      Open;
      if not IsEmpty then
        Result := FieldByName(sField).AsString;
      Close;
    end;
  except
    On E:Exception do
      Application.MessageBox(pchar('Error occured accessing Matter field ' + sGetField + #13#13 + E.Message), 'Insight', MB_OK + MB_ICONERROR);
  end;
  qryThisMatter.Free;
end;

function MatterString(iFile: integer; sField: string): string; overload;
var
  sGetField: string;
  qryThisMatter: TOraQuery;
begin
  Result := '';
  qryThisMatter := TOraQuery.Create(nil);
  try
    sGetField := sField;

    with qryThisMatter do
    begin
      if dmConnection.orsInsight.Connected = False then dmConnection.GetUserID;
      Connection := dmConnection.orsInsight;
      SQL.Text := 'SELECT ' + sGetField + ' FROM MATTER M WHERE NMATTER = :NMATTER';
      Params[0].AsInteger := iFile;
      Open;
      if not IsEmpty then
        Result := FieldByName(sField).AsString;
      Close;
    end;
  except
    On E:Exception do
      Application.MessageBox(pchar('Error occured accessing Matter field ' + sGetField + #13#13 + E.Message), 'Insight', MB_OK + MB_ICONERROR);
  end;
  qryThisMatter.Free;
end;

function TableCurrency(Table, LookupField, LookupValue, ReturnField: string): currency;
var
  qryLookup: TOraQuery;
begin
   qryLookup := TOraQuery.Create(nil);
   qryLookup.Connection := dmConnection.orsInsight;
   with qryLookup do
   begin
      SQL.Text := 'SELECT ' + ReturnField + ' FROM ' + Table + ' WHERE ' + LookupField + ' = :' + LookupField;
      Params[0].AsString := LookupValue;
      Open;
      Result := Fields[0].AsCurrency;
      Close;
   end;
   qryLookup.Free;
end;


function TableCurrency(Table, LookupField: string; LookupValue: Integer; ReturnField: string): currency;
var
  qryLookup: TOraQuery;
begin
   qryLookup := TOraQuery.Create(nil);
   qryLookup.Connection := dmConnection.orsInsight;
   with qryLookup do
   begin
      SQL.Text := 'SELECT ' + ReturnField + ' FROM ' + Table + ' WHERE ' + LookupField + ' = :' + LookupField;
      Params[0].AsInteger := LookupValue;
      Open;
      Result := Fields[0].AsCurrency;
      Close;
   end;
   qryLookup.Free;
end;

function FeeRate(sFeeType, sFileID, sAuthor: string; Fee_Date: TDateTime): Currency;
{ Work out the fee rate. The fee rate is worked out by, in order of priority:
  1. If Fee.Type is not 'N', then use the FeeType rate if non-zero.
  2. If Matter.Rate is non-zero, use it.
  3. iF Matter.FeeCode is not null, look up the FeeCode/EmpCode combination's rate.
  4. If Matter.FeeCode is not null, look up the FeeCode/EmpType combination's rate.
  5. If MatterType.Fee_Rate is nonzero, use it
  6. If MatterType.FeeCode is not null, then look up the MatterType.FeeCode/EmpType combination's rate.
  7. Use Employee.Rate
}
var
  cRate, cAuthorRate: currency;
  sMatterType, sFeeCode, sEmpType: string;
  bContinue: boolean;
begin
  cRate := 0;
  cAuthorRate := 0;
  bContinue := True;
  with dmConnection.qryTmp do
  begin
    if sFeeType <> 'N' then
    begin
      // 1. Use the FeeType.Rate if it exists
      Close;
      SQL.Text := 'SELECT RATE FROM FEETYPE WHERE CODE = :CODE';
      Params[0].AsString := sFeeType;
      Open;
      if not IsEmpty then
      begin
        if FieldByName('RATE').AsFloat <> 0 then
        begin
          cRate := FieldbyName('RATE').AsFloat;
          bContinue := False;
        end;
      end;
    end;

    // If normal fee
    if bContinue then
    begin
       // We'll need to get the employee details now
       Close;
       SQL.Text := 'SELECT TYPE, RATE FROM EMPLOYEE WHERE CODE = :CODE';
       Params[0].AsString := sAuthor;
       Open;
       if not IsEmpty then
       begin
          cAuthorRate := FieldbyName('RATE').AsFloat;
          sEmpType := FieldbyName('TYPE').AsString;
       end
       else
       begin
          cAuthorRate := 0;
          sEmpType := '';
       end;

       // Check the Matter details
       Close;
       SQL.Text := 'SELECT RATE, FEECODE, TYPE FROM MATTER WHERE FILEID = :FILEID';
       Params[0].AsString := sFileID;
       Open;
       if not IsEmpty then
       begin
         sMatterType := FieldByName('TYPE').AsString;
         // 2. Matter.Rate
         if FieldbyName('RATE').AsFloat <> 0 then
         begin
           if FieldbyName('RATE').AsFloat < 5 then
             cRate := FieldbyName('RATE').AsFloat * cAuthorRate
           else
             cRate := FieldbyName('RATE').AsFloat;
           bContinue := False;
         end
         else
           sFeeCode := FieldByName('FEECODE').AsString;
       end;
    end;
    if bContinue then
    begin
      if (sFeeCode <> '') and (sAuthor <> '') then
      begin
        // 3. FeeCode/EmpCode rate
        Close;
        SQL.Clear;
        SQL.Add('SELECT RATE');
        SQL.Add('FROM FEECODE_EMP');
        SQL.Add('WHERE FEECODE = :FEECODE');
        SQL.Add('AND EMP_CODE = :EMPCODE');
        SQL.Add('AND :FEE_DATE between EFFECTIVE_FROM AND NVL(EFFECTIVE_TO,''31-DEC-4712'')');
        Params[0].AsString := sFeeCode;
        Params[1].AsString := sAuthor;
        Params[2].AsDateTime := Fee_Date;
        Open;
        if not IsEmpty then
        begin
          if FieldByName('RATE').Value <> Null then
          begin
            cRate := FieldbyName('RATE').AsFloat;
            bContinue := False;
          end;
        end;
      end;
    end;

    if bContinue then
    begin
      if (sFeeCode <> '') and (sEmpType <> '') then
      begin
        // 4. FeeCode/EmpType rate
        Close;
        SQL.Clear;
        SQL.Add('SELECT RATE');
        SQL.Add('FROM FEECODETYPE');
        SQL.Add('WHERE FEECODE = :FEECODE');
        SQL.Add('AND EMPTYPE = :EMPTYPE');
        SQL.Add('AND :FEE_DATE between EFFECTIVE_FROM AND NVL(EFFECTIVE_TO,''31-DEC-4712'')');
        Params[0].AsString := sFeeCode;
        Params[1].AsString := sEmpType;
        Params[2].AsDateTime := Fee_Date;
        Open;
        if not IsEmpty then
        begin
          if FieldByName('RATE').Value <> Null then
          begin
            cRate := FieldbyName('RATE').AsFloat;
            bContinue := False;
          end;
        end;
      end;
    end;

    if bContinue then
    begin
      // Try the Matter Type
      Close;
      SQL.Clear;
      SQL.Add('SELECT FEE_RATE, FEECODE');
      SQL.Add('FROM MATTERTYPE');
      SQL.Add('WHERE CODE = :CODE');
      Params[0].AsString := sMatterType;
      Open;
      if not IsEmpty then
      begin
        if FieldByName('FEE_RATE').AsFloat <> 0 then
        begin
          // 5. MatterType.Fee_Rate
          if FieldByName('FEE_RATE').AsFloat < 5 then
            cRate := FieldByName('FEE_RATE').AsFloat * cAuthorRate
          else
            cRate := FieldByName('FEE_RATE').AsFloat;
          bContinue := False;
        end
        else
        begin
          sFeeCode := FieldByName('FEECODE').AsString;
          if (sFeeCode <> '') and (sEmpType <> '') then
          begin
            // 6. MatterType.FeeCode/EmpType rate
            Close;
            SQL.Clear;
            SQL.Add('SELECT RATE');
            SQL.Add('FROM FEECODETYPE');
            SQL.Add('WHERE FEECODE = :FEECODE');
            SQL.Add('AND EMPTYPE = :EMPTYPE');
            SQL.Add('AND :FEE_DATE between EFFECTIVE_FROM AND NVL(EFFECTIVE_TO,''31-DEC-4712'')');
            Params[0].AsString := sFeeCode;
            Params[1].AsString := sEmpType;
            Params[2].AsDateTime := Fee_Date;
            Open;
            if not IsEmpty then
            begin
              if FieldByName('RATE').Value <> Null then
              begin
                cRate := FieldbyName('RATE').AsFloat;
                bContinue := False;
              end;
            end;
          end;
        end;
      end;
    end;

    // Pass back the result
    if bContinue then
      FeeRate := cAuthorRate
    else
      FeeRate := cRate;
    Close;
  end;
end;

procedure FeeInsert(NMatter: integer; Author: string; Reason: string; Amount: Currency;
                    ATask: string; AUnits: integer; AMinutes: real; ARate: currency;
                    ATaxType: string);
var
  dAmount: Currency;
begin
  try
     with dmConnection.qryTmp do
     begin
       Connection := dmConnection.orsInsight;
       SQL.Text := 'SELECT PARTNER, FILEID, NCLIENT FROM MATTER WHERE NMATTER = :NMATTER';
       Params[0].AsInteger := NMatter;
       Open;
     end;
     if not dmConnection.qryTmp.IsEmpty then
       try
         with dmConnection.qryFeeInsert do
         begin
           ParamByName('CREATED').AsDateTime := Now;
           ParamByName('AUTHOR').AsString := Author;
           ParamByName('PARTNER').AsString := dmConnection.qryTmp.FieldByName('PARTNER').AsString;
           ParamByName('BANK_ACCT').AsString := dmConnection.Entity;
           ParamByName('DEPT').AsString := TableString('EMPLOYEE', 'CODE', Author, 'DEPT');
           ParamByName('EMP_TYPE').AsString := TableString('EMPLOYEE', 'CODE', Author, 'TYPE');
           ParamByName('DESCR').AsString := Reason;
           ParamByName('FILEID').AsString := dmConnection.qryTmp.FieldByName('FILEID').AsString;
           ParamByName('NMATTER').AsInteger := NMatter;
           ParamByName('NCLIENT').AsInteger := dmConnection.qryTmp.FieldByName('NCLIENT').AsInteger;
           ParamByName('TAXCODE').AsString := ATaxType;
           dAmount := Amount;
           ParamByName('TAX').AsFloat := TaxCalc(dAmount, '', dmConnection.DefaultTax, Now);
           ParamByName('AMOUNT').AsFloat := dAmount;
           ParamByName('TASK').AsString := ATask;
           ParamByName('UNITS').AsInteger := AUnits;
           ParamByName('MINS').AsFloat := AMinutes;
           ParamByName('RATE').AsCurrency := ARate;
           Prepare;
           Execute;
//           MatterUpdate(NMatter, 'UNBILL_FEES', dAmount + TaxCalc(dAmount, '', dmSaveDoc.DefaultTax, Now));

         end;
       except
         On E:Exception do
            Application.MessageBox(pchar('Error occured inserting fee'#13#13 + E.Message),'Insight', MB_OK+MB_ICONERROR);
       end;
  finally
     dmConnection.orsInsight.Commit;
     dmConnection.qryTmp.Close;
  end;
end;

procedure FeeTmpInsert(NMatter: integer; AAuthor: string; Reason: string; Amount: Currency;
                    ATask: string; AUnits: integer; AMinutes: real; ARate: currency;
                    ATaxType: string = 'GST');
var
   dAmount: Currency;
   lUnits: string;
begin
  try
     with dmConnection.qryTmp do
     begin
       Connection := dmConnection.orsInsight;
       SQL.Text := 'SELECT PARTNER, FILEID, NCLIENT, TITLE, SHORTDESCR FROM MATTER WHERE NMATTER = :NMATTER';
       Params[0].AsInteger := NMatter;
       Open;
     end;
     if not dmConnection.qryTmp.IsEmpty then
       try
         with dmConnection.qryFeeTmpInsert do
         begin
           ParamByName('CREATED').AsDateTime := Now;
           ParamByName('AUTHOR').AsString := AAuthor;
//           ParamByName('PARTNER').AsString := dmSaveDoc.qryTmp.FieldByName('PARTNER').AsString;
//           ParamByName('BANK_ACCT').AsString := dmSaveDoc.Entity;
           if (ATask <> '') then
           begin
              lUnits := TableString('SCALECOST','CODE', ATask, 'UNIT');
              if lUnits = '' then
                 lUnits := 'Units';
           end;
           ParamByName('UNIT').AsString := lUnits;
           ParamByName('EMPCODE').AsString := AAuthor;
           ParamByName('EMP_TYPE').AsString := TableString('EMPLOYEE', 'CODE', AAuthor, 'TYPE');
           ParamByName('DESCR').AsString := Reason;
           ParamByName('FILEID').AsString := dmConnection.qryTmp.FieldByName('FILEID').AsString;
           ParamByName('NMATTER').AsInteger := NMatter;
//           ParamByName('NCLIENT').AsInteger := dmSaveDoc.qryTmp.FieldByName('NCLIENT').AsInteger;
           ParamByName('TAXCODE').AsString := ATaxType;
           dAmount := Amount;

           ParamByName('MATLOCATE').AsString := dmConnection.qryTmp.FieldByName('TITLE').AsString +' - ' + dmConnection.qryTmp.FieldByName('SHORTDESCR').AsString;
           ParamByName('CAPTION').AsString := dmConnection.qryTmp.FieldByName('FILEID').AsString +' - ' + dmConnection.qryTmp.FieldByName('SHORTDESCR').AsString;
           ParamByName('AMOUNT').AsFloat := dAmount;
           ParamByName('TASK').AsString := ATask;
           ParamByName('UNITS').AsInteger := AUnits;
           ParamByName('MINS').AsFloat := AMinutes;
           ParamByName('RATE').AsCurrency := ARate;
           ParamByName('TAX').AsFloat := TaxCalc(dAmount, '', dmConnection.DefaultTax, Now);
           ParamByName('VERSION').AsString := ReportVersion(SysUtils.GetModuleName(HInstance));
           Prepare;
           Execute;
//           MatterUpdate(NMatter, 'UNBILL_FEES', dAmount + TaxCalc(dAmount, '', dmSaveDoc.DefaultTax, Now));

         end;
       except
         On E:Exception do
            Application.MessageBox(pchar('Error occured saving entry'#13#13 + E.Message),'Insight', MB_OK+MB_ICONERROR);
       end;
  finally
     dmConnection.orsInsight.Commit;
     dmConnection.qryTmp.Close;
  end;
end;


function TaxCalc(var Amount: Currency; RateType, TaxCode: string; TaxDate: TDateTime): Currency; overload;
   function TruncateTax(TaxAmt: Double): Double;
   var
      TruncAmt: Double;
      qryRate: TOraQuery;
   begin
      qryRate := TOraQuery.Create(nil);
      with qryRate do
      begin
        Connection := dmConnection.orsInsight;
//        SQL.Text := 'SELECT trunc(:TaxAmt,2) as TaxAmt from dual';
        SQL.Text := 'SELECT round(:TaxAmt,2) as TaxAmt from dual';
        qryRate.Params[0].AsFloat := TaxAmt;
        Open;
        TruncAmt := Fields[0].AsCurrency;
        Close;
      end;
      qryRate.Free;
      Result := TruncAmt;
   end;
var
  lcTaxRate : Currency;
  lcTax     : Currency;
  lcAmount  : Currency;
  // lcTaxTmp  : Currency;
begin
  lcAmount := FloatToCurr(Amount);
  lcTaxRate := FloatToCurr(TaxRate(RateType, TaxCode, TaxDate));

  if (lcTaxRate < 0) then
  begin
    lcTaxRate := Abs(lcTaxRate);

    if (TableString('TAXTYPE', 'CODE', TaxCode, 'WITHHOLDING') = 'Y') then
      lcTax := TruncateTax((lcAmount * lcTaxRate * 100) / 100)
    else
      lcTax := TruncateTax(((lcAmount * (lcTaxRate / (1 + lcTaxRate))) * 100) / 100);

    Amount := lcAmount - lcTax;
  end
  else
     lcTax := TruncateTax((lcAmount * lcTaxRate * 100) / 100);

  Result := lcTax;
end;

function TaxRate(RateType, TaxCode: string; Commence: TDateTime): Double;
begin
  with dmConnection.qryTmp do
  begin
    SQL.Clear;
    SQL.Add('SELECT RATE, BILL_RATE');
    SQL.Add('FROM TAXRATE');
    SQL.Add('WHERE TAXCODE = :TAXCODE');
    SQL.Add('  AND COMMENCE = (SELECT MAX(COMMENCE) FROM TAXRATE');
    SQL.Add('    WHERE TAXRATE.TAXCODE = :TAXCODE');
    SQL.Add('      AND TAXRATE.COMMENCE <= :COMMENCE)');
    ParamByName('TAXCODE').AsString := TaxCode;
    ParamByName('COMMENCE').AsDateTime := Trunc(Commence);

    Open;
    if IsEmpty then
      TaxRate := 0
    else
      if RateType = 'BILL' then
        TaxRate := FieldByName('BILL_RATE').AsFloat / 100
      else
        TaxRate := FieldByName('RATE').AsFloat / 100;
    Close;
  end;
end;

function get_default_gst(sform : String) : String;
begin
    dmConnection.qryTmp.SQL.Text := 'SELECT CODE FROM TAXDEFAULT WHERE TYPE=:TYPE';
    dmConnection.qryTmp.Prepare;
    dmConnection.qryTmp.ParamByName('TYPE').AsString := sForm;
    dmConnection.qryTmp.Open;
    get_default_gst := dmConnection.qryTmp.FieldByName('CODE').AsString;

    dmConnection.qryTmp.Close;
end;

function FormExists(frmInput : TForm):boolean;
var
  iCount : integer;
  bResult : boolean;
begin
  bResult := false;
  for iCount := 0 to (Application.ComponentCount - 1) do
    if Application.Components[iCount] is TForm then
      if Application.Components[iCount] = frmInput then
        bResult:=true;
  FormExists := bResult;
end;

function IsMatterArchived(FileId: string): boolean;
begin
   try
      try
         dmConnection.qryTmp.Close;
         dmConnection.qryTmp.SQL.Clear;
         dmConnection.qryTmp.SQL.Add('SELECT ''x'' FROM MATTER WHERE CLOSED = 1 AND ARCHIVED IS NOT NULL ');
         dmConnection.qryTmp.SQL.Add('AND FILEID = :FILEID');
         dmConnection.qryTmp.Params[0].AsString := FileId;
         dmConnection.qryTmp.Open;

         Result := not dmConnection.qryTmp.IsEmpty;
      finally
    end;    //  end try-finally
    except
       on E : Exception do
       begin
          Raise;
       end;
    end;
end;

function MatterIsCurrent(sFile: string): boolean;
begin
   with dmConnection.qryTmp do
   begin
      Close;
      SQL.Text := 'SELECT ''x'' FROM MATTER WHERE FILEID = :FILEID AND CLOSED = 0';
      Params[0].AsString := sFile;
      Open;
      Result := not dmConnection.qryTmp.IsEmpty;
      Close;
   end;
end;

function MatterExists(sFile: string): boolean;
begin
   if dmConnection.orsInsight.Connected = False then dmConnection.GetUserID();

   with dmConnection.qryTmp do
   begin
      Close;
      SQL.Text := 'SELECT FILEID FROM MATTER WHERE FILEID = :FILEID';
      Params[0].AsString := sFile;
      Open;
      Result := not IsEmpty;
      Close;
   end;
end;

procedure Split(const S: String; Separator: Char; MyStringList: TStringList) ;
var
   Start: integer;
begin
   Start := 1;
   While Start <= Length(S) do
      MyStringList.Add(GetNextToken(S, Separator, Start));
end;

function GetNextToken(Const S: string; Separator: char; var StartPos: integer): String;
var
   Index: integer;
begin
   Result := '';

   {Step over repeated separators}
   While (S[StartPos] = Separator) and (StartPos <= length(S))do
      StartPos := StartPos + 1;

   if StartPos > length(S) then Exit;

   {Set Index to StartPos}
   Index := StartPos;

   {Find the next Separator}
   While (S[Index] <> Separator) and (Index <= length(S))do
      Index := Index + 1;

   {Copy the token to the Result}
   Result := Copy(S, StartPos, Index - StartPos) ;

   {SetStartPos to next Character after the Separator}
   StartPos := Index + 1;
end;

function IsFileInUse(fName: string) : boolean;
var
  HFileRes: HFILE;
begin
  Result := False;
  if not FileExists(fName) then begin
    Exit;
  end;

  HFileRes := CreateFile(PChar(fName)
    ,GENERIC_READ or GENERIC_WRITE
    ,0
    ,nil
    ,OPEN_EXISTING
    ,FILE_ATTRIBUTE_NORMAL
    ,0);

  Result := (HFileRes = INVALID_HANDLE_VALUE);

  if not(Result) then begin
    CloseHandle(HFileRes);
  end;
end;

function CalcRate(pAuthor, lTask: string; lReceivedDate: TDateTime; pFileID: string): double;
begin
//   if ((TableCurrency('SCALECOST','CODE',string(lTask),'AMOUNT') <> 0) and
//      (TableString('SCALECOST','CODE',string(lTask),'ZERO_FEE') = 'N')) then
   CalcRate := FeeRate('0', pFileID, pAuthor, lReceivedDate);
end;

function IsMatterPrivate(ANMatter: integer; ARestrictMatter: string): boolean;
begin
   with dmConnection.procTemp do
   begin
      Close;
      StoredProcName := 'isallowedmatteraccess';
      PrepareSQL;
      Params[1].AsInteger  := ANMatter;
      Params[2].AsString   := dmConnection.UserID;
      Params[3].AsString   := ARestrictMatter;
      Execute;
      Result := (Params[0].AsInteger = 1);
   end;
end;

function PadFileID(AFileID: string): string;
var
  sMatterSeparator,
  sNewFileID,
  sFileIDExtract,
  sFileIDExtractNew,
  sMatterCode: string;
  i,
  iCount,
  iMatterPad: integer;
begin
   iCount := 0;
   sNewFileID := AFileID;
   sMatterCode := TableString('ENTITY','CODE', dmConnection.Entity,'MATTERCODE');
   sMatterSeparator := TableString('ENTITY','CODE', dmConnection.Entity,'MATTERSEPERATOR');
   iMatterPad := TableInteger('ENTITY','CODE', dmConnection.Entity,'MATTERPAD');
   if (pos(sMatterSeparator,sNewFileID) > 0) and (sMatterSeparator <> '')
      and (sMatterCode <> 'N')  then
   begin
      for I := length(sNewFileID) downto 0 do
      begin
         if sNewFileID[i] = sMatterSeparator then
            break;
         sFileIDExtract := sNewFileID[i] + sFileIDExtract;
         Inc(iCount);
      end;
   end;
   if (iCount < iMatterPad) and (icount > 0) then
   begin
      sFileIDExtractNew := Copy('000000' + sFileIDExtract, Length(sFileIDExtract) + 7 - iMatterPad, iMatterPad);
      sNewFileID := copy(snewfileid, 1,  length(sNewFileID)-iCount)+ sFileIDExtractNew;
   end;
   Result :=  sNewFileID;
end;

procedure MsgErr(sMsg: string);
begin
  MessageDlg(Format('%s',[sMsg]), mtError, [mbOK], 0);
end;

procedure MsgInfo(sMsg: string);
begin
  MessageDlg(Format('%s',[sMsg]), mtInformation, [mbOK], 0);
end;

function MsgAsk(sMsg: string): integer;
begin
  Result := MessageDlg(Format('%s',[sMsg]), mtConfirmation, [mbYes,mbNo], 0);
end;

function TFileSystemBindData.GetFindData(var w32fd: TWin32FindData): HRESULT;
begin
  w32fd:= fw32fd;
  Result := S_OK;
end;

function TFileSystemBindData.SetFindData(var w32fd: TWin32FindData): HRESULT;
begin
  fw32fd := w32fd;
  Result := S_OK;
end;

function CopyFileIFileOperationForceDirectories(const srcFile, destFile : string; DeleteOrigDoc: boolean) : boolean;
//works on Windows >= Vista and 2008 server
var
  r : HRESULT;
  fileOp: IFileOperation;
  siSrcFile: IShellItem;
  siDestFolder: IShellItem;
  destFileFolder, destFileName : string;
  pbc : IBindCtx;
  w32fd : TWin32FindData;
  ifs : TFileSystemBindData;
begin
   result := false;

   destFileFolder := ExtractFileDir(destFile);
   destFileName := ExtractFileName(destFile);

   if FileExists(destFile) then
      Result := False
   else
   begin
      //init com
      r := CoInitializeEx(nil, COINIT_APARTMENTTHREADED or COINIT_DISABLE_OLE1DDE);
      if Succeeded(r) then
      begin
         //create IFileOperation interface
         r := CoCreateInstance(CLSID_FileOperation, nil, CLSCTX_ALL, IFileOperation, fileOp);
         if Succeeded(r) then
         begin
            //set operations flags
            r := fileOp.SetOperationFlags(FOF_NOCONFIRMATION OR FOFX_NOMINIMIZEBOX);
            if Succeeded(r) then
            begin
               //get source shell item
               r := SHCreateItemFromParsingName(PChar(srcFile), nil, IShellItem, siSrcFile);
               if Succeeded(r) then
               begin
                  //create binding context to pretend there is a folder there
                  if NOT DirectoryExists(destFileFolder) then
                  begin
                     ZeroMemory(@w32fd, Sizeof(TWin32FindData));
                     w32fd.dwFileAttributes := FILE_ATTRIBUTE_DIRECTORY;
                     ifs := TFileSystemBindData.Create;
                     ifs.SetFindData(w32fd);
                     CreateBindCtx(0, pbc);
                     pbc.RegisterObjectParam(STR_FILE_SYS_BIND_DATA, ifs);
                  end
                  else
                     pbc := nil;

                  //get destination folder shell item
                  r := SHCreateItemFromParsingName(PChar(destFileFolder), pbc, IShellItem, siDestFolder);

                  if DeleteOrigDoc = False then
                  //add copy operation
                     if Succeeded(r) then r := fileOp.CopyItem(siSrcFile, siDestFolder, PChar(destFileName), nil)
                  else
                  //add move operation
                     if Succeeded(r) then r := fileop.MoveItem(siSrcFile, siDestFolder, PChar(destFileName), nil)
               end;

               //execute
               if Succeeded(r) then r := fileOp.PerformOperations;

               result := Succeeded(r);

               OleCheck(r);
            end;
         end;

         CoUninitialize;
      end;
   end;
end;

function WriteFileToDisk(var ANewDocName: string; AOldDocName: string; ADeleteFile: boolean): boolean;
var
   NewDocName{, AParsedDocName}: string;
   ADocumentSaved: boolean;
   AError: integer;
begin
   ADocumentSaved := True;

   if (ANewDocName <> '') then
   begin
      if not DirectoryExists(ExtractFileDir(ANewDocName)) then
         ForceDirectories(ExtractFileDir(ANewDocName));
   end;

   try
      if not CopyFile(PChar(AOldDocName) ,pchar(ANewDocName), true) then
      begin
         AError := GetLastError;
         case AError of
            80: begin
                   if MsgAsk(pchar('File [' + ANewDocName + '] already exists. Do you want to overwrite it?' )) = IDYES then
                      ADocumentSaved := CopyFile(PChar(AOldDocName) ,pchar(ANewDocName), false)
                   else
                      ADocumentSaved := False;
                end;
            82: begin
                  MsgErr(pchar('There was an error during the saving of the document.  The directory or file could not be created.'));
                  ADocumentSaved := False;
                end;
            5:  begin
                  MsgErr(pchar('There was an error during the saving of the document.  Access denied.'));
                  ADocumentSaved := False;
                end;
            39,112: begin
                  MsgErr(pchar('There was an error during the saving of the document.  The disk is full!'));
                  ADocumentSaved := False;
                end;
            111:begin
                  MsgErr(pchar('There was an error during the saving of the document.  The filename is to long!'));
                  ADocumentSaved := False;
                end;
            53 :begin
                  MsgErr(pchar('There was an error during the saving of the document.  The network path was not found!'));
                  ADocumentSaved := False;
                end;
            3:  begin
                  MsgErr(pchar('There was an error during the saving of the document.  The system cannot find the path specified!'));
                  ADocumentSaved := False;
                end;
            2:  begin
                  MsgErr(pchar('There was an error during the saving of the document.  The system cannot find the file specified!'));
                  ADocumentSaved := False;
                end;
         else
            MsgErr(pchar('There was an error during the saving of the document.  The document was not saved. Error: ' + IntTostr(AError)));
            ADocumentSaved := False;
         end;
      end;
      if (ADeleteFile and ADocumentSaved) then
         DeleteFile(pchar(AOldDocName));
   except
      on E: Exception do
      begin
         MsgErr(pchar('There was an Error during the saving of the document.  The document was not saved: ' + E.Message));
         ADocumentSaved := False;
      end;
   end;
   Result := ADocumentSaved;
end;

function StripNonAscii(s: string): string;
var
   Count, i:Integer;
begin
   Count := 0;
   for i:=1 to Length(s) do
      if ((s[i] >= #32) and (s[i] <= #127)) or (s[i] in [#10, #13]) then
         Inc(Count);
   if Count = Length(s) then
      Result := s // No characters need to be removed, return the original string (no mem allocation!)
   else
   begin
      SetLength(Result, Count);
      Count := 1;
      for i:=1 to Length(s) do
         if ((s[i] >= #32) and (s[i] <= #127)) or (s[i] in [#10, #13]) then
         begin
            Result[Count] := s[i];
            Inc(Count);
         end;
   end;
end;

end.

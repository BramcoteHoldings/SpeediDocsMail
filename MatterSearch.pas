unit MatterSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,
  dxDateRanges, cxDataControllerConditionalFormattingRulesManagerDialog,
  Data.DB, cxDBData, cxContainer, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls,
  cxButtons, cxCheckBox, cxTextEdit, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid,
  Registry;

type
  TfrmMtrSearch = class(TForm)
    tmrSearch: TTimer;
    tvMatters: TcxGridDBTableView;
    grdMattersLevel1: TcxGridLevel;
    grdMatters: TcxGrid;
    tvMattersNMATTER: TcxGridDBColumn;
    tvMattersPARTNER: TcxGridDBColumn;
    tvMattersAUTHOR: TcxGridDBColumn;
    tvMattersTYPE: TcxGridDBColumn;
    tvMattersFILEID: TcxGridDBColumn;
    tvMattersSTATUS: TcxGridDBColumn;
    tvMattersARCHIVED: TcxGridDBColumn;
    tvMattersLONGDESCR: TcxGridDBColumn;
    tvMattersCLIENTID: TcxGridDBColumn;
    tvMattersTITLE: TcxGridDBColumn;
    Panel1: TPanel;
    Label1: TLabel;
    tbClientSearch: TcxTextEdit;
    tbFileSearch: TcxTextEdit;
    Label2: TLabel;
    cbShowRecentlyAccessed: TcxCheckBox;
    btnOk: TcxButton;
    btnCancel: TcxButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure vMattersDblClick(Sender: TObject);
    procedure cbShowRecentlyAccessedClick(Sender: TObject);
    procedure tbClientSearchPropertiesChange(Sender: TObject);
    procedure tmrSearchTimer(Sender: TObject);    
    procedure EnableTimer(Sender: TObject);
    procedure tbClientSearchChange(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure gridMattersDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tbFileSearchPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    sOrderBy: string;
    FSQL: string;
//    dmSaveDoc: TdmSaveDoc;
  public
    { Public declarations }
//    dmSaveDoc: TdmSaveDoc;
      property SQL: string read FSQL write FSQL;
    procedure MakeSql(bSearch: boolean = False);
  end;

var
  frmMtrSearch: TfrmMtrSearch;

implementation

{$R *.dfm}

uses
   SaveDocFunc, SpeediDocsMail_IMPL;

procedure TfrmMtrSearch.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  regAxiom: TRegistry;
  lShowMRU: string;
begin
   regAxiom := TRegistry.Create;
   try
      regAxiom.RootKey := HKEY_CURRENT_USER;
      if regAxiom.OpenKey(csRegistryRoot, True) then
      begin
         lShowMRU := 'N';
         if cbShowRecentlyAccessed.Checked then
            lShowMRU := 'Y';
         regAxiom.WriteString('ShowMRU', lShowMRU);
      end;
      regAxiom.CloseKey;
   finally
      regAxiom.Free;
   end;

//   dmSaveDoc.qryMatters.Active := False;
end;

procedure TfrmMtrSearch.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//   dmSaveDoc.orsInsight.Disconnect;
//   dmSavedoc.Free;
//   dmSaveDoc := nil;
end;

procedure TfrmMtrSearch.FormCreate(Sender: TObject);
var
  regAxiom: TRegistry;
begin
   regAxiom := TRegistry.Create;
   try
      cbShowRecentlyAccessed.OnClick := nil;
      regAxiom.RootKey := HKEY_CURRENT_USER;
      if regAxiom.OpenKey(csRegistryRoot, True) then
      begin
         cbShowRecentlyAccessed.Checked := (regAxiom.ReadString('ShowMRU') = 'Y');
      end;
      regAxiom.CloseKey;
   finally
      regAxiom.Free;
      cbShowRecentlyAccessed.OnClick := cbShowRecentlyAccessedClick;
   end;
//   if (Assigned(dmSaveDoc) = False) then
//      dmSaveDoc := TdmSaveDoc.Create(nil);
end;

procedure TfrmMtrSearch.FormShow(Sender: TObject);
begin
//   if dmSaveDoc.orsInsight.Connected = False then dmSaveDoc.GetUserID();
   MakeSql;
end;

procedure TfrmMtrSearch.gridMattersDblClick(Sender: TObject);
begin
   btnOk.Click;
end;

procedure TfrmMtrSearch.vMattersDblClick(Sender: TObject);
begin
   btnOk.Click;
end;

procedure TfrmMtrSearch.MakeSql(bSearch: boolean);
var
   lsSQL,
   lsTables,
   lsWhereClause,
   lsAND: string;
begin
   try
      dmConnection.qryMatters.Close;
      dmConnection.qryMatters.SQL.Clear;
      if SQL <> '' then
      begin
         lsSQL := SQL;
         dmConnection.qryMatters.SQL.Text := lsSQL;
         dmConnection.qryMatters.Prepare;
         SQL := '';
      end
      else
      begin
         lsAND := ' AND ';
         lsSQL := 'select * ';
         lsTables := 'from matter ';
         lsWhereClause := ' where closed = 0 AND entity = nvl(:P_Entity, entity) ';
         if bSearch then
         begin
            if tbClientSearch.Text <> '' then
            begin
               lsWhereClause := lsWhereClause + lsAND + ' UPPER(MATTER.TITLE) LIKE ' + QuotedStr('%' + Uppercase(tbClientSearch.Text) + '%');
               if cbShowRecentlyAccessed.Checked then
               begin
                  lsWhereClause := lsWhereClause + ' AND upper(O.AUTHOR) = upper(:P_Author) AND O.TYPE = :P_Type AND O.CODE = MATTER.FILEID ';
                  lsTables := lsTables + ', OPENLIST O ';
               end;

               lsAND := ' AND ';
            end;
            if tbFileSearch.Text <> '' then
            begin
               lsWhereClause := lsWhereClause + lsAND + 'MATTER.FILEID LIKE ' + QuotedStr(tbFileSearch.Text + '%');
               lsAND := ' AND ';
            end;
         end
         else
         begin
            if cbShowRecentlyAccessed.Checked then
            begin
               lsWhereClause := lsWhereClause + ' AND upper(O.AUTHOR) = upper(:P_Author) AND O.TYPE = :P_Type AND O.CODE = MATTER.FILEID ';
               lsTables := lsTables + ', OPENLIST O ';
            end;
         end;
         dmConnection.qryMatters.SQL.Text := lsSQL + lsTables + lsWhereClause + sOrderBy;
         dmConnection.qryMatters.Prepare;
         if cbShowRecentlyAccessed.Checked then
         begin
            dmConnection.qryMatters.ParamByName('P_TYPE').AsString := 'MATTER';
            dmConnection.qryMatters.ParamByName('P_Author').AsString := dmConnection.UserID;
         end;
         dmConnection.qryMatters.ParamByName('P_Entity').Clear;
         if (dmConnection.Entity <> '') then
            dmConnection.qryMatters.ParamByName('P_Entity').AsString := dmConnection.Entity;
         end;

         dmConnection.qryMatters.Open;
   Except
//      if dmSaveDoc.orsInsight.Connected = False then dmSaveDoc.GetUserID();
      MakeSql();
//      Application.MessageBox('An error occurred.','SpeediDocs',);
//      Application.Free;
   end;
end;

procedure TfrmMtrSearch.cbShowRecentlyAccessedClick(Sender: TObject);
begin

   MakeSQL();
end;

procedure TfrmMtrSearch.tbClientSearchPropertiesChange(Sender: TObject);
begin
   EnableTimer(Sender);
end;

procedure TfrmMtrSearch.tbFileSearchPropertiesChange(Sender: TObject);
begin
   EnableTimer(Sender);
end;

procedure TfrmMtrSearch.tbClientSearchChange(Sender: TObject);
begin
   EnableTimer(Sender);
end;

procedure TfrmMtrSearch.Edit1Change(Sender: TObject);
begin
   EnableTimer(Sender);
end;

procedure TfrmMtrSearch.EnableTimer(Sender: TObject);
begin
   tmrSearch.Enabled := true;
end;

procedure TfrmMtrSearch.tmrSearchTimer(Sender: TObject);
begin
   tmrSearch.Enabled := false;
   if ((tbFileSearch.Text = '') and (tbClientSearch.Text = '')) then
      MakeSQL()
   else
      MakeSQL(True);
end;

end.

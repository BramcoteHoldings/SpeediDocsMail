unit DocList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator,
  cxDataControllerConditionalFormattingRulesManagerDialog, Data.DB, cxDBData,
  cxContainer, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxTextEdit, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxGridCustomView, cxGrid, Vcl.ExtCtrls, DBAccess, Ora, MemDS, OraSmart,
  dxSkinsCore, dxSkinOffice2013DarkGray, dxDateRanges;

type
  TfrmDocList = class(TForm)
    Panel1: TPanel;
    tvDocList: TcxGridDBTableView;
    lvDocList: TcxGridLevel;
    gridDocList: TcxGrid;
    tvDocListDOCID: TcxGridDBColumn;
    tvDocListNMATTER: TcxGridDBColumn;
    tvDocListDOC_NAME: TcxGridDBColumn;
    tvDocListD_CREATE: TcxGridDBColumn;
    tvDocListDESCR: TcxGridDBColumn;
    tvDocListFILEID: TcxGridDBColumn;
    tvDocListEMAIL_SENT_TO: TcxGridDBColumn;
    tvDocListEMAIL_FROM: TcxGridDBColumn;
    edtMatter: TcxTextEdit;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    btnSearch: TcxButton;
    tvDocListPATH: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDocList: TfrmDocList;

implementation

{$R *.dfm}

uses
   SaveDoc, SaveDocFunc, SpeediDocsMail_IMPL;

procedure TfrmDocList.btnSearchClick(Sender: TObject);
begin
   if edtMatter.Text <> '' then
   begin
      with dmConnection.qryDocs do
      begin
         Close;
         Sql.Clear;
         Sql.Text := 'SELECT DOCID, NMATTER,DOC_NAME, D_CREATE, AUTH1, D_MODIF, PATH,DESCR, FILEID, DOC_CODE, '+
                     'IMAGEINDEX, FILE_EXTENSION, EMAIL_SENT_TO,''DATAFILEPATH'',null as DATAFORM, '+
                     'null as TEMPLATELINEID,''FROMDOC'' as source, auth2, display_path, URL, '+
                     'tablevalue(''preccategory'',''npreccategory'',nvl(npreccategory,0),''descr'') as npreccategory , '+
                     'tablevalue(''precclassification'',''nprecclassification'',nvl(nprecclassification,0),''descr'') as nprecclassification, '+
                     'external_access, email_from '+
                     'FROM DOC '+
                     'where ';
//                     'nmatter = :nmatter  and parentdocid is null';
         if (edtMatter.Text <> '') then
            SQL.Text := Sql.Text + ' CONTAINS(dummy1,'+ QuotedStr('%'+ edtMatter.Text + '%') + ', 1) > 0 ';
         Sql.Text := Sql.Text + ' order by 4 desc, 5 desc ';
//         ParamByName('NMATTER').AsString := qryMatter.FieldByName('NMATTER').AsString;
         Open;
      end;
   end;
end;

procedure TfrmDocList.FormCreate(Sender: TObject);
begin
//   if not assigned(dmSaveDoc) then
//      dmSaveDoc := TdmSaveDoc.Create(Application);
//   if dmSaveDoc.orsInsight.Connected = False then dmSaveDoc.GetUserID();
end;

procedure TfrmDocList.FormShow(Sender: TObject);
begin
   with dmConnection.qryDocs do
      begin
         Close;
         Sql.Clear;
         Sql.Text := 'SELECT DOCID, NMATTER,DOC_NAME, D_CREATE, AUTH1, D_MODIF, PATH,DESCR, FILEID, DOC_CODE, '+
                     'IMAGEINDEX, FILE_EXTENSION, EMAIL_SENT_TO,''DATAFILEPATH'',null as DATAFORM, '+
                     'null as TEMPLATELINEID,''FROMDOC'' as source, auth2, display_path, URL, '+
                     'tablevalue(''preccategory'',''npreccategory'',nvl(npreccategory,0),''descr'') as npreccategory , '+
                     'tablevalue(''precclassification'',''nprecclassification'',nvl(nprecclassification,0),''descr'') as nprecclassification, '+
                     'external_access, email_from '+
                     'FROM DOC ';
         Sql.Text := Sql.Text + ' order by 4 desc, 5 desc ';
         Open;
      end;
end;

end.

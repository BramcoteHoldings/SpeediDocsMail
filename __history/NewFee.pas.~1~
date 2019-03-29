unit NewFee;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, DB, DBAccess,  MemDS, ComCtrls,
  OraSmart, Ora, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, JvBaseEdits, JvExMask, JvToolEdit, JvDBLookup,
  SaveDoc, cxMemo, cxButtonEdit;

type
  TfrmNewFee = class(TForm)
    lblMatterDesc: TLabel;
    lblClient: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cmbTemplate: TJvDBLookupEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblUnits: TLabel;
    dfItems: TEdit;
    neUnits: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    cbTaxType: TJvDBLookupEdit;
    cbDept: TJvDBLookupEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    dtpCreated: TDateTimePicker;
    neRate: TJvCalcEdit;
    neAmount: TJvCalcEdit;
    neMinutes: TJvCalcEdit;
    neTax: TJvCalcEdit;
    cbFeeBasis: TJvDBLookupEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    qryMRUList: TOraQuery;
    dsMRUList: TOraDataSource;
    dsFeeEarners: TOraDataSource;
    dsFee: TOraDataSource;
    dsEmpDept: TOraDataSource;
    dsFeeBasisList: TOraDataSource;
    dsTaxType: TOraDataSource;
    qFeeEarners: TOraQuery;
    qryScaleCost: TOraQuery;
    qryFee: TSmartQuery;
    qryEmpDept: TOraQuery;
    qryFeeBasisList: TOraQuery;
    qryTaxType: TOraQuery;
    qryBillType: TOraQuery;
    qFeeEarnersCODE: TStringField;
    qFeeEarnersNAME: TStringField;
    qFeeEarnersDEPT: TStringField;
    cbAuthor: TcxLookupComboBox;
    mmoDesc: TcxMemo;
    StatusBar: TStatusBar;
    btnEditMatter: TcxButtonEdit;
    procedure FormShow(Sender: TObject);
    procedure cbAuthorChange(Sender: TObject);
    procedure TemplateChange(Sender: TObject);
    procedure AuthorChange(Sender: TObject);
    procedure cbTaxTypeChange(Sender: TObject);
    procedure cmbMatterFindCloseUp(Sender: TObject);
    procedure neUnitsChange(Sender: TObject);
    procedure btnEditMatterExit(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnEditMatterPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
    DefaultTax : String;
    ScaleCode: string;
    bError: boolean;
    ScaleAmount: currency;
    FFileID: string;
    nmatter: integer;
    FOldAmount, FOldAmountTax, FEnterAmount: currency;
//    dmSaveDoc: TdmSaveDoc;
    FSubject: string;
    FUnits: string;
    procedure DisplayMatter(sMatter: string; AIsEditing: Boolean = False);
    procedure UpdateAmount;
    procedure CalcTax;
    procedure CalcRate;
  public
    { Public declarations }
    property sSubject: string read FSubject write FSubject;
    property nUnits: string read FUnits write FUnits;
    procedure CreateScale(AsMatter: String; ANMatter: Integer; AScaleCode: String; bNewFee: Boolean = True);
  end;

var
  frmNewFee: TfrmNewFee;

implementation

{$R *.dfm}

uses MatterSearch, SaveDocFunc, SpeediDocs_IMPL;

procedure TfrmNewFee.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree;
end;

procedure TfrmNewFee.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   qFeeEarners.Close;
   qryMRUList.Close;
   qryEmpDept.Close;
   qryFeeBasisList.Close;
   qryTaxType.Close;
   qryBillType.Close;
   qryScaleCost.Close;
//   dmSaveDoc.orsInsight.Disconnect;
// dmSaveDoc.Free;
end;

procedure TfrmNewFee.FormShow(Sender: TObject);
begin
   try
      StatusBar.Panels[0].Text := 'Ver: '+ ReportVersion(SysUtils.GetModuleName(HInstance)) + ' (' +DateTimeToStr(FileDateToDateTime(FileAge(SysUtils.GetModuleName(HInstance))))+')';

      if (not Assigned(dmConnection)) then
         dmConnection := TdmSaveDoc.Create(nil);
      if dmConnection.orsInsight.Connected = False then dmConnection.GetUserID();
      FOldAmount := 0.0;
      FOldAmountTax := 0.0;
      ScaleCode := '';
      qryMRUList.Close();
      qryMRUList.ParamByName('P_TYPE').AsString := 'MATTER';
      qryMRUList.ParamByName('P_Author').AsString := dmConnection.UserCode;
      qryMRUList.Open();

      qFeeEarners.Open;

      qryEmpDept.Open;
      qryFeeBasisList.Open;
      qryTaxType.Open;
      DefaultTax := get_default_gst('Fee');
      if DefaultTax = '' then
         DefaultTax := dmConnection.DefaultTax;

      qryBillType.Open;
      qryScaleCost.Open;
      cbTaxType.LookupValue := DefaultTax;
      dtpCreated.MaxDate := Date + 185;
      bError := false;
      cbFeeBasis.LookupValue := '0';

      if TableString('EMPLOYEE', 'CODE', dmConnection.UserCode, 'ISFEEEARNER') = 'Y' then
         cbAuthor.EditValue := dmConnection.UserCode
      else
         cbAuthor.EditValue := qFeeEarnersCODE.AsString;

      if(VarIsNull(cbAuthor.EditValue)) then
         cbDept.Clear
      else
         cbDept.LookupValue := dmConnection.UserDept;
      lblUnits.Caption := 'Units';
      with qryFee do
      begin
         ParamByName('P_Nfee').AsInteger := -1;
         Open;
      end;
 //     cbPrint.Checked := SettingLoadBoolean('FEECREATE', 'AUTOPRINTNOTE');

      cmbTemplate.OnChange := TemplateChange;
      cbAuthor.Properties.OnChange := AuthorChange;

      cbAuthorChange(Self);
      cbTaxTypeChange(Self);
      mmoDesc.Text := sSubject;
      neUnits.Text := nUnits;
   except
//      Application.MessageBox('Could not connect to Insight database6','Insight');
//      ModalResult := mrCancel;
   end;
end;

procedure TfrmNewFee.neUnitsChange(Sender: TObject);
begin
   UpdateAmount;
end;

procedure TfrmNewFee.cbAuthorChange(Sender: TObject);
begin
//
end;

procedure TfrmNewFee.cmbMatterFindCloseUp(Sender: TObject);
begin
{   if (cmbMatterFind.Text <> '') then
   begin
      if cmbMatterFind.Text = 'SEARCH...' then
      begin
         if not FormExists(frmMtrSearch) then
            Application.CreateForm(TfrmMtrSearch, frmMtrSearch);
         if frmMtrSearch.ShowModal = mrOK then
         begin
            if (IsMatterArchived(dmSaveDoc.qryMatters.FieldByName('FILEID').AsString)) then
            begin
               MessageDlg('You may not post Fees to a matter that is archived.', mtError, [mbOK], 0);
               cmbMatterFind.Text := '';
            end
            else if MatterIsCurrent(dmSaveDoc.qryMatters.FieldByName('FILEID').AsString) then
            begin
               DisplayMatter(dmSaveDoc.qryMatters.FieldByName('FILEID').AsString);
//               DoBillType(cmbMatterFind.Text);
            end
            else
               MessageDlg('Matter ' + dmSaveDoc.qryMatters.FieldByName('FILEID').AsString + ' has been closed', mtError, [mbOK], 0);
         end;
      end
      else
      begin
         if MatterExists(cmbMatterFind.Text) then
         begin
            if (IsMatterArchived(cmbMatterFind.Text)) then
            begin
               MessageDlg('You may not post Fees to a matter that is archived.', mtError, [mbOK], 0);
               cmbMatterFind.Text := '';
            end
            else
            begin
               DisplayMatter(cmbMatterFind.Text);
//               DoBillType(cmbMatterFind.Text);
            end;
         end
         else
         begin

            MessageDlg('The selected Matter is not valid.  Please check and re-try.', mtError, [mbOK], 0);
            cmbMatterFind.Text := '';
         end;
      end;
   end; }
end;

procedure TfrmNewFee.DisplayMatter(sMatter: string; AIsEditing: Boolean);
var
   lsAuthor : String;
begin
   btnEditMatter.Text := sMatter;
   lblClient.Caption := MatterString(btnEditMatter.Text, 'TITLE');
   lblMatterDesc.Caption := MatterString(btnEditMatter.Text, 'SHORTDESCR');

//   PopulateMatterOnly;

//   icmbType.EditValue := 'M';

   if(not AIsEditing) then
   begin
     if not (TableString('EMPLOYEE', 'CODE', dmConnection.UserCode, 'ISFEEEARNER') = 'Y') then
     begin
       lsAuthor := MatterString(btnEditMatter.Text, 'AUTHOR');

       if (lsAuthor <> '') then
       begin
           qFeeEarners.Close;
//           qFeeEarners.SQL.Clear;
//           qFeeEarners.SQL.Text := strFeeEarners.Strings.Text;
           qFeeEarners.ParamByName('Code').AsString := lsAuthor;
           qFeeEarners.Open;
       end;    //  end if

       cbAuthor.EditValue := lsAuthor;

       cbAuthor.EditValue := lsAuthor;
       cbAuthorChange(Self);

       if (cmbTemplate.Text = '') or (TableCurrency('SCALECOST','CODE',string(cmbTemplate.LookupValue),'AMOUNT') = 0) then
          neRate.Value := FeeRate('N', btnEditMatter.Text, String(cbAuthor.EditValue), dtpCreated.Date);


       cbDept.LookupValue := TableString('EMPLOYEE', 'CODE', String(cbAuthor.EditValue), 'DEPT');
       cbFeeBasis.LookupValue := MatterString(btnEditMatter.Text, 'FEEBASIS');
       cbTaxType.LookupValue := MatterString(btnEditMatter.Text, 'FEE_TAX_BASIS');
       UpdateAmount;
       CalcRate;
     end
     else
     begin

       cbFeeBasis.LookupValue := MatterString(btnEditMatter.Text, 'FEEBASIS');
       cbTaxType.LookupValue := MatterString(btnEditMatter.Text, 'FEE_TAX_BASIS');
       //added by AES 08/10/2008
       cbAuthorChange(Self);
     end;
     if Self.Visible then
        cmbTemplate.SetFocus;
   end;
end;

procedure TfrmNewFee.UpdateAmount;
var
   bError:  boolean;
begin
   if (SystemInteger('TIME_UNITS') > 0) then
   begin
      if ((lblUnits.Caption = 'Units') or (cmbTemplate.Text = '') or
         (TableCurrency('SCALECOST','CODE',string(cmbTemplate.LookupValue), 'RATE') = 0)) then
      begin
         try
            neAmount.Value := StrToInt(neUnits.Text) * neRate.Value / (60 / SystemInteger('TIME_UNITS'));
         except
            neAmount.Value := 0.00;
         end;
         try
            neMinutes.Text := IntToStr(StrToInt(neUnits.Text) * SystemInteger('TIME_UNITS'));
         except
            neMinutes.Text := '0';
         end;
      end
      else if (lblUnits.Caption = 'Mins') or (cmbTemplate.Text = '') or
              (TableCurrency('SCALECOST','CODE',string(cmbTemplate.LookupValue), 'RATE') = 0) then
      begin
         try
            neAmount.Value := StrToInt(neUnits.Text) * neRate.Value / 60;
         except
            neAmount.Value := 0.00;
         end;
         try
            neMinutes.Text := neUnits.Text;
         except
            neMinutes.Text := '0';
         end;
      end
      else if (lblUnits.Caption = 'Item') and (string(cmbTemplate.LookupValue) <> '') then
      begin
         try
            neAmount.Value := StrToInt(dfItems.Text) * neRate.Value;
         except
            neAmount.Value := 0.00;
         end;
         try
            neMinutes.Text := IntToStr(StrToInt(neUnits.Text) * SystemInteger('TIME_UNITS'));
         except
            neMinutes.Text := '0';
         end;
      end
      else
      begin
         try
            neAmount.Value := StrToInt(neUnits.Text) * neRate.Value;
         except
            neAmount.Value := 0.00;
         end;
      end;
      CalcTax;
   end
   else
   begin
      if bError = false then
      begin
         bError := true;
         MessageDlg('System Time Units not set in Systemfile', mtError, [mbOK], 0);
      end;
   end;
end;

procedure TfrmNewFee.CalcTax;
var
  dAmount : Currency;
begin
   dAmount := neAmount.Value;

   if (cbTaxType.LookupValue = 'GSTIN') then
   begin
      if (neAmount.Value = FOldAmount) then
      begin
         dAmount := neAmount.Value + neTax.Value;
      end;    //  end if
   end  //  end if
   else
   begin
      if FOldAmount <> 0 then
         neAmount.Value := FOldAmount;
   end;

  neTax.Value := TaxCalc(dAmount, '', cbTaxType.LookupValue, dtpCreated.Date);
  neAmount.Value := dAmount;
end;

procedure TfrmNewFee.BitBtn1Click(Sender: TObject);
begin
   FeeInsert(nmatter , cbAuthor.EditValue, mmoDesc.Text,
             neAmount.Value, cmbTemplate.LookupValue, StrToInt(neUnits.Text),
             neMinutes.Value, neRate.Value, cbTaxType.LookupValue);
end;

procedure TfrmNewFee.btnEditMatterExit(Sender: TObject);
begin
   if string(btnEditMatter.Text) <> '' then
   begin
      dmConnection.qryGetMatter.Close;
      dmConnection.qryGetMatter.ParamByName('FILEID').AsString := string(btnEditMatter.Text);
      dmConnection.qryGetMatter.Open;
      if dmConnection.qryGetMatter.Eof then
         MessageDlg('Invalid Matter Number', mtWarning, [mbOk], 0)
      else
      begin
         nMatter := dmConnection.qryGetMatter.FieldByName('NMATTER').AsInteger;
         FFileID := string(btnEditMatter.Text);
         lblClient.Caption := MatterString(btnEditMatter.Text, 'TITLE');
         lblMatterDesc.Caption := MatterString(btnEditMatter.Text, 'SHORTDESCR');
         cbDept.LookupValue := MatterString(btnEditMatter.Text, 'DEPT');
     end;
   end;
end;

procedure TfrmNewFee.btnEditMatterPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
   frmMtrSearch :=TfrmMtrSearch.Create(nil);
   try
      frmMtrSearch.MakeSql;
      if (frmMtrSearch.ShowModal = mrOK) then
      begin
         btnEditMatter.Text := dmConnection.qryMatters.FieldByName('fileid').AsString;   //  dmSaveDoc.qryMatters.FieldByName('fileid').AsString;
         nMatter := dmConnection.qryMatters.FieldByName('nmatter').AsInteger;
//         cmbAuthor.EditValue := TableString('MATTER','NMATTER',nMatter,'AUTHOR');
         FFileID := btnEditMatter.Text;
         lblClient.Caption := MatterString(btnEditMatter.Text, 'TITLE');
         lblMatterDesc.Caption := MatterString(btnEditMatter.Text, 'SHORTDESCR');
         cbDept.LookupValue := MatterString(btnEditMatter.Text, 'DEPT');
      end;
   finally
      frmMtrSearch.Free;
   end;
end;

procedure TfrmNewFee.CalcRate;
begin
   if (cmbTemplate.Text = '') or
      ((TableCurrency('SCALECOST','CODE',string(cmbTemplate.LookupValue),'AMOUNT') <> 0) and
      (TableString('SCALECOST','CODE',string(cmbTemplate.LookupValue),'ZERO_FEE') = 'N')) then

      neRate.Value := FeeRate(cbFeeBasis.LookupValue, FFileID, cbAuthor.EditValue, dtpCreated.Date);
   UpdateAmount;
end;

procedure TfrmNewFee.TemplateChange(Sender: TObject);
begin
   if (cmbTemplate.Text <> '') and (not VarIsNull(cmbTemplate.LookupValue)) then
   begin
      if trim(mmoDesc.Text) = '' then
         mmoDesc.Text := TableString('SCALECOST','CODE',string(cmbTemplate.LookupValue) ,'DESCR');

      if ((TableCurrency('SCALECOST','CODE',string(cmbTemplate.LookupValue),'nvl(RATE,0) as RATE') <> 0) or
         (TableCurrency('SCALECOST','CODE',string(cmbTemplate.LookupValue),'nvl(AMOUNT,0) as RATE') <> 0) and
         (TableString('SCALECOST','CODE',string(cmbTemplate.LookupValue),'ZERO_FEE') = 'N')) then
      begin
         CreateScale(FFileID,0,cmbTemplate.LookupValue, False);
         CalcRate;
      end;
   end
   else
   begin
      if cmbTemplate.Text = '' then
      begin
         dfItems.Visible := False;
         cmbTemplate.LookupValue := '';
         CalcRate;
      end;
   end;
end;

procedure TfrmNewFee.AuthorChange(Sender: TObject);
begin
   if(VarIsNull(cbAuthor.EditValue)) then
      cbDept.Clear
   else
   begin
      cbDept.LookupValue := TableString('EMPLOYEE', 'CODE', String(cbAuthor.EditValue), 'DEPT'); //qFeeEarners.FieldValues['DEPT'];
   end;
//   if (cmbTemplate.Text = '') then
      CalcRate;
end;

procedure TfrmNewFee.cbTaxTypeChange(Sender: TObject);
begin
   CalcTax;
end;

procedure TfrmNewFee.CreateScale(AsMatter: String; ANMatter: Integer; AScaleCode: String; bNewFee: Boolean);
var
   LabelDesc: string;
begin
   if bNewFee then DisplayMatter(AsMatter);
   qryScaleCost.close;
   qryScaleCost.ParambyName('p_code').AsString := AScaleCode;
   qryScaleCost.Open();
   try
      LabelDesc := trim(qryScaleCost.FieldByName('UNIT').AsString);
      cmbTemplate.LookupValue := AScaleCode;
      ScaleCode := AScaleCode;
      if trim(mmoDesc.Text) = '' then
         mmoDesc.Text := qryScaleCost.FieldByName('DESCR').AsString;
      if LabelDesc <> '' then
         lblUnits.Caption := LabelDesc;
      if qryScaleCost.FieldByName('AMOUNT').AsCurrency > 0 then
      begin
         neAmount.Value := qryScaleCost.FieldByName('AMOUNT').AsCurrency;
         dfItems.Visible := False;
      end
      else
      begin
         if qryScaleCost.FieldByName('RATE').AsCurrency > 0 then
         begin
            neRate.Value := qryScaleCost.FieldByName('RATE').AsCurrency;
//            dfItems.Visible := (LabelDesc <> '');
            if cmbTemplate.Text <> '' then
            begin
               if dfItems.Visible then
                  dfItems.Text := '1'
               else
                  dfItems.Text := '0';
            end;
//            UpdateAmount;
         end;
      end;
      if qryScaleCost.FieldByName('ZERO_FEE').AsString = 'N' then
      begin
         UpdateAmount;
         ScaleAmount := neAmount.Value;
         CalcTax;
      end
      else
      begin
         neAmount.Value := 0;
         neRate.Value := 0;
         neTax.Value := 0;
      end;
   finally
//      qryScaleCost.Close();
   end;
end;


end.

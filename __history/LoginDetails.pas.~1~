unit LoginDetails;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Registry, SaveDoc, SpeediDocs_IMPL, Vcl.ComCtrls, SaveDocFunc,
  Vcl.Buttons, AdditionalInfo, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxCheckBox;

type
  TfrmLoginSetup = class(TForm)
    GroupBox1: TGroupBox;
    edUserName: TEdit;
    edPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Database: TGroupBox;
    Label3: TLabel;
    edServerName: TEdit;
    edDatabase: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edPort: TEdit;
    GroupBox2: TGroupBox;
    chkShowMatterList: TCheckBox;
    chkSaveIncoming: TCheckBox;
    chkSaveOutgoing: TCheckBox;
    chkSaveSentEmail: TCheckBox;
    btnCancel: TButton;
    chkRemoveEmail: TCheckBox;
    GroupBox3: TGroupBox;
    chkLogEvents: TCheckBox;
    edLogPath: TEdit;
    StatusBar: TStatusBar;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    OpenDialog: TOpenDialog;
    chkUseDirectConn: TcxCheckBox;
    chkSaveIncomingAlways: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure chkShowMatterListClick(Sender: TObject);
    procedure chkSaveIncomingClick(Sender: TObject);
    procedure chkSaveOutgoingClick(Sender: TObject);
    procedure chkSaveSentEmailClick(Sender: TObject);
    procedure chkSaveIncomingAlwaysClick(Sender: TObject);
    procedure chkRemoveEmailClick(Sender: TObject);
    procedure chkLogEventsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edLogPathExit(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure chkUseDirectConnClick(Sender: TObject);
  private
    { Private declarations }
     LRegAxiom: TRegistry;
//     sRegistryRoot: string;
      FisOutlook: boolean;
  public
    { Public declarations }
    property isOutlook: boolean read FisOutlook write FisOutlook;
  end;

var
  frmLoginSetup: TfrmLoginSetup;

implementation


{$R *.dfm}

procedure TfrmLoginSetup.BitBtn1Click(Sender: TObject);
var
   frmAdditionalInfo : TfrmAdditionalInfo;
begin
   try
      frmAdditionalInfo := TfrmAdditionalInfo.Create(nil);
      frmAdditionalInfo.IsOutlook := Self.IsOutlook;
      frmAdditionalInfo.ShowModal;
   finally
      frmAdditionalInfo.Free;
      frmAdditionalInfo := nil;
   end;

end;

procedure TfrmLoginSetup.BitBtn2Click(Sender: TObject);
begin
   if edLogPath.Text <> '' then
      OpenDialog.InitialDir := ExtractFileDir(edLogPath.Text);
   if OpenDialog.Execute then
   begin
      edLogPath.Text := OpenDialog.FileName;
      chkLogEvents.Enabled := True;
      AddInModule.LogFile := OpenDialog.FileName;
      LregAxiom := TRegistry.Create;
      try
         LregAxiom.RootKey := HKEY_CURRENT_USER;
         LregAxiom.OpenKey(csRegistryRoot, True);
         LregAxiom.WriteString('LogFilePath',edLogPath.Text);
         chkLogEvents.Enabled := (edLogPath.Text <> '');
         if (edLogPath.Text = '') then
         begin
            AddInModule.bLogFile := False;
            chkLogEvents.Checked := False;
         end;
      finally
         LregAxiom.Free;
      end;
   end;
end;

procedure TfrmLoginSetup.Button1Click(Sender: TObject);
var
  regAxiom: TRegistry;
begin
   regAxiom := TRegistry.Create;
   try
      regAxiom.RootKey := HKEY_CURRENT_USER;
      if regAxiom.OpenKey(csRegistryRoot, True) then
      begin
         if chkUseDirectConn.Checked = True then
         begin
            regAxiom.WriteString('Net','Y');
            regAxiom.WriteString('Server Name',edServerName.Text+':'+edPort.Text+':'+edDatabase.Text);
            regAxiom.WriteString('User Name',edUserName.Text);
            regAxiom.WriteString('Password',edPassword.Text);
         end
         else
         begin
            regAxiom.WriteString('Net','N');
            regAxiom.WriteString('Server Name',edDatabase.Text);
            regAxiom.WriteString('User Name',edUserName.Text);
            regAxiom.WriteString('Password',edPassword.Text);
         end;
         regAxiom.CloseKey;
      end;

      if chkUseDirectConn.Checked = True then
      begin
         dmConnection.orsInsight.Options.Direct := True;
         dmConnection.orsInsight.Server := edServerName.Text+':'+edPort.Text+':'+edDatabase.Text;
      end
      else
      begin
         dmConnection.orsInsight.Options.Direct := False;
         dmConnection.orsInsight.Server := edDatabase.Text;
      end;

   finally
      regAxiom.Free;
   end;
   Close;
end;

procedure TfrmLoginSetup.chkLogEventsClick(Sender: TObject);
begin
   LregAxiom := TRegistry.Create;
   try
      LregAxiom.RootKey := HKEY_CURRENT_USER;
      LregAxiom.OpenKey(csRegistryRoot, True);
      if (chkLogEvents.Checked = True) then
      begin
         LregAxiom.WriteString('EventLog','Y');
         AddInModule.bLogFile := True;
      end
      else
      begin
         LregAxiom.WriteString('EventLog','N');
         AddInModule.bLogFile := False;
      end;
   finally
      LregAxiom.Free;
   end;
end;

procedure TfrmLoginSetup.chkRemoveEmailClick(Sender: TObject);
begin
   LregAxiom := TRegistry.Create;
   try
      LregAxiom.RootKey := HKEY_CURRENT_USER;
      LregAxiom.OpenKey(csRegistryRoot, True);
      if (chkRemoveEmail.Checked = True) then
      begin
         LregAxiom.WriteString('RemoveSavedEmails','Y');
      end
      else
      begin
         LregAxiom.WriteString('RemoveSavedEmails','N');
      end;
   finally
      LregAxiom.Free;
   end;
end;

procedure TfrmLoginSetup.chkSaveIncomingClick(Sender: TObject);
begin
   LregAxiom := TRegistry.Create;
   try
      LregAxiom.RootKey := HKEY_CURRENT_USER;
      LregAxiom.OpenKey(csRegistryRoot, True);
      if (chkSaveIncoming.Checked = True) then
      begin
         LregAxiom.WriteString('SaveIncomingEmails','Y');
      end
      else
      begin
         LregAxiom.WriteString('SaveIncomingEmails','N');
      end;
   finally
      LregAxiom.Free;
   end;
end;

procedure TfrmLoginSetup.chkSaveOutgoingClick(Sender: TObject);
begin
   LregAxiom := TRegistry.Create;
   try
      LregAxiom.RootKey := HKEY_CURRENT_USER;
      LregAxiom.OpenKey(csRegistryRoot, True);
      if (chkSaveOutgoing.Checked = True) then
      begin
         LregAxiom.WriteString('SaveOutgoingEmails','Y');
      end
      else
      begin
         LregAxiom.WriteString('SaveOutgoingEmails','N');
      end;
   finally
      LregAxiom.Free;
   end;
end;

procedure TfrmLoginSetup.chkSaveSentEmailClick(Sender: TObject);
begin
   LregAxiom := TRegistry.Create;
   try
      LregAxiom.RootKey := HKEY_CURRENT_USER;
      LregAxiom.OpenKey(csRegistryRoot, True);
      if (chkSaveSentEmail.Checked = True) then
      begin
         LregAxiom.WriteString('SaveSentEmail','Y');
         bSaveSentEmail := True;
      end
      else
      begin
         LregAxiom.WriteString('SaveSentEmail','N');
         bSaveSentEmail := False;
      end;
   finally
      LregAxiom.Free;
   end;
end;

procedure TfrmLoginSetup.chkSaveIncomingAlwaysClick(Sender: TObject);
begin
   LregAxiom := TRegistry.Create;
   try
      LregAxiom.RootKey := HKEY_CURRENT_USER;
      LregAxiom.OpenKey(csRegistryRoot, True);
      if (chkSaveIncomingAlways.Checked = True) then
      begin
         LregAxiom.WriteString('SaveIncomingAlways','Y');
         bSaveIncomingAlways := True;
      end
      else
      begin
         LregAxiom.WriteString('SaveIncomingAlways','N');
         bSaveIncomingAlways := False;
      end;
   finally
      LregAxiom.Free;
   end;
end;

procedure TfrmLoginSetup.chkShowMatterListClick(Sender: TObject);
begin
   LregAxiom := TRegistry.Create;
   try
      LregAxiom.RootKey := HKEY_CURRENT_USER;
      LregAxiom.OpenKey(csRegistryRoot, True);
      if (chkShowMatterList.Checked = True) then
      begin
         LregAxiom.WriteString('ShowMatterList','Y');
      end
      else
      begin
         LregAxiom.WriteString('ShowMatterList','N');
      end;
   finally
      LregAxiom.Free;
   end;
end;

procedure TfrmLoginSetup.chkUseDirectConnClick(Sender: TObject);
begin
   edServerName.Enabled := chkUseDirectConn.Checked;
   edPort.Enabled := chkUseDirectConn.Checked;
end;

procedure TfrmLoginSetup.edLogPathExit(Sender: TObject);
begin
   LregAxiom := TRegistry.Create;
   try
      LregAxiom.RootKey := HKEY_CURRENT_USER;
      LregAxiom.OpenKey(csRegistryRoot, True);
      LregAxiom.WriteString('LogFilePath',edLogPath.Text);
      chkLogEvents.Enabled := (edLogPath.Text <> '');
      if (edLogPath.Text = '') then
      begin
         AddInModule.bLogFile := False;
         chkLogEvents.Checked := False;
      end;
   finally
      LregAxiom.Free;
   end;
end;

procedure TfrmLoginSetup.FormShow(Sender: TObject);
var
   LoginStr, s: string;
begin
   StatusBar.Panels[0].Text := 'Ver: '+ ReportVersion(SysUtils.GetModuleName(HInstance)) + ' (' +DateTimeToStr(FileDateToDateTime(FileAge(SysUtils.GetModuleName(HInstance))))+')';

   chkShowMatterList.OnClick       := nil;
   chkSaveIncoming.OnClick         := nil;
   chkSaveOutgoing.OnClick         := nil;
   chkSaveSentEmail.OnClick        := nil;
   chkLogEvents.OnClick            := nil;
   chkSaveIncomingAlways.OnClick   := nil;

   LregAxiom := TRegistry.Create;
   try
      LregAxiom.RootKey := HKEY_CURRENT_USER;
      LregAxiom.OpenKey(csRegistryRoot, False);

      s := Copy(LregAxiom.ReadString('Server Name'),1,Pos(':',LregAxiom.ReadString('Server Name'))-1);
      LoginStr := Copy(LregAxiom.ReadString('Server Name'),Pos(':',LregAxiom.ReadString('Server Name'))+1, Length(LregAxiom.ReadString('Server Name')) - Pos(':',LregAxiom.ReadString('Server Name')) );
      if (LregAxiom.ReadString('Net') = 'Y') then
      begin
         if s <> '' then
            edServerName.Text := s;

         s := Copy(LoginStr,1,Pos(':',LoginStr)-1);
         LoginStr := Copy(LoginStr,Pos(':',LoginStr)+1, Length(LoginStr));
         if s <> '' then
            edPort.Text := s;

         s := LoginStr;
         if s <> '' then
            edDatabase.Text := s;
      end
      else
      begin
         edDatabase.Text := LoginStr;
         edServerName.Enabled := False;
         edPort.Enabled := False;
      end;

      edUserName.Text := LregAxiom.ReadString('User Name');
      edPassword.Text := LregAxiom.ReadString('Password');
      chkUseDirectConn.Checked := (LregAxiom.ReadString('Net') = 'Y');
      chkShowMatterList.Checked  := (LregAxiom.ReadString('ShowMatterList') = 'Y');
      chkSaveIncoming.Checked    := (LregAxiom.ReadString('SaveIncomingEmails') = 'Y');
      chkSaveOutgoing.Checked    := (LregAxiom.ReadString('SaveOutgoingEmails') = 'Y');
      chkSaveSentEmail.Checked   := (LregAxiom.ReadString('SaveSentEmail') = 'Y');
      chkSaveIncomingAlways.Checked   := (LregAxiom.ReadString('SaveIncomingAlways') = 'Y');
      chkLogEvents.checked       := (LregAxiom.ReadString('EventLog') = 'Y');
      edLogPath.Text             :=  LregAxiom.ReadString('LogFilePath');
   finally
     chkShowMatterList.OnClick   := chkShowMatterListClick;
     chkSaveIncoming.OnClick     := chkSaveIncomingClick;
     chkSaveOutgoing.OnClick     := chkSaveOutgoingClick;
     chkSaveSentEmail.OnClick    := chkSaveSentEmailClick;
     chkSaveIncomingAlways.OnClick    := chkSaveIncomingAlwaysClick;
     chkLogEvents.OnClick        := chkLogEventsClick;
     chkLogEvents.Enabled := (edLogPath.Text <> '');
     LregAxiom.Free;
   end;
end;

end.

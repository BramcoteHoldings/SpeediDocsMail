library SpeediDocsMail;

uses
  ComServ,
  SpeediDocsMail_TLB in 'SpeediDocsMail_TLB.pas',
  SpeediDocsMail_IMPL in 'SpeediDocsMail_IMPL.pas' {AddInModule: TAddInModule} {Insight_Addin_for_Outlook: CoClass},
  OutlookUnit in 'OutlookUnit.pas',
  SaveDocFunc in 'SaveDocFunc.pas',
  SaveDoc in 'SaveDoc.pas' {dmSaveDoc: TDataModule},
  SavedocDetails in 'SavedocDetails.pas' {frmSaveDocDetails};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.

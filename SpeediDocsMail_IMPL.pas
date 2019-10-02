unit SpeediDocsMail_IMPL;

interface

uses
  SysUtils, ComObj, adxAddIn, SpeediDocsMail_TLB, ComServ, ActiveX,
  Variants, Outlook2000, Outlook2010, System.Classes, StdVcl,
  Registry, Windows, SaveDoc, adxHostAppEvents, Outlook_Tlb;

  const
   csRegistryRoot = 'Software\Colateral\Axiom\SpeediDocs';

   olPosition = 1;

type
  TInsight_Addin_for_Outlook = class(TadxAddin, IInsight_Addin_for_Outlook)
  end;

  TAddInModule = class(TadxCOMAddInModule)
    adxRibbonTab1: TadxRibbonTab;
    adxOutlookAppEvents1: TadxOutlookAppEvents;
    adxRibbonContextMenu1: TadxRibbonContextMenu;
    procedure adxCOMAddInModuleAddInInitialize(Sender: TObject);
    procedure adxCOMAddInModuleAddInStartupComplete(Sender: TObject);
    procedure adxCOMAddInModuleAddInBeginShutdown(Sender: TObject);
    procedure adxRibbonTab1Controls1Controls0Click(Sender: TObject;
      const RibbonControl: IRibbonControl);
    procedure adxRibbonContextMenu1Controls1Click(Sender: TObject;
      const RibbonControl: IRibbonControl);
    procedure adxRibbonTab1Controls0Controls0Click(Sender: TObject;
      const RibbonControl: IRibbonControl);
    procedure adxOutlookAppEvents1NewMailEx(ASender: TObject;
      const EntryIDCollection: WideString);
    procedure adxRibbonContextMenu1Controls2Click(Sender: TObject;
      const RibbonControl: IRibbonControl);
    procedure adxRibbonContextMenu1Controls2PropertyChanging(Sender: TObject;
      PropertyType: TadxRibbonControlPropertyType; var Value: OleVariant;
      const Context: IDispatch);
    procedure adxRibbonContextMenu1Controls1PropertyChanging(Sender: TObject;
      PropertyType: TadxRibbonControlPropertyType; var Value: OleVariant;
      const Context: IDispatch);
    procedure adxRibbonTab1Controls2Controls0Click(Sender: TObject;
      const RibbonControl: IRibbonControl);
    procedure adxRibbonTab1Controls2Controls1Click(Sender: TObject;
      const RibbonControl: IRibbonControl);
    procedure adxCOMAddInModuleError(const E: Exception; var Handled: Boolean);
    procedure adxCOMAddInModuleAddInFinalize(Sender: TObject);
    procedure adxOutlookAppEvents1ItemSend(ASender: TObject;
      const Item: IDispatch; var Cancel: WordBool);
  private
      FItems,
      FItemsSent: TItems;
      LRegAxiom: TRegistry;
      sRegistryRoot: string;
      LDocList: Array of MailItem;

      procedure DoItemAdd(ASender: TObject; const Item: IDispatch);
      procedure DoSave;
      procedure ConvertApptToFee;
  protected
  public
   ol2010: Outlook2010._Application;
  end;

var
   AddInModule: TAddInModule;
   bSaveSentEmail: boolean;
   bSaveIncomingAlways: boolean;
   dmConnection: TdmSaveDoc;
   bPromptToSaveIncoming: boolean;



implementation

{$R *.dfm}

uses
   OutlookUnit, SaveDocDetails, dxCore, LoginDetails, SaveDocFunc,
   NewFee, vcl.controls, DocList;

procedure TAddInModule.adxCOMAddInModuleAddInBeginShutdown(Sender: TObject);
begin
   try
      if Assigned(dmConnection) then
      begin
         dmConnection.orsInsight.Disconnect;
         dmConnection.Free;
      end;
   except
//
   end;
end;

procedure TAddInModule.adxCOMAddInModuleAddInFinalize(Sender: TObject);
begin
   if Assigned(FItems) then
      FItems.Free;
end;

procedure TAddInModule.adxCOMAddInModuleAddInInitialize(Sender: TObject);
begin
   AddInModule := Self;
//   FDefItems := TItems.Create(nil);
//   FDefItems.ConnectTo(OutlookApp.GetNamespace('MAPI').GetDefaultFolder(olFolderSentMail).Items);
//   FDefItems.OnItemAdd := DoItemAdd;
end;

procedure TAddInModule.adxCOMAddInModuleAddInStartupComplete(Sender: TObject);
var
   IFolderInbox: Outlook2010.MAPIFolder;
   IFolderSent: Outlook2010.MAPIFolder;
   sKeyValue: string;
begin
   FItems := nil;
   FItemsSent := nil;
   dmConnection := nil;
   bSaveIncomingAlways := False;

   try
      dmConnection := TdmSaveDoc.Create(AddInModule);
      dmConnection.GetUserID;
   finally
      LregAxiom := TRegistry.Create;
      try
         LregAxiom.RootKey := HKEY_CURRENT_USER;
         LregAxiom.OpenKey(csRegistryRoot, False);
         bSaveSentEmail := (LregAxiom.ReadString('SaveSentEmail') = 'Y');
         sKeyValue := LregAxiom.ReadString('SaveIncomingAlways');
         if (sKeyValue = '') then
         begin
             LregAxiom.WriteString('SaveIncomingAlways','Y');
             bSaveIncomingAlways := true;
         end
         else
             bSaveIncomingAlways := (sKeyValue = 'Y');

         sKeyValue := LregAxiom.ReadString('PromptToSaveIncomingEmails');
         if (sKeyValue = '') then
         begin
             LregAxiom.WriteString('PromptToSaveIncomingEmails','Y');
             bPromptToSaveIncoming := true;
         end
         else
             bPromptToSaveIncoming := (sKeyValue = 'Y');

         if (LregAxiom.ReadString('ShowMatterList') = 'Y') then
         begin
//            adxOlFormsManager.Items[0].ExplorerLayout := elBottomNavigationPane;
         end
         else
//            adxOlFormsManager.Items[0].ExplorerLayout := elUnknown;
      finally
         LregAxiom.Free;
      end;

   end;
end;

procedure TAddInModule.adxCOMAddInModuleError(const E: Exception;
  var Handled: Boolean);
begin
   try
 //     WriteLog('Addin Exception: '  + E.Message);
      Handled := True;
   except
      // Ignore
   end;
end;

procedure TAddInModule.adxOutlookAppEvents1ItemSend(ASender: TObject;
  const Item: IDispatch; var Cancel: WordBool);
var
   ol2010: Outlook_Tlb._Application;
   i: integer;
   IMail: _MailItem;
   Inspector : outlook2000._Inspector;
   objFolder : Outlook_TLB.MAPIFolder;
   objStore : Outlook_TLB._store;
   StoreFolder : String;
begin
   if Assigned(FItems) then
   begin
      FItems.Free;
      FItems := nil;
   end;

   Inspector := OutlookApp.ActiveInspector;
   Inspector.CurrentItem.QueryInterface(IID__MailItem, IMail);
   ol2010:= self.OutlookApp.Application as Outlook_Tlb._Application;
   for i := 1 to ol2010.Session.Accounts.Count do
   begin
      if (IMail.SendUsingAccount <> nil) then
      begin
         if (IMail.SendUsingAccount.DisplayName = ol2010.Session.Accounts.Item(I).DisplayName) then
         begin
            StoreFolder := ol2010.Session.Accounts.Item(I).DisplayName;
            break;
         end;
      end;
   end;

   objstore := ol2010.Session.Stores.Item(ol2010.Session.Accounts.Item(I).DisplayName);
   objFolder := objstore.Session.GetDefaultFolder(olFolderSentMail);

   FItems := TItems.Create(nil);
   FItems.ConnectTo(outlook2000._Items(objFolder.Items));
//   FItems.OnItemAdd := nil;
   FItems.OnItemAdd := DoItemAdd;
end;

procedure TAddInModule.adxOutlookAppEvents1NewMailEx(ASender: TObject;
  const EntryIDCollection: WideString);
var
   Mail: Outlook2010.MailItem;
   ns : Outlook2000._NameSpace;
   item: IDispatch;
   i: integer;
   entryIds: TStringList;
   obj: olevariant;
   StoreId: olevariant;
   IFolderSent: Outlook2000.MAPIFolder;
begin
   try
      ns := nil;
      obj := null;
      try
         if (bSaveIncomingAlways) then
         begin
            ns := OutlookApp.GetNamespace('MAPI');
            entryIds := TstringList.Create;
            Split(EntryIDCollection, ',',entryIds);
            for i := 0 to entryIds.Count - 1 do
            begin
               try
                  if (VarIsNull(StoreId) = False) then
                  begin
                     try
                        item := ns.GetItemFromID(entryIds.Strings[i], StoreId);
                     finally
                        if Assigned(Item) then
                        begin
                           item.QueryInterface(IID__MailItem, Mail);
                           if (Assigned(Mail)) then
                           begin
                              IFolderSent := Mail.Parent as Outlook2000.MAPIFolder;
                              if (Assigned(Mail)) then
                              begin
                                 try
                                    SentMessage(Mail, True);
                                 finally
                                    Mail := nil;
                                 end;
                              end;
                           end;
                        end;
                     end;
                  end;
               finally
                  if Assigned(item) then
                     item := nil;
               end;
            end;
         end;
      finally
         if Assigned(IFolderSent) then
           IFolderSent := nil;
         ns := nil;
      end;
   except

   end;
end;

procedure TAddInModule.adxRibbonContextMenu1Controls1Click(Sender: TObject;
  const RibbonControl: IRibbonControl);
var
   Control: IRibbonControl;
   IWindow: IDispatch;
begin
   try
      IWindow := HostApp.ActiveWindow;
   except
   end;
   try
      if IWindow <> nil then
         DoSave;
   finally
      IWindow := nil;
   end;

end;

procedure TAddInModule.adxRibbonContextMenu1Controls1PropertyChanging(
  Sender: TObject; PropertyType: TadxRibbonControlPropertyType;
  var Value: OleVariant; const Context: IDispatch);
  var
   btn: OleVariant;
begin
   if Context<>nil then
   begin
      if (PropertyType = rcptvisible) then
      begin
         btn := OutlookApp.ActiveExplorer.CurrentFolder.Name;
         if ((pos('Calendar', btn) = 0 ) ) then
            Value := True
         else
            Value := False;
      end;
   end;

end;

procedure TAddInModule.adxRibbonContextMenu1Controls2Click(Sender: TObject;
  const RibbonControl: IRibbonControl);
begin
   ConvertApptToFee;
end;

procedure TAddInModule.adxRibbonContextMenu1Controls2PropertyChanging(
  Sender: TObject; PropertyType: TadxRibbonControlPropertyType;
  var Value: OleVariant; const Context: IDispatch);
var
   btn: OleVariant;
begin
   if Context<>nil then
   begin
      if (PropertyType = rcptvisible) then
      begin
         btn := OutlookApp.ActiveExplorer.CurrentFolder.Name;
         if (pos('Calendar', btn) > 0 ) then
            Value := True
         else
            Value := False;
      end;
   end;
end;

procedure TAddInModule.ConvertApptToFee;
var
   fmNewFee: TfrmNewFee;
   ns : Outlook2010.NameSpace;
   item: IDispatch;
   StoreId: OLEVariant;
   i: OLEVariant;
   sel: Outlook2000.selection;
   folder: Outlook2000.MAPIFolder;
   Appointment: Outlook2010.AppointmentItem;
   s: widestring;
begin
   try
      if Assigned(fmNewFee) then
      begin
         FreeAndNil(fmNewFee);
      end;

      try
         folder := OutlookApp.ActiveExplorer.CurrentFolder; //ol2010.GetNamespace('MAPI').GetDefaultFolder(olFolderCalendar);
         if true {folder = olFolderCalendar} then
         begin
            i := 1;
            sel := OutlookApp.ActiveExplorer.Selection;
            Appointment := Outlook2010.AppointmentItem(sel.Item(1));
            s := Appointment.Subject;

            if AnsiPos('Converted to Fee', Appointment.Subject) = 0 then
            begin
               fmNewFee := TfrmNewFee.Create(nil);
               fmNewFee.sSubject := Appointment.Subject;
               fmNewFee.nUnits := FloatToStrF((((Appointment.End_ - Appointment.Start)*24)*60) /60*10, ffNumber, 0,0 );
               fmNewFee.dtpCreated.Date := Appointment.Start;
               try
                  if fmNewFee.ShowModal = mrOk then
                  begin
                     Appointment.Subject := Appointment.Subject + ' - Converted to Fee';
                     Appointment.Save;
                  end;
               finally
                  fmNewFee.Free;
               end;
            end
            else
               MsgInfo('Appointment already converted to Fee');
         end;
      finally
         FreeAndNil(ns);
      end;
   except
//
   end;
end;

procedure TAddInModule.adxRibbonTab1Controls0Controls0Click(Sender: TObject;
  const RibbonControl: IRibbonControl);
var
   bLoginSetup: integer;
   frmLoginSetup: TfrmLoginSetup;
begin
   try
      try
         if Assigned(frmLoginSetup) then
            frmLoginSetup := nil;
         frmLoginSetup := TfrmLoginSetup.Create(nil);
         if HostType = ohaOutlook then
            frmLoginSetup.IsOutlook := True;
         bLoginSetup := frmLoginSetup.ShowModal;
      finally
         frmLoginSetup.Free;
         frmLoginSetup := nil;
         if Assigned(dmConnection) then
         begin
            if dmConnection.orsInsight.Connected = True then
               dmConnection.orsInsight.Disconnect;
         end
         else
            dmConnection := TdmSaveDoc.Create(AddInModule);
         if dmConnection.orsInsight.Connected = False then dmConnection.GetUserID;
      end;
   except
//
   end;
end;

procedure TAddInModule.adxRibbonTab1Controls1Controls0Click(Sender: TObject;
  const RibbonControl: IRibbonControl);
var
   Control: IRibbonControl;
   IWindow: IDispatch;
begin
   try
      IWindow := HostApp.ActiveWindow;
   except
   end;
   try
      if IWindow <> nil then
         DoSave;
   finally
      IWindow := nil;
   end;
end;

procedure TAddInModule.adxRibbonTab1Controls2Controls0Click(Sender: TObject;
  const RibbonControl: IRibbonControl);
var
   lnmatter,
   lDocID,
   I: integer;
   FFileID,
   lDocs: string;
   fmDocList: TfrmDocList;
   Mail: Outlook2000.MailItem;
   sel: Outlook2000.Selection;
   Inspector: Outlook2000.Inspector;
   Explorer: Outlook2000.Explorer;
   item: IDispatch;
   lAttachments: Outlook2000.Attachments;
   lPath,
   lDocName: OLEVariant;
begin  // insert bhl insight document as an attachment
   if Assigned(fmDocList) then
   begin
      fmDocList := nil;
   end;

   case HostType of
      ohaOutlook:
         begin
            fmDocList := TfrmDocList.Create(nil);
            try
               if (fmDocList.ShowModal = mrOK) then
               begin
                  try
                     Inspector := OutlookApp.ActiveInspector;
                  except
                  end;

                  if Inspector <> nil then
                  begin
                     Mail := Inspector.CurrentItem as Outlook2000.MailItem;
                     if (Mail <> nil) then
                     begin
                        with fmDocList.tvDocList.DataController do
                        begin
                           for I := 0 to (GetSelectedCount - 1) do
                           begin
                              DataSet.Bookmark := GetSelectedBookmark(I);

                              lnMatter := DataSet.FieldValues['NMATTER'];
                              FFileID  := DataSet.FieldValues['FILEID'];
                              lDocID   := DataSet.FieldValues['DOCID'];
                              lPath    := DataSet.FieldValues['PATH'];
                              lDocName := DataSet.FieldValues['DOC_NAME'];

                              if lDocs <> '' then
                                 lDocs := lDocs + ', ';
                              lDocs := lDocs + lDocName;
                              lAttachments := Mail.Attachments;
                              lAttachments.Add(lPath, olByValue, olPosition, lDocName);
//                           Mail.Save;
                           end;
                        end;
                     end;
                     if Mail.Subject = '' then
                        Mail.Subject := lDocs + '  #'+FFileID
                     ///else
                        //Mail.Subject := Mail.Subject + '  #'+FFileID;
                  end;
               end;
            finally
               dmConnection.qryDocs.Close;
               FreeAndNil(fmDocList);
            end;
         end;
   end;
end;

procedure TAddInModule.adxRibbonTab1Controls2Controls1Click(Sender: TObject;
  const RibbonControl: IRibbonControl);
var
   lnmatter,
   lDocID,
   i: integer;
   FFileID,
   MsgBody,
   ADisp_Path,
   CurMsgBody,
   tmpFileName: string;
   fmDocList: TfrmDocList;
   Mail: Outlook2000.MailItem;
   sel: Outlook2000.Selection;
   Inspector: Outlook2000.Inspector;
   item: IDispatch;
   lAttachments: Outlook2000.Attachments;
   lPath,
   lDocName: OLEVariant;
begin
   if Assigned(fmDocList) then
   begin
      fmDocList := nil;
   end;

   case HostType of
      ohaOutlook:
         begin
            fmDocList := TfrmDocList.Create(nil);
            try
               if (fmDocList.ShowModal = mrOK) then
               begin
                  try
                     Inspector := OutlookApp.ActiveInspector;
                  except
                  end;

                  if Inspector <> nil then
                  begin
                     Mail := Inspector.CurrentItem as Outlook2000.MailItem;
                     if (Mail <> nil) then
                     begin
                        with fmDocList.tvDocList.DataController do
                        begin
                           MsgBody := '<html><head></head><h1>Documents for action</h1><body>';
                           for I := 0 to (GetSelectedCount - 1) do
                           begin
                              DataSet.Bookmark := GetSelectedBookmark(I);

                              lnMatter := DataSet.FieldValues['NMATTER'];
                              FFileID  := DataSet.FieldValues['FILEID'];
                              lDocID   := DataSet.FieldValues['DOCID'];
                              lPath    := DataSet.FieldValues['PATH'];
                              lDocName := DataSet.FieldValues['DOC_NAME'];

                              if tmpFileName <> '' then
                                 tmpFileName := tmpFileName + ', ';
                              ADisp_Path := lPath;

                              tmpFileName := tmpFileName + TableString('matter','nmatter',lnMatter ,'title') +' - ' + lDocName;

                              MsgBody := MsgBody + '<p><a href="file:///' + ADisp_Path+ '">'+ ExtractFileName(ADisp_Path) +'</a></p>';
                           end;
                        end;
                        MsgBody := MsgBody + '</body></html>';
                        Mail.HTMLBody := MsgBody;
                        Mail.Subject := tmpFileName + '  #'+FFileID;
                     end;
                  end;
               end;
            finally
               dmConnection.qryDocs.Close;
               FreeAndNil(fmDocList);
            end;
         end;
   end;
end;

procedure TAddInModule.DoItemAdd(ASender: TObject; const Item: IDispatch);
var
   Mail: Outlook2010.MailItem;
   IFolderSent: MAPIFolder;
begin
   try
      if Assigned(Item) then
      begin
         Item.QueryInterface(IID__MailItem, Mail);
         if Assigned(Mail) then
         begin
            try
               IFolderSent := Mail.Parent as MAPIFolder;
               if ((IFolderSent.Name = 'Sent Items') or
                  (IFolderSent.Name = 'Sent Mail')or
                  (IFolderSent.Name = 'Sent')) then
               begin
                  try
                     SentMessage(Mail, True);
                  finally
                     Mail := nil;
                  end;
               end;
            finally
               IFolderSent := nil;
            end;
         end;
      end;
   except
//
   end;
end;

procedure TAddInModule.DoSave;
var
   i, Count,
   LAppType,
   liTotalSelected,
   lArrayCount: Integer;
   PropValue: OleVariant;
   PropName: widestring;
   item: IDispatch;
   LIMail: Outlook2010.MailItem;
   IContact: ContactItem;
   IAppointment: AppointmentItem;
   sel: Outlook2000.Selection;
   lSubject: string;
   ReceivedDate: TDateTime;
   fmSaveDocDetails: TfrmSaveDocDetails;
begin
   try
      sel := OutlookApp.ActiveExplorer.Selection;
   except
   //
   end;

   if (sel <> nil) then
   begin
      liTotalSelected := OutlookApp.ActiveExplorer.Selection.Count;

      if liTotalSelected = 1 then
      begin
         item := sel.Item(1);
         item.QueryInterface(IID__MailItem, LIMail);
         if LIMail <> nil then
         begin
            lSubject := LIMail.Subject;
            ReceivedDate := LIMail.ReceivedTime;
         end
         else
         begin
            Exit;
         end;

         try
            FreeAndNil(fmSaveDocDetails);
            fmSaveDocDetails := TfrmSaveDocDetails.Create(nil);

            fmSaveDocDetails.AppType := LAppType;

            fmSaveDocDetails.MailSubject := lSubject;
            fmSaveDocDetails.ReceivedDate := ReceivedDate;
            fmSaveDocDetails.TimeNarration := DateTimeToStr(ReceivedDate) + ' ' + lSubject;
            fmSaveDocDetails.dFileCount := liTotalSelected;

            fmSaveDocDetails.LadxLCID := adxLCID;
            fmSaveDocDetails.IMail := LIMail;

            fmSaveDocDetails.ShowModal;
         finally
            FreeAndNil(fmSaveDocDetails);
            LIMail := nil;
         end;
      end;

      if (liTotalSelected > 200) then
         MsgInfo(IntToStr(liTotalSelected) + ' eMails selected. You should select 200 or less.')
      else
      begin
         if (liTotalSelected > 1) and (liTotalSelected <= 200) then
         begin
            lArrayCount := 0;
            SetLength(LDocList, 250);
            FreeAndNil(fmSaveDocDetails);
            fmSaveDocDetails := TfrmSaveDocDetails.Create(nil);
            for I := 1 to liTotalSelected do
            begin
               item := sel.Item(I);
               item.QueryInterface(IID__MailItem, LIMail);
               if LIMail <> nil then
               begin
                  fmSaveDocDetails.DocList[lArrayCount] := LImail;
               end
               else
               begin
                  Exit;
               end;
               inc(lArrayCount);
            end;
            if Length(fmSaveDocDetails.DocList) > 1 then
            begin
               fmSaveDocDetails.AppType := LAppType;

//               fmSaveDocDetails.MailSubject := lSubject;
//               fmSaveDocDetails.ReceivedDate := ReceivedDate;
//               fmSaveDocDetails.TimeNarration := DateTimeToStr(ReceivedDate) + ' ' + lSubject;
               fmSaveDocDetails.dFileCount := liTotalSelected;

               fmSaveDocDetails.LadxLCID := adxLCID;
//               fmSaveDocDetails.IMail := LIMail;

               fmSaveDocDetails.ShowModal;
            end;
         end;
      end;
   end;
end;

initialization
  TadxFactory.Create(ComServer, TInsight_Addin_for_Outlook, CLASS_Insight_Addin_for_Outlook, TAddInModule);

    dxInitialize();

  {initialize my Critical section.}
//   InitializeCriticalSection(CS);


finalization
  // unload
  dxFinalize();
  {finalize my Critical section.}
//   DeleteCriticalSection(CS);

end.

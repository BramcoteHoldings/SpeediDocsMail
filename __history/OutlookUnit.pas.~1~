unit OutlookUnit;

interface

uses SpeediDocs_IMPL, ActiveX, ComObj, Variants, SaveDocFunc, System.SysUtils,
     System.Classes, Windows, SaveDoc, DB, Outlook2000, Office2000,
     Messages, ShellAPI, System.StrUtils, Registry, SaveDocDetails,
     System.Math, Outlook2010;

const
   WM_NEWMESSAGE = WM_USER + 1;
//  NPR_FILEID: TRwMapiNamedProperty = (PropSetID: '{001b04db-360a-424e-ae80-3f1fce8c7458}'; PropID: $8000; PropName: 'NPR_FILEID'; PropType: PT_STRING8; PropKind: MNID_ID);


   function SaveOutlookMessage(DocSequence: string; rgStorageItemIndex: integer; ATxtDocPath: string;
                      ANewCopy, AOverwrite: boolean; AFileID, AAuthor, ADocName: string;
                      AWorkflowType, ATemplateType: string;
                      AGroupID, APrec_Category, APrec_Classification, ADocFolder: integer;
                      APrecedentDescr, AKeywords: string;
                      AReceivedDate: TDateTime; AMail: Outlook2000.MailItem;
                      AFromExplorer: boolean = False;
                      ADocID: integer = -1; SaveTime: boolean = false;
                      ATimeNarration: string = ''; ATimeUnits: integer = 1; ASent: boolean = False;
                      ATask: string = ''): boolean;

   procedure SentMessage(AMail: Outlook2000.MailItem; ANewEmail: boolean = False);
   procedure InboxMessage(AMail: Outlook2000.MailItem; AFileID: string; ANewEmail: boolean = False);
//   procedure SetOutlookApp(OutlookApp: TOutlookApplication);

   function WriteFileDetailsToDB(AParentDocID: integer; ANewDocName, AFileID, ADocDescr: string; ADocID: integer = -1; ADocFolder: integer = -1): boolean;
//   function UpdateAmount(AUnits: integer): currency;
//   function CalcRate(ATemplate: string): currency;

implementation

var
   tmpFileName:   string;
   tmpdir:        string;
   FFileID:       string;
   FOldFileID:    string;
   FEditing:      boolean;
   FMail:         Outlook2000.MailItem;
   LRegAxiom:     TRegistry;
//   dmSaveDoc:     TdmSaveDoc;

function SaveOutlookMessage(DocSequence: string; rgStorageItemIndex: integer; ATxtDocPath: string;
                            ANewCopy, AOverwrite: boolean; AFileID, AAuthor, ADocName: string;
                            AWorkflowType, ATemplateType: string;
                            AGroupID, APrec_Category, APrec_Classification, ADocFolder: integer;
                            APrecedentDescr, AKeywords: string;
                            AReceivedDate: TDateTime; AMail: Outlook2000.MailItem;
                            AFromExplorer: boolean = False;
                            ADocID: integer = -1; SaveTime: boolean = false;
                            ATimeNarration: string = ''; ATimeUnits: integer = 1; ASent: boolean = False;
                            ATask: string = ''): boolean;
var
   OLEResult: HResult;
   Unknown: IUnknown;
   MailName: WideString;
   lSubject,
   lEmailFrom
   ,FileID
   ,AParsedDocName
   ,lEmailTo
   ,lTask
   ,DispName
   ,AExt
   ,ADispName
   ,ANewDocName
   ,ASubject
   ,AParsedDir
   ,ADocDescr
   ,ParsedVarDocName
   ,ParsedOldDocName
   ,VarDocName
   ,RandFile,
   LPrevFILEID : string;
   up: UserProperty;
   ups: UserProperties;
   item: IDispatch;
   sel: Selection;
   LNMatter
   ,lDocID
   ,x
   ,i
   ,FHashPos
   ,lTimeUnits
   ,iCount
   ,AParentDocID,
   lnRecipCount : integer;
   lRate
   ,lAmount: double;
   bUseSubject: boolean;
   bDocSeqAppend: boolean;
   lAttachments
   ,Attachment: OLEVariant;
   lNewFolder,
   lParentFolder: MapiFolder;
   ns : Outlook2000._NameSpace;
   lMailCopy: Outlook2000.MailItem;
   Flags
   ,AType: variant;
   lRecipients: Outlook2000.Recipients;
   FProp: Outlook2000.UserProperty;
   FPropPrev: Outlook2000.UserProperty;
   Categories:    string;
   OldDocName:    string;   //AES 07/09/2018
   bCategoriseEmails: boolean;
   ADocumentSaved: boolean;   //AES 07/09/2018
begin
   x := 0;
   if AFromExplorer then
   begin
      FMail := AMail;
   end;

   if FMail <> nil then
   begin
      Categories := AMail.Categories;
      bCategoriseEmails := (SystemString('CATEGORISE_EMAILS') = 'Y');
//      OutputDebugString('2');
{      if IMAil.Attachments.Count > 0 then
      begin
         OutputDebugString('3');
         while IMail.Attachments.Count > 0 do
            IMail.Attachments.Remove(1);
      end; }
//      OutputDebugString('4');

      //AES 07/09/2018
      tmpdir := IncludeTrailingPathDelimiter(GetEnvironmentVariable('TEMP'));

      try
         if (Assigned(dmConnection) = False) then
            dmConnection := TdmSaveDoc.Create(nil);
         if dmConnection.orsInsight.Connected = False then dmConnection.GetUserID;

         ns := AddInModule.OutlookApp.GetNamespace('MAPI');

         bUseSubject := (SystemString('USE_MAIL_SUBJECT_AS_NAME') = 'Y');
         bDocSeqAppend := (SystemString('DOC_SEQ_APPEND') = 'Y');
         lDocID := dmConnection.DocID;
         lEmailFrom := FMail.SenderName;

 {        if FMail.Recipients.Count > 0 then
         begin
            for lnRecipCount := 1 to FMail.Recipients.Count do
            begin
               if (lEmailTo <> '') then
                  lEmailTo := lEmailTo +'; ';
               lEmailTo := lEmailTo + FMail.Recipients.Item(lnRecipCount).Name;
            end;
         end;  }

         if (Fmail.CC <> '') then
         begin
            lEmailTo := 'cc: ' + Fmail.CC + char(13) + char(10) + 'to: ' + Fmail.To_;
         end
         else
         begin
            lEmailTo := Fmail.To_;
         end;

         lSubject := FMail.Subject;
         for x := 1 to length(lSubject) do
         begin
            if (lSubject[x] in ['/', '\', '?','"','<','>','|','*',':', '.']) then
               lSubject[x] := ' ';
         end;

         //if (lDocID <= 0) and (ADocID = -1) then
         if (ADocID = -1) then
         begin
            if (dmConnection.qryMatterAttachments.Active = False)  then
               dmConnection.qryMatterAttachments.Open;
            dmConnection.qryMatterAttachments.insert;
            dmConnection.qryMatterAttachments.ParamByName('docid').AsInteger := dmConnection.DocID;
            lDocID := dmConnection.DocID;
         end
         else
            if (lDocID <= 0) then
               lDocID := ADocID;

         if EndsText('\',ATxtDocPath) then
            ATxtDocPath := LeftStr(ATxtDocPath,length(ATxtDocPath)-1);

         //DW 11 Jul 2018 added doc_id to file name to ensure unique file name
         if (bUseSubject = True) then
         begin
            if (bDocSeqAppend = True) then
            begin
                MailName := IncludeTrailingPathDelimiter(ATxtDocPath) + lSubject + '_' + '[DOCSEQUENCE]' + '_' + IntToStr(lDocID) + '.msg';
            end
            else
            begin
                if (FileExists(IncludeTrailingPathDelimiter(ATxtDocPath) + lSubject + '_' + '[DOCSEQUENCE]' + '.msg')) then
                    MailName := IncludeTrailingPathDelimiter(ATxtDocPath) + lSubject + '_' + '[DOCSEQUENCE]' + '_' + IntToStr(lDocID) + '.msg'
                else
                    MailName := IncludeTrailingPathDelimiter(ATxtDocPath) + lSubject + '_' + '[DOCSEQUENCE]' + '.msg';
            end;
         end
         else
         begin
            MailName := IncludeTrailingPathDelimiter(ATxtDocPath) + IntToStr(lDocID) + '.msg'
         end;

         LNMatter := TableInteger('MATTER','FILEID', AFileID,'NMATTER');
         AParsedDocName := ParseMacros(MailName,LNMatter, lDocID, ADocName) ;

         // AES 07 Sep 2018
        { if not DirectoryExists(ExtractFileDir(AParsedDocName)) then
            ForceDirectories(ExtractFileDir(AParsedDocName)); }

         FPropPrev := FMail.UserProperties.Find('MATTER', True);
         if Assigned(FPropPrev) then
         try
            LPrevFILEID := FPropPrev.Value;
         finally
            FPropPrev := nil;
         end;
         FProp := FMail.UserProperties.Find('MATTER', True);
         if FProp = nil then
         begin
             FProp := FMail.UserProperties.Add('MATTER', olText, False, 1);
             if Assigned(FProp) then
             try
                FProp.Value := AFileID;
                FMail.Save;
             finally
                FProp := nil;
             end;
         end
         else
         begin
             if AFileID <> LPrevFILEID then
                  FProp.Value := AFileID + ', ' + LPrevFILEID;
         end;
         FMail.Save;

         //AES 07/09/2018
         OldDocName := tmpdir + ExtractFileName(AParsedDocName);
         FMail.SaveAs(OldDocName {AParsedDocName} ,olMSG);

         if (TOSVersion.Name = 'Windows 8') or (TOSVersion.Name = 'Windows Server 2012') or (TOSVersion.Major = 10) then
            ADocumentSaved := CopyFileIFileOperationForceDirectories(OldDocName, AParsedDocName)
         else
            ADocumentSaved := WriteFileToDisk(AParsedDocName, OldDocName);

         //FMail.SaveAs(AParsedDocName ,olMSG);

//         OutputDebugString('5');

//         OutputDebugString('6');
         try
            if dmConnection.qryMatterAttachments.Active = False then
            begin
               dmConnection.orsInsight.StartTransaction;
               dmConnection.qryMatterAttachments.Open;

            end;
            if dmConnection.qryMatterAttachments.State = dsBrowse then
               dmConnection.qryMatterAttachments.Insert;

            AParentDocID := lDocID;

            TableInteger('MATTER','FILEID',AFileID,'nMatter');

            dmConnection.qryMatterAttachments.FieldByName('docid').AsInteger := lDocID;
            dmConnection.qryMatterAttachments.FieldByName('fileid').AsString := AFileid;
            dmConnection.qryMatterAttachments.FieldByName('nmatter').AsInteger := TableInteger('MATTER','FILEID',AFileID,'nMatter');
            dmConnection.qryMatterAttachments.FieldByName('auth1').AsString := UpperCase(AAuthor);  //  dmConnection.UserID;
            if (FEditing = False) then
               dmConnection.qryMatterAttachments.FieldByName('D_CREATE').AsDateTime := AReceivedDate;

            dmConnection.qryMatterAttachments.FieldByName('IMAGEINDEX').AsInteger := 4;
            dmConnection.qryMatterAttachments.FieldByName('DOC_NAME').AsString := ExtractFileName(AParsedDocName);
            dmConnection.qryMatterAttachments.FieldByName('DESCR').AsString := ADocName;
            dmConnection.qryMatterAttachments.FieldByName('SEARCH').AsString := ADocName;
            dmConnection.qryMatterAttachments.FieldByName('FILE_EXTENSION').AsString := Copy(ExtractFileExt(AParsedDocName),2, Length(ExtractFileExt(AParsedDocName)));
            dmConnection.qryMatterAttachments.FieldByName('precedent_details').AsString := ADocName;
            dmConnection.qryMatterAttachments.FieldByName('KEYWORDS').AsString := AKeywords;
            dmConnection.qryMatterAttachments.FieldByName('EMAIL_FROM').AsString := lEmailFrom;
            dmConnection.qryMatterAttachments.FieldByName('EMAIL_SENT_TO').AsString := lEmailTo;

            if (APrec_Category > -1) then
               dmConnection.qryMatterAttachments.FieldByName('NPRECCATEGORY').AsInteger := APrec_Category
            else
            begin
               try
                  dmConnection.qryMatterAttachments.FieldByName('NPRECCATEGORY').AsInteger := SystemInteger('EMAIL_DFLT_CATEGORY');
               except
               //
               end;
            end;

            if (APrec_Classification > -1) then
               dmConnection.qryMatterAttachments.FieldByName('NPRECCLASSIFICATION').AsInteger := APrec_Classification
            else
            begin
               try
                  dmConnection.qryMatterAttachments.FieldByName('NPRECCLASSIFICATION').AsInteger := SystemInteger('EMAIL_DFLT_CLASSIFICATION');
               except
                 //
               end;
            end;
            if (ADocFolder > -1) then
               dmConnection.qryMatterAttachments.FieldByName('FOLDER_ID').AsInteger := ADocFolder;

            //            if cbPortalAccess.Checked then
//               dmConnection.qryMatterAttachments.FieldByName('EXTERNAL_ACCESS').AsString := 'Y'
//            else
               dmConnection.qryMatterAttachments.FieldByName('EXTERNAL_ACCESS').AsString := 'N';

            if FEditing then
            begin
               dmConnection.qryMatterAttachments.FieldByName('D_MODIF').AsDateTime := Now;
               dmConnection.qryMatterAttachments.FieldByName('auth2').AsString := dmConnection.UserCode;
            end;

            if rgStorageItemIndex = 0 then
            begin
               TBlobField(dmConnection.qryMatterAttachments.fieldByname('DOCUMENT')).LoadFromFile(tmpFileName);
            end
            else
            begin
               dmConnection.qryMatterAttachments.FieldByName('PATH').AsString := IndexPath(AParsedDocName, 'DOC_SHARE_PATH');
               dmConnection.qryMatterAttachments.FieldByName('display_PATH').AsString := AParsedDocName;
            end;

            dmConnection.qryMatterAttachments.Post;
            dmConnection.qryMatterAttachments.ApplyUpdates;

            LregAxiom := TRegistry.Create;
            try
               LregAxiom.RootKey := HKEY_CURRENT_USER;
               LregAxiom.OpenKey(csRegistryRoot, False);

               {if (ASent = True) then
               begin
                  lParentFolder := ns.GetDefaultFolder(olFolderInbox).Parent as MAPIFolder;
                  try
                     lNewFolder := lParentFolder.Folders.Item('Sent from Insight') as MAPIFolder;
                  except
                     if (not assigned(lNewFolder)) then
                        lNewFolder := lParentFolder.Folders.Add('Sent from Insight', olFolderInbox);
                  end;
               end
               else
               begin
                  lParentFolder := ns.GetDefaultFolder(olFolderInbox).Parent as MAPIFolder;
                  try
                     lNewFolder := lParentFolder.Folders.Item('Saved In Insight') as MAPIFolder;
                  except
                     if (not assigned(lNewFolder)) then
                        lNewFolder := lParentFolder.Folders.Add('Saved In Insight', olFolderInbox);
                  end;
               end; }
            finally
               if ((LregAxiom.ReadString('SaveOutgoingEmails') = 'Y') or
                  (LregAxiom.ReadString('SaveIncomingEmails') = 'Y')) then
               begin
                  Randomize;
                  RandFile := IntToStr(RandomRange(100, 10000));
                  tmpFileName := IncludeTrailingPathDelimiter(dmConnection.GetEnvVar('TMP')) + 'insighteml' + RandFile + '.msg';
                  FMail.SaveAs(tmpFileName, olMSG);

                  if (LregAxiom.ReadString('SaveOutgoingEmails') = 'Y') then
                  begin
                     try
                        AddInModule.ol2010.CopyFile(tmpFileName, 'Sent from Insight');
                     except
//                        on E : Exception do

                     end;
                  end;

                  if (LregAxiom.ReadString('SaveIncomingEmails') = 'Y') then
                  begin
                     try
                        AddInModule.ol2010.CopyFile(tmpFileName, 'Saved In Insight');
                        if (LregAxiom.ReadString('RemoveSavedEmails') = 'Y') then
                           FMail.Delete;
                     except

                     end;
                  end;

//                  DeleteFile(tmpFileName);
               end;

//               if (not VarIsNull(lMailCopy))  then
 //                 lMailCopy := varNull;
{               if Assigned(lNewFolder) then
                  lNewFolder := nil;
               if Assigned(lParentFolder) then
                  lParentFolder := nil;  }

               LregAxiom.Free;
            end;

            if SystemString('EMAIL_SEPARATE_ATTACHMENTS') = 'Y' then
            begin
               lAttachments := FMail.Attachments;
               for iCount := 1 to lAttachments.Count do
               begin
                  Attachment := lAttachments.Item(iCount);

                  flags := lAttachments.Item(iCount).PropertyAccessor.GetProperty('http://schemas.microsoft.com/mapi/proptag/0x37140003');

                  //To ignore embedded attachments -
                  if (flags <> 4) then
                  begin
                     AType := lAttachments.Item(iCount).Type;
                     // DW 12 Jul 2018 allow email message attachments to be saved
                     //if (AType <> 5) then
                     //begin
                        DispName := Attachment.DisplayName;

                        if DispName = '' then
                           DispName := Attachment.FileName;

                        if DispName = '' then
                           DispName := 'Email Attachment';

                        while Pos('/', DispName) > 0 do
                           DispName[Pos('/', DispName)] := '.';

                        while Pos('\', DispName) > 0 do
                           DispName[Pos('\', DispName)] := '.';

                        AExt := ExtractFileExt(DispName);
                        if (AType = 5) and (uppercase(AExt) <> '.MSG') then
                        begin
                             AExt := '.MSG';
                             DispName := DispName + AExt;
                        end;
                        ADispName := Copy (DispName,1, Length(DispName)- Length(AExt));

                        ADispName := ADispName + '_' + '[DOCSEQUENCE]';

                        // DW 12 Jul 2018 remove invalid characters from filename
                        for x := 1 to length(ADispName) do
                        begin
                        if (ADispName[x] in ['/', '\', '?','"','<','>','|','*',':', '.']) then
                            ADispName[x] := ' ';
                        end;
                        if dmConnection.qrySaveEmailAttachments.State = dsInactive then
                        begin
                            if ADocID = -1 then
                               dmConnection.qrySaveEmailAttachments.ParamByName('docid').AsString := dmConnection.AttDocID
                            else
                               dmConnection.qrySaveEmailAttachments.ParamByName('docid').AsInteger := ADocID;

                            dmConnection.qrySaveEmailAttachments.Open;
                        end;

                        if dmConnection.qrySaveEmailAttachments.State = dsBrowse then
                            dmConnection.qrySaveEmailAttachments.Insert;
                        if (bDocSeqAppend = True) then
                            DispName := ADispName + '_' + dmConnection.AttDocID + AExt;

                        VarDocName := ATxtDocPath +'\'+ DispName;

//                         VarDocName := AParsedDir + DispName;
                        ParsedVarDocName := ParseMacros(VarDocName, TableInteger('MATTER','FILEID',AFileID,'NMATTER'), lDocID, DispName);
                        if (FileExists(ParsedVarDocName)) then
                        begin
                              AExt := ExtractFileExt(ParsedVarDocName);
                              ADispName := Copy (ParsedVarDocName,1, Length(ParsedVarDocName)- Length(AExt));
                              ParsedVarDocName := ADispName + '_' + dmConnection.AttDocID + AExt;
                        end;

                        Attachment.SaveAsFile(ParsedVarDocName);

                        WriteFileDetailsToDB(AParentDocID, ParsedVarDocName, AFileID, ADocDescr, ADocFolder);
                     //end;
                  end;
               end;
            end;
            if not ContainsText(Categories, 'SpeediDocs') and (bCategoriseEMails = True) then
            begin
                 Categories := AMail.Categories;
                 if (Length(Categories) = 0) then
                 Begin
                     AMail.Categories := 'SpeediDocs';
                 End
                 Else
                 Begin
                     AMail.Categories := Categories + ', SpeediDocs';
                 End;
                 AMail.Save;
            end;

            if SaveTime then
            begin
               lTimeUnits := dmConnection.SystemInteger('TIME_UNITS');
               if ATask <> '' then
                  lTask := ATask
               else
                  lTask := dmConnection.SystemString('DFLT_EMAIL_TASK');

               lRate := CalcRate(AAuthor, lTask, AReceivedDate, AFileID);
               lAmount := ATimeUnits * lRate / (60 / lTimeUnits);
               FeeTmpInsert(LNMatter, AAuthor, ATimeNarration, lAmount, lTask, ATimeUnits,
                            (ATimeUnits*lTimeUnits), lRate, 'GST');
            end;
            dmConnection.orsInsight.Commit;
         except
            dmConnection.orsInsight.Rollback;
         end;
      finally
//         dmConnection.orsInsight.Disconnect;
//         dmConnection.Free;
//         dmSaveDoc := nil;
      end;
   end;
end;

function WriteFileDetailsToDB(AParentDocID: integer; ANewDocName, AFileID, ADocDescr: string; ADocID: integer = -1; ADocFolder: integer = -1): boolean;
var
   FileExt: string;
   FileImg: integer;
begin
   dmConnection.qrySaveEmailAttachments.FieldByName('docid').AsString := dmConnection.AttDocID;
   dmConnection.qrySaveEmailAttachments.FieldByName('fileid').AsString := AFileID;
   dmConnection.qrySaveEmailAttachments.FieldByName('nmatter').AsInteger := TableInteger('MATTER','FILEID',AFileID,'NMATTER');
   dmConnection.qrySaveEmailAttachments.FieldByName('auth1').AsString := UpperCase(dmConnection.UserID);

   dmConnection.qrySaveEmailAttachments.FieldByName('DOC_NAME').AsString := ExtractFileName(ANewDocName);

   dmConnection.qrySaveEmailAttachments.FieldByName('DESCR').AsString := ADocDescr;
   dmConnection.qrySaveEmailAttachments.FieldByName('FILE_EXTENSION').AsString := Copy(ExtractFileExt(ANewDocName),2, length(ExtractFileExt(ANewDocName)));

   dmConnection.qrySaveEmailAttachments.FieldByName('PATH').AsString := IndexPath(ANewDocName, 'DOC_SHARE_PATH');
   dmConnection.qrySaveEmailAttachments.FieldByName('DISPLAY_PATH').AsString := ANewDocName;
   dmConnection.qrySaveEmailAttachments.FieldByName('PARENTDOCID').AsInteger := AParentDocID;
   dmConnection.qrySaveEmailAttachments.FieldByName('IS_ATTACHMENT').AsString := 'Y';
   if (ADocFolder > -1) then
        dmConnection.qryMatterAttachments.FieldByName('FOLDER_ID').AsInteger := ADocFolder;

   FileExt := uppercase(dmConnection.qrySaveEmailAttachments.FieldByName('FILE_EXTENSION').AsString);
   if (FileExt = 'DOC') or (FileExt = 'DOCX') then
      FileImg := 2
   else if (FileExt = 'XLS') or (FileExt = 'XLSX') then
      FileImg := 3
   else if (FileExt = 'PDF')  then
      FileImg := 5
   else if (FileExt = 'MSG') then
      FileImg := 4
   else
      FileImg := 1;

   try
      dmConnection.qrySaveEmailAttachments.FieldByName('D_CREATE').AsDateTime := FileDateToDateTime(FileAge(ANewDocName));
   except
    //
   end;

   dmConnection.qrySaveEmailAttachments.FieldByName('IMAGEINDEX').AsInteger := FileImg;
   dmConnection.qrySaveEmailAttachments.FieldByName('precedent_details').AsString := 'Email attachment - ';
   dmConnection.qrySaveEmailAttachments.FieldByName('KEYWORDS').AsString := 'Email attachment - ';

   dmConnection.qrySaveEmailAttachments.Post;
   dmConnection.qrySaveEmailAttachments.ApplyUpdates;
end;


procedure SentMessage(AMail: Outlook2000.MailItem; ANewEmail: boolean = False);
var
   sSubject,
   FileID: string;
   x,
   i: integer;
   Prop: Outlook2000.UserProperty;
   IDsp: IDispatch;
   IMail: MailItem;
   ReceivedDate: TDateTime;
   Categories:    string;
   bCategoriseEmails: boolean;
begin
   try
      Categories := AMail.Categories;
      bCategoriseEmails := (SystemString('CATEGORISE_EMAILS') = 'Y');
      sSubject := AMail.Subject;
      Prop := nil;
      Prop := AMail.UserProperties.Find('SPPROCESS', True);
      if Prop = nil then
      begin
         Prop := AMail.UserProperties.Add('SPPROCESS', olDateTime, False, 1);
         if Assigned(Prop) then
         try
            Prop.Value := Now;
            AMail.Save;
         finally
            Prop := nil;
         end;
      end;
      if (pos('#', sSubject) > 0) then
      begin
         for i := 1 to length(sSubject) do
         begin
            if (sSubject[i] = '#') then
            begin
               for x := i + 1 to length(sSubject) do
               begin
                  if ((sSubject[x] <> ' ') and (sSubject[x] <> ']')) then
                     FileID := FileID + sSubject[x]
                  else
                     break;
               end;
            end;
            if (FileID <> '')  then
               break;
         end;

         if ((FileID <> '') and (dmConnection.IsValidMatter(FileID) = True)) then
         begin
            if Assigned(AMail) then
            begin
                try
                   if FileID <> '' then
                   begin
                      try
                         Prop := AMail.UserProperties.Find('MATTER', True);
                      except
                         begin
                            if not Assigned(Prop) then
                              Prop := AMail.UserProperties.Add('MATTER', olText, False, 1);
                            if Assigned(Prop) then
                            try
                              Prop.Value := FileID;
                              AMail.Save;
                            finally
                              Prop := nil;
                            end;
                         end;
                      end;
                   end;
                except
                   if not Assigned(Prop) then
                      Prop := AMail.UserProperties.Add('MATTER', olText, False, 1);
                   if Assigned(Prop) then
                   try
                      Prop.Value := FileID;
                      AMail.Save;
                   finally
                      Prop := nil;
                   end;
                end;

//               prop := 'http://schemas.microsoft.com/mapi/string/{00020329-0000-0000-C000-000000000046}/Matter';
//               OleVariant(OutlookApp.ActiveInspector.CurrentItem).PropertyAccessor.SetProperty(prop,FileID);
                 if prop = nil then
                 begin
                    if not Assigned(Prop) then
                      Prop := AMail.UserProperties.Add('MATTER', olText, False, 1);
                    if Assigned(Prop) then
                    try
                       Prop.Value := FileID;
                       AMail.Save;
                    finally
                       Prop := nil;
                    end;
                 end;
                 if AMail.Sent = False then
                     Sleep(200);
            end;
            InboxMessage(AMail, FileID, ANewEmail);
         end
         else if ((FileID <> '') and (MatterExists(FileID) = FALSE)) then
         begin
             if (bCategoriseEmails = True) then
              begin
                    if (Length(Categories) = 0) then
                    Begin
                          AMail.Categories := 'Invalid_Matter';
                          AMail.Save
                    End;

                    if not (ContainsText(Categories,'Invalid_Matter')) then
                    Begin
                           AMail.Categories := Categories + ', Invalid_Matter';
                           AMail.Save
                    End;
              end;
         end;
      end
      else
      begin
         if (ANewEmail = True) and (bSaveSentEmail = true) then
         begin
            try
               if not ContainsText(Categories, 'SpeediDocs') then
               begin
                   Prop := AMail.UserProperties.Find('MATTER', True);
                   if not Assigned(Prop) then
                   begin
                       ReceivedDate := AMail.ReceivedTime;
                       frmSaveDocDetails := TfrmSaveDocDetails.Create(nil);
                       frmSaveDocDetails.AppType := 3;  //Outlook

                       frmSaveDocDetails.btnClose.Caption := 'Don''t save';
                       frmSaveDocDetails.MailSubject := sSubject;
                       frmSaveDocDetails.ReceivedDate := ReceivedDate;
                       frmSaveDocDetails.TimeNarration := DateTimeToStr(ReceivedDate) + ' ' + sSubject;
        //               SetOutlookApp(OutlookApp);

        //               frmSaveDocDetails.LadxLCID := adxLCID;
                       frmSaveDocDetails.IMail := AMail;
                       frmSaveDocDetails.SentEmail := ANewEmail;

                       frmSaveDocDetails.ShowModal;
                   end;
               end;
            finally
              frmSaveDocDetails := nil;
              AMail := nil;
            end;
         end;
      end;
   except
   //
   end;
end;

procedure InboxMessage(AMail: Outlook2000.MailItem; AFileID: string; ANewEmail: boolean = False {; OutlookApp: TOutlookApplication});
var
   sSubject,
   FileID,
   DocSequence,
   DfltDir: string;
   x,
   i: integer;
   prop: Outlook2000.UserProperty;
   bSaveTime: boolean;
   Categories:    string;
   bCategoriseEmails: boolean;
//   dmSaveDoc: TdmSaveDoc;
begin
   prop := nil;
   FileID := AFileID;
   sSubject := AMail.Subject;
   Categories := AMail.Categories;
   bCategoriseEmails := (SystemString('CATEGORISE_EMAILS') = 'Y');
   if Assigned(AMail) then
   begin
      try
          prop := AMail.UserProperties.Find('MATTER', True);
          if Assigned(prop) then
              FileId := prop.Value;
      except
//         on E: EExternalModuleException do
      end;
   end;
   if (FileID = '') then
   begin
      sSubject := AMail.Subject;
      if (Pos('#',sSubject) > 0) then
      begin
         for i := 1 to length(sSubject) do
         begin
            if sSubject[i] = '#' then
            begin
               for x := i + 1 to length(sSubject) do
               begin
                  if (sSubject[x] = ' ') then
                     break;
                  if ((sSubject[x] <> ' ') and (sSubject[x] <> '[')
                     and (sSubject[x] <> ']')) then
                     FileID := FileID + sSubject[x]
                  else
                     break;
               end;
            end;
            if (FileID <> '') then
               break;
         end;
      end;
   end;

   try
      if (not Assigned(dmConnection)) then
         dmConnection := TdmSaveDoc.Create(nil);
      if dmConnection.orsInsight.Connected = False then dmConnection.GetUserID;

      AddInModule.WriteLog('comparing email = ' + AMail.Subject + ' received: ' + DateTimetoStr(AMail.ReceivedTime) + ' sent: ' + DateTimetoStr(AMail.SentOn));
      if ((FileID <> '') and (MatterExists(FileID) = true)) then
      begin
         try
            if dmConnection.orsInsight.Connected = False then dmConnection.GetUserID;
            with dmConnection.qryCheckEmail do
            begin
               Close;
               ParamByName('descr').AsString := sSubject;
               ParamByName('D_CREATE').AsDateTime := AMail.ReceivedTime;
               //ParamByName('D_CREATE').AsDateTime := AMail.SentOn;
               ParamByName('fileid').AsString := FileID;
               Open;
               if ((FieldByName('rec_found').IsNull = True) or (ANewEmail = True))  then
               begin
                  FMail := AMail;
                  DfltDir := SystemString('DRAG_DEFAULT_DIRECTORY');
                  bSaveTime := (SystemString('CREATE_TIME_FROM_EMAIL') = 'Y');
                  SaveOutlookMessage(DocSequence, 1, DfltDir,
                           True, True, FileID,
                           dmConnection.UserCode, AMail.Subject,
                           '', '',
                           -1, SystemInteger('EMAIL_DFLT_CATEGORY'), SystemInteger('EMAIL_DFLT_CLASSIFICATION'), -1,
                           '','',
                           AMail.ReceivedTime, AMail, False, -1, bSaveTime);
                  AddInModule.WriteLog('Saving email = ' + AMail.Subject + ' ' + DatetoStr(AMail.ReceivedTime));
               end
               else
               begin
                  AddInModule.WriteLog('double up email = ' + AMail.Subject + ' received: ' + DateTimetoStr(AMail.ReceivedTime) + ' sent: ' + DateTimetoStr(AMail.SentOn));
               end;
            end;
         finally
            dmConnection.qryCheckEmail.Close;
         end;
      end
      else if ((FileID <> '') and (MatterExists(FileID) = FALSE)) then
      begin
         if (bCategoriseEmails = True) then
          begin
                if (Length(Categories) = 0) then
                Begin
                      AMail.Categories := 'Invalid_Matter';
                      AMail.Save
                End;

                if not (ContainsText(Categories,'Invalid_Matter')) then
                Begin
                       AMail.Categories := Categories + ', Invalid_Matter';
                       AMail.Save
                End;
          end;
      end;
   finally
      //AddInModule.WriteLog('final on ' + AMail.Subject + ' received: ' + DateTimetoStr(AMail.ReceivedTime) + ' sent: ' + DateTimetoStr(AMail.SentOn));

 //     dmConnection.orsInsight.Disconnect;
//      dmSaveDoc.Free;
//      dmSaveDoc := nil;
   end;
end;

procedure SetOutlookApp(OutlookApp: TOutlookApplication);
begin
//    AMSOutlook := OutlookApp;
end;

{function UpdateAmount(AUnits: integer): currency;
var
   bError:  boolean;
   sTemplate: string;
   nAmount: Currency;
begin
   sTemplate := SystemString('DFLT_EMAIL_TASK');
   if (SystemInteger('TIME_UNITS') > 0) then
   begin
      if (TableCurrency('SCALECOST','CODE',string(sTemplate), 'RATE') = 0) then
      begin
         try
            nAmount := AUnits * nRate / 60;
         except
            nAmount := 0.00;
         end;
      end
//      CalcTax;
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

function CalcRate(ATemplate: string): currency;
begin
   if ((TableCurrency('SCALECOST','CODE',string(ATemplate),'AMOUNT') <> 0) and
      (TableString('SCALECOST','CODE',string(ATemplate),'ZERO_FEE') = 'N')) then
      Result := FeeRate('', cmbMatterFind.EditText, cbAuthor.EditValue, dtpCreated.Date);
end;   }


end.

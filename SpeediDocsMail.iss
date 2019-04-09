#define AppName "{543CFF7F-8DE9-4797-AEDF-83DCD6C3E8D7}"
#define AppVersion "4.0.0.8"



[Setup]
AppName                = SpeediDocsMail
AppVerName             = SpeediDocsMail 4.0.0.8
OutputBaseFilename     = SpeediDocsMail
DefaultDirName         = {pf32}\SpeediDocs
OutputDir              = _Setup
AppPublisher           = Bramcote Holdings Pty Ltd
AppSupportURL          = http:\\support.bhlinsight.com
AppId                  = {{#AppName}
AppVersion             = {#AppVersion}
WizardImageFile        = Office2007Gray.bmp
WizardSmallImageFile   = compiler:WizModernSmallImage-IS.bmp
SetupIconFile          = Insight_Icon.ico
;
; Specifically permit running 64bit mode, since we need this to read from the
; correct node in the Registry.
; "ArchitecturesAllowed=x64" specifies that Setup cannot run on anything but x64.
; "ArchitecturesInstallIn64BitMode=x64" requests that the install be done
; in "64-bit mode" on x64, meaning it should use the native 64-bit Program Files
; directory and the 64-bit view of the registry.
;
ArchitecturesAllowed=x86 x64
ArchitecturesInstallIn64BitMode=x64
 

[Files]
; Add-in dll
Source: "Win32\output\SpeediDocsMail.dll";                    DestDir: "{app}"; Flags: regserver; Check: not IsOutlook64bit
; Source: "Win64\SpeediDocs.dll";                               DestDir: "{app}"; Flags: regserver; Check: IsOutlook64bit
Source: "gdiplus.dll";                                        DestDir: "{app}"; Flags: ignoreversion
Source: "SpeediDocsMail.ini";                                     DestDir: "{app}";
Source: "IntResource.dll";                                    DestDir: "{app}"; Flags: ignoreversion
Source: "IntResource64.dll";                                  DestDir: "{app}"; Flags: ignoreversion

; Add the ISSkin DLL used for skinning Inno Setup installations.
Source: ISSkin.dll; DestDir: {app}; Flags: dontcopy

; Add the Visual Style resource contains resources used for skinning,
Source: Office2007.cjstyles; DestDir: {tmp}; Flags: dontcopy 

[Registry]
; outlook entries
Root: HKCU; Subkey: "SOFTWARE\Microsoft\Office\Outlook\Addins\SpeediDocs.coSpeediDocs"; Flags: uninsdeletekey; ValueType: dword; \
   ValueName: "LoadBehavior"; ValueData: "3";
Root: HKCU; Subkey: {{Code:BuildOutlookResiliencyKey}; Flags: uninsdeletekey; ValueType: dword; \
    ValueName: "SpeediDocs.coSpeediDocs"; ValueData: "1"; 
; word entries
Root: HKCU; Subkey: "SOFTWARE\Microsoft\Office\Word\Addins\SpeediDocs.coSpeediDocs"; Flags: uninsdeletekey; ValueType: dword; \
   ValueName: "LoadBehavior"; ValueData: "3";
; excel
Root: HKCU; Subkey: "SOFTWARE\Microsoft\Office\Excel\Addins\SpeediDocs.coSpeediDocs"; Flags: uninsdeletekey; ValueType: dword; \
   ValueName: "LoadBehavior"; ValueData: "3";


[Code]
// Importing LoadSkin API from ISSkin.DLL
procedure LoadSkin(lpszPath: String; lpszIniFileName: String);
external 'LoadSkin@files:isskin.dll stdcall';

// Importing UnloadSkin API from ISSkin.DLL
procedure UnloadSkin();
external 'UnloadSkin@files:isskin.dll stdcall';

// Importing ShowWindow Windows API from User32.DLL
function ShowWindow(hWnd: Integer; uType: Integer): Integer;
external 'ShowWindow@user32.dll stdcall';  

function IsOffice64(): boolean;
var
  bitness: string;
  path: string;
begin
  Result := False;
  bitness := '';
  path := '';
  // Windows x64
  if IsWin64 then 
  begin
    // Office 2010
      // Outlook 2010 x64
      if RegValueExists(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\14.0\Outlook', 'Bitness') then
      begin
        if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\14.0\Outlook', 'Bitness', bitness) then
        begin
          Result := bitness = 'x64';
          Exit;
        end;
      end
      else
      begin
        // check other Office 2010 applications
        // Excel 2010
        if RegKeyExists(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\14.0\Excel\InstallRoot') then
        begin
          if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\14.0\Excel\InstallRoot', 'Path', path) then
          begin
            if Pos('(x86)', path) = 0 then
            begin
              Result := True;
              Exit;
            end;
          end;
        end;
        // Word 2010
        if RegKeyExists(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\14.0\Word\InstallRoot') then
        begin
          if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\14.0\Word\InstallRoot', 'Path', path) then
          begin
            if Pos('(x86)', path) = 0 then
            begin
              Result := True;
              Exit;
            end;
          end;
        end;
        // PowerPoint 2010
        if RegKeyExists(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\14.0\PowerPoint\InstallRoot') then
        begin
          if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\14.0\PowerPoint\InstallRoot', 'Path', path) then
          begin
            if Pos('(x86)', path) = 0 then
            begin
              Result := True;
              Exit;
            end;
          end;
        end;

        // Office 2013
        // Outlook 2013 x64
        if RegValueExists(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\15.0\Outlook', 'Bitness') then
        begin
          if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\15.0\Outlook', 'Bitness', bitness) then
          begin
            Result := bitness = 'x64';
            Exit;
          end;
        end
        else
        begin
          // check other Office 2013 applications
          // Excel 2013
          if RegKeyExists(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\15.0\Excel\InstallRoot') then
          begin
            if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\15.0\Excel\InstallRoot', 'Path', path) then
            begin
              if Pos('(x86)', path) = 0 then
              begin
                Result := True;
                Exit;
              end;
            end;
          end;
          // Word 2013
          if RegKeyExists(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\15.0\Word\InstallRoot') then
          begin
            if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\15.0\Word\InstallRoot', 'Path', path) then
            begin
              if Pos('(x86)', path) = 0 then
              begin
                Result := True;
                Exit;
              end;
            end;
          end;
          // PowerPoint 2013
          if RegKeyExists(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\15.0\PowerPoint\InstallRoot') then
          begin
            if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\15.0\PowerPoint\InstallRoot', 'Path', path) then
            begin
              if Pos('(x86)', path) = 0 then
              begin
                Result := True;
                Exit;
              end;
            end;
          end;
        end;
      end;
   end;    
end;

function GetNumber(var temp: String): Integer;
var
  part: String;
  pos1: Integer;
begin
  if Length(temp) = 0 then
  begin
    Result := -1;
    Exit;
  end;
    pos1 := Pos('.', temp);
    if (pos1 = 0) then
    begin
      Result := StrToInt(temp);
    temp := '';
    end
    else
    begin
    part := Copy(temp, 1, pos1 - 1);
      temp := Copy(temp, pos1 + 1, Length(temp));
      Result := StrToInt(part);
    end;
end;
 
function CompareInner(var temp1, temp2: String): Integer;
var
  num1, num2: Integer;
begin
    num1 := GetNumber(temp1);
  num2 := GetNumber(temp2);
  if (num1 = -1) or (num2 = -1) then
  begin
    Result := 0;
    Exit;
  end;
      if (num1 > num2) then
      begin
        Result := 1;
      end
      else if (num1 < num2) then
      begin
        Result := -1;
      end
      else
      begin
        Result := CompareInner(temp1, temp2);
      end;
end;
 
function CompareVersion(str1, str2: String): Integer;
var
  temp1, temp2: String;
begin
    temp1 := str1;
    temp2 := str2;
    Result := CompareInner(temp1, temp2);
end;

function InitializeSetup(): Boolean;
var
  oldVersion: String;
  uninstaller: String;
  ErrorCode: Integer;
  newVersion: String;
begin
  ExtractTemporaryFile('Office2007.cjstyles');
  LoadSkin(ExpandConstant('{tmp}\Office2007.cjstyles'), '');
  newVersion := '{#SetupSetting("AppVersion")}'; 
  if RegKeyExists(HKEY_LOCAL_MACHINE,
    'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#AppName}_is1') then
  begin
    RegQueryStringValue(HKEY_LOCAL_MACHINE,
      'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#AppName}_is1',
      'DisplayVersion', oldVersion);
    if (CompareVersion(oldVersion, newVersion) < 0) then
    begin
      if MsgBox('Version ' + oldVersion + ' of SpeediDocs is already installed. Continue to use this version?',
        mbConfirmation, MB_YESNO) = IDYES then
      begin
        Result := False;
      end
      else
      begin
          RegQueryStringValue(HKEY_LOCAL_MACHINE,
            'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#AppName}_is1',
            'UninstallString', uninstaller);
          ShellExec('runas', uninstaller, '/SILENT', '', SW_HIDE, ewWaitUntilTerminated, ErrorCode);
          Result := True;
      end;
    end
    else
    begin
      MsgBox('Version ' + oldVersion + ' of SpeediDocs is already installed. Please uninstall and then retry installation. The installer will now exit.',
        mbInformation, MB_OK);
      Result := False;
    end;
  end
  else
  begin
    Result := True;
  end;
end;

procedure DeinitializeSetup();
begin
  // Hide Window before unloading skin so user does not get
  // a glimpse of an unskinned window before it is closed.
  ShowWindow(StrToInt(ExpandConstant('{wizardhwnd}')), 0);
  UnloadSkin();
end;

function GetOutlookVersionNumberAsString(): String;
(*
    Search Registry for installed Outlook version. From highests version down.
*)
begin
    if RegValueExists(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\16.0\Outlook', 'Bitness') then begin
        Result := '16.0';
    end else if RegValueExists(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\15.0\Outlook', 'Bitness') then begin
        Result := '15.0';
    end else if RegValueExists(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\14.0\Outlook', 'Bitness') then begin
        Result := '14.0';
    end else if RegValueExists(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\12.0\Outlook', 'Bitness') then begin
        Result := '12.0';
    end else if RegValueExists(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\11.0\Outlook', 'Bitness') then begin
        Result := '11.0';
    end else if RegValueExists(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\10.0\Outlook', 'Bitness') then begin
        Result := '10.0';
    end else if RegValueExists(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\9.0\Outlook', 'Bitness') then begin
        Result := '9.0';
    end else begin
        Result := '0.0';
    end;
end;

(*
    Importing a Windows API function for understanding if OUTLOOK.EXE is a 32-bit
    or 64-bit application. This function has a few named constants. There appears
    to be no other accurate option than looking at the exe's PE header.
*)
const
    SCS_32BIT_BINARY = 0;   // A 32-bit Windows-based application
    SCS_64BIT_BINARY = 6;   // A 64-bit Windows-based application
    SCS_DOS_BINARY   = 1;   // An MS-DOS – based application
    SCS_OS216_BINARY = 5;   // A 16-bit OS/2-based application
    SCS_PIF_BINARY   = 3;   // A PIF file that executes an MS-DOS – based application
    SCS_POSIX_BINARY = 4;   // A POSIX – based application
    SCS_WOW_BINARY   = 2;   // A 16-bit Windows-based application
 
function GetBinaryType(lpApplicationName: AnsiString; var lpBinaryType: Integer): Boolean;
    external 'GetBinaryTypeA@kernel32.dll stdcall';
 
function IsOutlook64bit(): Boolean;
(*
    64-bit versions of Office use the standard node of the Registry named
    'Software\Microsoft\' which is the same for 32-bit Outlook on 32-bit Windows.
    The node named 'Software\Wow6432Node\Microsoft\' is only used for 32-bit
    Outlook installed on 64-bit Windows so we can avoid checking.
 
    Makes sure you have these [Setup] directives correctly set otherwise it may
    not read from the correct branch in the Registry on 64-bit systems:
        ArchitecturesAllowed=x86 x64
        ArchitecturesInstallIn64BitMode=x64
*)
var
    InstallRoot: String;
    BinaryType: Integer;
begin
    Result := false;
 
    // Look for the InstallRoot of Outlook. This is where Outlook is installed.
    //
    if not RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Office\' + GetOutlookVersionNumberAsString + '\Outlook\InstallRoot', 'Path', InstallRoot) then exit;
 
    // Look what binary type 'Outlook.EXE' is.
    //
    if GetBinaryType(AddBackslash(InstallRoot) + 'Outlook.exe', BinaryType) then begin
        Result := (BinaryType = SCS_64BIT_BINARY);
    end;
end;

function BuildOutlookResiliencyKey(): string;
var
  s: string;
begin
  s := GetOutlookVersionNumberAsString;
  Result := Format('SOFTWARE\Microsoft\Office\%s\Outlook\Resiliency\DoNotDisableAddinList',[s]);
end;    
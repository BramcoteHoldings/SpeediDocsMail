unit SpeediDocsMail_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// $Rev: 52393 $
// File generated on 21/03/2019 7:33:48 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\Insight_XE4_Source\SpeediDocsMail\SpeediDocsMail (1)
// LIBID: {C8C7A0FC-32A3-40B4-AB53-289B7AE28864}
// LCID: 0
// Helpfile:
// HelpString: SpeediDocsMail Library
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  SpeediDocsMailMajorVersion = 1;
  SpeediDocsMailMinorVersion = 0;

  LIBID_SpeediDocsMail: TGUID = '{C8C7A0FC-32A3-40B4-AB53-289B7AE28864}';

  IID_IInsight_Addin_for_Outlook: TGUID = '{4FAE58C5-E729-47F4-8F31-F426AD41CD75}';
  CLASS_Insight_Addin_for_Outlook: TGUID = '{4A9F8918-8DDA-4D30-A76F-788938C46B95}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IInsight_Addin_for_Outlook = interface;
  IInsight_Addin_for_OutlookDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  Insight_Addin_for_Outlook = IInsight_Addin_for_Outlook;


// *********************************************************************//
// Interface: IInsight_Addin_for_Outlook
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4FAE58C5-E729-47F4-8F31-F426AD41CD75}
// *********************************************************************//
  IInsight_Addin_for_Outlook = interface(IDispatch)
    ['{4FAE58C5-E729-47F4-8F31-F426AD41CD75}']
  end;

// *********************************************************************//
// DispIntf:  IInsight_Addin_for_OutlookDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4FAE58C5-E729-47F4-8F31-F426AD41CD75}
// *********************************************************************//
  IInsight_Addin_for_OutlookDisp = dispinterface
    ['{4FAE58C5-E729-47F4-8F31-F426AD41CD75}']
  end;

// *********************************************************************//
// The Class CoInsight_Addin_for_Outlook provides a Create and CreateRemote method to
// create instances of the default interface IInsight_Addin_for_Outlook exposed by
// the CoClass Insight_Addin_for_Outlook. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoInsight_Addin_for_Outlook = class
    class function Create: IInsight_Addin_for_Outlook;
    class function CreateRemote(const MachineName: string): IInsight_Addin_for_Outlook;
  end;

implementation

uses System.Win.ComObj;

class function CoInsight_Addin_for_Outlook.Create: IInsight_Addin_for_Outlook;
begin
  Result := CreateComObject(CLASS_Insight_Addin_for_Outlook) as IInsight_Addin_for_Outlook;
end;

class function CoInsight_Addin_for_Outlook.CreateRemote(const MachineName: string): IInsight_Addin_for_Outlook;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Insight_Addin_for_Outlook) as IInsight_Addin_for_Outlook;
end;

end.


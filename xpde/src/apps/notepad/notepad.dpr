program notepad;

uses
  QForms,
  uXPStyle,
  main in 'main.pas' {frmMain},
  uAboutDlg,
  uOpenWith,
  uXPAPI_imp;

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(Application);  //conflicts with TActionList
  Application.Title := 'XPde Notepad';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

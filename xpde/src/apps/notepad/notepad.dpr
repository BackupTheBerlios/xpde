program notepad;

uses
  QForms,
  uXPStyle,
  main in 'main.pas' {frmMain},
  uAboutDlg,
  uOpenWith,
  uXPAPI_imp,
  gt in 'gt.pas' {frmGoTo};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(Application);
  Application.Title := 'XPde Notepad';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmGoTo, frmGoTo);
  Application.Run;
  Application.Style
end.

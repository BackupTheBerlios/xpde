program calculator;

uses
  QForms,
  uXPStyle,
  main in 'main.pas' {MainForm},
  FastStrings in 'FastStrings.pas',
  uAboutDlg in '../../core/xpde/uAboutDlg.pas' {AboutDlg},
  uOpenWith in '../../core/xpde/uOpenWith.pas' {OpenWithDlg},
  uXPAPI_imp in '../../core/xpde/uXPAPI_imp.pas';

{$R *.res}

begin
  Application.Initialize;
  setXPstyle(application);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutDlg, AboutDlg);
  Application.CreateForm(TOpenWithDlg, OpenWithDlg);
  Application.Run;
end.

program XPwm;

uses
  QForms,
  uXPStyle,
  uSpecial in 'uSpecial.pas',
  uTaskBar in 'uTaskBar.pas' {TaskBar},
  uRun in 'uRun.pas' {RunDlg},
  uOpenWith in '../xpde/uOpenWith.pas' {OpenWithDlg},
  uXPAPI_imp in '../xpde/uXPAPI_imp.pas';

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TTaskBar, TaskBar);
  Application.CreateForm(TRunDlg, RunDlg);
  Application.CreateForm(TOpenWithDlg, OpenWithDlg);
  Application.Run;
end.

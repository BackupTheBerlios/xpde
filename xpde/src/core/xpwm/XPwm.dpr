program XPwm;

uses
  QForms,
  uXPStyle,
  uTaskBar in 'uTaskBar.pas' {TaskBar},
  uWMConsts in 'uWMConsts.pas',
  uWMFrame in 'uWMFrame.pas' {WindowsClassic},
  uWindowManager in 'uWindowManager.pas',
  uOpenWith in '../xpde/uOpenWith.pas' {OpenWithDlg},
  uXPAPI_imp in '../xpde/uXPAPI_imp.pas';

{$R *.res}

begin
  Application.Initialize;
  setXPStyle(application);
  XPwindowmanager.install;
  Application.CreateForm(TTaskBar, TaskBar);
  Application.Run;
end.

program appexec;

uses
  QForms,
  uXPStyle,
  uRun in 'uRun.pas' {RunDlg},
  uXPAPI_imp in '../../core/xpde/uXPAPI_imp.pas',
  uOpenWith in '../../core/xpde/uOpenWith.pas' {OpenWithDlg};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TRunDlg, RunDlg);
  Application.Run;
end.

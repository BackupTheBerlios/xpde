program controlpanel;

uses
  QForms,
  uXPStyle,
  uControlPanel in 'uControlPanel.pas' {ControlFanelFrm},
  uXPAPI_imp in '../../core/xpde/uXPAPI_imp.pas',
  uOpenWith in '../../core/xpde/uOpenWith.pas' {OpenWithDlg};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TControlFanelFrm, ControlFanelFrm);
  Application.CreateForm(TOpenWithDlg, OpenWithDlg);
  Application.Run;
end.

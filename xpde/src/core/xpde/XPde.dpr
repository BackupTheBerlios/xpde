program XPde;

uses
  QForms,
  uXPStyle,
  uDesktopMain in 'uDesktopMain.pas' {MainForm},
  uChangeIcon in 'uChangeIcon.pas' {ChangeIconDlg},
  uCreateShortcut in 'uCreateShortcut.pas' {CreateShortcutDlg},
  uLNKProperties in 'uLNKProperties.pas' {LNKPropertiesDlg},
  uOpenWith in 'uOpenWith.pas' {OpenWithDlg},
  uXPAPI_imp in 'uXPAPI_imp.pas';

{$R *.res}

begin
  Application.Initialize;
  setXPStyle(application);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TOpenWithDlg, OpenWithDlg);
  Application.Run;
end.

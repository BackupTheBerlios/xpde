program XPde;

uses
  QForms,
  uXPStyle,
  main in 'main.pas' {MainForm},
  uCreateShortcut in 'uCreateShortcut.pas' {CreateShortcutDlg},
  uLNKProperties in 'uLNKProperties.pas' {LNKPropertiesDlg},
  uChangeIcon in 'uChangeIcon.pas' {ChangeIconDlg},
  uOpenWith in 'uOpenWith.pas' {OpenWithDlg},
  uXPAPI_imp in 'uXPAPI_imp.pas';

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);  
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TOpenWithDlg, OpenWithDlg);
  Application.Run;
end.

program XPdesetup;

uses
  QForms,
  uXPStyle,
  main in 'main.pas' {BackForm},
  uPersonalizeDlg in 'uPersonalizeDlg.pas' {PersonalizeDlg},
  uStartInstallation in 'uStartInstallation.pas' {StartInstallationDlg};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TBackForm, BackForm);
  Application.Run;
end.

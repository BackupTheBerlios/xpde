program XPdesetup;

uses
  QForms,
  uXPStyle,
  main in 'main.pas' {BackForm},
  uPersonalizeDlg in 'uPersonalizeDlg.pas' {PersonalizeDlg};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TBackForm, BackForm);
  Application.CreateForm(TPersonalizeDlg, PersonalizeDlg);
  Application.Run;
end.

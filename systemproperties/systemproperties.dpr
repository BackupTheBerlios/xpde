program systemproperties;

uses
  QForms,
  uXPStyle,
  uSystemProperties in 'uSystemProperties.pas' {SystemPropertiesDlg};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TSystemPropertiesDlg, SystemPropertiesDlg);
  Application.Run;
end.

program systemproperties;

uses
  QForms,
  uXPStyle,
  uSystemProperties in 'uSystemProperties.pas' {SystemPropertiesDlg},
  uDeviceManager in 'uDeviceManager.pas' {frmSystem},
  uHWProperties in 'uHWProperties.pas' {frmProp};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);  
  Application.CreateForm(TSystemPropertiesDlg, SystemPropertiesDlg);
  Application.Run;
end.

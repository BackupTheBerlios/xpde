program systemproperties;

uses
  QForms,
  uXPStyle,
  uSystemProperties in 'uSystemProperties.pas' {SystemPropertiesDlg},
  uDeviceManager in 'uDeviceManager.pas' {frmSystem},
  uHWProperties in 'uHWProperties.pas' {frmProp},
  uTest in 'uTest.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);  
  Application.CreateForm(TSystemPropertiesDlg, SystemPropertiesDlg);
  Application.Run;
end.

program systemproperties;

uses
  QForms,
  uXPStyle,
  uSystemProperties in 'uSystemProperties.pas' {SystemPropertiesDlg},
  uDeviceManager in 'uDeviceManager.pas' {frmSystem},
  uHWProperties in 'uHWProperties.pas' {frmProp},
  SysProvider in '../sysprovider/SysProvider.pas';

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TSystemPropertiesDlg, SystemPropertiesDlg);
//Zeljan:If the TSystemPropertiesDlg form is the main one, the menu of the TfrmSystem is not drawn correctly
//Reason: Don't know yet????  
//  Application.CreateForm(TfrmSystem, frmSystem);
  Application.Run;
end.

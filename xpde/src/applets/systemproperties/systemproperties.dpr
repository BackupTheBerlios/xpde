program systemproperties;

uses
  QForms,
  uXPStyle,
  uSystemProperties in 'uSystemProperties.pas' {SystemPropertiesDlg},
  uDeviceManager in 'uDeviceManager.pas' {frmSystem},
  uHWProperties in 'uHWProperties.pas' {frmProp},
  uXPImageList in '../xpde/src/components/xpimagelist/uXPImageList.pas',
  uXPListview in '../xpde/src/components/xplistview/uXPListview.pas',
  SysProvider in '../sysprovider/SysProvider.pas';

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TSystemPropertiesDlg, SystemPropertiesDlg);
  Application.Run;
end.

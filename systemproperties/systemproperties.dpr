program systemproperties;

uses
  QForms,
  uXPStyle,
  uSystemProperties in 'uSystemProperties.pas' {SystemPropertiesDlg},
  uDeviceManager in 'uDeviceManager.pas' {frmSystem},
  uHWProperties in 'uHWProperties.pas' {frmProp},
  uXPImageList in '../../components/xpimagelist/uXPImageList.pas',
  uXPListview in '../../components/xplistview/uXPListview.pas',
  uXPAPI in '../../components/toolsapi/uXPAPI.pas';

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TSystemPropertiesDlg, SystemPropertiesDlg);
  Application.Run;
end.

program systemproperties;

uses
  QForms,
  uXPStyle,
  uSystemProperties in 'uSystemProperties.pas' {SystemPropertiesDlg},
  uDeviceManager in 'uDeviceManager.pas' {frmSystem},
  uXPListview in '../../components/xplistview/uXPListview.pas',
  uXPImageList in '../../components/xpimagelist/uXPImageList.pas';

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TSystemPropertiesDlg, SystemPropertiesDlg);
  Application.Run;
end.

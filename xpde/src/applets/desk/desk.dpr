program desk;

uses
  QForms,
  uXPStyle,
  uDisplayProperties in 'uDisplayProperties.pas' {DisplayPropertiesDlg},
  uOpenWith in '../../core/xpde/uOpenWith.pas' {OpenWithDlg},
  uXPAPI_imp in '../../core/xpde/uXPAPI_imp.pas';

{$E .cpl}

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Display Properties';
  SetXPStyle(application);
  Application.CreateForm(TDisplayPropertiesDlg, DisplayPropertiesDlg);
  Application.CreateForm(TOpenWithDlg, OpenWithDlg);
  Application.Run;
end.

program desk;

uses
  QForms,
  uXPStyle,
  uDisplayProperties in 'uDisplayProperties.pas' {DisplayPropertiesDlg},
  uXPAPI_imp in '../../core/xpde/uXPAPI_imp.pas',
  uOpenWith in '../../core/xpde/uOpenWith.pas' {OpenWithDlg};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TDisplayPropertiesDlg, DisplayPropertiesDlg);
  Application.Run;
end.

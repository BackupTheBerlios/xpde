program regional;

uses
  QForms,
  uXPStyle,
  uRegionalandLanguageOptions in 'uRegionalandLanguageOptions.pas' {RegionalandLanguageOptionsDlg};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TRegionalandLanguageOptionsDlg, RegionalandLanguageOptionsDlg);
  Application.Run;
end.

program keyboard;

uses
  QForms,
  uXPStyle,
  uKeyboardProperties in 'uKeyboardProperties.pas' {KeyboardPropertiesDlg};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TKeyboardPropertiesDlg, KeyboardPropertiesDlg);
  Application.Run;
end.

program mouse;

uses
  QForms,
  uXPStyle,
  uMouseProperties in 'uMouseProperties.pas' {MousePropertiesDlg};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TMousePropertiesDlg, MousePropertiesDlg);
  Application.Run;
end.

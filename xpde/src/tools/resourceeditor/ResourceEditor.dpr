program ResourceEditor;

uses
  QForms,
  uXPStyle,
  main in 'main.pas' {MainForm},
  uResources in 'uResources.pas',
  uResourceFileFrm in 'uResourceFileFrm.pas' {ResourceFileFrm},
  uResourceAPI in 'uResourceAPI.pas',
  uStringEditor in 'uStringEditor.pas' {StringEditor};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

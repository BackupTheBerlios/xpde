program ResourceEditor;

uses
  QForms,
  main in 'main.pas' {MainForm},
  uResources in 'uResources.pas',
  uResourceFileFrm in 'uResourceFileFrm.pas' {ResourceFileFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

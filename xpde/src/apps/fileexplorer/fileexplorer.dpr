program fileexplorer;

uses
  QForms,
  uXPStyle,
  uXPExplorer in 'uXPExplorer.pas',
  main in 'main.pas' {Form1},
  uExplorerAPI in 'uExplorerAPI.pas',
  uLocalFileSystem in 'uLocalFileSystem.pas';

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

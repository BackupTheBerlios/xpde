program fileexplorer;

uses
  QForms,
  uXPStyle,
  uXPExplorer in 'uXPExplorer.pas',
  main in 'main.pas' {ExplorerForm},
  uExplorerAPI in 'uExplorerAPI.pas',
  uLocalFileSystem in 'uLocalFileSystem.pas';

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  application.font.height:=12;
  application.font.name:='Helvetica';
  Application.CreateForm(TExplorerForm, ExplorerForm);
  Application.Run;
end.

program fileexplorer;

uses
  QForms,
  uXPStyle,
  uXPExplorer in 'uXPExplorer.pas',
  main in 'main.pas' {ExplorerForm},
  uExplorerAPI in 'uExplorerAPI.pas',
  uLocalFileSystem in 'uLocalFileSystem.pas',
  uOpenWith in '../../core/xpde/uOpenWith.pas' {OpenWithDlg},
  uXPAPI_imp in '../../core/xpde/uXPAPI_imp.pas',
  uXPAPI in '../../components/toolsapi/uXPAPI.pas';

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
//  application.font.height:=12;
//  application.font.name:='Helvetica';
  Application.CreateForm(TExplorerForm, ExplorerForm);
  Application.Run;
end.

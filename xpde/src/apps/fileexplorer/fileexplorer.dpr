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
  uXPAPI in '../../components/toolsapi/uXPAPI.pas',
  uProgressDlg in 'uProgressDlg.pas' {ProgressDlg};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TExplorerForm, ExplorerForm);
  Application.Run;
end.

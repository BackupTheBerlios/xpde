program fileexplorer;

uses
  QForms,
  uXPStyle,
  uXPExplorer in 'uXPExplorer.pas',
  main in 'main.pas' {ExplorerForm},
  uExplorerAPI in 'uExplorerAPI.pas',
  uXPAPI_imp in '../../core/xpde/uXPAPI_imp.pas',
  uLocalFileSystem in 'uLocalFileSystem.pas',
  uOpenWith in '../../core/xpde/uOpenWith.pas' {OpenWithDlg},
  uXPAPI in '../../components/toolsapi/uXPAPI.pas',
  uProgressDlg in 'uProgressDlg.pas' {ProgressDlg},
  uAboutDlg in '../../core/xpde/uAboutDlg.pas' {AboutDlg},
  uSmbClient in 'uSmbClient.pas',
  uSmbOption in 'uSmbOption.pas' {smbOption},
  uSelectUser in 'uSelectUser.pas' {dlgSelectUser};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TExplorerForm, ExplorerForm);
  Application.CreateForm(TsmbOption, smbOption);
  Application.CreateForm(TdlgSelectUser, dlgSelectUser);
  Application.Run;
end.

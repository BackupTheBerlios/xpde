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
  uSelectUser in 'uSelectUser.pas' {dlgSelectUser},
  uConfirmFileReplace in 'uConfirmFileReplace.pas' {ConfirmFileReplaceDlg},
  uConfirmFolderReplace in 'uConfirmFolderReplace.pas' {ConfirmFolderReplaceDlg},
  uSelUserGroup in '../../components/selectuser/uSelUserGroup.pas' {SelectUserGroup},
  uLocation in '../../components/selectuser/uLocation.pas' {LocationDlg},
  uObjectTypes in '../../components/selectuser/uObjectTypes.pas' {ObjTypesDlg},
  uResString in '../../components/selectuser/uResString.pas',
  uXPuserUtils in '../../components/userlib/uXPuserUtils.pas',
  uExplorerUtil in 'uExplorerUtil.pas',
  uPropeties in 'uPropeties.pas' {PropetiesDlg},
  uSecurityAdv in 'uSecurityAdv.pas' {SecurityDlg};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TExplorerForm, ExplorerForm);
  Application.CreateForm(TsmbOption, smbOption);
  Application.CreateForm(TdlgSelectUser, dlgSelectUser);
  Application.Run;
end.

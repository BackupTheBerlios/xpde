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
  uConfirmFileReplace in 'uConfirmFileReplace.pas' {ConfirmFileReplaceDlg},
  uConfirmFolderReplace in 'uConfirmFolderReplace.pas' {ConfirmFolderReplaceDlg},
  uXPuserUtils in '../../components/userlib/uXPuserUtils.pas',
  uExplorerUtil in 'uExplorerUtil.pas',
  uPropeties in 'uPropeties.pas' {PropetiesDlg},
  uSecurityAdv in 'uSecurityAdv.pas' {SecurityDlg},
  uGroupAndUser in '../../components/selectuser/uGroupAndUser.pas' {SelUserGroup},
  uSelectObj in '../../components/selectuser/uSelectObj.pas' {ObjTypes},
  uGroupUserResourse in '../../components/selectuser/uGroupUserResourse.pas',
  uLocationObj in '../../components/selectuser/uLocationObj.pas' {LocationObj},
  uSelectUser in '../../components/userlib/uSelectUser.pas' {dlgSelectUserDlg};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TExplorerForm, ExplorerForm);
  Application.CreateForm(TsmbOption, smbOption);
  Application.Run;
end.

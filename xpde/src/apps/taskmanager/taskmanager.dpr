program taskmanager;

uses
  QForms,
  uXPStyle,
  uTaskManager in 'uTaskManager.pas' {WindowsTaskManagerDlg},
  uAboutTaskManager in 'uAboutTaskManager.pas' {AboutTaskManagerDlg},
  uCreateNewTask in 'uCreateNewTask.pas' {CreateNewTaskDlg},
  uAboutDlg in '../../core/xpde/uAboutDlg.pas' {AboutDlg},
  uOpenWith in '../../core/xpde/uOpenWith.pas' {OpenWithDlg},
  uXPAPI_imp in '../../core/xpde/uXPAPI_imp.pas';

{$R *.res}
begin
  tm_version:='0.31';
  tm_build:='20030211'; // BUILD FORMAT -> YYYYMMDD
  Application.Initialize;
  SetXPStyle(application);  
  Application.CreateForm(TWindowsTaskManagerDlg, WindowsTaskManagerDlg);
  Application.CreateForm(TAboutDlg, AboutDlg);
  Application.CreateForm(TOpenWithDlg, OpenWithDlg);
  Application.Run;
end.

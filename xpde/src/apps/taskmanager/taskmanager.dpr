program taskmanager;

uses
  QForms,
  uXPStyle,
  uTaskManager in 'uTaskManager.pas' {WindowsTaskManagerDlg},
  uAboutTaskManager in 'uAboutTaskManager.pas' {AboutTaskManagerDlg},
  uCreateNewTask in 'uCreateNewTask.pas' {CreateNewTaskDlg};

{$R *.res}
begin
  tm_version:='0.31';
  tm_build:='20030211'; // BUILD FORMAT -> YYYYMMDD
  Application.Initialize;
  SetXPStyle(application);  
  Application.CreateForm(TWindowsTaskManagerDlg, WindowsTaskManagerDlg);
  Application.Run;
end.

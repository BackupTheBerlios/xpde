program taskmanager;

uses
  QForms,
  uXPStyle,
  uTaskManager in 'uTaskManager.pas' {WindowsTaskManagerDlg};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);  
  Application.CreateForm(TWindowsTaskManagerDlg, WindowsTaskManagerDlg);
  Application.Run;
end.

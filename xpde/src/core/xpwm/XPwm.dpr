program XPwm;

uses
  QForms,
  XLib,
  SysUtils,
  uXPStyle,
  uTaskBar in 'uTaskBar.pas' {TaskBar},
  uWMConsts in 'uWMConsts.pas',
  uWMFrame in 'uWMFrame.pas' {WindowsClassic},
  uWindowManager in 'uWindowManager.pas',
  uOpenWith in '../xpde/uOpenWith.pas' {OpenWithDlg},
  uXPAPI_imp in '../xpde/uXPAPI_imp.pas',
  uTurnOff in 'uTurnOff.pas' {Turnoff};

{$R *.res}
{
var
    event: XEvent;

procedure DoneApplication;
begin
  with Application do
  begin
//    FreeAndNil(FIdleTimer);
    ShowHint := False;
    Destroying;
    DestroyComponents;
  end;
end;
}


begin
  Application.Initialize;
  setXPStyle(application);
  XPwindowmanager.install;
  Application.CreateForm(TTaskBar, TaskBar);
  Application.CreateForm(TTurnoff, Turnoff);

  {
  AddExitProc(DoneApplication);
  application.MainForm.Show;

  while not application.Terminated do begin
     if XPending(application.display)=1 then begin
        XPeekEvent(application.display,@event);
        eventhandler(@event);
     end;
     application.HandleMessage;
  end;
  }
  Application.Run;
  
end.

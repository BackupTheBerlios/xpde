program XPshell;

uses
  QForms,
  QControls,
  QDialogs,
  uXPAPI,
  SysUtils,
  uXPStyle;

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  //Loads the desktop
  loadpackage(extractfilepath(application.exename)+'bplXPde.so');

  //Loads the windowmanager
  loadpackage(extractfilepath(application.exename)+'bplXPwm.so');


  if assigned(XPWindowManager) then begin
    XPWindowManager.setup;
  end
  else begin
    showmessage('Window Manager not found!');
  end;
  
  Application.Run;
end.

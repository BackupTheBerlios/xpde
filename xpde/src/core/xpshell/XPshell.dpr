program XPshell;

uses
  QForms,
  QControls,
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
  Application.Run;
end.

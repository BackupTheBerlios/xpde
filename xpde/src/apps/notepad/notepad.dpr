program notepad;

uses
  QForms,
  uXPStyle,
  main in 'main.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.Title := 'Notepad';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

program traydemo;

uses
  QForms,
  uXPStyle,
  main in 'main.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

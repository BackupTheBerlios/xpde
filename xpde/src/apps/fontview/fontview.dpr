program fontview;

uses
  QForms,
  uXPStyle,
  SysUtils,
  ufontview in 'ufontview.pas' {MainForm};

{$R *.res}

begin
if ParamCount > 0 then
 begin
 if FileExists(ParamStr(1)) then
  begin
   Application.Initialize;
   SetXPStyle(application);
   Application.CreateForm(TMainForm, MainForm);
  Application.Run;
  end;
 end;
end.

program newuser;

uses
  QForms,
  uXPStyle,
  xpnewuser in 'xpnewuser.pas' {New_User},
  uUserPropeties in 'uUserPropeties.pas' {Properties};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TNew_User, New_User);
  Application.CreateForm(TProperties, Properties);
  Application.Run;
end.

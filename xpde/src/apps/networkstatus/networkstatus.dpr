program networkstatus;

uses
  SysUtils,
  QForms,
  uXPStyle,
  uConnectionStatus in 'uConnectionStatus.pas' {ConnectionStatusDlg},
  uNetworkConnectionDetails in 'uNetworkConnectionDetails.pas' {NetworkConnectionDetailsDlg},
  hwinfo in '../../common/hwinfo.pas',
  xpclasses in '../../common/xpclasses.pas';

{$R *.res}
var ipar,lista__:integer;
begin
  Application.Initialize;
  
  Read_Net('/proc/net/dev');
  device_number:=-1;

  for ipar:=1 to paramcount do begin

  if (LowerCase(Paramstr(ipar)) = 'l') or
  (LowerCase(Paramstr(ipar)) = '-l') then begin

  for lista__:=0 to 20 do begin
  if net_info[lista__].device<>'' then
  writeln('Interface : ',net_info[lista__].device);
  End;
  halt(0);
  End;

  if ((LowerCase(Paramstr(ipar)) = 'i') or
  (LowerCase(Paramstr(ipar)) = '-i')) // interface
  and (length(ParamStr(ipar+1))<>0) then begin
  for lista__:=0 to 20 do begin
  if net_info[lista__].device=Paramstr(ipar+1) then
  device_number:=lista__;
  End;
  End;
  End;

  if device_number=-1 then begin
  writeln('Device doesn''t exist.');
  writeln('You must start program with -i <devicename> ');
  writeln('For available devices list start program with -l switch.');
  halt(0);
  End;

  Fill_Net_Devices(net_info[device_number].device);
  Get_Info_From_Netstat(net_info[device_number].device);

  SetXPStyle(application);
  Application.CreateForm(TConnectionStatusDlg, ConnectionStatusDlg);
  Application.Run;
end.

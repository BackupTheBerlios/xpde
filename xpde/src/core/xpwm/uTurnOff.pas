unit uTurnOff;

interface

uses
  Libc, SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QExtCtrls;

type
  TTurnoff = class(TForm)
    btnCancel: TButton;
    turnoff_off: TImage;
    turnoff_on: TImage;
    turnoff: TImage;
    restart: TImage;
    restart_off: TImage;
    restart_on: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure turnoffMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure restartMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure restartClick(Sender: TObject);
    procedure turnoffClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    overoff: boolean;
    overrestart: boolean;    
  end;

var
  Turnoff: TTurnoff;

implementation

{$R *.xfm}

procedure TTurnoff.turnoffMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    if not overoff then begin
        turnoff.Picture.Assign(turnoff_on.picture);
        overoff:=true;
    end;
end;

procedure TTurnoff.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    if overoff then begin
        turnoff.Picture.Assign(turnoff_off.picture);
        overoff:=false;
    end;
    if overrestart then begin
        restart.Picture.Assign(restart_off.picture);
        overrestart:=false;
    end;
end;

procedure TTurnoff.restartMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    if not overrestart then begin
        restart.Picture.Assign(restart_on.picture);
        overrestart:=true;
    end;
end;

procedure TTurnoff.restartClick(Sender: TObject);
begin
	if Libc.system('reboot')<>-1 then
        Libc.system('shutdown -t3 -r now');
end;

procedure TTurnoff.turnoffClick(Sender: TObject);
begin
        if Libc.system('poweroff')<>-1 then
        Libc.system('shutdown -t3 -h now');
end;

procedure TTurnoff.FormCreate(Sender: TObject);
begin
    overoff:=false;
    overrestart:=false;    
end;

end.

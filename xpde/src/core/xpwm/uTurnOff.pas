unit uTurnOff;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
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
    over: boolean;
  end;

var
  Turnoff: TTurnoff;

implementation

{$R *.xfm}

procedure TTurnoff.turnoffMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    if not over then begin
        turnoff.Picture.Assign(turnoff_on.picture);
        over:=true;
    end;
end;

procedure TTurnoff.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    turnoff.Picture.Assign(turnoff_off.picture);
    restart.Picture.Assign(restart_off.picture);
    over:=false;
end;

procedure TTurnoff.restartMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    if not over then begin
        restart.Picture.Assign(restart_on.picture);
        over:=true;
    end;
end;

procedure TTurnoff.restartClick(Sender: TObject);
begin
    showmessage('Restart');
end;

procedure TTurnoff.turnoffClick(Sender: TObject);
begin
    showmessage('turn off');
end;

procedure TTurnoff.FormCreate(Sender: TObject);
begin
    over:=false;
end;

end.

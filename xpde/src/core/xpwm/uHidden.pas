unit uHidden;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls;

type
  THidden = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Hidden: THidden;

implementation

{$R *.xfm}

procedure THidden.FormCreate(Sender: TObject);
begin
    width:=0;
    height:=0;
    left:=-100;
    top:=-100;
end;

end.

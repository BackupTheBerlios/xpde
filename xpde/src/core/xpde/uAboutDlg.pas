unit uAboutDlg;

interface

uses
  SysUtils, Types, Classes,
  Variants, QTypes, QGraphics,
  QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, Libc;

type
  TAboutDlg = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lbFree: TLabel;
    Bevel1: TBevel;
    Button1: TButton;
    Image2: TImage;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutDlg: TAboutDlg;

implementation

{$R *.xfm}

procedure TAboutDlg.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if key=#27 then modalresult:=mrCancel;
end;

procedure TAboutDlg.FormShow(Sender: TObject);
var
    sinf:_sysinfo;
    freem: integer;
begin
    Libc.Sysinfo(sinf);
    freem:=sinf.freeram+sinf.bufferram;

    lbFree.Caption:= IntTostr(longint(freem) div 1024)+' Kb';
end;

end.

unit main;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, uTrayIcon, QImgList, QMenus;

type
  TForm1 = class(TForm)
    XPTrayIcon1: TXPTrayIcon;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    Open1: TMenuItem;
    About1: TMenuItem;
    Close1: TMenuItem;
    Changeimage1: TMenuItem;
    procedure Open1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure XPTrayIcon1DblClick(Sender: TObject);
    procedure Changeimage1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.xfm}

procedure TForm1.Open1Click(Sender: TObject);
begin
    showmessage('open');
end;

procedure TForm1.About1Click(Sender: TObject);
begin
    showmessage('about');
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
    close;
end;

procedure TForm1.XPTrayIcon1DblClick(Sender: TObject);
begin
    showmessage('default action');
end;

procedure TForm1.Changeimage1Click(Sender: TObject);
begin
    if XPTrayIcon1.Imageindex=0 then XPTrayIcon1.Imageindex:=1
    else XPTrayIcon1.Imageindex:=0;
end;

end.

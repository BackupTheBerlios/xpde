unit uActiveTasks;

interface

uses
  SysUtils, Types, Classes,XLib,
  Variants, QTypes, QGraphics, Qt,
  QControls, QForms, uXPStyleConsts,
  QDialogs, QStdCtrls, QExtCtrls;

type
  TActiveTasksDlg = class(TForm)
    Label1: TLabel;
    Timer1: TTimer;
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    activetask: integer;
    function getDottedText(const text: string; maxwidth: integer): string;
  public
    { Public declarations }
    procedure incActiveTask;
  end;

var
  ActiveTasksDlg: TActiveTasksDlg=nil;

implementation

uses uWindowManager;

{$R *.xfm}

procedure TActiveTasksDlg.FormPaint(Sender: TObject);
var
    x,y: integer;
    w: integer;
    c: integer;
    cli: TWMClient;
    b: TBitmap;
    nc: integer;
    ox: integer;
begin
    y:=19;
    nc:=xpwindowmanager.clients.count;
    if (nc>7) then nc:=7;

    w:=nc*43;
    ox:=(width-w) div 2;

    x:=ox;

    canvas.pen.width:=1;
    R3D(canvas,clientrect);
    R3D(canvas,rect(14,height-35,315,height-10),false,false,true);

    c:=0;
    canvas.pen.color:=dclHighlight;
    canvas.pen.width:=2;
    while (c<xpwindowmanager.clients.count) do begin
        cli:=xpwindowmanager.clients[c];
        if c=activetask then begin
            canvas.rectangle(rect(x,y,x+43,y+43));
        end;

        b:=cli.geticon;
        b.transparent:=true;
        canvas.draw(x+5,y+5,b);

        x:=x+43;

        if ((c+1) mod 7)=0 then begin
            x:=ox;
            y:=y+43;
        end;
        inc(c);
    end;
end;

procedure TActiveTasksDlg.FormShow(Sender: TObject);
var
    rows: integer;
begin
    width:=330;
    height:=107;
    rows:=((xpwindowmanager.clients.count-1) div 7)+1;
    height:=height+(43*(rows-1));
    activetask:=0;
    incActiveTask;
    left:=(screen.Width-width) div 2;
    top:=((screen.height-height) div 2)-107;
end;

procedure TActiveTasksDlg.Timer1Timer(Sender: TObject);
var
    keymap: TXQueryKeymap;
    i: integer;
    c: TWMClient;
begin
    //This is shit!
    xquerykeymap(qtdisplay,keymap);

    if keymap[8]=#0 then begin
        timer1.enabled:=false;
        c:=xpwindowmanager.clients[activetask];
        if assigned(c) then begin
            c.activate;
            activetasksdlg:=nil;
            close;
        end;
    end;
end;

procedure TActiveTasksDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    action:=caFree;
end;

function TActiveTasksDlg.getDottedText(const text:string;maxwidth:integer):string;
var
    w: integer;
    wc: widestring;
    k: integer;
begin
    wc:=text;

    k:=1;
    canvas.Font.assign(label1.font);
    w:=canvas.TextWidth(wc);

    while w>maxwidth do begin
        wc:=copy(text,1,length(text)-k)+'...';
        w:=canvas.TextWidth(wc);
        inc(k);
    end;

    result:=wc;
end;

procedure TActiveTasksDlg.incActiveTask;
var
    c: TWMClient;
begin
    inc(activetask);
    if activetask>=xpwindowmanager.clients.count then begin
        activetask:=0;
    end;

    invalidate;
    c:=xpwindowmanager.clients[activetask];
    label1.caption:=getdottedText(c.gettitle,label1.width);
end;

end.

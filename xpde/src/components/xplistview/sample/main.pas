unit main;

interface

uses
  SysUtils, Types, Classes,
  Variants, QTypes, QGraphics,
  QControls, QForms, QDialogs,  Qt,
  QStdCtrls, QComCtrls, uXPListview, QExtCtrls, uXPImageList, QButtons;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    HeaderControl1: THeaderControl;
    Panel2: TPanel;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  protected
    { Private declarations }
  public
    { Public declarations }
    function WidgetFlags: Integer; override;    
  end;

  TItem=class(TObject)
  public
    x,y:integer;
  end;

var
  Form1: TForm1;
  xp: TXPListview;
  xpimg: TXPImageList;
  smimg: TXPImageList;
  items: TList;

implementation

uses Math;

{$R *.xfm}

procedure TForm1.Button2Click(Sender: TObject);
var
    x,y: integer;
    p: TPanel;
begin

    for x:=0 to 75 do begin
        for y:=0 to 75 do begin
            p:=TPanel.create(self);
            p.left:=x*43;
            p.top:=y*43;
//            p.Parent:=ScrollBox1;
        end;
    end;
end;

function TForm1.WidgetFlags: Integer;
begin
    Result := Inherited WidgetFlags or Integer(WidgetFlags_WRepaintNoErase) or Integer(WidgetFlags_WResizeNoErase);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
    i: TXPListItem;
    k: integer;

    fileattrs:integer;
    sr: TSearchRec;
    hs: THeaderSection;
begin
(*
    xpimg:=TXPImageList.create(self);

    //Load the images
    Image1.Picture.LoadFromFile('/home/ttm/xpde/themes/default/32x32/system/folder2.png');
    xpimg.AddImage(Image1.Picture.Graphic);
    Image1.Picture.LoadFromFile('/home/ttm/xpde/themes/default/32x32/system/computer.png');
    xpimg.AddImage(Image1.Picture.Graphic);
    Image1.Picture.LoadFromFile('/home/ttm/xpde/themes/default/32x32/system/package_network.png');
    xpimg.AddImage(Image1.Picture.Graphic);
    Image1.Picture.LoadFromFile('/home/ttm/xpde/themes/default/32x32/system/trashcan_empty.png');
    xpimg.AddImage(Image1.Picture.Graphic);

    //Setup the listview
    xp:=TXPListview.create(self);
//    xp.color:=$984E00;
//    xp.font.color:=clWhite;

    xp.ImageList:=xpimg;
    xp.parent:=self;
    xp.Align:=alClient;
    xp.left:=100;
    xp.top:=100;
    xp.Width:=600;
    xp.Height:=400;

    //Setup the items
    for k:=1 to 30001 do begin
        i:=xp.Items.Add;
        i.ImageIndex:=RandomRange(0,4);
        case i.imageindex of
            0: i.caption:='My Documents';
            1: i.caption:='My Computer';
            2: i.caption:='My Network Places';
            3: i.caption:='Recycle Bin';
        end;
//        i.caption:=i.caption+'('+inttostr(k)+')';
    end;
*)
    xpimg:=TXPImageList.create(self);
    smimg:=TXPImageList.create(self);

    xp:=TXPListview.create(self);
//    xp.color:=$984E00;
//    xp.font.color:=clWhite;

    xp.ImageList:=xpimg;
    xp.SmallImageList:=smimg;
    hs:=xp.HeaderControl.Sections.Add;
    hs.Text:='Name';

    hs:=xp.HeaderControl.Sections.Add;
    hs.Text:='Size';

    hs:=xp.HeaderControl.Sections.Add;
    hs.Text:='Type';

    hs:=xp.HeaderControl.Sections.Add;
    hs.Text:='Date modified';

    xp.parent:=panel2;
    xp.Align:=alClient;
    xp.SendToBack;
    xp.left:=100;
    xp.top:=100;
    xp.Width:=600;
    xp.Height:=400;

    FileAttrs := FileAttrs + faArchive;
    FileAttrs := FileAttrs + faAnyFile;

    if FindFirst('/home/ttm/xpde/themes/default/32x32/system/*.png', FileAttrs, sr) = 0 then     begin
      repeat
        if (sr.Attr and FileAttrs) = sr.Attr then begin
            Image1.Picture.LoadFromFile('/home/ttm/xpde/themes/default/32x32/system/'+sr.name);
            i:=xp.Items.Add;
            i.imageindex:=xpimg.AddImage(Image1.Picture.Graphic);
            i.Subitems.Add(inttostr(sr.Size));
            i.Subitems.Add('PNG Graphic');
            i.Subitems.Add(timetostr(sr.time));
            i.caption:=sr.name;
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;

    //***************

    FileAttrs := FileAttrs + faArchive;
    FileAttrs := FileAttrs + faAnyFile;

    if FindFirst('/home/ttm/xpde/themes/default/16x16/system/*.png', FileAttrs, sr) = 0 then     begin
      repeat
        if (sr.Attr and FileAttrs) = sr.Attr then begin
            Image1.Picture.LoadFromFile('/home/ttm/xpde/themes/default/16x16/system/'+sr.name);
            smimg.AddImage(Image1.Picture.Graphic);
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
end;


procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
    xp.ViewStyle:=vsDetail;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
    xp.ViewStyle:=vsIcon;
end;

end.

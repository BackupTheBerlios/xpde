unit uXPPNG;

interface

uses Classes, QGraphics, uXPCommon,
     QDialogs, Types, Sysutils;

type
    TXPPNG=class(TGraphic)
    private
        FBackground: TBitmap;
        FAlphaMask: TBitmap;
        original: TBitmap;
        Fdone: boolean;
        FBackgroundColor: TColor;
        procedure createAlphaMask(original: TBitmap);
        procedure SetBackground(const Value: TBitmap);
        procedure SetBackgroundColor(const Value: TColor);

    protected
        function GetEmpty: Boolean; override;
        function GetHeight: Integer; override;
        function GetWidth: Integer; override;
        procedure SetHeight(Value: Integer); override;
        procedure SetWidth(Value: Integer); override;
    public
        procedure Assign(source:TPersistent);override;
        procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
        procedure LoadFromStream(Stream: TStream); override;
        procedure SaveToStream(Stream: TStream); override;

        procedure paintToCanvas(ACanvas:TCanvas; const x,y:integer);
        constructor Create;override;
        destructor Destroy;override;
        property Background:TBitmap read FBackground write SetBackground;
        property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor;
    end;

implementation

{ TXPPNG }

constructor TXPPNG.Create;
begin
  inherited;
  FBackgroundColor:=clBtnFace;
  Fdone:=false;
  original:=TBitmap.create;
  FAlphaMask:=TBitmap.create;
  FBackground:=TBitmap.create;
end;

destructor TXPPNG.Destroy;
begin
  original.free;
  FBackground.free;
  FAlphaMask.free;
  inherited;
end;

procedure TXPPNG.createAlphaMask(original:TBitmap);
var
    x,y:integer;
    points: Pointer;
    alpha: Pointer;
    a,r,g,b: byte;
begin
    falphamask.Canvas.brush.color:=clWhite;
    falphamask.Canvas.FillRect(rect(0,0,32,32));
    for y:=0 to original.height-1 do begin
        points:=original.ScanLine[y];
        alpha:=falphamask.ScanLine[y];
        for x:=0 to original.width-1 do begin
            r:=byte(points^);
            inc(PChar(points),1);
            g:=byte(points^);
            inc(PChar(points),1);
            b:=byte(points^);
            inc(PChar(points),1);
            a:=byte(points^);
            inc(PChar(points),1);

            if a<>0 then begin
                if a=255 then integer(alpha^):=(0 shl 24)+(b shl 16)+(g shl 8)+r
                else integer(alpha^):=((31-(a div 8)) shl 24)+(b shl 16)+(g shl 8)+r;
            end
            else integer(alpha^):=integer($FFFFFFFF);
            inc(PChar(alpha),4);
        end;
    end;
end;

procedure TXPPNG.SetBackground(const Value: TBitmap);
begin
  FBackground.assign(Value);
end;

procedure TXPPNG.paintToCanvas(ACanvas: TCanvas; const x, y: integer);
var
    c: TBitmap;
    s: TBitmap;
    b: TBitmap;
begin
    c:=TBitmap.create;
    s:=TBitmap.create;
    b:=TBitmap.create;
    try
        c.Width:=falphamask.width;
        c.height:=falphamask.height;
        s.Width:=falphamask.width;
        s.height:=falphamask.height;
        b.Width:=falphamask.width;
        b.height:=falphamask.height;
        b.Canvas.Brush.color:=FBackgroundColor;
        b.Canvas.FillRect(rect(0,0,falphamask.width,falphamask.height));

        bitblt(falphamask,s,0,0,falphamask.width,falphamask.height);
//        bitblt(fbackground,b,x,y,falphamask.width,falphamask.height);
        AlphaBitmap(s,b,c,1);
//        ACanvas.Draw(x,y,c);
        ACanvas.Draw(x,y,c);
    finally
        b.free;
        s.free;
        c.free;
    end;
end;

procedure TXPPNG.LoadFromStream(Stream: TStream);
begin
    original.LoadFromStream(stream);

    falphamask.width:=original.width;
    falphamask.height:=original.height;
    fbackground.width:=falphamask.width;
    fbackground.height:=falphamask.height;
    fbackground.Canvas.brush.color:=clBtnFace;
    fbackground.Canvas.FillRect(types.rect(0,0,falphamask.width,falphamask.height));
    createAlphaMask(original);
end;

procedure TXPPNG.Draw(ACanvas: TCanvas; const Rect: TRect);
begin
    paintToCanvas(ACanvas, rect.left, rect.top);
end;

function TXPPNG.GetEmpty: Boolean;
begin
    result:=falphamask.empty;
end;

function TXPPNG.GetHeight: Integer;
begin
    result:=falphamask.height;
end;

function TXPPNG.GetWidth: Integer;
begin
    result:=falphamask.width;
end;

procedure TXPPNG.SetHeight(Value: Integer);
begin
end;

procedure TXPPNG.SetWidth(Value: Integer);
begin
end;

procedure TXPPNG.Assign(source: TPersistent);
var
    m: TMemoryStream;
begin
    if source is TXPPNG then begin
        falphamask.width:=(source as TXPPNG).falphamask.width;
        falphamask.height:=(source as TXPPNG).falphamask.height;
        bitblt((source as TXPPNG).falphamask,falphamask,0,0,falphamask.width,falphamask.height);
    end
    else if source is TBitmap then begin
        m:=TMemorystream.create;
        try
            (source as TBitmap).SaveToStream(m);
            m.position:=0;
            LoadFromStream(m);
        finally
            m.free;
        end;
    end
    else inherited;
end;

procedure TXPPNG.SaveToStream(Stream: TStream);
begin
    original.SaveToStream(stream);
end;

procedure TXPPNG.SetBackgroundColor(const Value: TColor);
begin
    if value<>FBackgroundColor then begin
        FBackgroundColor := Value;
    end;
end;

initialization
    TPicture.RegisterFileFormat('PNG','PNG Alpha', TXPPNG);

finalization
    TPicture.UnregisterGraphicClass(TXPPNG);



end.

unit uXPPNG;

interface

uses Classes, QGraphics, uXPCommon,
     QDialogs, Types, Sysutils;

type
    TXPPNG=class(TGraphic)
    private
        FBackground: TBitmap;
        FAlphaMask: TBitmap;
        FSelectedMask: TBitmap;
        FCached: TBitmap;
        original: TBitmap;
        Fdone: boolean;
        FBackgroundColor: TColor;
        FUseBackground: boolean;
        cached: boolean;
    FSelected: boolean;
        procedure createAlphaMask(original: TBitmap);
        procedure createSelectedMask;
        procedure SetBackground(const Value: TBitmap);
        procedure SetBackgroundColor(const Value: TColor);
        procedure SetUseBackground(const Value: boolean);
    procedure SetSelected(const Value: boolean);

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

        property Selected:boolean read FSelected write SetSelected;
        procedure paintToCanvas(ACanvas:TCanvas; const x,y:integer; dens:integer=0);
        constructor Create;override;
        destructor Destroy;override;
        property Background:TBitmap read FBackground write SetBackground;
        property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor;
        property UseBackground: boolean read FUseBackground write SetUseBackground;
    end;

implementation

{ TXPPNG }

constructor TXPPNG.Create;
begin
  inherited;
  FSelected:=false;
  cached:=false;
  FCached:=TBitmap.create;
  FSelectedMask:=TBitmap.create;
  FUseBackground:=false;
  FBackgroundColor:=clBtnFace;
  Fdone:=false;
  original:=TBitmap.create;
  FAlphaMask:=TBitmap.create;
  FBackground:=TBitmap.create;
end;

destructor TXPPNG.Destroy;
begin
  FCached.free;
  original.free;
  FSelectedMask.free;
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

procedure TXPPNG.paintToCanvas(ACanvas: TCanvas; const x, y: integer; dens:integer=0);
var
    c: TBitmap;
    s: TBitmap;
    b: TBitmap;
    d: TBitmap;
begin
    if not cached then begin
//        c:=TBitmap.create;
        s:=TBitmap.create;
//        b:=TBitmap.create;
//        d:=TBitmap.create;
        try
//            c.Width:=falphamask.width;
//            c.height:=falphamask.height;

            s.Width:=falphamask.width;
            s.height:=falphamask.height;
            {
            b.Width:=falphamask.width;
            b.height:=falphamask.height;
            d.Width:=falphamask.width;
            d.height:=falphamask.height;
            }
            {
            if fusebackground then begin
                b.Assign(fbackground);
            end
            else begin
                b.Canvas.Brush.color:=FBackgroundColor;
                b.Canvas.FillRect(rect(0,0,falphamask.width,falphamask.height));
            end;
            }

            if not fselected then begin
                bitblt(falphamask,s,0,0,falphamask.width,falphamask.height);
            end
            else begin
                bitblt(fselectedmask,s,0,0,falphamask.width,falphamask.height);
            end;

            AlphaBitmap(s,fbackground,fcached,dens);
            ACanvas.Draw(x,y,fcached);
            cached:=true;

        finally
//            d.free;
//            b.free;
            s.free;
//            c.free;
        end;
    end
    else begin
            ACanvas.Draw(x,y,fcached);
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
    createSelectedMask;
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
        cached:=false;
        FBackgroundColor := Value;
        FBackground.Width:=original.Width;
        FBackground.height:=original.height;
        FBackground.Canvas.Brush.Color:=FBackgroundColor;
        FBackground.Canvas.FillRect(rect(0,0,original.width,original.height));
    end;
end;

procedure TXPPNG.SetUseBackground(const Value: boolean);
begin
  FUseBackground := Value;
end;

procedure TXPPNG.createSelectedMask;
var
    c: TBitmap;
    s: TBitmap;
    b: TBitmap;
    d: TBitmap;
begin
    c:=TBitmap.create;
    s:=TBitmap.create;
    b:=TBitmap.create;
    d:=TBitmap.create;
    try
        fselectedmask.Width:=falphamask.width;
        fselectedmask.height:=falphamask.height;
        c.Width:=falphamask.width;
        c.height:=falphamask.height;
        s.Width:=falphamask.width;
        s.height:=falphamask.height;
        b.Width:=falphamask.width;
        b.height:=falphamask.height;
        d.Width:=falphamask.width;
        d.height:=falphamask.height;
        if fusebackground then begin
            b.Assign(fbackground);
        end
        else begin
            b.Canvas.Brush.color:=FBackgroundColor;
            b.Canvas.FillRect(rect(0,0,falphamask.width,falphamask.height));
        end;

        bitblt(falphamask,s,0,0,falphamask.width,falphamask.height);
        b.Canvas.Brush.color:=clHighlight;
        b.Canvas.FillRect(rect(0,0,falphamask.width,falphamask.height));
        SelectedBitmap(s,b,c,16);
        bitblt(c,FSelectedMask,0,0,falphamask.width,falphamask.height);

    finally
        d.free;
        b.free;
        s.free;
        c.free;
    end;
end;

procedure TXPPNG.SetSelected(const Value: boolean);
begin
    if FSelected<>Value then begin
        FSelected := Value;
        cached:=false;
    end;
end;

initialization
    //Removed until the desktop is ready for alpha channel
    //TPicture.RegisterFileFormat('PNG','PNG Alpha', TXPPNG);

finalization
    //Removed until the desktop is ready for alpha channel
    //TPicture.UnregisterGraphicClass(TXPPNG);



end.

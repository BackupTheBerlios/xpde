unit uTrayIcon;

interface

uses
    Classes, QExtCtrls, QControls,
    QImgList, QGraphics, QMenus, uXPIPC,
    XLib, Qt, QForms, Types,
    QDialogs, Sysutils;

type
    TXPTrayIcon=class(TComponent)
    private
        parentwindow: window;
        FPanel: TPanel;
        FImage: TImage;
        FImageList: TImageList;
        FImageIndex: integer;
        FPopupMenu: TPopupMenu;
        FOnClick: TNotifyEvent;
        FOnDblClick: TNotifyEvent;
        FHint: string;
    FActive: boolean;
        procedure SetImageList(const Value: TImageList);
        procedure SetImageIndex(const Value: integer);
        procedure SetPopupMenu(const Value: TPopupMenu);
        procedure SetOnClick(const Value: TNotifyEvent);
        procedure SetOnDblClick(const Value: TNotifyEvent);
        procedure SetHint(const Value: string);
        procedure SetActive(const Value: boolean);
    public
        procedure updateImage;
        procedure updateActive;
        procedure addtotray;
        procedure removefromtray;
        procedure setparent(aparent: TWidgetControl);
        procedure setParentWindow(w: window);
        procedure notification(AComponent: TComponent; Operation: TOperation); override;
        constructor Create(AOwner:TComponent);override;
        destructor Destroy;override;
    published
        property Active:boolean read FActive write SetActive;
        property ImageList: TImageList read FImageList write SetImageList;
        property ImageIndex: integer read FImageIndex write SetImageIndex;
        property PopupMenu: TPopupMenu read FPopupMenu write SetPopupMenu;
        property Hint:string read FHint write SetHint;
        property OnClick: TNotifyEvent read FOnClick write SetOnClick;
        property OnDblClick: TNotifyEvent read FOnDblClick write SetOnDblClick;

    end;

procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('XPde',[TXPTrayIcon]);
end;

{ TXPTrayIcon }

procedure TXPTrayIcon.addtotray;
begin
    if not (csDesigning in componentstate) then begin
        XPIPC.broadcastMessage(XPDE_ADDTRAYICON,QWidget_winID(FPanel.handle));
    end;
end;

constructor TXPTrayIcon.Create(AOwner: TComponent);
begin
  inherited;
  FActive:=false;
  FHint:='';
  FOnClick:=nil;
  FOnDblClick:=nil;
  FPopupMenu:=nil;
  FImageIndex:=-1;
  FImageList:=nil;
  FPanel:=TPanel.create(nil);
  FPanel.Width:=16;
  FPanel.height:=16;
  FPanel.Caption:='';
  FPanel.BevelOuter:=bvNone;
  FImage:=TImage.create(nil);
  FImage.parent:=FPanel;
  FImage.align:=alClient;
end;

destructor TXPTrayIcon.Destroy;
begin
    removefromtray;
    if not (csDestroying in FPanel.ComponentState) then begin
        FImage.Parent:=nil;
        FImage.free;
        FPanel.Parent:=nil;
        FPanel.free;
    end;
    inherited;
end;

procedure TXPTrayIcon.notification(AComponent: TComponent;
  Operation: TOperation);
begin
    if operation=opRemove then begin
        if AComponent=FImageList then FImageList:=nil;
        if AComponent=FPopupMenu then FPopupMenu:=nil;        
    end;
    inherited;
end;

procedure TXPTrayIcon.removefromtray;
begin
    if not (csDesigning in componentstate) then begin
        XPIPC.broadcastMessage(XPDE_REMOVETRAYICON,QWidget_winID(FPanel.handle));
    end;
end;

procedure TXPTrayIcon.SetActive(const Value: boolean);
begin
    if value<>FActive then begin
        FActive := Value;
        updateactive;
    end;
end;

procedure TXPTrayIcon.SetHint(const Value: string);
begin
    if value<>FHint then begin
        FHint := Value;
        FImage.hint:=Fhint;
        FImage.ShowHint:=true;
    end;
end;

procedure TXPTrayIcon.SetImageIndex(const Value: integer);
begin
    if (value<>FImageIndex) then begin
        FImageIndex := Value;
        updateImage;
    end;
end;

procedure TXPTrayIcon.SetImageList(const Value: TImageList);
begin
    if value<>FImageList then begin
        FImageList := Value;
        updateImage;
    end;
end;

procedure TXPTrayIcon.SetOnClick(const Value: TNotifyEvent);
begin
    FOnClick := Value;
    FImage.OnClick:=FOnClick;
end;

procedure TXPTrayIcon.SetOnDblClick(const Value: TNotifyEvent);
begin
  FOnDblClick := Value;
  FImage.OnDblClick:=FOnDblClick;
end;

procedure TXPTrayIcon.setparent(aparent: TWidgetControl);
begin
    FPanel.parent:=aparent;
end;

procedure TXPTrayIcon.setParentWindow(w: window);
var
    h: window;
begin
    h:=QWidget_winID(FPanel.handle);
    parentwindow:=w;
    XReparentWindow(application.display,h,parentwindow,0,0);
    XMapWindow(application.display,h);
end;

procedure TXPTrayIcon.SetPopupMenu(const Value: TPopupMenu);
begin
    FPopupMenu := Value;
    FImage.PopupMenu:=FPopupMenu;
end;

procedure TXPTrayIcon.updateActive;
begin
    if FActive then begin
        addtotray;
    end
    else begin
        removefromtray;
    end;
end;

procedure TXPTrayIcon.updateImage;
var
    b: TBitmap;
begin
    if assigned(FImageList) then begin
        b:=TBitmap.create;
        try
            b.width:=FImage.width;
            b.height:=FImage.height;
            FImageList.GetBitmap(FImageIndex,b);
            FImage.Picture.Assign(b);
            FImage.transparent:=true;
            XClearArea (application.display, QWidget_winid(FPanel.handle), 0,0,0,0,1);
        finally
            b.free;
        end;
    end;
end;

end.

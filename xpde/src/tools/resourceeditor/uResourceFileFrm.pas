unit uResourceFileFrm;

interface

uses
  SysUtils, Types, Classes,
  Variants, QTypes, QGraphics,
  QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, uResources, QExtCtrls;

type
  TResourceFileFrm = class(TForm)
    tvEntries: TTreeView;
    StatusBar1: TStatusBar;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    resourceFile:TResourceFile;
    procedure updateResourceTree;
    procedure loadFromFile(const filename:string);
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  end;

var
  ResourceFileFrm: TResourceFileFrm;

implementation

{$R *.xfm}

{ TResourceFileFrm }

constructor TResourceFileFrm.Create(AOwner: TComponent);
begin
  inherited;
  resourceFile:=TResourceFile.create(nil);
end;

destructor TResourceFileFrm.Destroy;
begin
  resourceFile.free;
  inherited;
end;

procedure TResourceFileFrm.loadFromFile(const filename: string);
begin
    resourcefile.loadfromfile(filename);
    caption:=filename;
    updateResourceTree;
end;

procedure TResourceFileFrm.updateResourceTree;
var
    root: TTreeNode;
    catnode: TTreeNode;
    node: TTreeNode;
    i: integer;
    category: string;
    entry: TResourceEntry;
    function FindCategory(const caption:string):TTreeNode;
    var
        k:longint;
    begin
        result:=nil;
        for k:=0 to root.Count-1 do begin
            node:=root[k];
            if (AnsiCompareStr(node.Text,caption)=0) then begin
                result:=node;
                break;
            end;
        end;
    end;
begin
    tvEntries.Items.BeginUpdate;
    try
        tvEntries.Items.clear;
        root:=tvEntries.Items.AddChild(nil,'Resources');
        for i:=0 to resourcefile.resources.count-1 do begin
            entry:=resourcefile.resources[i];
            if entry.resourcetype<>rtNone then category:=ResourceTypeToString(entry.resourcetype)
            else category:=entry.sresourcetype;
            catnode:=FindCategory(category);
            if (not assigned(catnode)) then catnode:=tvEntries.Items.AddChild(root,category);
            node:=tvEntries.Items.AddChildObject(catnode,entry.resourcename,entry);            
        end;
    finally
        tvEntries.items.EndUpdate;
    end;
end;

procedure TResourceFileFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    //Check for modifications before close
    action:=caFree;
end;

end.

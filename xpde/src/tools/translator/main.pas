unit main;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QActnList, QMenus, QComCtrls, QGrids, QExtCtrls;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    ActionList1: TActionList;
    FileOpenCommand: TAction;
    File1: TMenuItem;
    FileOpenCommand1: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    sgStrings: TStringGrid;
    OpenDialog: TOpenDialog;
    StatusBar: TStatusBar;
    ToolButton2: TToolButton;
    procedure FileOpenCommandExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sgStringsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ToolButton2Click(Sender: TObject);
  private
    { Private declarations }
    hints:TStringList;
    lastfilename:string;
  public
    { Public declarations }
    procedure loadfromfile(const filename:string);
    procedure savetofile(const filename:string);
  end;

var
  Form1: TForm1;

implementation

{$R *.xfm}

procedure TForm1.FileOpenCommandExecute(Sender: TObject);
begin
    if opendialog.execute then begin
        loadfromfile(opendialog.filename);
    end;
end;

procedure TForm1.loadfromfile(const filename: string);
var
    f: TStringList;
    i:integer;
    line:string;
    k:integer;
    str,val,hin: string;
begin
    hints.clear;
    if fileexists(filename) then begin
        lastfilename:=filename;
        f:=TStringList.create;
        try
            f.loadfromfile(filename);
            sgStrings.rowcount:=f.Count+1;
            for i:=0 to f.count-1 do begin
                line:=f[i];
                k:=pos('=',line);
                str:='';
                val:='';
                hin:='';
                if k<>0 then begin
                    str:=copy(line,1,k-1);
                    val:=trim(copy(line,k+1,length(line)));
                    k:=pos('#',val);
                    if k<>0 then begin
                        hin:=copy(val,k+1,length(val));
                        val:=trim(copy(val,1,k-1));
                    end;
                    hints.add(hin);
                    sgStrings.Cells[0,i+1]:=str;
                    sgStrings.Cells[1,i+1]:=val;
                end;
            end;
        finally
            f.free;
        end;
    end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
    w: integer;
    i:integer;
begin
    w:=sgStrings.ClientWidth div sgStrings.colcount;
    for i:=0 to sgStrings.colcount-1 do begin
        sgStrings.ColWidths[i]:=w;
    end;
    sgStrings.Cells[0,0]:='Native';
    sgStrings.Cells[1,0]:='Translated';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    lastfilename:='';
    hints:=TStringList.create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
    hints.free;
end;

procedure TForm1.sgStringsSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
    canselect:=true;
    statusbar.SimpleText:=hints[Arow-1];
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
    savetofile(lastfilename);
end;

procedure TForm1.savetofile(const filename: string);
var
    i:longint;
    line:string;
    f: TStringList;
begin
    if filename<>'' then begin
        f:=TStringList.create;
        try
            for i:=1 to sgStrings.RowCount-1 do begin
                line:=sgStrings.cells[0,i]+'='+sgStrings.cells[1,i];
                line:=line+stringofchar(' ',500-length(line))+'#'+hints[i-1];
                f.add(line);
            end;
            f.savetofile(filename);
        finally
            f.free;
        end;
    end;
end;

end.

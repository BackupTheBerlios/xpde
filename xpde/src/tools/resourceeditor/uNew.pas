unit uNew;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QButtons, Libc;


type
  TNewTranslationDlg = class(TForm)
    Label1: TLabel;
    edExe: TEdit;
    Label2: TLabel;
    cbLocales: TComboBox;
    Label3: TLabel;
    edResbind: TEdit;
    btnGenerate: TButton;
    meOperations: TMemo;
    sbExe: TSpeedButton;
    sbResbind: TSpeedButton;
    procedure edExeChange(Sender: TObject);
    procedure cbLocalesChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure updateOperations;
  end;

var
  NewTranslationDlg: TNewTranslationDlg;

implementation

{$R *.xfm}

{ TNewTranslationDlg }

procedure TNewTranslationDlg.updateOperations;
var
    source: string;
    resource: string;
    resbind: string;
    sharedresources: string;
    locale:string;
    homepath: string;
    function striplocale(const str:string):string;
    var
        k:integer;
    begin
        result:='';
        k:=pos('[',str);
        if k<>0 then begin
            result:=copy(str,k+1,length(str));
            k:=pos(']',result);
            if k<>0 then begin
                result:=copy(result,1,k-1);
            end;
        end;
    end;
begin
    source:=edExe.Text;
    resbind:=edResbind.text;
    locale:=striplocale(cbLocales.Text);

    homepath:=getpwuid(getuid)^.pw_dir;

    resbind:=stringreplace(resbind,'$HOME',homepath,[rfReplaceAll, rfIgnoreCase]);

    meOperations.lines.beginupdate;
    try
        meOperations.lines.clear;
        if (locale<>'') and (source<>'') and (resbind<>'') then begin
            resource:=ChangeFileExt(source,'.'+locale+'.res');
            sharedresources:=ChangeFileExt(source,'.'+locale);
            meOperations.Lines.add(format('Source:%s',[source]));
            meOperations.Lines.add(format('Resource file:%s',[resource]));
            meOperations.Lines.add(format('Shared resources:%s',[sharedresources]));
            meOperations.Lines.add('');

            meOperations.Lines.add(format('%s -r %s %s',[resbind, resource, source]));
            meOperations.Lines.add(format('%s -s %s %s',[resbind, sharedresources, source]));
        end;
    finally
        meOperations.lines.endupdate;
    end;
end;

procedure TNewTranslationDlg.edExeChange(Sender: TObject);
begin
    updateOperations;
end;

procedure TNewTranslationDlg.cbLocalesChange(Sender: TObject);
begin
    updateOperations;
end;

end.

unit uStaticForm;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls,BigNumber;

type
  TStatisticsForm = class(TForm)
    RetBTN: TButton;
    LoadBTN: TButton;
    CdBTN: TButton;
    CadBTN: TButton;
    StatisticListBox: TListBox;
    StaticNumsLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CadBTNClick(Sender: TObject);
    procedure CdBTNClick(Sender: TObject);
    procedure LoadBTNClick(Sender: TObject);
    procedure RetBTNClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    nData:Longint;
    { Private declarations }
  public
    procedure AddData(num:TNumber);
    procedure GetAvearage(var num:TNumber);
    procedure GetSum(var num:TNumber);
    procedure GetStandardDerivationasN(var num:TNumber);
    procedure GetStandardDerivationasN_1(var num:TNumber);
    procedure GetSqaureAvearage(var num:TNumber);
    procedure GetSqaureSum(var num:TNumber);
    { Public declarations }
  end;

var
  StatisticsForm: TStatisticsForm;

implementation
uses main;

{$R *.xfm}
procedure TStatisticsForm.GetSum(var num:TNumber);
var
l:longint;
begin
Num.MakeZero;
if nData=0 then exit;
for l:=0 to nData-1 do
Num.Add(TNumber(StatisticListBox.Items.Objects[l]));
end;


procedure TStatisticsForm.GetAvearage(var num:TNumber);
begin
num.MakeZero;
if nData=0 then exit;
GetSum(num);
num.Divide(TNumber.Create(nData));
end;

procedure TStatisticsForm.GetStandardDerivationasN(var num:TNumber);
var
tmp,tmp1:TNumber;
l:longint;
begin
num.MakeZero;
if nData=0 then exit;
tmp:=TNumber.Create;tmp1:=TNumber.Create;
GetAvearage(tmp);
for l:=0 to nData-1 do
begin
TNumber(StatisticListBox.Items.Objects[l]).Sub(tmp,tmp1);
tmp1.IntPower(two);
num.Add(tmp1);
end;
num.Divide(TNumber.Create(nData));
num.Sqrt;
end;


procedure TStatisticsForm.GetStandardDerivationasN_1(var num:TNumber);
var
tmp,tmp1:TNumber;
l:longint;
begin
num.MakeZero;
if nData=0 then exit;
tmp:=TNumber.Create;tmp1:=TNumber.Create;
GetAvearage(tmp);
for l:=0 to nData-1 do
begin
TNumber(StatisticListBox.Items.Objects[l]).Sub(tmp,tmp1);
tmp1.IntPower(two);
num.Add(tmp1);
end;
num.Divide(TNumber.Create(nData-1));
num.Sqrt;
end;


procedure TStatisticsForm.GetSqaureSum(var num:TNumber);
var
l:longint;
begin
Num.MakeZero;
if nData=0 then exit;
for l:=0 to nData-1 do
begin
Num.Add(TNumber(StatisticListBox.Items.Objects[l]).FIntPower(two));
end;
end;

procedure TStatisticsForm.GetSqaureAvearage(var num:TNumber);
begin
num.MakeZero;
if nData=0 then exit;
GetSqaureSum(num);
num.Divide(TNumber.Create(nData));
end;


procedure TStatisticsForm.AddData(num:TNumber);
begin
inc(nData);
StatisticListBox.Items.AddObject(num.GetFormatString(MaxShow),TNumber.Create(num));
StaticNumsLabel.Caption:='n='+inttostr(StatisticListBox.Items.Count);
end;


procedure TStatisticsForm.FormCreate(Sender: TObject);
begin
nData:=0;
end;

procedure TStatisticsForm.CadBTNClick(Sender: TObject);
var
i:longint;
begin
if nData=0 then exit;
for i:=0 to nData-1 do
StatisticListBox.Items.Objects[i].Destroy;
nData:=0;
StatisticListBox.Items.Clear;
StaticNumsLabel.Caption:='n=0';
end;

procedure TStatisticsForm.CdBTNClick(Sender: TObject);
begin
if StatisticListBox.ItemIndex=-1 then exit;
StatisticListBox.Items.Objects[StatisticListBox.ItemIndex].Destroy;
StatisticListBox.Items.Delete(StatisticListBox.ItemIndex);
dec(nData);
StaticNumsLabel.Caption:='n='+inttostr(nData);
end;

procedure TStatisticsForm.LoadBTNClick(Sender: TObject);
begin
if StatisticListBox.ItemIndex=-1 then exit;
StatisticListBox.Items.Objects[StatisticListBox.ItemIndex].Destroy;
StatisticListBox.Items.Objects[StatisticListBox.ItemIndex]:=TNumber.Create(Main.MainForm.CalcText);                // change from maxdig to maxshow ??? allright ???    
StatisticListBox.Items[StatisticListBox.ItemIndex]:=TNumber(StatisticListBox.Items.Objects[StatisticListBox.ItemIndex]).GetFormatString(MaxShow);
end;

procedure TStatisticsForm.RetBTNClick(Sender: TObject);
begin
Main.MainForm.SetFocus;
end;

procedure TStatisticsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Main.MainForm.StaBTN.Click;
end;

end.

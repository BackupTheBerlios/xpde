// Completly rewritten due to supporting of big numbers
// Bugs:
//       - Code is not clear
//       - negative numbers in other bases are not fully supported
//       - Need some optimizations
//       - still a BIG QUESTION
//             Is that the best way i choose ???
//
//
//
// TODO:
//       -  What kind of help system to use ????
//       -  1.1! = ??????? dont know what does floating point number factoriel
//           means 
//       - Optimizations
//       - How Windows Calculator have all of digits of sin(x)
//       - Clearifying code
//       - Bitwise calculations
//
//
// History:
//
//
//    0.0 :
//         -  First Version done by Webmaster [cellulear@yahoo.com]
//         -  Every operation was done on Extended types so numbers have to be
//              in the range of  3.6 x 10^-4951 .. 1.1 x 10^4932 with only 10
//              valid floating digits,
//         -  Everything was divided in Scientific and Normal calculator so somethings
//              were duplicated
//         -    No Scientifics operations was developed
//         -    Calculations doesnt have any priority
//         -    Bugs in Numbers in other Bases
//
//
//
//    1.0b :
//         -  First New Designed Version
//         -  Completly changed & Improved By Roozbeh GHolizadeh [roozbeh@xpde.com]
//         -  Now every operation is done by new type TNumber to go over limits of
//             pascal extended types,there is no theorical limit in number of digits,
//             and limit of Longint in Exponents.
//         -  Now there is no Scientific or Normal Calculator everything is mixed in one
//             Form and panels
//         -  Calculations are done by priority of operations
//         -  Parantheses are Fully Supported
//         -  Numbers can be shown and calculated in other bases (still problems mainly
//             with negative numbers)
//         -  Trigonometric functions with support of diffrent Angle types
//
//    1.1a :
//         -  All functions are now supported but bitwise operators
//         -  Keyboard shortcuts are working
//         -  Now buttons get focus when going over them
//         -  Some bugs fixed
//         -  X1Y operation added for x^(1/y)
//
unit main;
{$o-}

interface

uses
  SysUtils, Types, Classes,
  Variants, QTypes, QGraphics,
  QControls, QForms, QDialogs,
  QStdCtrls, QMenus, QExtCtrls,
   uXPAPI,BigNumber;



Const
 MaxPR=20;
 MaxDig=35;
 MaxShow=31;

type
TheOperations=(
_Nop,_Equal,_Fact,_OpenPr,_ClosePr,_FESci,_FENorm,
_Or,_And,_Not,_Xor,_Int,_Frac,
_DegDMS,_DMSDeg,
_Sin,_Cos,_Tan,_ArcSin,_ArcCos,_ArcTan,
_Sinh,_Cosh,_Tanh,_ArcSinh,_ArcCosh,_ArcTanh,
_Ln,_Log,_InvLog,_Exp,_XInv,_XY,_X1Y,_X2,_XSqrt,_X3,_X3Sqrt,
_Div,_Mul,_Add,_Sub,_Mod);

Sentence=record
  Pr:Boolean;
  Num:TNumber;
  Operation:TheOperations;
  Priority:byte;
end;


  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    EditMNU: TMenuItem;
    CopyMNU: TMenuItem;
    PasteMNU: TMenuItem;
    ViewMNU: TMenuItem;
    ScientificMNU: TMenuItem;
    StandardMNU: TMenuItem;
    HelpMNU: TMenuItem;
    AboutCalculator1: TMenuItem;
    N2: TMenuItem;
    HelpTopics1: TMenuItem;
    SciencePanel: TPanel;
    ByteGroup: TRadioGroup;
    AngleGroup: TRadioGroup;
    AndBTN: TButton;
    XorBTN: TButton;
    NotBTN: TButton;
    IntBTN: TButton;
    piBTN: TButton;
    HexABTN: TButton;
    HexBBTN: TButton;
    HexCBTN: TButton;
    HexDBTN: TButton;
    HexEBTN: TButton;
    HexFBTN: TButton;
    CheckGroup: TGroupBox;
    OtherLBL: TLabel;
    StaBTN: TButton;
    AveBTN: TButton;
    SumBTN: TButton;
    sBTN: TButton;
    DatBTN: TButton;
    FEBTN: TButton;
    OpenParBTN: TButton;
    CloseParBTN: TButton;
    dmsBTN: TButton;
    ExpBTN: TButton;
    lnBTN: TButton;
    sinBTN: TButton;
    xyBTN: TButton;
    logBTN: TButton;
    cosBTN: TButton;
    x3BTN: TButton;
    nBTN: TButton;
    tanBTN: TButton;
    x2BTN: TButton;
    OneOverBTN: TButton;
    InvCB: TCheckBox;
    HypCB: TCheckBox;
    CalcEdit: TEdit;
    StandardPanel: TPanel;
    MCBTN: TButton;
    MRBTN: TButton;
    MSBTN: TButton;
    MAddBTN: TButton;
    SevenBTN: TButton;
    EightBTN: TButton;
    NineBTN: TButton;
    DivideBTN: TButton;
    Sqrt_ModBTN: TButton;
    FourBTN: TButton;
    FiveBTN: TButton;
    SixBTN: TButton;
    MultiplyBTN: TButton;
    PlusMinusBTN: TButton;
    Percent_OrBTN: TButton;
    OneBTN: TButton;
    TwoBTN: TButton;
    ThreeBTN: TButton;
    MinusBTN: TButton;
    OneOver_LshBTN: TButton;
    ZeroBTN: TButton;
    DecimalBTN: TButton;
    PlusBTN: TButton;
    EqualBTN: TButton;
    CCEPanel: TPanel;
    BackSpaceBTN: TButton;
    CEBTN: TButton;
    CBTN: TButton;
    MemoryLBL: TLabel;
    N1: TMenuItem;
    HexMNU: TMenuItem;
    DecimalMNU: TMenuItem;
    OctalMNU: TMenuItem;
    BinaryMNU: TMenuItem;
    N3: TMenuItem;
    DegreesMNU: TMenuItem;
    RadiansMNU: TMenuItem;
    GradsMNU: TMenuItem;
    N4: TMenuItem;
    DigitGroupingMNU: TMenuItem;
    QWordMNU: TMenuItem;
    DWordMNU: TMenuItem;
    WordMNU: TMenuItem;
    ByteMNU: TMenuItem;
    N5: TMenuItem;
    BasePanel: TPanel;
    HexRDBTN: TRadioButton;
    DecRDBTN: TRadioButton;
    OctRDBTN: TRadioButton;
    BinRDBTN: TRadioButton;
    WhatsThisPUMNU: TPopupMenu;
    WhatsThisMNU: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure AboutCalculator1Click(Sender: TObject);
    procedure DecimalBTNClick(Sender: TObject);
    procedure CEBTNClick(Sender: TObject);
    procedure CBTNClick(Sender: TObject);
    procedure CopyMNUClick(Sender: TObject);
    procedure PasteMNUClick(Sender: TObject);
    procedure EqualBTNClick(Sender: TObject);
    procedure PlusMinusBTNClick(Sender: TObject);
    procedure Sqrt_ModBTNClick(Sender: TObject);
    procedure OneOver_LshBTNClick(Sender: TObject);
    procedure MCBTNClick(Sender: TObject);
    procedure MRBTNClick(Sender: TObject);
    procedure MAddBTNClick(Sender: TObject);
    procedure Percent_OrBTNClick(Sender: TObject);
    procedure BackSpaceBTNClick(Sender: TObject);
    procedure StandardMNUClick(Sender: TObject);
    procedure ScientificMNUClick(Sender: TObject);
    procedure FEBTNClick(Sender: TObject);
    procedure StaBTNClick(Sender: TObject);
    procedure NumberBTNClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DivideBTNClick(Sender: TObject);
    procedure MultiplyBTNClick(Sender: TObject);
    procedure MinusBTNClick(Sender: TObject);
    procedure PlusBTNClick(Sender: TObject);
    procedure piBTNClick(Sender: TObject);
    procedure InvCBClick(Sender: TObject);
    procedure HypCBClick(Sender: TObject);
    procedure MSBTNClick(Sender: TObject);
    procedure HexMNUClick(Sender: TObject);
    procedure DecimalMNUClick(Sender: TObject);
    procedure OctalMNUClick(Sender: TObject);
    procedure BinaryMNUClick(Sender: TObject);
    procedure BaseRDBTNClick(Sender: TObject);
    procedure DegreesMNUClick(Sender: TObject);
    procedure RadiansMNUClick(Sender: TObject);
    procedure GradsMNUClick(Sender: TObject);
    procedure ByteGroupClick(Sender: TObject);
    procedure AngleGroupClick(Sender: TObject);
    procedure DigitGroupingMNUClick(Sender: TObject);
    procedure KeyPressed(Sender: TObject; var Key: Char);
    procedure AveBTNKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AveBTNKeyString(Sender: TObject; var S: WideString;
      var Handled: Boolean);
    procedure TheMouseEnter(Sender: TObject);
    procedure TheMouseLeave(Sender: TObject);
    procedure ByteGroupMNUClick(Sender: TObject);
    procedure WhatsThisMNUClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ControlMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FHintWindow:THintWindow;
    FHintPoint:TPoint;
    FHintShow:Boolean;
    HintStr:String;
    FNumIndex,BaseIndex: Byte;
    FNum:array[1..MaxPR+1] of Sentence;
    FMemoryNum: TNumber;
    isManuallyEntered,IsDecimal,IsFloat,ShowSCi: Boolean;
    procedure SetCalcText(S: string);
    procedure AddCalcText(CH: Char);
    function  GetOperationPriority(OP: TheOperations): Byte;
    function  ConvertToCurrentNum: Boolean;
    procedure Operate(OP: TheOperations);
    procedure Calculate(b: Shortint);
    procedure CorrectCurrentNum;
  public
    CalcText: String;
  end;

var
  MainForm: TMainForm;

implementation

uses uStaticForm, StrUtils;

{$R *.xfm}

const
 BRK=#13#10;
 EmptySciEdit = '0 ';
 AllToPr=-2;
 HelpStr:Array[1..14] of String =
 (
  'Puts this number in the calculator display.'+BRK+
  'Keyboard equivalent = 0-9',
  'Enters the selected letter in the value.'+BRK+
  'This button is available only if hexadecimal mode is turned on.'+BRK+
  'Keyboard equivalent = A-F',
  'Divides.'+BRK+
  'Keyboard equivalent = /',
  'Multiplies.'+BRK+
  'Keyboard equivalent = *',
  'Subtracts.'+BRK+
  'Keyboard equivalent = -',
  'Adds.'+BRK+
  'Keyboard equivalent = +',
  'Displays the modulus, or remainder, of x/y. Use this button as a binary operator.'+BRK+
  'For example, to find the modulus of 5 divided by 3, click 5 MOD 3 =, which equals 2.'+BRK+
  'Keyboard equivalent = %',
  'Calculates bitwise OR.'+BRK+
  'Logical operators will truncate the decimal portion of a number before performing any bitwise operation.'+BRK+
  'Keyboard equivalent = |',
  'Shifts left. To shift right, use Inv+Lsh. After clicking this button, you must specify (in binary) how many positions to the left or to the right you want to shift the number in the display area, and then click =.'+BRK+
  'Logical operators will truncate the decimal portion of a number before performing any bitwise operation.'+BRK+
  'Keyboard equivalent = <',
  'Performs any operation on the previous two numbers. To repeat the last operation, click = again.'+BRK+
  'Keyboard equivalent = ENTER',
  'Calculates bitwise AND.'+BRK+
  'Logical operators will truncate the decimal portion of a number before performing any bitwise operation.'+BRK+
  'Keyboard equivalent = &',
  'Calculates bitwise exclusive OR.'+BRK+
  'Logical operators will truncate the decimal portion of a number before performing any bitwise operation.'+BRK+
  'Keyboard equivalent = ^',
  'Calculates bitwise inverse.'+BRK+
  'Logical operators will truncate the decimal portion of a number before performing any bitwise operation.'+BRK+
  'Keyboard equivalent = ~',
  'Displays the integer portion of a decimal value. To display the fractional portion of a decimal value, use Inv+Int.'+BRK+
  'Keyboard equivalent = ;');




























procedure DegtoDMS(var Res:TNumber);
var
tmp,tmp2:TNumber;
begin
tmp := TNumber.Create(Res,Res.FloatDigits);
tmp2 := TNumber.Create(0,Res.FloatDigits);
tmp.Int(Res);
tmp.Frac;
tmp.mul(TNumber.Create('0.6'));
tmp.Exponent:=tmp.Exponent+2; //*100
tmp.Int(tmp2);tmp2.Exponent:=tmp2.Exponent-2; // /100
Res.Add(tmp2);
tmp.Frac;
tmp.mul(TNumber.Create('0.006'));
Res.Add(tmp);
end;




procedure DMStoDeg(var Res:TNumber);
var
tmp,tmp2:TNumber;
begin
tmp := TNumber.Create(Res,Res.FloatDigits);
tmp2 := TNumber.Create(Res,Res.FloatDigits);
tmp.Int(Res);
tmp.Frac(tmp2);
tmp2.Exponent:=tmp2.Exponent+2;
tmp2.Int;
tmp2.Exponent:=tmp2.Exponent-2;
tmp.Frac;
tmp.Sub(tmp2);
tmp2.divide(TNumber.Create('0.6'));
Res.Add(tmp2);
tmp.divide(TNumber.Create('0.36'));
Res.Add(tmp);
end;



function BinToInt(Value: string): Int64;
var
  i: Integer;
  int: Int64;
begin
  int := 0;
  for i := 1 to Length(Value) do
  begin
    int := int * 2 + StrToInt(Copy(Value, i, 1));
  end;
  Result := int;
end;



function OctToInt(Value: string): Int64;
var
  i: Integer;
  int: Int64;
begin
  int := 0;
  for i := 1 to Length(Value) do
  begin
    int := int * 8 + StrToInt(Copy(Value, i, 1));
  end;
  Result := int;
end;


function IntToOct(Value: Int64; digits: Integer): string;
var
  rest: Int64;
  oct: string;
  i: Integer;
begin
  oct  :=  '';
  while Value <> 0 do
  begin
    rest  := Value mod 8;
    Value := Value div 8;
    oct := IntToStr(rest) + oct;
  end;
  for i := Length(oct) + 1 to digits do
    oct := '0' + oct;
  Result := oct;
end;


function IntToBin(Value: Int64; digits: Integer): string;
var
  rest: Longint;
  oct: string;
  i: Integer;
begin
  oct := '';
  while Value <> 0 do
  begin
    rest  := Value mod 2;
    Value := Value div 2;
    oct := IntToStr(rest) + oct;
  end;
  for i := Length(oct) + 1 to digits do
    oct := '0' + oct;
  Result := oct;
end;


function HexToInt(HexStr: String): Int64;
var RetVar : Int64;
    i : byte;
begin
  HexStr := UpperCase(HexStr);
  RetVar := 0;

  for i :=1  to length(HexStr) do begin
      RetVar := RetVar *16;
      if HexStr[i] in ['0'..'9'] then
         RetVar := RetVar + (byte(HexStr[i]) - 48)
      else
         if HexStr[i] in ['A'..'F'] then
            RetVar := RetVar + (byte(HexStr[i]) - 55)
         else begin
            Retvar := 0;
            break;
         end;
  end;
  Result := RetVar;
end;


function AddThousandSeparator(S: string; Chr: Char): string;
var
  I: Integer;
  Decimal: String;
begin
  Decimal := Copy(S,Pos(DecimalSeparator,S),Length(S));
  if Pos('-',S) > 0 then
   Result :=  Copy(S,2,Pos(DecimalSeparator,S)-2)
  else
   Result := Copy(S,1,Pos(DecimalSeparator,S)-1);
  I := Length(Result) - 2;
  while I > 1 do
  begin
    Insert(Chr, Result, I);
    I := I - 3;
  end;
  if Pos('-',S) > 0 then
   Result := '-' + Result + Decimal
  else
   Result := Result + Decimal;
end;


function AddSciSeparator(S: string; Chr: Char): string;
var
  I: Integer;
begin
  if Pos('-',S) > 0 then
   Result := Copy(S,2,Length(S))
  else
   Result := Copy(S,1,Length(S));
  I := Length(Result) - 2;
  while I > 1 do
  begin
    Insert(Chr, Result, I);
    I := I - 4;
  end;
  if Pos('-',S) > 0 then
   Result := '-' + Result
  else
   Result := Result;
end;


function  TMainForm.GetOperationPriority(OP: TheOperations): Byte;
begin
case OP of
  _Add,_Sub:Result := 0;
  _Mul,_Div:Result := 1;
  _XY:Result := 2;
else
  Result := 0;
end;
end;


procedure TMainForm.Calculate(b: Shortint);
var
tmp: TNumber;
begin

if b=alltoPr then
begin
// here current sentence have lower or equal priority to prev sent.
while  (FNum[FNumIndex].Priority <= FNum[FNumIndex-1].Priority)
      and (not FNum[FNumIndex-1].Pr) do
begin
case FNum[FNumIndex-1].Operation of
  _Add: FNum[FNumIndex-1].Num.Add(FNum[FNumIndex].Num);
  _Sub: FNum[FNumIndex-1].Num.Sub(FNum[FNumIndex].Num);
  _Mul: FNum[FNumIndex-1].Num.Mul(FNum[FNumIndex].Num);
  _Div: FNum[FNumIndex-1].Num.Divide(FNum[FNumIndex].Num);
  _Mod: FNum[FNumIndex-1].Num.DivMod(FNum[FNumIndex].Num);
  _XY:  FNum[FNumIndex-1].Num.Power(FNum[FNumIndex].Num);
  _X1Y:
        begin
        FNum[FNumIndex].Num.Inverse;
        FNum[FNumIndex-1].Num.Power(FNum[FNumIndex].Num);
        end;
end;

FNum[FNumIndex-1].Operation := FNum[FNumIndex].Operation;
FNum[FNumIndex-1].Priority := FNum[FNumIndex].Priority;
FNum[FNumIndex].Num.MakeZero;
Dec(FNumIndex);
if FNumIndex=1 then break;
end;
end

else

if b>0 then
begin
case FNum[b].Operation of
  _Int: FNum[b].Num.Int;
  _Frac: FNum[b].Num.Frac;
  _Sin: FNum[b].Num.Sin;
  _Cos: FNum[b].Num.Cos;
  _Tan: FNum[b].Num.Tan;
  _ArcSin: FNum[b].Num.ArcSin;
  _ArcCos: FNum[b].Num.ArcCos;
  _ArcTan: FNum[b].Num.ArcTan;
  _Sinh: FNum[b].Num.Sinh;
  _Cosh: FNum[b].Num.Cosh;
  _Tanh: FNum[b].Num.Tanh;
  _ArcSinh: FNum[b].Num.ArcSinh;
  _ArcCosh: FNum[b].Num.ArcCosh;
  _ArcTanh: FNum[b].Num.ArcTanh;
  _Exp: FNum[b].Num.Exp;
  _Ln: FNum[b].Num.Ln;
  _Log: FNum[b].Num.Log;
  _InvLog: begin tmp := TNumber.Create('10',MaxDig);tmp.Power(FNum[b].Num);FNum[b].Num.Assign(tmp);tmp.Destroy;end;
  _XInv: FNum[b].Num.Inverse;
  _Fact: FNum[b].Num.Factoriel;
  _X2: FNum[b].Num.IntPower(two);
  _X3: FNum[b].Num.IntPower(three);
  _X3Sqrt: begin tmp := TNumber.Create(0,MaxDig);one.Divide(three,tmp);FNum[b].Num.Power(tmp);tmp.Destroy;end;
  _XSqrt: FNum[b].Num.Sqrt;
  _DegDMS: DegtoDMS(FNum[b].Num);
  _DMSDeg: DMStoDeg(FNum[b].Num);
end;

end;
// permanetly ?????????
AngleGroup.OnClick(self);
end;





procedure TMainForm.AddCalcText(CH:Char);
var
S:String;
begin
if isManuallyEntered=false then
begin
CalcEdit.Text := '';
CalcText := '';
end;
isManuallyEntered := true;
if (CH = '.') and (IsFloat) then
begin Beep;exit;end;

if Ch = '-' then
 if Pos('e',CalcText) = 0 then
   if pos('-',CalcText) = 1 then delete(CalcText,1,1)
     else CalcText := '-'+CalcText

 else
   if pos('e-',CalcText) <> 0 then
      CalcText := AnsiReplaceStr(CalcText,'e-','e+')
    else
     CalcText := AnsiReplaceStr(CalcText,'e+','e-');



if (CH <> ' ') and (CH <> '-') and (CH <> '+') then
begin
if CalcText='0' then CalcText:='';
CalcText := CalcText+CH;
end;

if Pos('e',CalcText) <> 0 then
 if Pos('e-',CalcText) = 0 then
  if Pos('e+',CalcText) = 0 then
      CalcText := AnsiReplaceStr(CalcText,'e','e+');

if pos('e-',CalcText) = Length(CalcText)-1 then
      CalcText := AnsiReplaceStr(CalcText,'e-','e');
if pos('e+',CalcText) = Length(CalcText)-1 then
      CalcText := AnsiReplaceStr(CalcText,'e+','e');

if (CalcText='') or (CalcText=' ') then CalcText:='0';

if not ConvertToCurrentNum then
 begin
  Beep;
  Delete(CalcText,Length(CalcText),1);
 end;

s := CalcText;
if s = '' then s := '0';
if Pos('e',s) = Length(s) then s := s+'+0';
if Pos('.',CalcText) = 0 then
s := s+'.';
if DigitGroupingMNU.Checked then s:=AddThousandSeparator(s,',');
CalcEdit.Text := s;
end;




procedure TMainForm.SetCalcText(S: string);
begin
isManuallyEntered  :=  false;
 case BaseIndex of
  0:s := IntToHex(Strtoint64(s),0);
  2:s := IntToOct(Strtoint64(s),0);
  3:s := IntToBin(Strtoint64(s),0);
 end;
if pos('.',s)=0 then s  :=  s + '.';
if DigitGroupingMNU.Checked then s:=AddThousandSeparator(s,',');
CalcEdit.Text  :=  S;
end;




function TMainForm.ConvertToCurrentNum: Boolean;
begin
Result := false;
Case BaseIndex of
0:if ByteGroup.ItemIndex > 1 then
   if Length(CalcText) > 8-ByteGroup.ItemIndex*4 then exit else
  else
   if Length(CalcText) > 16-ByteGroup.ItemIndex*4 then exit;
1:if (Length(CalcText) > MaxShow) or
     ((Pos('e',CalcText)<>0) and (Length(Copy(CalcText,Pos('e',CalcText),Length(CalcText))) > 7)) then exit;
2:
  case ByteGroup.ItemIndex of
    0:if length(CalcText) > 22 then exit;
    1:if length(CalcText) > 11 then exit;
    2:if Length(CalcText) > 5 then exit;
    3:if Length(CalcText) > 2 then exit;
  end;
3:if Length(CalcText) > (8-ByteGroup.ItemIndex*2)*4 then exit;
end;
 case BaseIndex of
  0:FNum[FNumIndex].Num.Assign(IntToStr(HexToInt(CalcText)));
  1:FNum[FNumIndex].Num.Assign(CalcText);
  2:FNum[FNumIndex].Num.Assign(IntToStr(OctToInt(CalcText)));
  3:FNum[FNumIndex].Num.Assign(IntToStr(BinToInt(CalcText)));
 end;
Result := True;
 end;



procedure TMainForm.CorrectCurrentNum;
var
a:Int64;
begin
if BaseIndex <> 1 then
begin
a := FNum[FNumIndex].Num.GetInt64;
Case ByteGroup.ItemIndex of
  1: a := Cardinal(a);
  2: a := word(a);
  3: a := byte(a);
end;
FNum[FNumIndex].Num.Assign(inttostr(a));
CalcText := FNum[FNumIndex].Num.GetFormatString(MaxShow);
end;
end;




procedure TMainForm.Operate(OP:TheOperations);
var
doinc:boolean;
begin
DefocusControl(MainForm,True);
doinc := true;
try
if OP=_ClosePr then
begin
dec(FNumIndex);
FNum[FNumIndex-1].Num.Assign(FNum[FNumIndex].Num);
dec(FNumIndex);
FNum[FNumIndex].Pr := false;
FNum[FNumIndex].Operation := _Add;
FNum[FNumIndex].Priority := 0;
Calculate(AllToPr);
end
else
if OP=_OpenPr then
begin
FNum[FNumIndex].Pr := true;
FNum[FNumIndex].Operation := _OpenPr;
end
else
if (OP <> _Nop) then
begin
FNum[FNumIndex].Pr := false;
FNum[FNumIndex].Operation := OP;
FNum[FNumIndex].Priority := GetOperationPriority(OP);
end;
if OP = _equal then
begin
Calculate(AllToPr);
end;


Case OP of
_DegDMS,_DMSDeg,
_Frac,_Int,
_Sin,_Cos,_Tan,_ArcSin,_ArcCos,_ArcTan,
_Sinh,_Cosh,_Tanh,_ArcSinh,_ArcCosh,_ArcTanh,
_Exp,_Ln,_Log,_InvLog,_X2,_X3,_X3Sqrt,_XSqrt, _XInv,_Fact:begin Calculate(FNumIndex);doinc := false;end;
_Nop,_ClosePr,_Equal,_FESci,_FENorm:doinc := false;
_OpenPr:;
else
begin
if FNumIndex>1 then
   if FNum[FNumIndex].Priority <= FNum[FNumIndex-1].Priority then
      if not FNum[FNumIndex-1].Pr then
          Calculate(ALLToPr);
// ????????????
doinc := true;
end;
end;

if (ShowSCi) or (OP = _FESci) then
 CalcText := FNum[FNumIndex].Num.GetString(MaxShow)
else
 CalcText := FNum[FNumIndex].Num.GetFormatString(MaxShow);

CorrectCurrentNum;

isManuallyEntered := false;
SetCalcText(CalcText);
if doinc then
begin
Inc(FNumIndex);
FNum[FNumIndex].Operation:=_Nop;
end;
IsFloat := false;

except
 on E: Exception do
   begin
   CEBTNClick(self);
   CalcEdit.Text:=E.Message;
   end;

end;end;







procedure TMainForm.FormCreate(Sender: TObject);
var
b:byte;
begin
    //These lines are here to set the font of the menubar
    font.name := '';
    parentfont := true;
for b := 1 to MaxPR do
begin
FNum[b].Num := TNumber.Create(0,MaxDig);
FNum[b].Operation:=_Equal;
end;
FMemoryNum := TNumber.Create(0,MaxDig);
FNumIndex := 1;
FHintWindow:= HintWindowClass.Create(MainForm);
FHintWindow.Color:=clInfoBk;
FHintShow:=False;
IsFloat := false;ShowSCi := false;
CalcText  :=  '0';
SetCalcText(CalcText);
BaseIndex := 1;
DecimalMNU.Click;
DegreesMNU.Click;
StandardMNU.Click;
//isManuallyEntered := True;
end;                  



procedure TMainForm.AboutCalculator1Click(Sender: TObject);
begin
    XPAPI.showAboutDlg('Calculator');
end;


procedure TMainForm.DecimalBTNClick(Sender: TObject);
begin
IsDecimal  :=  True;
AddCalcText('.');
IsFloat := true;
end;

procedure TMainForm.CEBTNClick(Sender: TObject);
begin
IsDecimal  :=  False;
IsFloat := False;
FNum[FNumIndex].Num.MakeZero;
SetCalcText('0');
DefocusControl(MainForm,True)
end;


procedure TMainForm.CBTNClick(Sender: TObject);
begin
repeat
CEBTNClick(Self);
dec(FNumIndex);
until FNumIndex=0;
FNumIndex := 1;
ShowSCi := False;
DefocusControl(MainForm,True)
end;

procedure TMainForm.CopyMNUClick(Sender: TObject);
begin
CalcEdit.CopyToClipboard;
end;

procedure TMainForm.PasteMNUClick(Sender: TObject);
begin
CalcEdit.PasteFromClipboard;
end;

procedure TMainForm.EqualBTNClick(Sender: TObject);
begin
Operate(_Add);
dec(FNumIndex);
end;


procedure TMainForm.PlusMinusBTNClick(Sender: TObject);
begin
if isManuallyEntered then
AddCalcText('-')
else
begin
FNum[FNumIndex].Num.SwitchSign;
Operate(_Nop);
end;
end;



procedure TMainForm.Sqrt_ModBTNClick(Sender: TObject);
begin
if StandardMNU.Checked then
begin
Sqrt_ModBTN.Tag := 30;
FEBTNClick(Sqrt_ModBTN)
end
else
begin
Sqrt_ModBTN.Tag := 18;
FEBTNClick(Sqrt_ModBTN)
end;
end;


procedure TMainForm.Percent_OrBTNClick(Sender: TObject);
begin
Percent_OrBTN.Tag:= 17;
if StandardMNU.Checked then
FEBTNClick(Percent_OrBTN);
end;

procedure TMainForm.OneOver_LshBTNClick(Sender: TObject);
begin
OneOver_LshBTN.Tag := 15;
if StandardMNU.Checked then
FEBTNClick(OneOver_LshBTN);
end;


procedure TMainForm.MCBTNClick(Sender: TObject);
begin
FMemoryNum.MakeZero;
MemoryLBL.Caption := '';
end;

procedure TMainForm.MSBTNClick(Sender: TObject);
begin
FMemoryNum.Assign(CalcText);
if not FMemoryNum.IsZero then
MemoryLBL.Caption := 'M';
Operate(_Nop);
end;

procedure TMainForm.MRBTNClick(Sender: TObject);
begin
FNum[FNumIndex].Num.Assign(FMemoryNum);
Operate(_Nop);
end;


procedure TMainForm.MAddBTNClick(Sender: TObject);

var
tmp: TNumber;
begin
tmp := TNumber.Create(0,MaxDig);
tmp.Assign(CalcText);
FMemoryNum.Add(tmp);
tmp.Destroy;
If FMemoryNum.IsZero then
MemoryLBL.Caption := ''
else
MemoryLBL.Caption := 'M'
end;



procedure TMainForm.BackSpaceBTNClick(Sender: TObject);
begin
if (CalcText = '') or (CalcText = '0') then exit;
if pos('.',CalcText) = Length(CalcText) then IsFloat := false;
delete(CalcText,Length(CalcText),1);
AddCalcText(' ');
DefocusControl(MainForm,True)
end;

procedure TMainForm.StandardMNUClick(Sender: TObject);
var
b: Byte;
begin
if ScientificMNU.Checked then
begin
StandardMNU.Checked := true;
SciencePanel.Hide;
MainForm.Width := 260;
StandardPanel.Left := 0;
StandardPanel.Top := StandardPanel.Top-AngleGroup.Height;
CCEPanel.Top := 30;
Height := Height-50;
Sqrt_ModBTN.Caption := 'sqrt';Sqrt_ModBTN.Font.Color := ZeroBTN.Font.Color;
Percent_OrBTN.Caption := '%';Percent_OrBTN.Font.Color := ZeroBTN.Font.Color;
OneOver_LshBTN.Caption := '1/x';OneOver_LshBTN.Font.Color := ZeroBTN.Font.Color;

if InvCB.Tag = 20 then begin InvCB.OnClick(self);InvCB.Checked := false;end;
if HypCB.Tag = 40 then begin HypCB.OnClick(self);HypCB.Checked := false;end;


for b := 0 to ViewMNU.Count-1 do
if pos('T',ViewMNU.Items[b].Hint) <> 0 then
begin ViewMNU.Items[b].Visible := true;ViewMNU.Items[b].Enabled := true;end
else
begin ViewMNU.Items[b].Visible := false;ViewMNU.Items[b].Enabled := false;end;
end;
end;



procedure TMainForm.ScientificMNUClick(Sender: TObject);
var
b:byte;
begin
if StandardMNU.Checked then
begin
ScientificMNU.Checked := true;
MainForm.Width := 476;
StandardPanel.Left := 181;
StandardPanel.Top := StandardPanel.Top+AngleGroup.Height;
CCEPanel.Top := 56;
Height := Height+50;
SciencePanel.Show;
Sqrt_ModBTN.Caption := 'Mod';Sqrt_ModBTN.Font.Color := DivideBTN.Font.Color;
Percent_OrBTN.Caption := 'Or';Percent_OrBTN.Font.Color := DivideBTN.Font.Color;
OneOver_LshBTN.Caption := 'Lsh';OneOver_LshBTN.Font.Color := DivideBTN.Font.Color;


for b := 0 to ViewMNU.Count-1 do
if pos('C',ViewMNU.Items[b].Hint) <> 0 then
begin ViewMNU.Items[b].Visible := true;ViewMNU.Items[b].Enabled := true;end
else
begin ViewMNU.Items[b].Visible := false;ViewMNU.Items[b].Enabled := false;end;

DecimalMNUClick(self);

end;
end;




procedure TMainForm.FEBTNClick(Sender: TObject);
var
opBak:TheOperations;
begin                    //+20      +40
if not (Sender as TButton).Enabled then begin Beep;exit;end;
Screen.Cursor:=crHourGlass;
case TButton(Sender).Tag+InvCB.Tag+HypCB.Tag of
 0,20,40: Operate(_Nop);
 1,21,41:
   if BaseIndex = 1 then
     begin
     ShowSCi := ShowSCi xor true;
     if ShowSCi then
      Operate(_FESci)
     else
      Operate(_FENorm)
     end;
 2,42:
      Operate(_DegDMS);

 22,62:
      Operate(_DMSDeg);

 3:
     Operate(_Sin);

 23:
     Operate(_ArcSin);

 43:
     Operate(_Sinh);

 63:
     Operate(_ArcSinh);

 4:
     Operate(_Cos);

 24:
     Operate(_ArcCos);

 44:
     Operate(_Cosh);

 64:
     Operate(_ArcCosh);

 5:
     Operate(_Tan);

 25:
     Operate(_ArcTan);

 45:
     Operate(_Tanh);

 65:
     Operate(_ArcTanh);

 6,26,66:
     begin// Do (
      if OtherLBL.Tag = MaxPR-4 then exit;
      OtherLBL.Tag := OtherLBL.Tag+1;
      OtherLBL.Caption := '(='+inttostr(OtherLBL.Tag);
      Operate(_OpenPr);
    end;
 11,31,71:
     begin// Do )
      if OtherLBL.Tag = 0 then exit;
      Operate(_Add);
      OtherLBL.Tag := OtherLBL.Tag-1;
      if OtherLBL.Tag <> 0 then
      OtherLBL.Caption := '(='+inttostr(OtherLBL.Tag)
      else OtherLBL.Caption := '';
      Operate(_ClosePr);
    end;
 7,27,47:
      AddCalcText('e');

 8,48:
     Operate(_XY);

 28,68:
     Operate(_X1Y);

 9,49:
     Operate(_X3);

 29,69:
     Operate(_X3Sqrt);

 10,50:
     Operate(_X2);

 30,80:
     Operate(_XSqrt);

 12,52:
     Operate(_Ln);

 32,82:
     Operate(_Exp);

 13,53:
     Operate(_Log);

 33,73:
     Operate(_InvLog);

 14,54:
     Operate(_Fact);

 15,55:
     Operate(_Xinv);
 16,56:
     Operate(_Int);
 36,76:
     Operate(_Frac);
 17:if FNumIndex<=1 then CEBTNClick(self) else
     begin
       if (not isManuallyEntered) and (FNum[FNumIndex].Operation=_Nop) then
       begin
       FNum[FNumIndex].Num.Assign(FNum[FNumIndex-1].Num);
       end;
       opBak:=FNum[FNumIndex-1].Operation;
       FNum[FNumIndex-1].Operation:=_Add;
       FNum[FNumIndex-1].Priority:=GetOperationPriority(_Add);
       FNum[FNumIndex].Operation:=_Mul;
       FNum[FNumIndex].Priority:=GetOperationPriority(_Mul);
       inc(FNumIndex);
       FNum[FNumIndex].Num.Assign(FNum[FNumIndex-1].Num);
       FNum[FNumIndex-1].Num.Assign(FNum[FNumIndex-2].Num);
       FNum[FNumIndex].Num.Exponent:=FNum[FNumIndex].Num.Exponent-2;
       Operate(_Mul);Dec(FNumIndex);
       assert(FNumIndex>1);
       FNum[FNumIndex-1].Operation:=opBak;
     end;

  18:
     Operate(_Mod);
end;

Screen.Cursor:=crDefault;
if InvCB.Tag = 20 then begin InvCB.OnClick(self);InvCB.Checked := false;end;
if HypCB.Tag = 40 then begin HypCB.OnClick(self);HypCB.Checked := false;end;
DefocusControl(MainForm,True)
end;




procedure TMainForm.StaBTNClick(Sender: TObject);
begin
if not (Sender as TButton).Enabled then begin Beep;exit;end;
case TButton(Sender).Tag+InvCB.Tag of
 0,1: begin
     StaBTN.Tag := StaBTN.Tag xor 1;
     if StaBTN.Tag=1 then
      begin
       StatisticsForm.Show;
       AveBTN.Enabled := true;SumBTN.Enabled := true;
       sBTN.Enabled := true;DatBTN.Enabled := true;
      end
     else
      begin
       StatisticsForm.Hide;
       AveBTN.Enabled := false;SumBTN.Enabled := false;
       sBTN.Enabled := false;DatBTN.Enabled := false;
      end
    end;
 2: begin
      StatisticsForm.GetAvearage(FNum[FNumIndex].num);
      Operate(_Nop);
    end;
 22: begin
      StatisticsForm.GetSqaureAvearage(FNum[FNumIndex].num);
      Operate(_Nop);
    end;
 3: begin
      StatisticsForm.GetSum(FNum[FNumIndex].num);
      Operate(_Nop);
    end;
 23: begin
      StatisticsForm.GetSqaureSum(FNum[FNumIndex].num);
      Operate(_Nop);
    end;
 4: begin
      StatisticsForm.GetStandardDerivationasN_1(FNum[FNumIndex].num);
      Operate(_Nop);
    end;
 24: begin
      StatisticsForm.GetStandardDerivationasN(FNum[FNumIndex].num);
      Operate(_Nop);
    end;
5,25: begin
      StatisticsForm.AddData(TNumber.Create(CalcText));
      Operate(_Nop);
    end;
end;
if InvCB.Tag=20 then begin InvCB.OnClick(self); InvCB.Checked := false; end;
DefocusControl(MainForm,True)
end;



procedure TMainForm.NumberBTNClick(Sender: TObject);
begin
if not (Sender as TButton).Enabled then begin Beep;exit;end;
  with sender as TButton do
    AddCalcText(UpCase(char( Hint[1])));
//DefocusControl(MainForm,True)
end;


procedure TMainForm.FormDestroy(Sender: TObject);
var
b:byte;
begin
for b := 1 to MaxPR do
   FNum[b].Num.Destroy;
end;


procedure TMainForm.DivideBTNClick(Sender: TObject);
begin
if (not isManuallyEntered) and (FNum[FNumIndex].Operation=_Nop) then dec(FNumIndex);
  Operate(_Div);
end;


procedure TMainForm.MultiplyBTNClick(Sender: TObject);
begin
if (not isManuallyEntered) and (FNum[FNumIndex].Operation=_Nop) then dec(FNumIndex);
   Operate(_Mul);
end;


procedure TMainForm.MinusBTNClick(Sender: TObject);
begin
if (not isManuallyEntered) and (FNum[FNumIndex].Operation=_Nop) then dec(FNumIndex);
   Operate(_Sub);
end;


procedure TMainForm.PlusBTNClick(Sender: TObject);
begin
if (not isManuallyEntered) and (FNum[FNumIndex].Operation=_Nop) then dec(FNumIndex);
   Operate(_Add);
end;


procedure TMainForm.piBTNClick(Sender: TObject);
begin
if InvCB.Tag=0 then
  FNum[FNumIndex].Num.Assign(Pi,asAllbutFloatDigits xor asAngle)
else
  FNum[FNumIndex].Num.Assign(Pi2,asAllbutFloatDigits xor asAngle);
Operate(_Nop);
{if InvCB.Tag=0 then
SetCalcText(Pi.GetFormatString(MaxShow-1))
else
SetCalcText(Pi2.GetFormatString(MaxShow-1));
CalcText:=CalcEdit.Text;
ConvertToCurrentNum;}
end;


procedure TMainForm.InvCBClick(Sender: TObject);
begin
if ScientificMNU.Checked then
   if InvCB.Checked then
       InvCB.Tag := 20 else InvCB.Tag := 0;
end;


procedure TMainForm.HypCBClick(Sender: TObject);
begin
if ScientificMNU.Checked then
   if HypCB.Checked then
      HypCB.Tag := 40 else HypCB.Tag := 0
end;


procedure TMainForm.HexMNUClick(Sender: TObject);
var
i: Word;
begin
HexMNU.Checked := true;
HexRDBTN.Checked := true;

for i := 0 to SciencePanel.ControlCount-1 do
  if SciencePanel.Controls[i] is TButton then
     with SciencePanel.Controls[i] as TButton do
       if pos('H',Hint) <> 0 then Enabled := true else Enabled := false;

for i := 0 to StandardPanel.ControlCount-1 do
  if StandardPanel.Controls[i] is TButton then
     with StandardPanel.Controls[i] as TButton do
        if pos('H',Hint) <> 0 then Enabled := true else Enabled := false;

for i := 0 to ViewMNU.Count-1 do
    if ViewMNU.Items[i].GroupIndex=3 then
       begin ViewMNU.Items[i].Visible := true;ViewMNU.Items[i].Enabled := true;end
    else if ViewMNU.Items[i].GroupIndex=4 then
       begin ViewMNU.Items[i].Visible := false;ViewMNU.Items[i].Enabled := false;end;

AngleGroup.Hide;
SetCalcText(CalcText);
end;



procedure TMainForm.DecimalMNUClick(Sender: TObject);
var
i: Word;
begin
DecimalMNU.Checked := true;
DecRDBTN.Checked := true;


for i := 0 to SciencePanel.ControlCount-1 do
   if SciencePanel.Controls[i] is TButton then
      with SciencePanel.Controls[i] as TButton do
         if pos('D',Hint) <> 0 then Enabled := true else Enabled := false;

for i := 0 to StandardPanel.ControlCount-1 do
   if StandardPanel.Controls[i] is TButton then
      with StandardPanel.Controls[i] as TButton do
         if pos('D',Hint) <> 0 then Enabled := true else Enabled := false;

for i := 0 to ViewMNU.Count-1 do
    if ViewMNU.Items[i].GroupIndex=4 then
       begin ViewMNU.Items[i].Visible := true;ViewMNU.Items[i].Enabled := true;end
    else if ViewMNU.Items[i].GroupIndex=3 then
       begin ViewMNU.Items[i].Visible := false;ViewMNU.Items[i].Enabled := false;end;

AngleGroup.Show;
SetCalcText(CalcText);
end;



procedure TMainForm.OctalMNUClick(Sender: TObject);
var
i: Word;
begin
OctalMNU.Checked := true;
OctRDBTN.Checked := true;

for i := 0 to SciencePanel.ControlCount-1 do
  if SciencePanel.Controls[i] is TButton then
     with SciencePanel.Controls[i] as TButton do
        if pos('O',Hint) <> 0 then Enabled := true else Enabled := false;
for i := 0 to StandardPanel.ControlCount-1 do
  if StandardPanel.Controls[i] is TButton then
      with StandardPanel.Controls[i] as TButton do
         if pos('O',Hint) <> 0 then Enabled := true else Enabled := false;

for i := 0 to ViewMNU.Count-1 do
    if ViewMNU.Items[i].GroupIndex=3 then
       begin ViewMNU.Items[i].Visible := true;ViewMNU.Items[i].Enabled := true;end
    else if ViewMNU.Items[i].GroupIndex=4 then
       begin ViewMNU.Items[i].Visible := false;ViewMNU.Items[i].Enabled := false;end;

AngleGroup.Hide;
SetCalcText(CalcText);
end;



procedure TMainForm.BinaryMNUClick(Sender: TObject);
var
i: Word;
begin
BinaryMNU.Checked := true;
BinRDBTN.Checked := true;

for i := 0 to SciencePanel.ControlCount-1 do
if SciencePanel.Controls[i] is TButton then
   with SciencePanel.Controls[i] as TButton do
     if pos('B',Hint) <> 0 then Enabled := true else Enabled := false;

for i := 0 to StandardPanel.ControlCount-1 do
  if StandardPanel.Controls[i] is TButton then
     with StandardPanel.Controls[i] as TButton do
       if pos('B',Hint) <> 0 then Enabled := true else Enabled := false;

for i := 0 to ViewMNU.Count-1 do
    if ViewMNU.Items[i].GroupIndex=3 then
       begin ViewMNU.Items[i].Visible := true;ViewMNU.Items[i].Enabled := true;end
    else if ViewMNU.Items[i].GroupIndex=4 then
       begin ViewMNU.Items[i].Visible := false;ViewMNU.Items[i].Enabled := false;end;

AngleGroup.Hide;
SetCalcText(CalcText);
end;




procedure TMainForm.ByteGroupClick(Sender: TObject);
begin
if isManuallyEntered then
ConvertToCurrentNum;
isManuallyEntered := false;
CorrectCurrentNum;
SetCalcText(CalcText);
DefocusControl(MainForm,True)
end;



procedure TMainForm.BaseRDBTNClick(Sender: TObject);
begin
Operate(_Nop);
isManuallyEntered := false;
BaseIndex := (Sender as TRadioButton).Tag;
CorrectCurrentNum;
case BaseIndex of
  0: HexMNU.Click;
  1: DecimalMNU.Click;
  2: OctalMNU.Click;
  3: BinaryMNU.Click;
end;
DefocusControl(MainForm,True)
end;


procedure TMainForm.DegreesMNUClick(Sender: TObject);
var
i: Word;
begin
DegreesMNU.Checked := true;
AngleGroup.ItemIndex := 0;
for i := 1 to MaxPR do
FNum[i].Num.Angle := Degrees;
end;


procedure TMainForm.RadiansMNUClick(Sender: TObject);
var
i: Word;
begin
RadiansMNU.Checked := true;
AngleGroup.ItemIndex := 1;
for i := 1 to MaxPR do
FNum[i].Num.Angle := Radians;
end;


procedure TMainForm.GradsMNUClick(Sender: TObject);
var
i: Word;
begin
GradsMNU.Checked := true;
AngleGroup.ItemIndex := 2;
for i := 1 to MaxPR do
FNum[i].Num.Angle := Grads;
end;


procedure TMainForm.AngleGroupClick(Sender: TObject);
begin
  case AngleGroup.ItemIndex of
    0: DegreesMNUClick(self);
    1: RadiansMNUClick(self);
    2: GradsMNUClick(self);
  end;
DefocusControl(MainForm,True)
end;


procedure TMainForm.DigitGroupingMNUClick(Sender: TObject);
begin
DigitGroupingMNU.Tag := DigitGroupingMNU.Tag xor 1;
if DigitGroupingMNU.Tag = 1 then
   DigitGroupingMNU.Checked := true
else
   DigitGroupingMNU.Checked := false;
SetCalcText(CalcText);
end;






procedure TMainForm.KeyPressed(Sender: TObject; var Key: Char);
begin
//
end;

procedure TMainForm.AveBTNKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
case Key of
4102:  DatBTN.Click;
4103:  CEBTN.Click;
4096:  CBTN.Click;
4099:  BackSpaceBTN.Click;
4152:  PlusMinusBTNClick(self);
ord('0')..ord('9'):  AddCalcText(char(Key));
ord('.'):  DecimalBTNClick(self);
ord('+'):  PlusBTNClick(self);
ord('-'):  MinusBTNClick(self);
ord('*'):  MultiplyBTNClick(self);
ord('/'):  DivideBTNClick(self);
ord(')'):  CloseParBTN.Click;
ord('('):  OpenParBTN.Click;
ord(';'):  Percent_OrBTNClick(self);
ord('V'):  FEBTN.Click;
ord('N'):  LnBTN.Click;
ord('X'):  ExpBTN.Click;
ord('Y'):  xyBTN.Click;
ord('S'):  if ssCtrl in Shift then StaBTN.Click else sinBTN.Click;
ord('!'):  nBTN.Click;
ord('#'):  x3BTN.Click;
ord('O'):  cosBTN.Click;
ord('T'):  if ssCtrl in Shift then SumBTN.Click else tanBTN.Click;
ord('@'):  x2BTN.Click;

ord('A'):  if ssCtrl in Shift then AveBTN.Click else HexABTN.Click;
ord('B'):  HexBBTN.Click;
ord('C'):  HexCBTN.Click;
ord('D'):  if ssCtrl in Shift then sBTN.Click else HexDBTN.Click;
ord('E'):  HexEBTN.Click;
ord('F'):  HexFBTN.Click;

ord('I'):  InvCBClick(self);
ord('H'):  HypCBClick(self);
ord('L'):  if ssCtrl in Shift then  MCBTNClick(self) else logBTN.Click;
ord('R'):  if ssCtrl in Shift then  MRBTNClick(self) else OneOverBTN.Click;
ord('M'):  if ssCtrl in Shift then  MSBTNClick(self) else dmsBTN.Click;
ord('P'):  if ssCtrl in Shift then  MAddBTNClick(self) else piBTNClick(self);
4100,4101: EqualBTNClick(self);
end;
end;


procedure TMainForm.AveBTNKeyString(Sender: TObject; var S: WideString;
  var Handled: Boolean);
begin
//
end;

procedure TMainForm.TheMouseEnter(Sender: TObject);
begin
with Sender as TControl do
HintStr:=HelpKeyword;
with Sender as TButtonControl do
 if Visible and Enabled and (not FHintShow) then
  begin
  SetFocus;
  end;
end;

procedure TMainForm.TheMouseLeave(Sender: TObject);
begin
if not FHintShow then
DefocusControl(Sender as TButtonControl,True)
end;


procedure TMainForm.ByteGroupMNUClick(Sender: TObject);
begin
if StandardMNU.Checked then exit;
with Sender as TMenuItem do
ByteGroup.ItemIndex:=Tag;
ByteGroupClick(self);
end;

procedure TMainForm.WhatsThisMNUClick(Sender: TObject);
var
mr:trect;

begin
mr:=FHintWindow.CalcHintRect(2000, HintStr, 0);
inc(mr.Left,Mouse.CursorPos.X);inc(mr.Top,Mouse.CursorPos.Y);
inc(mr.Right,Mouse.CursorPos.X);inc(mr.Bottom,Mouse.CursorPos.Y);
FHintWindow.ActivateHint(mr,HintStr);
FHintWindow.SetFocus;
FHintShow:=True;
//Application.ActivateHint(point(10,10));
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
if FHintShow then
begin
FHintWindow.ReleaseHandle;
FHintShow:=False;
end;
end;

procedure TMainForm.ControlMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if Button=mbRight then
with Sender as TControl do
 HintStr:=HelpStr[HelpContext];
end;

end.




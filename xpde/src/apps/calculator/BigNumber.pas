//=============================================================================
//    All code Copyrighted 2003 by Roozbeh GHolizadeh (roozbehid@yahoo.com)
//
//                This unit Rights Fully belong to Roozbeh GHolizadeh
//
//                    Original file name is BigNumber.pas
//
//
//                 You are not allowed to use this unit without
//                        prior permission of the myself
//
//
//                 if you liked this unit and you want to use it in
//                    your program please email me for permission
//                           and a more advanced unit.
//
//
//
//
//
//                          !!!!!!   PLEASE   !!!!!!!
//                   Do not alter / remove this copyright notice
//                       Email me at :
//                                     roozbehid@yahoo.com
//                                     roozbeh@xpde.com
//
//
//  History
//      Early 1997
//        0.0  :  Created for some school excersises in early 1997 with Turbo Pascal 6
//                 to calculate Factoriel,i later tried to implement it to have
//                 support for basic operations
//      Summer 1999
//        0.1  :  Now my BigNumber unit can calculate Pi to any required digits
//               - Everythings now done by objects instead of pure records
//               - Support for Sin Cos Tan added
//
//      Summer 2000
//        1.0  : First attempts to port it to Delphi but not very succsessfull
//
//
//      Jan 2003
//        2.0b : After long time but this time everything is done for XPDE Calculator
//               - Everything from internal types to methods completly rewritten
//               - Every byte holds one digit in String types
//               - Very slow
//
//      Feb 2003
//        2.01b : Now Multiplications are very fast and Division method completly
//                 rewriiten
//               - Rewritten for support of Dynamic arrays
//               - Support for negative numbers
//               - Support for negative Exponents
//               - Now numbers are hold as Scientific notation
//
//      Feb 2003
//        2.02b : TaylorLn and TaylorExp added but very slow
//                - Again lots of fixups and optimizations but still lotta bugs
//
//
//      April 2003
//        3.0a  : Very Fast Taylor and Newton equatons (compare to previous ones)
//               - Now every byte hold two digits
//               - Lots of functions added
//               - Trigonometric functions added
//               - Lots of Optimizations
//               - Lots of bug fixes
//
//      May 2003
//         3.1a  : Added support for nonlimited digits numbers (not fully developed)
//                - "SetEqual" and "SetNumber" are combined in "Assign" method
//                - Small but important fixups in Division
//                - Ln and Exp is finally fast but still requires some little more
//                   optimizations
//                - Trigonimetric functions with soppurt of different Angle types
//                - Hyperbolic Trigonometric functions added
//                - Reverse Trigonometric functions added
//                - Guassien 3 Point Integral added for any function
//                - 5 Exceptional classes added
//                - Good error handling with Messages
//                - Rounding capabilities
//                - SQRT and LOG functions added
//
//
//  27  May 2003
//        3.101a  : Taylor Series are now 10% faster than before
//                - "Assign" method now got options for better assigning
//
//  1  June 2003
//        3.11a  : Logical Operators are Added
//
//  BUGS :
//         - Some functions have to change to procedures (making try exception statements
//             hard to define and somewheres code is not clear)
//         - Problems with Assigning
//         - bugs in  Nonlimited Digits numbers
//         
//
//
//
//  TODO :
//         - Clearifying code
//         - Support for Rational Numbers
//         - Remove HardCoded Numbers like Ln10 and Pi to support digits more than
//             what is declared
//         - Optimization for support of bigger digits
//         - Change internal Structures to IEEE Floating Point Numbers (????)
//         - Make internal structure numbers bigger (any gain in speed ???)
//
unit BigNumber;
{$o-}

// b+5 converted to b in setfloatdigits and its related problems
// precision working?!!

interface
uses SysUtils,Types,math;

const
NoFloatLimit=-1;
MaxDivDigits=60;
DefFloatDig=20;
DigPerNum=2;
DigPerNumMax=100;
InvalidInputErrorStr='Invalid function input';
DivisionByZeroErrorStr='Divion by zero';
UndefinedErrorStr='Result of function is undefined';
ConversionError='Error in converting to number'; 

asTheSign=1;
asExponent=2;
asFloatDigits=4;
asNumber=8;
asAngle=16;
asIndexAdd=32;
asAll=asTheSign or asExponent or asFloatDigits or asNumber or asAngle or asIndexAdd;
asTheNumber=asNumber or asExponent or asTheSign;
asAllButAngle=asAll xor asAngle;
asAllButIndexAdd=asAll xor asIndexAdd;
asAllButNumber=asAll xor asNumber;
asAllButFloatAngle=asAll xor asFloatDigits xor asAngle;
asAllButFloatDigits=asAll xor asFloatDigits;

type
AngleKind=(Degrees,Radians,Grads);
SignIndicator=(Zero=0,Positive=1,Negative=2);
NumberType=Byte;
NumberArray=Array of NumberType;
BitWiseArray=Array of Cardinal;
OneDigit=0..9;

ENumberConversionError=Class(Exception);
ENumberOverFlowError=Class(Exception);
ENumberDivisonByZeroError=Class(Exception);
ENumberInvalidInputError=Class(Exception);
ENumberUnknownError=Class(Exception);

PNumber=^TNumber;
FXFunction=procedure(X,Res: PNumber);

TNumber=Class
//   public
   private
     FSign : SignIndicator;
     FExponent : Longint;
     FNum : NumberArray;
     FIndexAdd : Longint;
     FNumHigh : Longint;
     FFloatDigits : Longint;
     FSimpleOP :Boolean;
     FAngle :AngleKind;

   function  GetFN(Ind: Longint): NumberType;
   procedure SetFN(Ind: Longint;value: NumberType);
   procedure ShiftRightDigits(Numbers: Byte);
   procedure ShiftLeftDigits(Numbers: Byte);
   procedure ShiftRight(Numbers: Byte);
   procedure ShiftLeft(Numbers: Byte);
   procedure Shift(Numbers: Integer);
   function  GetSign: SignIndicator;
   procedure SetSign(Sgn: SignIndicator);
   function  GetExponent: LongInt;
   procedure SetExponent(Ex: Longint);
   procedure SetNum(Ind: Longint;Num: NumberType);
   function  GetNum(Ind: Longint): NumberType;
   procedure SetNumPos(Ind: Longint;Pos: Shortint;Value: NumberType);
   function  GetNumPos(Ind: Longint;Pos: Shortint): NumberType;
   procedure SetDigValue(Ind: Longint;Value: NumberType);
   function  GetDigValue(Ind: Longint): NumberType;
   procedure SetFloatDigits(b: Longint);
   function  GetFloatDigits: Longint;


  public

     property Angle: AngleKind read FAngle write FAngle;
     property Sign:SignIndicator read GetSign write SetSign;
     property FloatDigits: Longint read GetFloatDigits write SetFloatDigits;
     property Exponent: LongInt read GetExponent write SetExponent;
     property Num[Ind: Longint]: NumberType read GetNum write SetNum;default;
     property NumPos[Ind: Longint;Pos: Shortint]: NumberType read GetNumPos write SetNumPos;
     property Dig[Ind: Longint]: NumberType read GetDigValue write SetDigValue;
     property FN[Ind: Longint]: NumberType read GetFN write SetFN;

     constructor Create;overload;
     constructor Create(b: Extended;FPr: Longint= 20);overload;
     constructor Create(b: String;FPr: Longint= 20);overload;
     constructor Create(b: TNumber;FPr: Longint= 20);overload;
     destructor Destroy;override;
     procedure Assign(Num: TNumber;AssignMode:byte=asAllbutAngle);overload;
     procedure Assign(b: Extended);overload;
     procedure Assign(b: String);overload;
     procedure SetLength(Size: Longint);

     function  GetString(MaxChar: Word):String;
     function  GetFormatString(MaxDig: Word):string;
     function  GetInt64: Int64;
     function  GetExtended: Extended;
     function  GetManitissa: Extended;
     procedure SetManitissa(Man: Extended;Index:Longint=0);

     procedure RoundTo(MaxDig: Longint);overload;
     procedure RoundTo(MaxDig: Longint;var Res: TNumber);overload;
     procedure Int(var Res: TNumber);overload;
     procedure Int;overload;
     procedure Frac(var Res: TNumber);overload;
     procedure Frac;overload;


     function Compare(const b: TNumber):TValueRelationship;
     function AbsCompare(const b: TNumber):TValueRelationship;

     procedure MakeZero;
     procedure MakeOne;
     procedure Correction;
     procedure SwitchSign;

     function IsZero: Boolean;
     function IsOne: Boolean;
     function IsEqualTo(b:OneDigit): Boolean;
     function IsIntegerOdd: Boolean;
     function IsInteger: Boolean;

     procedure IncNumber;
     procedure DecNumber;
     procedure Add(b: TNumber;var Res: TNumber);overload;
     procedure Add(b: TNumber);overload;

     procedure Sub(b: TNumber;var Res: TNumber);overload;
     procedure Sub(b: TNumber);overload;

     procedure Mul(b: TNumber;var Res: TNumber);overload;
     procedure Mul(b: TNumber);overload;

     procedure Divide(b: TNumber;var Res: TNumber);overload;
     procedure Divide(b: TNumber);overload;
     procedure DivInt(b: TNumber;var Res: TNumber);overload;
     procedure DivInt(b: TNumber);overload;
     procedure DivMod(b: TNumber;var Res: TNumber);overload;
     procedure DivMod(b: TNumber);overload;
     procedure DivIntMod(b: TNumber;Var ResDiv,ResMod: TNumber);

     function  BitWiseConvertOut:BitWiseArray;
     procedure BitWiseConvertIn(bitar:BitWiseArray);
     procedure BitWiseAnd(b: TNumber;var Res: TNumber);overload;
     procedure BitWiseAnd(b: TNumber);overload;
     procedure BitWiseOr(b: TNumber;var Res: TNumber);overload;
     procedure BitWiseOr(b: TNumber);overload;
     procedure BitWiseXor(b: TNumber;var Res: TNumber);overload;
     procedure BitWiseXor(b: TNumber);overload;
     procedure BitWiseNot(var Res: TNumber);overload;
     procedure BitWiseNot;overload;
     procedure BitWiseLsh(b: TNumber;var Res: TNumber);overload;
     procedure BitWiseLsh(b: TNumber);overload;
     procedure BitWiseRsh(b: TNumber;var Res: TNumber);overload;
     procedure BitWiseRsh(b: TNumber);overload;



     function  FIntPower(b: TNumber): TNumber;
     procedure IntPower(b: TNumber);overload;
     procedure IntPower(b: TNumber;var Res: TNumber);overload;
     function  Power(b: Longint): TNumber;overload;
     procedure Power(y: TNumber;var Res: TNumber);overload;
     procedure Power(y: TNumber);overload;
     procedure Sqrt(var Res: TNumber);overload;
     procedure Sqrt;overload;

     function  Gause3PointIntegeral(a,b: TNumber;m: Longint;fx: FXFunction): TNumber;

     function  Find2pk_L: Longint;
     function  Find2pk_N: TNumber;

     procedure NewtonInverse(var NumberOut: TNumber);
     procedure Inverse;


     procedure Factoriel(a: Word);overload;
     procedure Factoriel;overload;
     procedure Factoriel(var Res: TNumber);overload;
     function  FFactoriel: TNumber;

     procedure AngleToRadian;overload;
     procedure AngleToRadian(var Res: TNumber);overload;
     procedure RadianToAngle;overload;
     procedure RadianToAngle(var Res: TNumber);overload;


     procedure TaylorSin(var Res: TNumber);
     procedure Sin(var Res: TNumber);overload;
     procedure Sin;overload;
     procedure Sinh(var Res: TNumber);overload;
     procedure Sinh;overload;

     procedure TaylorCos(var Res: TNumber);
     procedure Cos(var Res: TNumber);overload;
     procedure Cos;overload;
     procedure Cosh(var Res: TNumber);overload;
     procedure Cosh;overload;

     procedure Tan(var Res: TNumber);overload;
     procedure Tan;overload;
     procedure Tanh(var Res: TNumber);overload;
     procedure Tanh;overload;

     procedure TaylorArcTan(var Res: TNumber);overload;
     procedure ArcTan(var Res: TNumber);overload;
     procedure ArcTan;overload;
     procedure ArcTanh(var Res: TNumber);overload;
     procedure ArcTanh;overload;

     procedure TaylorArcSin(var Res: TNumber);overload;
     procedure NewtonArcSin(var Res: TNumber);overload;
     procedure ArcSin(var Res: TNumber);overload;
     procedure ArcSin;overload;
     procedure ArcSinh(var Res: TNumber);overload;
     procedure ArcSinh;overload;

     procedure ArcCos(var Res: TNumber);overload;
     procedure ArcCos;overload;
     procedure ArcCosh(var Res: TNumber);overload;
     procedure ArcCosh;overload;

     procedure TaylorLn(var Res: TNumber);
     procedure ArgumentReductionLn(var Res: TNumber);
     procedure InverseExpLn(var Res: TNumber);
     procedure PadeLn(var Res: TNumber);
     procedure Ln(var Res: TNumber);overload;
     procedure Ln;overload;
     procedure Log(var Res: TNumber);overload;
     procedure Log;overload;

     procedure TaylorExp(var Res: TNumber);
     procedure Exp(var Res: TNumber);overload;
     procedure Exp;overload;
end;



var
Ln10,Pi,Pi2,Pion2,Four,Three,Two,One: TNumber;

implementation

const
PLn10= 2.302585;
PLn2= 0.693147;
PLn10onLn2= 3.3119281;


constructor TNumber.Create;
begin
 inherited;
  FSimpleOP := false;
  FNumHigh := -1;
  FFloatDigits := DefFloatDig;
  FAngle := Radians;
  MakeZero;
end;



constructor TNumber.Create(b:extended;FPr: Longint=DefFloatDig);
begin
  Create;
  FFloatDigits := FPr;
  Assign(b);
end;



constructor TNumber.Create(b:string;FPr: Longint = DefFloatDig);
begin
  Create;
  FFloatDigits := FPr;
  if b <> '' then
    Assign(b);
end;


constructor TNumber.Create(b: TNumber;FPr: Longint = DefFloatDig);
begin
  Create;
  FFloatDigits := FPr;
  Assign(b);
end;


procedure TNumber.SetLength(Size: Longint);
begin
  if Size - 1 = FNumHigh then
    Exit;
  System.SetLength(FNum, Size);
  FNumHigh := Size - 1;
end;



function  TNumber.GetString(MaxChar: Word):String;
var
l: Longint;
begin
  Result := Chr(FNum[0] div 10+byte('0'))+'.'+Chr(FNum[0] mod 10+byte('0'));
  for l := 1 to FNumHigh do
    begin
      Result := Result + Chr(FNum[l] div 10 + byte('0'));
      Result := Result + Chr(FNum[l] mod 10 + byte('0'));
    end;
  if (((FNumHigh + 1) * DigPerNum - 1) > FExponent) then
  if Result[Length(Result)] = '0' then delete(Result, Length(Result), 1);
  if Result[Length(Result)] = '.' then delete(Result, Length(Result), 1);
  if Length(Result) > MaxChar then       
    Delete(Result,MaxChar,Length(Result));
  Result := Result + 'e' + IntToStr(FExponent);
  if FSign = Negative then
    Result := '-' + Result;
end;




function TNumber.GetFormatString(MaxDig: Word):string;
var
s:string;
tmp: TNumber;
begin
  tmp := TNumber.Create(self, FFloatDigits);
  try
    tmp.RoundTo(MaxDig - 1);
    Result := tmp.GetString(Maxdig);
    if Pos('-',Result)=1 then
      delete(Result,1,1);

    if (tmp.FNumHigh + 1) * DigPerNum > MaxDig then
      exit;
    if tmp.Fexponent>0 then
      if 2 * tmp.FExponent - (tmp.FNumHigh + 1) * DigPerNum > MaxDig then
        Exit
      else
     else
    if abs(tmp.FExponent) - 1 + (tmp.FNumHigh + 1) * DigPerNum > MaxDig then
      exit;

   //delete exponent
   delete(Result, Pos('e', Result), Length(Result));
   // delete .
   if pos('.', Result) <> 0 then
     delete(Result, 2, 1);
   if tmp.FExponent >= 0 then
     begin
     if 2+tmp.FExponent <= Length(Result) then
       Insert('.', Result, 2 + tmp.FExponent)
      else
     Result := Result + StringofChar('0', tmp.FExponent - Length(Result) + 1);
  end
   else
  begin
    s := StringofChar('0', -tmp.FExponent - 1);
    Result := '0.' + s + Result;
    if Length(s)>MaxDig then
      begin
        Result := tmp.GetString(MaxDig);
        Exit;
      end;
  end;
  if Result[1] = '.' then
    Result := '0' + Result;

  if Result[Length(Result)] = '.' then
    Delete(Result, Length(Result), 1);

  if Result = '00' then
    Result:='0';

  if tmp.FSign = Negative then
    Result := '-' + Result;

  finally
    tmp.Destroy;
end;end;




function  TNumber.GetInt64:Int64;
var
tmp: TNumber;
cmp:TValueRelationship;
begin
  tmp := TNumber.Create('');
   try
     Result := 0;
     int(tmp);
     cmp := TNumber.Create('9223372036854775807').AbsCompare(tmp);
     if cmp=LessThanValue then
       exit;
     //Result := round(StrtoFloat(tmp.GetString(30)));
     Result := Trunc(StrtoFloat(tmp.GetString(30)));
   finally
     tmp.Destroy;
end;end;




function  TNumber.GetExtended:Extended;
var
cmp:TValueRelationship;
begin
  Result := 0;
  cmp := TNumber.Create('1.1e4932').AbsCompare(self);
  if cmp=LessThanValue then
    exit;
  Result := StrtoFloat(GetString(13));
end;


function  TNumber.GetManitissa:Extended;
var
b:byte;
begin
  Result := FNum[0];
  for b:=1 to 4 do
    begin
      Result:=Result * DigPerNumMax;
      if b <= FNumHigh then
        Result:= Result + FNum[b];
    end;
  Result := Result /1000000000;
end;



procedure TNumber.SetManitissa(Man:Extended;Index: Longint=0);
var
b:Longint;
begin
  if Man>=10 then
    Man:=Man / Math.Power(10, trunc(Log10(Man) + 1));
  for b:=Index to Index + 4 do
    begin
      Man:=Man * DigPerNumMax;
      FNum[b]:=Trunc(Man);
      Man:=System.Frac(Man);
    end;
end;



procedure TNumber.RoundTo(MaxDig: Longint;var Res: TNumber);
begin
  Res.Assign(Self, asAll);
  Res.RoundTo(MaxDig);
end;



procedure TNumber.RoundTo(MaxDig: Longint);
var
i: Longint;
c: Byte;
begin
  dec(MaxDig);// ???????????
  if MaxDig > (FNumHigh + 1) * DigPerNum then
    Exit;
  c := 0;
  for i := FNumHigh downto 0 do
    begin
      FNum[i] := FNum[i] + c;
      if (i + 1) * DigPerNum = MaxDig then
        break;
      if FNum[i] mod 10 >= 5 then
        c := 1
      else
        c := 0;

      FNum[i] := ((FNum[i] div 10) + c) * 10;
      if (i + 1) * DigPerNum - 1 = MaxDig then
        break;
      if FNum[i] div 10 >= 5 then
        c := 1
      else
        c := 0;
      FNum[i] := 0;
    end;
  Correction;
  c := 0;

  for i := FNumHigh downto 0 do
    begin
      //if i <> 0 then
      FNum[i] := FNum[i] + c;
      if FNum[i] div 100 > 0 then
        c := 1
      else
        c := 0;
      if i = 0 then
        begin
          FNum[0] := (FNum[0] div 100) * 10 + (FNum[0] mod 100);
          Break;
        end;
      FNum[i] := FNum[i] mod 100
    end;
  Correction;
  if c>0 then
  FExponent := FExponent + 1;
end;





procedure TNumber.Int(var Res: TNumber);
var
i: Longint;
begin
  Res.Assign(self, asAll);
  if FExponent >= (FNumHigh + 1) * DigPerNum - 1 then exit;
  for i := Res.FNumHigh downto 0 do
    begin
      if FExponent + 1 = (i + 1) * DigPerNum then break;
      Res.FNum[i] := (Res.FNum[i] div 10) * 10;
      if Res.FExponent + 1 = (i + 1) * DigPerNum - 1 then break;
      Res.FNum[i] := 0;
    end;
  Res.Correction;
end;









procedure TNumber.AngleToRadian;
var
tmp: TNumber;
b: Word;
begin
  if FAngle = Degrees then
    b := 180
  else
  if FAngle = Grads then
    b := 400
  else
    exit;
  tmp := TNumber.Create(b);
 try
  Mul(Pi);
  Divide(tmp);
 finally
  tmp.Destroy;
end;end;




procedure TNumber.AngleToRadian(var Res: TNumber);
var
tmp: TNumber;
b: Word;
begin
  Res.Assign(Self);
  if Res.FAngle = Degrees then
    b := 180
  else
    if Res.FAngle = Grads then
      b := 400
  else
    exit;
  tmp := TNumber.Create(b);
 try
  Res.Mul(Pi);
  Res.Divide(tmp);
 finally
  tmp.Destroy;
end;end;




procedure TNumber.RadianToAngle;
var
tmp: TNumber;
b: Word;
begin
  if FAngle = Degrees then
    b := 180
 else
  if FAngle = Grads then
    b := 400
 else
   exit;
  tmp := TNumber.Create(b);
 try
  Divide(Pi);
  Mul(tmp);
 finally
  tmp.Destroy;
end;end;



procedure TNumber.RadianToAngle(var Res: TNumber);
var
tmp: TNumber;
b: Word;
begin
  Res.Assign(Self);
  if Res.FAngle = Degrees then
    b := 180
 else
  if Res.FAngle = Grads then
    b := 400
 else
    exit;
  tmp := TNumber.Create(b);
 try
  Res.divide(Pi);
  Res.Mul(tmp);
 finally
  tmp.Destroy;
end;end;




procedure TNumber.Assign(Num: TNumber;AssignMode:byte=asAllbutAngle);
begin
  if AssignMode and asNumber = asNumber then
    begin SetLength(0);FNum := Copy(Num.FNum);FNumHigh := Num.FNumHigh;end;

  if AssignMode and asExponent = asExponent then
    FExponent := Num.FExponent;

  if AssignMode and asTheSign = asTheSign then
    FSign := Num.FSign;

  if AssignMode and asIndexAdd = asIndexAdd then
    FIndexAdd := Num.FIndexAdd;

  if AssignMode and asFloatDigits = asFloatDigits then
    FFloatDigits := Num.FFloatDigits;

  if AssignMode and asAngle = asAngle then
    FAngle := Num.FAngle;

  if (AssignMode and asFloatDigits <> asFloatDigits) and
     (AssignMode and asNumber = asNumber) then
   Correction;
end;



procedure TNumber.MakeZero;
begin
  SetLength(1);
  FNum[0] := 0;
  Exponent := 0;
  Sign := Zero;
  FIndexAdd := 0;
end;


procedure TNumber.MakeOne;
begin
  SetLength(1);
  FNum[0] := 10;
  Exponent := 0;
  Sign := Positive;
  FIndexAdd := 0;
end;



procedure TNumber.Assign(b:Extended);
begin
  Assign(FloatToStr(b));
end;




procedure TNumber.Assign(b:string);
var
i,w: Word;
begin
  if Pos('e', b) = Length(b) then
    b := b + '0';
  Sign := Positive;
  if Pos('-', b) = 1 then
    begin Sign := Negative;Delete(b, 1, 1);end;
  if Pos('+', b) = 1 then
    Delete(b,1,1);
  b := UpperCase(b);
  FExponent := 0;

  if pos('E',b)  <>  0 then
    begin
      FExponent := StrToInt(Copy(b, Pos('E', b) + 1, Length(b)));
      Delete(b, Pos('E', b), Length(b));
    end;

  if Pos('.',b) = 0 then
     b := b+'.0';

  FExponent := FExponent + Pos('.', b) - 2;
  Delete(b, Pos('.', b), 1);

  if Length(b) mod DigPerNum=0 then
    SetLength(Length(b) div DigPerNum )
  else
    SetLength(Length(b) div DigPerNum + 1 );

  for i := 0 to length(b)-1 do
    begin
      if not ( b[i+1] in ['0'..'9']) then
        raise ENumberConversionError.Create(ConversionError);
      W := (byte(b[i+1]) - $30) ;
      if i mod DigPerNum=0 then
        FNum[i div DigPerNum] := W
      else
      FNum[i div DigPerNum] := FNum[i  div DigPerNum] * 10 + W;
    end;

  if FNumHigh * DigPerNum - 1 > FloatDigits then
    SetFloatDigits(FNumHigh * DigPerNum - 1);

  Correction;
end;




destructor TNumber.Destroy;
begin
  System.SetLength(FNum,0);
  inherited;
end;





function  TNumber.GetFN(Ind: Longint): NumberType;
begin
  Result := 0;
  if (Ind > FNumHigh) then Result := 0
 else
  if Ind >= 0 then
  Result := FNum[Ind];
end;



procedure TNumber.SetFN(Ind: Longint;Value: NumberType);
begin
  if (Ind > FNumHigh) then exit
 else
  if Ind >= 0 then
    FNum[Ind] := Value;
end;


procedure TNumber.SetDigValue(Ind: Longint;Value: NumberType);
begin
  FNum[FNumHigh - Ind] := Value;
end;



function  TNumber.GetDigValue(Ind: Longint): NumberType;
begin
  if Ind > FNumHigh then Result := 0
 else
  Result := FNum[FNumHigh - Ind];
end;



procedure TNumber.SetNumPos(Ind: Longint;Pos: Shortint;Value: NumberType);
var
b,i: Shortint;
rs,k: NumberType;
begin
  if Pos = -1 then
    FNum[Ind] := Value
 else
   begin
     b:=0;
     rs := FNum[Ind];
     while rs <> 0 do begin inc(b);rs := rs div 10;end;
     rs := FNum[Ind];
     if Pos >= b then repeat inc(b);rs := rs * 10; until b = pos + 1;
     Inc(Pos);
     k := 1;
     for i := 1 to b - Pos do k := k * 10;
     FNum[Ind]:=rs- ((rs div k) mod 10) * k + Value * k;
   end;
end;



function  TNumber.GetNumPos(Ind: Longint;Pos: Shortint): NumberType;
var
b,i: Shortint;
rs,k: NumberType;
begin
  if (Ind > FNumHigh) or (Ind < 0) then Result := 0
 else
  if Pos <> -1 then
    begin
      b := 0;
      rs := FNum[Ind];
      while rs <> 0 do begin inc(b);rs := rs div 10;end;
      Inc(pos);
      if Pos > b then begin Result := 0;exit;end;
      k:=1;
      for i := 1 to b - pos do k := k * 10;
        Result:=(FNum[Ind] div k) mod 10;
    end
   else
    Result := FNum[Ind];
end;




procedure TNumber.SetNum(Ind: Longint;Num: NumberType);
var
tmp:Longint;
begin
  if Ind > FNumHigh + FIndexAdd then
    Raise ENumberUnknownError.Create('')
 else
   begin
     if FIndexAdd = 0 then FNum[Ind] := Num
    else
     if Ind < FIndexAdd then
    else
      begin
        tmp := Ind - FIndexAdd;
        if odd(FIndexAdd) then
          begin
            FNum[tmp] := Num mod 10;
            FNum[tmp + 1] := Num div 10;
          end
      else
       FNum[tmp] := Num;
    end;
  end;
end;





function  TNumber.GetNum(Ind: Longint): NumberType;
var
tmp:Longint;
begin
  if Ind > FNumHigh + FIndexAdd then Result := 0
 else
   begin
     if FIndexAdd = 0 then Result := FNum[Ind]
    else
     if Ind < FIndexAdd div DigPerNum then Result := 0
    else
      begin
        tmp:=Ind - FIndexAdd div DigPerNum;
        if odd(FIndexAdd) then
          Result := (FN[tmp-1] mod 10) * 10 + (FN[tmp] div 10)
       else
          Result := FN[tmp];
      end;
   end;
end;




function TNumber.GetSign:SignIndicator;
begin
  Result := FSign;
end;

procedure TNumber.SetSign(sgn:SignIndicator);
begin
  FSign := sgn;
end;

function TNumber.GetExponent: Longint;
begin
  Result := FExponent;
end;

procedure TNumber.SetExponent(Ex: Longint);
begin
  FExponent := Ex;
end;




//problems??
procedure TNumber.ShiftRightDigits(Numbers: Byte);
var
i: Word;
begin
  Setlength(FNumHigh + 1 + ((Numbers - 1) div 2 + 1) );//???????????
  if not odd(Numbers) then
    for i := FNumHigh downto 0 do
      if i-Numbers div 2 >= 0 then
        FNum[i] := FN[i - Numbers div 2]
      else
        FNum[i] := 0
     else
      for i := FNumHigh downto 0 do
        if i-Numbers div 2 >= 0 then
          FNum[i] := (FN[i - Numbers div 2 - 1] mod 10) * 10 + FN[i - Numbers div 2] div 10
       else
          FNum[i] := 0
end;





//?????????????
procedure TNumber.ShiftLeftDigits(Numbers: Byte);
var
i: Word;
begin

if not odd(Numbers) then
for i := 0 to FNumHigh do
    if i + Numbers div 2  <=  FNumHigh then
    FNum[i] := FN[i+Numbers div 2]
    else
    FNum[i] := 0
else
for i := 0 to FNumHigh do
    if i + Numbers div 2  <=  FNumHigh then
    FNum[i] := (FN[i + Numbers div 2] mod 10) * 10 + FN[i + Numbers div 2 + 1] div 10
    else
    FNum[i] := 0;
Setlength(FNumHigh + 1 - ((Numbers - 1) div 2) );//???????????????????
end;





procedure TNumber.ShiftRight(Numbers: Byte);
begin
FIndexAdd := FIndexAdd + Numbers;
FExponent := FExponent + FIndexAdd;
end;



procedure TNumber.ShiftLeft(Numbers: Byte);
begin
FIndexAdd := FIndexAdd - Numbers;
FExponent := FExponent + FIndexAdd;
end;





procedure TNumber.Shift(Numbers:integer);
begin
if Numbers > 0 then ShiftRight(Numbers)
else if Numbers < 0 then ShiftLeft(-Numbers)
else
begin
FExponent := FExponent - FIndexAdd;
FIndexAdd := 0;
end;
end;




function TNumber.IsZero:Boolean;
begin
if FSign=Zero then Result := true
else
if FNum[0] = 0 then begin Result := true;if FNumHigh > 1 then assert(false); end
else Result := false;
end;





function TNumber.IsOne:Boolean;
begin
if FSign=Zero then Result := false
else
if FSign=Negative then Result := false
else
if (FNum[0] = 1 * DigPerNumMax div 10) and (FExponent = 0) and (FNumHigh = 0) then Result := true
else Result := false;
end;




function TNumber.IsEqualTo(b:OneDigit):Boolean;
begin
if b=0 then Result := IsZero
else
if FSign = Zero then Result := false
else
if FSign = Negative then Result := false
else
if (FNum[0] = b * DigPerNumMax div 10) and (FExponent = 0) and (FNumHigh = 0) then
 Result := true
else
 Result := false;
end;



function TNumber.IsInteger:Boolean;
begin
Result := false;
if FExponent >= (FNumHigh + 1) * DigPerNum - 1 then Result := true
else
if FExponent=(FNumHigh + 1) * DigPerNum - 2 then
   if  FNum[FNumHigh] mod 10 = 0 then Result := true;
end;



// meaningless for reals
function TNumber.IsIntegerOdd:Boolean;
begin
if (FNumHigh + 1) * DigPerNum - 1 = FExponent then
Result := Odd(FNum[FNumHigh])
else
if FExponent > (FNumHigh + 1) * DigPerNum - 1 then
Result := false
else
Result := Odd(FNum[FNumHigh] div (DigPerNumMax div 10))
end;


procedure TNumber.SetFloatDigits(b: Longint);
begin
  FFloatDigits := b;
  Correction;
end;



function TNumber.GetFloatDigits: Longint;
begin
  if FFloatDigits <> NoFloatLimit then
    Result := FFloatDigits
  else
    Result := MaxDivDigits;
end;




procedure TNumber.SwitchSign;
begin
  if FSign = Zero then exit;
  if FSign = Negative then
    FSign := Positive
  else
    FSign := Negative;
end;






procedure TNumber.Correction;
var
dc,i: Word;
begin
dc := 0;
for i := 0 to FNumHigh do
begin
if FNum[i] div 10 = 0 then Inc(dc)
else break;
if FNum[i] mod 10 = 0 then Inc(dc)
else break;
if FNum[i] <> 0 then break;
end;

if (dc <> 0)then
begin
ShiftLeftDigits(dc);
FExponent := FExponent - dc;
end;

dc := 0;
for i := FNumHigh downto 0 do
if FNum[i] = 0 then inc(dc) else break;

if (dc <> 0) then
     SetLength(FNumHigh + 1 - dc);

if FNum=Nil then
begin
FExponent := 0;FSign := Zero;Setlength(1);
end;

if FFloatDigits = NoFloatLimit then exit;
if FNumHigh * DigPerNum - 1 > FFloatDigits then
SetLength(FFloatDigits div DigPerNum + 1);
end;






// two numbers MUST be corrected before calling this
function TNumber.Compare(const b: TNumber):TValueRelationship;
var
i,  MinNum: Longint;
begin
Result := EqualsValue;

if (FSign = b.FSign) then {+ + or - -}
begin
 if FExponent <> b.FExponent then
       if FExponent > b.FExponent then
          begin if FSign = Positive then Result := GreaterThanValue else Result := LessThanValue end
             else
                begin if FSign = Positive then Result := LessThanValue else Result := GreaterThanValue end
 else//FExp=b.Fexp
   begin

    if FNumHigh > b.FNumHigh then
        MinNum := b.FNumHigh
    else
        MinNum := FNumHigh;

   for i := 0 to MinNum do
     if Fnum[i] > b.Fnum[i] then
       begin if FSign = Positive then Result := GreaterThanValue else Result := LessThanValue;break end
            else
        if Fnum[i] < b.Fnum[i] then
           begin if FSign = Positive then Result := LessThanValue else Result := GreaterThanValue;break;end;

   if b.FNumHigh = FNumHigh then exit;
   if Result = EqualsValue then
    if b.FNumHigh = MinNum then begin Result := GreaterThanValue; exit; end
    else
   begin Result := LessThanValue; exit; end

  end
end

else
if (FSign = Positive) then{a=+ b=-}
Result := GreaterThanValue
  else {a=- b=+}
  Result := LessThanValue;
end;









// two numbers MUST be corrected before calling this
function TNumber.AbsCompare(const b: TNumber):TValueRelationship;
var
i, MinNum: Longint;
begin
Result := EqualsValue;

 if FExponent <> b.FExponent then
       if FExponent>b.FExponent then
           Result := GreaterThanValue
             else
                Result := LessThanValue
 else//FExp=b.Fexp
   begin
    if FNumHigh > b.FNumHigh then
        MinNum := b.FNumHigh
   else
        MinNum := FNumHigh;


   for i := 0 to MinNum do
     if Fnum[i] > b.Fnum[i] then
       Begin Result := GreaterThanValue;break end
            else
        if Fnum[i] < b.Fnum[i] then
           begin Result := LessThanValue ;break;end;

   if b.FNumHigh = FNumHigh then exit;
   if Result = EqualsValue then
    if b.FNumHigh = MinNum then begin Result := GreaterThanValue; exit; end
    else
   begin Result := LessThanValue; exit; end


   end;
end;








// omptimized
procedure TNumber.IncNumber;
begin
  Add(one);
end;



// omptimized
procedure TNumber.DecNumber;
begin
  Sub(One);
end;






procedure TNumber.Add(b: TNumber;var Res: TNumber);
var
rs,bn,i: Word;
CR: Byte;
begin

if b.IsZero then begin Res.Assign(self, asAllbutFloatAngle);exit;end;
if   IsZero then begin Res.Assign(b, asAllbutFloatAngle);exit;end;

if not FSimpleOP then
begin
   if (FSign <> Positive) and (b.FSign <> Positive) then {- -}
    begin
     FSign := Positive;b.FSign := Positive;FSimpleOP := true;
     add(b,res);
     FSign := Negative;b.FSign := Negative;Res.FSign := Negative;exit;
    end
else if FSign <> b.FSign then
       if FSign = Positive then{+ -}
         begin b.FSign := Positive;Sub(b, res);b.FSign := Negative;exit;end
        else{- +}
         begin FSign := Positive;b.Sub(self, res);FSign := Negative;exit;end;
end else FSimpleOP := false;


Res.FSign := Positive;

if FExponent <> b.FExponent then
   if FExponent > b.FExponent then
      b.Shift(FExponent - b.FExponent)
   else
      Shift(b.FExponent - FExponent);

if FNumHigh + FIndexAdd > b.FNumHigh + b.FIndexAdd then
   bn := FNumHigh + FIndexAdd
else
   bn := b.FNumHigh + b.FIndexAdd;

Res.SetLength(bn + 1);
Res.FExponent := FExponent;
CR := 0;

for i := bn downto 0 do
 begin
 rs := Num[i] + b.Num[i] + CR;
 Res[i] := rs mod DigPerNumMax;
 CR := rs div DigPerNumMax;
 end;

if cr > 0 then
begin
Res.ShiftRightDigits(1);
Res[0] := Res[0] + CR * 10;
Res.FExponent := Res.FExponent + CR;
end;

Shift(0);
b.Shift(0);
Res.Correction;
end;
















procedure TNumber.Sub(b: TNumber;var Res: TNumber);
var
bn,i: Word;
CR:shortint;
rs:integer;
cmp:TValueRelationship;
sgntmp:SignIndicator;
begin


Res.MakeZero;Res.FSign := Positive;

if b.IsZero then begin Res.Assign(self, asAllbutFloatAngle);exit;end;
if   IsZero then begin Res.Assign(b, asAllbutFloatAngle);Res.SwitchSign;exit;end;

if not FSimpleOP then
begin
cmp := AbsCompare(b);
sgntmp := FSign;

if FSign = b.FSign then // + +    -  -
case cmp of
EqualsValue:begin Res.Makezero;exit;end;

LessThanValue:
begin
FSign := Positive;b.FSign := Positive;b.FSimpleOP := true;
b.Sub(self,res);
FSign := sgntmp;b.FSign := sgntmp;Res.FSign := Negative;
exit;
end;

GreaterThanValue:
if FSign = Negative then Res.FSign := Negative

end//end case
else
 if  b.FSign = Negative then{+ -}
  begin b.FSign := Positive;FSimpleOP := true;Add(b,res);Res.FSign := Positive;b.FSign := Negative;exit;end
    else{- +}
     begin FSign := Positive;FSimpleOP := true;Add(b,res);FSign := Negative;Res.FSign := Negative;exit;end;

end else FSimpleOP := false;

if FExponent <> b.FExponent then
   if FExponent > b.FExponent then
      b.Shift(FExponent - b.FExponent)
   else
      Shift(b.FExponent - FExponent);

if FNumHigh + FIndexAdd > b.FNumHigh + b.FIndexAdd then
   bn := FNumHigh + FIndexAdd
else
   bn := b.FNumHigh + b.FIndexAdd;

Res.SetLength(bn + 1);
Res.FExponent := FExponent;
CR := 0;

for i := bn downto 0 do
 begin
 rs := Num[i] - b.Num[i] + CR;
 if rs < 0 then
    begin rs := rs + 100;cr := -1;end
 else
    cr := 0;
 Res[i] := rs mod DigPerNumMax;
 end;


Res.Correction;
assert(cr=0);

Shift(0);b.Shift(0);
end;













procedure TNumber.Mul(b: TNumber;var Res: TNumber);
var
rs,i,j: Word;
prev: Byte;
begin

Res.MakeZero;

if b.IsZero then begin Res.MakeZero; exit;end;

if ((FSign=Positive) and  (b.FSign=Positive)) or ((FSign=Negative) and (b.FSign=Negative)) then
Res.FSign := Positive
else
Res.FSign := Negative;

Res.FExponent := FExponent + b.FExponent;
Res.SetLength(FNumHigh + 1 + b.FNumHigh + 1);

prev := 0;
for j := 0 to b.FNumHigh do
for i := 0 to FNumHigh + 1 do
begin
if j = b.FNumHigh then
prev := prev;
rs := b.Dig[j] * Dig[i] + prev + Res.Dig[j + i];
Res.Dig[j + i] := rs mod DigPerNumMax;
prev := rs div DigPerNumMax;
end;

//if Res[0] Div 10 <> 0 then

Res.Correction;
Inc(Res.FExponent);
end;












procedure TNumber.Divide(b: TNumber;var Res: TNumber);
var
Temp: TNumber;
i: Word;
n: Byte;
sgntmp1,sgntmp2:SignIndicator;
begin

if IsZero then
begin
   if b.IsZero then
        Raise ENumberInvalidInputError.Create(UndefinedErrorStr);
 Res.MakeZero;
 exit;
end;

if b.IsZero then
   Raise ENumberDivisonByZeroError.Create(DivisionByZeroErrorStr);


if not FSimpleOP then
 begin

   if b.IsOne then
        begin Res.Assign(Self, asAllButFloatAngle);exit;end;
 end
else FSimpleOP := false;

 Temp := TNumber.Create('', Res.FFloatDigits + 2);
  // ????????
// Res.MakeZero;
 Res.SetLength((Res.FloatDigits + 1) div DigPerNum + 2);
 Temp.SetLength((Res.FloatDigits + 1) div DigPerNum + 2);


if ((FSign=Positive) and  (b.FSign=Positive)) or ((FSign=Negative) and (b.FSign=Negative)) then
Res.FSign := Positive
else
Res.FSign := Negative;

sgntmp1 := FSign;sgntmp2 := b.FSign;
FSign := Positive;b.FSign := Positive;

temp.Assign(Self);
Res.FExponent := temp.FExponent - b.FExponent;
temp.FExponent := b.FExponent;
if temp.AbsCompare(b) = LessThanValue then
   begin Inc(temp.FExponent);Dec(Res.FExponent);end;

for i := 0 to Res.FloatDigits  do
begin
n := 0;
if Temp.Compare(b) <> LessThanValue then
repeat
temp.FSimpleOP := true;
temp.Sub(b);
inc(n);
until  temp.AbsCompare(b) = LessThanValue;

//a.Assign(temp);
temp.FExponent := temp.FExponent + 1;  //*10

if i mod DigPerNum=0 then
   Res.FNum[i div DigPerNum] := n
else
   Res.FNum[i div DigPerNum] := Res.FNum[i  div DigPerNum] * 10 + n;


{if not odd(i) then
Res.FNum[i div 2] := n * 10
else
Res.FNum[i div 2] := Res.FNum[i div 2] + n;}
//if temp.FSign=Zero then break;
if temp.IsZero then break;
end;
while i mod DigPerNum <> 1 do
  begin
  Res.FNum[i div DigPerNum] := Res.FNum[i  div DigPerNum] * 10;
  inc(i);
  end;

FSign := sgntmp1;
b.FSign := sgntmp2;
Res.Correction;
end;









procedure TNumber.DivInt(b: TNumber;var Res: TNumber);
var
cmp:TValueRelationship;
begin
cmp := Compare(b);
if cmp = EqualsValue then begin Res.MakeOne;exit;end;
if cmp = LessThanValue then begin Res.MakeZero;exit;end;
Divide(b, Res);
Res.Int;
end;





procedure TNumber.DivMod(b: TNumber;var Res: TNumber);
var
tmp: TNumber;
cmp:TValueRelationship;
begin
if b.IsZero then
      Raise ENumberInvalidInputError.Create(UndefinedErrorStr);
cmp := Compare(b);
if cmp = EqualsValue then begin Res.MakeZero;exit;end;
if cmp = LessThanValue then begin Res.Assign(Self, asAllButFloatAngle);exit;end;
tmp := TNumber.Create('', Res.FFloatDigits);
Divide(b, tmp);
tmp.Int;
tmp.Mul(b);
Sub(tmp, Res);
end;





procedure TNumber.DivIntMod(b: TNumber;Var ResDiv,ResMod: TNumber);
var
cmp: TValueRelationship;
tmp: TNumber;
begin
if b.IsZero then
      Raise ENumberInvalidInputError.Create(UndefinedErrorStr);

cmp := Compare(b);
if cmp = EqualsValue then
  begin ResMod.MakeZero;ResDiv.MakeOne;exit;end;
if cmp = LessThanValue then
  begin ResMod.Assign(Self, asAllButFloatAngle);ResDiv.MakeZero; exit;end;

tmp := TNumber.Create('', ResMod.FFloatDigits);
try
Divide(b, ResDiv);
ResDiv.Int;
ResDiv.Mul(b,tmp);
Sub(tmp, ResMod);
finally
tmp.Destroy;
end;end;




function TNumber.BitWiseConvertOut:BitWiseArray;
var
bittmp: BitWiseArray;
tmp,base,divint,divmod: TNumber;
i,j: longint;
cmp: TValueRelationship;
begin
divint := TNumber.Create(self, FFloatDigits);
divmod := TNumber.Create('', FFloatDigits);
tmp := TNumber.Create('', FFloatDigits);
base := TNumber.Create('4294967296', FFloatDigits);
try
i:=0;

System.Setlength(bittmp,1);
repeat
divint.DivIntMod(base,tmp,divmod);
bittmp[i]:=divmod.GetInt64;
inc(i);
System.Setlength(bittmp,i+1);
divint.Assign(tmp);
cmp:=divint.Compare(base);
until cmp=LessThanValue;
bittmp[i]:=divint.GetInt64;
if bittmp[i]=0 then dec(i);
System.SetLength(Result,i+1);
for j:=0 to i do
Result[j]:=bittmp[i-j];
finally
divint.Destroy;divmod.Destroy;tmp.Destroy;base.Destroy;bittmp:=nil;
end;end;




procedure TNumber.BitWiseConvertIn(bitar:BitWiseArray);
var
base,tmp,tmp2: TNumber;
i: Longint;
begin
MakeZero;
tmp := TNumber.Create('1', FFloatDigits);
tmp2 := TNumber.Create('', FFloatDigits);
base := TNumber.Create('4294967296', FFloatDigits);
try
for i:=High(bitar) downto 0 do
begin
tmp.Mul(TNumber.Create(bitar[i]),tmp2);
Add(tmp2);
if i<>0 then
tmp.Mul(base);
end;
finally
tmp.Destroy;tmp2.Destroy;base.Destroy;
end;end;





procedure TNumber.BitWiseAnd(b: TNumber;var Res: TNumber);
var
aa,bb,cc:BitWiseArray;
i,ha,hb,hc: Longint;
begin
aa:=BitWiseConvertOut;
bb:=b.BitWiseConvertOut;
ha:=High(aa);hb:=High(bb);
if ha>hb then
System.SetLength(cc,ha+1)
else
System.SetLength(cc,hb+1);
hc:=High(cc);
i:=0;
repeat
if hc-i>=0 then
  if hb-i<0 then
    cc[hc-i]:=aa[ha-i] and 0
   else
     if ha-i<0 then
       cc[hc-i]:=0 and bb[hb-i]
      else
        cc[hc-i]:=aa[ha-i] and bb[hb-i]
 else
   break;

inc(i);
until 1=2;
Res.BitWiseConvertIn(cc);
aa:=nil;bb:=nil;cc:=nil;
end;




procedure TNumber.BitWiseOr(b: TNumber;var Res: TNumber);
var
aa,bb,cc:BitWiseArray;
i,ha,hb,hc: Longint;
begin
aa:=BitWiseConvertOut;
bb:=b.BitWiseConvertOut;
ha:=High(aa);hb:=High(bb);
if ha>hb then
System.SetLength(cc,ha+1)
else
System.SetLength(cc,hb+1);
hc:=High(cc);
i:=0;
repeat
if hc-i>=0 then
  if hb-i<0 then
    cc[hc-i]:=aa[ha-i] or 0
   else
     if ha-i<0 then
       cc[hc-i]:=0 or bb[hb-i]
      else
        cc[hc-i]:=aa[ha-i] or bb[hb-i]
 else
   break;

inc(i);
until 1=2;
Res.BitWiseConvertIn(cc);
aa:=nil;bb:=nil;cc:=nil;
end;





procedure TNumber.BitWiseXor(b: TNumber;var Res: TNumber);
var
aa,bb,cc:BitWiseArray;
i,ha,hb,hc: Longint;
begin
aa:=BitWiseConvertOut;
bb:=b.BitWiseConvertOut;
ha:=High(aa);hb:=High(bb);
if ha>hb then
System.SetLength(cc,ha+1)
else
System.SetLength(cc,hb+1);
hc:=High(cc);
i:=0;
repeat
if hc-i>=0 then
  if hb-i<0 then
    cc[hc-i]:=aa[ha-i] xor 0
   else
     if ha-i<0 then
       cc[hc-i]:=0 xor bb[hb-i]
      else
        cc[hc-i]:=aa[ha-i] xor bb[hb-i]
 else
   break;

inc(i);
until 1=2;
Res.BitWiseConvertIn(cc);
aa:=nil;bb:=nil;cc:=nil;
end;




procedure TNumber.BitWiseLsh(b: TNumber;var Res: TNumber);
var
bb: Int64;
aa,cc:BitWiseArray;
i:integer;
lb:byte;
tmp:cardinal;
begin
if b.IsZero then begin Res.Assign(self); exit; end;
bb:=b.GetInt64;
lb:=bb mod 32;
if (bb=0) or (bb>65535) then
   Raise ENumberInvalidInputError.Create(InvalidInputErrorStr);
aa:=BitWiseConvertOut;
System.SetLength(cc,(High(aa)+1)+bb div 32 + 1);

for i:=0 to High(aa) do
cc[i+1]:=aa[i];

tmp:=0;
for i:=high(aa) downto 0 do
begin
cc[i+1]:=cc[i+1] or tmp;
tmp:=cc[i+1] shr (32-lb);
cc[i+1]:=cc[i+1] shl lb;
end;
cc[0]:=tmp;
Res.BitWiseConvertIn(cc);
aa:=nil;cc:=nil;
end;




procedure TNumber.BitWiseRsh(b: TNumber;var Res: TNumber);
var
bb: Int64;
aa,cc:BitWiseArray;
i:integer;
rb:byte;
tmp:cardinal;
hc,ha:longint;
begin
if b.IsZero then begin Res.Assign(self); exit; end;
bb:=b.GetInt64;
rb:=bb mod 32;

if (bb=0) or (bb>65535) then
   Raise ENumberInvalidInputError.Create(InvalidInputErrorStr);
aa:=BitWiseConvertOut;
ha:=High(aa);
if bb div 32 <= ha + 1  then
System.SetLength(cc,(ha+1)-bb div 32)
else
begin
Res.MakeZero;exit;
end;
hc:=high(cc);
for i:=0 to hc do
cc[i]:=aa[i];

tmp:=0;
for i:=0 to hc do
begin
cc[i]:=cc[i] or tmp;
tmp:=(cc[i] shl (32-rb)) shr (32-rb);
cc[i]:=cc[i] shr rb;
end;
Res.BitWiseConvertIn(cc);
aa:=nil;cc:=nil;
end;





procedure TNumber.BitWiseNot(var Res: TNumber);
begin
Res.assign(Self);
Res.Add(one);
Res.SwitchSign
end;





procedure TNumber.NewtonInverse(var NumberOut: TNumber);
var
xn,tmp,tmp2: TNumber;
i: Word;
x0:double;
expbak: Longint;
sgnbak:SignIndicator;
begin
NumberOut.MakeZero;
x0 := (FNum[0] div 10)+(FNum[0] mod 10)*0.1+(FN[1] div 10)*0.01+(FN[1] mod 10)*0.001;
x0 := 1/x0;
xn := TNumber.Create(x0, NumberOut.FFloatDigits);
tmp2 := TNumber.Create(0, NumberOut.FFloatDigits);
tmp := TNumber.Create(0, NumberOut.FFloatDigits);
expbak := FExponent;sgnbak := FSign;
FExponent := 0;SetSign(Positive);

i:=xn.FNumHigh * DigPerNum;
repeat
Mul(xn, tmp);
two.Sub(tmp, tmp2);
tmp2.Mul(xn, tmp);
xn.Assign(tmp, asAllButFloatAngle);
i:=i*2;
until i>NumberOut.FFloatDigits;

FExponent := expbak;FSign := sgnbak;
tmp.MakeOne;
tmp.FExponent := -expbak;
if expbak <> 0 then
tmp.Mul(xn,NumberOut)
else
NumberOut.Assign(xn, asAllButFloatAngle);
end;










procedure TNumber.Sqrt(var Res: TNumber);
var
tmp2,tmp1,tmp,x,m: TNumber;
i,n: Word;
cmp:TValueRelationship;
begin
if FSign=Negative then
   Raise ENumberInvalidInputError.Create(InvalidInputErrorStr);
if (IsZero) or (IsOne) then
begin Res.Assign(self, asAllButFloatAngle);exit;end;

tmp := TNumber.Create('', Res.FFloatDigits);
tmp1 := TNumber.Create('', Res.FFloatDigits);

if (abs(FExponent) > 2) then
begin
tmp.Assign(self,asTheNumber or asFloatDigits);
tmp.FExponent := FExponent mod 2;
tmp.Sqrt(Res);
Res.FExponent := Res.FExponent + FExponent div 2;
exit;
end;

cmp := one.Compare(Self);
if cmp=LessThanValue then  // self > 1
begin
m := Find2pk_N;
m.IncNumber;
m.Divide(two);
m.Int;
tmp.Assign('4');
m.SetSign(Negative);
x := tmp.FIntPower(m);
x.Mul(self);
m.SetSign(Positive);

end
else // self < 1
begin
one.Divide(four,tmp);
cmp := tmp.Compare(self);
x := TNumber.Create(self, FFloatDigits);
m := TNumber.Create('0');

if cmp = GreaterThanValue then //self <1/4
begin

repeat
m.DecNumber;
tmp2 := tmp.FIntPower(m);
x.Mul(tmp2, tmp1);
cmp := tmp.Compare(tmp1);
tmp2.Destroy;
until cmp=LessThanValue;
x.Assign(tmp1);

end;

end;

Res.Assign(x, asTheNumber);
Res.Mul(two);
Res.Add(one);
Res.Divide(three);
n := Round(System.Ln(Res.FloatDigits * PLn10onLn2) / PLn2) + 1;

for i := 1 to n do
begin
Res.Mul(two, tmp);
x.Divide(tmp, tmp1);
Res.Divide(two, tmp);
tmp1.Add(tmp, res);
end;

//m.SetSign(Positive);
two.IntPower(m, tmp);
Res.Mul(tmp);
end;





procedure TNumber.Power(y: TNumber;var Res: TNumber);
var
tmp: TNumber;
begin
if y.IsInteger then
begin IntPower(y, res);exit;end;
tmp := TNumber.Create('', Res.FFloatDigits);
try
ln(tmp);
tmp.Mul(y);
tmp.Exp(Res);
finally
tmp.Destroy;
end;end;






function TNumber.Power(b: Longint): TNumber;
var
selftmp,tmp: TNumber;
t: Longint;
begin

selftmp := nil;tmp := nil;
if b < 0 then
begin selftmp := TNumber.Create(self, FFloatDigits);Inverse;b := -b;end;

try
Result := TNumber.Create(self);

if b = 0 then
begin Result.MakeOne;exit;end;

if b = 1 then
  exit
else
  if abs(b) = 2  then
 begin
  Result.Mul(self);
  exit;
 end;

tmp := TNumber.Create('', FFloatDigits);

if Odd(b) then
 t := b - 1
else
t := b;

t := t div 2;
tmp.Assign(Power(t));
tmp.Mul(tmp);

if Odd(b) then
tmp.Mul(self);

Result.Assign(tmp);

finally
if assigned(selftmp) then
Assign(selftmp);
if assigned(tmp) then
tmp.Destroy;
end;end;







procedure TNumber.IntPower(b: TNumber);
var
tmp: TNumber;
begin
tmp := FIntPower(b);
Assign(tmp, asAllButFloatAngle);
tmp.Destroy;
end;




procedure TNumber.IntPower(b: TNumber;var Res: TNumber);
var
tmp: TNumber;
begin
tmp := FIntPower(b);
Res.Assign(tmp, asAllButFloatAngle);
tmp.Destroy;
end;




//dont remove this two must be!!!
function TNumber.FIntPower(b: TNumber): TNumber;
var
two,selftmp,tmp,tmp2: TNumber;
begin
tmp := nil;tmp2 := nil;selftmp := nil;
two := TNumber.Create('2');

if b.FSign=Negative then
begin
selftmp := TNumber.Create(self, FFloatDigits);
Inverse;
b.SetSign(Positive);
end;

try
Result := TNumber.Create(self, FFloatDigits);
if b.IsZero then
begin Result.MakeOne;exit;end;

if b.IsEqualTo(1) then exit
else
if b.IsEqualTo(2) then
begin
Result.Mul(self);exit;
end;

tmp := TNumber.Create('', FFloatDigits);
tmp2 := TNumber.Create('', FFloatDigits);

if b.IsIntegerOdd then
b.Sub(one,tmp)
else
tmp.Assign(b);
tmp.Divide(two,tmp2);
tmp.Assign(FIntPower(tmp2));
tmp.Mul(tmp);
if b.IsIntegerOdd then
tmp.Mul(self);
Result.Assign(tmp);

finally
if assigned(selftmp) then
begin
Assign(selftmp);
b.SetSign(Negative);
end;

if assigned(tmp) then
tmp.Destroy;

if assigned(tmp2) then
tmp2.Destroy;

end;end;








procedure TNumber.Factoriel(a: Word);
var
tmp1,tmp2: TNumber;
i: Word;
begin
tmp1 := TNumber.Create('1');
tmp2 := TNumber.Create('', FFloatDigits);
try
Assign('1');
for i := 1 to a do
begin
tmp1.mul(self,tmp2);
Assign(tmp2);
tmp1.add(ONE);
end;
finally
tmp1.Destroy;tmp2.Destroy;
end;end;





procedure TNumber.Factoriel(var Res: TNumber);
var
tmp: TNumber;
begin
tmp := FFactoriel;
try
Res.Assign(tmp);
finally
tmp.Destroy;
end;end;




function TNumber.FFactoriel: TNumber;
var
incr: TNumber;
begin
Result := TNumber.Create('1', FFloatDigits);
incr := TNumber.Create('1');
try
if FSign=Negative then raise ENumberInvalidInputError.Create(InvalidInputErrorStr);
while Compare(incr) = GreaterThanValue do
begin
incr.add(ONE);
Result.mul(incr);
end;
finally
incr.Destroy;
end;end;




function TNumber.Find2pk_L: Longint;
var
tmp: TNumber;
cmp:TValueRelationship;
begin
if FExponent <> 0 then
tmp := two.Power(FExponent * 3)
else
tmp := TNumber.Create(1);

Result := FExponent * 3;
cmp := tmp.Compare(self);
while cmp <> GreaterThanValue do
begin
tmp.Mul(two);
Result := Result + 1;
cmp := tmp.Compare(self);
end;
end;





function TNumber.Find2pk_N: TNumber;
var
tmp,tmp1: TNumber;
cmp:TValueRelationship;
begin
Result := TNumber.Create;
if FExponent < 0 then exit;
if FExponent <> 0 then
tmp1 := TNumber.Create(FExponent)
else
tmp1 := TNumber.Create('1');
tmp1.Mul(three);
tmp := two.FIntPower(tmp1);
Result.Assign(tmp1);
cmp := tmp.Compare(self);
while cmp <> GreaterThanValue do
begin
tmp.Mul(two);
Result.Add(one);
cmp := tmp.Compare(self);
end;
end;





//no precisiobns no float digits
function  TNumber.Gause3PointIntegeral(a,b: TNumber;m: Longint;fx:FXFunction): TNumber;
var
temp,tmp1,HALF: TNumber;

function gx(a,b,x: TNumber): TNumber;
begin
temp.Assign(b);
temp.Sub(a);
temp.Mul(x);
temp.Add(b);
temp.Add(a);
temp.Mul(HALF);
fx(@temp,@Result);
end;



var
y,zero,five,eight,eighteen,xh,mm,h,x,p,Res: TNumber;
cmp: TValueRelationship;
begin
p := TNumber.Create('0.77459666924148337703585307995648');
half := TNumber.Create('0.5');
h := TNumber.Create;x := TNumber.Create('0');
temp := TNumber.Create;
Res := TNumber.Create('0');mm := TNumber.Create(m);xh := TNumber.Create;
five := TNumber.Create('5');eight := TNumber.Create('8');
eighteen := TNumber.Create('18');zero := TNumber.Create('0');
//h := (b-a)/(m);
h.Assign(b);h.Sub(a);h.Divide(mm);
//x := a;
x.Assign(a);xh.Assign(x);

repeat
p.FSign := Negative;
xh.Add(h);

y := gx(x,xh,p);
y.Mul(five);

//y := y+8*gx(x,x+h,0);
tmp1 := gx(x,xh,zero);
tmp1.Mul(eight);
y.Add(tmp1);

//y := y+5*gx(x,x+h,p);
p.FSign := Positive;
tmp1 := gx(x,xh,p);
tmp1.Mul(five);
y.Add(tmp1);

//Res: =res+h/18*y;
tmp1.Assign(h);
tmp1.Divide(eighteen);
tmp1.Mul(y);
Res.Add(tmp1);

//x := x+h;
x.Add(h);
cmp := x.Compare(b);
y.Destroy;tmp1.Destroy;
until (cmp=GreaterThanValue) or (cmp=EqualsValue);

Result := res;

end;







// Sin(x)=x-x^3/3! +x^5/5! -x^7/7! +...
procedure TNumber.TaylorSin(var Res: TNumber);
var
i: Word;
tmp4,tmp1: TNumber;
c:shortint;
begin
tmp1 := TNumber.Create('1', Res.FFloatDigits);
tmp4 := TNumber.Create('0', Res.FFloatDigits);
try
Res.MakeZero;
c := 1;

i := 0;
repeat
i := i + 1;
tmp4.Add(one);
tmp1.mul(self);
tmp1.Divide(tmp4);
if not odd(i) then continue;


if c > 0 then
Res.Add(tmp1)
else
Res.Sub(tmp1);

c := c * -1;
until abs(tmp1.FExponent) >= Res.FloatDigits;
finally
tmp1.Destroy;tmp4.Destroy;
end;end;






procedure TNumber.Sin(var Res: TNumber);
var
cmp: TValueRelationship;
x,tmp: TNumber;
begin

if FSign = Negative then
 begin
   SwitchSign;
   Sin(Res);
   SwitchSign;
   Res.SwitchSign;
   exit;
 end;

// reduce below 2*pi
tmp := TNumber.Create('');
x := TNumber.Create('');
try
x.Assign(self,asAll);x.AngleToRadian;
tmp.SetFloatDigits(x.FloatDigits);
tmp.Assign(pion2, asAllbutFloatDigits);
if x.Compare(tmp) = EqualsValue then begin Res.MakeOne;exit; end;
if x.Compare(TNumber.Create) = EqualsValue then begin Res.MakeZero;exit;end;
tmp.Assign(pi, asAllbutFloatDigits);
if x.Compare(tmp) = EqualsValue then begin Res.MakeZero;exit; end;
// error in bignumbers ?????/
x.DivMod(tmp);

tmp.Assign(pion2);
tmp.SetFloatDigits(Res.FloatDigits);

cmp := tmp.Compare(x);
if cmp = LessThanValue then
begin
x.Sub(tmp);
x.TaylorCos(Res);
exit;
end;
x.TaylorSin(Res);
finally
x.Destroy;tmp.Destroy;
end;end;





// Cos(x)=1-x^2/2! +x^4/4! -x^6/6! +....
procedure TNumber.TaylorCos(var Res: TNumber);
var
i: Word;
tmp4,tmp1: TNumber;
c:shortint;
begin
tmp1 := TNumber.Create(Self, Res.FloatDigits);
tmp4 := TNumber.Create('1', Res.FloatDigits);
try
Res.MakeOne;
c := -1;
i := 1;

repeat
inc(i);
tmp4.Add(one);
tmp1.Mul(self);
tmp1.Divide(tmp4);
if odd(i) then continue;

if c > 0 then
Res.Add(tmp1)
else
Res.Sub(tmp1);

c := c * -1;
until abs(tmp1.FExponent) > Res.FloatDigits;
finally
tmp1.Destroy;tmp4.Destroy;
end;end;






procedure TNumber.Cos(var Res: TNumber);
var
cmp:TValueRelationship;
x,tmp: TNumber;
begin

if FSign = Negative then
begin
FSign := Positive;
Sin(Res);
FSign := Negative;exit;
end;

// reduce below 2*pi
tmp := TNumber.Create;
x := TNumber.Create;
try
x.Assign(self, asAll);
x.AngleToRadian;

tmp.SetFloatDigits(x.FloatDigits);
tmp.Assign(pion2, asAllbutFloatDigits);
if x.Compare(tmp) = EqualsValue then begin Res.MakeZero;exit; end;
if x.Compare(TNumber.Create) = EqualsValue then begin Res.MakeOne;exit;end;
tmp.Assign(pi, asAllbutFloatDigits);
if x.Compare(tmp) = EqualsValue then begin Res.MakeOne;Res.SwitchSign;exit; end;

x.DivMod(pi2);


tmp.Assign(pion2);
tmp.SetFloatDigits(Res.FFloatDigits);

cmp := tmp.Compare(x);
if cmp = LessThanValue then
begin
x.Sub(tmp);
x.TaylorSin(Res);
Res.SwitchSign;
exit;
end;

x.TaylorCos(Res);
finally
x.Destroy;tmp.Destroy;
end;end;








procedure TNumber.Tan(var Res: TNumber);
var
tmp1,tmp2: TNumber;
begin
tmp1 := TNumber.Create('', Res.FFloatDigits);
tmp2 := TNumber.Create('', Res.FFloatDigits);
try
try
Sin(Res);
Cos(tmp1);
Res.Divide(tmp1);
{Sin(tmp1);tmp2.Assign(tmp1);
tmp3 := tmp1.FIntPower(two);
one.Sub(tmp3,tmp2);
tmp2.Sqrt;
tmp1.Divide(tmp2,res);}
Except
 on E:ENumberDivisonByZeroError do
    Raise ENumberInvalidInputError.Create(InvalidInputErrorStr)

end;
finally
 tmp1.Destroy;tmp2.Destroy;
end;end;




// ArcTan(x)=x-x^3/3+x^5/5-...
procedure TNumber.TaylorArcTan(var Res: TNumber);
var
i: Word;
incr,tmp3,xp: TNumber;
c: Byte;
begin

xp := TNumber.Create('1', Res.FFloatDigits);
tmp3 := TNumber.Create('', Res.FFloatDigits);
incr := TNumber.Create('0', Res.FFloatDigits);
try
Res.MakeZero;
c := 0;
i := 0;

repeat
inc(i);
incr.Add(one);

xp.Mul(self);
if not odd(i) then continue;

xp.Divide(incr,tmp3);
if c = 0 then
Res.Add(tmp3)
else
Res.Sub(tmp3);

c := c xor 1;
until abs(tmp3.FExponent) > Res.FloatDigits;
finally
xp.Destroy;tmp3.Destroy;incr.Destroy;
end;end;






procedure TNumber.ArcTan(var Res: TNumber);
var
x,tmp: TNumber;
red:boolean;
begin
tmp := TNumber.Create('0.5');
x := TNumber.Create(self, Res.FFloatDigits);
try
if tmp.Compare(self) <> GreaterThanValue then
begin
red := false;
if two.Compare(self) <> GreaterThanValue then
begin
red := true;
x.Inverse;
end;
x.Mul(x,tmp);
tmp.IncNumber;
tmp.Sqrt;
tmp.IncNumber;
tmp.Inverse;
x.Mul(tmp);
x.TaylorArcTan(res);
Res.Mul(two);
if red then
begin
Res.SetSign(Negative);
Res.Add(pion2);
end;
end
else
x.TaylorArcTan(Res);

finally
x.Destroy;tmp.Destroy;
end;end;











procedure TNumber.NewtonArcSin(var Res: TNumber);
var
tmp1,tmp2,tmp3: TNumber;
i: Word;
begin
tmp1 := TNumber.Create('0', Res.FFloatDigits);
tmp2 := TNumber.Create('0', Res.FFloatDigits);
tmp3 := TNumber.Create('0', Res.FFloatDigits);
try
Res.Assign(Math.ArcSin(GetExtended));

for i := 1 to (Res.FloatDigits div 12) + 1 do
begin
Res.Sin(tmp1);
Res.Cos(tmp2);
tmp1.Divide(tmp2);tmp1.SwitchSign;
Divide(tmp2,tmp3);
Res.Add(tmp3);Res.Add(tmp1);
end;
finally
tmp1.Destroy;tmp2.Destroy;tmp3.Destroy;
end;end;





procedure TNumber.TaylorArcSin(var Res: TNumber);
var
i: Word;
oddmul,evenmul,incr,tmp3,xp: TNumber;
begin
xp := TNumber.Create('1', Res.FFloatDigits);
tmp3 := TNumber.Create('0', Res.FFloatDigits);
incr := TNumber.Create('0', Res.FFloatDigits);
oddmul := TNumber.Create('1', Res.FFloatDigits);
evenmul := TNumber.Create('1', Res.FFloatDigits);
try
Res.MakeZero;
i := 1;


repeat
incr.Add(one);

xp.Mul(self);
if not odd(i) then
begin
evenmul.Mul(incr);
inc(i);
continue;
end;

oddmul.Divide(evenmul, tmp3);
tmp3.Divide(incr);
tmp3.Mul(xp);
Res.Add(tmp3);

if odd(i) then
oddmul.Mul(incr);

inc(i);
until abs(tmp3.FExponent) > Res.FloatDigits;

finally
tmp3.Destroy;oddmul.Destroy;evenmul.Destroy;xp.Destroy;
end;end;





procedure TNumber.ArcCos(var Res: TNumber);
var
tmp: TNumber;
begin
tmp := TNumber.Create('', Res.FFloatDigits);
try
ArcSin(tmp);
tmp.AngleToRadian;
Pion2.Sub(tmp,Res);
finally
tmp.Destroy;
end;end;






procedure TNumber.ArcSin(var Res: TNumber);
var
//tmp1,tmp2,tmp3: TNumber;
cmp:TValueRelationship;
begin
cmp := AbsCompare(one);
if cmp = EqualsValue then Res.Assign(Pion2) else
if cmp = GreaterThanValue then raise ENumberInvalidInputError.Create(InvalidInputErrorStr)
else
NewtonArcSin(Res);
Res.FAngle := FAngle;
Res.RadianToAngle;
{exit;
tmp3 := TNumber.Create('2',Res.FFloatDigits);tmp3.Sqrt;
tmp2 := TNumber.Create('0',Res.FFloatDigits);

tmp1 := FIntPower(two);
tmp1.SetFloatDigits(Res.FFloatDigits);
one.Sub(tmp1,tmp2);
tmp2.Sqrt;
tmp2.Add(one);
tmp2.Sqrt;
tmp2.Mul(tmp3);
tmp2.Inverse;
Mul(tmp2,tmp3);
tmp3.TaylorArcSin(tmp2);
tmp2.Mul(two,res);
Res.RadianToAngle;}
end;









// Exp(x)=1+x+x^2/2! +...
procedure TNumber.TaylorExp(var Res: TNumber);
var
tmp1,tmp4: TNumber;
begin
  tmp1 := TNumber.Create('1', Res.FFloatDigits);
  tmp4 := TNumber.Create('0', Res.FFloatDigits);
 try
  Res.MakeOne;
  repeat
    tmp4.Add(one);
    tmp1.Mul(self);
    tmp1.Divide(tmp4);
    Res.Add(tmp1);
  until abs(tmp1.FExponent) > Res.FloatDigits;

 finally
  tmp1.Destroy;tmp4.Destroy;
end;end;








// computes 1+-self
// Ln(1-z)= -z-z^2/2-z^3/3-...
procedure TNumber.TaylorLn(var Res: TNumber);
var
i: Word;
z,tmp3,tmp1,a: TNumber;
cmp:TValueRelationship;
sgn:SignIndicator;
begin
  tmp1 := TNumber.Create('1', Res.FFloatDigits);
  a := TNumber.Create('0', Res.FFloatDigits);
  tmp3 := TNumber.Create('0', Res.FFloatDigits);
  z := TNumber.Create('0', Res.FFloatDigits);
  Res.MakeZero;

  cmp := One.Compare(self);
  if cmp = EqualsValue then exit
  else
  if cmp = GreaterThanValue then
    begin sgn := Negative;one.Sub(self, z);end
  else
    begin
      cmp := Two.Compare(self);
      if cmp = GreaterThanValue then
        begin sgn := Positive;sub(one, z);end
      else
        begin
          one.Divide(self, z);
          z.TaylorLn(res);
          z.SetSign(Positive);exit;
        end;
    end;

  i := 0;
  repeat
    inc(i);
    a.add(one);
    tmp1.Mul(z);
    tmp1.Divide(a,tmp3);
    if (odd(i)) and (sgn = positive) then
      Res.Add(tmp3)
    else
      Res.Sub(tmp3)
  until abs(tmp3.FExponent) > Res.FloatDigits;
end;






procedure TNumber.ArgumentReductionLn(var Res: TNumber);
var
e,inve,m,tmp: TNumber;
cmp:TValueRelationship;
begin
  Res.MakeZero;
  inve := TNumber.Create('',Res.FFloatDigits);
  e := TNumber.Create('',Res.FFloatDigits);
  one.Exp(e);
  // find m
  m := Find2pk_N;
  //optimization
  if not m.IsZero then
    begin
      repeat
        cmp := Compare(e.FIntPower(m));
        if cmp = GreaterThanValue then break;
        m.sub(one);
      until 1 = 2;
      m.Add(one);
    end;
  one.Divide(e,inve);
  tmp := inve.FIntPower(m);
  tmp.Mul(self);
  tmp.Sqrt;tmp.Sqrt;
  //tmp.TaylorLn(res);
  Res.Assign(System.ln(tmp.GetExtended));
  Res.Mul(two);Res.Mul(two);
  Res.add(m);
  Res.Correction;
end;






procedure TNumber.Ln(var Res: TNumber);
var
x,m,tmp: TNumber;
exptmp:Longint;
begin
  Res.MakeZero;
  tmp := TNumber.Create('1.05', Res.FFloatDigits);
  m := TNumber.Create('0', Res.FFloatDigits);
  x := TNumber.Create(self, Res.FFloatDigits);
 try
  exptmp := x.FExponent;
  x.FExponent:=0;
//optimization
  repeat
    x.Sqrt;
    m.IncNumber;

    if x.FExponent = 0 then
    if x.Compare(tmp) = LessThanValue then break;
  until 1 = 2;

  x.TaylorLn(Res);
  two.IntPower(m,tmp);
  Res.Mul(tmp);
  Ln10.Mul(TNumber.Create(exptmp), tmp);
  Res.Add(tmp);
  Res.Correction;
 finally
  tmp.Destroy;m.Destroy;x.Destroy;
end;end;






// computes 1+-self
procedure TNumber.PadeLn(var Res: TNumber);
var
tmp2,tmp1,tmp3,tmp4: TNumber;
cmp:TValueRelationship;
begin
tmp1 := TNumber.Create('6', Res.FFloatDigits);
tmp2 := TNumber.Create('0.7662', Res.FFloatDigits);
tmp3 := TNumber.Create('5.9897', Res.FFloatDigits);
tmp4 := TNumber.Create('3.7658', Res.FFloatDigits);
Res.MakeZero;

cmp := One.Compare(self);
if cmp = EqualsValue then exit
else
if cmp = GreaterThanValue then
 sub(one,res)
else
begin
cmp := Two.Compare(self);
if (cmp = GreaterThanValue) or (cmp = EqualsValue) then
 sub(one,res)
else
begin
one.Divide(self,tmp1);
tmp1.PadeLn(res);
Res.SetSign(Positive);exit;
end;

end;
tmp4.Mul(res);
tmp4.add(tmp3);
tmp2.Mul(res);
tmp2.Add(tmp1);
Res.mul(tmp2);
Res.Divide(tmp4);
end;




procedure TNumber.InverseExpLn(var Res: TNumber);
var
i: Word;
tmp,tmp1: TNumber;
begin
  tmp := TNumber.Create('', Res.FFloatDigits);
  tmp1 := TNumber.Create('', Res.FFloatDigits);
 try
// find m
  if (FSign = Negative) or (IsZero) then
    raise ENumberInvalidInputError.Create(InvalidInputErrorStr);
  {if abs(Exponent)>4932 then
  begin tsLn(Res);exit; end
  else}
  Res.Assign(System.Ln(GetExtended));
  {m := Find2pk_N;
  Res.Mul(m);}
  for i := 1 to Res.FloatDigits div 12 do
    begin
      Res.Exp(tmp);
      divide(tmp,tmp1);
      Res.Sub(one);
      Res.Add(tmp1);
    end;
  Res.Correction;
 finally
  tmp.Destroy;tmp1.Destroy;
end;end;










procedure TNumber.Exp(var Res: TNumber);
var
k,tmp,tmp1,y: TNumber;
begin
  tmp1 := TNumber.Create('0', Res.FFloatDigits);
  y := TNumber.Create('0', Res.FFloatDigits);
  k := Find2pk_N;
 try
  k.FFloatDigits := Res.FloatDigits;
  k.FExponent := k.FExponent + 1;
  //k.Add(four);
  tmp := two.FIntPower(k); // tmp = 2^k
  //tmp.FExponent := tmp.FExponent +1;
  one.Divide(tmp,tmp1);   // tmp1 = 2^-k
  tmp1.Mul(self);        // tmp1 =(2^-k)*x
  tmp1.Divide(two);
  tmp1.TaylorExp(y);
  y.Sub(one);
  y.Mul(two,tmp1);
  y.Mul(y);
  y.Add(tmp1);
  y.Add(one);
  y.IntPower(tmp,res)
 finally
  tmp1.Destroy;tmp.Destroy;k.Destroy;y.Destroy;
end;end;













//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------













procedure TNumber.Add(b: TNumber);
var
tmp: TNumber;
begin
  tmp := TNumber.Create('', FFloatDigits);
  Add(b,tmp);

  FNum := tmp.FNum;
  FNumHigh := tmp.fnumHigh;
  FSign := tmp.FSign;
  FExponent := tmp.FExponent;
end;



procedure TNumber.Sub(b: TNumber);
var
tmp :TNumber;
begin
  tmp := TNumber.Create('', FFloatDigits);
  Sub(b,tmp);

  FNum := tmp.FNum;
  FNumHigh := tmp.fnumHigh;
  FSign := tmp.FSign;
  FExponent := tmp.FExponent;
end;



procedure TNumber.Mul(b: TNumber);
var
tmp: TNumber;
begin
  tmp := TNumber.Create('', FFloatDigits);
  mul(b,tmp);

  FNum := tmp.FNum;
  FNumHigh := tmp.fnumHigh;
  FSign := tmp.FSign;
  FExponent := tmp.FExponent;
end;



procedure TNumber.Divide(b: TNumber);
var
tmp: TNumber;
begin
  tmp := TNumber.Create('', FFloatDigits);
  Divide(b,tmp);

  FNum := tmp.FNum;
  FNumHigh := tmp.fnumHigh;
  FSign := tmp.FSign;
  FExponent := tmp.FExponent;
end;



procedure TNumber.Inverse;
var
tmp: TNumber;
begin
  tmp := TNumber.Create('', FFloatDigits);
 try
  one.Divide(Self,tmp);
  Assign(tmp);
 finally
  tmp.Destroy;
end;end;


procedure TNumber.Factoriel;
var
tmp: TNumber;
begin
tmp := FFactoriel;
try
Assign(tmp,asTheNumber);
finally;
tmp.Destroy;
end;end;


procedure TNumber.Int;
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
Int(tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;

procedure TNumber.Sqrt;
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
Sqrt(tmp);
Assign(tmp);
finally
tmp.Destroy
end;end;

procedure TNumber.Frac(var Res: TNumber);
var
tmp: TNumber;
begin
  tmp := TNumber.Create('', Res.FFloatDigits);
 try
  Int(tmp);
  Sub(tmp,Res);
 finally
  tmp.Destroy;
end;end;

procedure TNumber.Frac;
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
Frac(tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;


procedure TNumber.DivInt(b: TNumber);
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
DivInt(b,tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;


procedure TNumber.DivMod(b: TNumber);
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
DivMod(b,tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;


procedure TNumber.BitWiseAnd(b: TNumber);
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
BitWiseAnd(b,tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;

procedure TNumber.BitWiseOr(b: TNumber);
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
BitWiseOr(b,tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;


procedure TNumber.BitWiseXor(b: TNumber);
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
BitWiseXor(b,tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;


procedure TNumber.BitWiseLsh(b: TNumber);
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
BitWiseLsh(b,tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;

procedure TNumber.BitWiseRsh(b: TNumber);
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
BitWiseRsh(b,tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;

procedure TNumber.BitWiseNot;
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
BitWiseNot(tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;



procedure TNumber.Sinh(var Res: TNumber);
var
tmp: TNumber;
begin
tmp := TNumber.Create('', Res.FFloatDigits);
try
Exp(tmp);
Res.Assign(tmp);
tmp.Inverse;
Res.Sub(tmp);
Res.Divide(two);
finally
tmp.Destroy;
end;end;



procedure TNumber.Cosh(var Res: TNumber);
var
tmp: TNumber;
begin
tmp := TNumber.Create('', Res.FFloatDigits);
try
Exp(tmp);
Res.Assign(tmp);
tmp.Inverse;
Res.Add(tmp);
Res.Divide(two);
finally
tmp.destroy;
end;end;



procedure TNumber.Log(var Res: TNumber);
var
tmp,tmp1: TNumber;
begin
tmp := TNumber.Create('10', Res.FloatDigits);
tmp1 := TNumber.Create('', Res.FloatDigits);
try
Ln(res);
tmp.Ln(tmp1);
Res.Divide(tmp1);
finally
tmp.Destroy;tmp1.Destroy;
end;end;



procedure TNumber.ArcCos;
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
ArcCos(tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;


procedure TNumber.Tanh(var Res: TNumber);
var
tmp: TNumber;
begin
tmp := TNumber.Create('', Res.FFloatDigits);
try
Sinh(Res);
Cosh(tmp);
Res.Divide(tmp);
finally
tmp.Destroy;
end;end;


procedure TNumber.ArcSinh;
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits );
try
ArcSinh(tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;


procedure TNumber.ArcSin;
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
ArcSin(tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;


procedure TNumber.ArcCosh;
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
ArcCosh(tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;



// ArcTanh(x)=1/2*Ln((1+x)/(1-x)).
procedure TNumber.ArcTanh(var Res: TNumber);
var
tmp,tmp1: TNumber;
begin
tmp := TNumber.Create(Self, Res.FFloatDigits);
tmp1 := TNumber.Create('1', Res.FFloatDigits);
try
tmp.Add(one);
tmp1.Sub(self);
tmp.Divide(tmp1);
tmp.Ln(res);
Res.Divide(two,res);
finally
tmp.Destroy;tmp1.Destroy;
end;end;


procedure TNumber.ArcTanh;
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
ArcTanh(tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;


procedure TNumber.ArcTan;
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
ArcTan(tmp);
Assign(tmp);
tmp.Destroy;
end;


procedure TNumber.Sin;
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
Sin(tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;


procedure TNumber.Cos;
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
Cos(tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;


// ArcCosh(x)=Ln(x+Sqrt(x^2-1)),
procedure TNumber.ArcCosh(var Res: TNumber);
var
tmp: TNumber;
begin
  tmp := FIntPower(two);
  tmp.Sub(one);
  tmp.Sqrt;
  tmp.Add(self);
  tmp.Ln(Res);
end;



//  ArcSinh(x)=Ln(x+Sqrt(x^2+1)),
procedure TNumber.ArcSinh(var Res: TNumber);
var
tmp: TNumber;
begin
  tmp := TNumber.Create(self, Res.FFloatDigits);
 try
  tmp.Mul(self);
  tmp.Add(one);
  tmp.Sqrt;
  tmp.Add(self);
  tmp.Ln(Res);
 finally
  tmp.Destroy;
end;end;

procedure TNumber.Cosh;
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
Cosh(tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;


procedure TNumber.Tanh;
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
Tanh(tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;


procedure TNumber.Sinh;
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
Sinh(tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;


procedure TNumber.Tan;
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
Tan(tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;


procedure TNumber.Exp;
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
Exp(tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;



procedure TNumber.Log;
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
Log(tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;


procedure TNumber.Ln;
var
tmp: TNumber;
begin
  tmp := TNumber.Create('', FFloatDigits);
 try
  Ln(tmp);
  Assign(tmp);
 finally
  tmp.Destroy;
end;end;



procedure TNumber.Power(y: TNumber);
var
tmp: TNumber;
begin
tmp := TNumber.Create('', FFloatDigits);
try
Power(y,tmp);
Assign(tmp);
finally
tmp.Destroy;
end;end;



initialization

one := TNumber.Create('1');
two := TNumber.Create('2');
three := TNumber.Create('3');
Four := TNumber.Create('4');
Pi := TNumber.Create('3.141592653589793238462643383279502884197169399375105820974944'+
                  '592307816406286208998628034825342117067982148086513282306647'+
                  '093844609550582231725359408128481117450284102701938521105559'+
                  '64462294895493038196');
Ln10 := TNumber.Create('2.3025850929940456840179914546843642075802774059335446778033'+
                    '186086043243380937540409102507286580713012880161850198335571'+
                    '604602551484317423808853946999887097691608826756808516382753221');
Pi2 := TNumber.Create('', Pi.FFloatDigits);
Pion2 := TNumber.Create('', Pi.FFloatDigits);
Pi.Mul(two, pi2);
Pi.Divide(two, pion2);


finalization


one.Destroy;
two.Destroy;
three.Destroy;
Four.Destroy;
Pi.Destroy;
Pi2.Destroy;
Pion2.Destroy;




end.



















procedure TNumber.TaylorTan(var Res: TNumber);
var
i: Word;
tmp4,tmp3,tmp1,tmp2: TNumber;
begin
tmp1 := TNumber.Create(1,Res.FFloatDigits);
tmp2 := TNumber.Create(1,Res.FFloatDigits);
tmp3 := TNumber.Create('0',Res.FFloatDigits);
tmp4 := TNumber.Create('0',Res.FFloatDigits);

Res.MakeZero;

for i := 1 to 40 do
begin
tmp4.Add(one);
tmp2.mul(tmp4);
tmp1.Mul(self);
if not odd(i) then continue;
tmp1.Divide(tmp2,tmp3);
Res.Add(tmp3);
end;


end;


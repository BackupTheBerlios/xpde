(* This unit is Copyright ©2001 Howard Harvey, all rights reserved.
   The unit was developed by a third party based on Howard Harvey's
   code, but the copyright on the source remains entirely with the
   original developer.

   You are free to use this unit in your development, provided this
   unit source is included if any other substantial source code is
   provided as part of the package. If you make substantial
   modifications to the source, you are still obliged to credit the
   original developer.
*)

unit ttfinfo;

interface

uses Classes,Sysutils;

type
  TTTFInfoList = record
	FilePath   : string;
	FileCalled : string;
	FileSize   : longint;
	Copyright  : string;
	Family     : string;
	SubFamily  : string;
	Identifier : string;
	FontName   : string;
	Version    : string;
	PSname     : string;
	Trademark  : string;
  end;

  UKind = (motorola,intel);

  USHORT = record
  case Ukind of
	motorola : (b1,b2: byte);
	intel: (shortword: word);
  end;

  SHORT = record
  case Ukind of
	motorola: (b1,b2: byte);
	intel: (shortword: integer);
  end;

  ULONG = record
  case Ukind of
	motorola: (b1,b2,b3,b4 : byte);
	intel: (longword: longint);
  end;

  PANOSE = array [1..10] of byte;

  THeaderRec = record
	ident: array[1..4] of char;
	csum: ULONG ;
	pntr: ULONG ;
	rsize: ULONG ;
  end;

  TNameHeader = record
	FormatSel: USHORT;
	NumRecords: USHORT;
	Stoffset: USHORT;
  end;

  TNameRecord = record
	PlatformID: USHORT;
	EncodingID: USHORT;
	LanguageID: USHORT;
	NameID: USHORT;
	Slength: USHORT;
	Soffset: USHORT;
  end;

  TOS2Record = record
	version             : USHORT;
	xAvgCharWidth       : SHORT;
	usWeightClass       : USHORT;
	usWidthClass        : USHORT;
	fsType              : SHORT;
	ySubscriptXSize     : SHORT;
	ySubscriptYSize     : SHORT;
	ySubscriptXOffset   : SHORT;
	ySubscriptYOffset   : SHORT;
	ySuperscriptXSize   : SHORT;
	ySuperscriptYSize   : SHORT;
	ySuperscriptXOffset : SHORT;
	ySuperscriptYOffset : SHORT;
	yStrikeoutSize      : SHORT;
	yStrikeoutPosition  : SHORT;
	sFamilyClass        : SHORT;
	panose              : PANOSE;
	ulCharRange         : array [1..4] of ULONG;
	achVendID           : array [1..4] OF CHAR;
	fsSelection         : USHORT;
	usFirstCharIndex    : USHORT;
	usLastCharIndex     : USHORT;
	sTypoAscender       : USHORT;
	sTypoDescender      : USHORT;
	sTypoLineGap        : USHORT;
	usWinAscent         : USHORT;
	usWinDescent        : USHORT;
  end;

  FListPtr = ^TTTFInfoList;

const	PtsTable = 8 ;
		ERR_INVALID_EXTENSION = 16;
		sInvalidExtension = 'File has an invalid (non-.TTF) extension.';
		ERR_SCREEN_FONT = 17;
		sScreenfont = 'File is a screen font (.FON extension).';
		ERR_POSTSCRIPT_FONT = 18;
		sPSFont = 'File is a PostScript font (.PF? extension).';
		ERR_INVALID_PATH = 19;
		sBadpath = 'File path is invalid.';

//	TTFInfoRec    : FListPtr;
var FontInfoPtr   : FListPtr = (nil);
	NameRec       : THeaderRec;
	NameHeader    : TNameHeader;
	NameRecord    : TNameRecord;
	OS2Record     : TOS2Record;
	PrTextPts     : array [1..PtsTable] of byte = (8,12,16,24,36,48,60,72);

function GetFontInfo(Fname: string; FontInfoPtr: FListPtr): Integer;

implementation

//diagnostic procs; disposable
function Diag(Val1,Val2: String): Boolean;
begin
{	Result := ID_OK =
		MessageBox(GetActiveWindow,Pchar(Val1),Pchar(Val2),
		64 or MB_SYSTEMMODAL or MB_OKCANCEL);}
end;

function Debug(Val1,Val2: Integer): Boolean;
var P1,P2: array [byte] of Char;
begin
{	StrPCopy(P1,InttoStr(Val1));
	StrPCopy(P2,IntToStr(Val2));
	Result := ID_OK =
		MessageBox(GetActiveWindow,P1,P2,
		64 or MB_SYSTEMMODAL or MB_OKCANCEL);}
end;
//end diagnostics


procedure ConvertUSHORT(var value: USHORT);
//Two byte swap around
var temp: byte;
begin
	temp := value.b2;
	value.b2 := value.b1;
	value.b1 := temp;
end;

procedure ConvertULONG(var value: ULONG);
// Four byte swap around
var temp: byte;
begin
	temp := value.b4;
	value.b4 := value.b1;
	value.b1 := temp;
	temp := value.b3;
	value.b3 := value.b2;
	value.b2 := temp;
end;

function GetFontInfo(Fname: string; FontInfoPtr: FListPtr): Integer;
var NameStart  : longint;
	index      : longint;
	records    : integer;
	NameString : string[255];
	ZeroPntr   : integer;
	StringStart: longint;
	foundname  : boolean;
	TT_File    : file;
	Oldmode    : integer;

	procedure FindNameRecord(var nrec: THeaderRec);
	var index: longint;
	begin
		index:= 12;
	// Look for the 'name' string field
		repeat
			Seek(TT_File, index);
			BlockRead(TT_File, nrec, 16);
			index := index + 16;
		until (nrec.ident[1] = 'n')
		and (nrec.ident[2] = 'a')
		and (nrec.ident[3] = 'm')
		and (nrec.ident[4] = 'e');
	//Convert the data in the fields to Intel format
		ConvertULONG(nrec.csum);
		ConvertULONG(nrec.pntr);
		ConvertULONG(nrec.rsize);
	end;

	procedure FindOS2Record(var nrec: THeaderRec);
	var index: longint;
	begin
		index := 12;
	// Look for the 'name' string field
		repeat
			Seek(TT_File, index) ;
			BlockRead(TT_File, nrec, 16);
			index := index + 16;
		until (nrec.ident[1] = 'O')
		and (nrec.ident[2] = 'S')
		and (nrec.ident[3] = '/')
		and (nrec.ident[4] = '2');
	//Convert the data in the fields to Intel format
		ConvertULONG(nrec.csum);
		ConvertULONG(nrec.pntr);
		ConvertULONG(nrec.rsize);
	end;

begin
	Oldmode := Filemode;
	Filemode := 0;
	Result := 0;
	NameString := UpperCase(ExtractFileExt(Fname));
	If NameString = '.FON' then begin
		Result := ERR_SCREEN_FONT;
		Exit;
	end;
	If Pos('PF',NameString) <> 0 then begin
		Result := ERR_POSTSCRIPT_FONT;
		Exit;
	end;
	If NameString <> '.TTF' then begin
		Result := ERR_INVALID_EXTENSION;
		Exit;
	end;
	If Not FileExists(FName) then begin
		Result := ERR_INVALID_PATH;
		Exit;
	end;
	AssignFile(TT_File, Fname);
	{$IFOPT I+}{$DEFINE I_PLUS}{$I-}{$ENDIF}
	Reset(TT_File,1);
	{$IFDEF I_PLUS}{$I+}{$UNDEF I_PLUS}{$ENDIF}
	If IOResult <> 0 then begin
		Result := IOResult;
		Exit;
	end;
//init structure
	FontInfoPtr^.FilePath := Fname;
	FontInfoPtr^.FileCalled := ExtractFileName(Fname);
	FontInfoPtr^.FileSize   := FileSize(TT_File);
	FontInfoPtr^.FontName   := '';
	FontInfoPtr^.Copyright  := '';
	FontInfoPtr^.Family     := '';
	FontInfoPtr^.SubFamily  := '';
	FontInfoPtr^.Identifier := '';
	FontInfoPtr^.Version    := '';
	FontInfoPtr^.PSname     := '';
	FontInfoPtr^.Trademark  := '';
	FindNameRecord(NameRec);
	NameStart := NameRec.pntr.longword;
	Seek(TT_File, NameStart);
	BlockRead(TT_File, NameHeader, 6);
	ConvertUSHORT(NameHeader.NumRecords);
	ConvertUSHORT(NameHeader.StOffset);
	StringStart := NameStart + NameHeader.StOffset.shortword;
	foundname := false;
	index := NameStart + 6;
	for records := 1 to NameHeader.NumRecords.shortword do begin
		Seek(TT_File, index);
		BlockRead(TT_File, NameRecord, 12);
		Index := index + 12;
		ConvertUSHORT(NameRecord.PlatformID);
		ConvertUSHORT(NameRecord.EncodingID);
		ConvertUSHORT(NameRecord.LanguageID);
		ConvertUSHORT(NameRecord.NameID);
		ConvertUSHORT(NameRecord.Slength);
		ConvertUSHORT(NameRecord.Soffset);
		if ((NameRecord.PlatformID.shortword = 3)
			and (NameRecord.EncodingID.shortword = 1)
			and (NameRecord.LanguageID.shortword = $0409))
		or ((NameRecord.PlatformID.shortword = 1)
			and (NameRecord.EncodingID.shortword = 0)
			and (NameRecord.LanguageID.shortword = 0))
		then begin
			Seek(TT_File, StringStart+NameRecord.Soffset.shortword );
			If (NameRecord.Slength.shortword > 160)
			then NameRecord.Slength.shortword := 160;
			NameString[0] := Chr(NameRecord.Slength.shortword);
			BlockRead(TT_File, NameString[1] , NameRecord.Slength.shortword );
			if (NameRecord.EncodingID.shortword = 1)
			then begin
				repeat
					ZeroPntr := Pos(Chr(0), NameString);
					if ZeroPntr <> 0 then Delete(NameString, ZeroPntr, 1);
				until ZeroPntr = 0;
			end;
			case NameRecord.NameID.shortword of
			//CopyRight msg
				0: FontInfoPtr^.Copyright := NameString;
			//Family Name
				1: FontInfoPtr^.Family := NameString;
			//Sub Family Name
				2: FontInfoPtr^.SubFamily := NameString;
			//Identifier
				3: FontInfoPtr^.Identifier := NameString;
			//Font name
				4: begin
					if not foundname then FontInfoPtr^.FontName := NameString;
					foundname := True;
				end;
			//Version
				5: FontInfoPtr^.Version := NameString;
			//Postscript Name
				6: FontInfoPtr^.PSname := NameString;
			//Trademark
				7: FontInfoPtr^.Trademark := NameString;
			end;//if namerecord
		end;//if namerecord.platformid.shortrecord
	end;//for records
	CloseFile(TT_File);
	Filemode := Oldmode;
end;

end.

unit stdio;

// Interface to C stdio.
//
// Copyright © 2001 Tempest Software, Inc.
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

interface

uses Libc, Classes;

// Get the standard C files.
function stdin: PIOFile;
function stdout: PIOFile;
function stderr: PIOFile;

// Call fopen to open a file, and assign the FILE pointer to the Kylix file F.
procedure AssignStdio(var F: TextFile; const FileName: string; const Mode: string = '');

// Call popen to open a pipe.
procedure AssignPopen(var F: TextFile; const CmdLine, Mode: string);

// Assign the standard input to F, which defaults to Input.
procedure AssignStdin(var F: TextFile; const Mode: string = 'r'); overload;
procedure AssignStdin; overload;

// Assign the standard output to F, which defaults to Output.
procedure AssignStdout(var F: TextFile; const Mode: string = 'w'); overload;
procedure AssignStdout; overload;

// Assign the standard error output to F, which defaults to ErrOutput.
procedure AssignStderr(var F: TextFile; const Mode: string = 'w'); overload;
procedure AssignStderr; overload;

// Get the file pointer for a Stdio-associated text file.
function GetFP(var F: TextFile): PIOFile;

type
  TStdioStream = class(TStream)
  private
    fStdioFile: PIOFile;
    fOwnership: TStreamOwnership;
  public
    constructor Create(StdioFile: PIOFile; Ownership: TStreamOwnership = soReference); overload;
    constructor Create(const Filename, Mode: string); overload;
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
    property StdioFile: PIOFile read fStdioFile;
    property StreamOwnership: TStreamOwnership read FOwnership write FOwnership;
  end;
  TTempStdioStream = class(TStdioStream)
  private
    fFilename: string;
    fDeleteOnClose: Boolean;
  public
    constructor Create(const Prototype: string = ''; const Modes: string = ''; DeleteOnClose: Boolean = True);
    destructor Destroy; override;
    property DeleteOnClose: Boolean read fDeleteOnClose write fDeleteOnClose;
    property Filename: string read fFilename;
  end;

implementation

uses SysUtils, unixutils;

// Don't bother to load stdin, etc., until needed. If getting one,
// might as well get them all. Note that Kylix doesn't seem to be able
// to link a $L directive file that wants to link with data in a shared
// library. Instead, load the library dynamically and get the symbols
// we need.
var
  c_stdin, c_stdout, c_stderr: PIOFile;

procedure GetCStdio;
var
  Handle: THandle;
  P: PPointer;
begin
  Handle := LoadLibrary(libcmodulename);
  if Handle = 0 then
    RaiseLastOSError;
  try
    P := GetProcAddress(Handle, 'stdin');
    c_stdin := P^;
    P := GetProcAddress(Handle, 'stdout');
    c_stdout := P^;
    P := GetProcAddress(Handle, 'stderr');
    c_stderr := P^;
  finally
    FreeLibrary(Handle);
  end;
end;

function stdin: PIOFile;
begin
  if c_stdin = nil then
    GetCStdio;
  Result := c_stdin;
end;

function stdout: PIOFile;
begin
  if c_stdout = nil then
    GetCStdio;
  Result := c_stdout;
end;

function stderr: PIOFile;
begin
  if c_stderr = nil then
    GetCStdio;
  Result := c_stderr;
end;



type
  TUserData = record
    FP: PIOFile;
    Mode: array[0..3] of Char;
    Pad: array[1..24] of Byte;
  end;

function GetFP(var F: TextFile): PIOFile;
begin
  Result := TUserData(TTextRec(F).UserData).FP;
end;

function StdioRead(var F: TTextRec): Integer;
var
  N: Integer;
begin
  N := fread(F.BufPtr, 1, F.BufSize, TUserData(F.UserData).FP);
  if N < 0 then
  begin
    Result := 1;
    SetInOutRes(errno);
  end
  else
  begin
    F.BufEnd := N;
    F.BufPos := 0;
    Result := 0;
  end;
end;

function StdioWrite(var F: TTextRec): Integer;
var
  N: Integer;
begin
  N := fwrite(F.BufPtr, 1, F.BufPos, TUserData(F.UserData).FP);
  if (N < 0) or (Cardinal(N) > F.BufPos) then
  begin
    Result := 1;
    SetInOutRes(errno);
  end
  else
  begin
    F.BufPos := 0;
    Result := 0;
  end;
end;

function StdioClose(var F: TTextRec): Integer;
begin
  fclose(TUserData(F.UserData).FP);
  TUserData(F.UserData).FP := nil;
  F.Mode := fmClosed;
  Result := 0;
end;

function StdioFlush(var F: TTextRec): Integer;
begin
  Result := 0;
end;

function StdioOpen(var F: TTextRec): Integer;
begin
  if TUserData(F.UserData).Mode[0] = #0 then
    case F.Mode of
    fmInput:  StrPCopy(TUserData(F.UserData).Mode, 'r');
    fmOutput: StrPCopy(TUserData(F.UserData).Mode, 'w');
    fmInOut:
      begin
        StrPCopy(TUserData(F.UserData).Mode, 'a');
        F.Mode := fmOutput;
      end;
    end;

  TUserData(F.UserData).FP := fopen(F.Name, TUserData(F.UserData).Mode);
  if TUserData(TTextRec(F).UserData).FP = nil then
  begin
    F.Mode := fmClosed;
    Result := 1;
    SetInOutRes(errno);
  end
  else
  begin
    if f.Mode = fmInOut then
      F.Mode := fmOutput;
    Result := 0;
  end;

  F.BufPtr := F.Buffer;
  F.BufPos := 0;
  F.BufEnd := 0;
  F.BufSize := 1;
  if F.Mode = fmInput then
    F.InOutFunc := @StdioRead
  else
    F.InOutFunc := @StdioWrite;
end;

function StdioPopen(var F: TTextRec): Integer;
begin
  TUserData(F.UserData).FP := popen(F.Name, TUserData(F.UserData).Mode);
  if TUserData(TTextRec(F).UserData).FP = nil then
  begin
    F.Mode := fmClosed;
    Result := 1;
    SetInOutRes(errno);
  end
  else
    Result := 0;

  F.BufPtr := F.Buffer;
  F.BufPos := 0;
  F.BufEnd := 0;
  F.BufSize := 1;
  if F.Mode = fmInput then
    F.InOutFunc := @StdioRead
  else
    F.InOutFunc := @StdioWrite;
end;

function StdioPclose(var F: TTextRec): Integer;
begin
  pclose(TUserData(F.UserData).FP);
  TUserData(F.UserData).FP := nil;
  F.Mode := fmClosed;
  Result := 0;
end;

procedure AssignPopen(var F: TextFile; const CmdLine, Mode: string);
begin
  FillChar(TTextRec(F), SizeOf(TTextRec), 0);
  TTextRec(F).Mode := fmClosed;
  TTextRec(F).OpenFunc := @StdioPopen;
  TTextRec(F).FlushFunc := @StdioFlush;
  TTextRec(F).CloseFunc := @StdioPclose;
  StrPLCopy(TTextRec(F).Name, CmdLine, SizeOf(TTextRec(F).Name)-1);
  StrPLCopy(TUserData(TTextRec(F).UserData).Mode, Mode, 3);
end;

procedure AssignStdio(var F: TextFile; const FileName, Mode: string);
begin
  FillChar(TTextRec(F), SizeOf(TTextRec), 0);
  TTextRec(F).Mode := fmClosed;
  TTextRec(F).OpenFunc := @StdioOpen;
  TTextRec(F).FlushFunc := @StdioFlush;
  TTextRec(F).CloseFunc := @StdioClose;
  StrPLCopy(TTextRec(F).Name, FileName, SizeOf(TTextRec(F).Name)-1);
  StrPLCopy(TUserData(TTextRec(F).UserData).Mode, Mode, 3);
end;

procedure AssignStdin(var F: TextFile; const Mode: string); overload;
begin
  FillChar(TTextRec(F), SizeOf(TTextRec), 0);
  TTextRec(F).Mode := fmInput;
  TTextRec(F).InOutFunc := @StdioRead;
  TTextRec(F).FlushFunc := @StdioFlush;
  TTextRec(F).CloseFunc := @StdioClose;
  TTextRec(F).OpenFunc  := @StdioOpen;
  TTextRec(F).BufPtr := TTextRec(F).Buffer;
  TTextRec(F).BufPos := 0;
  TTextRec(F).BufEnd := 0;
  TTextRec(F).BufSize := 1;
  StrPLCopy(TUserData(TTextRec(F).UserData).Mode, Mode, 3);
  TUserData(TTextRec(F).UserData).FP := stdin;
end;

procedure AssignStdin; overload;
begin
  AssignStdin(Input);
end;

procedure AssignStdout(var F: TextFile; const Mode: string); overload;
begin
  FillChar(TTextRec(F), SizeOf(TTextRec), 0);
  TTextRec(F).Mode := fmOutput;
  TTextRec(F).InOutFunc := @StdioWrite;
  TTextRec(F).FlushFunc := @StdioFlush;
  TTextRec(F).CloseFunc := @StdioClose;
  TTextRec(F).OpenFunc  := @StdioOpen;
  TTextRec(F).BufPtr := TTextRec(F).Buffer;
  TTextRec(F).BufPos := 0;
  TTextRec(F).BufEnd := 0;
  TTextRec(F).BufSize := 1;
  StrPLCopy(TUserData(TTextRec(F).UserData).Mode, Mode, 3);
  TUserData(TTextRec(F).UserData).FP := stdout;
end;

procedure AssignStdout; overload;
begin
  AssignStdout(Output);
end;

procedure AssignStderr(var F: TextFile; const Mode: string); overload;
begin
  FillChar(TTextRec(F), SizeOf(TTextRec), 0);
  TTextRec(F).Mode := fmOutput;
  TTextRec(F).InOutFunc := @StdioWrite;
  TTextRec(F).FlushFunc := @StdioFlush;
  TTextRec(F).CloseFunc := @StdioClose;
  TTextRec(F).OpenFunc  := @StdioOpen;
  TTextRec(F).BufPtr := TTextRec(F).Buffer;
  TTextRec(F).BufPos := 0;
  TTextRec(F).BufEnd := 0;
  TTextRec(F).BufSize := 1;
  StrPLCopy(TUserData(TTextRec(F).UserData).Mode, Mode, 3);
  TUserData(TTextRec(F).UserData).FP := stderr;
end;

procedure AssignStderr; overload;
begin
  AssignStderr(ErrOutput);
end;

{ TStdioStream }

constructor TStdioStream.Create(StdioFile: PIOFile;
  Ownership: TStreamOwnership);
begin
  inherited Create;
  fStdioFile := StdioFile;
  fOwnership := Ownership;
end;

constructor TStdioStream.Create(const Filename, Mode: string);
begin
  inherited Create;
  fStdioFile := fopen(PChar(Filename), PChar(Mode));
  if fStdioFile = nil then
    RaiseLastOSError;
  fOwnership := soOwned;
end;

destructor TStdioStream.Destroy;
begin
  if (StreamOwnership = soOwned) and (StdioFile <> nil) then
    fclose(StdioFile);
  inherited;
end;

function TStdioStream.Read(var Buffer; Count: Integer): Longint;
begin
  Result := fread(@Buffer, 1, Count, StdioFile)
end;

function TStdioStream.Seek(const Offset: Int64;
  Origin: TSeekOrigin): Int64;
begin
  Result := fseeko64(StdioFile, Offset, Ord(Origin));
end;

function TStdioStream.Write(const Buffer; Count: Integer): Longint;
begin
  Result := fwrite(@Buffer, 1, Count, StdioFile);
end;


{ TTempStdioStream }

constructor TTempStdioStream.Create(const Prototype, Modes: string;
  DeleteOnClose: Boolean);
var
  Handle: TFileHandle;
begin
  fFilename := Prototype;
  if Length(Filename) = 0 then
    fFilename := '/tmp/tmpXXXXXX'
  else if (Length(Filename) < 6) or (Copy(Filename, Length(Filename) - 6 + 1, 6) <> 'XXXXXX') then
    fFilename := Filename + 'XXXXXX'
  else
    UniqueString(fFilename);

  Handle := mkstemp(PChar(Filename));
  if Handle < 0 then
    raise EFOpenError.CreateFmt('%s: %s', [strerror, Filename]);

  fDeleteOnClose := DeleteOnClose;
  if Length(Modes) = 0 then
    inherited Create(fdopen(Handle, 'r+'), soOwned)
  else
    inherited Create(fdopen(Handle, PChar(Modes)), soOwned);
end;

destructor TTempStdioStream.Destroy;
begin
  inherited;
  if DeleteOnClose then
    DeleteFile(Filename);
end;

initialization
finalization
  rcs_id('$Id: stdio.pas,v 1.1 2003/01/21 19:47:04 ttm Exp $');
end.

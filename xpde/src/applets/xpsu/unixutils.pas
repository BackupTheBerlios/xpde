unit unixutils;

// Various UNIX utility functions.
//
// Many of these functions are Pascal wrappers for C functions, so they
// are easier to use in Kylix programs.
//
// A few Windows definitions are also provided, for compatibility. I will write
// more Windows equivalents when I find the time. Right now, I haven't even
// tested whether all the Windows code compiles successfully.
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

{$ifdef MSWINDOWS}
uses Windows, Types, SysUtils, Classes;
{$endif}
{$ifdef LINUX}
uses Libc, Types, SysUtils, Classes;
{$endif}

type
  // Some simple types that enhance portability between Delphi and Kylix.
{$ifdef MSWINDOWS}
  TFileHandle = THandle;
  TProcessHandle = THandle;
{$endif}
{$ifdef LINUX}
  TFileHandle = Integer;
  TProcessHandle = pid_t;
{$endif}

  // Class wrapper for a pipe.
  TPipe = class
  private
  {$ifdef MSWINDOWS}
    fReadHandle: TFileHandle;
    fWriteHandle: TFileHandle;
  {$endif}
  {$ifdef LINUX}
    fHandles: TPipeDescriptors;
  {$endif}
  public
    constructor Create(Inheritable: Boolean = True);
    destructor Destroy; override;
    procedure CloseReadHandle;
    procedure CloseWriteHandle;
    procedure CloseHandles;
    function ReadIsClosed: Boolean;
    function WriteIsClosed: Boolean;

  {$ifdef MSWINDOWS}
    procedure DuplicateRead(Inheritable: Boolean);
    procedure DuplicateWrite(Inheritable: Boolean);
    property ReadHandle: TFileHandle read fReadHandle;
    property WriteHandle: TFileHandle read fWriteHandle;
  {$endif}
  {$ifdef LINUX}
    procedure DuplicateRead(NewFd: Integer = stdin);
    procedure DuplicateWrite(NewFd: Integer = stdout);
    property ReadHandle: TFileHandle read fHandles.ReadDes;
    property WriteHandle: TFileHandle read fHandles.WriteDes;
  {$endif}
  end;

  // Stream wrapper for a pipe.
  TPipeStream = class(TStream)
  private
    fPipe: TPipe;
    function GetReadHandle: TFileHandle;
    function GetWriteHandle: TFileHandle;
  protected
    property Pipe: TPipe read fPipe;
  public
    constructor Create(Inheritable: Boolean = True);
    destructor Destroy; override;
    function Read(var Buffer; Count: Integer): Integer; override;
    function Seek(Offset: Integer; Origin: Word): Integer; override;
    function Write(const Buffer; Count: Integer): Integer; override;

    procedure CloseReadHandle;
    procedure CloseWriteHandle;

  {$ifdef MSWINDOWS}
    procedure DuplicateRead(Inheritable: Boolean);
    procedure DuplicateWrite(Inheritable: Boolean);
    property ReadHandle: TFileHandle read GetReadHandle;
    property WriteHandle: TFileHandle read GetWriteHandle;
  {$endif}
  {$ifdef LINUX}
    procedure DuplicateRead(NewFd: Integer = stdin);
    procedure DuplicateWrite(NewFd: Integer = stdout);
    property ReadHandle: TFileHandle read GetReadHandle;
    property WriteHandle: TFileHandle read GetWriteHandle;
  {$endif}
  end;

  // Stream wrappers similar to popen/pclose. TCommandStream is an abstract
  // base class. Use one of the concrete classes TWriteToCommandStream or
  // TReadFromCommandStream, or call a simpler function, such as
  // WriteToProgram or ReadFromProgram.
  TCommandStream = class(TStream)
  private
    fPipe: TPipeStream;
    fProcess: TProcessHandle;
  protected
    property Pipe: TPipeStream read fPipe;
  public
    destructor Destroy; override;
    function Read(var Buffer; Count: Integer): Integer; override; abstract;
    function Seek(Offset: Integer; Origin: Word): Integer; override;
    function WaitFor: Integer;
    function Write(const Buffer; Count: Integer): Integer; override; abstract;
    property ProcessHandle: TProcessHandle read fProcess;
  end;

  // Run a program and read its standard output as a stream.
  TReadFromCommandStream = class(TCommandStream)
  public
    // The first three constructors are preferred, but the last one is an option
    // for simpler uses.
    constructor Create(const Path: string; const Args: array of string; Env: PPChar = nil); overload;
    constructor Create(const Path: string; Args: TStrings; Env: PPChar = nil); overload;
    constructor Create(const Path: string; Args: PPChar; Env: PPChar = nil); overload;
    constructor Create(const CmdLine: string); overload;
    function Read(var Buffer; Count: Integer): Integer; override;
    function Write(const Buffer; Count: Integer): Integer; override;
  end;

  // Run a program, piping the stream as the program's standard input.
  TWriteToCommandStream = class(TCommandStream)
  public
    // The first three constructor are preferred, but the last one is an option
    // for simpler uses.
    constructor Create(const Path: string; const Args: array of string; Env: PPChar = nil); overload;
    constructor Create(const Path: string; Args: TStrings; Env: PPChar = nil); overload;
    constructor Create(const Path: string; Args: PPChar; Env: PPChar = nil); overload;
    constructor Create(const CmdLine: string); overload;
    function Read(var Buffer; Count: Integer): Integer; override;
    function Write(const Buffer; Count: Integer): Integer; override;
  end;

  // All the TCommandStream classes raise EPipeError for exceptions.
  EPipeError = class(Exception);

{$ifdef LINUX}
  // Stream opened on a temporary file.
  TTempStream = class(THandleStream)
  private
    fFileName: string;
    fDeleteOnClose: Boolean;
  public
    constructor Create(const Prototype: string = ''; DeleteOnClose: Boolean = True);
    destructor Destroy; override;
    property DeleteOnClose: Boolean read fDeleteOnClose write fDeleteOnClose default True;
    property FileName: string read FFileName;
  end;
{$endif}

// The rcs_id function does nothing. It is useful for storing an RCS
// string in a manner that ensures the string will be linked into the
// final executable file, and not be optimized away. For example, include
// a call to rcs_id('$Id: unixutils.pas,v 1.1 2003/01/21 19:47:04 ttm Exp $') in a program or in a unit's initialization
// or finalization code.
procedure rcs_id(const S: string);

{$ifdef MSWINDOWS}
// Combine Args into a single string.
function MakeCmdLine(const ProgramPath: string; const Args: array of string): string; overload;
function MakeCmdLine(const ProgramPath: string; Args: TStrings): string; overload;
{$endif}

{$ifdef LINUX}
// Return the path to the user's preferred shell.
function GetShell: string;

// Take an array of strings and return a pointer to a PChar array.
// The caller is responsible for freeing the PChar array by calling FreeMem.
function MakePCharArray(const Args: array of string; const ProgramPath: string = ''): PPChar; overload;
function MakePCharArray(Args: TStrings; const ProgramPath: string = ''): PPChar; overload;

// Run a program and wait for it to finish. Return the status from waitpid.
function RunProgram(const ProgramPath: string; Args: TStrings; Env: PPChar = nil): Integer; overload;
function RunProgram(const ProgramPath: string; const Args: array of string; Env: PPChar = nil): Integer; overload;
function RunProgram(const CmdLine: string): Integer; overload;

// Run a program and wait for it to finish. Save its standard output and error
// output in strings. Return the status from waitpid.
function ReadFromProgram(const ProgramPath: string; const Args: array of string;
    out Output, ErrOutput: string; Env: PPChar = nil): Integer; overload;
function ReadFromProgram(const ProgramPath: string; Args: TStrings;
    out Output, ErrOutput: string; Env: PPChar = nil): Integer; overload;
function ReadFromProgram(const ProgramPath: string; Args: PPChar;
    out Output, ErrOutput: string; Env: PPChar = nil): Integer; overload;
function ReadFromProgram(const CmdLine: string; out Output, ErrOutput: string): Integer; overload;

// Run a program and wait for it to finish. Supply a string as the program's
// standard input. Return the status from waitpid.
function WriteToProgram(const ProgramPath: string; const Args: array of string;
    const Input: string; Env: PPChar = nil): Integer; overload;
function WriteToProgram(const ProgramPath: string; Args: TStrings;
    const Input: string; Env: PPChar = nil): Integer; overload;
function WriteToProgram(const ProgramPath: string; Args: PPChar;
    const Input: string; Env: PPChar = nil): Integer; overload;
function WriteToProgram(const CmdLine: string; const Input: string): Integer; overload;

// Run a program and wait for it to finish. Supply Input as the input.
// Store the output and error output in Output and ErrOutput. Return the
// status from waitpid.
function ReadWriteProgram(const ProgramPath: string; Args: PPChar;
    Input, Output, ErrOutput: TStream; Env: PPChar = nil): Integer; overload;
function ReadWriteProgram(const ProgramPath: string; const Args: array of string;
    const Input: string; var Output, ErrOutput: string; Env: PPChar = nil): Integer; overload;
function ReadWriteProgram(const ProgramPath: string; Args: TStrings;
    const Input: string; var Output, ErrOutput: string; Env: PPChar = nil): Integer; overload;
function ReadWriteProgram(const ProgramPath: string; Args: PPChar;
    const Input: string; var Output, ErrOutput: string; Env: PPChar = nil): Integer; overload;
function ReadWriteProgram(const CmdLine: string;
    const Input: string; var Output, ErrOutput: string): Integer; overload;

// Start a program in a subprocess, but do not wait. Return the PID.
function RunNoWait(const ProgramPath: string; const Args: array of string;
    Env: PPChar = nil): TProcessHandle; overload;
function RunNoWait(const CmdLine: string): TProcessHandle; overload;

// Various wrappers for execve that are better suited to Kylix.
function exec(const ProgramPath: string; Args, Env: TStrings): Integer; overload;
function exec(const ProgramPath: string; Args: TStrings; Env: PPChar): Integer; overload;
function exec(const ProgramPath: string; const Args: array of string; const Env: array of string): Integer; overload;
function exec(const ProgramPath: string; const Args: array of string; Env: PPChar): Integer; overload;
function exec(const ProgramPath: string; Argv, Env: PPChar): Integer; overload;
function exec(const ProgramPath: string; const Args: array of string): Integer; overload;
function exec(const CmdLine: string): Integer; overload;

// Wrappers for Libc functions. In general, these use strings instead of PChars.
// Also, errors raise exceptions, so many functions are wrapped as procedures.

// Print an error message to stderr, for the current value of errno.
// Use Str as a prefix for the message.
procedure perror(const Str: string);
// Return the error string for the given error number.
function strerror(Errno: Integer): string; overload;
// Return the error string for the current value of errno.
function strerror: string; overload;

// Change a file's times.
procedure utime(const Path: string; AccessTime, ModTime: TDateTime);
procedure utimes(const Path: string; AccessTime, ModTime: TDateTime);

// Create a hard link.
procedure link(const OldPath, NewPath: string);
// Create a symbolic (soft) link.
procedure symlink(const OldPath, NewPath: string);
// Return the value of a symbolic link, or raise an exception if Path is
// not a symbolic link.
function readlink(const Path: string): string;
// stat a file or symbolic link.
procedure stat(const Path: string; var statbuf: TStatBuf); overload;
procedure lstat(const Path: string; var statbuf: TStatBuf); overload;
procedure stat(const Path: string; var statbuf: TStatBuf64); overload;
procedure lstat(const Path: string; var statbuf: TStatBuf64); overload;

// Rename a file.
procedure rename(const OldName, NewName: string);

// Change a file's size.
procedure truncate(const Path: string; NewSize: off_t); overload;
procedure truncate(const Path: string; NewSize: off64_t); overload;

// This version of pselect might be easier to use in Kylix. Pass arrays of
// file descriptors that you are interested in. The function returns
// an array of file descriptors that will not block. If, for some reason,
// you need to pass the same file descriptor in more than one fd_set,
// you cannot use this version, and must use the Libc version. The Timeout
// is the integral number of nanoseconds to wait. Zero means poll; negative
// means wait forever.
function pselect(const ReadFds, WriteFds, ExceptFds: array of Integer;
  Timeout: Int64 = -1; Sigmask: PSigSet = nil): TIntegerDynArray;

// Libc declares the __timeout parameters incorrectly, so fix it.
function __pselect(__nfds: Integer; __readfds, __writefds, __exceptfds: PFDSet;
  __timeout: Ptimespec = nil; __sigmask: PSigSet = nil): Integer; cdecl;

// Libc.FD_ISSET erroneously declares its fdset argument as VAR instead
// of CONST.
function FD_ISSET(fd: TFileDescriptor; const fdset: TFDSet): Boolean;

// Libc.chown is bound to the wrong version of chown.
function chown(FileName: PChar; Owner: __uid_t; Group: __gid_t): Integer; cdecl; overload;

// Libc has truncate64, but not truncate. The difference isn't much,
// and truncate64 is a proper superset of the functionality of truncate, but
// experienced UNIX programmers might balk at the omission.
function truncate(FileName: PChar; NewSize: off_t): Integer; cdecl; overload;

// C programmers have to use bits and octal numbers and other yucky
// stuff that's hard to program and hard to debug. Pascal programmers
// can use enumerated literals and sets.
type
  TModeBits = (mExecOther, mWriteOther, mReadOther,
               mExecGroup, mWriteGroup, mReadGroup,
               mExecUser,  mWriteUser,  mReadUser,
               mSticky, mSetGid, mSetUid);
  TMode = set of TModeBits;
// Change a file's mode (permission).
procedure chmod(const Path: string; Mode: mode_t); overload;
procedure chmod(const Path: string; Mode: TMode); overload;
procedure chown(const Path: string; Uid: uid_t; Gid: gid_t); overload;
procedure lchown(const Path: string; Uid: uid_t; Gid: gid_t);
// Set the default mode mask. (New files are created with a mode that
// is formed by removing all bits in the umask.)
function umask(Mode: TModeBits): TModeBits;

procedure DateTimeToTimeval(DateTime: TDateTime; var tv: timeval);
procedure DateTimeToTimespec(DateTime: TDateTime; var ts: timespec);
{$endif}

implementation

{$ifdef LINUX}
uses KernelIoctl;
{$endif}

{$ifdef LINUX}
function __pselect;       external libcmodulename name 'pselect';
function chown(FileName: PChar; Owner: __uid_t; Group: __gid_t): Integer; cdecl; external libcmodulename name '__chown';
function truncate(FileName: PChar; NewSize: off_t): Integer; cdecl; external libcmodulename name 'truncate';
{$endif}

resourcestring
  sCantSeek = 'Cannot seek in a pipe stream';
  sCantWrite = 'Cannot write to a read-only stream';
  sCantRead = 'Cannot read from a write-only stream';

var
  UnixEpoch: TDateTime;

procedure rcs_id(const S: string);
begin
end;

{$ifdef LINUX}
procedure DateTimeToTimeval(DateTime: TDateTime; var tv: timeval);
var
  Seconds: TDateTime;
begin
  Seconds := (DateTime - UnixEpoch) * SecsPerDay;
  tv.tv_sec := Trunc(Seconds);
  tv.tv_usec := Round(Frac(Seconds) * 1000000);
end;

procedure DateTimeToTimespec(DateTime: TDateTime; var ts: timespec);
var
  Seconds: TDateTime;
begin
  Seconds := (DateTime - UnixEpoch) * SecsPerDay;
  ts.tv_sec := Trunc(Seconds);
  ts.tv_nsec := Round(Frac(Seconds) * 1000000000);
end;
{$endif}

{$ifdef MSWINDOWS}
// Combine Args into a single string.
function MakeCmdLine(const ProgramPath: string; Args: TStrings): string; overload;
var
  I: Integer;
begin
  Result := ProgramPath;
  for I := 0 to Args.Count-1 do
    Result := Result + ' ' + Args[I];
end;

// Combine Args into a single string.
function MakeCmdLine(const ProgramPath: string; const Args: array of string): string; overload;
var
  I: Integer;
begin
  Result := ProgramPath;
  for I := Low(Args) to High(Args) do
    Result := Result + ' ' + Args[I];
end;
{$endif}

{$ifdef LINUX}
resourcestring
  DefaultShell = '/bin/sh';

// Return the path to the user's preferred shell. The default is /bin/sh,
// but that can be configured with a resource string.
function GetShell: string;
begin
  Result := getenv('SHELL');
  if Length(Result) = 0 then
    Result := DefaultShell;
end;

// Return a PChar array equivalent for an array of strings. Append a nil pointer
// to the PChar array. If ProgramPath is not an empty string, insert it as
// the first element of the PChar array. The caller is responsible for
// freeing the PChar array by calling FreeMem. Note that the most common
// use is for preparing argv and env arrays for exec, and after a successful
// exec, there is no need to free any memory.
function MakePCharArray(const Args: array of string; const ProgramPath: string): PPChar; overload;
var
  Argv: PPCharArray;
  Count: Integer;
  Origin: Integer;
  I: Integer;
begin
  Count := Length(Args) + 1;
  if Length(ProgramPath) <> 0 then
    Inc(Count);

  GetMem(Argv, Count * SizeOf(PChar));

  try
    if Length(ProgramPath) = 0 then
      Origin := 0
    else
    begin
      Argv[0] := PChar(ProgramPath);
      Origin := 1;
    end;

    for I := Low(Args) to High(Args) do
      Argv[I+Origin] := PChar(Args[I]);
    Argv[Length(Args)+Origin] := nil;
    Result := @Argv[0];
  except
    FreeMem(Argv);
    raise;
  end;
end;

// Return a PChar array equivalent for a TStrings object. Append a nil pointer
// to the PChar array. If ProgramPath is not an empty string, insert it as
// the first element of the PChar array. The caller is responsible for
// freeing the PChar array by calling FreeMem. Note that the most common
// use is for preparing argv and env arrays for exec, and after a successful
// exec, there is no need to free any memory.
function MakePCharArray(Args: TStrings; const ProgramPath: string): PPChar; overload;
var
  Argv: PPCharArray;
  Count: Integer;
  Origin: Integer;
  I: Integer;
begin
  Count := Args.Count + 1;
  if Length(ProgramPath) <> 0 then
    Inc(Count);

  GetMem(Argv, Count * SizeOf(PChar));

  try
    if Length(ProgramPath) = 0 then
      Origin := 0
    else
    begin
      Argv[0] := PChar(ProgramPath);
      Origin := 1;
    end;

    for I := 0 to Args.Count-1 do
      Argv[I+Origin] := PChar(Args[I]);
    Argv[Args.Count+Origin] := nil;
    Result := @Argv[0];
  except
    FreeMem(Argv);
    raise;
  end;
end;

// Below are wrappers for execve that are more Pascal-like.
function exec(const ProgramPath: string; Args, Env: TStrings): Integer; overload;
var
  Envp: PPChar;
begin
  Envp := MakePCharArray(Env);
  Result := exec(ProgramPath, Args, Envp);
  FreeMem(Envp);
end;

function exec(const ProgramPath: string; Args: TStrings; Env: PPChar): Integer; overload;
var
  Argv: PPChar;
begin
  if Env = nil then
{$warn symbol_platform off}
    Env := envp;
{$warn symbol_platform on}
  Argv := MakePCharArray(Args, ProgramPath);
  Result := exec(ProgramPath, Argv, Env);
  FreeMem(Argv);
end;

function exec(const ProgramPath: string; const Args: array of string; const Env: array of string): Integer; overload;
var
  Envp: PPChar;
begin
  Envp := MakePCharArray(Env);
  Result := exec(ProgramPath, Args, Envp);
  FreeMem(Envp);
end;

function exec(const ProgramPath: string; const Args: array of string; Env: PPChar): Integer; overload;
var
  Argv: PPChar;
begin
  if Env = nil then
{$warn symbol_platform off}
    Env := envp;
{$warn symbol_platform on}
  Argv := MakePCharArray(Args, ProgramPath);
  Result := exec(ProgramPath, Argv, Env);
  FreeMem(Argv);
end;

function exec(const ProgramPath: string; Argv, Env: PPChar): Integer; overload;
begin
  Result := execve(PChar(ProgramPath), Argv, Env);
end;

function exec(const ProgramPath: string; const Args: array of string): Integer; overload;
begin
{$warn symbol_platform off}
  Result := exec(ProgramPath, Args, envp);
{$warn symbol_platform on}
end;

function exec(const CmdLine: string): Integer; overload;
begin
  Result := exec(GetShell, ['-c', CmdLine]);
end;

// Libc.FD_ISSET erroneously declares its fdset argument as VAR instead
// of CONST.
function FD_ISSET(fd: TFileDescriptor; const fdset: TFDSet): Boolean;
begin
  Result := (fdset.fds_bits[__FDELT(fd)] and __FDMASK(fd)) <> 0;
end;

// Read from Pipe's read handle if that file descriptor is set
// in Fds. Read only as many bytes as are available, to prevent
// the caller from blocking. Return the text that was read from
// the file descriptor.
function ReadFd(const Fds: TFDSet; Pipe: TPipe): string;
var
  Count: Integer;
begin
  Result := '';
  if not Pipe.ReadIsClosed and FD_ISSET(Pipe.ReadHandle, Fds) then
  begin
    if ioctl(Pipe.ReadHandle, FIONREAD, @Count) < 0 then
      RaiseLastOSError;
    if Count = 0 then
      Pipe.CloseReadHandle
    else
    begin
      SetLength(Result, Count);
      if __read(Pipe.ReadHandle, Result[1], Count) <> Count then
        RaiseLastOSError;
    end;
  end;
end;

// Write to Pipe's write handle if that file descriptor is set in Fds.
// Write only one pipe buffer's worth of text, to prevent the caller
// from blocking. Copy the text from Stream.
procedure WriteFd(const Fds: TFDSet; Pipe: TPipe; Stream: TStream);
var
  Count: Integer;
  Buffer: string;
begin
  if not Pipe.WriteIsClosed and FD_ISSET(Pipe.WriteHandle, Fds) then
  begin
    SetLength(Buffer, fpathconf(Pipe.WriteHandle, _PC_PIPE_BUF));
    Count := Stream.Read(Buffer[1], Length(Buffer));
    if Count = 0 then
      Pipe.CloseWriteHandle
    else
    begin
      if __write(Pipe.WriteHandle, Buffer[1], Count) <> Count then
        RaiseLastOSError;
    end;
  end;
end;

// Set Pipe's read handle in Fds. If the file descriptor has a higher
// value than MaxFd, update MaxFd.
procedure SetReadFd(var Fds: TFDSet; Pipe: TPipe; var MaxFd: TFileHandle);
begin
  if not Pipe.ReadIsClosed then
  begin
    FD_SET(Pipe.ReadHandle, Fds);
    if Pipe.ReadHandle > MaxFd then
      MaxFd := Pipe.ReadHandle;
  end;
end;

// Set Pipe's write handle in Fds. If the file descriptor has a higher
// value than MaxFd, update MaxFd.
procedure SetWriteFd(var Fds: TFDSet; Pipe: TPipe; var MaxFd: TFileHandle);
begin
  if not Pipe.WriteIsClosed then
  begin
    FD_SET(Pipe.WriteHandle, Fds);
    if Pipe.WriteHandle > MaxFd then
      MaxFd := Pipe.WriteHandle;
  end;
end;

// Run a program and read its standard output and error output.
function ReadFromProgram(const ProgramPath: string; Args: PPChar;
    out Output, ErrOutput: string; Env: PPChar): Integer; overload;
var
  StdoutPipe, StderrPipe: TPipe;
  Pid: TProcessHandle;
  ReadFds: TFDSet;
  MaxFd: Integer;
begin
  StdoutPipe := nil;
  StderrPipe := nil;
  try
    StdoutPipe := TPipe.Create;
    StderrPipe := TPipe.Create;
    Pid := fork;
    if Pid < 0 then
      RaiseLastOSError
    else if Pid = 0 then
    begin
      // In the child process.
      StdoutPipe.DuplicateWrite;
      StderrPipe.DuplicateWrite(stderr);
      StdoutPipe.CloseHandles;
      StderrPipe.CloseHandles;

      if Env = nil then
{$warn symbol_platform off}
        Env := envp;
{$warn symbol_platform on}

      exec(ProgramPath, Args, Env);
      perror(ProgramPath);
      __abort;
    end
    else
    begin
      // In the parent.
      StdoutPipe.CloseWriteHandle;
      StderrPipe.CloseWriteHandle;
      Output := '';
      ErrOutput := '';
      while not StdoutPipe.ReadIsClosed or not StderrPipe.ReadIsClosed do
      begin
        FD_ZERO(ReadFds);
        MaxFd := Low(Integer);
        SetReadFd(ReadFds, StdoutPipe, MaxFd);
        SetReadFd(ReadFds, StderrPipe, MaxFd);
        if __pselect(MaxFd+1, @ReadFds, nil, nil) < 0 then
          RaiseLastOSError;
        Output := Output + ReadFd(ReadFds, StdoutPipe);
        ErrOutput := ErrOutput + ReadFd(ReadFds, StderrPipe);
      end;
      WaitPid(Pid, @Result, 0);
    end;
  finally
    StdoutPipe.Free;
    StderrPipe.Free;
  end;
end;

// Run a program and read its standard output and error output.
function ReadFromProgram(const CmdLine: string; out Output, ErrOutput: string): Integer; overload;
begin
  Result := ReadFromProgram(GetShell, ['-c', CmdLine], Output, ErrOutput);
end;

// Run a program and read its standard output and error output.
function ReadFromProgram(const ProgramPath: string; Args: TStrings;
    out Output, ErrOutput: string; Env: PPChar): Integer; overload;
var
  Argv: PPChar;
begin
  Argv := MakePCharArray(Args);
  Result := ReadFromProgram(ProgramPath, Argv, Output, ErrOutput, Env);
  FreeMem(Argv);
end;

// Run a program and read its standard output and error output.
function ReadFromProgram(const ProgramPath: string; const Args: array of string;
    out Output, ErrOutput: string; Env: PPChar): Integer; overload;
var
  Argv: PPChar;
begin
  Argv := MakePCharArray(Args);
  Result := ReadFromProgram(ProgramPath, Argv, Output, ErrOutput, Env);
  FreeMem(Argv);
end;

// Run a program, piping Input as its standard input, and storing
// the standard output and error output in Output and ErrOutput.
function ReadWriteProgram(const ProgramPath: string; Args: PPChar;
    Input, Output, ErrOutput: TStream; Env: PPChar): Integer; overload;
var
  StdinPipe, StdoutPipe, StderrPipe: TPipe;
  Str: String;
  Pid: TProcessHandle;
  ReadFds, WriteFds: TFDSet;
  MaxFd: Integer;
begin
  StdinPipe  := nil;
  StdoutPipe := nil;
  StderrPipe := nil;
  try
    StdinPipe  := TPipe.Create;
    StdoutPipe := TPipe.Create;
    StderrPipe := TPipe.Create;
    Pid := fork;
    if Pid < 0 then
      RaiseLastOSError
    else if Pid = 0 then
    begin
      // In the child process. Duplicate the pipes as stdin, stdout, and stderr.
      StdinPipe.DuplicateRead;
      StdoutPipe.DuplicateWrite;
      StderrPipe.DuplicateWrite(stderr);
      // Now that the pipes have been duplicated, close their handles.
      StdinPipe.CloseHandles;
      StdoutPipe.CloseHandles;
      StderrPipe.CloseHandles;

      if Env = nil then
{$warn symbol_platform off}
        Env := envp;
{$warn symbol_platform on}

      // Here we go...
      exec(ProgramPath, Args, Env);
      // Oops. That didn't work.
      perror('exec');
      __abort;
    end
    else
    begin
      // In the parent.
      StdinPipe.CloseReadHandle;
      StdoutPipe.CloseWriteHandle;
      StderrPipe.CloseWriteHandle;
      while not StdinPipe.WriteIsClosed or not StdoutPipe.ReadIsClosed or not StderrPipe.ReadIsClosed do
      begin
        FD_ZERO(ReadFds);
        FD_ZERO(WriteFds);
        MaxFd := Low(Integer);
        // Try to write to the child's stdin, or read from child's stdout or stderr.
        SetReadFd(ReadFds, StdoutPipe, MaxFd);
        SetReadFd(ReadFds, StderrPipe, MaxFd);
        SetWriteFd(WriteFds, StdinPipe, MaxFd);
        if __pselect(MaxFd+1, @ReadFds, @WriteFds, nil) < 0 then
          RaiseLastOSError;
        WriteFd(WriteFds, StdinPipe, Input);
        Str := ReadFd(ReadFds, StdoutPipe);
        if Length(Str) > 0 then
          Output.WriteBuffer(Str[1], Length(Str));
        Str := ReadFd(ReadFds, StderrPipe);
        if Length(Str) > 0 then
          ErrOutput.WriteBuffer(Str[1], Length(Str));
      end;
      WaitPid(Pid, @Result, 0);
    end;
  finally
    StdinPipe.Free;
    StdoutPipe.Free;
    StderrPipe.Free;
  end;
end;

function ReadWriteProgram(const ProgramPath: string; Args: PPChar;
    const Input: string; var Output, ErrOutput: string; Env: PPChar): Integer; overload;
var
  StdoutStream, StderrStream, StdinStream: TStringStream;
begin
  StdoutStream := nil;
  StderrStream := nil;
  StdinStream := nil;
  try
    StdinStream := TStringStream.Create(Input);
    StdoutStream := TStringStream.Create('');
    StderrStream := TStringStream.Create('');
    Result := ReadWriteProgram(ProgramPath, Args, StdinStream, StdoutStream, StderrStream, Env);
    Output := StdoutStream.DataString;
    ErrOutput := StderrStream.DataString;
  finally
    StdinStream.Free;
    StdoutStream.Free;
    StderrStream.Free;
  end;
end;

// Run a program, piping Input as its standard input, and storing
// the standard output and error output in Output and ErrOutput.
function ReadWriteProgram(const ProgramPath: string; const Args: array of string;
    const Input: string; var Output, ErrOutput: string; Env: PPChar): Integer; overload;
var
  Argv: PPChar;
begin
  Argv := MakePCharArray(Args);
  Result := ReadWriteProgram(ProgramPath, Argv, Input, Output, ErrOutput, Env);
  FreeMem(Argv);
end;

// Run a program, piping Input as its standard input, and storing
// the standard output and error output in Output and ErrOutput.
function ReadWriteProgram(const ProgramPath: string; Args: TStrings;
    const Input: string; var Output, ErrOutput: string; Env: PPChar): Integer; overload;
var
  Argv: PPChar;
begin
  Argv := MakePCharArray(Args);
  Result := ReadWriteProgram(ProgramPath, Argv, Input, Output, ErrOutput, Env);
  FreeMem(Argv);
end;

// Run a program, piping Input as its standard input, and storing
// the standard output and error output in Output and ErrOutput.
function ReadWriteProgram(const CmdLine: string;
                          const Input: string; var Output, ErrOutput: string): Integer; overload;
begin
  Result := ReadWriteProgram(GetShell, ['-c', CmdLine], Input, Output, ErrOutput);
end;
{$endif}

// Run a program and wait for it to finish.
function RunProgram(const ProgramPath: string; Args: TStrings; Env: PPChar = nil): Integer; overload;
{$ifdef LINUX}
var
  Pid: TProcessHandle;
{$endif}
begin
{$ifdef MSWINDOWS}
  RunProgram(MakeCmdLine(ProgramPath, Args));
{$endif}
{$ifdef LINUX}
  Pid := fork;
  if Pid < 0 then
    RaiseLastOSError
  else if Pid = 0 then
  begin
    exec(ProgramPath, Args, Env);
    perror('exec');
    __abort;
  end
  else
    WaitPid(Pid, @Result, 0);
{$endif}
end;

// Run a program and wait for it to finish.
function RunProgram(const ProgramPath: string; const Args: array of string; Env: PPChar): Integer; overload;
{$ifdef LINUX}
var
  Pid: TProcessHandle;
{$endif}
begin
{$ifdef MSWINDOWS}
  RunProgram(MakeCmdLine(ProgramPath, Args));
{$endif}
{$ifdef LINUX}
  Pid := fork;
  if Pid < 0 then
    RaiseLastOSError
  else if Pid = 0 then
  begin
    exec(ProgramPath, Args, Env);
    perror('exec');
    __abort;
  end
  else
    WaitPid(Pid, @Result, 0);
{$endif}
end;

// Run a program and wait for it to finish.
function RunProgram(const CmdLine: string): Integer; overload;
{$ifdef MSWINDOWS}
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
{$endif}
begin
{$ifdef MSWINDOWS}
  FillChar(StartupInfo, SizeOf(StartupInfo), 0);
  StartupInfo.cb := SizeOf(StartupInfo);
  Win32Check(CreateProcess(nil, PChar(CmdLine), nil, nil, True, 0, nil, nil, StartupInfo, ProcessInfo));
  Result := ProcessInfo.hProcess;
  // Don't need the thread handle.
  Win32Check(CloseHandle(ProcessInfo.hThread));
  // Wait for the process to end and return its status.
  Result := CloseHandle(ProcessInfo.hProcess);
{$endif}
{$ifdef LINUX}
  Result := RunProgram(GetShell, ['-c', CmdLine]);
{$endif}
end;

// Run a program, pipong the contents of Input to its standard input.
function WriteToProgram(const ProgramPath: string; Args: PPChar;
    const Input: string; Env: PPChar = nil): Integer; overload;
var
  Stream: TWriteToCommandStream;
begin
  Stream := TWriteToCommandStream.Create(ProgramPath, Args, Env);
  try
    Stream.WriteBuffer(Input[1], Length(Input));
    Result := Stream.WaitFor;
  finally
    Stream.Free;
  end;
end;

// Run a program, pipong the contents of Input to its standard input.
function WriteToProgram(const ProgramPath: string; Args: TStrings;
    const Input: string; Env: PPChar = nil): Integer; overload;
var
  Argv: PPChar;
begin
  Argv := MakePCharArray(Args);
  Result := WriteToProgram(ProgramPath, Argv, Input, Env);
  FreeMem(Argv);
end;

// Run a program, pipong the contents of Input to its standard input.
function WriteToProgram(const ProgramPath: string; const Args: array of string;
    const Input: string; Env: PPChar): Integer; overload;
var
  Argv: PPChar;
begin
  Argv := MakePCharArray(Args);
  Result := WriteToProgram(ProgramPath, Argv, Input, Env);
  FreeMem(Argv);
end;

// Run a program, pipong the contents of Input to its standard input.
function WriteToProgram(const CmdLine: string; const Input: string): Integer; overload;
begin
  Result := WriteToProgram(GetShell, ['-c', CmdLine], Input);
end;

// Run a program but do not wait for it to finish. Return its PID.
function RunNoWait(const ProgramPath: string; const Args: array of string; Env: PPChar): TProcessHandle; overload;
begin
{$ifdef MSWINDOWS}
  RunNoWait(MakeCmdLine(ProgramPath, Args));
{$endif}
{$ifdef LINUX}
  Result := fork;
  if Result < 0 then
    RaiseLastOSError
  else if Result = 0 then
  begin
    exec(ProgramPath, Args, Env);
    perror('exec');
    __abort;
  end;
{$endif}
end;

// Run a program but do not wait for it to finish. Return its PID.
function RunNoWait(const CmdLine: string): TProcessHandle; overload;
{$ifdef MSWINDOWS}
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
{$endif}
begin
{$ifdef MSWINDOWS}
  FillChar(StartupInfo, SizeOf(StartupInfo), 0);
  StartupInfo.cb := SizeOf(StartupInfo);
  Win32Check(CreateProcess(nil, PChar(CmdLine), nil, nil, True, 0, nil, nil, StartupInfo, ProcessInfo));
  Result := ProcessInfo.hProcess;
  // Don't need the thread handle.
  Win32Check(CloseHandle(ProcessInfo.hThread));
{$endif}
{$ifdef LINUX}
  Result := RunNoWait(GetShell, ['-c', CmdLine]);
{$endif}
end;


{ TPipe }

procedure TPipe.CloseHandles;
begin
  CloseReadHandle;
  CloseWriteHandle
end;

procedure TPipe.CloseReadHandle;
var
  Tmp: TFileHandle;
begin
  Tmp := ReadHandle;
{$ifdef MSWINDOWS}
  if Tmp <> Invalid_Handle_Value then
  begin
    fReadHandle := Invalid_Handle_Value;
    Win32Check(CloseHandle(Tmp));
  end;
{$endif}
{$ifdef LINUX}
  fHandles.ReadDes := -1;
  if (Tmp >= 0) and (__close(Tmp) < 0) then
    RaiseLastOSError;
{$endif}
end;

procedure TPipe.CloseWriteHandle;
var
  Tmp: TFileHandle;
begin
  Tmp := WriteHandle;
{$ifdef MSWINDOWS}
  if Tmp <> Invalid_Handle_Value then
  begin
    fWriteHandle := Invalid_Handle_Value;
    Win32Check(CloseHandle(Tmp));
  end;
{$endif}
{$ifdef LINUX}
  fHandles.WriteDes := -1;
  if (Tmp >= 0) and (__close(Tmp) < 0) then
    RaiseLastOSError;
{$endif}
end;

constructor TPipe.Create(Inheritable: Boolean);
{$ifdef MSWINDOWS}
var
  Attributes: TSecurityAttributes;
{$endif}
begin
  inherited Create;
{$ifdef MSWINDOWS}
  fReadHandle := Invalid_Handle_Value;
  fWriteHandle := Invalid_Handle_Value;
  Attributes.nLength := SizeOf(Attributes);
  Attributes.lpSecurityDescriptor := nil;
  Attributes.bInheritHandle := Inheritable;
  Win32Check(CreatePipe(fReadHandle, fWriteHandle, @Attributes, 0));
{$endif}
{$ifdef LINUX}
  fHandles.ReadDes := -1;
  fHandles.WriteDes := -1;
  if pipe(fHandles) < 0 then
    RaiseLastOSError;
{$endif}
end;

destructor TPipe.Destroy;
begin
  CloseReadHandle;
  CloseWriteHandle;
  inherited;
end;

{$ifdef MSWINDOWS}
procedure TPipe.DuplicateRead(Inheritable: Boolean);
var
  ProcessHandle: TProcessHandle;
  NewHandle: TFileHandle;
begin
  ProcessHandle := GetCurrentProcess;
  Win32Check(DuplicateHandle(ProcessHandle, ReadHandle, ProcessHandle, @NewHandle, 0, Inheritable, Duplicate_Same_Access));
  CloseReadHandle;
  fReadHandle := NewHandle;
end;

procedure TPipe.DuplicateWrite(Inheritable: Boolean);
var
  ProcessHandle: TProcessHandle;
  NewHandle: TFileHandle;
begin
  ProcessHandle := GetCurrentProcess;
  Win32Check(DuplicateHandle(ProcessHandle, WriteHandle, ProcessHandle, @NewHandle, 0, Inheritable, Duplicate_Same_Access));
  CloseWriteHandle;
  fWriteHandle := NewHandle;
end;
{$endif}

{$ifdef LINUX}
procedure TPipe.DuplicateRead(NewFd: Integer);
begin
  if dup2(ReadHandle, NewFd) < 0 then
    RaiseLastOSError;
end;
procedure TPipe.DuplicateWrite(NewFd: Integer);
begin
  if dup2(WriteHandle, NewFd) < 0 then
    RaiseLastOSError;
end;
{$endif}

function TPipe.ReadIsClosed: Boolean;
begin
  Result := ReadHandle < 0;
end;

function TPipe.WriteIsClosed: Boolean;
begin
  Result := WriteHandle < 0;
end;


{ TPipeStream }

procedure TPipeStream.CloseReadHandle;
begin
  Pipe.CloseReadHandle
end;
procedure TPipeStream.CloseWriteHandle;
begin
  Pipe.CloseWriteHandle
end;

constructor TPipeStream.Create(Inheritable: Boolean);
begin
  inherited Create;
  fPipe := TPipe.Create(Inheritable);
end;

destructor TPipeStream.Destroy;
begin
  FreeAndNil(fPipe);
  inherited;
end;

{$ifdef MSWINDOWS}
procedure TPipeStream.DuplicateRead(Inheritable: Boolean);
begin
  Pipe.DuplicateRead(Inheritable);
end;

procedure TPipeStream.DuplicateWrite(Inheritable: Boolean);
begin
  Pipe.DuplicateWrite(Inheritable);
end;
{$endif}

{$ifdef LINUX}
procedure TPipeStream.DuplicateRead(NewFd: Integer);
begin
  Pipe.DuplicateRead(NewFd);
end;

procedure TPipeStream.DuplicateWrite(NewFd: Integer);
begin
  Pipe.DuplicateWrite(NewFd);
end;
{$endif}

function TPipeStream.GetReadHandle: TFileHandle;
begin
  Result := Pipe.ReadHandle;
end;

function TPipeStream.GetWriteHandle: TFileHandle;
begin
  Result := Pipe.WriteHandle;
end;

function TPipeStream.Read(var Buffer; Count: Integer): Integer;
{$ifdef MSWINDOWS}
var
  BytesRead: Cardinal;
{$endif}
begin
{$ifdef MSWINDOWS}
  if not ReadFile(ReadHandle, Buffer, Count, BytesRead, nil) then
    Result := -1
  else
    Result := BytesRead;
{$endif}
{$ifdef LINUX}
  Result := __read(ReadHandle, Buffer, Count);
{$endif}
end;

function TPipeStream.Seek(Offset: Integer; Origin: Word): Integer;
begin
  raise EPipeError.Create(sCantSeek);
end;

function TPipeStream.Write(const Buffer; Count: Integer): Integer;
{$ifdef MSWINDOWS}
var
  BytesWritten: Cardinal;
{$endif}
begin
{$ifdef MSWINDOWS}
  if not WriteFile(WriteHandle, Buffer, Count, BytesWritten, nil) then
    Result := -1
  else
    Result := BytesWritten;
{$endif}
{$ifdef LINUX}
  Result := __write(WriteHandle, Buffer, Count);
{$endif}
end;


{ TCommandStream }

destructor TCommandStream.Destroy;
begin
  WaitFor;
  FreeAndNil(fPipe);
  inherited;
end;

function TCommandStream.Seek(Offset: Integer; Origin: Word): Integer;
begin
  raise EPipeError.Create(sCantSeek);
end;

function TCommandStream.WaitFor: Integer;
var
  Tmp: TProcessHandle;
begin
  Tmp := ProcessHandle;
{$ifdef MSWINDOWS}
  if Tmp <> Invalid_Handle_Value then
  begin
    fProcess := Invalid_Handle_Value;
    Result := CloseHandle(Tmp);
  end;
{$endif}
{$ifdef LINUX}
  if Tmp > 0 then
  begin
    fProcess := -1;
    waitpid(Tmp, @Result, 0);
  end;
{$endif}
end;


{ TReadFromCommandStream }

constructor TReadFromCommandStream.Create(const CmdLine: string);
{$ifdef MSWINDOWS}
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
{$endif}
begin
{$ifdef MSWINDOWS}
  fPipe := TPipeStream.Create;
  fProcess := Invalid_Handle_Value;

  // Make sure the child does not inherit the read end of the pipe.
  Pipe.DuplicateRead(False);

  // Start up the child process.
  FillChar(StartupInfo, SizeOf(StartupInfo), 0);
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.dwFlags := StartF_UseStdHandles;
  StartupInfo.hStdInput := GetStdHandle(Std_Input_Handle);
  StartupInfo.hStdError := GetStdHandle(Std_Error_Handle);
  StartupInfo.hStdOutput := Pipe.WriteHandle;

  Win32Check(CreateProcess(nil, PChar(CmdLine), nil, nil, True, 0, nil, nil, StartupInfo, ProcessInfo));
  fProcess := ProcessInfo.hProcess;
  // Don't need the thread handle.
  Win32Check(CloseHandle(ProcessInfo.hThread));

  // Close the write side of the pipe in the parent, so the parent
  // can read what the child writes.
  Pipe.CloseWriteHandle;
{$endif}
{$ifdef LINUX}
  Create(GetShell, ['-c', CmdLine]);
{$endif}
end;

constructor TReadFromCommandStream.Create(const Path: string; Args, Env: PPChar);
begin
{$ifdef MSWINDOWS}
  Create(MakeCmdLine(Path, Args));
{$endif}
{$ifdef LINUX}
  fPipe := TPipeStream.Create;
  fProcess := fork;
  if ProcessHandle < 0 then
    RaiseLastOSError
  else if ProcessHandle = 0 then
  begin
    // In the child process.
    Pipe.DuplicateWrite;
    Pipe.CloseWriteHandle;
    Pipe.CloseReadHandle;

    if Env = nil then
{$warn symbol_platform off}
      Env := envp;
{$warn symbol_platform on}

    exec(Path, Args, Env);
    perror(Path);
    __abort;
  end;
  // In the parent process.
  Pipe.CloseWriteHandle;
{$endif}
end;

constructor TReadFromCommandStream.Create(const Path: string;
  Args: TStrings; Env: PPChar);
var
  Argv: PPChar;
begin
  Argv := MakePCharArray(Args);
  Create(Path, Argv, Env);
  FreeMem(Argv);
end;

constructor TReadFromCommandStream.Create(const Path: string; const Args: array of string;
  Env: PPChar);
var
  Argv: PPChar;
begin
  Argv := MakePCharArray(Args);
  Create(Path, Argv, Env);
  FreeMem(Argv);
end;

function TReadFromCommandStream.Read(var Buffer; Count: Integer): Integer;
begin
  Result := Pipe.Read(Buffer, Count);
end;

function TReadFromCommandStream.Write(const Buffer; Count: Integer): Integer;
begin
  raise EPipeError.Create(sCantWrite);
end;

{ TWriteToCommandStream }

constructor TWriteToCommandStream.Create(const CmdLine: string);
{$ifdef MSWINDOWS}
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
{$endif}
begin
{$ifdef MSWINDOWS}
  fProcess := Invalid_Handle_Value;
  fPipe := TPipeStream.Create;

  // Make sure the child does not inherit the write end of the pipe.
  Pipe.DuplicateWrite(False);

  // Start up the child process.
  FillChar(StartupInfo, SizeOf(StartupInfo), 0);
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.dwFlags := StartF_UseStdHandles;
  StartupInfo.hStdOutput := GetStdHandle(Std_Output_Handle);
  StartupInfo.hStdError := GetStdHandle(Std_Error_Handle);
  StartupInfo.hStdInput := Pipe.ReadHandle;
  Win32Check(CreateProcess(nil, PChar(CmdLine), nil, nil, True, 0, nil, nil, StartupInfo, ProcessInfo));
  fProcess := ProcessInfo.hProcess;
  // Don't need the thread handle.
  Win32Check(CloseHandle(ProcessInfo.hThread));

  // Close the read side of the pipe in the parent, so the parent
  // can write to the child.
  Pipe.CloseReadHandle;
{$endif}
{$ifdef LINUX}
  Create(GetShell, ['-c', CmdLine]);
{$endif}
end;

constructor TWriteToCommandStream.Create(const Path: string; Args: TStrings; Env: PPChar);
var
  Argv: PPChar;
begin
  Argv := MakePCharArray(Args);
  Create(Path, Argv, Env);
  FreeMem(Argv);
end;

constructor TWriteToCommandStream.Create(const Path: string; const Args: array of string; Env: PPChar);
var
  Argv: PPChar;
begin
  Argv := MakePCharArray(Args);
  Create(Path, Argv, Env);
  FreeMem(Argv);
end;

constructor TWriteToCommandStream.Create(const Path: string;
  Args: PPChar; Env: PPChar);
begin
{$ifdef MSWINDOWS}
  Create(MakeCmdLine(Path, Args));
{$endif}
{$ifdef LINUX}
  fPipe := TPipeStream.Create;
  fProcess := fork;
  if ProcessHandle < 0 then
    RaiseLastOSError
  else if ProcessHandle = 0 then
  begin
    // In the child process.
    Pipe.DuplicateRead;
    Pipe.CloseWriteHandle;
    Pipe.CloseReadHandle;

    if Env = nil then
{$warn symbol_platform off}
      Env := envp;
{$warn symbol_platform on}

    exec(Path, Args, Env);
    perror(Path);
    __abort;
  end;
  // In the parent process.
  Pipe.CloseReadHandle;
{$endif}
end;

function TWriteToCommandStream.Read(var Buffer; Count: Integer): Integer;
begin
  raise EPipeError.Create(sCantRead);
end;

function TWriteToCommandStream.Write(const Buffer;
  Count: Integer): Integer;
begin
  Result := Pipe.Write(Buffer, Count);
end;

{$ifdef LINUX}
procedure perror(const Str: string);
begin
  Libc.perror(PChar(Str));
end;

function strerror(Errno: Integer): string; overload;
var
  Buf: array[0..255] of Char;
begin
  Result := Libc.strerror_r(Errno, @Buf[0], SizeOf(Buf));
end;

function strerror: string; overload;
begin
  Result := strerror(errno);
end;

function pselect(const ReadFds, WriteFds, ExceptFds: array of Integer;
  Timeout: Int64 = -1; Sigmask: PSigSet = nil): TIntegerDynArray;
var
  I, J: Integer;
  MaxFd: Integer;
  ReadSet, WriteSet, ExceptSet:  TFDSet;
  TimeValue: TTimeSpec;
  TimePtr: PTimeSpec;
  Return: Integer;
begin
  // Initialize the file descriptor sets. At the same time, determine the
  // highest file descriptor value.
  FD_ZERO(ReadSet);
  FD_ZERO(WriteSet);
  FD_ZERO(ExceptSet);
  MaxFd := Low(Integer);
  for I := Low(ReadFds) to High(ReadFds) do
  begin
    FD_SET(ReadFds[I], ReadSet);
    if ReadFds[I] > MaxFd then
      MaxFd := ReadFds[I];
  end;
  for I := Low(WriteFds) to High(WriteFds) do
  begin
    FD_SET(WriteFds[I], WriteSet);
    if WriteFds[I] > MaxFd then
      MaxFd := WriteFds[I];
  end;
  for I := Low(ExceptFds) to High(ExceptFds) do
  begin
    FD_SET(ExceptFds[I], ExceptSet);
    if ExceptFds[I] > MaxFd then
      MaxFd := ExceptFds[I];
  end;

  if MaxFd = Low(Integer) then
  begin
    SetLength(Result, 0);
    Exit;
  end;

  // Convert the timeout.
  if TimeOut < 0 then
    // Infinity.
    TimePtr := nil
  else
  begin
    TimePtr := @TimeValue;
    TimeValue.tv_sec := TimeOut div 1000000000;
    TimeValue.tv_nsec := TimeOut mod 1000000000;
  end;

  Return := __pselect(MaxFd+1, @ReadSet, @WriteSet, @ExceptSet, TimePtr, SigMask);
  if Return < 0 then
    RaiseLastOSError;
  SetLength(Result, Return);
  J := 0;
  for I := 0 to MaxFd do
  begin
    if FD_ISSet(I, ReadSet) then
    begin
      Result[J] := I;
      Inc(J);
    end
    else if FD_ISSet(I, WriteSet) then
    begin
      Result[J] := I;
      Inc(J);
    end
    else if FD_ISSet(I, ExceptSet) then
    begin
      Result[J] := I;
      Inc(J);
    end;
  end;
end;

procedure link(const OldPath, NewPath: string);
begin
  if Libc.link(PChar(OldPath), PChar(NewPath)) < 0 then
    RaiseLastOSError;
end;

procedure symlink(const OldPath, NewPath: string);
begin
  if Libc.symlink(PChar(OldPath), PChar(NewPath)) < 0 then
    RaiseLastOSError;
end;

function readlink(const Path: string): string;
var
  Status: Integer;
begin
  SetLength(Result, MAXNAMLEN+1);
  Status := Libc.readlink(PChar(Path), PChar(Result), Length(Result)-1);
  if Status < 0 then
    RaiseLastOSError
  else
    SetLength(Result, Status);
end;

procedure chmod(const Path: string; Mode: mode_t); overload;
begin
  if Libc.chmod(PChar(Path), Mode) < 0 then
    RaiseLastOSError;
end;

procedure chmod(const Path: string; Mode: TMode); overload;
begin
  chmod(Path, Word(Mode));
end;

procedure chown(const Path: string; Uid: uid_t; Gid: gid_t); overload;
begin
  if chown(PChar(Path), Uid, Gid) < 0 then
    RaiseLastOSError;
end;

procedure lchown(const Path: string; Uid: uid_t; Gid: gid_t);
begin
  if Libc.lchown(PChar(Path), Uid, Gid) < 0 then
    RaiseLastOSError;
end;

procedure stat(const Path: string; var statbuf: TStatBuf); overload;
begin
  if Libc.stat(PChar(Path), statbuf) < 0 then
    RaiseLastOSError;
end;

procedure lstat(const Path: string; var statbuf: TStatBuf); overload;
begin
  if Libc.lstat(PChar(Path), statbuf) < 0 then
    RaiseLastOSError;
end;

procedure stat(const Path: string; var statbuf: TStatBuf64); overload;
begin
  if Libc.stat64(PChar(Path), statbuf) < 0 then
    RaiseLastOSError;
end;

procedure lstat(const Path: string; var statbuf: TStatBuf64); overload;
begin
  if Libc.lstat64(PChar(Path), statbuf) < 0 then
    RaiseLastOSError;
end;

function umask(Mode: TModeBits): TModeBits;
var
  Tmp: Word;
begin
  Tmp := Libc.umask(Word(Mode));
  Result := TModeBits(Tmp);
end;

procedure rename(const OldName, NewName: string);
begin
  if __rename(PChar(OldName), PChar(NewName)) < 0 then
    RaiseLastOSError;
end;

// Change a file's times.
procedure utime(const Path: string; AccessTime, ModTime: TDateTime);
var
  TimeVals: TAccessModificationTimes;
begin
  DateTimeToTimeval(AccessTime, TimeVals.AccessTime);
  DateTimeToTimeval(ModTime,    TimeVals.ModificationTime);
  if Libc.utimes(PChar(Path), TimeVals) < 0 then
    RaiseLastOSError;
end;

procedure utimes(const Path: string; AccessTime, ModTime: TDateTime);
begin
  utime(Path, AccessTime, ModTime);
end;

procedure truncate(const Path: string; NewSize: off_t); overload;
begin
  if __truncate(PChar(Path), NewSize) < 0 then
    RaiseLastOSError;
end;

procedure truncate(const Path: string; NewSize: off64_t); overload;
begin
  if Libc.truncate64(PChar(Path), NewSize) < 0 then
    RaiseLastOSError;
end;

{ TTempStream }
constructor TTempStream.Create(const Prototype: string;
  DeleteOnClose: Boolean);
begin
  if Length(Prototype) = 0 then
    Create('/tmp/tmpXXXXXX', DeleteOnClose)
  else
  begin
    fFileName := Prototype;
    UniqueString(fFileName);
    if (Length(FileName) < 6) or (Copy(FileName, Length(FileName)-6, 6) <> 'XXXXXX') then
      fFileName := FileName + 'XXXXXX';
    inherited Create(mkstemp(PChar(fFileName)));
    if Handle < 0 then
      RaiseLastOSError;
  end;
end;

destructor TTempStream.Destroy;
begin
  if Handle >= 0 then
    __close(Handle);
  if DeleteOnClose then
    DeleteFile(FileName);
  inherited;
end;
{$endif}

initialization
  UnixEpoch := EncodeDate(1970, 1, 1);
  rcs_id('$Id: unixutils.pas,v 1.1 2003/01/21 19:47:04 ttm Exp $');
end.

{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2002 José León Serna <ttm@xpde.com>                           }
{                                                                             }
{ This program is free software; you can redistribute it and/or               }
{ modify it under the terms of the GNU General Public                         }
{ License as published by the Free Software Foundation; either                }
{ version 2 of the License, or (at your option) any later version.            }
{                                                                             }
{ This program is distributed in the hope that it will be useful,             }
{ but WITHOUT ANY WARRANTY; without even the implied warranty of              }
{ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU           }
{ General Public License for more details.                                    }
{                                                                             }
{ You should have received a copy of the GNU General Public License           }
{ along with this program; see the file COPYING.  If not, write to            }
{ the Free Software Foundation, Inc., 59 Temple Place - Suite 330,            }
{ Boston, MA 02111-1307, USA.                                                 }
{                                                                             }
{ *************************************************************************** }
program xpsu;

uses
  SysUtils,
  Classes,
  QForms,
  QControls,
  QDialogs,
  uXPStyle,
  Libc,
  Xlib,
  stdio in 'stdio.pas',
  unixutils in 'unixutils.pas',
  uAskPassword in 'uAskPassword.pas' {AskPasswordDlg};

type
    TConf=record
        dir: PChar;                                                             // directory where .Xauthority is located
        user: PChar;                                                            // which user to become
        command: PChar;                                                         // command to exec - for su
        login_shell: integer;                                                   // make this a login shell
        keep_env: integer;                                                      // keep environment?
        grab: integer;                                                          // grab X, keyboard and mouse?
        passw: string;
    end;

var
    conf: TConf;
    tmp_dir: PChar;
    xauth: PChar;
    xauth_env: PChar;
    ld_library_path: PChar;
    ld_library_path_env: PChar;
    allowchoose: boolean;

function forkpty(__amaster: PInteger; __name: PChar; __termp: PTermIos; __winp: PWinSize): Integer; cdecl; external libutilmodulename name 'forkpty';
function _write(Handle: Integer; Buffer: Pointer; Count: size_t): ssize_t; cdecl; external libcmodulename name 'write';

procedure free_pass(pass: PChar);
begin
  if (pass<>nil) then begin
    free(pass);
  end;
end;

const
    BUFSIZ=1024;

procedure clean_dir (const dirname:PChar);
var
  xauthname: PChar;
begin
  xauthname := strdup(PChar(format('%s/.Xauthority', [dirname])));
  if (unlink (xauthname)=0) then rmdir (dirname);
end;

// Write all of buf, even if write(2) is interrupted. */
function full_write(d: integer;const buf:PChar;nbytes:size_t):ssize_t;
var
  r,w: ssize_t;
  init: PChar;
begin
    w:=0;

    // Loop until nbytes of buf have been written.
    while (w < nbytes) do begin
        // Keep trying until write succeeds without interruption. */
        repeat
            init:=buf;
            inc(init,w);
            r := __write(d, init, nbytes - w);
        until (r>0) or (errno<>EINTR);
        //while (r < 0 && errno == EINTR);

        if (r < 0) then begin
            result:=-1;
            exit;
        end;
        w :=w+r;
    end;
    result:=w;
end;

procedure copy(const fn: PChar;const dir:PChar);
var
    m: TMemoryStream;
begin
    m:=TMemoryStream.create;
    try
        m.loadfromfile(fn);
        m.savetofile(dir+'/'+extractfilename(fn));
    finally
        m.free;
    end;
end;
{
procedure copy(const fn: PChar;const dir:PChar);
var
    fin, fout: integer;
    r: integer;
    newfn: PChar;
    buf: array [0..BUFSIZ] of char;
begin
    newfn := strdup(PChar(format('%s/%s', [dir, basename(fn)])));

    fout := open(newfn, O_WRONLY or O_CREAT or O_EXCL);
    if (fout = -1) then begin
        if (errno = EEXIST) then begin
            writeln('The X authority file i am trying to create for root already exists! This is highly suspicious!');
        end
        else begin
            writeln(format('Error copying "%s" to "%s": %s',[fn, dir, strerror(errno)]));
        end;

        clean_dir (dir);
        halt(1);
    end;

    fin := open(fn, O_RDONLY);
    if (fin = -1) then begin
        writeln(format('Error copying "%s" to "%s": %s',[fn, dir, strerror(errno)]));
        clean_dir (dir);
        halt(1);
    end;

    r := __read(fin, buf, BUFSIZ);
    while (r > 0) do begin
        if (full_write(fout, buf, r) = -1) then begin
            writeln(format('Error copying "%s" to "%s": %s',[fn, dir, strerror(errno)]));
            clean_dir (dir);
            halt(1);
        end;
        r := __read(fin, buf, BUFSIZ);
    end;

    if (r = -1) then begin
        writeln(format('Error copying "%s" to "%s": %s',[fn, dir, strerror(errno)]));
        clean_dir (dir);
        halt(1);
    end;

    __close (fin);
    __close (fout);

    chmod (newfn, S_IRUSR or S_IWUSR or S_IRGRP or S_IROTH);
    free (newfn);
end;
}

function su_do (var conf: TConf): integer;
var
    i: integer;
    fdpty: integer;
    fdio: array [0..1] of integer;
    pid: pid_t;
    pid_gc: pid_t;

    cmd: TStringList;
    comm: PPChar;

    wfds: tfdset;
    tv: TTimeval;
    buf: array [0..255] of char;
    abuf: array [0..4] of char;
    status: integer;
    clave: string;

    password: PChar;
    pass: PChar;
begin
    i := 0;

    pipe (@fdio);

    pid := fork;
    if (pid = 0) then begin
        pid_gc := forkpty (@fdpty, nil, nil, nil);
        if (pid_gc = 0) then begin
            cmd:=TStringList.create;
	        cmd.add('/bin/su');
	        if (conf.login_shell<>0) then cmd.add('-');
	        cmd.add(conf.user);
            if (conf.keep_env<>0) then cmd.add('-p');

	        cmd.add('-c');
	        cmd.add(conf.command);

            // executes the command
            comm:=MakePCharArray(cmd);
	        if (execv (comm^, comm) = -1) then begin
                writeln(format('Unable to run /bin/su %s',[strerror(errno)]));
	        end;
        end
        else if (pid_gc = -1) then begin
            writeln(format('%s',[strerror(errno)]));
            result:=1;
            exit;
	    end
        else begin
	        while ((__read (fdpty, buf, 256))=0) do;

	        FD_ZERO(wfds);
	        FD_SET(fdpty, wfds);

	        tv.tv_sec := 2;
	        tv.tv_usec := 0;

            password:=strdup(PChar(conf.passw+#13));

	        if (password = nil) then begin
                result:=1;
                exit;
            end;

	        // we cannot pass 'password' as it has no \n
	        select (1, @wfds, nil, nil, @tv);
            _write (fdpty, password, strlen(password));

	        // cleans the memory
	        free_pass (pass);
            free_pass (password);

	        // tell the grandparent the password has been given
	        __close (fdio[0]);
	        __write (fdio[1], 'done', strlen ('done'));

	        if ((fcntl (fdpty, F_SETFL, O_NONBLOCK) = -1)) then begin
                writeln(format('An error happened, your program may be blocked: %s',[strerror(errno)]));
            end;

	        while (waitpid (pid_gc, @status, WNOHANG)=0) do begin
	            tv.tv_sec := 0;
	            tv.tv_usec := 100;
	            bzero(@buf, 256);
	            select (0, nil, nil, nil, @tv);
	            __read (fdpty, buf, 255);
	            fprintf (stderr, buf);
            end;
	        clean_dir (conf.dir);

	        if (WIFEXITED(status)) then begin
	            if (WEXITSTATUS(status)<>0) then begin
                    writeln(format('Child terminated with %d status',[WEXITSTATUS(status)]));
                    result:=1;
                    exit;
		        end;
	        end;
        end;
    end
    else if (pid = -1) then begin
        writeln(format('%s',[strerror(errno)]));
        result:=1;
        exit;
    end
    else begin
        // if we don't block the program quits but this shall not last forever
        __close (fdio[1]);
        __read(fdio[0], buf, 5);
    end;
    result:=0;
end;

Function getHomeDir:String;
begin
result := getpwuid(getuid)^.pw_dir;
end;

begin
  application.Initialize;
  SetXPStyle(application);

  tmp_dir:=strdup('/tmp/xpsu-XXXXXX');

  xauth := nil;
  xauth_env := nil;

  conf.dir:= nil;
  conf.user:= nil;
  conf.command := nil;                                                          // xpsu

  conf.login_shell := 0;
  conf.keep_env := 1;
  conf.grab := 1;

  allowchoose:=false;

  if ParamCount=0 then begin
    showmessage('You need to specify which program to run');
    halt(1);
  end
  else begin
    if paramcount=1 then begin
        allowchoose:=true;
        conf.user := strdup ('root');
        conf.command := strdup(PChar(paramstr(1)));
    end
    else if paramcount=2 then begin
        conf.user := strdup (PChar(paramstr(1)));
        conf.command := strdup(PChar(paramstr(2)));
    end;
  end;

  // xauth stuff, borrowed from gnome-sudo
  conf.dir := mkdtemp (tmp_dir);
  if (conf.dir=nil) then begin
      writeln(strerror(errno));
      halt(1);
  end;

  // directory must not be 700
  chmod (conf.dir, S_IRUSR or S_IWUSR or S_IXUSR or S_IRGRP or S_IROTH or S_IXOTH);


  xauth := strdup(PChar(gethomedir+'/.Xauthority'));


  copy (xauth, conf.dir);
  free (xauth);

  xauth := strdup(PChar(format('%s/.Xauthority',[conf.dir])));
  xauth_env := getenv ('XAUTHORITY');
  ld_library_path:= strdup('$LD_LIBRARY_PATH:/home/ttm/xpde');

  setenv ('LD_LIBRARY_PATH', ld_library_path, 1);
  setenv ('XAUTHORITY', xauth, 1);



            // ask for password
            with TAskPasswordDlg.create(application) do begin
                try
                    cbUsername.ItemIndex:=cbUsername.Items.IndexOf(conf.user);
                    cbUsername.Enabled:=allowchoose;
                    if showmodal=mrOk then begin
                        conf.passw:=edpassword.text;
                        conf.user:=strdup(PChar(cbUsername.Items[cbUsername.itemindex]));
                    end
                    else begin
                        halt(1);
                    end;
                finally
                    free;
                end;
            end;


  su_do(conf);

  // reset the env var as it was before or clean it
  if (xauth_env<>nil) then setenv ('XAUTHORITY', xauth_env, 1)
  else unsetenv ('XAUTHORITY');


  free (xauth);
  free (conf.command);
  free (conf.user);


end.

{$G1}{$P1}

CONST strlen=160;

TYPE str=string[strlen];
userrec=record
name:string[25];
realname:string[14];
laston:string[10];
linelen:byte;
pagelen:byte;
sl:byte;
age:byte;
sex:char;
callsign:string[8];
gold:real;
end;
      regs=record ax,bx,cx,dx,bp,si,di,ds,es,flags:integer; end;

var
sysopf:text[1024];
sysopffn:string[80]; dialcnt:byte;
gfilespath,datapath:string[80];
usernum:integer;
incom,okansi,cs,so,hangup:boolean;
timeon,timeleft:real;
thisuser:userrec;
rp:regs;

function timer:real;
var reg:record
      ax,bx,cx,dx,bp,si,di,ds,es,flags:integer;
    end;
  h,m,s,t:real;
begin
  reg.ax:=44*256;
  msdos(reg);
  h:=(reg.cx div 256);
  m:=(reg.cx mod 256);
  s:=(reg.dx div 256);
  t:=(reg.dx mod 256);
  timer:=h*3600+m*60+s+t/100;
end;

function nsl:real;
begin
  if timer<timeon then
    timeon:=timeon-24.0*3600.0;
  nsl:=timeleft-(timer-timeon);
end;

function sysop:boolean;
begin
  if (mem[0:1047] and 16)=0 then sysop:=false else sysop:=true;
end;

procedure sysoplog(i:str);
begin
if (not so) or incom then
writeln(sysopf,i);
end;

function tch(i:str):str;
begin
if length(i)>2 then i:=copy(i,length(i)-1,2) else
if length(i)=1 then i:='0'+i;
tch:=i;
end;

function date:str;
var reg:record
  ax,bx,cx,dx,bp,si,di,ds,es,flags:integer;
    end;
  m,d,y:string[4];
begin
reg.ax:=$2a00; msdos(reg); str(reg.cx,y); str(reg.dx mod 256,d);
str(reg.dx shr 8,m);
date:=tch(m)+'/'+tch(d)+'/'+tch(y);
end;

function value(I:str):integer;
var n,n1:integer;
begin
val(i,n,n1);
if n1<>0 then begin
i:=copy(i,1,n1-1);
val(i,n,n1)
end;
value:=n;
if i='' then value:=0;
end;

function cstr(i:integer):str;
var c:str;
begin
str(i,c); cstr:=c;
end;

function nam:str;
var s:str; i:integer; tf:boolean;
begin
s:=thisuser.name;
tf:=true;
for i:=1 to length(s) do
if s[i]<'A' then
tf:=true
else begin
if (s[i]<='Z') and not tf then
s[i]:=chr(ord(s[i])+32);
tf:=false;
end;
nam:=s+' #'+cstr(usernum);
end;

procedure checkhangup;
begin
end;

procedure getkey(var c:char); forward;

procedure prompt(i:str); forward;

procedure ansic(c:integer);
var i:str;
begin
if c<2 then c:=0
else
if (c=2) then c:=7 else c:=c-2;
i:=#3+chr(ord('0')+c);
prompt(i);
end;

procedure pausescr;
var i:integer; cc:char;
begin
ansic(3); prompt('(-*-)'); ansic(0);
getkey(cc);
for i:=1 to 5 do
prompt(#8+' '+#8);
end;

procedure prompt;
var c:integer; cc:char;
begin
if (not hangup) then
for c:=1 to length(i) do
write(i[c]);
end;

procedure print(i:str);
begin
prompt(i+chr(13)+chr(10))
end;

procedure nl;
begin
prompt(chr(13)+chr(10))
end;

procedure prt(i:str);
begin
ansic(4); prompt(i); ansic(0);
end;

procedure tleft;
var x,y:integer;
begin
if timer<timeon then timeon:=timeon-24.0*60*60;
if (nsl<0) then begin
nl;
print('Time expired.');
hangup:=true;
end;
checkhangup;
end;


function empty:boolean;
begin
  rp.ax:=$0b00;
  msdos(rp);
  if (rp.ax and $00ff)=$00 then
    empty:=true
  else
    empty:=false;
end;

function inkey:char;
var ch:char;
begin
if (empty) then
inkey:=#0
else begin
rp.ax:=$0800;
msdos(rp);
inkey:=chr(rp.ax and $00ff);
end;
end;

procedure getkey;
begin
rp.ax:=$0800;
msdos(rp);
c:=chr(rp.ax and $00ff);
end;

procedure cls;
begin
write(chr(12)); dialcnt:=18;
end;

procedure input1(var i:str; ml:integer; tf:boolean);
var cp:integer;
    c:char;
    r:real;
begin
checkhangup;
if not hangup then begin
r:=timer;
cp:=1;
repeat
getkey(c);
if c=#1 then r:=timer;
if not tf then c:=upcase(c);
if (c>=' ') and (c<chr(127)) then
if cp<=ml then begin
i[cp]:=c;
cp:=cp+1;
write(c);
end else else case ord(c) of
8:if cp>1 then begin
c:=chr(8);
write(#8#32#8);
cp:=cp-1;
end;
21,24:while cp<>1 do begin
cp:=cp-1;
write(#8#32#8);
end;
end;
if (timer-r)>300.0 then hangup:=true;
until (c=#13) or (c=#14) or hangup;
i[0]:=chr(cp-1);
nl;
end;
end;

procedure input(var i:str; ml:integer);
begin
input1(i,ml,false);
end;


procedure inputl(var i:str; ml:integer);
begin
  input1(i,ml,true);
end;

procedure onek(var c:char; ch:str);
begin
  repeat
  getkey(c);
  c:=upcase(c);
until (pos(c,ch)>0) or hangup;
hangup:=false;
if hangup then c:=ch[1];
print(''+c);
end;


procedure wkey(var abort,next:boolean);
var cc:char;
begin
 while not (empty or hangup ) do begin
  getkey(cc);
  if (cc=' ') or (cc=chr(3)) or (cc=chr(24)) or (cc=chr(11)) then
   abort:=false;
 if (cc=chr(14)) then begin abort:=false; next:=true; end;
end;
 end;

function ctim(rl:real):str;
var h,m,s:str;
begin
 s:=tch(cstr(trunc(rl-int(rl/60.0)*60.0)));
 m:=tch(cstr(trunc(int(rl/60.0)-int(rl/3600.0)*60.0)));
 h:=cstr(trunc(rl/3600.0));
 if length(h)=1 then h:='0'+h;
 ctim:=h+':'+m+':'+s;
end;

function tlef:str;
begin
 tlef:=ctim(nsl);
end;

function cstrr(rl:real; base:integer):str;
var c1,c2,c3:integer; i:str; r1,r2:real;
begin
if rl<=0.0 then cstrr:='0' else begin
r1:=ln(rl)/ln(1.0*base);
r2:=exp(ln(1.0*base)*(trunc(r1)));
i:='';
while (r2>0.999) do begin
c1:=trunc(rl/r2);
i:=i+copy('0123456789ABCDEF',c1+1,1);
rl:=rl-c1*r2;
r2:=r2/(1.0*base);
end;
cstrr:=i;
end;
end;


procedure printa1(i:str; var abort,next:boolean);
var c:integer;
begin
checkhangup;
if not hangup then begin
abort:=false; next:=false; c:=1;
if not empty then wkey(abort,next);
while (c-1<length(i)) and (not hangup) do begin
 checkhangup;
if i[c]=#3 then
if i[c+1] in [#0..#8] then
if okansi then
ansic(ord(i[c+1]));
if not empty then wkey(abort,next);
if i[c]=#3 then
 c:=c+1
 else
 write(i[c]);
 c:=c+1;
  end;
 end else abort:=true;
end;

procedure printa(i:str; var abort,next:boolean);
var s:str; p,op,rp,rop,nca:integer; crend:boolean;
begin
 abort:=false;
 crend:=(i[length(i)]=#1) and (i[length(i)-1]<>#3);
 if crend then i:=copy(i,1,length(i)-1);
 wkey(abort,next);
 if i='' then nl;
 while (i<>'') and (not abort) and (not hangup) do begin
  rp:=0; nca:=thisuser.linelen-wherex-1; p:=0;
  while (rp<nca) and (p<length(i)) do begin
  if i[p+1]=#8 then rp:=rp-1 else
  if i[p+1]=#3 then
   p:=p+1
   else
   if (i[p+1]<>#10) then rp:=rp+1;
    p:=p+1;
    end;
    op:=p; rop:=rp;
    if (rp>=nca) and (p<length(i)) then begin
  while ((not (i[p] in [' ',#8,#10])) or (i[p-1]=#3)) and (p>1) do begin
   rp:=rp-1; p:=p-1;
   end;
   if p=1 then
  if not (i[1] in [' ',#8,#10]) then begin rp:=rp-1; p:=p-1; end;
   end;
   if abs(rop-rp)>=(thisuser.linelen div 2) then p:=op;
  s:=copy(i,1,p); delete(i,1,p);
 if (s[length(s)]=' ') then s[0]:=pred(s[0]);
 printa1(s,abort,next);
 if ((i='') and crend) or (i<>'') or abort then
  nl
 else
  printa1(' ',abort,next);
end;
end;

procedure printacr(i:str; var abort,next:boolean);
begin
 if not abort then
  if i[length(i)]=#1 then
    printa(i,abort,next)
  else
    printa(i+#1,abort,next);
end;

procedure pfl(fn:str; var abort:boolean; cr:boolean);
var fil:text;
    i:str;
    next:boolean;
begin
  if not hangup then begin
  assign(fil,fn);
  {$I-} reset(fil); {$I+}
  if ioresult<>0 then print('File not found.') else begin
  abort:=false;
  while not eof(fil) and (not hangup) do begin
   readln(fil,i);
  if cr then
   printacr(i,abort,next)
   else
    printa(i,abort,next);
  end;
   close(fil);
   end;
   nl;nl;
    end;
end;

procedure printfile(fn:str);
var abort:boolean;
begin
  pfl(fn,abort,true);
end;

procedure iport;
var f:text;
    i:str;
    n:integer;
begin
  assign(f,paramstr(1));
  {$I-} reset(f); {$I+}
  if (ioresult=0) then begin
    readln(f,usernum);
    readln(f,thisuser.name);
    readln(f,thisuser.realname);
    readln(f,thisuser.callsign);
    readln(f,thisuser.age);
    readln(f,thisuser.sex);
    readln(f,thisuser.gold);
    readln(f,thisuser.laston);
    readln(f,thisuser.linelen);
    readln(f,thisuser.pagelen);
    readln(f,thisuser.sl);
    readln(f,n);
    cs:=(n=1);
    readln(f,n);
    so:=(n=1);
    readln(f,n);
    okansi:=(n=1);
    readln(f,n);
    incom:=(n=1);
    readln(f,timeleft);
    readln(f,gfilespath);
    readln(f,datapath);
    readln(f,i);
    close(f);
    sysopffn:=gfilespath+i;
    assign(sysopf,sysopffn);
    {$I-} append(sysopf); {$I+}
    if (ioresult<>0) then begin
      rewrite(sysopf);
    end;
  end else begin
    writeln('Parameter file not found.');
    halt;
  end;
  hangup:=false;
  timeon:=timer;
end;

procedure topscr;
begin
end;

procedure goto_ansixy(x5,y5: integer);
var gotcha:string[8];
    num1,num2:string[2];
begin
num1:='  ';
num2:='  ';
gotcha:='         ';
str(x5,num1);
str(y5,num2);
gotcha:=chr(27)+'['+num1+';'+num2+'f';
prompt(gotcha);
end;
procedure return;
begin
close(sysopf); ansic(0);
halt;
end;
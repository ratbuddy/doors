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
sysopf:text[1024]; maz:integer;
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

procedure sysoplog(i:str);
begin
if (not so) or incom then
writeln(sysopf,i);
end;

procedure getkey(var c:char);
begin
rp.ax:=$0800;
msdos(rp);
c:=chr(rp.ax and $00ff);
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

procedure checkhangup;
begin
end;

procedure prompt(i:str);
var c:integer; cc:char;
begin
if (not hangup) then
for c:=1 to length(i) do
write(i[c]);
end;

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


procedure print(i:str);
begin
prompt(i+chr(13)+chr(10))
end;

procedure nl;
begin
prompt(chr(13)+chr(10))
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


procedure cls;
begin
write(chr(12)); dialcnt:=18;
end;

procedure input(var i:str; ml:integer);
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
c:=upcase(c);
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

procedure onek(var c:char; ch:str);
begin
ansic(3);
repeat
getkey(c);
c:=upcase(c);
until (pos(c,ch)>0) or hangup;
hangup:=false;
if hangup then c:=ch[1];
print(''+c);
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
end;

procedure printfile(filename: str);
var xx:char; xfile:file of char;
begin
ansic(0);
assign(xfile,filename);
reset(xfile);
while not EOF(xfile) do begin
 read(xfile,xx);
 prompt(xx);
end;
close(xfile);
end;

procedure clear_space;
var cnt:byte;
begin
goto_ansixy(18,1);
for cnt:=18 to 23 do
print(CHR(27)+'[K');
if maz=1 then maz:=0 else maz:=1;
dialcnt:=18;
end;

procedure say_saying(talk : helper);
begin
if dialcnt = 23 then begin goto_ansixy(23,1); pausescr;
DIALCNT:=18; if maz=1 then maz:=0 else maz:=1; end;
nl; goto_ansixy(dialcnt,1);
if maz=1 then ansic(3)
   else ansic(4); prompt(talk); PROMPT (CHR(27)+'[K'); dialcnt:=dialcnt+1;
end;

function modifier(score: integer) : integer;
var temp:integer;
begin
temp:=0;
if score<7 then temp:=score-7;
if score>20 then temp :=(-1) * (20-score);
modifier:=temp;
end;

procedure talk(h : integer; speech : helper);
begin
ansic(h);
prompt(speech);
end;

procedure talknl(h : integer; speechnl : helper);
begin
ansic(h); print(speechnl);
end;

procedure inc(var a:integer; b:integer);
begin
a:=a+b;
end;

procedure binc(var a:byte; b:integer);
begin
a:=a+b;
end;
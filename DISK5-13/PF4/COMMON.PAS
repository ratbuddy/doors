unit common;
interface
uses dos;
TYPE helper=string[160];
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
type cards=record
   idnum: byte;
   special_num: word;
     end;
type game=record
  races:  array [1..4] of byte;
  smoked: array [1..4,1..5] of byte;
  amounts: array [1..4,1..5] of integer;
  terrains: array [1..4,1..5] of byte;
  ranges: array [1..4,1..5] of byte;
  current_card: byte;
  names: array [1..4] of string[25];
  cards_held: array[1..4,1..6] of cards;
  card : array [1..184] of cards;
  game_let: char;
end;
type gamer = record
  name:array [1..4] of string[25];
  laston : array [1..4,1..3] of word;
  races: array [1..4] of byte;
 end;

var
player:game;

sysopf:text; maz:integer;
sysopffn:string[80]; dialcnt:byte;
gfilespath,datapath:string[80];
usernum:integer;
incom,okansi,cs,so,hangup:boolean;
timeon,timeleft:real;
thisuser:userrec;
rp:registers; high:integer;
function timer:real;
function nsl:real;
procedure sysoplog(i:helper);
procedure getkey(var c:char);
function value(I:helper):integer;
function cstr(i:integer):helper;
procedure checkhangup;
procedure prompt(i:helper);
procedure ansic(c:integer);
procedure pausescr;
procedure print(i:helper);
procedure nl;
procedure tleft;
procedure cls;
procedure input(var i:helper; ml:integer);
procedure onek(var c:char; ch:helper);
function cstrr(rl:real; base:integer):helper;
procedure goto_ansixy(x5,y5: integer);
procedure return;
procedure printfile(filename: helper);
procedure clear_space;
procedure say_saying(talk : helper);
procedure talk(h : integer; speech : helper);
procedure talknl(h : integer; speechnl : helper);
function ynq : boolean;
procedure load_cards;
procedure clear_eol(y,x:byte);
implementation
function timer:real;
  var h,m,s,t:integer;
  begin
  rp.ax:=44*256;
  msdos(rp);
  h:=(rp.cx div 256);
  m:=(rp.cx mod 256);
  s:=(rp.dx div 256);
  t:=(rp.dx mod 256);
  timer:=h*3600+m*60+s+t/100;
end;

function nsl:real;
begin
  if timer<timeon then
    timeon:=timeon-24.0*3600.0;
  nsl:=timeleft-(timer-timeon);
end;

procedure sysoplog(i:helper);
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

function value(I:helper):integer;
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

function cstr(i:integer):helper;
var c:helper;
begin
str(i,c); cstr:=c;
end;

procedure checkhangup;
begin
end;

procedure prompt(i:helper);
var c:integer; cc:char;
    regs:registers;
begin
  regs.ah:=2;
  for c:=1 to length(i) do begin
    regs.dl:=ord(i[c]);
    msdos(regs);
 end;
end;

procedure ansic(c:integer);
var i:helper; gotcha:string[8];
begin
gotcha:=chr(27)+'[0m';
prompt(gotcha);
gotcha:=chr(27)+'[1m';
prompt(gotcha);
case c of
  0,1 : gotcha:=chr(27)+'[37;40m';
  4 : gotcha:=chr(27)+'[34;40m';
  7 : gotcha:=chr(27)+'[36;40m';
  5 : gotcha:=chr(27)+'[35;40m';
  6 : gotcha:=chr(27)+'[37;44m';
  3 : gotcha:=chr(27)+'[36;40m';
  2 : gotcha:=chr(27)+'[33;40m';
  8 : gotcha:=chr(27)+'[31;5m';
end;
prompt(gotcha);
end;

procedure pausescr;
var i:integer; cc:char;
begin
ansic(3); prompt('(-*-)'); ansic(0);
getkey(cc);
for i:=1 to 5 do
prompt(#8+' '+#8);
end;


procedure print(i:helper);
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
PROMPT(CHR(27)+'[2J');
dialcnt:=18;
end;

procedure input(var i:helper; ml:integer);
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

procedure onek(var c:char; ch:helper);
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

function cstrr(rl:real; base:integer):helper;
var c1,c2,c3:integer; i:helper; r1,r2:real;
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
close(sysopf); talk(0,' ');
cls;
halt;
end;

procedure printfile(filename: helper);
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

procedure talk(h : integer; speech : helper);
begin
ansic(h);
prompt(speech);
end;

procedure talknl(h : integer; speechnl : helper);
begin
ansic(h); print(speechnl);
end;

function ynq : boolean;
var ychar:char;
begin
onek(ychar,'NY');
if ychar='Y' then ynq:=true else ynq:=false;
end;

 procedure load_cards;
 var card_file: file of cards;
 x,y:byte;
  procedure swapper(var a,b: cards);
  var c:cards;
  begin
  c:=a; a:=b; b:=c;
  end;

 begin
 assign(card_file,'CARDS.PIT');
 reset(card_file);
 for x:=1 to 184 do
 read(card_file,player.card[x]);
 close(card_file);
 for y:=1 to 15 do
 for x:=1 to 184 do swapper(player.card[x],player.card[random(184)+1]);
 end;

procedure clear_eol(y,x:byte);
begin
goto_ansixy(y,x);
PROMPT (CHR(27)+'[K');
end;

end. {end of unit}

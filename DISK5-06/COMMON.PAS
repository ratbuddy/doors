unit common;
interface
uses crt,globals,dos;
function value(I:helper):integer;
procedure talk(x : integer; saying:helper);
procedure talknl(x:integer; saying:helper);
procedure view_initial_char;
procedure pot_view;
procedure determine_armorclass;
procedure list_view;
procedure cls;
procedure goto_xy(xx, yy : byte);
procedure ansic(xx : byte);
procedure clear_space;
procedure say_saying(talk:helper);
function cstr(i:integer): helper;
procedure pausescr;
procedure input(var i:helper; ml:integer);
procedure input1(var i:helper; ml:integer; tf:boolean);
procedure nl;
procedure onek(var c:char; ch:helper);
function cstrr(rl:real; base:integer):helper;
function modifier(score: integer) : integer;
procedure printfile(fucker :string);
procedure prompt(st:string);
implementation

procedure cls;
begin
clrscr;
end;

procedure goto_xy(xx,yy : byte);
begin
gotoxy(yy,xx);
end;

procedure ansic(xx : byte);
begin
textcolor(xx);
if xx=7 then textcolor(GREEN);
if xx=3 then textcolor(LIGHTBLUE);
if xx=4 then textcolor(YELLOW);
end;

procedure pausescr;
var i:integer; cc:char;
begin
ansic(3); write('(-*-)'); ansic(0);
cc:=readkey;
for i:=1 to 5 do
write(#8+' '+#8);
end;

procedure clear_space;
var cnt:byte;
begin
for cnt:=18 to 23 do begin gotoxy(1,cnt);
   clreol; end;
end;

procedure say_saying(talk : helper);
begin
if dialcnt = 23 then begin gotoxy(1,23); pausescr;
clear_space; DIALCNT:=18; end;
gotoxy(1,dialcnt);
ansic(10); write(talk); inc(dialcnt);
end;

function cstr(i:integer): helper;
var c:helper;
begin
  str(i,c); cstr:=c;
end;

procedure talk(x : integer; saying:helper);
begin
ansic(x); write(saying);
end;
procedure talknl(x:integer; saying:helper);
begin
ansic(x); writeln(saying);
end;

procedure nl;
begin
writeln;
end;

procedure onek(var c:char; ch:helper);
begin
  repeat
  c:=readkey;
  c:=upcase(c);
until (pos(c,ch)>0); write(C); nl;
end;

function cstrr(rl:real; base:integer):helper;
var c1,c2,c3:integer; i:helper; r1,r2:real;
begin
rl:=rl+1;
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

function modifier(score: integer) : integer;
var temp:integer;
begin
temp:=0;
if score<7 then temp:=score-7;
if score>20 then temp :=(-1) * (20-score);
modifier:=temp;
end;

procedure list_view;
begin
with player do begin ansic(4);
talknl(5,'Equipped Weapon : '+equipweapon.name+' +'+cstr(equipweapon.magical));
talknl(5,'Equipped Armor  : '+equiparmor.name+' +'+cstr(equiparmor.magical));
talknl(5,'Equipped Staff  : '+equipmagic.name);
talknl(5,'Equipped Missile: '+equipmis.name+' +'+cstr(equipmis.magical));
end;
end;

procedure determine_armorclass;
var y:integer;
begin
player.armorclass:=player.equiparmor.protect+player.equiparmor.magical;
player.armorclass:=player.armorclass+modifier(player.stats[4]);
if player.armorclass<0 then player.armorclass:=0;
end;

procedure pot_view;
var x:integer;
begin
for x:=43 to 50 do
 if player.exemptions[x] > 0 then
   talknl(5,cstr(player.exemptions[x]) +' Potions of '+potion_array[x-42].name);
end;

procedure view_initial_char;
var x,whichone,itemp:integer; temper:char;
    g:helper; temp:helper; tempy:string[2];
begin
cls;
talknl(4,player.name);
for x:=1 to 8 do begin
   if odd(x) then gotoxy(1,(x div 2)+2) else gotoxy(35,(x div 2)+1);
   talk(4,stat_name[x]+': '+cstr(player.stats[x]));
end;
nl; nl;
talk(4,'Class:           ');
talknl(5,class_name[player.class]);
talk(4,'Hit Points:      ');
talknl(5,cstr(player.maxhitpoints)+'/'+cstr(player.act_hitpoints));
talknl(5,'Gold :         '+cstrr(player.goldpieces,10));
list_view; nl; pot_view; pausescr;
talk(4,'Level:           '); talknl(5,cstr(player.level));
talk(4,'Experience:      '); talknl(5,cstrr(player.experience,10));
talk(4,'Needed Exper:    '); talknl(5,cstrr(player.needed_exp,10));
talk(4,'Armor Class:     '); talknl(5,cstr(player.armorclass));
talk(4,'# Attacks / Rnd  '); talknl(5,cstr(player.numatt));
talk(4,'Spell Points:    '); talknl(5,cstr(player.stats[8])+'/'+cstr(player.act_spellpoints));
talk(4,'Food             '); talknl(5,cstr(player.food));
talk(4,'Total Moves      '); talknl(5,cstrr(player.total_moves,10));
pausescr;
end;
procedure prompt(st : string);
var regs:registers;
    index:integer;
begin
regs.ah:=2;
for index:=1 to length(st) do begin
  regs.dl:=ord(st[index]);
  msdos(regs);
end;
end;
procedure printfile(fucker : string);
var g1 : file of char; g2 :char;
begin
assign(g1,fucker); reset(g1); textcolor(7); g2:='a';
while (not EOF(g1)) do begin
   read(g1,g2); prompt(g2);
   end;
close(g1);
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

procedure input1(var i:helper; ml:integer; tf:boolean);
var cp:integer;
    c:char;
    r:real;
begin
  cp:=1;
  repeat
    c:=readkey;
    c:=upcase(c);
    if (c>=' ') and (c<chr(127)) then
  if cp<=ml then begin
    i[cp]:=c;
    cp:=cp+1;
    write(c);
    end else else
     case ord(c) of
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
  until (c=#13) or (c=#14);
  i[0]:=chr(cp-1);
  nl;
 end;


procedure input(var i:helper; ml:integer);
begin
  input1(i,ml,false);
end;

end.
program on_liner;

{$I COMMON.PAS}
{$I RECORDS.H}
var player: character;
meanies:array [1..4] of monsters;
maz : integer; dung_room : array [1..75] of dun_room;
ginput:char; potion_array:array [1..9] of potions;
stat_name: array[1..11] of string[15]; act_stats:array[1..5] of byte;
bridger,exitter,doner,general,use_pool,time_expander:boolean;
town_stuff : town_rec; dungeon_stuff : dun_rec;
class_name: array[1..6] of string[15];
weapon:array [0..10] of weapons;
armor:array [0..5] of armors;
magici:array [0..10] of magic_staff;
ring : array [0..19] of ringer;
monster_array:array [1..68] of monsters; {monster 50 is a no monster!}
conditions: weather;
map : array [-5..85,-5..28] of char;
auto_map : array [0..79,0..24] of char;
campr,modder,foodmv, moves,dunchk : integer;

procedure sub_moves(subb : integer);
begin
moves:=moves-subb;
player.total_moves:=player.total_moves+subb;
foodmv:=foodmv+subb;
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

procedure display_gold;
begin
talknl(3,'Gold Pieces:      '+cstrr(player.goldpieces,10));
end;

procedure display_moves;
begin talknl(3,'Moves Remaining:    '+cstr(moves)); end;

procedure return_stats;
begin
player.stats[1]:=act_stats[1]; player.stats[2]:=act_stats[2]; player.numatt:=act_stats[5];
player.stats[6]:=act_stats[3]; player.stats[4]:=act_stats[4];
end;

procedure orig_stats;
begin
act_stats[1]:=player.stats[1]; act_stats[2]:=player.stats[2];
act_stats[3]:=player.stats[6]; act_stats[4]:=player.stats[4];
act_stats[5]:=player.numatt;
end;

procedure statements;
var garbage : str;
begin
if player.city then talk(5,'Reminders for Next Time (25 chars)?: ') else
say_saying('Reminders for Next Time? (25 chars)?: ');
input(garbage,25);
player.memory:=garbage;
end;

procedure save_char(test : byte);
var saver: file of character;
filename:string[8];
temper:array [1..5] of byte;
begin
temper[1]:=player.stats[1]; temper[2]:=player.stats[2];
temper[3]:=player.stats[6]; temper[4]:=player.stats[4];
temper[5]:=player.numatt;
return_stats;
 filename:='        ';
 str(usernum,filename);
 filename:=filename+'.sav';
 assign(saver,filename);
 rewrite(saver);
 write(saver,player);
 close(saver);
player.stats[1]:=temper[1]; player.stats[2]:=temper[2]; player.numatt:=temper[5];
player.stats[6]:=temper[3]; player.stats[4]:=temper[4];
end;

procedure table_char;
type table = record
name : string[25];
level : byte;
tm   : real;
win : boolean;
end;
var ftab : file of table; tlist : table; axd,stan : integer;
begin
assign(ftab,'TABLE.DAT'); reset(ftab);
seek(ftab,usernum-1);
tlist.name:=player.name; axd:=3;
tlist.level:=player.level;
tlist.tm :=player.total_moves;
if player.door_exemps[253]=69 then tlist.win:=true else tlist.win:=false;
write(ftab,tlist);
reset(ftab); cls;
talknl(4,'NAME                      LEVEL           TOTAL MOVES'); nl;
for stan:=1 to 750 do begin
read(ftab,tlist);
if tlist.level>0 then begin
talk(4,tlist.name);
goto_ansixy(axd,29);
talk(3,' '+cstr(tlist.level));
goto_ansixy(axd,39);
talk(7,' '+cstrr(tlist.tm,10));
goto_ansixy(axd,51);
if tlist.win then talknl(8,'IS A WINNER!') else nl;
axd:=axd+1;
if axd=22 then begin pausescr; cls; axd:=1; end;
end;
end;
pausescr;
close(ftab);
end;

procedure check_moves;
var xevior : string[35];
begin
if moves < 1 then begin
xevior:='OUT OF MOVES, SEE YA TOMORROW!';
if player.city then
talknl(6,xevior)
else
say_saying(xevior);
statements; save_char(1); table_char; return;
end;
end;

procedure determine_armorclass;
var y:integer;
begin
with player do begin
y:=modifier(stats[4]);
armorclass:=equiparmor.protect+equiparmor.magical+y;
if (equipring.idnum>0) and (equipring.idnum<6) then
armorclass:=armorclass+equipring.magical;
if armorclass<0 then armorclass:=0;
end; end;

procedure assign_moves;
begin
if player.class = 4 then moves:=275 else moves :=250;
end;

procedure check_player_death;
var temr : integer;
begin
with player do begin
if act_hitpoints < 0 then begin
 act_hitpoints:=maxhitpoints;
 goldpieces:=int(goldpieces * 0.9);
 temr:=random(6)+1;
 case temr of
  1: begin stats[1]:=stats[1]-1; act_stats[1]:=act_stats[1]-1; end;
  2: begin stats[2]:=stats[2]-1; act_stats[2]:=act_stats[2]-1; end;
  4: begin stats[4]:=stats[4]-1; act_stats[4]:=act_stats[4]-1; end;
  6: begin stats[6]:=stats[6]-1; act_stats[3]:=act_stats[3]-1;  end;
  else stats[temr]:=stats[temr]-1;
end;
 say_saying('Your Character has Been Killed -- Do NOT hang up it has Already ');
 say_saying('Been Saved!  The Monsters have taken Ten Percent of your Gold and ');
 say_saying('You Have Lost One Point of '+stat_name[temr]+'.'); pausescr;
 moves:=-1; check_moves;
 return;
end; end;
end;

{$I BANK.PAS}

procedure use_potion(var loc : byte; var changee : integer; max_cha: integer);
var t:integer;
begin
t:=random(player.level*8)+3+modifier(player.stats[6]); if t<1 then t:=1;
loc:=loc-1;
changee:=changee+t;
if changee > max_cha then changee:=max_cha;
say_saying('You were restored by '+cstr(t)+' Points!');
end;

{$I CONVERSE.PAS}

procedure use_stat_pot(var loct,st : byte; name:helper; origi : byte);
var cta : byte;
begin
loct:=loct-1;  cta:=random(10)+1+modifier(player.stats[6]);
if cta<1 then cta:=1;
if st-act_stats[origi]>15 then cta:=0; st:=st+cta;
say_saying('You gained '+cstr(cta)+' Points of '+name);
determine_armorclass;
end;

procedure use_delay;
begin
player.exemptions[49]:=player.exemptions[49]-1;
moves:=moves+50; time_expander:=true;
end;

procedure use_speed;
begin
player.numatt:=player.numatt+1;
player.exemptions[50]:=player.exemptions[50]-1;
say_saying('You now receive '+cstr(player.numatt)+' Attacks Per Round!');
end;

function use_which_potion : boolean;
type tempost=string[20];
var x,y: byte; chi: char; passer:boolean;
begin
passer:=false; y:=18; use_which_potion:=false;
say_saying('Usable Potions (0 for None): ');
for x:=1 to 8 do
if player.exemptions[42+x]>0 then begin passer:=true;
case x of
1 : say_saying('1. HEALING ');
2 : say_saying('2. RESTORE MAGIC POINTS  ');
3 : say_saying('3. STRENGTH');
4 : say_saying('4. INTELLIGENCE');
5 : SAY_SAYING('5. LUCK  ');
6 : say_saying('6. DEXTERITY');
7 : say_saying('7. ADDITIONAL MOVES ');
8 : say_saying('8. SPEED ');
end;
end;
if passer then begin say_saying('Choice: '); onek(chi,'012345678'); x:=(ord(chi)-48);
if chi <> '0' then
if player.exemptions[42+x] > 0 then begin
 use_which_potion:=true;
 case chi of
 '1' : use_potion(player.exemptions[43],player.act_hitpoints,player.maxhitpoints);
 '2' : use_potion(player.exemptions[44],player.act_spellpoints,player.stats[8]);
 '3' : use_stat_pot(player.exemptions[45],player.stats[1],'STRENGTH',1);
 '4' : use_stat_pot(player.exemptions[46],player.stats[2],'INTELLIGENCE',2);
 '5' : use_stat_pot(player.exemptions[47],player.stats[6],'LUCK',3);
 '6' : use_stat_pot(player.exemptions[48],player.stats[4],'DEXTERITY',4);
 '7' : if time_expander =false then use_delay;
 '8' : use_speed;
 end end else say_saying('You don''t have any of those!');
end;
if passer=false then begin say_saying('No Potions in Your Possession!'); pausescr;
use_which_potion:=false; end;
end;
{$I COMBATB.PAS}

procedure main_dun;

procedure show_location;
var r,s,crdx,crdy,x3,y3,xer,yer : integer;
begin
with player do begin
if dungeon then begin crdx:=xactual; crdy:=yactual; end
  else begin crdx:=outxact; crdy:=outyact; end;
if crdx > 78 then
  if dungeon then xactual:=1 else outxact:=1;
if crdy > 23 then if dungeon then yactual:=1 else outyact:=1;
if crdx < 1 then if dungeon then xactual:=78 else outxact:=78;
if crdy < 1 then if dungeon then yactual:=23 else outyact:=23;
if dungeon then begin crdx:=xactual; crdy:=yactual; end
  else begin crdx:=outxact; crdy:=outyact; end;
end;
if player.door_exemps[255]=0 then
for y3:=-3 to 3 do begin
goto_ansixy(12+y3,31);
for x3:=-5 to 5 do begin
 r:=crdx+x3; s:=crdy+y3;
 case map[r,s] of
  '∞',' ','o' : begin ansic(3); prompt(map[r,s]); end;
  'ù','Á' : begin ansic(7); prompt(map[r,s]); end;
  'B'..'I','Ô','$','W','w' : begin ansic(8); prompt(map[r,s]); end;
  'å','T','P' : prompt(' ');
  '±' : begin ansic(4); prompt(map[r,s]); end;
  '≤' : begin ansic(0); prompt(map[r,s]); end;
  else begin ansic(5); prompt(map[r,s]); end;
 end;
end;
end;
ansic(0);
if player.door_exemps[255]=1 then
for y3:=-3 to 3 do begin
goto_ansixy(12+y3,31); s:=crdy+y3;
for x3:=-5 to 5 do begin
 r:=crdx+x3;
 if map[r,s] in ['å','P','T'] then prompt(' ') else prompt(map[r,s]);
end;
end;
goto_ansixy(12,36);ansic(4); prompt('Í');
for x3:=-1 to 1 do
 for y3:= -1 to 1 do
   if not(map[crdx+x3,crdy+y3] in ['å','P','T']) then
      auto_map[crdx+x3,crdy+y3]:=map[crdx+x3,crdy+y3];
end;

procedure display_hit_points;
begin
goto_ansixy(4,53); prompt('       ');
ansic(5);
goto_ansixy(4,53); prompt(cstr(player.maxhitpoints)+'/'+cstr(player.act_hitpoints));
end;

procedure display_gps;
begin
ansic(5);
goto_ansixy(5,53); prompt(cstrr(player.goldpieces,10));
end;

procedure display_magic;
begin
ansic(5);
goto_ansixy(6,53); prompt(cstr(player.stats[8])+'/'+cstr(player.act_spellpoints));
end;

procedure display_AC;
begin
ansic(5);
goto_ansixy(7,53); prompt(cstr(player.armorclass));
end;

procedure display_LOX;
begin
ansic(5);
goto_ansixy(8,53); if player.dungeon then prompt(cstr(player.xactual)+'  ')
  else prompt(cstr(player.outxact));
end;

procedure display_LOY;
begin
ansic(5);
goto_ansixy(9,53); if player.dungeon then prompt(cstr(player.yactual)+'  ')
  else prompt(cstr(player.outyact));
end;

procedure display_food;
begin
ansic(5);
goto_ansixy(10,53); prompt(cstr(player.food))
end;

procedure display_mvs;
begin
ansic(5); goto_ansixy(11,53); prompt(cstr(moves)+'  '); end;

procedure main_grid;
var f1: file of char; tempor : char;
begin
cls;
if player.door_exemps[254]=0 then begin
assign(f1,'maindun.ans');
reset(f1);
while not EOF(f1) do begin
read(f1, tempor); prompt(tempor);
end;
close(f1); end;
end;

procedure display_all;
begin
display_hit_points;
display_gps;
display_magic;
display_AC;
display_lox;
display_loy;
display_food;
display_mvs;
if player.dungeon then begin goto_ansixy(15,45); talk(3,dungeon_stuff.dname);
end; end;

procedure encounter;
var yy : file of monster_table;
j,k,l,m,n :  byte; y,x : integer;
sholder : monster_table; crapper:boolean;
begin
y:=0;
case player.level of
  1,2 : y:=0;
  3,4,5: y:=1;
  6,7: y:=2;
  8,9,10 : y:=3;
  11..20: y:=3; {Change later}
  end;
if y > 5 then y:=5 else if y <0 then y:=0;
assign(yy,'ENCOUNTS.PIT'); reset(yy);
x:=random(50)+(y*50);
seek(yy,x); read(yy,sholder); close(yy);
with sholder do begin
J:=mon1; k:=mon2; l:=mon3; m:=mon4; n:=amount;
end;
crapper:=COMBAT(j,k,l,m,n);
if crapper then check_for_new_level(n);
end;

procedure restore;
begin
dialcnt:=18; main_grid; display_all; show_location;
end;

procedure rester;
var gg:char;
begin
say_saying('Do You Wish to Rest? (Y/N): ');
onek(gg,'NY');
if gg='Y' then begin
  sub_moves(player.maxhitpoints-player.act_hitpoints);
  sub_moves(player.stats[8]-player.act_spellpoints);
  player.act_hitpoints:=player.maxhitpoints;
  player.act_spellpoints:=player.stats[8];
  display_all; check_moves;
end;
end;

function do_a_room(xer,yer : integer) : BOOLEAN;
var f,g,h,i,j,encc:byte; testes : boolean;
begin
encc:=determin_combat(xer,yer,f,g,h,i,j);
if player.door_exemps[dung_room[encc].toggler] = 1 then begin do_a_room:=true;
say_saying('This Room is Empty Because of a Previous Battle!'); rester; end else
begin
say_saying('The Rusted Door Bursts Open and Inside is ...........');
f:=dung_room[encc].dencount[1]; g:=dung_room[encc].dencount[2];
h:=dung_room[encc].dencount[3]; i:=dung_room[encc].dencount[4];
j:=dung_room[encc].dencount[5]; pausescr;
if f>0 then testes:=combat(f,g,h,i,j) else testes:=true;
   if testes then begin
   if dung_room[encc].special > 0 then whats_so_special(dung_room[encc].special);
   player.door_exemps[dung_room[encc].toggler] := 1;   {HE WON THE BATTLE}
   check_for_new_level(j); restore; do_a_room:=true; {MOVE THROUGH IT!!}
  end else begin restore; do_a_room:=false; end;
 end;
end;

procedure do_a_wandering;
var choicer : char;
begin
case (random(6)) of
 1 : begin do_other_wandering; display_all; end;
 0,2,3,4,5 : begin
 say_saying('An Encounter! Hit ''A'' to begin the Attack!');
 onek(choicer,'A'); encounter; dialcnt:=18;
 cls; main_grid; display_all; show_location;
 end;
end;
display_hit_points;
end;

procedure do_an_increase;
begin
with player do begin
if act_hitpoints < maxhitpoints then
  begin act_hitpoints:=act_hitpoints+1; display_hit_points end;
if act_spellpoints < stats[8] then
   begin act_spellpoints:=act_spellpoints+1; display_magic; end;
end;
end;

procedure check_for_wandering;
begin
if random(125)=25 then do_a_wandering;
if (random(15)=1) or (player.equipring.idnum=12) or (player.equipring.idnum=13) then do_an_increase;
if foodmv > 80 then begin check_food_supply; display_food; foodmv:=0; end;
end;

procedure pf_kill;
var winner:boolean;
tempchar : char; filex : file of char;
begin
winner:=COMBAT(29,68,50,50,2);
if winner then begin
 check_for_new_level(2);
 assign(filex,'TITLER3.ANS'); reset(filex); ansic(0);
 while not EOF(filex) do begin
 read(filex,tempchar);
 prompt(tempchar);
 end;
pausescr; pausescr;
 player.door_exemps[253]:=69;
 moves:=-1; check_moves;
end;
end;

function newmove(x1,y1 : integer) : boolean;
var test:boolean; gh,a,b,c,d,e : byte; gg:char;
begin
newmove:=false;  gg:=chr(172);
if player.dungeon then
  case map[(player.xactual)+x1,(player.yactual)+y1] of
 ' ','≤','±' : newmove:=true;
 'C' : if player.door_exemps[253]<>69 then begin test:=do_a_cave; if test then pf_kill; end;
 'V' : begin newmove:=true; what_a_view; end;
 'S' : begin newmove:=true; exitter:=true; player.outdoor:=true; player.dungeon:=false; end;
 'D' : begin test:=do_a_room(x1,y1); newmove:=test; end;
 'W','w' : begin newmove:=true; test:=do_a_stairs(x1,y1); if test then get_screen; end;
 '∞' : begin newmove:=true;  sub_moves(1); end;
 'õ' : begin test:=caryatid(a,b,c,d,e); if test then
       test:=COMBAT(a,b,c,d,e); if test then begin check_for_new_level(e);
       restore; map[player.xactual+x1,player.yactual+y1]:=' '; end;
       newmove:=test; end;
 'P' : begin newmove:=true; do_a_pit2(x1,y1); display_all; end;
 'T' : begin newmove:=true; do_a_timetrap(x1,y1); display_all; end;
 'å' : begin guard(a,b,c,d,e); test:=combat(a,b,c,d,e); if test then begin
       check_for_new_level(e); map[player.xactual+x1,player.yactual+y1]:=' '; end;
       restore; newmove:=test; end;
  'ü' : begin do_a_fountain; display_all; end;
  '$' : begin newmove:=true; do_a_treasure(x1,y1); display_all; end;
  'o' : begin fountain(a,b,c,d,e); if a >0 then begin
         test:=COMBAT(a,b,c,d,e); check_for_new_level(e); restore; end;
        end;
  'ù' : begin newmove:=true; sub_moves(1); end;
  'R' : begin newmove:=riddler(x1,y1,0); restore; end;
  'M' : begin newmove:=riddler(x1,y1,1); restore; end;
  '#' : newmove:=time_warp;
  'Á' : begin newmove:=true; soma_plant(x1,y1); sub_moves(1); end;
  'B' : begin newmove:=true; do_a_bird; restore; end;
  end;
if player.outdoor then
   case map[(player.outxact)+x1,(player.outyact)+y1] of
  ' ' : newmove:=true;
  'ù' : begin newmove:=true; sub_moves(4); end;
  '∞' : begin newmove:=true; if player.equipring.idnum<> 16 then sub_moves(24); end;
  '±' : begin newmove:=true; foodmv:=foodmv+2; end;
  'B' : if not bridger then begin test:=do_a_bridge(a,b,c,d,e); if test then begin
        test:=COMBAT(16,b,c,d,e); if test then check_for_new_level(e);
        bridger:=test; restore; end; newmove:=test; end else newmove:=true;
  'F' : newmove:=do_a_ferry;
  'H' : begin newmove:=true; test:=enter_sage(x1,y1); if test then restore; end;
  'I' : begin newmove:=true; enter_inn; display_all; end;
  'C' : begin newmove:=true; enter_city; end;
  'Ô' : begin newmove:=true; load_dungeon(x1,y1); enter_dungeon_check(gh);
        a:=dungeon_stuff.wrong[1]; b:=dungeon_stuff.wrong[2]; c:=dungeon_stuff.wrong[3];
        d:=dungeon_stuff.wrong[4]; e:=dungeon_stuff.wrong[5];
        case gh of
         0:  ;
         1,3: begin test:=combat(a,b,c,d,e); if test then check_for_new_level(e); restore; end;
         2:  begin newmove:=false; enter_dun_This_way(x1,y1); end;
        end;
       end;
    else if map[(player.outxact)+x1,(player.outyact)+y1] = gg then begin
         newmove:=true; sub_moves(random(24)+1); end;
   end;
sub_moves(1); display_mvs;
end;

procedure check_north;
var legit : boolean;
begin
if player.yactual = 1 then begin player.ymap:=player.ymap-1; get_screen; legit:=true; end else
legit:=newmove(0,-1);
if legit then begin
player.yactual:=player.yactual-1;
display_loy;
show_location;
end else prompt(chr(7));
end;

procedure check_west;
var legit : boolean;
begin
if player.xactual = 1 then begin player.xmap:=player.xmap-1; get_screen; legit:=true; end else
legit:=newmove(-1,0);
if legit then begin
player.xactual:=player.xactual-1;
display_lox;
show_location;
end else prompt(chr(7));
end;

procedure check_east;
var legit : boolean;
begin
if player.xactual = 78 then begin player.xmap:=player.xmap+1; get_screen; legit:=true; end else
legit:=newmove(1,0);
if legit then begin
player.xactual:=player.xactual+1;
display_lox;
show_location;
end else prompt(chr(7));
end;

procedure check_south;
var legit : boolean;
begin
if player.yactual = 23 then begin player.ymap:=player.ymap+1; get_screen; legit:=true; end else
legit:=newmove(0,1);
if legit then begin
player.yactual:=player.yactual+1;
display_loy;
show_location;
end
else prompt(chr(7));
end;

procedure check_north_out;
var legit : boolean;
begin
if player.outyact = 1 then begin player.outymap:=player.outymap-1; get_screen; legit:=true; end else
legit:=newmove(0,-1);
if legit then begin
player.outyact:=player.outyact-1;
display_loy;
show_location;
end else prompt(chr(7));
end;

procedure check_west_out;
var legit : boolean;
begin
if player.outxact = 1 then begin player.outxmap:=player.outxmap-1; get_screen; legit:=true; end else
legit:=newmove(-1,0);
if legit then begin
player.outxact:=player.outxact-1;
display_lox;
show_location;
end else prompt(chr(7));
end;

procedure check_east_out;
var legit : boolean;
begin
if player.outxact = 78 then begin player.outxmap:=player.outxmap+1; get_screen; legit:=true; end else
legit:=newmove(1,0);
if legit then begin
player.outxact:=player.outxact+1;
display_lox;
show_location;
end else prompt(chr(7));
end;

procedure check_south_out;
var legit : boolean;
begin
if player.outyact = 23 then begin player.outymap:=player.outymap+1; get_screen; legit:=true; end else
legit:=newmove(0,1);
if legit then begin
player.outyact:=player.outyact+1;
display_loy;
show_location;
end
else prompt(chr(7));
end;

var choice: char;
    var bh : boolean;
begin
main_grid; if player.dungeon then begin
load_dungeon(0,0); load_rooms; end; display_all; get_screen;
if player.outdoor then load_weather;
show_location; exitter:=false;
repeat
goto_ansixy(12,53);
ansic(4);
onek(choice,'8462ACFHIQRSUVXZ?');
case choice of
 '8' :if player.dungeon then check_north else check_north_out;
 '4' :if player.dungeon then check_west else check_west_out;
 '6' :if player.dungeon then check_east else check_east_out;
 '2' :if player.dungeon then check_south else check_south_out;
 'A' :begin auto_map_view; cls; restore; end;
 'C' :begin bh:=camper; if bh then do_a_wandering; display_all; campr:=campr+1; end;
 'F' :fast_mode;
 'H' :if player.outdoor then begin hunter; display_food; display_mvs; end
      else say_saying('Hunting Not Allowed in Dungeons!');
 'I' :inspect;
 'Q' :begin moves:=0; check_moves; end;
 'U' :begin bh:=use_which_potion; display_all; sub_moves(1); end;
 'R' :begin bh:=use_ring; if bh then show_location; end;
 'S' :begin save_char(0); sub_moves(1); say_saying('Character Saved'); end;
 'V' :begin cls; view_initial_char; cls; restore; end;
 'X' :begin x_ray; display_mvs; end;
 'Z' :begin destroy_char; check_moves; end;
 '?' :begin player.door_exemps[254]:=0; restore; end;
end;
check_moves;
check_for_wandering;
until exitter;
end;

procedure do_main_area_work;
var infinite:boolean;
begin
infinite:=false;
repeat
talk(5,'Choice (BCDFGLPQRSTVYZ?) -->');
onek(ginput,'BCDFGLPQRSTVYZ?');
case ginput of
'B'  :infinite:=boating;
'C'  :conversationz;
'D'  :docs;
'F'  :fast_mode;
'G'  :if town_stuff.gen then do_general_store else talknl(5,'Sorry no General Store Here');
'L'  :begin infinite:=true; player.city:=false; player.outdoor:=true; end;
'Q'  :begin moves:=0; check_moves; end;
'P'  :if town_stuff.pot then sell_potion else talknl(5,'Sorry no Potion Store here!');
'S'  :begin talknl(4,'Character Saved'); save_char(0); end;
'R'  :if town_stuff.pot then
      begin sell_ring; determine_armorclass; end else talknl(5,'Sorry no Ring Store Here!');
'T'  :if town_stuff.tav then enter_tavern else talknl(5,'Sorry no Tavern Located Here!');
'V'  :view_initial_char;
'Y'  :guardian_angel;
'Z'  :begin destroy_char; check_moves; end;
'?'  :welcome;
end;
until infinite;
end;

procedure do_city;
begin
get_city_info; welcome;
Do_Main_Area_work;
end;

procedure try_to_read_char;
var g1:file of character;
    filename:string[8];
begin
filename:='        ';
str(usernum,filename);
assign(g1,filename+'.sav');
{$I-} reset(g1); {$I+}
if IOresult=0 then begin read(g1,player); assign_moves;
 serial;
 talknl(5,'Your Reminders from Last Time are...');
 talknl(4,player.memory); nl; pausescr; orig_stats; close(g1);
end else begin intro; create_for_real; view_initial_char; assign_moves; end;
end;

begin
doner:=false; init_names; read_weapons; dialcnt:=18; foodmv:=1;
do_opening_screen; time_expander:=false; modder:=0; maz:=1; bridger:=false;
randomize; use_pool:=false; campr:=0; dunchk:=1;
iport;
try_to_read_char; determine_armorclass;
repeat if (player.dungeon) OR (player.outdoor) then main_dun
else do_city; until doner;
end.
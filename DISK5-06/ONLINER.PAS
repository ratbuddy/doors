{$O+,F+}

program on_liner;

uses crt,common,globals,overlay,combatb,bank,converse;
{$O COMBATB}
{$O bank}
{$O CONVERSE}

procedure sub_moves(subb : integer);
begin
player.total_moves:=player.total_moves+subb;
end;

procedure talk(h : integer; speech : helper);
begin
ansic(h);
write(speech);
end;

procedure talknl(h : integer; speechnl : helper);
begin
ansic(h); writeln(speechnl);
end;

procedure display_gold;
begin
talknl(3,'Gold Pieces:      '+cstrr(player.goldpieces,10));
end;

procedure return_stats;
begin
player.stats[1]:=act_stats[1]; player.stats[2]:=act_stats[2]; player.numatt:=act_stats[5];
player.stats[6]:=act_stats[3]; player.stats[4]:=act_stats[4]; end;

procedure statements;
var garbage : helper;
begin
say_saying('Reminders for Next Time? (25 chars)?');
input(garbage,25);
player.memory:=garbage;
end;

procedure save_char;
var saver: file of character;
begin
 return_stats; statements;
 assign(saver,'PIT2.SAV');
 rewrite(saver);
 write(saver,player);
 close(saver);
end;

procedure delete_item(typer:char);
begin
case typer of
'A' : player.equiparmor:=armor[0];
'W' : player.equipweapon:=weapon[0];
'M' : player.equipmis:=weapon[0];
'S' : player.equipmagic:=magici[0];
end;
end;

procedure orig_stats;
begin
act_stats[1]:=player.stats[1]; act_stats[2]:=player.stats[2];
act_stats[3]:=player.stats[6]; act_stats[4]:=player.stats[4];
act_stats[5]:=player.numatt;
end;

procedure use_potion(var loc : byte; var changee : integer; max_cha: integer);
var t:integer;
begin
t:=random(15)+3+modifier(player.stats[6]); if t<1 then t:=1;
loc:=loc-1;
changee:=changee+t;
if changee > max_cha then changee:=max_cha;
say_saying('You were restored by '+cstr(t)+' Points!');
end;

procedure use_stat_pot(var loct,st : byte; name:helper; origi : byte);
var cta : byte;
begin
loct:=loct-1;  cta:=random(6)+1;
if st-act_stats[origi]>15 then cta:=0; st:=st+cta;
say_saying('You gained '+cstr(cta)+' Points of '+name);
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

procedure use_which_potion;
type tempost=string[20];
var x,y: byte; chi: char; passer:boolean;
begin
passer:=false; y:=18;
say_saying('Usable Potions:');
for x:=1 to 8 do
if player.exemptions[42+x]>0 then
case x of
1 : begin say_saying('1. HEALING '); passer:=true; end;
2 : begin say_saying('2. RESORE MAGIC POINTS  ');  passer:=true; end;
3 : begin say_saying('3. STRENGTH');  passer:=true; end;
4 : begin say_saying('4. INTELLIGENCE');  passer:=true; end;
5 : begin say_saying('5. LUCK  ');  passer:=true; end;
6 : begin say_saying('6. DEXTERITY');  passer:=true; end;
7 : begin say_saying('7. ADDITIONAL MOVES '); passer:=true; end;
8 : begin say_saying('8. GOLD '); passer:=true; end;
end;
if passer then begin onek(chi,'012345678'); x:=(ord(chi)-48);
 if chi <> '0' then
   if player.exemptions[42+x] > 0 then
     case chi of
    '1' : use_potion(player.exemptions[43],player.act_hitpoints,player.maxhitpoints);
    '2' : use_potion(player.exemptions[44],player.act_spellpoints,player.stats[8]);
    '3' : use_stat_pot(player.exemptions[45],player.stats[1],'STRENGTH',1);
    '4' : use_stat_pot(player.exemptions[46],player.stats[2],'INTELLIGENCE',2);
    '5' : use_stat_pot(player.exemptions[47],player.stats[6],'LUCK',3);
    '6' : use_stat_pot(player.exemptions[48],player.stats[4],'DEXTERITY',4);
    '7' : if time_expander =false then use_delay;
    '8' : use_speed;
    end else say_saying('You don''t have any of those!');
end;
if passer=false then begin say_saying('None in Your Possession!'); pausescr; end;
end;

procedure main_dun;
type over_helper = string[80];
type signs    = record
xmapper       : integer;
ymapper       : integer;
xpos          : integer;
ypos          : integer;
saying        : over_helper;
end;

var
sign : array [1..38] of signs;

procedure load_signs;
var f1 : file of signs;
filename: string[10]; temp:char; yx:integer;

procedure clear_signs;
var x: integer;
begin
for x := 1 to 38 do
sign[x].saying:='                                                                                                    ';
end;

begin
clear_signs; yx:=0;
temp:=chr(player.dungeon_level+48);
filename:='SIGNS'+temp+'.DAT';
assign(f1,filename);
reset(f1);
while not EOF(f1) do begin
yx:=yx+1;
read(f1,sign[yx]);
end;
close(f1);
end;

procedure show_location;
var crdx,crdy,x3,y3,xer,yer : integer;
begin
  if player.dungeon then begin crdx:=player.xactual; crdy:=player.yactual; end
     else begin crdx:=player.outxact; crdy:=player.outyact; end;
if crdx > 78 then
   if player.dungeon then player.xactual:=1 else player.outxact:=1;
if crdy > 23 then if player.dungeon then player.yactual:=1 else player.outyact:=1;
if crdx < 1 then if player.dungeon then player.xactual:=78 else player.outxact:=78;
if crdy < 1 then if player.dungeon then player.yactual:=23 else player.outyact:=23;
  if player.dungeon then begin crdx:=player.xactual; crdy:=player.yactual; end
     else begin crdx:=player.outxact; crdy:=player.outyact; end;
for y3:=-3 to 3 do begin
goto_xy(11+y3,31);
for x3:=-5 to 5 do
 if map[crdx+x3,crdy+y3]='°' then
 begin ansic(3); write(map[crdx+x3,crdy+y3]); end else
  if map[crdx+x3,crdy+y3]='' then begin
       ansic(7); write(map[crdx+x3,crdy+y3]); end else
       if (map[crdx+x3,crdy+y3]='C') or (map[crdx+x3,crdy+y3]='B') then begin
         ansic(8); write(map[crdx+x3,crdy+y3]); end else
         if map[crdx+x3,crdy+y3]='ï' then begin
           ansic(8); write(map[crdx+x3,crdy+y3]); end else
    begin ansic(5); write(map[crdx+x3,crdy+y3]); end;
end;
goto_xy(11,36);ansic(4); write('ê');
   for x3:=-1 to 1 do
     for y3:= -1 to 1 do
       auto_map[crdx+x3,crdy+y3]:=map[crdx+x3,crdy+y3];
end;

procedure display_hit_points;
begin
goto_xy(4,53); write('       ');
ansic(5);
goto_xy(4,53); write(cstr(player.maxhitpoints)+'/'+cstr(player.act_hitpoints));
end;

procedure display_gps;
begin
ansic(5);
goto_xy(5,53); write(cstrr(player.goldpieces,10));
end;

procedure display_magic;
begin
ansic(5);
goto_xy(6,53); write(cstr(player.stats[8])+'/'+cstr(player.act_spellpoints));
end;

procedure display_AC;
begin
ansic(5);
goto_xy(7,53); write(cstr(player.armorclass));
end;

procedure display_LOX;
begin
ansic(5);
goto_xy(8,53); if player.dungeon then write(cstr(player.xactual)+'  ')
  else write(cstr(player.outxact));
end;

procedure display_LOY;
begin
ansic(5);
goto_xy(9,53); if player.dungeon then write(cstr(player.yactual)+'  ')
  else write(cstr(player.outyact));
end;

procedure display_food;
begin
ansic(5);
goto_xy(10,53); write(cstr(player.food))
end;

procedure main_grid;
var f1: file of char; tempor : char;
begin
assign(f1,'maindun.ans');
reset(f1);
while not EOF(f1) do begin
  read(f1, tempor); prompt(tempor);
  end;
close(f1);
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
end;

procedure restore;
begin
dialcnt:=18; main_grid; display_all; show_location;
end;

procedure encounter;
var g1 : file of monster_table;
filename: string[15];
temp : char; j,k,l,m,n :  byte; y,x : integer;
sholder : monster_table; crapper:boolean;
begin
y:=player.level div 2;
if y > 5 then y:=5; if y <1 then y:=1;
temp:=chr(y+48);
filename:='ENCOUNT'+temp+'.PIT';
assign(g1,filename); reset(g1);
x:=random(50)+1;
seek(g1,x-1); read(g1,sholder); close(g1);
J:=sholder.mon1; k:=sholder.mon2; l:=sholder.mon3; m:=sholder.mon4; n:=sholder.amount;
crapper:=COMBAT(j,k,l,m,n);
if crapper then check_for_new_level;
end;

function do_a_room(xer,yer : integer) : BOOLEAN;
var f,g,h,i,j,encc:byte; testes : boolean;
begin
encc:=determin_combat(xer,yer);
if player.door_exemps[dung_room[encc].toggler] = 1 then begin do_a_room:=true;
say_saying('This Room is Empty Because of a Previous Battle!'); end else
  begin
  say_saying('The Rusted Door Bursts Open and Inside is ...........');
  f:=dung_room[encc].dencount[1]; g:=dung_room[encc].dencount[2];
  h:=dung_room[encc].dencount[3]; i:=dung_room[encc].dencount[4];
  j:=dung_room[encc].dencount[5];
  testes:=combat(f,g,h,i,j);
    if testes then begin
       if dung_room[encc].special > 0 then whats_so_special(dung_room[encc].special);
      player.door_exemps[dung_room[encc].toggler] := 1;   {HE WON THE BATTLE}
      check_for_new_level; restore; do_a_room:=true; {MOVE THROUGH IT!!}
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
 onek(choicer,'A'); encounter;
 clrscr; restore;
 end;
end;
display_hit_points;
end;

procedure do_an_increase;
begin
if player.act_hitpoints < player.maxhitpoints then
  begin player.act_hitpoints:=player.act_hitpoints+1; display_hit_points end;
if player.act_spellpoints < player.stats[8] then
   begin player.act_spellpoints:=player.act_spellpoints+1; display_magic; end;
end;

procedure check_for_wandering;
begin
if random(75)=25 then do_a_wandering;
if random(12)=1 then do_an_increase;
if random(60)= 1 then begin check_food_supply; display_food; end;
end;

procedure do_a_sign(modx,mody : integer);
var x: integer;
begin
for x:=1 to 38 do
if player.xmap = sign[x].xmapper then
if player.ymap = sign[x].ymapper then
if player.xactual+modx = sign[x].xpos then
if player.yactual+mody = sign[x].ypos then
say_saying(sign[x].saying); pausescr;
end;

function newmove(x1,y1 : integer) : boolean;
var test:boolean; gh,a,b,c,d,e : byte;
begin
newmove:=false;
if player.dungeon then
  case map[(player.xactual)+x1,(player.yactual)+y1] of
 ' ','²' : newmove:=true;
 'S' : begin newmove:=true; exitter:=true; player.outdoor:=true; player.dungeon:=false; end;
 'â' : begin do_a_sign(x1,y1); newmove:=true; end;
 'D' : begin test:=do_a_room(x1,y1); newmove:=test; end;
 '°' : begin newmove:=true;  sub_moves(1); end;
 '›' : begin newmove:=false;
       test:=COMBAT(42,51,51,51,1); if test then check_for_new_level;
       restore; end;
  end;
if player.outdoor then
   case map[(player.outxact)+x1,(player.outyact)+y1] of
      ' ' : newmove:=true;
      '' : begin newmove:=true; sub_moves(4); end;
      '°' : begin newmove:=true; sub_moves(24); end;
      'B' : begin test:=do_a_bridge(a,b,c,d,e); if a=2 then
            test:=COMBAT(16,b,c,d,e); if test then begin
            check_for_new_level; restore; end; newmove:=test; end;
      'C' : begin newmove:=true; enter_city; end;
      'ï' : begin newmove:=true; load_dungeon(x1,y1); enter_dungeon_check(gh);
            a:=dungeon_stuff.wrong[1]; b:=dungeon_stuff.wrong[2]; c:=dungeon_stuff.wrong[3];
            d:=dungeon_stuff.wrong[4]; e:=dungeon_stuff.wrong[5];
            case gh of
              0:  ;
             1,3: begin test:=combat(a,b,c,d,e); if test then check_for_new_level; restore; end;
              2:  begin newmove:=false; enter_dun_This_way(x1,y1); end;
            end;
            end;
   end;
sub_moves(1);
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
end else write(chr(7));
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
end else write(chr(7));
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
end else write(chr(7));
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
else write(chr(7));
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
end else write(chr(7));
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
end else write(chr(7));
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
end else write(chr(7));
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
else write(chr(7));
end;

var choice: char;
begin
main_grid; display_all; get_screen;
if player.dungeon then begin load_signs; load_rooms; end;
show_location; exitter:=false;
repeat
goto_xy(12,53);
ansic(4);
onek(choice,'8462AQUSVX');
case choice of
 '8' :if player.dungeon then check_north else check_north_out;
 '4' :if player.dungeon then check_west else check_west_out;
 '6' :if player.dungeon then check_east else check_east_out;
 '2' :if player.dungeon then check_south else check_south_out;
 'A' :if player.dungeon then begin auto_map_view; pausescr; clrscr; main_grid; display_all; show_location; end
      else say_saying('Automapper not enabled in Outdoor mode!');
 'Q' : begin save_char; halt; end;
 'U' : begin use_which_potion; display_all; end;
 'S' : save_char;
 'V' : begin clrscr; view_initial_char; clrscr; main_grid; display_all; show_location; end;
end;
check_for_wandering;
until exitter;
end;

procedure do_main_area_work;
var infinite:boolean;
begin
infinite:=false;
repeat
talk(5,'Choice (BCGLPQSTV?) -->');
onek(ginput,'BCGLPQSTV?');
case ginput of
'B'  :boating;
'C'  :conversationz;
'G'  :if town_stuff.gen then do_general_store else talknl(5,'Sorry no General Store Here');
'L'  :begin infinite:=true; player.city:=false; player.outdoor:=true; end;
'Q'  :begin save_char; halt; end;
'P'  :if town_stuff.pot then sell_potion else talknl(5,'Sorry no Potion Store here!');
'S'  :save_char;
'T'  :if town_stuff.tav then enter_tavern else talknl(5,'Sorry no Tavern Located Here!');
'V'  :view_initial_char;
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
var g1:file of character; ghi: char;
begin
talk(4,'(R)estart Saved Game  (S)tart a New Game  :');
onek(ghi,'RS');
if ghi='R' then begin assign(g1,'PIT2.SAV'); reset(g1);
   read(g1,player); talknl(5,'Your Reminders from Last Time are...');
   talknl(4,player.memory); nl; pausescr; orig_stats; close(g1);
   end else begin intro; create_for_real; orig_stats; end;
end;

begin
ovrinit('onliner.ovr');
doner:=false; init_names; read_weapons; dialcnt:=18;
printfile('TITLER2.ANS'); time_expander:=false; modder:=0;
randomize;
try_to_read_char; determine_armorclass;
repeat if (player.dungeon) OR (player.outdoor) then main_dun
 else do_city; until doner;
end.
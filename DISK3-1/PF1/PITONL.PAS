program on_liner;
{$I COMMON.PAS}
{$I Records.H}
var player,otra_player: character;
elf_mod:byte; patience:boolean;
meanies:array [1..4] of monsters;
auto_map : array [0..79,0..24] of char;
name: helper; otra_char : integer;
ginput:char; potion_array:array [1..8] of potions;
ready_to_adventur: boolean; maz:byte;
stat_name: array[1..11] of string[15]; act_stats:array[1..4] of byte;
created_char : boolean; time_expander:boolean;
class_name: array[1..6] of string[15];
weapon:array [1..24] of weapons;
armor:array [1..13] of armors;
magici:array [1..10] of magic_staff;
monster_array:array [1..73] of monsters; {monster 73 is a character!}
map : array [-5..85,-5..28] of char;
moves : integer; modder:integer;
{$I MODSTATS.PAS}

procedure talk(h : integer; speech : helper);
begin
ansic(h);
prompt(speech);
end;

procedure talknl(h : integer; speechnl : helper);
begin
ansic(h); print(speechnl);
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

procedure display_gold;
begin
talknl(3,'Gold Pieces:      '+cstrr(player.goldpieces,10));
end;

procedure display_moves;
begin talknl(3,'Moves Remaining:    '+cstr(moves)); end;

procedure place_character;
var act_player : character_location;
temp_player : character_location;
filer : file of character_location;
begin
assign(filer,'locxy.dat');
reset(filer);
act_player.num:= usernum;
act_player.dungeon_level:=player.dungeon_level;
act_player.xmaps := player.xmap;
act_player.ymaps := player.ymap;
act_player.xloc := player.xactual;
act_player.yloc := player.yactual;
seek(filer,usernum-1);
write(filer,act_player);
close(filer);
end;
procedure return_stats;
begin
player.stats[1]:=act_stats[1]; player.stats[2]:=act_stats[2];
player.stats[6]:=act_stats[3]; player.stats[4]:=act_stats[4]; end;

procedure table_character;
var ff : file of table;
    tempo : table;
begin
assign(ff,'TABLE.DAT');
reset(ff);
tempo.name:=player.name;
tempo.dun_lvl:=player.dungeon_level;
tempo.class:=player.class;
tempo.level:=player.level;
seek(ff,usernum-1);
write(ff,tempo);
close(ff);
end;

procedure save_char;
var saver: file of character;
    filename:string[8];
    temper:array [1..4] of byte;
begin
if created_char then begin
temper[1]:=player.stats[1]; temper[2]:=player.stats[2];
temper[3]:=player.stats[6]; temper[4]:=player.stats[4];
 return_stats;
 filename:='        ';
 str(usernum,filename);
 filename:=filename+'.sav';
 assign(saver,filename);
 rewrite(saver);
 write(saver,player);
 close(saver);
 place_character; table_character;
player.stats[1]:=temper[1]; player.stats[2]:=temper[2];
player.stats[6]:=temper[3]; player.stats[4]:=temper[4];
end;
end;

procedure see_list;
var agt : char; ff:file of table; tempy : table; xx: integer;
begin
nl;
talk(3,'Do You Wish to See The Character Table? (Y/N):'); xx:=0;
onek(agt,'YN');
if agt='Y' then begin xx:=1;
  cls; assign(ff,'TABLE.DAT'); reset(ff);
  while not EOF(ff) do begin
    read(ff,tempy);
    if tempy.level > 0 then begin
    if tempy.dun_lvl = 20 then
       talknl(3,tempy.name+' is a Winner of this Game!') else
    talknl(3,tempy.name+' is a Level '+cstr(tempy.level)+' '+class_name[tempy.class]+
       ' on Dungeon Level '+cstr(tempy.dun_lvl));
     xx:=xx+1;
     if xx mod 22 = 0 then begin pausescr; cls; end;
    end;
  end;
close(ff); pausescr;
end;
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
 save_char;
 say_saying('Your Character has Been Killed -- Do NOT hang up it has Already ');
 say_saying('Been Saved!  The Monsters have taken Ten Percent of your Gold and ');
 say_saying('You Have Lost One Point of '+stat_name[temr]+'.'); pausescr;
 return;
end; end;
end;

procedure check_moves;
begin
if moves <=0 then begin
goto_ansixy(22,1); talknl(6,'OUT OF MOVES, SEE YA TOMORROW!');
pausescr; save_char; see_list; return; end;
end;

procedure delete_item(typer:char);
begin
case typer of
'A' : player.equiparmor.idnum:='NONE';
'H' : player.equipshield.idnum:='NONE';
'W' : player.equipweapon.idnum:='NONE';
'M' : player.equipmis.idnum:='NONE';
'S' : player.equipmagic.idnum:='NONE';
end;
end;

procedure list_view;
begin
with player do begin
if equipweapon.idnum[1] <>'N' then talknl(4,'Equipped Weapon : '+equipweapon.name+' +'+
   cstr(equipweapon.magical));
if equiparmor.idnum[1] <> 'N' then talknl(4,'Equipped Armor  : '+equiparmor.name+' +'+
   cstr(equiparmor.magical));
if equipmagic.idnum[1] <> 'N' then talknl(4,'Equipped Staff  : '+equipmagic.name);
if equipshield.idnum[1] <> 'N' then talknl(4,'Equipped Shield : '+equipshield.name+' +'+
    cstr(equipshield.magical));
if equipmis.idnum[1] <> 'N' then talknl(4,'Equipped Missile: '+equipmis.name+' +'+
   cstr(equipmis.magical));
end;
end;

procedure determine_armorclass;
var y:integer;
begin
player.armorclass:=0;
if player.equiparmor.idnum[1] <> 'N' then
     player.armorclass:=player.equiparmor.protect+player.equiparmor.magical;
if player.equipshield.idnum[1] <> 'N' then
   if player.equipweapon.h2h = false then
     player.armorclass:=player.equipshield.protect + player.armorclass + player.equipshield.magical;
player.armorclass:=player.armorclass+modifier(player.stats[4]);
if player.armorclass<0 then player.armorclass:=0;
end;

procedure pot_view;
var x:integer;
begin
for x:=43 to 50 do
 if player.exemptions[x] > 0 then
   talknl(4,cstr(player.exemptions[x]) +' Potions of '+potion_array[x-42].name);
end;


procedure view_initial_char;
var x,whichone,itemp:integer; temper:char;
    g:helper; temp:str; tempy:string[2];
begin
cls;
player.name:=thisuser.name;
ansic(3); print(player.name);
for x:=1 to 8 do begin
   talk(5,stat_name[x]+': ');
   talknl(4,cstr(player.stats[x]));
end;
nl;
talk(3,'Class:           ');
talknl(4,class_name[player.class]);
talk(3,'Hit Points:      ');
talk(4,cstr(player.maxhitpoints));
talk(3,'/');
talk(4,cstr(player.act_hitpoints)); nl;
display_gold;
list_view; nl; pot_view;
talk(3,'Level:           '); talknl(4,cstr(player.level));
talk(3,'Experience:      '); talknl(4,cstrr(player.experience,10));
talk(3,'Needed Exper:    '); talknl(4,cstrr(player.needed_exp,10));
talk(3,'Armor Class:     '); talknl(4,cstr(player.armorclass));
talk(3,'Gold In Bank:    '); talknl(4,cstrr(player.bank,10));
talk(3,'# Attacks / Rnd  '); talknl(4,cstr(player.numatt));
talk(3,'Dungeon Level:   '); talknl(4,cstr(player.dungeon_level));
talk(3,'Spell Points:    '); talknl(4,cstr(player.stats[8])+'/'+cstr(player.act_spellpoints));
display_moves;
pausescr;
end;

procedure assign_moves;
begin
if player.class = 4 then moves:=275 else moves :=250;
end;

procedure mod_move_armor;
begin
if player.equiparmor.idnum[1] <> 'N' then moves:=moves-player.equiparmor.movemod;
end;

procedure show_messages;
var filer : file of junker; temp :junker;
   filenamer : string[8];
begin filenamer:='         ';
str(usernum,filenamer);
assign(filer,filenamer+'.MSG');
{$I-} reset(filer); {$I+}
if IOResult <> 0 then begin talknl(5,'You have no Messages!'); pausescr; close(filer); end
 else begin
  while not EOF(Filer) do begin
   read(filer,temp); talknl(4,'Message From:  '+temp.name);
   talknl(4,temp.words); nl;
  end;
pausescr;
close(filer); erase(filer);
end;  end;

procedure orig_stats;
begin
act_stats[1]:=player.stats[1]; act_stats[2]:=player.stats[2];
act_stats[3]:=player.stats[6]; act_stats[4]:=player.stats[4];
end;

procedure add_constitution_bonus;
begin
with player do begin
if stats[5]>20 then maxhitpoints:=maxhitpoints+(player.stats[5]-20);
if stats[5]<9 then maxhitpoints:=maxhitpoints+(player.stats[5]-9);
end; end;

{$I BANK.PAS}

procedure create_char;
var question:char;
begin
cls;
talknl(8,'Warning!!! Creating a Character will');
talknl(8,'Destroy Any Existing Character!!!');nl;
talk(5,'Do you wish to continue? (Y/N)');
onek(question,'YN');
if question='Y' then create_for_real;
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

procedure use_stat_pot(var loct,st : byte; name:hectic; origi : byte);
var cta : byte;
begin
loct:=loct-1;  cta:=random(6)+1;
if st-act_stats[origi]>15 then cta:=0; st:=st+cta;
say_saying('You gained '+cstr(cta)+' Points of '+name);
determine_armorclass;
end;

procedure use_delay;
begin
player.exemptions[49]:=player.exemptions[49]-1;
moves:=moves+50; time_expander:=true;
end;

procedure use_gold_liq;
begin
player.goldpieces:=player.goldpieces+500;
player.exemptions[50]:=player.exemptions[50]-1;
end;

procedure use_which_potion;
type tempost=string[20];
var x: byte; chi: char; passer:boolean;
begin
passer:=false; goto_ansixy(22,1); talk(5,'Usable Potions: ');
for x:=1 to 8 do
if player.exemptions[42+x]>0 then
case x of
1 : begin say_saying('1. HEAL '); passer:=true; end;
2 : begin say_saying('2. MPS ');  passer:=true; end;
3 : begin say_saying('3. STR ');  passer:=true; end;
4 : begin say_saying('4. INT ');  passer:=true; end;
5 : begin say_saying('5. LCK ');  passer:=true; end;
6 : begin say_saying('6. DEX ');  passer:=true; end;
7 : begin say_saying('7. MOVE+ '); passer:=true; end;
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
    '8' : use_gold_liq;
    end else say_saying('You don''t have any of those!');
end;
if passer=false then say_saying('No Potions in Your Possession');
end;
{$I COMBATB.PAS}

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
exitter : boolean;

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
var x3,y3,xer,yer : integer;
begin
with player do begin
if xactual > 78 then xactual:=1;
if yactual > 23 then yactual:=1;
if xactual < 1 then xactual:=78;
if yactual < 1 then yactual:=23;
if not patience then
  for y3:=-2 to 3 do begin
   goto_ansixy(11+y3,31);
   for x3:=-5 to 5 do
   if map[xactual+x3,yactual+y3]='°' then
   begin ansic(3); prompt(map[xactual+x3,yactual+y3]); end else
   begin ansic(5); prompt(map[xactual+x3,yactual+y3]); end;
  end;
ansic(0);
if patience then
  for y3:=-2 to 3 do begin
   goto_ansixy(11+y3,31);
   for x3:=-5 to 5 do
     prompt(map[xactual+x3,yactual+y3]);
  end;
goto_ansixy(11,36);ansic(4); prompt('ê');
for x3:=-1 to 1 do
 for y3:= -1 to 1 do
  auto_map[xactual+x3,yactual+y3]:=map[xactual+x3,yactual+y3];
end;
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
goto_ansixy(8,53); prompt(cstr(player.xactual)+'  ');
end;

procedure display_LOY;
begin
ansic(5);
goto_ansixy(9,53); prompt(cstr(player.yactual)+'  ');
end;

procedure display_DUL;
begin
ansic(5);
goto_ansixy(10,53); prompt(cstr(player.dungeon_level));
end;

procedure display_mvs;
begin
ansic(5); goto_ansixy(12,56); prompt(cstr(moves)+'  '); end;

procedure main_grid;
var g1:file of char; hh: char; row : integer;
begin
assign(g1,'maindun.ans');
reset(g1); cls;
while not EOF(g1) do begin
read(g1,hh);
prompt(hh);
END; close(g1); end;

procedure display_all;
begin
display_hit_points;
display_gps;
display_magic;
display_AC;
display_lox;
display_loy;
display_dul;
display_mvs;
end;

procedure display_map;
var x,y : integer;
begin
say_saying('You get a vision of the current map, now installed in auto-map!');
for y := 1 to 23 do
 for x:= 1 to 78 do
  auto_map[x,y] := map[x,y]
end;

procedure encounter;
var g1 : file of monster_table;
filename: string[15]; bh:boolean;
temp : char; j,k,l,m,n :  byte; y,x : integer;
sholder : monster_table;
begin
y:=player.level div 2;
if y > 5 then y:=5; if y <1 then y:=1;
temp:=chr(y+48);
filename:='ENCOUNT'+temp+'.DAT';
assign(g1,filename); reset(g1);
x:=random(70)+1;
seek(g1,x-1); read(g1,sholder); close(g1);
with sholder do begin
J:=mon1; k:=mon2; l:=mon3; m:=mon4; n:=amount; end;
bh:=COMBAT(j,k,l,m,n); if bh then check_for_new_level(n);
end;

procedure restore;
begin
main_grid; display_all; show_location;
end;

procedure do_a_room(xer,yer : integer);
begin
say_saying('The Rusted Door Bursts Open and Inside is ...........');
pausescr; encounter;
restore;
end;

procedure do_a_wandering;
var choicer : char;
begin
case (random(2)) of
 1 : begin do_other_wandering; display_all; end;
 0 : begin
say_saying('An Encounter! Hit ''A'' to begin the Attack!: ');
 onek(choicer,'A'); encounter; pausescr;
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
end; end;

procedure check_for_wandering;
begin
if random(75)=25 then do_a_wandering;
if random(12)=1 then do_an_increase;
end;

procedure offer_entrance;
var choice : char;
begin
say_saying('Do you Wish to Enter the Bank? (Y/N) ');
onek(choice,'YN');
if choice = 'Y' then begin
enter_bank; main_grid; display_all; show_location; end else
say_saying('Continue playing....');
end;

procedure offer_armor_entrance;
var choice : char;
begin
say_saying('Do you Wish to Enter the General Store? (Y/N) ');
onek(choice,'YN');
if choice = 'Y' then begin
do_general_store; main_grid; display_all; show_location; end else
say_saying('Continue Playing.....');
end;

procedure enchant_weapon;
var choice,schoice : char; wcost:integer;
begin
wcost := 500 * player.dungeon_level;
if player.goldpieces < wcost then say_saying('Not Enough Gold!') else
begin
say_saying('A = Armor  S = Shield  W = Weapon  M = Missile Weapon (ASWM): ');
onek(choice,'ASWM');
say_saying('This will cost '+cstr(wcost)+' Gold Pieces. OK? (Y/N): ');
onek(schoice,'YN');
if schoice ='Y' then begin
player.goldpieces:=player.goldpieces-wcost;
say_saying('You now have '+cstrr(player.goldpieces,10)+' Gold Pieces');
with player do begin
case choice of
'A' :  begin equiparmor.magical:=equiparmor.magical+1; determine_armorclass; display_AC; end;
'S' :  begin equipshield.magical:=equipshield.magical+1; determine_armorclass; display_AC; end;
'W' :  equipweapon.magical:=equipweapon.magical+1;
'M' :  equipmis.magical:=equipmis.magical+1;
end;
end;
end;
save_char;
end;
moves:=moves-2; check_moves; display_mvs;
end;

procedure offer_map;
var choice :char; xcost:integer;
begin
xcost:=player.level * 100;
if player.goldpieces < xcost then say_saying('You Cannot Afford to See the Map!')
else begin say_saying('For '+cstr(xcost)+' Gold Pieces I Will show a map of this level! (Y/N)');
onek(choice,'YN');
if choice='Y' then begin
player.goldpieces:=player.goldpieces-xcost;
display_map;
end; end;
end;

procedure increase_stat;
var choice,schoice : char;
xcost,x,r : integer;
begin
xcost := 1500 * player.dungeon_level;
if player.goldpieces < xcost then say_saying('You cannot afford this!') else begin
cls;
for x := 1 to 8 do
 talknl(4,cstr(x)+'.   '+stat_name[x]+' : '+cstr(player.stats[x]));
talknl(5,'9.  Hit Points (Max) '+cstr(player.maxhitpoints));
talknl(5,'For '+cstr(xcost)+' Gold Pieces I will raise one of your stats by 1 or ');
talknl(5,'increase your Hit / Spell Points up 10 hit points!  Is this okay (Y/N)');
onek(choice,'YN');
if choice = 'Y' then begin
nl; talk(5,'Which one? (1 - 9, 0 = None)');
onek(schoice,'0123456789');
r :=random(10)+1;
 case ord(schoice)-48 of
 1..7 : player.stats[ord(schoice)-48]:=player.stats[ord(schoice)-48]+1;
 8  : player.stats[8]:=player.stats[8]+r;
 9  : player.maxhitpoints:=player.maxhitpoints+r;
 0  : ;
 end;
if schoice <> '0' then begin player.goldpieces:=player.goldpieces-xcost;
save_char;  end;
main_grid; display_all; show_location; end;
end;
end;

procedure do_a_statue;
var choice : char;
begin
clear_space;
say_saying('Do you Wish to Talk to the Living Statue? (Y/N) ');
onek(choice,'YN');
if choice = 'Y' then begin
say_saying('Hello brave '+player.name+' I can do the following things for you:  ');
say_saying('1. Enchant Item by +1, 2. Give map,  3. Increase stats  0. None (1230)?');
onek(choice,'1230');
case choice of
'1' : enchant_weapon;
'2' : offer_map;
'3' : increase_stat;
end;
moves:=moves-2; check_moves; display_mvs;
end;
end;

procedure do_a_sign(modx,mody : integer);
var x: integer;
begin
for x:=1 to 38 do
if player.xmap = sign[x].xmapper then
if player.ymap = sign[x].ymapper then
if player.xactual+modx = sign[x].xpos then
if player.yactual+mody = sign[x].ypos then
say_saying(sign[x].saying);
end;

procedure do_a_stairs(xx,yy : integer);
var extra_temp : stairs;
stair_file: file of stairs;
done : boolean; temx : char;
begin
assign(stair_file,'STAIRS.DAT');
reset(stair_file);
say_saying('Do You Wish to go Up to the next Level? (Y/N)');
onek(temx,'YN');
if temx='Y' then
while not EOF(stair_file) do begin
read(stair_file,extra_temp);
if player.dungeon_level = extra_temp.fromlevel then
if player.xactual+xx = extra_temp.fromxloc then
if player.xmap = extra_temp.fromxmap then
if player.ymap = extra_temp.fromymap then
if player.yactual+yy = extra_temp.fromyloc then begin
player.dungeon_level:=extra_temp.tolevel;
player.xmap:=extra_temp.toxmap;
player.ymap:=extra_temp.toymap;
player.xactual:=extra_temp.toxloc;
player.yactual:=extra_temp.toyloc;
if player.dungeon_level > 0 then begin display_all; get_screen; load_signs; show_location;
end else exitter := true; end;
end; close(stair_file);
end;


procedure go_down1;
begin
case player.dungeon_level of
3: begin player.dungeon_level:=4; player.xmap:=1; player.ymap:=1;
         player.xactual:=9; player.yactual:=10; end;
2: begin player.dungeon_level:=3; player.xmap:=3; player.ymap:=6; player.xactual:=35;
         player.yactual:=12; end;
1: begin player.dungeon_level:=2; player.xmap:=1; player.ymap:=1; player.xactual:=50;
   player.yactual:=15; end;
end;
display_all; get_screen; load_signs; show_location;

end;

procedure send_message(sayer : helper);
VAR g1 : file of junker;
h,stateme : junker;
filename:string[8];
begin
filename:='        ';
str(otra_char,filename); stateme.words:=sayer;
stateme.name:=player.name;
assign(g1,filename+'.MSG');
{$I-} reset(g1); {$I+}
if IOResult <> 0 then begin rewrite(g1); write(g1,stateme) end else begin
while not EOF(g1) do read(g1,h);
write(g1,stateme);
end;
close(g1);
end;

procedure save_char2;
var saver: file of character;
filename:string[8];
begin
filename:='        ';
str(usernum,filename);
filename:=filename+'.sav';
assign(saver,filename);
rewrite(saver);
write(saver,player);
close(saver);
end;

procedure offer_message(jj : byte);
var ghi : char; hint:str;
begin
say_saying('Do you wish to send a message to '+otra_player.name+' (Y/N)?');
ansic(3); onek(ghi,'YN'); if ghi = 'N' then
 case jj of
 1 : send_message('I killed you and took half your money!');
 2 : send_message('I saw you in the dungeon but did not bother you.... next time..');
 end
else begin
say_saying('Enter a Message 70 Characters long!'); goto_ansixy(22,1);
say_saying(':'); ansic(5);
input(hint,70); send_message(hint);
end;
end;

procedure charvschar(xx,yy : integer);
var a,att : boolean;    xt : integer;
temp : character; texa : real;
begin
a:=who_is_it(xx,yy); texa:=player.goldpieces;
if a then begin att:=combat(73,51,51,51,1); if att then check_for_new_level(1);
  if texa<=player.goldpieces then begin
  temp:=player; xt:=usernum; usernum:=otra_char;
  if otra_player.goldpieces > 1 then otra_player.goldpieces:= otra_player.goldpieces/2;
  player:=otra_player; save_char2; player:=temp; usernum:=xt;
  offer_message(1);
end
end else offer_message(2);
map[player.xactual+xx,player.yactual+yy]:=' '; cls; main_grid; display_all; show_location;
end;

function newmove(x1,y1 : integer) : boolean;
var test,test2:boolean;
    temp:real; a,b,c,d,e : byte;
begin
 case map[(player.xactual)+x1,(player.yactual)+y1] of
 ' ' : newmove:=true;
 'Ÿ' : begin do_a_fountain; display_all; newmove:=false; end;
'B','$' : begin offer_entrance; newmove:=false; end;
 'A' : begin offer_armor_entrance; newmove:=false; end;
 '­' : begin do_a_statue; newmove:=false; end;
 'â' : begin do_a_sign(x1,y1); newmove:=true; end;
 'D' : begin do_a_room(x1,y1); newmove:=false; end;
 'S' : begin do_a_stairs(x1,y1); newmove:=false; end;
 'C' : begin charvschar(x1,y1); newmove:=true; end;
 '°' : begin newmove:=true; moves:=moves-1; end;
 'P' : if player.exemptions[4]=1 then go_down1
        else begin test:=number_of_the_beast;
             if player.exemptions[4]=1 then go_down1
               else begin test:=COMBAT(31,31,31,31,4); if test then check_for_new_level(4);
               restore; end;
       end;
 '#' : begin do_pound; newmove:=false; end;
 'G' : begin  temp:=player.goldpieces;
        test:=GATE_KEEPER;
        if test then begin test:=COMBAT(54,55,55,51,3);
           restore;
           if player.goldpieces > temp-1 then begin
                       player.exemptions[5]:=1; check_for_new_level(3); end;
         end; if player.exemptions[5]=1 then go_down1; end;
 'N' : begin newmove:=false; temp:=player.goldpieces; test:=NONA;
             if test then begin test:=COMBAT(63,51,51,51,1);
               if test then check_for_new_level(1);
                if player.goldpieces > temp-1 then player.exemptions[6]:=1;
                 restore;
                  end;
       if player.exemptions[6]=1 then go_down1; end;
 'X' : begin test:=do_final; temp:=player.goldpieces; if do_final then begin
       test:=COMBAT(59,47,71,47,4); if test then check_for_new_level(4);
       restore; if player.goldpieces >temp-1 then player.exemptions[7]:=1;
       end; if player.exemptions[7]=1 then do_final2;
       end;

 'H' : begin sell_potion; cls; main_grid; display_all; show_location; newmove:=false; end;
 'T' : begin enter_tavern; cls; main_grid; display_all; show_location; newmove:=false; end;
 '›' : begin test:=caryatid(a,b,c,d,e); if test then
       test:=COMBAT(a,b,c,d,e); if test then begin check_for_new_level(e);
       restore; map[player.xactual+x1,player.yactual+y1]:=' '; end;
       newmove:=test; end;

else newmove:=false;
end;
moves:=moves-1; check_moves; display_mvs;
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

var choice: char;
begin
main_grid; display_all; get_screen; load_signs; show_location; exitter:=false;
repeat
goto_ansixy(11,53);
ansic(4);
onek(choice,'8462AFQUSVZ');
case choice of
 '8' :check_north;
 '4' :check_west;
 '6' :check_east;
 '2' :check_south;
 'A' :begin auto_map_view; restore; end;
 'F' : fast_mode;
 'Q' :if map[player.xactual,player.yactual]=' ' then begin moves:=0; check_moves; end else
    say_saying('You Cannot Save Here.....');
 'U' :begin use_which_potion; display_all; moves:=moves-1; end;
 'S' : begin say_saying('Character Saved'); save_char; moves:=moves-1; end;
 'V' :begin cls; view_initial_char; cls; main_grid; display_all; show_location; end;
 'Z' : begin destroy_char; check_moves; end;
end;
check_for_wandering;
until exitter;
end;

procedure do_main_area_work(choice : char);
begin
case choice of
'A'  :if created_char then begin enter_dun; main_dun; CLS; end else fool;
'B'  :if created_char then enter_bank else fool;
'C'  :create_char;
'G'  :if (player.goldpieces>1) and (created_char) then do_general_store else fool;
'Q'  :begin moves:=0; check_moves; end;
'S'  :do_opening_screen;
'T'  :if created_char then enter_tavern else fool;
'Y'  :if created_char then view_initial_char else fool;
'?'  :welcome;
end;
end;

procedure start_main;
var infinite : boolean;
begin
welcome; infinite:=false;
repeat
talk(5,'Choice (ABCGQSTY?) -->');
onek(ginput,'ABCGQSTY?');
Do_Main_Area_work(ginput);
until infinite;
end;

procedure try_to_read_char;
var g1:file of character;
    filename:string[8];
begin
filename:='        ';
str(usernum,filename);
assign(g1,filename+'.sav');
{$I-} reset(g1); {$I+}
if IOresult=0 then begin created_char:=true; read(g1,player); assign_moves; mod_move_armor; orig_stats; close(g1);
serial; show_messages; end else begin moves:=1; player.dungeon_level:=0; end;
end;

begin
init_names; read_weapons; elf_mod:=0; patience:=false;
do_opening_screen; time_expander:=false; modder:=0;
ready_to_adventur:=false; randomize; created_char:=false;
iport;
try_to_read_char; determine_armorclass;
if player.dungeon_level > 0 then main_dun;
start_main;
end.
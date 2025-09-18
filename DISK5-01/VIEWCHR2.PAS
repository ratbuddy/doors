program viewchar;

uses dos,crt;

type helper = string[70];
type uv=string[25];

type ringer = record
idnum : byte;
name  : string[20];
magical : byte;
battle : boolean;
charges: byte;
minddam: byte;
maxdam : byte;
cost   : integer;
end;
type weapons = record
idnum:byte; name:string[16]; melee:boolean;
dam:integer; numat: integer;
h2h:boolean; cost:integer; magical: integer; classrest:string[6];
end;
type potions = record idnum:byte; name:string[30]; cost:real; end;
type armors = record
idnum:byte; name:string[14]; protect:integer;
cost:integer; magical:integer; class_rest:string[6];
end;
type magic_staff = record
idnum:byte; name:string[30];
damage:integer; cost:real; spcost:integer;
success:integer;
end;
type monsters = record
idnum : byte; name : string[20]; minhp : byte; maxhp : integer;
numatt : byte; range : byte; spoints : integer;
maxdam:byte; minddam:byte; mis_mindam: byte; mis_maxdam:byte; Level : byte; Undead : boolean;
FAB : boolean; Armor_Class : byte; experience : integer; GPS:INTEGER; staff:byte;
sp_name:string[20]; elf_hater : boolean; regen:byte; end;
type monster_table = record
mon1 : byte; mon2 : byte;  mon3 : byte; mon4 : byte; amount:byte; end;
type character = record
name           : string[25];
Maxhitpoints   : integer;
Act_hitpoints  : integer;
act_spellpoints: integer;
level          : byte;
numatt         : byte;
food           : byte;
goldpieces     : real;
experience     : real;
Needed_exp     : real;
ArmorClass     : integer;
outdoor        : boolean;
city           : boolean;
dungeon        : boolean;
dungeon_level  : byte;
outxact        : byte;
outyact        : byte;
outxmap        : byte;
outymap        : byte;
xactual        : byte;
yactual        : byte;
xmap           : byte;
ymap           : byte;
spells         : boolean;
Class          : integer;
stats          : array [1..8] of byte;
equipweapon    : weapons;
equiparmor     : armors;
equipmis       : weapons;
equipmagic     : magic_staff;
equipring      : ringer;
exemptions     : array [1..51] of byte; {For Conversations -- 43-51 is pot}
door_exemps    : array [1..255] of byte; {for dungeon encounters}
memory         : string[25];
total_moves    : real;
end;

type location= record
city_num : byte;
class    : byte;
name     : string[25];
level    : byte;
end;

var player :character;
    player_file : file of character;
    filename:string[8]; filenum:integer;
    count,w,x,y : integer;
    temp : char;
    weapon : array [1..10] of weapons;
    armor  : array [1..5] of armors;
    magici : array [1..10] of magic_staff;
    potion_array : array [1..9] of potions;
    ring : array [0..18] of ringer;
    loaded:boolean;

procedure do_file_name(numb : integer);
begin
filename:='               ';
str(numb,filename);
filename:=filename+'.SAV';
assign(player_file,filename);
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
seek(ftab,filenum-1);
tlist.name:=player.name; axd:=3;
tlist.level:=player.level;
tlist.tm :=player.total_moves;
if player.door_exemps[253]=69 then tlist.win:=true else tlist.win:=false;
write(ftab,tlist);
close(ftab);
end;

procedure save_char;
var saver: file of character;
filename:string[8];
begin
filename:='        ';
str(filenum,filename);
filename:=filename+'.sav';
assign(saver,filename);
rewrite(saver);
write(saver,player);
close(saver);
end;

procedure choices;
begin
writeln;
writeln('1. See Listing of Characters');
writeln('2. Get a Character by Name');
writeln('3. Get a Character by Number');
writeln('4. Mod Character (Must be Loaded!)');
writeln('5. Destroy a Character (Must Be Loaded!)');
writeln('6. Save Character (Must be Loaded!)');
writeln('7. Quit or (Ctrl C)');
end;

procedure mod_char;
var yyy: integer;
procedure number1;
begin
writeln('a. Player Name : ',player.name); writeln;
writeln('b. Strength    : ',player.stats[1]);
writeln('c. Intelligence: ',player.stats[2]);
writeln('d. Wisdom      : ',player.stats[3]);
writeln('e. Coordination: ',player.stats[4]);
writeln('f. Health      : ',player.stats[5]);
writeln('g. Luck        : ',player.stats[6]);
writeln('h. Personality : ',player.stats[7]);
writeln('i. Max Spellpts: ',player.stats[8]);
writeln('j. Max Hps     : ',player.maxhitpoints);
writeln('k. Current Hps : ',player.act_hitpoints);
writeln('l. Gold        : ',player.goldpieces:0:0);
writeln('m. Food        : ',player.food);
writeln; writeln; writeln('Press ''n'' for Next Page or ''z'' to quit!');
end;

procedure number2;
begin
writeln;
writeln('o. Weapon Name   :',player.equipweapon.name);
writeln('q. Armor Name    :',player.equiparmor.name);
writeln('r. Missile Name  :',player.equipmis.name);
writeln('s. Magic Staff   :',player.equipmagic.name);
writeln('u. Healing Potion:',player.exemptions[43]);
writeln('v. Magic Rest Pot:',player.exemptions[44]);
writeln('w. Strength Potn :',player.exemptions[45]);
writeln('x. Intell Potion :',player.exemptions[46]);
writeln('y. Coord Potion  :',player.exemptions[47]);
writeln('!. Luck Potion   :',player.exemptions[48]);
writeln('@. Time Distor.Pt:',player.exemptions[49]);
writeln('#. Speed         :',player.exemptions[50]);
writeln('$. X-ray Vision  :',player.exemptions[51]);
writeln('%. Ring Name     :',player.equipring.name);
writeln; writeln('Press ''Z'' to Quit or ''P'' to view prev. screen!');
end;

procedure name_change;
var shit:string[25];
begin
shit:='                         ';
shit:=player.name;
player.name:='                           ';
writeln('Enter Player''s New Name: (Enter ''NO CHANGE'' if you made a mistake');
write('  :');
readln(player.name);
if player.name='NO CHANGE' then player.name:=shit;
end;

procedure maxhps_change;
var change: integer;
begin
writeln('Enter Player''s New Max Hps (no more than 600 please!): ');
readln(change);
if (change < 600) and (change> 0)  then player.maxhitpoints:=change else
  writeln('Invalid Input!');
end;

procedure current_hps_change;
var xxx : integer;
begin
writeln('Current Maximum Hitpoints Is : ',player.maxhitpoints);
writeln('Input New Current Hitpoints (cannot be higher than above)');
write('-->'); readln(xxx);
if (xxx <0) or (xxx > player.maxhitpoints) then writeln('Invalid Input')
  else player.act_hitpoints:=xxx;
end;

procedure gold_change;
var xxx : real;
begin
writeln('Current Player Has ',player.goldpieces:0:0,' Gold Pieces');
write('Enter New Amount -->'); readln(xxx);
if (xxx < 0) or (xxx > 200000.0) then writeln('Invalid Input') else
  player.goldpieces:=xxx;
end;

procedure gnu_weapon;
var shitstain: byte;
begin
clrscr;
for shitstain:=1 to 24 do
 if weapon[shitstain].melee then writeln(shitstain,'. ',weapon[shitstain].name);
writeln;
writeln('The Player Currently uses a ',player.equipweapon.name);
writeln('Magical Bonus is:  ',player.equipweapon.magical);
write('Enter New Weapon Number --> (0 for None) ');
readln(shitstain);
if shitstain > 0 then
   if shitstain < 24 then
     if weapon[shitstain].melee then begin
        player.equipweapon:=weapon[shitstain];
        write('Now Enter Magical Bonus (0 for None) --> ');
         readln(shitstain);
           if (shitstain > -1) and (shitstain < 6) then
              player.equipweapon.magical:=shitstain
           else writeln('Invalid Input -- Magical Bonus Set at 0');
      end else writeln('Invalid Input -- No Weapon Set');
end;

procedure gnu_staff;
var shitstain: byte;
begin
clrscr;
for shitstain:=1 to 10 do
writeln(shitstain,'. ',magici[shitstain].name);
writeln;
writeln('The Player Currently uses a ',player.equipmagic.name);
write('Enter Number of New Staff (0 for None)');
readln(shitstain);
if shitstain > 0 then
   if shitstain < 11 then
     player.equipmagic:=magici[shitstain]
      else writeln('Invalid Input -- No Weapon Set');
end;

procedure gnu_armor;
var shitstain: byte;
begin
clrscr;
for shitstain:=1 to 11 do
 writeln(shitstain,'. ',armor[shitstain].name);
writeln;
writeln('The Player Currently uses a ',player.equiparmor.name);
writeln('Magical Bonus is:  ',player.equiparmor.magical);
write('Enter New Armor Number --> (0 for None) ');
readln(shitstain);
if (shitstain > 0) and (shitstain < 12) then begin
        player.equiparmor:=armor[shitstain];
          write('Now Enter Magical Bonus (0 for None) --> ');
          readln(shitstain);
          if (shitstain > -1) and (shitstain < 6) then
          player.equiparmor.magical:=shitstain
           else writeln('Invalid Input -- Magical Bonus Set at 0');
 end else writeln('Invalid Input -- No Armor Set');
end;

procedure pot(loct : byte; name: string);
var t :byte;
begin
writeln('Player Currently Has ',player.exemptions[loct],' ', name);
write('Enter New Amount (255 max) --> ');
readln(t);
if (t<0) or (t>255) then
  if loct < 9 then writeln('Invalid Input!') else player.exemptions[loct]:=t
   else player.exemptions[42]:=t;
end;
procedure change_stat(what_str : string; loct : byte);
var shit : byte;
begin
writeln('The Character''s ',what_str,' is : ',player.stats[loct]);
write('Enter New Value --> ');
readln(shit);
if (shit>0) and (shit<255) then player.stats[loct]:=shit else writeln('INVALID INPUT');
end;

procedure gnu_ring;
var xer: integer;
begin
clrscr;
for xer:=0 to 18 do
writeln(xer,' ', ring[xer].name,'    charges: ',ring[xer].charges,' magic bonus : ',ring[xer].magical);
writeln;
write('Enter Number you wish the user to have, or 20 to not change it:  ');
readln(xer);
if (xer>-1) and (xer<19) then
  player.equipring:=ring[xer] else writeln('No Change');
end;


procedure food;
var shit : integer;
begin
writeln('The Character''s has ',player.food,' Food ');
writeln('Enter New Value --> ');
readln(shit);
if (shit>0) and (shit<100) then player.food:=shit else writeln('INVALID INPUT');
end;

begin
yyy:=1; clrscr;
repeat
if yyy=1 then number1 else number2;
write('Choice: ');
temp:=readkey;
case temp of
  'p','P','n','N' : if yyy=1 then yyy:=2 else yyy:=1;
  'a','A' : name_change;
  'b','B' : change_stat('STRENGTH',1);
  'c','C' : change_stat('INTELLIGENCE',2);
  'd','D' : change_stat('WISDOM',3);
  'e','E' : change_stat('COORDINATION',4);
  'f','F' : change_stat('HEALTH',5);
  'g','G' : change_stat('LUCK',6);
  'h','H' : change_stat('PERSONALITY',7);
  'i','I' : change_stat('MAX. SPELL PTS',8);
  'j','J' : maxhps_change;
  'k','K' : current_hps_change;
  'l','L' : Gold_Change;
  'm','M' : food;
  'o','O' : gnu_weapon;
  'q','Q' : gnu_armor;
  's','S' : gnu_staff;
  'u','U' : pot(43,'Potion of Healing');
  'v','V' : pot(44,'Pot. of Spell Rest');
  'w','W' : pot(45,'Pot. of Strength');
  'x','X' : pot(46,'Pot. of Intelligence');
  'y','Y' : pot(47,'Pot. of Coordination');
  '!' : pot(48,'Potion of Luck');
  '@' : pot(49,'Time Distorters');
  '#' : pot(50,'Liquid Gold');
  '$' : pot(42,'X-ray Vision');
  '%' : gnu_ring;
end;
until (temp='z') or (temp='Z');
end;



procedure get_number;
begin
writeln;
write('Enter User''s Number (0 for None) -->');
readln(count);
if (count > 750) or (count<1) then writeln('Invalid Input!') else begin
     do_file_name(count);
   {$I-}  reset(player_file); {$I+}
     if IOResult <> 0 then writeln('No such Character!') else begin
     read(player_file,player);
     if player.level > 0 then begin filenum:=count; writeln('Character Loaded'); loaded:=true; end
      else begin writeln('No such Character! -- Try Again!'); loaded:=false; end;
     close(player_file);
end;

end;
end;


procedure get_name;
var shitfuck : string[25];    found:boolean; ch:char; xt,nnn:integer;
begin
shitfuck:='                           '; count:=0;
found:=false;
writeln;
writeln('Enter The Person''s Name In CAPS, Spelling Must be Perfect');
readln(shitfuck);
writeln('Roughly, what''s the highest User Number which is currently playing?');
write('(750 is max)  ---->');
readln(nnn);
write('Working.');
for xt:=1 to nnn do begin
  if xt mod 20 =0 then write('.');
  do_file_name(xt);
  {$I-} reset(player_file); {$I+}
  if IOResult = 0 then begin
  read(player_file,player);
   if player.name=shitfuck then begin filenum:=xt;
     writeln; textcolor(YELLOW); writeln('Found It -- Character Loaded!');
textcolor(WHITE);  xt:=nnn; found:=true; loaded:=true; end;
  close(player_file);
end;
end;
if not found then begin writeln; writeln('Unable to Find User! -- Press any key to Continue'); ch:=readkey; end;
end;

procedure view_list;
var scount,xt,extra_count,nnn: integer;
  ch: char;
begin
writeln;
writeln('Roughly, what''s the highest User Number which is currently playing?');
write('---->');
readln(nnn);
writeln('Working......');
count:=0;
for xt:=1 to nnn do begin
   do_file_name(xt);
  {$I-} reset(player_file); {$I+}
   if IORESULT =0 then begin
     read(player_file,player);
     if player.level > 0 then
     writeln('Name: ',player.name,' ---   Number: ',xt);
     close(player_file);
   end;
end;
writeln('All Done -- Hit Any Key to Continue!');
ch:=readkey;
end;

procedure read_weapons;
var g1:file of weapons; g5: file of potions;
g2:file of armors;   g7 : file of ringer;
g3:file of magic_staff;
nerd:integer;
begin
assign(g1,'weapons.dat'); reset(G1);
for nerd:=1 to 10 do
read(g1,weapon[nerd]);
close(g1);
assign(g2,'armor.dat'); reset(g2);
for nerd:=1 to 5 do
read(g2,armor[nerd]);
close(g2);
assign(g3,'magic.dat'); reset(g3);
for nerd:=1 to 10 do
read(g3,magici[nerd]);
close(g3);
assign(g7,'rings.dat'); reset(g7);
for nerd:=0  to 18 do
read(g7,ring[nerd]);
close(g7);
assign(g5,'POTIONS.DAT'); reset(g5);
for nerd:=1 to 8 do read(g5,potion_array[nerd]); close(g5);
end;

procedure destroy_char;
var shit :char;
    filename:string[11];
begin
  filename:='              ';
  writeln('Do You REALLY Wish to Destroy ',player.name,' who is Usernum ',filenum);
  write('(Y/N) -->'); read(shit);
  if (shit='Y') or (shit='y') then begin
     do_file_name(filenum);
     erase(player_file);
     str(filenum,filename);  {Don'T forget about TABle AND LOCXY!}
     filename:=filename+'.MSG'; assign(player_file,filename);
     loaded:=false;
     player.name:='                               ';
player.dungeon_level:=0;
player.xmap:=0;
player.ymap:=0;
player.xactual:=0;
player.yactual:=0;
player.class:=0;
player.level:=0;
writeln('REMOVED FROM THE GAME!');
  table_char;
  end;
end;

begin
clrscr; loaded:=false;
read_weapons;
repeat
writeln;
textcolor(RED);
writeln('         Welcome To Pit Fiend''s Onliner Volume ][ Character Editor!');
writeln('          Copyright 1990 by Pit Fiend -- ALL RIGHTS RESERVED!');
textcolor(YELLOW);
writeln('     Carelessly Modifying Characters may result in DRASTIC changes in ');
writeln('      a character''s powers.  This may SEVERELY ruin a good game in progress.');
textcolor(MAGENTA);
  choices;
  writeln;
  write('Enter Choice: -->'); textcolor(WHITE);
  temp:=readkey;
  case temp of
    '1' : view_list;
    '2' : get_name;
    '3' : get_number;
    '4' : if loaded then mod_char else write('Character NOT loaded!');
    '5' : if loaded then destroy_char else write('Character Not Loaded!');
    '6' : if loaded then save_char else write('Character Not Loaded!');
  end;
until temp='7';
end.




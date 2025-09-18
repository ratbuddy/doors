overlay function combat(a2,b2,c2,d2,number : byte) : boolean;
const STANDARD = 9;
PLAYER_STAND = 9;
type tiny_helper = string[80];
var
mon_mismel : array [1..4] of boolean;
mon_dead   : array [1..4] of boolean;
hps        : array [1..4] of integer;
turned,finished,mismelvar : boolean;  {true :=missile}
counter : integer;
cround : byte;

procedure display_screen;
var filer : file of char;
temp : char;
begin
assign(filer,'combatsr.ans');
reset(filer); cls;
while not EOF(filer) do begin
read(filer,temp);
prompt(temp);
end;
close(filer);
end;

procedure display_char_hp;
begin
goto_ansixy(5,12);
ansic(4); prompt(cstr(player.act_hitpoints)+'  ');
goto_ansixy(dialcnt,1);
end;

procedure display_char_cac;
begin
goto_ansixy(6,12); ansic(4); prompt(cstr(player.armorclass));
end;

procedure display_cMPS;
begin
goto_ansixy(7,12);
ansic(4); prompt(cstr(player.act_spellpoints)+'  ');
goto_ansixy(dialcnt,1);
end;

procedure display_mon_name(x,y,cnt : Integer);
begin
if meanies[cnt].maxhp < 1 then begin goto_ansixy(x,y); ansic(4); prompt('DEAD            '); end
 else begin goto_ansixy(x,y); ansic(4); prompt(meanies[cnt].name); end;
end;

procedure display_mon_hp(x,y,cnt : Integer);
begin
goto_ansixy(x,y); ansic(4); prompt(cstr(meanies[cnt].maxhp)+'   ');
end;

procedure display_mon_AC(x,y,cnt : integer);
begin
goto_ansixy(x,y); ansic(4); prompt(cstr(meanies[cnt].armor_class));
end;

procedure display_mon_MPS(x,y,cnt : integer);
begin
goto_ansixy(x,y); ansic(4); prompt(cstr(meanies[cnt].spoints)+'   ');
end;

procedure display_mon_mismel(x,y,cnt: Integer);
begin
goto_ansixy(x,y); prompt(' '); goto_ansixy(x+1,y); prompt(' ');
if mon_mismel[cnt] then goto_ansixy(x,y) else goto_ansixy(x+1,y);
ansic(4); prompt('*'); goto_ansixy(dialcnt,1);
end;

procedure display_monsters(count : integer);
var puty,putx : integer;
begin
case count of
   1   : begin puty:=4; putx :=43; end;
   2   : begin puty:=4; putx := 65; end;
   3   : begin puty:=12; putx:=43; end;
   4   : begin puty:=12; putx:=65; end;
end;
display_mon_name(puty,putx,count);
display_mon_hp(puty+1,putx,count);
display_mon_AC(puty+2,putx,count);
display_mon_MPS(puty+3,putx,count);
display_mon_mismel(puty+4,putx,count);
end;

procedure display_char;
begin
display_char_hp;
display_char_cac;
display_cMPS;
end;

procedure assign_monster;
var x:integer;
begin
for x:=1 to 4 do meanies[x]:=monster_array[51];
meanies[1]:=monster_array[a2];
meanies[2]:=monster_array[b2];
meanies[3]:=monster_array[c2];
meanies[4]:=monster_array[d2];
if number > 1 then
meanies[2].maxhp:=random(meanies[2].maxhp-meanies[2].minhp)+meanies[2].minhp;
if number > 2 then meanies[3].maxhp:=random(meanies[3].maxhp-meanies[3].minhp)+meanies[3].minhp;
if number > 3 then meanies[4].maxhp:=random(meanies[4].maxhp-meanies[4].minhp)+meanies[4].minhp;
for x:=1 to number do hps[x]:=meanies[x].maxhp;
end;

function initiative(modr : integer) : integer;
begin
initiative:=random(10)+modr;
end;

function determine_hit(modr : integer) : integer;
begin
determine_hit:=random(20)+modr;
end;

procedure do_damage(target : integer; typer : char);
var xx, temp,damag : integer;
   wname:string[20];
begin
damag:=0;
if typer = 'F' then begin
   wname:=player.equipmis.name;
for xx:=1 to player.equipmis.magical+1 do
  damag:=random(player.equipmis.dam)+damag; end
 else begin
   wname:=player.equipweapon.name;
   temp := modifier(player.stats[1]);
for xx:=1 to player.equipweapon.magical+1 do
   damag:=random(player.equipweapon.dam)+temp+damag;
  end;
if damag < 1 then damag:=1;
if (player.class=4) and (random(120) < player.level*10) then
begin say_saying('You Did DOUBLE damage!'); damag:=damag*2; end;
say_Saying('Your '+wname+' Hits #'+cstr(target)+' '+meanies[target].name+' For '+cstr(damag)+' Points of Damage!');
meanies[target].maxhp:=meanies[target].maxhp-damag;
display_monsters(target); goto_ansixy(dialcnt,1);
if meanies[target].maxhp < 1 then mon_dead[target]:=true;
end;

function determine_base : integer;
begin
case player.class of
1,5: determine_base:=7;
2  : determine_base:=10;
3,4,6 : determine_base:=8;
end;
end;

procedure do_missile(which : integer);
 var countz,temp,x,baser : integer;
begin
if player.equipmis.idnum[1] <> 'N'  then begin
  temp:=modifier(player.stats[4]);
  for countz:= 1 to player.equipmis.numat+player.numatt-1 do begin
x := determine_hit(temp+(player.level div 2) - meanies[which].armor_class+player.equipmis.magical);
  baser := determine_base;
  if x > baser-1 then do_damage(which,'F') else
   say_saying('Attack #'+cstr(countz)+' Missed! #'+cstr(which)+' '+meanies[which].name);
  end
end  else say_saying('You Do Not Have A Missile Weapon!');
end;

procedure do_melee(which : integer);
 var countz,temp,x,baser : integer;
begin
if player.equipweapon.idnum[1] <> 'N' then begin
temp:=modifier(player.stats[1]);
for countz:= 1 to player.equipweapon.numat+player.numatt-1 do begin
x := determine_hit(temp+(player.level div 2)-meanies[which].armor_class+player.equipweapon.magical);
baser := determine_base;
if x > baser-1 then do_damage(which,'M') else
say_saying('Attack #'+cstr(countz)+' Missed! #'+cstr(which)+' '+meanies[which].name);
end
end  else say_saying('You Do Not Have A Weapon!');
end;

procedure attack_monster(lett : char);
var whichone : integer;
begin
whichone:=ord(lett)-48;
if mon_mismel[whichone] then do_missile(whichone) else do_melee(whichone);
if meanies[whichone].maxhp < 1 then begin mon_dead[whichone]:=true;
  say_saying('You have Slain  #'+cstr(whichone)+' '+meanies[whichone].name+'!'); end;
end;

procedure move_char;
var modm,modr,x,temp : integer;
    choice : char;
begin
temp:=0; modr:=0;
if player.class = 4 then modr:=20;
say_saying('Do you wish to have all Monsters in: 1. Missile or 2 Melee? ');
ansic(4); onek(choice,'12');
if choice = '1' then
 for x := 1 to number do begin
 modm :=0;
if meanies[x].FAB then modm:=20;
if mon_dead[x]= false then
 if mon_mismel[x] = false then
 if random(100)+player.stats[4]+player.level*2+modr - meanies[x].level*2 - modm > 50
  then begin mon_mismel[x]:=true; display_monsters(x);
  say_saying(meanies[x].name+' #'+cstr(x)+' is now in Missile Range!');
  end else say_saying(meanies[x].name+' #'+cstr(x)+' Evades You!');
 end;
if choice = '2' then
 for x := 1 to number do begin
  modm :=0;
if meanies[x].FAB then modm:=20;
if mon_dead[x]= false then
if mon_mismel[x] then
if random(100)+player.stats[4]+player.level*2+modr - meanies[x].level*2 - modm > 50
then begin mon_mismel[x]:=false; display_monsters(x);
say_saying(meanies[x].name+' #'+cstr(x)+' is now in Melee Combat!');
end else say_saying(meanies[x].name+' #'+cstr(x)+' Evades You!');
end;
end;

function retreat_char : boolean;
var choice : char; percentage : integer; tt : byte;
begin
retreat_char:=false;
percentage:=10-modifier(player.stats[4])-player.level;
for tt:=1 to number do
 percentage:=percentage+meanies[tt].level;
if percentage<10 then percentage:=10;
if percentage>100 then percentage:=100;
say_saying('You Realize You Will Loose '+cstr(percentage)+'% of your Gold if you Retreat, OK? (Y/N)');
onek(choice,'YN');
if choice='Y' then begin
 player.goldpieces:=player.goldpieces*((100-percentage)/100);
 finished:=true; combat:=false; retreat_char:=true;
 end;
end;

procedure turn_undead;
var y,x,success : integer;
begin
y:=0; for x:=1 to number do
if meanies[x].undead then y:=y+1;
if y < 1 then say_saying('None of these Beasts Are Undead!  Turn Wasted!' )
else if turned then say_saying('You have already tried to turn Undead!')
else for success:=1 to number do
if (mon_dead[success] = false) and (meanies[success].undead) then
if random(20)+modifier(player.stats[3])+player.level-2*meanies[success].level> 10 then
begin
say_saying('You Turn #'+cstr(success)+' '+meanies[success].name+'!');
meanies[success].maxhp:=-1;
mon_dead[success]:=true;
display_monsters(success);
end
else say_saying('You Were NOT Successful in Turning '+meanies[success].name+' #'+cstr(success));
turned:=true;
end;

procedure save_for_monster(var dama,cat : integer);
begin
if random(100)+meanies[cat].level*7 > 75 then
 begin say_saying(meanies[cat].name+' made his saving throw!');
 dama:=dama div 2; end else say_saying(meanies[cat].name+' missed his saving throw!');
end;

procedure do_char_staff;
var dc,x,y,damag : integer;
begin
with player do begin
if class=6 then begin elf_mod:=elf_mod+1; dc:=-1 end else dc:=-3;
if (level*dc)+random(100)-(stats[2]*3)<equipmagic.success-1 then
 begin
 say_saying('Your '+equipmagic.name+' was Used Successfully!');
 act_spellpoints:=act_spellpoints-equipmagic.spcost;
 for x:=1 to number do begin
 damag:=0;
 if mon_dead[x] = false then begin
 for y:=1 to equipmagic.damage do
 damag:=damag+random(10)+1;
 save_for_monster(damag,x);
 meanies[x].maxhp:=meanies[x].maxhp-damag;
 if meanies[x].maxhp<1 then mon_dead[x]:=true;
 display_monsters(x);
say_saying('Your '+equipmagic.name+' hit '+meanies[x].name+' #'+cstr(x)+' for '+cstr(damag)+' Pts of Damage');
  end
  end
 end
 else begin
 say_saying('You Failed to Use your '+equipmagic.name);
 act_spellpoints:=act_spellpoints-equipmagic.spcost;
 end;
display_char;
end;
end;

procedure check_monster_deaths;
var t1,t2,total : integer;
begin
total:=0;
for t1 := 1 to number do
    if meanies[t1].maxhp < 1 then total:=total+1;
if total = number then begin
 say_saying('You have defeated the Monsters!');
 finished:=true;
 combat:=true;
end;
end;

procedure player_attack;
var choice : char;
 okay : boolean;
 counts : byte;
begin
repeat
 okay:=true;
 say_saying('Choice: (1234,MPRSTU) :'); ansic(4);
 onek(choice,'1234MPRSTUZ');
 case choice of
'1','2','3','4' : if (ord(choice)-48 > number) or (mon_dead[ord(choice)-48])
  then okay:=false else attack_monster(choice);
 'M' : move_char;
 'R' : okay:=retreat_char;
 'T' : if player.class <> 3 then begin okay:=false; say_saying('You are Not a Priest!');
       end else turn_undead;
 'S' : if (player.class <> 2) and (player.class <> 6) then
       begin okay:=false; say_saying('You are Not a Magic User!'); end
       else if player.equipmagic.idnum[1]='N' then begin say_saying('You Don''t Have a Magic Staff!');
       okay:=false; end else
      if player.act_spellpoints < player.equipmagic.spcost-1 then begin
      say_saying('You Don''t Have Enough Spell Points!'); okay:=false;
      end else if elf_mod=player.level*3 then begin say_saying('Elf can''t cast that many spells!'); okay:=false end
      else do_char_staff;
 'P' : say_saying('You Pass this round!');
 'U' : begin use_which_potion; display_char; end;
 'Z' : return;
end;
 if okay then check_monster_deaths;
until (okay);
end;

procedure close_mon_melee(loct: integer);
var modr: integer;
begin
modr :=0;
if meanies[loct].FAB then modr:=20;
if meanies[loct].level*5+modr+random(100) > (45+player.stats[4]) then begin
say_saying('The '+meanies[loct].name+' #'+cstr(loct)+' Closes to do Melee!');
mon_mismel[loct]:=false;
display_monsters(loct); goto_ansixy(dialcnt,1);
end else say_saying('The '+meanies[loct].name+' #'+cstr(loct)+' Fails to Close to do Melee!');
end;

procedure mon_missile(loct:integer);
var damag,tt,modr,x,hitter : integer;
begin
with meanies[loct] do begin
if FAB then modr:=3 else modr:=0;  tt:=0;
if (elf_hater) and (player.class=6) then modr:=modr+2;
for x := 1 to numatt do begin
hitter:=determine_hit(modr+meanies[loct].level-player.armorclass);
if hitter > STANDARD-1 then begin
repeat tt:=tt+1;
if mon_mismel[loct] then damag:=random(mis_maxdam-mis_mindam)+mis_mindam
 else damag:=random(maxdam-minddam)+minddam;
  if tt = 150 then return;
  until (damag < 300) and (damag > -1);
say_saying('The '+name+' #'+cstr(loct)+' Hits for '+cstr(damag)+' Points of Damage on Attack #'+cstr(x));
player.act_hitpoints:=player.act_hitpoints-damag;
check_player_death;
display_char_hp;
end else
say_saying('The '+name+' #'+cstr(loct)+' Missed with Attack #'+cstr(x));
end;
end;
end;

procedure do_player_saving_throw(var dama : integer);
begin
if random(100)+player.level*6+player.stats[6] > 90 then
begin say_saying('You made your saving throw, half damage!');
dama:=dama div 2; end else say_saying('You missed your saving throw <full damage!>');
end;

procedure mon_magic(loct: integer);
var temp: magic_staff; x,sum:integer;
begin
with meanies[loct] do begin
temp:=magici[meanies[loct].staff]; sum:=0;
if random(110) > temp.success+(3*meanies[loct].level)
then begin say_saying(Name+' Fails to cast'+sp_name+' Sucessfully!');
 spoints:=spoints-temp.spcost; display_monsters(loct);
 end else begin
 for x:=1 to temp.damage do
 sum:=random(8)+1+sum;
 do_player_saving_throw(SUM);
 player.act_hitpoints:=player.act_hitpoints-sum;
 spoints:=spoints-temp.spcost;
say_saying('The '+meanies[loct].name+' casts '+sp_name+' for '+cstr(sum)+' Points of Damage');
display_char_hp;
check_player_death;
end;
end;
end;

procedure mon_mis_opt(loca : integer);
begin
if meanies[loca].spoints < magici[meanies[loca].staff].spcost then
if meanies[loca].range < (random(100)+1) then close_mon_melee(loca)
else mon_missile(loca)
else mon_magic(loca);
end;

procedure melee_opt(loca : integer);
begin
if meanies[loca].spoints < magici[meanies[loca].staff].spcost then
    mon_missile(loca) else mon_magic(loca);
end;

procedure monster_attack;
var x : integer;
begin
for x:= 1 to number do
if mon_dead[x] = false then
 if mon_mismel[x] then mon_mis_opt(x) else melee_opt(x);
end;

procedure regenate;
var gg : integer;
begin
 for gg:=1 to number do
  if ( meanies[gg].regen>0) then
  begin
    meanies[gg].maxhp:=meanies[gg].maxhp+meanies[gg].regen;
   if meanies[gg].maxhp>hps[gg] then meanies[gg].maxhp:=hps[gg];
   say_saying(meanies[gg].name+'# '+cstr(gg)+' Regenerates '+cstr(meanies[gg].regen)+' Hit Points!');
   if (mon_dead[gg]) and (meanies[gg].maxhp>0) then begin
     mon_dead[gg]:=false;
     say_saying(meanies[gg].name+'# '+cstr(gg)+' Comes back to Life!');
   end;
end;
   display_monsters(gg);
end;

procedure do_combat;
var temp,playeri,mons : integer;
begin
if (cround mod 3) = 0 then regenate;
say_saying('Round Number '+cstr(cround)+' of Combat!'); moves:=moves-1;
temp:=modifier(player.stats[4]);
if player.class=4 then playeri:=initiative(7+player.level+temp) else
   playeri:=initiative(player.level+temp);
if meanies[1].FAB then mons:=initiative(7+meanies[1].level) else
   mons:=initiative(meanies[1].level);
if playeri > mons then begin
  player_attack;
  monster_attack;
  end else begin
  monster_attack;
  player_attack;
end;
end;

begin
mismelvar:=true; for counter:=1 to number do mon_mismel[counter]:=true;
for counter:=1 to number do mon_dead[counter]:=false; cround:=1;
turned:=false; dialcnt:=18; goto_ansixy(18,1);
assign_monster; finished:=false;
display_screen;
display_char;
for counter:=1 to number do display_monsters(counter);
repeat
do_combat; cround:=cround+1;
until finished;
end;

overlay function number_of_the_beast : boolean;
 type helpette = string[80];
var inputter : array [1..3] of char;
    testor2  : byte;
procedure get_answer;
  var x: integer;
  begin
  ANSIC(4);
  for x:=1 to 3 do begin goto_ansixy(dialcnt,50+x);
    onek(inputter[x],'1234567890');
  end;
end;

function check_answer : byte;
   var sum,x : byte;
       shitzoid : array [1..3] of byte;
   begin
   sum:=0;
   for x:=1 to 3 do
    if inputter[x]='0' then sum:=sum+1;
   if sum = 3 then check_answer:=1 else {Didn't know the answer}
   begin
     sum:=0;
     for x:=1 to 3 do
        shitzoid[x] := ord(inputter[x])-48;
     for x:=1 to 3 do
        if shitzoid[x] = player.exemptions[x] then sum:=sum+1;
     if sum=3 then check_answer:=2 else check_answer:=3;
   end;
end;

procedure avoided_problems;
begin
say_saying('"Hmm, read the signs fool!", the Pit Fiend says as he vanishes!');
say_saying('Continue playing....');
end;

procedure right_answer;
begin
say_saying('"ARGHH!!!", the Pit Fiend Howls with a bestial scream!');
say_saying('The Pit Fiend vanishes in a cloud of smoke and a set of stairs ');
say_saying('going downward appears!  Congratulations!');
player.exemptions[4]:=1; {can go to the second level!}
end;

procedure fucked_up;
begin
say_saying('"No you Fool! That is NOT the number of the Beast!');
say_saying('"Read the Signs!  To teach you a lesson, I want you to meet my friends"');
say_saying('The Pit Fiend steps into a cloud of acrid smoke as four Lemures grin at you!');
number_of_the_beast:=false;
end;

begin
clear_space;
say_saying('Just before you get to the stairs a cloud of smoke forms.');
say_saying('The air becomes sickly warm as a infintely hot fire burns the floor!');
say_saying('A Hideous Pit Fiend steps forward and grins with a devilish smile!');
say_saying('Tell me the Number of the Beast or face my wrath mortal one!');
number_of_the_beast:=true;
say_saying('Enter Your Answer (3 Digits, 000 for No Answer!): ');
get_answer;
testor2 := check_answer;
case testor2 of
   1 :  avoided_problems;
   2 :  right_answer;
   3 :  fucked_up;
end;
end;

overlay procedure do_other_wandering;
type ytems = STRING[80];
type mm = record
      usermouth : string[25];
      saying : string[80];
    end;
  procedure do_a_trap;
  var xxx:char;
     procedure pit;
     var damag,x:integer;
     begin damag:=0;
       for x:=1 to player.dungeon_level do
         damag:=damag+random(6)+1;
         player.act_hitpoints:=player.act_hitpoints - damag;
         if player.stats[4] > random(100) then damag:=damag div 2;
         say_saying('You have Fallen into a Pit!');
         say_saying('You take '+cstr(damag)+' Points of Damage!');
         check_player_death;
         say_saying('You are delayed by 50 movement points getting out!');
         moves:=moves-50;
    end;
   procedure cage;
   var x : integer;
   begin
   say_saying('Rattling chains can be heard as a floor plate presses downward!');
   if random(100)+1 < (player.stats[6] + player.stats[4]) then begin
   say_saying('You throw yourself to the side of a wall as a giant heavy cage ');
   say_saying('crashes to the floor!') end else begin
   say_saying('Before you have a chance to move a cage traps you!  Ugh!');
    x:=60-player.stats[1];
   if x < 10 then x:=10;
   say_saying('You Lose '+cstr(x)+' moves for today!');
   moves:=moves-x;
   end;
   end;

procedure stone_block;
  var x,damag : byte;
  begin
   say_saying('A plate in the ground pushes inward as you step on it');
   if random(100)+1 < (player.stats[6] + player.stats[4]) then begin
   say_saying('You throw yourself to the side of a wall as a heavy, stone block');
   say_saying('crashes to the floor!') end else begin
   say_saying('Before you have a chance to move a stone block falls on you!  Ugh!'); damag:=0;
   for x:=1 to player.dungeon_level do damag:=damag+random(6)+1;
   say_saying('You are hit for '+cstr(damag)+' Points of Damage!');
  end;
end;

procedure acid;
  var x,damag : byte;
  begin
    say_saying('A plate in the ground slips inward as you step on it'); damag:=0;
    if random(100)+1 < (player.stats[6] + player.stats[4]) then begin
      say_saying('A cauldron of Acid begins to burn away the floor!');
      say_saying('Luckily you avoided it!');
      end else begin
      say_saying('You are drenched in a powerful acid that begins to corrode you!');
      if player.equiparmor.idnum[1]='N' then begin
         for x := 1 to player.level do
            damag:=damag+random(8)+1;
         say_saying('You take '+cstr(damag)+' Points of Damage!');
         player.act_hitpoints := player.act_hitpoints-damag;
         check_player_death;
      end else begin
      say_saying('Your Armor is drained by a magical bonus of -1!');
      player.equiparmor.magical:=player.equiparmor.magical-1;
      determine_armorclass;
      end;
      end;
end;

procedure goolie;
begin
say_saying('A Dismembered body falls forward, out of the ceiling');
say_saying('Mouth ajarr and rot grubs crawling all over his now fleshless body');
say_saying('When a Hideous laugh breaks the silent air ......');
say_saying('"The Master Lord, Pit Fiend was here.....Muhahhah"');
end;

begin
clear_space;
say_saying('A TRAP -- PRESS "A" TO SEE WHAT HAPPENS!!!!!!!!: ');
onek(xxx,'A');
 case (random(6)+1) of
  1 : pit;
  2 : cage;
  3 : stone_block;
  4 : acid;
5,6 : goolie;
end;
end;


  procedure do_a_magic_mouth;
    var g1 : file of mm; inputss : str;
    mag_mouth : mm; choice5 : char;
    begin
    clear_space;
    say_saying('A Magic Mouth appears; hit "A" to see what it says: ');
    ansic(5); onek(choice5,'A');
    assign(g1,'mmouth.dat'); reset(g1);
    read(g1,mag_mouth);
    say_saying('From: '+mag_mouth.usermouth);
    say_saying(mag_mouth.saying);
    say_saying('Now you have a chance to change it, do you wish to (Y/N)?: ');
    onek(choice5,'YN'); close(g1);
    if choice5 ='Y' then begin
      assign(g1,'mmouth.dat'); rewrite(g1); mag_mouth.usermouth:=player.name;
      say_saying(':'); ansic(5);
      input(inputss,70); mag_mouth.saying:=inputss; write(g1,mag_mouth); close(g1);
     end;
say_saying('Continue Playing......');
    end;

procedure pile_of_shit;
type klunker = record
       sayer : string[80]
       end;
var g1 : file of klunker; x:integer;
    temp : klunker;
begin
assign(g1,'piles.dat');
reset(g1); x:=random(40);
seek(g1,x); read(g1,temp);
say_saying(temp.sayer); close(g1);
end;

begin
case (random(18)+1) of
10,11,14,18 : do_a_magic_mouth;
15,16,17,2,3,12: do_a_trap;
1,4,5,6,7,8,9,13 : pile_of_shit;
end;
end;

overlay function who_is_it(xxx,yyy : integer) : boolean;
  var filer : file of character_location;
    foundit : boolean; secint: char;
    temp : character_location;
    tempy : character;


  procedure convert(x : integer);
      var temp_file : file of character;
      filename:string[8];
    begin
    filename:='        ';
    str(x,filename);
    assign(temp_file,filename+'.SAV'); reset(temp_file);
    read(temp_file,tempy); close(temp_file);
    otra_player:=tempy;
    monster_array[73].idnum:=73;
    monster_array[73].name :=tempy.name;
    monster_array[73].minhp:=tempy.maxhitpoints;
    monster_array[73].maxhp:=tempy.maxhitpoints;
    monster_array[73].numatt:=tempy.numatt;
    monster_array[73].gps :=(random(100)+1)*tempy.level;
    monster_array[73].staff:=1;
if tempy.level > 10 then tempy.level :=10;
if tempy.equipmis.idnum[1] <> 'N' then monster_array[73].range:=100
  else monster_array[73].range:=0;
  if (tempy.class=6) or (tempy.class=2) then monster_array[73].spoints:=tempy.stats[8]
    else monster_array[73].spoints:=0;
  if tempy.equipmagic.idnum[1] <> 'N' then monster_array[73].staff:=ord(tempy.equipmagic.idnum[3])-48;
  if tempy.equipmagic.idnum = 'M20' then monster_array[73].staff:=10;
if tempy.equipweapon.idnum[1] <> 'N' then begin
  monster_array[73].minddam:=1+tempy.equipweapon.magical+modifier(tempy.stats[1]);
  monster_array[73].maxdam:=tempy.equipweapon.magical+tempy.equipweapon.dam+modifier(tempy.stats[1]);
 end else begin
  monster_array[73].minddam:=0;
  monster_array[73].maxdam:=1+modifier(tempy.stats[1]); end;
 if tempy.equipmis.idnum[1] <> 'N' then begin
  monster_array[73].mis_mindam:=1+tempy.equipmis.magical+modifier(tempy.stats[4]);
  monster_array[73].mis_maxdam:=tempy.equipmis.magical+tempy.equipmis.dam+modifier(tempy.stats[4]);
 end else begin
  monster_array[73].mis_mindam:=0;
  monster_array[73].mis_maxdam:=1+modifier(tempy.stats[4]);
 end; monster_array[73].level:=tempy.level;
  if (tempy.class=6) or (tempy.class=2) then
    if tempy.level > 10 then monster_array[73].level:=10;
  monster_array[73].undead:=false;
  if tempy.class=4 then monster_array[73].FAB:=true else monster_array[73].FAB:=false;
  monster_array[73].Armor_class:=tempy.armorclass; monster_array[73].idnum:=73;
    monster_array[73].regen:=0;
  end;

begin
clear_space;
assign(filer,'locxy.dat'); foundit:=false;
reset(filer); who_is_it:=false;
while foundit=false do begin
 read(filer,temp);
 if temp.dungeon_level = player.dungeon_level then
  if temp.xmaps = player.xmap then
   if temp.ymaps = player.ymap then
    if temp.xloc = player.xactual+xxx then
     if temp.yloc = player.yactual+yyy then begin
       close(filer); convert(temp.num); foundit:=true; otra_char := temp.num;
        say_saying('You Encounter '+tempy.name+' who is a Level '+cstr(tempy.level)+'  '+class_name[tempy.class]);
         say_saying('Do You Wish to Attack? (Y/N) '); ansic(4); onek(secint,'YN');
         if secint='Y' then who_is_it:=true else who_is_it:=false;
        end;
end;
end;

overlay procedure do_pound;
  var st : byte;
begin
clear_space;
say_saying('As you walk forward a Magic Mouth appears and says the following:');
case player.ymap of
  4 : st:=1; 1: st:=2; 5: st:=3; end;
say_saying('Your Beast # '+cstr(st)+' is '+cstr(player.exemptions[st]));
say_saying('REMEMBER THIS: Beast #'+cstr(st)+' is '+cstr(player.exemptions[st]));
pausescr;
end;

overlay function GATE_KEEPER : boolean;
begin
clear_space;
if player.exemptions[5] = 0 then begin
say_saying('Standing before the gates to the Third Level ');
say_saying('is a Hideous and Skeletal Gate Keeper!  He raises his sickle to ');
say_saying('begin the attack!');
gate_keeper:=true;
end else gate_keeper:=false;
end;

overlay procedure sell_potion;
var choicer: char; coster : real;

procedure give_list_pot;
var x:char; g1: file of char; tt:integer;
begin
cls; assign(g1,'POTION.ANS');  reset(g1); x:='p';
while x <> '*' do begin
   read(g1,x); ansic(4); if x<>'*' then prompt(x);
end; close(g1);
for tt:=1 to 8 do begin
  goto_ansixy(5+tt,50); ansic(3); prompt(cstr(player.exemptions[42+tt]));
  end;
end;

procedure purchase_potion;
var yyy:char; tvt:str; junk,quant,xx:integer;
begin
nl;nl;
talknl(4,'You have '+cstrr(player.goldpieces,10)+' Gold Pieces');
nl; nl; talknl(4,'No more than 255 for any potion!');
talknl(4,'Which do you wish to purchase? (0,1..8) (0 for None)');
ansic(4); onek(yyy,'021345678'); nl;
if yyy<>'0' then begin
 talk(4,'How Many Do you Wish to Purchase? (1..255): ');
 ansic(3); input(tvt,3);
 val(tvt,quant,junk); xx:=ord(yyy)-48;
 if player.goldpieces < (potion_array[xx].cost*quant) then begin
    ansic(3); print('You Don''t have enough Gold for that!'); end else
  if quant < 1 then begin
    ansic(3); print('Are you trying to Cheat?');
    end else
    if player.exemptions[42+xx]+quant>255 then begin
     ansic(4); print('That''s over 255, you can''t carry that much!') end
     else begin
   player.exemptions[42+xx]:=player.exemptions[42+xx]+quant;
   player.goldpieces:=player.goldpieces-(potion_array[xx].cost * quant);
   end;
end;
end;

begin
say_saying('Inside the Room is a Wrinkled little Gnome....');
say_saying('Welcome -- to my Shop of Potions!');
say_saying('Do You Wish to Buy Any? (Y/N)'); onek(choicer,'YN');
  if choicer='Y' then
  repeat
    give_list_pot;
    purchase_potion;
    talk(3,'Do You Wish to Buy Any More? (Y/N)'); onek(choicer,'YN');
    until choicer='N';
end;

overlay procedure do_a_fountain;
var choice : char;
procedure effective_fountain(var alterator : integer);
var r,x : integer;
begin
alterator := alterator + random(4)-1;
r := random(26)+1+alterator;
case r of
-25..5     : begin say_saying('You are completely healed!');
             player.act_hitpoints:=player.maxhitpoints; end;
6,7       : begin say_saying('Your Armor Class has been raised by one, temporarily!');
             player.armorclass:=player.armorclass+1; end;
8,9,10,11 : begin say_saying('You Loose 5 Turns!'); moves:=moves-5; end;
12,13,14  : begin say_saying('Your Spell Points have been Restored!'); player.act_spellpoints:=player.stats[8];
                end;
15,16,17  : begin say_saying('At the Bottom of the Fountain You Find Many Goldpieces');
            x:=random(200)+10 * player.level; player.goldpieces:=player.goldpieces+x; end;
18,19,20  : say_saying('Quite Refreshing!                              ');
21,22,23  : begin goto_ansixy(22,1); ansic(5);
            prompt('Fool!  You loose 1 Maximum Hit Point!'); pausescr;
            player.maxhitpoints := player.maxhitpoints-1; end;
24,25,26  : begin
            say_saying('Dizzy Water, UGH! Loose 1 Armor Class Rating! (temporarily)             ');
            player.Armorclass:=player.armorclass-1; end;
27,28,29,30 : begin  x:=(random(90)+10)*player.level;
             say_saying('Gold Stealer! A Mystic Hand Comes out of the Fountain and Steals '+cstr(x)+' Gold Pieces');
             player.goldpieces:=player.goldpieces-x; if x<0 then player.goldpieces:=0;
             end;
31..50    : begin save_char; say_saying('Go to Zero Movement Points!  Argh, Later'); moves:=0; check_moves;
            return; end;
 end;
end;

begin
repeat
say_saying('Do You Wish to Drink From This Fountain? (Y/N): ');
onek(choice,'YN');
if choice='Y' then effective_fountain(modder);
moves:=moves-1; if moves < 1 then choice:='N';
until choice='N';
end;

overlay procedure destroy_char;
var saver: file of character;
filename:string[8];
begin
 filename:='        ';
 str(usernum,filename);
 filename:=filename+'.SAV';
clear_space;
say_saying('Choice: (D)estroy, (N)othing, (Q)uit w/o Saving, Your Character?');
onek(ginput,'DNQ');
if ginput='D' then begin
 save_char;
 assign(saver,filename);
 erase(saver); sysoplog(player.name+' Killed his/her character by ''Z'' method!');
 say_saying('Play Again Real Soon!'); return;
end;
if ginput='Q' then return;
if ginput='N' then say_saying('Continue Playing......');
end;


overlay function caryatid(var ja,jb,jc,jd,je : byte) : boolean;
var chk : char;
begin
clear_space;
say_saying('Upon Reaching the Statue(s) it suddenly comes to life!');
say_saying('"Back away or I shall be forced to attack you", it challenges');
say_saying('Slay it (Y/N)');
onek(chk,'YN');
if chk='N' then caryatid:=false else
begin say_saying('The Statue(s) Come to Life and Attack!');
 caryatid:=true;
 case player.level of
 1..5 : case random(3) of
 0,3  : begin ja:=42; jb:=42; jc:=51; jd:=51; je:=2; end;
   1  : begin ja:=42; jb:=42; jc:=51; jd:=51; je:=2; end;
   2  : begin ja:=42; jb:=51; jc:=51; jd:=51; je:=1; end;
 end;
 6..10 : case random(4) of
   0,4 : begin ja:=42; jb:=42; jc:=42; jd:=42; je:=4; end;
   1   : begin ja:=42; jb:=42; jc:=42; jd:=51; je:=3; end;
   2   : begin ja:=43; jb:=42; jc:=51; jd:=51; je:=2; end;
   3   : begin ja:=43; jb:=42; jc:=42; jd:=51; je:=3; end;
 end;
11..15 : case random(3) of
   0,3 : begin ja:=42; jb:=42; jc:=43; jd:=43; je:=4; end;
   1   : begin ja:=43; jb:=43; jc:=43; jd:=51; je:=3; end;
   2   : begin ja:=42; jb:=43; jc:=42; jd:=51; je:=3; end;
end;
16..100 : begin ja:=43; jb:=43; jc:=43; jd:=43; je:=4; end;
end;
end;
end;

overlay function NONA : boolean;
var g1: file of char;
    yeck : char;
begin
if player.exemptions[6] = 0 then begin
   cls; assign(g1,'NONA.TXT'); reset(g1);
   while yeck <> '*' do begin
      read(g1,yeck); if yeck <> '*' then prompt(yeck);
   end; close(g1); pausescr;
   NONA:=true; end  else NONA:=false;
end;

overlay function DO_FINAL : boolean;
var g1:file of char;
    yeck : char;
begin
if player.exemptions[7] =0 then begin
   cls; assign(g1,'FINAL.TXT'); reset(g1);
   while yeck <> '*' do begin
      read(g1,yeck); if yeck <> '*' then prompt(yeck); end; close(g1); pausescr;
   do_final:=true end else do_final:=false;

end;

overlay procedure do_final2;
var winnerfile : file of char;
     yicki : char;
begin
cls; assign(winnerfile,'WINNER.TXT');
     reset(winnerfile);
     while yicki <> '*'  do begin
        read(winnerfile, yicki); if yicki <> '*' then prompt(yicki);
     end; close(winnerfile);
  pausescr;     player.dungeon_level:=20; save_char; return;
end;

overlay procedure check_for_new_level(snumber : byte);
var x,y : integer;
 procedure increase_stats;
 var x: integer;
    let : char;
begin
 for x := 1 to 3 do begin
 cls; ansic(4); print('You May Now Increase any '+cstr(4-x)+' Stats, hit the corresponding Letter:');nl;
 print(' A.  Stength      '+cstr(player.stats[1]));
 print(' B.  Intelligence '+cstr(player.stats[2]));
 print(' C.  Wisdom       '+cstr(player.stats[3]));
 print(' D.  Coordination '+cstr(player.stats[4]));
 print(' E.  Health       '+cstr(player.stats[5]));
 print(' F.  Luck         '+cstr(player.stats[6]));
 print(' G.  Personality  '+cstr(player.stats[7]));
  ansic(4); prompt('Letter:  ');
  onek(let,'ABCDEFG');
  case let of
   'A'  :begin player.stats[1]:=player.stats[1]+1; act_stats[1]:=act_stats[1]+1; end;
   'B'  :begin player.stats[2]:=player.stats[2]+1; act_stats[2]:=act_stats[2]+1; end;
   'C'  :player.stats[3]:=player.stats[3]+1;
   'D'  :begin player.stats[4]:=player.stats[4]+1; act_stats[4]:=act_stats[4]+1; end;
   'E'  :player.stats[5]:=player.stats[5]+1;
   'F'  :begin player.stats[6]:=player.stats[6]+1; act_stats[3]:=act_stats[3]+1; end;
   'G'  :player.stats[7]:=player.stats[7]+1;
  end;
end;
if (player.level mod 5 = 0) then begin player.numatt:=player.numatt+1;
  say_saying('Great Work! You Now Have an Additional Attack per Round');
 end;
determine_armorclass;
end;

procedure give_pot;
var amounti, ran : integer;
begin
ran:=random(6)+1; amounti:=random(3)+1;
say_saying('You find '+cstr(amounti)+' Potions of '+potion_array[ran].name);
if player.exemptions[42+ran]+amounti > 255 then player.exemptions[42+ran]:=255
 else player.exemptions[42+ran]:=player.exemptions[42+ran] + amounti;
say_saying('You now have '+cstr(player.exemptions[42+ran])+' Potions of '+potion_array[ran].name);
end;

procedure restyn;
var choice : char;
begin
 player.act_hitpoints:=player.maxhitpoints;
 player.act_spellpoints:=player.stats[8];
 pausescr;
end;

procedure determine_experience(var expr : real);
var ct : integer;
    atemp : real;
begin
atemp:=0;
for ct:=1 to snumber do
atemp:= meanies[ct].experience+ atemp;
say_saying('You have earned: '+cstrr(atemp,10)+' Experience Points!');
expr:=expr+atemp;
end;

procedure give_out_treasure;
var treasure : real;
    pot, x : integer;
begin
treasure:=1;
for x:=1 to snumber do
treasure:=meanies[x].gps+(meanies[x].gps*(random(20)-10)/100)+treasure;
if treasure < 0 then treasure:=0;
say_saying('Searching through the debris of the battle you find:  '+cstrr(treasure,10)+' Gold Pieces');
player.goldpieces:=treasure+player.goldpieces;
say_saying('You now have, '+cstrr(player.goldpieces,10)+' Gold Pieces');
if random(100) < snumber+6 then give_pot;
end;

begin
give_out_treasure;
determine_experience(player.experience);
restyn;
if player.experience > player.needed_exp-1 then begin  {gained level!}
   player.needed_exp:=2*player.needed_exp;
   player.level:=player.level+1; y:=0;
   clear_space;
   say_saying('Congratulations! You have gained a Level!');
   say_saying('You are now Level:  '+cstr(player.level));
   say_saying('You now need '+cstrr(player.needed_exp,10)+' Experience Points');
   case player.class of
      1 :  x:=random(7)+10;
      2 :  begin x:=random(7)+6; y :=random(10)+12 + modifier(player.stats[2]); end;
      3 :  x:=random(8)+8;
      4 :  x:=random(8)+8;
      5 :  x:=random(8)+12;
      6 :  begin x:=random(6)+8; y:=random(7)+10 + modifier(player.stats[2]); end;
   end;
   x:=x+modifier(player.stats[5]);   if x < 1 then x:=1;
   say_saying('You have gained '+cstr(x)+' Hit Points!');player.maxhitpoints:=player.maxhitpoints+x;
   say_saying('You now have '+cstr(player.maxhitpoints)+' Maximum Hitpoints');
   player.act_hitpoints:=player.maxhitpoints;
   say_saying('Spell Points have been increased by '+cstr(y));
   player.stats[8]:=player.stats[8]+y;
   player.act_spellpoints:=player.stats[8]; pausescr;
   cls;
  increase_stats;
end;
moves:=moves-10;
end;
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
cround: byte;

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
for x:=1 to 4 do meanies[x]:=monster_array[50];
meanies[1]:=monster_array[a2];
meanies[2]:=monster_array[b2];
meanies[3]:=monster_array[c2];
meanies[4]:=monster_array[d2];
if number > 1 then
meanies[2].maxhp:=random(meanies[2].maxhp-meanies[2].minhp)+meanies[2].minhp;
if number > 2 then meanies[3].maxhp:=random(meanies[3].maxhp-meanies[3].minhp)+meanies[3].minhp;
if number > 3 then meanies[4].maxhp:=random(meanies[4].maxhp-meanies[4].minhp)+meanies[4].minhp;
for x:=1 to 4 do hps[x]:=meanies[x].maxhp;
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
2  : determine_base:=9;
3,4,6 : determine_base:=8;
end;
end;

procedure do_missile(which : integer);
 var countz,temp,x,baser : integer;
begin
if player.equipmis.idnum > 0 then begin
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
if player.equipweapon.idnum> 0 then begin
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
if random(100)+meanies[cat].level*7 > 75+player.level then
begin say_saying(meanies[cat].name+' made his saving throw!');
dama:=dama div 2; end else say_saying(meanies[cat].name+' missed his saving throw!');
end;

procedure do_char_staff;
var dc,x,y,damag : integer;
begin
with player do begin
if class=6 then dc:=-2 else dc:=-3;
if (level*dc)+random(100)-(stats[2]*(0-dc))<equipmagic.success-1 then
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

function fire_ring : boolean;
var axer, damag:integer;
begin
with player do begin
if (equipring.idnum>5) and (equipring.idnum<10) then
for axer:=1 to number do begin
damag:=random(equipring.maxdam-equipring.minddam)+equipring.minddam;
fire_ring:=true;
save_for_monster(damag,axer);
say_saying
('Your '+equipring.name+' Explodes on '+meanies[axer].name+' #'+cstr(axer)+' For '+cstr(damag)+' Points of Damage');
meanies[axer].maxhp:=meanies[axer].maxhp-damag;
if meanies[axer].maxhp<1 then mon_dead[axer]:=true;
display_monsters(axer);
equipring.charges:=equipring.charges-1;
if equipring.charges<1 then equipring:=ring[0];
end else begin say_saying('You do not have a Magical Combat Ring!'); fire_ring:=false; end;
end;
end;

procedure player_attack;
var choice : char;
 okay : boolean;
 counts : byte;
begin
repeat
 okay:=true;
 say_saying('Choice: (1234,FMPRSTU) : '); ansic(4);
 onek(choice,'1234FMPRSTUZ');
 case choice of
'1','2','3','4' : if (ord(choice)-48 > number) or (mon_dead[ord(choice)-48])
  then okay:=false else attack_monster(choice);
 'F' : okay:=fire_ring;
 'M' : move_char;
 'R' : okay:=retreat_char;
 'T' : if player.class <> 3 then begin okay:=false; say_saying('You are Not a Priest!');
       end else turn_undead;
 'S' : if (player.class <> 2) and (player.class <> 6) then
       begin okay:=false; say_saying('You are Not a Magic User!'); end
       else if player.equipmagic.idnum=0 then begin say_saying('You Don''t Have a Magic Staff!');
       okay:=false; end else
      if player.act_spellpoints < player.equipmagic.spcost then begin
      say_saying('You Don''t Have Enough Spell Points!'); okay:=false;
      end else do_char_staff;
 'P' : begin say_saying('You Pass this round!'); counts:=player.numatt; end;
 'U' : begin okay:=use_which_potion; display_char; end;
 'Z' : return;
end;
 if okay then begin check_monster_deaths; counts:=counts+1; end;
 if finished then BEGIN counts:=player.numatt; okay:=true; end;
until okay;
end;

procedure close_mon_melee(loct: integer);
var modr: integer;
begin
modr :=0;
if meanies[loct].FAB then modr:=30;
if meanies[loct].level*7+modr+random(100) > (45+player.stats[4]) then begin
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
if (drainer) and (random(100)<50+player.level+modifier(player.stats[6]))
 then begin say_saying(name+' Drains you of '+cstr(level)+'% of your experience!');
 player.experience:=int(player.experience*((100-level)/100));
 end;
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
if random(100)+player.level*5+player.stats[6] > 80 then
begin say_saying('You made your saving throw, half damage!');
dama:=dama div 2; end else say_saying('You missed your saving throw <full damage!>');
if player.equipring.idnum=19 then
 if player.equipring.charges-dama< 0 then
  begin dama:=0-player.equipring.charges-dama; player.equipring:=ring[0];
  say_saying('Your Ring is Useless now... absorbed some of the damage!');
  end else begin player.equipring.charges:=player.equipring.charges-dama;
  say_saying('Your Ring Absorbs the Damage, have '+cstr(player.equipring.charges)+' Left!');
  dama:=0;
 end
end;

procedure mon_magic(loct: integer);
var temp: magic_staff; x,sum:integer;
begin
with meanies[loct] do begin
temp:=magici[meanies[loct].staff]; sum:=0;
if random(100) > temp.success+(4*meanies[loct].level)
then begin say_saying(Name+' Fails to '+sp_name+' Sucessfully!');
 spoints:=spoints-temp.spcost; display_monsters(loct);
 end else begin
 for x:=1 to temp.damage do
 sum:=random(9)+1+sum;
 do_player_saving_throw(SUM); if sum<1 then sum:=1;
 player.act_hitpoints:=player.act_hitpoints-sum;
 spoints:=spoints-temp.spcost;
say_saying('The '+meanies[loct].name+' '+sp_name+' for '+cstr(sum)+' Points of Damage');
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
var gg : byte;
begin
 for gg:=1 to number do
  if (meanies[gg].regen>0) then
  begin
   meanies[gg].maxhp:=meanies[gg].maxhp+meanies[gg].regen;
   if meanies[gg].maxhp>hps[gg] then meanies[gg].maxhp:=hps[gg];
   say_saying(meanies[gg].name+' #'+cstr(gg)+' Regenerates '+cstr(meanies[gg].regen)+' Hit Points!');
   if (mon_dead[gg]) and (meanies[gg].maxhp>0) then begin
     mon_dead[gg]:=false;
     say_saying(meanies[gg].name+' #'+cstr(gg)+' Comes back to Life!');
   end;
   display_monsters(gg);
  end;
with player do begin
if (equipring.idnum=12) or (equipring.idnum=13) then
if act_hitpoints<maxhitpoints then begin
 act_hitpoints:=act_hitpoints+equipring.magical;
 if act_hitpoints>maxhitpoints then act_hitpoints:=maxhitpoints;
 say_saying('You Regenerate '+cstr(equipring.magical)+' Hit Points!');
 display_char_hp;
end;
end;
end;

procedure do_combat;
var temp,playeri,mons : integer;
begin
say_saying('Round Number '+cstr(cround)+' of Combat!'); sub_moves(1);
if cround mod 3=0 then regenate;
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

overlay procedure do_other_wandering;
  procedure do_a_trap;
  var xxx:char;

     procedure pit;
     var damag,x:integer;
     begin damag:=0;
       for x:=1 to player.dungeon_level+1 do
         damag:=damag+random(10)+1;
         player.act_hitpoints:=player.act_hitpoints - damag;
         if player.stats[4] > random(100) then damag:=damag div 2;
         if damag<1 then damag:=1;
         say_saying('You have Fallen into a Pit!');
         if player.equipring.idnum=15 then say_saying('Luckily, Your Feather Falling ring Saved You!')
          else begin
         say_saying('You take '+cstr(damag)+' Points of Damage!');
         check_player_death;
          end;
         say_saying('You are delayed by 15 movement points getting out!');
         sub_moves(15);

    end;
   procedure cage;
   var x : integer;
   begin
   say_saying('Rattling chains can be heard as a floor plate presses downward!');
   if random(100)+1 < (player.stats[6] + player.stats[4]) then begin
   say_saying('You throw yourself to the side of a wall as a giant heavy cage ');
   say_saying('crashes to the floor!') end else begin
   say_saying('Before you have a chance to move a cage traps you!  Ugh!');
    x:=50-player.stats[1];
   if x < 10 then x:=10;
   say_saying('You Lose '+cstr(x)+' moves for today!');
   moves:=moves-x; player.total_moves:=player.total_moves+x;
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
      if player.equiparmor.idnum>0 then begin
         for x := 1 to player.dungeon_level do
            damag:=damag+random(12)+1;
         say_saying('You take '+cstr(damag)+' Points of Damage!');
         player.act_hitpoints := player.act_hitpoints-damag;
         check_player_death;
      end else begin
      say_saying('Your Armor is drained by a magical bonus of -1!');
      player.equiparmor.magical:=player.equiparmor.magical-1;
      if player.equiparmor.magical < -1 then player.equiparmor.magical:=-1;
      determine_armorclass;
      end;
      end;
end;
 procedure wanderman;
 var ggg,bonus : byte;
     itemname:string[30]; mag_mod,modis,coster : integer;
  procedure pric_mod;
   begin
    case bonus of
    1 : mag_mod:=0;
    2 : mag_mod:=500;
    3 : mag_mod:=2000;
    4 : mag_mod:=4000;
    5 : mag_mod:=9000;
    6 : mag_mod:=12000;
   7..100 :mag_mod:=25000;
   end;
end;

 begin
 modis:=modifier(player.stats[7]);
 say_saying('As you drugde through the wilderness, you hear the sounds of wooden');
 say_saying('wheel turning and the laughter of men!  Quickly taking cover you ');
 say_saying('hide in the brush.  From around the corner comes a caravan of ');
 say_saying('weapon merchants...  Do you Expose yourself (Y/N)?'); ansic(7);
 onek(ginput,'YN');
   if ginput='N' then say_saying('The merchants pass without incident!')
     else begin clear_space; dialcnt:=18;
       say_saying('You step out of the cover and walk up to them!');
       say_saying('"Greetings Traveler, calls a merchant!  By the looks of yourself');
       say_saying('it appears that you may be in need of some MAGIC items...');
       say_saying('Would thou be interested? (Y/N)'); ansic(7);
       onek(ginput,'NY');
       if ginput='N' then say_saying('"Too Bad, maybe some other time... the merchants continue..')
         else begin
           ggg:=random(3)+1;
    case ggg of
    1 : begin {mel wea} itemname:=player.equipweapon.name; bonus:=player.equipweapon.magical+1;
  pric_mod; coster:=player.equipweapon.cost + ((450+modis)+mag_mod); end;
    2 : begin {mis wea} itemname:=player.equipmis.name; bonus:=player.equipmis.magical+1;
  pric_mod; coster:=player.equipmis.cost + ((450+modis)+mag_mod); end;
    3 : begin {armor} itemname:=player.equiparmor.name; bonus:=player.equiparmor.magical+1;
  pric_mod; coster:=player.equiparmor.cost + ((450+modis)+mag_mod); end;
     end;
   clear_space; dialcnt:=18;
    if bonus>7 then say_saying('Sorry but what we have to offer is nothing compared to your equipment!')
    else begin
    say_saying('We offer you this --> '+itemname+' +'+cstr(bonus)+' for '+cstr(coster)+' Gold Pieces');
    say_saying('You have '+cstrr(player.goldpieces,10)+' Gold Pieces.  Is this acceptable to you? (Y/N)');
    if ginput='N' then say_saying('"Too bad, maybe some other time then..."')
    else if player.goldpieces < coster then say_saying('I''m afraid you don''t have the gold to buy it!')
      else begin  player.goldpieces:=player.goldpieces-coster;
       case ggg of
        1:  player.equipweapon.magical:=bonus;
        2:  player.equipmis.magical   :=bonus;
        3:  player.equiparmor.magical   :=bonus;
       end;
      say_saying('"Purchased... see you later, do business again!"');
     end;
    end;
   end;
 end;
end;

procedure speedman;
var cost:integer;
begin
cost:=(1000+random(100))*player.level;
say_saying('A traveling Elf offers to speed up your missile weapon by 1 additional');
say_saying('attack per round!  He charges '+cstr(cost)+' gold pieces for the service!');
say_saying('You have '+cstrr(player.goldpieces,10)+' Gold Pieces (YN)'); ansic(4);
onek(ginput,'YN'); if ginput='Y' then
 if player.goldpieces < cost then say_saying('Not Enough Funds!  Maybe Later...')
       else begin
          player.goldpieces:=player.goldpieces-1000;
          player.equipmis.numat:=player.equipmis.numat+1;
          player.equipmis.name:=player.equipmis.name+' OF SPEED';
       end;
end;

procedure bard;
  begin
  say_saying('A traveling minstrel is out in the wilderness.....');
  say_saying('He greets you pleasantly and says the following to you:  ');
  say_saying('"Greetings from Castle Kzin, I''m the head bard there... for 100 "');
  say_saying('"gold pieces I will sing you a song?  Okay? (Y/N)"');
  say_saying('You have '+cstrr(player.goldpieces,10)+ ' Gold Pieces!');
  ansic(5); onek(ginput,'YN');
  if ginput='N' then say_saying('Maybe some other time then......')
    else if player.goldpieces < 100 then say_saying('Not Enough Gold!')
       else begin
           say_saying('The Bard Begins to strum his lyre......'); pausescr;
           clear_space;
           say_saying('Tis is said, that the evil ones are back....');
           say_saying('Xevior, Mojave, and Pit Fiend -- ones dressed in black');
           say_saying('Doing their worst to destroy the world and all its good!');
           pausescr; clear_space;
           say_saying('Xevior, a dwarf to be feared;');
           say_saying('Lives deep in the mountains... talk to his heirs;');
           say_saying('Mojave, raiding ships and plundering the fair;');
           say_saying('is said to be undeafetable, prepare for him with great care;');
           pausescr; clear_space;
           say_saying('The mighty Pit Fiend, has yet to be heard from;');
           say_saying('Hiding in the depths, watching his evil plans take their form;');
           say_saying('while the Death Angels guard his place;');
           say_saying('where the name comes from a heroine of great beauty and grace.');
       end;
end;


procedure do_a_magic_mouth;
 var g1 : file of mm; inputss : str;
 mag_mouth : mm; choice5 : char;
 begin
 clear_space;
 say_saying('A Magic Mouth appears!');
 assign(g1,'MMOUTH.DAT'); reset(g1);
 read(g1,mag_mouth);
 say_saying('From: '+mag_mouth.usermouth);
 say_saying(mag_mouth.saying);
 say_saying('Now you have a chance to change it, do you wish to (Y/N)?');
 onek(choice5,'YN'); close(g1);
 if choice5 ='Y' then begin
  assign(g1,'mmouth.dat'); rewrite(g1); mag_mouth.usermouth:=player.name;
  say_saying('Enter String (70 Characters) ');
  say_saying(':'); ansic(5);
  input(inputss,70); mag_mouth.saying:=inputss; write(g1,mag_mouth); close(g1);
  say_saying('Message saved and reported to sysop!');
  sysoplog('Magic Mouth = '+inputss);
 end;
end;

begin
if dialcnt > 18 then begin clear_space; dialcnt:=18; end;
say_saying('A SPECIAL EVENT -- PRESS "A" TO SEE WHAT HAPPENS!!!!!!!!'); ansic(7);
onek(xxx,'A');
if player.dungeon then
    case (random(8)+1) of
       1..3 : pit;
       4 : cage;
       5 : stone_block;
       6 : acid;
      7,8 : do_a_magic_mouth;
    end;
if player.outdoor then
    case (random(8)+1) of
       1..4 :pit;
       5 :wanderman;
       6 :speedman;
       7 :bard;
       8 :do_a_magic_mouth;
     end;
end;

begin
do_a_trap;
end;

overlay procedure sell_potion;
var choicer: char;

procedure give_list_pot;
var x:char; g1: file of char; tt:integer;
begin
cls; talknl(4,'Welcome to : '+town_stuff.pot_name+' Shop of Potions!');
assign(g1,'POTION.ANS');  reset(g1); x:='p'; ansic(0);
while x <> '*' do begin
   read(g1,x); ansic(4); if x<>'*' then prompt(x);
end; close(g1);
for tt:=1 to 9 do begin
  goto_ansixy(6+tt,50); ansic(3); prompt(cstr(player.exemptions[42+tt]));
  end;
end;

procedure seller_pot;
var xyx : char; inpute: str; nm,tempest: byte; charge:real;
begin
talknl(4,'Which do you wish to Sell? (0,1..9) (0 for None)');
onek(xyx,'0123456789');
nm:=ord(xyx)-48; charge:=int(potion_array[nm].cost *0.5);
talknl(4,'I offer you '+cstrr(charge,10)+' Gold Pieces Per Vial');
talk(4,'How Many do you wish to sell (0-'+cstr(player.exemptions[42+nm])+'): ');
input(inpute,3);
tempest:=value(inpute);
if (tempest>0) and (tempest<player.exemptions[42+nm]+1) then begin
  player.exemptions[42+nm]:=player.exemptions[42+nm]-tempest;
  player.goldpieces:=player.goldpieces+(charge*tempest);
  talknl(7,'Thanks for the Business!');
end else talknl(8,'Invalid Input!');
end;

procedure purchase_potion;
var yyy:char; tvt:str; junk,quant,xx:integer;
begin
nl; nl; talknl(4,'No more than 255 for any potion!');
talknl(4,'Which do you wish to purchase? (0,1..9) (0 for None)');
talk(4,'or Hit "S" to sell potion!:  ');
ansic(4); onek(yyy,'0213456789S'); nl;
if yyy='S' then seller_pot else
if yyy<>'0' then begin
 talknl(4,'You have '+cstrr(player.goldpieces,10)+' Gold Pieces');
 talk(3,'How Many Do you Wish to Purchase? (1..255)');
 input(tvt,3);
 val(tvt,quant,junk); xx:=ord(yyy)-48;
 if player.goldpieces < (potion_array[xx].cost*quant) then begin
    ansic(3); print('You Don''t have enough Gold for that!'); end else
  if quant < 1 then
    talknl(3,'Are you trying to Cheat?')
     else
  if player.exemptions[42+xx]+quant>255 then
   talknl(4,'That''s over 255, you can''t carry that much!') else
   begin
 if xx< 10 then player.exemptions[42+xx]:=player.exemptions[42+xx]+quant;
 player.goldpieces:=player.goldpieces-(potion_array[xx].cost * quant);
   end;
end;
end;

begin
repeat
give_list_pot;
purchase_potion;
talk(3,'Do You Wish to Buy Any More? (Y/N)'); onek(choicer,'YN');
until choicer='N';
end;

overlay procedure destroy_char;
var saver: file of character;
filename:string[8];
begin
filename:='        ';
str(usernum,filename);
filename:=filename+'.SAV';
say_saying('Choice: (D)estroy, (N)othing, (Q)uit w/o Saving, Your Character?');
onek(ginput,'DNQ');
if ginput='D' then begin
 player.city:=false; save_char(1);
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
begin say_saying('The Statue(s) Come to Life and Attack!'); pausescr;
 caryatid:=true;
 case player.level of
 1..5 : case random(3) of
 0,3  : begin ja:=60; jb:=60; jc:=60; jd:=50; je:=3; end;
   1  : begin ja:=60; jb:=60; jc:=50; jd:=50; je:=2; end;
   2  : begin ja:=60; jb:=50; jc:=50; jd:=50; je:=1; end;
 end;
 6..10 : case random(4) of
   0,4 : begin ja:=60; jb:=60; jc:=22; jd:=22; je:=4; end;
   1   : begin ja:=60; jb:=60; jc:=22; jd:=50; je:=3; end;
   2   : begin ja:=22; jb:=22; jc:=50; jd:=50; je:=2; end;
   3   : begin ja:=22; jb:=23; jc:=60; jd:=50; je:=3; end;
 end;
11..15 : case random(3) of
   0,3 : begin ja:=22; jb:=22; jc:=23; jd:=60; je:=4; end;
   1   : begin ja:=23; jb:=23; jc:=23; jd:=50; je:=3; end;
   2   : begin ja:=22; jb:=23; jc:=22; jd:=50; je:=3; end;
end;
16..100 : begin ja:=23; jb:=23; jc:=23; jd:=23; je:=4; end;
end;
end;
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
  talk(4, 'Letter:  ');
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
  act_stats[5]:=player.numatt;
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
      1 :  x:=random(10)+13;
      2 :  begin x:=random(7)+8; y :=random(10)+18 + modifier(player.stats[2]); end;
      3 :  x:=random(8)+10;
      4 :  x:=random(8)+10;
      5 :  x:=random(8)+15;
      6 :  begin x:=random(8)+10; y:=random(7)+10 + modifier(player.stats[2]); end;
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
sub_moves(10);
end;
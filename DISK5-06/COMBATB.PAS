{$O+,F+}
unit combatb;
interface
uses common,globals;
function combat(a2,b2,c2,d2,number : byte): boolean;
     procedure do_other_wandering;
procedure sell_potion;
function caryatid : BOOLEAN;
procedure check_for_new_level;
implementation

function combat(a2,b2,c2,d2,number : byte): boolean;
const STANDARD = 10;
      PLAYER_STAND = 9;
type tiny_helper = string[80];
var meanies : array [1..4] of monsters;
    mon_mismel : array [1..4] of boolean;
    mon_dead   : array [1..4] of boolean;
    turned,finished,mismelvar : boolean;  {true :=missile}
    dialcnt,counter : integer;
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
goto_xy(5,12);
ansic(4); write(cstr(player.act_hitpoints)+'  ');
goto_xy(dialcnt,1);
end;

procedure display_char_cac;
begin
goto_xy(6,12); ansic(4); write(cstr(player.armorclass));
end;

procedure display_cMPS;
begin
goto_xy(7,12);
ansic(4); write(cstr(player.act_spellpoints)+'  ');
goto_xy(dialcnt,1);
end;

procedure display_mon_name(x,y,cnt : Integer);
begin
if meanies[cnt].maxhp < 1 then begin goto_xy(x,y); ansic(4); write('DEAD            '); end
 else begin goto_xy(x,y); ansic(4); write(meanies[cnt].name); end;
end;

procedure display_mon_hp(x,y,cnt : Integer);
begin
goto_xy(x,y); ansic(4); write(cstr(meanies[cnt].maxhp)+'   ');
end;

procedure display_mon_AC(x,y,cnt : integer);
begin
goto_xy(x,y); ansic(4); write(cstr(meanies[cnt].armor_class));
end;

procedure display_mon_MPS(x,y,cnt : integer);
begin
goto_xy(x,y); ansic(4); write(cstr(meanies[cnt].spoints)+'   ');
end;

procedure display_mon_mismel(x,y,cnt: Integer);
begin
goto_xy(x,y); write(' '); goto_xy(x+1,y); write(' ');
if mon_mismel[cnt] then goto_xy(x,y) else goto_xy(x+1,y);
ansic(4); write('*'); goto_xy(dialcnt,1);
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
meanies[1]:=monster_array[a2];
meanies[2]:=monster_array[b2];
meanies[3]:=monster_array[c2];
meanies[4]:=monster_array[d2];
if number > 1 then
   meanies[2].maxhp:=random(meanies[2].maxhp)+meanies[2].minhp;
 if number > 2 then meanies[3].maxhp:=random(meanies[3].maxhp)+meanies[3].minhp;
  if  number > 3 then meanies[4].maxhp:=random(meanies[4].maxhp)+meanies[4].minhp;
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
wname :='                          '; damag:=0;
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
if damag < 1 then damag :=1;
if player.class=4 then
    if random(100) < player.level*5 then begin say_saying('You Did DOUBLE damage!');
        damag:=damag*2; end;
say_saying('Your '+wname+' Hits #'+cstr(target)+' '+meanies[target].name+' For '+cstr(damag)+' Points of Damage!');
meanies[target].maxhp:=meanies[target].maxhp-damag;
display_monsters(target); goto_xy(dialcnt,1);
if meanies[target].maxhp < 1 then mon_dead[target]:=true;
end;

function determine_base : integer;
begin
case player.class of
     1,5,6 : determine_base:=7;
      2    : determine_base:=10;
      3,4  : determine_base:=8;
end;
end;

procedure do_missile(which : integer);
 var countz,temp,x,baser : integer;
begin
if player.equipmis.idnum > 0 then begin
  temp:=modifier(player.stats[4]);
  for countz:= 1 to player.equipmis.numat do begin
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
  for countz:= 1 to player.equipweapon.numat do begin
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
      if mon_dead[x]= false then
         if mon_mismel[x] = false then
          if meanies[x].FAB then modm:=20;
             if random(100)+player.stats[4]+player.level*2+modr - meanies[x].level*2 - modm > 50
                then begin mon_mismel[x]:=true; display_monsters(x);
                say_saying(meanies[x].name+' #'+cstr(x)+' is now in Missile Range!');
                end;
    end;
if choice = '2' then
    for x := 1 to number do begin
      modm :=0;
      if mon_dead[x]= false then
         if mon_mismel[x] then
          if meanies[x].FAB then modm:=20;
             if random(100)+player.stats[4]+player.level*2+modr - meanies[x].level*2 - modm > 50
                then begin mon_mismel[x]:=false; display_monsters(x);
                say_saying(meanies[x].name+' #'+cstr(x)+' is now in Melee Combat!');
              end;
end;
end;
procedure retreat_char;
var choice : char;
begin
say_saying('You Realize You Will Loose 25% of your Gold if you Retreat, OK? (Y/N)');
onek(choice,'YN');
if choice='Y' then begin
   player.goldpieces:=player.goldpieces*0.75;
   finished:=true; combat:=false;
   end;
end;

procedure determine_experience(var expr : real);
var ct : integer;
    atemp : real;
begin
atemp:=0;
for ct:=1 to number do
  atemp:= meanies[ct].experience+ atemp;
say_saying('You have earned: '+cstrr(atemp,10)+' Experience Points!');
expr:=expr+atemp;
end;

procedure give_out_treasure;
var treasure : real;
    pot, x : integer;
begin
  treasure:=1;
   for x := 1 to number do
     treasure:=meanies[x].gps+(meanies[x].gps*(random(20)-10)/100)+treasure;
if treasure < 0 then treasure:=0;
say_saying('Searching through the debris of the battle you find:  '+cstrr(treasure,10)+' Gold Pieces');
player.goldpieces:=treasure+player.goldpieces;
say_saying('You now have, '+cstrr(player.goldpieces,10)+' Gold Pieces                    ');
end;

procedure turn_undead;
var y,x,success : integer;
begin
y:=0; for x:=1 to number do
     if meanies[x].undead then y:=y+1;
if y < 1 then say_saying('None of these Beasts Are Undead!  Turn Wasted!' )
 else if turned then say_saying('You have already tried to turn Undead!')
   else for success:=1 to number do
      if mon_dead[success] = false then
        if random(100)+player.stats[3]+3*player.level-2*meanies[1].level-3*number > 50 then
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
if random(100)+meanies[cat].level*6.5 > 75 then
  begin say_saying(meanies[cat].name+' made his saving throw!');
        dama:=dama div 2; end else say_saying(meanies[cat].name+' missed his saving throw!');
end;

procedure do_char_staff;
var x,y,damag : integer;
begin
    if player.level*(-3)+random(100)-(player.stats[2]*2) < player.equipmagic.success-1 then
      begin
       say_saying('Your '+player.equipmagic.name+' was Used Successfully!');
       player.act_spellpoints:=player.act_spellpoints - player.equipmagic.spcost;
         for x:=1 to number do begin
           damag:=0;
           if mon_dead[x] = false then begin
            for y:=1 to player.equipmagic.damage do
               damag:=damag+random(10)+1;
            save_for_monster(damag,x);
            meanies[x].maxhp:=meanies[x].maxhp-damag;
            if meanies[x].maxhp<1 then mon_dead[x]:=true;
            display_monsters(x);
            say_saying('You Cast Your Spell and hit  #'+cstr(x)+' for '+cstr(damag)+' Points of Damage');
            end
         end
      end
   else begin
     say_saying('You Failed to Cast the Spell....');
     player.act_spellpoints:=player.act_spellpoints - player.equipmagic.spcost;
   end;
display_char;
 end;

procedure check_player_death;
begin
if player.act_hitpoints < 0 then begin
   player.act_hitpoints:=player.maxhitpoints div 2;
   player.goldpieces:=0;
   say_saying('Your Character has Been Killed -- Do NOT hang up it has Already ');
   halt;
end;
end;

procedure restyn;
var choice : char;
begin
say_saying('Would you Like to Rest, You are Wounded by '+cstr(player.maxhitpoints-player.act_hitpoints)+' Hit Points (Y/N)?');
if (player.class=2) or (player.class=6) then
  say_saying('You need '+cstr(player.stats[8]-player.act_spellpoints)+' Spell Points Restored!');
onek(choice,'YN');
  if choice = 'Y' then begin
     player.total_moves:=player.total_moves+((player.maxhitpoints-player.act_hitpoints)*2);
     player.act_hitpoints:=player.maxhitpoints;
     player.act_spellpoints:=player.stats[8];
     say_saying('You are completely healed but your moves have gone down!');
     pausescr;
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
   give_out_treasure;
   finished:=true;
   determine_experience(player.experience);
   combat:=true;
   restyn;
end;
end;

procedure player_attack;
var choice : char;
    okay : boolean;
    counts : byte;
begin
counts:= 1;
repeat
   okay:=true;
   say_saying('Choice: (1234,MPRTUX) :'); ansic(4);
   onek(choice,'1234MPRTUXZ');
   case choice of
   '1','2','3','4' : if (ord(choice)-48 > number) or (meanies[ord(choice)-48].maxhp < 1 ) then okay:=false
                     else attack_monster(choice);
   'M' : move_char;
   'R' : retreat_char;
   'T' : if player.class <> 3 then begin okay:=false; say_saying('You are Not a Priest!');
         end else turn_undead;
   'U' : if (player.class <> 2) and (player.class <> 6) then
              begin okay:=false; say_saying('You are Not a Magic User!'); end
         else if player.equipmagic.idnum=0 then begin say_saying('You Don''t Have a Magic Staff!');
          okay:=false; end else
        if player.act_spellpoints < player.equipmagic.spcost-1 then begin
            say_saying('You Don''t Have Enough Spell Points!'); okay:=false;
         end else do_char_staff;
   'P' : begin say_saying('You Pass this round!'); counts:=player.numatt+1; end;
{   'X' : begin use_which_potion; display_char; end;}
   'Z' : halt;
end;
   if okay then begin check_monster_deaths; counts:=counts+1; end;
   if finished then counts:=player.numatt;
until (okay) or (counts=player.numatt);
end;

procedure close_mon_melee(loct: integer);
var modr: integer;
begin
modr :=0;
if meanies[loct].FAB then modr:=20;
if meanies[loct].level*5+modr+random(100) > 50 then begin
   say_saying('The '+meanies[loct].name+' #'+cstr(loct)+' Closes to do Melee!');
   mon_mismel[loct]:=false;
   display_monsters(loct); goto_xy(dialcnt,1);
   end else say_saying('The '+meanies[loct].name+' #'+cstr(loct)+' Fails to Close to do Melee!');
end;

procedure shoot_mon_missile(loct:integer);
var damag,tt,modr,x,hitter : integer;
begin
if meanies[loct].FAB then modr:=3 else modr:=0;  tt:=0;
for x := 1 to meanies[loct].numatt do begin
   hitter:=determine_hit(modr+meanies[loct].level-player.armorclass);
   if hitter > STANDARD-1 then begin
   repeat tt:=tt+1;
if mon_mismel[loct] then damag:=random(meanies[loct].mis_maxdam-1)+meanies[loct].mis_mindam
       else damag:=random(meanies[loct].maxdam-1)+meanies[loct].minddam;
   if tt = 150 then halt;
    until (damag < 300) and (damag > -1);
     say_saying('The '+meanies[loct].name+' #'+cstr(loct)+' Hits for '+cstr(damag)+' Points of Damage');
     player.act_hitpoints:=player.act_hitpoints-damag;
     check_player_death;
     display_char_hp;
  end else
     say_saying('The '+meanies[loct].name+' #'+cstr(loct)+' Misses!');
end;
end;

procedure do_player_saving_throw(var dama : integer);
begin
if random(100)+player.level*6+player.stats[6] > 90 then
  begin say_saying('You made your saving throw!');
     dama:=dama div 2; end else say_saying('You missed your saving throw!');
end;

procedure mon_magic(loct: integer);
var temp: magic_staff;
     x,sum : integer;
begin
temp:=magici[meanies[loct].level]; sum:=0;
if random(100) > temp.success+(2*meanies[loct].level)
  then begin say_saying(Meanies[loct].Name+' Fails to Cast Spell Sucessfully!');
     meanies[loct].spoints:=meanies[loct].spoints-temp.spcost; display_monsters(loct);
       end
          else begin
                for x:=1 to temp.damage do
                     sum:=random(7)+1+sum;
                do_player_saving_throw(SUM);
                player.act_hitpoints:=player.act_hitpoints-sum;
                meanies[loct].spoints:=meanies[loct].spoints-temp.spcost;
          say_saying('The '+meanies[loct].name+' casts a spell for '+cstr(sum)+' Points of Damage');
                display_char_hp;
                check_player_death;
          end;
end;

procedure mon_mis_opt(loca : integer);
begin
if meanies[loca].spoints < magici[meanies[loca].level].spcost then
   if meanies[loca].range < (random(100)+1) then close_mon_melee(loca)
   else shoot_mon_missile(loca)
else mon_magic(loca);
end;

procedure melee_opt(loca : integer);
begin
if meanies[loca].spoints < magici[meanies[loca].level].spcost then
    shoot_mon_missile(loca) else mon_magic(loca);
end;

procedure monster_attack;
var x : integer;
begin
for x:= 1 to number do
 if mon_dead[x] = false then
  if mon_mismel[x] then mon_mis_opt(x) else melee_opt(x);
end;

procedure do_combat;
var temp,playeri,mons : integer;
begin
say_saying('Round Number '+cstr(cround)+' of Combat!');
player.total_moves:=player.total_moves+1;
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
turned:=false; dialcnt:=18;
assign_monster; finished:=false;
display_screen;
display_char;
for counter :=1 to number do display_monsters(counter);
repeat
  do_combat; cround:=cround+1;
until finished;
end;

procedure do_other_wandering;
type ytems = STRING[80];
type mm = record
      usermouth : string[25];
      saying : string[80];
    end;

  procedure do_a_trap;
  var xxx:char;
     Procedure check_player_death2;
     var temr : integer;
     begin
       if player.act_hitpoints < 0 then begin
          player.act_hitpoints:=1;
             player.goldpieces:=0;
                temr:=random(6)+1;
                player.stats[temr]:=player.stats[temr]-1;
               say_saying('You Character has Been Killed -- Do NOT hang up it has already been saved!');
               say_saying('Your gold has been taken and you have lost 1 point of '+stat_name[temr]+'.');
               halt;
               end;
     end;
     procedure pit;
     var damag,x:integer;
     begin damag:=0;
       for x:=1 to player.dungeon_level do
         damag:=damag+random(6)+1;
         player.act_hitpoints:=player.act_hitpoints - damag;
         if player.stats[4] > random(100) then damag:=damag div 2;
         say_saying('You have Fallen into a Pit!');
         say_saying('You take '+cstr(damag)+' Points of Damage!');
         check_player_death2;
         say_saying('You are delayed by 15 movement points getting out!');
         player.total_moves:=player.total_moves+15;
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
         check_player_death2;
      end else begin
      say_saying('Your Armor is drained by a magical bonus of -1!');
      player.equiparmor.magical:=player.equiparmor.magical-1;
      if player.equiparmor.magical < -1 then player.equiparmor.magical:=-1;
      end;
      end;
end;
 procedure wanderman;
 var ggg,bonus : byte;
     itemname:string[30]; modis,coster : integer;
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
                 coster:=player.equipweapon.cost + ((450+modis)* bonus); end;
             2 : begin {mis wea} itemname:=player.equipmis.name; bonus:=player.equipmis.magical+1;
                 coster:=player.equipmis.cost + ((450+modis)* bonus); end;
             3 : begin {armor} itemname:=player.equiparmor.name; bonus:=player.equiparmor.magical+1;
                 coster:=player.equiparmor.cost + ((450+modis)* bonus); end;
           end;
       clear_space; dialcnt:=18;
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

procedure speedman;
begin
say_saying('A traveling Elf offers to speed up your missile weapon by 1 additional');
say_saying('attack per round!  He charges 1000 gold pieces for the service!');
say_saying('You have '+cstrr(player.goldpieces,10)+' Gold Pieces (YN)'); ansic(4);
onek(ginput,'YN'); if ginput='Y' then
    if player.goldpieces < 1000 then say_saying('Not Enough Funds!  Maybe Later...')
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
           say_saying('where the name comes from a heroine of great beauty and love.');
       end;
end;



begin
if dialcnt > 18 then begin clear_space; dialcnt:=18; end;
say_saying('A SPECIAL EVENT -- PRESS "A" TO SEE WHAT HAPPENS!!!!!!!!'); ansic(7);
onek(xxx,'A');
if player.dungeon then
    case (random(4)+1) of
       1 : pit;
       2 : cage;
       3 : stone_block;
       4 : acid;
    end;
if player.outdoor then
    case (random(4)+1) of
       1 :pit;
       2 :wanderman;
       3 :speedman;
       4 :bard;
     end;
end;

begin
do_a_trap;
end;

procedure sell_potion;
var choicer: char;

procedure give_list_pot;
var x:char; g1: file of char; tt:integer;
begin
cls; assign(g1,'POTION.ANS');  reset(g1); x:='p';
while x <> '*' do begin
   read(g1,x); ansic(4); if x<>'*' then write(x);
end; close(g1);
for tt:=1 to 8 do begin
  goto_xy(5+tt,50); ansic(3); write(cstr(player.exemptions[42+tt]));
  end;
end;

procedure purchase_potion;
var yyy:char; tvt:helper; junk,quant,xx:integer;
begin
nl; nl; ansic(4); writeln('No more than 255 for any potion!');
ansic(4); write('Which do you wish to purchase? (0,1..8) (0 for None)');
ansic(4); onek(yyy,'021345678'); nl;
if yyy<>'0' then begin
 ansic(4); writeln('You have '+cstrr(player.goldpieces,10)+' Gold Pieces');
 ansic(4); write('How Many Do you Wish to Purchase? (1..255)');
 ansic(3); input(tvt,3);
 val(tvt,quant,junk); xx:=ord(yyy)-48;
 if player.goldpieces < (potion_array[xx].cost*quant) then begin
    ansic(3); writeln('You Don''t have enough Gold for that!'); end else
  if quant < 1 then begin
    ansic(3); writeln('Are you trying to Cheat?');
    end else
    if player.exemptions[42+xx]+quant>255 then begin
     ansic(4); writeln('That''s over 255, you can''t carry that much!') end
     else begin
   player.exemptions[42+xx]:=player.exemptions[42+xx]+quant;
   player.goldpieces:=player.goldpieces-(potion_array[xx].cost * quant);
   end;
end;
end;

begin
say_saying('Welcome -- to '+town_stuff.pot_name);
say_saying('Do You Wish to Buy Potions? (Y/N)'); onek(choicer,'YN');
  if choicer='Y' then
  repeat
    give_list_pot;
    purchase_potion;
    ansic(3); write('Do You Wish to Buy Any More? (Y/N)'); onek(choicer,'YN');
    until choicer='N';
end;

function caryatid : BOOLEAN;
begin
ansic(4); goto_xy(22,1); write('I Thought I told you not to TOUCH the Statues!');
pausescr;
ansic(4); goto_xy(22,1); write('Suddenly the Statue comes alive and is ready to do Battle!');
pausescr;
if player.level > 6 then caryatid:=true else caryatid:=false;
end;

procedure check_for_new_level;
var x,y : integer;
 procedure increase_stats;
 var x: integer;
    let : char;
begin
 for x := 1 to 3 do begin goto_xy(17,1);
  cls; ansic(4); writeln('You May Now Increase any 3 Stats, hit the corresponding Letter:');nl;
  writeln(' A.  Stength      '+cstr(player.stats[1]));
  writeln(' B.  Intelligence '+cstr(player.stats[2]));
  writeln(' C.  Wisdom       '+cstr(player.stats[3]));
  writeln(' D.  Coordination '+cstr(player.stats[4]));
  writeln(' E.  Health       '+cstr(player.stats[5]));
  writeln(' F.  Personality  '+cstr(player.stats[6]));
     ansic(4); write('Letter:  ');
     onek(let,'ABCDEF');
     case let of
       'A'  :begin player.stats[1]:=player.stats[1]+1; act_stats[1]:=act_stats[1]+1; end;
       'B'  :begin player.stats[2]:=player.stats[2]+1; act_stats[2]:=act_stats[2]+1; end;
       'C'  :player.stats[3]:=player.stats[3]+1;
       'D'  :begin player.stats[4]:=player.stats[4]+1; act_stats[4]:=act_stats[4]+1; end;
       'E'  :player.stats[5]:=player.stats[5]+1;
       'F'  :player.stats[6]:=player.stats[6]+1;
     end;
end;
if (player.level mod 5 = 0) then begin player.numatt:=player.numatt+1;
  act_stats[5]:=player.numatt;
  say_saying('Great Work! You Now Have an Additional Attack per Round');
 end;
end;

begin
if player.experience > player.needed_exp-1 then begin  {gained level!}
   player.needed_exp:=2*player.needed_exp;
   player.level:=player.level+1; y:=0;
   say_saying('Congratulations! You have gained a Level!');
   say_saying('You are now Level:  '+cstr(player.level));
   say_saying('You now need '+cstrr(player.needed_exp,10)+' Experience Points');
   case player.class of
      1 :  x:=random(10)+10;
      2 :  begin x:=random(7)+6; y :=random(20)+12 + modifier(player.stats[2]); end;
      3 :  x:=random(8)+8;
      4 :  x:=random(8)+8;
      5 :  x:=random(12)+12;
      6 :  begin x:=random(12)+15; y:=random(24)+10 + modifier(player.stats[2]); end;
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
player.total_moves:=player.total_moves+10;
end;
end.
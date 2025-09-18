{$O+,F+}
unit bank;
interface
uses common,globals;
procedure auto_map_view;
procedure get_screen;
function do_a_bridge(var j,k,l,m,n: BYTE) : boolean;
function determin_combat(xx,yy : integer) : byte;
procedure load_rooms;
procedure check_food_supply;
procedure enter_dun_this_way(x1,y1: BYTE);
procedure enter_dungeon_check(var tt : byte);
procedure load_dungeon(modx,mody : integer);
procedure enter_city;
procedure read_weapons;
procedure whats_so_special(ghi : byte);
procedure Do_general_store;
procedure init_names;
procedure enter_tavern;
procedure create_for_real;
procedure get_city_info;
procedure welcome;
implementation

procedure read_weapons;
var g7:file of weapons; g5: file of potions;
g2:file of armors;
g3:file of magic_staff;
g4:file of monsters;
nerd:integer;
begin
assign(g7,'weapons.dat'); reset(G7);
for nerd:=0 to 10 do
read(g7,weapon[nerd]);
close(g7);
assign(g2,'armor.dat'); reset(g2);
for nerd:=0 to 5 do
read(g2,armor[nerd]);
close(g2);
assign(g3,'magic.dat'); reset(g3);
for nerd:=0 to 10 do
read(g3,magici[nerd]);
close(g3);
assign(g4,'monster.dat'); reset(g4);
for nerd:=1 to 50 do
read(g4,monster_array[nerd]);
close(g4);
assign(g5,'POTIONS.DAT'); reset(g5);
for nerd:=1 to 8 do read(g5,potion_array[nerd]); close(g5);
end;

procedure Do_general_store;

   procedure do_gs_options;
   begin
cls;
talk(7,'WELCOME TO '+town_stuff.gen_name+' GENERAL STORE!');nl;nl;nl;
talknl(7,' ษอออออออออออออออออออออออออออออออออป');
talk(7,' บ (');
talk(4,'A');
talknl(7,')rmor, purchase               บ');
talk(7,' บ (');
talk(4,'F');
talknl(7,')ood, purchase                บ');
talk(7,' บ (');
talk(4,'L');
talknl(7,')eave Store                   บ');
talk(7,' บ (');
talk(4,'M');
talknl(7,')agic Spells,purchase         บ');
talk(7,' บ (');
talk(4,'V');
talknl(7,')iew Your Character           บ');
talk(7,' บ (');
talk(4,'W');
talknl(7,')eapons, purchase             บ');
talknl(7,' ศอออออออออออออออออออออออออออออออออผ');nl;nl;
nl;
end;


procedure food_purchase;
var gg : char; purchar : helper;
    coster,max_pur,sprice,shit : integer;
begin
sprice:=town_stuff.price_mod*5;
max_pur:=99-player.food;
talknl(7,'You currently have '+cstr(player.food)+' rations!');
talk(7,'Would you be interested in purchasing some more? (Y/N)');
ansic(4); onek(gg,'YN'); if gg='Y' then begin
    talknl(5,'I charge '+cstr(sprice)+'per ration!');
    talknl(5,'How many do you want to buy (0-'+cstr(max_pur)+'): '); ansic(3);
    input(purchar,2); coster:=value(purchar);
    if (coster<1) or (coster>max_pur) then talknl(5,'INVALID INPUT')
       else
           if (coster*sprice) > player.goldpieces then talknl(8,'You can''t afford that!')
              else begin
                 player.food:=coster+player.food;
                 player.goldpieces:=player.goldpieces-(coster*sprice);
                 talknl(7,'You now have '+cstr(player.food)+' Rations!');
              end;
   end;
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

procedure display_magici(choici:integer);
begin
if (choici > 0) and (choici < 11) then begin
talk(3,'Name             :'+magici[choici].name); nl;
talk(3,'Maximum Damage   :'+cstr(magici[choici].damage*8)); nl;
talk(3,'Gold Piece Cost  :'+cstrr(magici[choici].cost,10)); nl;
talk(3,'Success Chance   :'+cstr(magici[choici].success)+'%'); nl;
talk(3,'Spell Point Cost :'+cstr(magici[choici].spcost)); nl;
pausescr;
end; end;

procedure display_armor(choici:integer);
begin
if (choici > 0) and (choici < 6) then begin
talknl(6,armor[choici].name);
talknl(3,'Protection Value: '+cstr(armor[choici].protect));
talknl(3,'The Cost of the Armor is : '+cstr(armor[choici].cost)+' Gold Pieces');
talknl(3,'The Magical Bonus is: +'+cstr(armor[choici].magical));
pausescr;
end; end;

procedure display_weapon(choici:integer);
begin
if (choici > 0) and (choici < 11) then begin
talknl(6,weapon[choici].name);
if weapon[choici].melee= true then talknl(3,'This Weapon is a Melee Weapon')
   else talknl(3,'This Weapon is a Missile Weapon');
talknl(3,'Maximum Damage:  '+cstr(weapon[choici].dam));
if weapon[choici].h2h = true then talknl(3,'Two Handed Weapon');
talknl(3,'The Magical Bonus is: +'+cstr(weapon[choici].magical));
talknl(3,'Cost:  '+cstr(weapon[choici].cost));
talknl(3,'Number of Attacks per Round: '+cstr(weapon[choici].numat));
pausescr;
end; end;

procedure list_view;
begin
talknl(4,'Equipped Weapon : '+player.equipweapon.name);
talknl(4,'Equipped Armor  : '+player.equiparmor.name);
talknl(4,'Equipped Staff  : '+player.equipmagic.name);
talknl(4,'Equipped Missile: '+player.equipmis.name);
end;

procedure do_information_regitem(V:char);
var choice:char; foundit:boolean;
scount7,shit,choici:integer;
tiddley:string[1];
clearer:boolean;
begin
talk(5,'Enter Corresponding ID Number: ');
onek(choice,'0123456789');foundit:=false;
choici:=ord(choice)-48; str(player.class,tiddley);
if v='W' then display_weapon(choici) else display_armor(choici);
end;

procedure determine_armorclass;
var y:integer;
begin
player.armorclass:=0;
player.armorclass:=player.equiparmor.protect+player.equiparmor.magical;
player.armorclass:=player.armorclass+modifier(player.stats[4]);
if player.armorclass<0 then player.armorclass:=0;
end;

procedure sell_item;
    procedure display_offer(typer:char);
     var choicer:char;
       price:real;
       whichone,x:integer;
     begin
price:=0;
if typer='A' then if player.equiparmor.idnum>0 then price:=player.equiparmor.cost+player.equiparmor.magical*10;
if typer='S' then if player.equipmagic.idnum>0 then price:=player.equipmagic.cost;
if typer='M' then if player.equipmis.idnum>0 then price:=player.equipmis.cost+
    player.equipmis.magical*10;
if typer='W' then if player.equipweapon.idnum>0 then price:=player.equipweapon.cost+player.equipweapon.magical*10;
     price:=price*0.5;
talknl(4,'I will give you '+cstrr(price,10)+' Gold Pieces for that item!');
   talk(4,'Do you Accept? (Y/N)');
   onek(choicer,'YN');
  if choicer='Y' then begin
  talknl(7,'SOLD!!'); pausescr;
  player.goldpieces:=player.goldpieces+price;
  delete_item(typer); determine_armorclass;
  end;
end;

var maxcount,choici,itemp,whichone:integer;
    choice:char;
begin
talknl(5,'Enter:   A:  Armor');
talknl(5,'         S:  Magic Staff ');
talknl(5,'         M:  Missile Weapon');
talknl(5,'         W:  Weapon');
talknl(5,'         N:  None');
talknl(5,'Enter Number (N to exit): '); ansic(5);
onek(choice,'AMHWN');
if choice<>'N' then display_offer(choice);
end;

procedure purchase_it(location:integer; which_char:char);
var x,joke:integer;
begin
nl;
if which_char='W' then
if player.goldpieces<weapon[location].cost then
talknl(6,'You Cannot Afford That') else begin
talknl(5,'You Have Purchased the '+weapon[location].name);
if weapon[location].melee=false then
player.equipmis:=weapon[location]
else player.equipweapon:=weapon[location];
player.goldpieces:=player.goldpieces-weapon[location].cost;
end;
if which_char='A' then
if player.goldpieces<armor[location].cost then
talknl(6,'You Cannot Afford That')
else begin
talknl(5,'You Have Purchased the '+armor[location].name);
player.equiparmor:=armor[location];
player.goldpieces:=player.goldpieces-armor[location].cost;
determine_armorclass;
end;
if which_char='M' then
if player.goldpieces<magici[location].cost then
talknl(6,'You Cannot Afford That') else begin
talknl(5,'You Have Purchased the '+magici[location].name);
player.equipmagic:=magici[location];
player.goldpieces:=player.goldpieces-magici[location].cost;
end;
end;

procedure purchase_weapon;
var grabit,choice,tiddley:char;
    count4,choici:integer;
begin
talk(5,'Enter Corresponding ID Number: ');
onek(choice,'01234567');
choici:=ord(choice)-48;
tiddley:=chr(player.class+48);
if pos(tiddley,weapon[choici].classrest) > 0 then begin
display_weapon(choici);
talk(4,'Gold Pieces:  '+cstrr(player.goldpieces,10));
nl; talk(5,'Do You Wish to Purchase It? (Y/N)');
onek(grabit,'YN'); nl;
if grabit='Y' then purchase_it(choici,'W'); end else
  talknl(5,'You Cannot Use That!');
end;

procedure purchase_armor;
var count4,choici:integer; grabit,choice,tiddley:char;
begin
talk(5,'Enter Corresponding ID Number: ');
onek(choice,'012345');
choici:=ord(choice)-48;
tiddley:=chr(player.class+48);
if pos(tiddley,armor[choici].class_rest) > 0 then begin
display_armor(choici);
talknl(5,'Gold Pieces:  '+cstrr(player.goldpieces,10));
nl;talk(6,'Do You Wish to Purchase It? (Y/N)');
onek(grabit,'YN');
if grabit='Y' then purchase_it(choici,'A'); end else
  talknl(5,'You Cannot Use That!');
end;

procedure purchase_magici;
var choice:helper;foundit:boolean;
shit,count,choici:integer; grabit:char;
begin
repeat
talk(5,'Enter Corresponding ID Number: '); ansic(5);
input(choice,2);foundit:=false;
choici:=value(choice);
until (choici>0) and (choici<11);
display_magici(choici);
talknl(5,'Gold Pieces:  '+cstrr(player.goldpieces,10));
nl;talk(6,'Do You Wish to Purchase It? (Y/N)');
onek(grabit,'YN');
if grabit='Y' then purchase_it(choici,'M');
end;

procedure do_weapon_list;
var  falser:boolean; row,temp,temp2:integer;modi:integer;
buthole:string[1];dung:string[2];
choicer:char;
  procedure show_weapons;
  var nerd,counter : integer;
  begin
  row:=4;cls;str(player.class,buthole);
  talknl(4,'Weapons Available:  ');
  talknl(4,'ID #  NAME');nl;
  goto_xy(row+1,1);
    for nerd:=1 to 10 do begin
     falser:=false;
     for counter:=1 to length (weapon[nerd].classrest) do
     if (buthole=weapon[nerd].classrest[counter]) then
     falser:=true;
    if falser=true then begin
     row:=row+1;
    talk(4,cstr(weapon[nerd].idnum)+': '+weapon[nerd].name);
    goto_xy(row,22);
    talk(4,cstr(weapon[nerd].cost));
   if row>23 then row:=24;
    goto_xy(row,36); talknl(3,'GPS.');
    end;
   end;
talknl(4,'(I)nformation on a Weapon');
talknl(4,'(L)eave Weaponry Section');
talknl(4,'(P)urchase a Weapon');
talknl(4,'(S)ell a Weapon');
end;

begin
show_weapons;
repeat  nl;
talk(4,'Choice: ILPS? :'); ansic(4);
onek(choicer,'ILPS?');
  case choicer of
  'I':do_information_regitem('W');
  'P':purchase_weapon;
  'S':sell_item;
  '?':show_weapons;
  end;
 until choicer='L';
end;

procedure do_information_magici;
var choice:helper;
shit, count,choici:integer;
 tiddley:string[1];
begin
talk(5,'Enter Corresponding ID Number: ');
repeat
ansic(5);  input(choice,2);
choici:=value(choice); str(player.class,tiddley);
until (choici<11) and (choici>0);
display_magici(choici)
end;

procedure do_magic_list;
var  falser:boolean; row,temp,temp2:integer;modi:integer;
buthole:string[1];dung:string[2];
choicer:char;
   procedure show_magici;
    var nerd,counter : integer;
    begin
    row:=4;cls;str(player.class,buthole);
    talknl(4,'Magic Staves Types Available:  '); talknl(4,'ID #  NAME');nl;
    for nerd:=1 to 10 do begin goto_xy(row+1,1); row:=row+1;
    talk(4,cstr(magici[nerd].idnum)+': '+magici[nerd].name); goto_xy(row,32);
    talk(3,cstrr(magici[nerd].cost,10)); goto_xy(row,47); talknl(3,'GPS.');
    end;
talknl(4,'(I)nformation on a Staff');
talknl(4,'(L)eave Magic Staff Section');
talknl(4,'(P)urchase Staff');
talknl(4,'(S)ell A Staff');
end;
begin
show_magici;
repeat nl;
talk(4,'Enter Choice (ILPS?):  '); ansic(3);
onek(choicer,'ILPS?');
case choicer of
 'I':do_information_magici;
 'P':if (player.class=2) or (player.class=6) then purchase_magici
     else begin talknl(3,'You are not a Magic User'); pausescr;end;
 'S':sell_item;
 '?':show_magici;
end;
until choicer='L';
end;

procedure do_armor_list;
var  falser:boolean; row,temp,temp2:integer;modi:integer;
buthole:string[1];dung:string[2];
  choicer:char;
   procedure show_armor;
    var nerd,counter : integer;
    begin
    row:=4;cls;str(player.class,buthole);
    talknl(4,'Armor Types Available:  ');
    talknl(4,'ID #  NAME');nl; goto_xy(row+1,1);
    for nerd:=0 to 5 do begin falser:=false;
    for counter:=1 to length (armor[nerd].class_rest) do
    if (buthole=armor[nerd].class_rest[counter]) then falser:=true;
    if falser=true then begin row:=row+1;
    talk(4,cstr(armor[nerd].idnum)+': '+armor[nerd].name); goto_xy(row,22);
    talk(4,'  '+cstr(armor[nerd].cost));
    goto_xy(row,39); talknl(3,'GPS.');
    end;
 end;
talknl(4,'(I)nformation on a Armor');
talknl(4,'(L)eave Armory Section');
talknl(4,'(P)urchase Armor');
talknl(4,'(S)ell Your Armor');
end;

begin
show_armor;
repeat nl;
talk(4,'Enter Request Now (ILPS?):  '); ansic(3); onek(choicer,'ILPS?');
case choicer of
'I':do_information_regitem('A');
'P':purchase_armor;
'S':sell_item;
'?':show_armor;
end;
until choicer='L';
end;


var question:char;
yetter : integer;
begin
do_gs_options;
 for yetter:=0 to 10 do begin
  weapon[yetter].cost:=weapon[yetter].cost+(500*(town_stuff.price_mod-1));
   weapon[yetter].magical:=(town_stuff.price_mod div 1)-1;
end;
 for yetter:=0 to 5 do begin
armor[yetter].cost:=armor[yetter].cost+(500*(town_stuff.price_mod-1));
 armor[yetter].magical:=(town_stuff.price_mod div 1)-1;
 end;
 repeat
  talk(4,'Choice AFLMVW ,? ');
  ansic(3); onek(question,'AFLMVW?');nl;
  case question of
 '?':do_gs_options;
 'A':do_armor_list;
 'F':food_purchase;
 'M':do_magic_list;
 'V':view_initial_char;
 'W':do_weapon_list;
  end;
 player.total_moves:=player.total_moves+2;
until question='L';
determine_armorclass;
end;

procedure init_names;
       begin
stat_name[1]:='STR';
stat_name[2]:='INT';
stat_name[3]:='WIS';
stat_name[4]:='CRD';
stat_name[5]:='HTH';
stat_name[6]:='LCK';
stat_name[7]:='PER';
stat_name[8]:='SPT';
stat_name[9]:='HIT POINTS';
stat_name[10]:='HIT POINTS REM.';
stat_name[11]:='DEFENSE';
class_name[1]:='FIGHTER';
class_name[2]:='MAGIC USER';
class_name[3]:='PRIEST';
class_name[4]:='ROGUE';
class_name[5]:='DWARF';
class_name[6]:='ELF';
end;

procedure enter_tavern;
var chk:helper;
    choicer:char;
    maxbet,shit : integer;
procedure tavern_choices(var chk: helper);
begin
       talknl(8,'WELCOME TO '+town_stuff.tav_name);
       talknl(7,' ษอออออออออออออออออออออออออออออออออป');
       talk(7,' บ (');
       talk(4,'B'); ansic(7);
       talknl(7,')uy a Drink at Bar            บ');
       talk(7,' บ (');
       talk(4,'E');
       talknl(7,')xit Tavern                   บ');
       talk(7,' บ (');
       talk(4,'G');
       talknl(7,')amble                        บ');
       talknl(7,' ศอออออออออออออออออออออออออออออออออผ');nl;nl;
      end;

procedure gamble;
var  question:char;
   procedure dicing;
   var dice1,bet,numplayers :integer;
   totals:array [1..7] of integer; betstr:helper;

        procedure do_dicegame;
          var count,temp1,temp2: integer; tie:boolean; begin
          if bet>player.goldpieces then
             talknl(4,'Are you trying to cheat? <-- Don''t Answer This!')
             else begin
              for count:=1 to numplayers do begin
                  totals[count]:=random(6)+1+random(6)+1+random(6)+1;
                  if count=numplayers-1 then begin
                    totals[count]:=totals[count]+3;
                    if totals[count]>18 then totals[count]:=18;
                    end;
talknl(6,'Player #'+cstr(count)+' rolls a:'+cstr(totals[count]));
                  end;
                  totals[count+1]:=random(6)+1+random(6)+1+random(6)+1;
                  talknl(6,'You Rolled a:  '+cstr(totals[count+1]));
                  temp1:=totals[numplayers+1];
                  for count:=1 to numplayers do
                    if totals[count]>temp1 then
                       temp1:=totals[count];   {find max}
                       temp2:=0;
                  for count:=1 to numplayers+1 do
        {finds ties}if temp1=totals[count] then temp2:=temp2+1;
                    if temp2>1 then tie:=true else tie:=false;
           if tie=false then
             for count:=1 to numplayers+1 do
               if temp1=totals[count] then
                  if temp1=totals[numplayers+1] then begin
              talknl(5,'You win!!! '+cstr(numplayers*bet)+' Gold Pieces');
                  player.goldpieces:=player.goldpieces+bet*(numplayers);
                  count:=numplayers+1;end
                  else begin
                  talknl(5,'Player #'+cstr(count)+' wins');
                  player.goldpieces:=player.goldpieces-bet;
                  count:=numplayers+1;
                  end;
          if tie=true then
          talknl(6,'Nobody wins -- a Tie');
         end;
      end;

   begin
   numplayers:=random(5)+1; maxbet:=1000 * (town_stuff.price_mod+2);
talknl(4,'You see a group of '+cstr(numplayers)+' men playing dice.');
talknl(4,'You sit at the table with them.  A man with a mustache says,');
talknl(4,'"Maximum bet is '+cstr(maxbet)+' gold pieces.  If you decide to sissy');
talknl(4,'out on us just bet 0.  We roll three six sided dice here."');nl;nl;
   repeat
     talknl(5,'Make your bet ('+cstr(maxbet)+' max., 0 to quit)');
     talknl(4,'Gold Pieces:  '+cstrr(player.goldpieces,10));
     talk(4,'Bet: '); ansic(6);
     input(betstr,4);
     bet:=value(betstr);
     if (bet>0) and (bet<maxbet+1) then do_dicegame else
     if bet<>0 then talknl(5,'Illegal Bet!');
   until bet=0;
   end;

procedure slotting;
var slot1,slot2,slot3,bet:integer;
   question:helper;
   ch:char;

    procedure do_slots;
      var valuers: array[1..3] of integer;
          counters,totals:integer;

     procedure display_slots(x,count:integer);
           begin
           case x of
            1,2,3,4: begin talk(7,'ORC    '); valuers[count]:=1; end;
            5,6,7  : begin talk(5,'WITCH  '); valuers[count]:=3;end;
            8,9    : begin talk(4,'SWORD  '); valuers[count]:=5; end;
            10     : begin talk(3,'KING   '); valuers[count]:=8; end;
           end;
           end;

      begin
         slot1:=random(10)+1;
         slot2:=random(10)+1;
         slot3:=random(10)+1;
         talknl(3,'You pull back the Dragon Hide handle and you get....');
         display_slots(slot1,1);display_slots(slot2,2); display_slots(slot3,3);
         nl; totals:=valuers[1]+valuers[2]+valuers[3];
         if (valuers[1]=3) and (valuers[2]=5) and (valuers[3]=8) then begin
             bet:=bet*3;
             talknl(4,'Wow a straight, How Lucky!!');
            talknl(5,'You Win:  '+cstr(bet)+' Gold Pieces');
            player.goldpieces:=bet+player.goldpieces;
            end;
        if (valuers[1]=valuers[2]) and (valuers[2]=valuers[3]) then begin
            bet:=bet+bet*valuers[1];
            talknl(4,'Three in a Row, How Lucky!!');
            talknl(5,'You Win:  '+cstr(bet)+' Gold Pieces');
            player.goldpieces:=bet+player.goldpieces;
            end else
            if totals =21 then begin
            talknl(5,'Almost, but not quite!');
            bet:=bet*7;
            talknl(6,'You Win:  '+cstr(bet)+' Gold Pieces');
            player.goldpieces:=bet+player.goldpieces;
            end else
            if totals = 18 then begin
            talknl(5,'Almost, but not quite!');
            bet:=bet*4;
            talknl(6,'You Win:  '+cstr(bet)+' Gold Pieces');
            end else
            begin
            talknl(4,'Not much in that spin -- be sure and try again');
            player.goldpieces:=player.goldpieces-bet;
            end;
          end;
  begin
    maxbet:=25*(town_stuff.price_mod+2);
    talknl(5,'You walk over to the slots.  You can bet from');
    talknl(5,'1-'+cstr(maxbet)+' Gold Pieces');
    repeat
    talknl(3,'You have '+cstrr(player.goldpieces,10)+' Gold Pieces');
    talknl(5,'Enter 0 to exit the Slotting Area.'); talk(5,'Amount Bet: ');
    ansic(6); input(question,2);
    bet:=value(question);
     if bet > player.goldpieces then talknl(5,'NO CHEATING FOOL!') else
       if (bet > 0) and (bet<maxbet+1) then do_slots else
         if bet <> 0 then talknl(5,'Illegal Bet!');;
    until bet=0;
end;

var ch:char;
begin
nl;nl;
repeat
talknl(5,'Do you wish to play (D)ice or (S)lots? (Q to quit)');
talk(3,'Choice : '); ansic(5); onek(ch,'QDS');
case ch of
   'D' : dicing;
   'S' : slotting;
  end;
until ch='Q';
end;


procedure buy_drink;
  type rumor = record
        crappy : string[72];
       end;
  var cost,temp2,temp3:integer;
      choice: char; rumors : rumor;
      g1:file of rumor;
  begin
  if player.goldpieces<1 then
     talknl(4,'Gulliver says, "Are you trying to freeload?  You have no money!"')
     else begin nl;
       talknl(4,'You have '+cstrr(player.goldpieces,10)+' Gold Pieces');
       temp2:=modifier(player.stats[7])+10;
       cost:=temp2 + (10 * town_stuff.price_mod);
       if cost < 1 then cost:=1;
       talknl(4,'A drink costs '+cstr(cost)+' Gold Pieces');
       talk(5,'Wish to buy? (Y/N)'); ansic(3); onek(choice,'NY');
       if (choice='Y') and (player.goldpieces > cost-1) then begin
          player.goldpieces:=player.goldpieces-cost;
          talknl(4,'You now have '+cstrr(player.goldpieces,10)+' Gold Pieces');
          cost:=random(100)+1;
          if cost < (20+player.stats[6]+player.level) then begin
             assign(g1,'rumors.dat');
             reset(g1);
             cost:=random(75);
             seek(g1,cost);
             read(g1,rumors);
             talknl(4,rumors.crappy); close(g1);
          end else
          talknl(4,'You buy your ale and enjoy the atmosphere.');
      end;
  end;
  nl;nl;
  end;

begin
cls; chk:='BEG?';
tavern_choices(chk);
repeat
talk(4,'Choice: ,? ');
onek(choicer,chk);
case choicer of
  '?':tavern_choices(chk);
  'G':begin gamble; tavern_choices(chk); end;
  'B':begin buy_drink; tavern_choices(chk); end;
  end;
until choicer='E';
end;


procedure create_for_real;
var i,count:integer;
 ok:boolean;
 chk : string[6];
 procedure roll_stats;
    var x,holder:integer;
    begin
    for x:=1 to 8 do begin
     talk(3,stat_name[x]+'  = ');
     holder:=random(20)+5;
     player.stats[x]:=holder;
     talknl(5,cstr(holder));
   end;
    nl; nl;
    talknl(5,'Rerolls Left: '+cstr(count));
    end;

 procedure ask_question(var done : boolean;var counter : integer);
 var question:char;
 begin
  nl;
  talk(6,'Do you wish to reroll [Y/N]?  '); onek(question,'YN');
  if question='N' then ok:=true else counter:=count-1; nl;
  end;
 procedure choose_class;
  begin
 nl; chk:='';
 talknl(5,'The classes you can be are:');
 if player.stats[1]>4 then begin
 talknl(3,'1.  Fighter'); chk:=chk+'1'; end;
 if (player.stats[2]>14) and (player.stats[8]>10) then begin
 talknl(3,'2.  Magic User'); chk:=chk+'2'; end;
 if player.stats[3]>14 then begin
 talknl(3,'3.  Priest    '); chk:=chk+'3'; end;
 if (player.stats[4]>12) and (player.stats[7]>12) then begin
 talknl(3,'4.  Rogue    '); chk:=chk+'4'; end;
 if (player.stats[1]>20) and (player.stats[5]>18) then begin
 talknl(3,'5.  Dwarf '); chk:=chk+'5'; end;
 if (player.stats[2]>18) and (player.stats[4]>18) and (player.stats[8]>15) then begin
 talknl(3,'6.  Elf'); chk:=chk+'6'; end;
end;

procedure pick_class;
var question:char; x: byte;
    class_choosen: boolean; namer : helper;
begin
class_choosen:=false;
repeat
nl; talk(5,'Enter Number of Class You Want: ');
onek(question,chk);
x:=ord(question)-48;
talk(5,'Are you Sure You Want To Be a ');
talk(6,class_name[x]+'? ');
onek(question,'YN');
if question='Y' then class_choosen:=true;
until class_choosen;
player.class:=x;
if (player.class=2) or (player.class=6) then player.spells:=true else
  player.spells:=false;
if player.spells = false then player.stats[8]:=0;
player.act_spellpoints:=player.stats[8];
talk(5,'Enter Character''s Name (25 Chars Max): ');
input(namer,25);
player.name:=namer;
end;

procedure do_hitpoints;
var temp:integer;
begin
case player.class of
1:  player.maxhitpoints:=30;
2:  player.maxhitpoints:=20;
3:  player.maxhitpoints:=27;
4:  player.maxhitpoints:=25;
5:  player.maxhitpoints:=30;
6:  player.maxhitpoints:=25;
end;
with player do begin
maxhitpoints:=maxhitpoints+random(6)+1;
Act_hitpoints:=maxhitpoints;
end;
end;

procedure do_initial_gold;
var x: integer;
begin
with player do begin
 case class of
 1:  goldpieces:=250+random(50);
 2:  goldpieces:=150+random(10);
 3:  goldpieces:=200+random(25);
 4:  goldpieces:=150+random(100);
 5:  goldpieces:=200+random(25);
 6:  goldpieces:=200+random(50);
end;
experience:=0; numatt:=1; xactual:=0; yactual:=0; moves:=1;
dungeon_level:=0; level:=1;armorclass:=0; xmap:=0; ymap:=0;
for x:=1 to 100 do exemptions[x]:=0; exemptions[43]:=random(3)+1;
for x:=1 to 255 do door_exemps[x]:=0;
outdoor:=false; city:=true; dungeon:=false; total_moves:=0.0;
outyact:=5; outxact:=10; outxmap:=5; outymap:=5;
food:=25; memory:='                                  ';
case player.class of
 1:  player.needed_exp:=2000;
 2:  player.needed_exp:=2500;
 3:  player.needed_exp:=1500;
 4:  player.needed_exp:=1000;
 5:  player.needed_exp:=2500;
 6:  player.needed_exp:=3000;
end;
end;
end;

var xy:integer;
begin
ok:=false; count:=15;
cls;
player.equiparmor:=armor[0];
player.equipweapon:=weapon[0];
player.equipmis:=weapon[0];
player.equipmagic:=magici[0];
repeat
 roll_stats;
 choose_class;
 ask_question(ok,count);
until ok or (count=0); if count=0 then halt;
pick_class;
do_hitpoints;
do_initial_gold;
view_initial_char;
end;

procedure get_city_info;
var g2:file of town_rec;
begin
assign(g2,'TOWNDATA.PIT');
reset(g2);
repeat
  read(g2,town_stuff);
until (town_stuff.x=player.outxact) and (town_stuff.y=player.outyact);
close(g2);
end;

procedure welcome;
begin
cls; talknl(3,'Welcome to '+town_stuff.city_name); nl;
nl;
talk(4,'Your Choices Brave ');
talknl(5,player.name);
talknl(3,'(B)oating -- if port');
talknl(3,'(C)hat with People!');
talknl(3,'(G)eneral Store');
talknl(3,'(L)eave Town!');
talknl(3,'(P)urchase Potions');
talknl(3,'(Q)uit and Save');
talknl(3,'(S)ave Character -- No Quit');
talknl(3,'(T)avern       ');
talknl(3,'(V)iew Character');
end;

procedure enter_city;
var ttext: char;
begin
say_saying('Do You Wish to Enter the City? (Y/N):');
ansic(5); onek(ttext,'NY');
if ttext='Y' then begin exitter:=true; player.outdoor:=false; player.city:=true; end;
end;

procedure load_dungeon(modx,mody : integer);
var du_file : file of dun_rec;
begin
assign(du_file,'DUNGEON.INF');
reset(du_file);
repeat
  read(du_file,dungeon_stuff);
until (dungeon_stuff.dlocx=player.outxact+modx) and (dungeon_stuff.dlocy=player.outyact+mody);
close(du_file);
end;

procedure enter_dungeon_check(var tt : byte);
var tinput : char; x,y: byte;
    t1 : array [1..3] of helper;

begin
clear_space; y:=0;
say_saying('Do you wish to Enter the Dungeon '+dungeon_stuff.dname);
say_saying('(Y)es/(N)o (Remember you will need the magic words!): ');
ansic(5); onek(tinput,'YN'); if tinput ='N' then tt:=0 else begin
    clear_space; dialcnt:=18;
    say_saying('Please Enter the THREE Magic Words Needed to Enter (one at a time)');
    say_saying('These are obtained from town''s people or other places...');
    for x:=1 to 3 do begin
      say_saying('Enter Word Number '+cstr(x)+':');
      input(t1[x],3);
    end;
    if player.exemptions[dungeon_stuff.ttoggle] <> 1 then begin
       clear_space;
       say_saying('I did NOT check the validity of your inputs...');
       say_saying('You must talk to a villager to get these words, not from another');
       say_saying('player  -= Be sure and Read the DOCS next time! =- ');
       tt :=1;
    end else begin
      for x:=1 to 3 do
           if t1[x]=dungeon_stuff.dwords[x] then y:=y+1;
      if y=3 then begin say_saying('The doors to the dungeon open inward!');
         tt:=2;
      end else begin say_saying('Those are NOT the correct words!'); tt:=3;
      end;
    end;
end;
end;

procedure enter_dun_this_way(x1,y1: BYTE);
begin
player.outxact:=player.outxact+x1;
player.outyact:=player.outyact+y1;
player.dungeon_level:=dungeon_stuff.dnum;
player.xactual:=dungeon_stuff.xactual;
player.yactual:=dungeon_stuff.yactual;
player.xmap:=dungeon_stuff.xmap;
player.ymap:=dungeon_stuff.ymap;
player.outdoor:=false;
exitter:=true;
player.dungeon:=true;
end;

procedure check_food_supply;
begin
if player.food=0 then begin
   say_saying('You are OUT OF FOOD!!!  You are wounded now and out of moves!');
   moves:=0; player.act_hitpoints:=player.act_hitpoints-player.act_hitpoints div 4; pausescr;
  if player.act_spellpoints>0 then player.act_spellpoints:=player.act_spellpoints-player.act_spellpoints div 2;
   moves:=0; end
  else begin player.food:=player.food-1;
       say_saying('1 Food Ration Consumed, you have '+cstr(player.food)+' Food Left!');
end;
end;

procedure load_rooms;
 var x,yx : byte; temp:char;
     f1: file of dun_room;
     filename:string[10];
  begin
  for x:=1 to 75 do dung_room[x].dlocx:=0;
yx:=0;
temp:=chr(player.dungeon_level+48);
filename:='DUNRM'+temp+'.PIT';
assign(f1,filename);
reset(f1);
while not EOF(f1) do begin
yx:=yx+1;
read(f1,dung_room[yx]);
end;
close(f1);
end;

function determin_combat(xx,yy : integer) : byte;
var tt:byte;
begin
for tt:=1 to 75 do
  if dung_room[tt].dxmap=player.xmap then
    if dung_room[tt].dymap=player.ymap then
      if dung_room[tt].dlocx=player.xactual+xx then
        if dung_room[tt].dlocy=player.yactual+yy then begin
           determin_combat:=tt; tt:=76; end;
if tt=75 then begin writeln('ERROR, NOT FOUND!!!!!!!'); halt end;
end;

function do_a_bridge(var j,k,l,m,n: BYTE) : boolean;
var gg : char; coster:integer;
begin
j:=0;
if random(100) > 39 then begin
   n:=(player.level div 4)+1; if n>4 then n:=4; j:=2;
   k:=50; l:=50; m:=50;
   if n>1 then K:=16;
   if n>2 then l:=16;
   if n>3 then m:=16;
   if dialcnt > 18 then begin clear_space; dialcnt:=18; end;
   say_saying(cstr(n)+' Troll(s) step from underneath the bridge!');
   say_saying('You have '+cstrr(player.goldpieces,10)+' Gold Pieces!');
   coster:=((player.level div 2)+1) * 50 * n;
   say_saying('They will let you pass for '+cstr(coster)+' Gold Pieces!');
   say_saying('Do you (A)ccept, (F)ight them, (L)eave them.');
   ansic(4); onek(gg,'AFL');
   case gg of
     'A' : if player.goldpieces < coster then begin
                do_a_bridge:=true; j:=2; end
    else begin player.goldpieces:=player.goldpieces-coster; do_a_bridge:=false; end;
     'F' : begin do_a_bridge:=true; j:=2; end;
     'L' : begin j:=1; do_a_bridge:=false; end;
   end;
end else begin
    say_saying('Evidence of Trolls are noted near this bridge!');
    do_a_bridge:=false; J:=0;
end;
end;

procedure get_screen;
var x,y,xer,yer : integer;
 f1 : file of char;
 filename:string[12];
 temp1,temp2,temp3 : char;
begin
if player.dungeon then begin filename:='LVL';
temp1:=chr(player.dungeon_level+48);
temp2:=chr(player.xmap+48); temp3:=chr(player.ymap+48);
filename:=filename+temp1+temp2+temp3+'.DNG';
end else begin
  filename:='WILDER';
temp2:=chr(player.outxmap+48); temp3:=chr(player.outymap+48);
filename:=filename+temp2+temp3+'.PIT';
end;
assign(f1,filename);
reset(f1);
for x:=-5 to 85 do
 for y:=-5 to 28 do
 map[x,y]:=' ';
   for x:=0 to 79 do
     for y:=0 to 24 do
       auto_map[x,y]:=' ';
for y:=1 to 23 do
 for x:=1  to 80 do
  read(f1,map[x,y]);
for y:=1 to 23 do
for x:=1  to 80 do
 if map[x,y]='/' then map[x,y]:=' ';
close(f1);
end;

procedure auto_map_view;
var xx,yy: byte;
begin
cls; dialcnt:=18;
for xx:=1 to 23 do begin
 for yy:=1 to 78 do
   write(auto_map[yy,xx]);
   goto_xy(xx,1);
end;
end;

procedure whats_so_special(ghi : byte);
begin
case ghi of
   1  :  begin if dialcnt > 18 then begin clear_space; dialcnt:=18; end;
         say_saying('Congratulations... You have defeated the Kobold Chieftain!');
         say_saying('The Kobolds are no longer a threat to the Island Without');
         say_saying('their Leader.  Travel by ship is now safe!');
         end;
end;
end;

end.
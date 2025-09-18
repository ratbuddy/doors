overlay procedure read_weapons;
var g7:file of weapons; g5: file of potions;
g2:file of armors; g8 : file of ringer;
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
for nerd:=1 to 68 do
read(g4,monster_array[nerd]);
close(g4);
assign(g5,'POTIONS.DAT'); reset(g5);
for nerd:=1 to 9 do read(g5,potion_array[nerd]); close(g5);
assign(g8,'RINGS.DAT'); reset(g8);
for nerd:=0 to 19 do read(g8,ring[nerd]); close(g8);
end;


overlay procedure Do_general_store;

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
talknl(7,')agic Spells, purchase        บ');
talk(7,' บ (');
talk(4,'W');
talknl(7,')eapons, purchase             บ');
talknl(7,' ศอออออออออออออออออออออออออออออออออผ');nl;nl;
nl; display_gold; display_moves;
end;


procedure food_purchase;
var gg : char; purchar : str;
    coster,max_pur,sprice : integer;
begin
sprice:=town_stuff.price_mod*5;
max_pur:=99-player.food;
talknl(7,'You currently have '+cstr(player.food)+' rations!');
talk(7,'Would you be interested in purchasing some more? (Y/N)');
ansic(4); onek(gg,'YN'); if gg='Y' then begin
talknl(5,'I charge '+cstr(sprice)+' Gold Pieces per ration!');
talk(5,'How many do you want to buy (0-'+cstr(max_pur)+') -->'); ansic(3);
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
end; end;

procedure display_armor(choici:integer);
begin
if (choici > 0) and (choici < 6) then begin
talknl(6,armor[choici].name);
talknl(3,'Protection Value: '+cstr(armor[choici].protect));
talknl(3,'The Cost of the Armor is : '+cstr(armor[choici].cost)+' Gold Pieces');
talknl(3,'The Magical Bonus is: +'+cstr(armor[choici].magical));
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
end; end;

procedure list_view;
begin
talknl(4,'Equipped Weapon : '+player.equipweapon.name);
talknl(4,'Equipped Armor  : '+player.equiparmor.name);
talknl(4,'Equipped Staff  : '+player.equipmagic.name);
talknl(4,'Equipped Missile: '+player.equipmis.name);
end;

procedure do_information_regitem(V:char);
var choice:str;foundit:boolean;
scount7,choici:integer;
tiddley:string[1];
clearer:boolean;
begin
talk(5,'Enter Corresponding ID Number: ');
input(choice,2);foundit:=false;
choici:=value(choice); str(player.class,tiddley);
if v='W' then display_weapon(choici) else display_armor(choici);
end;

procedure sell_item;
    procedure display_offer(typer:char);
     var choicer:char;
       price:real;
       whichone,x:integer;
     begin
price:=0;
if typer='A' then if player.equiparmor.idnum>0 then price:=player.equiparmor.cost+player.equiparmor.magical*10;
if typer='S' then if player.equipmagic.idnum>0 then price:=player.equipmagic.cost*0.5;
if typer='M' then if player.equipmis.idnum>0 then price:=player.equipmis.cost+
    player.equipmis.magical*10;
if typer='W' then if player.equipweapon.idnum>0 then price:=player.equipweapon.cost+player.equipweapon.magical*10;
     price:=price*0.5;
talknl(4,'I will give you '+cstrr(price,10)+' Gold Pieces for that item!');
talk(4,'Do you Accept? (Y/N): ');
onek(choicer,'YN');
if choicer='Y' then begin
 talknl(7,'SOLD!!'); pausescr;
 player.goldpieces:=player.goldpieces+price;
 delete_item(typer); determine_armorclass; save_char(0);
 end;
end;

var maxcount,choici,itemp,whichone:integer;
    choice:char;
begin
talknl(5,'Enter:   A:  '+player.equiparmor.name);
talknl(5,'         S:  '+player.equipmagic.name);
talknl(5,'         M:  '+player.equipmis.name);
talknl(5,'         W:  '+player.equipweapon.name);
talknl(5,'         N:  None');
talk(5,'Enter Number (N to exit): '); ansic(5);
onek(choice,'AMNSW');
if choice<>'N' then display_offer(choice);
end;

procedure purchase_it(location:integer; which_char:char);
var x,joke:integer;
begin
nl;
with player do begin
if which_char='W' then
if goldpieces<weapon[location].cost then
talknl(6,'You Cannot Afford That') else begin
talknl(5,'You Have Purchased the '+weapon[location].name);
if weapon[location].melee=false then
equipmis:=weapon[location]
else equipweapon:=weapon[location];
goldpieces:=goldpieces-weapon[location].cost;
display_gold;
end;
if which_char='A' then
if goldpieces<armor[location].cost then
talknl(6,'You Cannot Afford That')
else begin
talknl(5,'You Have Purchased the '+armor[location].name);
equiparmor:=armor[location];
goldpieces:=goldpieces-armor[location].cost;
display_gold;
end;
if which_char='M' then
if goldpieces<magici[location].cost then
talknl(6,'You Cannot Afford That') else begin
talknl(5,'You Have Purchased the '+magici[location].name);
equipmagic:=magici[location];
goldpieces:=goldpieces-magici[location].cost;
display_gold;
end;
end; end;

procedure purchase_weapon;
var foundit:boolean;grabit:char; choice:str;
    count4,choici:integer;
    tiddley:string[1];
begin
talk(5,'Enter Corresponding ID Number: ');
input(choice,2); foundit:=false;
choici:=value(choice); str(player.class,tiddley);
if (choici < 11) and (choici > 0) then
for count4:=1 to 6 do
if weapon[choici].classrest[count4]=tiddley then begin
count4:=17;foundit:=true;
display_weapon(choici);
talk(4,'Gold Pieces:  '+cstrr(player.goldpieces,10));
nl; talk(5,'Do You Wish to Purchase It? (Y/N)'); ansic(0);
onek(grabit,'YN');
if grabit='Y' then purchase_it(choici,'W'); end;
if foundit=false then talknl(5,'You Cannot Use That!');
end;

procedure purchase_armor;
var foundit:boolean;
count4,choici:integer; grabit,choice:char;
tiddley:string[1];
begin
talk(5,'Enter Corresponding ID Number: ');
onek(choice,'12345670'); foundit:=false;
choici:=ord(choice)-48; str(player.class,tiddley);
if (choici < 6) and (choici > 0) then
for count4:=1 to 6 do
if armor[choici].class_rest[count4]=tiddley then
begin
count4:=17;foundit:=true;
display_armor(choici);
talknl(5,'Gold Pieces:  '+cstrr(player.goldpieces,10));
nl;talk(6,'Do You Wish to Purchase It? (Y/N)');           ansic(0);
onek(grabit,'YN');
if grabit='Y' then purchase_it(choici,'A'); end;
if foundit=false then talknl(5,'You Cannot Use That!');
end;

procedure purchase_magici;
var choice:str;foundit:boolean;
count,choici:integer; grabit:char;
tiddley:string[1];
begin
repeat
talk(5,'Enter Corresponding ID Number: '); ansic(5);
input(choice,2);foundit:=false;
choici:=value(choice); str(player.class,tiddley);
until (choici>0) and (choici<11);
display_magici(choici);
talknl(5,'Gold Pieces:  '+cstrr(player.goldpieces,10));
nl;talk(6,'Do You Wish to Purchase It? (Y/N)'); ansic(0);
onek(grabit,'YN');
if grabit='Y' then purchase_it(choici,'M');
end;

procedure do_weapon_list;
var  falser:boolean; row,temp,temp2:integer;modi:integer;
nerd,counter:integer;buthole:string[1];dung:string[2];
choicer:char;
  procedure show_weapons;
  begin
  row:=4;cls;str(player.class,buthole);
  talknl(4,'Weapons Available:  ');
  talknl(4,'ID #  NAME');nl;
  goto_ansixy(row+1,1);
    for nerd:=1 to 10 do begin
     falser:=false;
     for counter:=1 to length (weapon[nerd].classrest) do
     if (buthole=weapon[nerd].classrest[counter]) then
     falser:=true;
    if falser=true then begin
     row:=row+1;
    talk(4,cstr(weapon[nerd].idnum)+': '+weapon[nerd].name);
    goto_ansixy(row,22);
    talk(4,cstr(weapon[nerd].cost));
   if row>23 then row:=24;
    goto_ansixy(row,36); talknl(3,'GPS.');
    end;
   end;
display_gold;
talknl(4,'(I)nformation on a Weapon');
talknl(4,'(L)eave Weaponry Section');
talknl(4,'(P)urchase a Weapon');
talknl(4,'(S)ell a Weapon');
talknl(4,'(Y)our Equipment');
end;

begin
show_weapons;
repeat  nl;
talk(4,'Choice: ILPSY? :'); ansic(4);
onek(choicer,'ILPSY?');
  case choicer of
  'I':do_information_regitem('W');
  'P':purchase_weapon;
  'S':sell_item;
  'Y':list_view;
  '?':show_weapons;
  end;
 until choicer='L';
end;

procedure do_information_magici;
var choice:str;
 count,choici:integer;
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
nerd,counter:integer;buthole:string[1];dung:string[2];
choicer:char;
   procedure show_magici;
    begin
    row:=4;cls;str(player.class,buthole);
    talknl(4,'Magic Staves Types Available:  '); talknl(4,'ID #  NAME');nl;
    for nerd:=1 to 10 do begin goto_ansixy(row+1,1); row:=row+1;
    talk(4,cstr(magici[nerd].idnum)+': '+magici[nerd].name); goto_ansixy(row,32);
    talk(3,cstrr(magici[nerd].cost,10)); goto_ansixy(row,47); talknl(3,'GPS.');
    end;
display_gold;
talknl(4,'(I)nformation on a Staff');
talknl(4,'(L)eave Magic Staff Section');
talknl(4,'(P)urchase Staff');
talknl(4,'(S)ell A Staff');
talknl(4,'(Y)our Equipment');
end;
begin
show_magici;
repeat nl;
talk(4,'Enter Choice (ILPSY?):  '); ansic(3);
onek(choicer,'ILPSY?');
case choicer of
 'I':do_information_magici;
 'P':if (player.class=2) or (player.class=6) then purchase_magici
     else begin talknl(3,'You are not a Magic User'); pausescr;end;
 'S':sell_item;
 'Y':list_view;
 '?':show_magici;
end;
until choicer='L';
end;

procedure do_armor_list;
var  falser:boolean; row,temp,temp2:integer;modi:integer;
  nerd,counter:integer;buthole:string[1];dung:string[2];
  choicer:char;
   procedure show_armor;
    begin
    row:=4;cls;str(player.class,buthole);
    talknl(4,'Armor Types Available:  ');
    talknl(4,'ID #  NAME');nl; goto_ansixy(row+1,1);
    for nerd:=0 to 5 do begin falser:=false;
    for counter:=1 to length (armor[nerd].class_rest) do
    if (buthole=armor[nerd].class_rest[counter]) then falser:=true;
    if falser=true then begin row:=row+1;
    talk(4,cstr(armor[nerd].idnum)+': '+armor[nerd].name); goto_ansixy(row,22);
    talk(4,'  '+cstr(armor[nerd].cost));
    goto_ansixy(row,39); talknl(3,'GPS.');
    end;
 end;
display_gold;
talknl(4,'(I)nformation on a Armor');
talknl(4,'(L)eave Armory Section');
talknl(4,'(P)urchase Armor');
talknl(4,'(S)ell Your Armor');
talknl(4,'(Y)our Equipment');
end;

begin
show_armor;
repeat nl;
talk(4,'Enter Request Now (ILPSY?):  '); ansic(3); onek(choicer,'ILPSY?');
case choicer of
'I':do_information_regitem('A');
'P':purchase_armor;
'S':sell_item;
'Y':list_view;
'?':show_armor;
end;
until choicer='L';
end;


var question:char;
moddera,subbera,txe,yetter : integer;
g2:file of armors; g7:file of weapons;
begin
do_gs_options;
case town_stuff.price_mod of
 1: begin moddera:=0; subbera:=1; end;
 2: begin moddera:=500; subbera:=5; end;
 3: begin moddera:=3000; subbera:=15; end;
 4: begin moddera:=6000; subbera:=25; end;
 5: begin moddera:=10000; subbera:=100; end;
 6: begin moddera:=15000;  subbera:=150; end;
end;
for yetter:=0 to 10 do begin
weapon[yetter].cost:=weapon[yetter].cost+moddera
  -(modifier(player.stats[7])*subbera);
if weapon[yetter].cost<1 then weapon[yetter].cost:=1;
weapon[yetter].magical:=(town_stuff.price_mod div 1)-1;
end;
for yetter:=0 to 5 do begin
armor[yetter].cost:=armor[yetter].cost+moddera-(modifier(player.stats[7])*subbera);
if armor[yetter].cost<1 then weapon[yetter].cost:=1;
armor[yetter].magical:=(town_stuff.price_mod div 1)-1;
end;
 repeat
  talk(4,'Choice AFLMW ,? ');
  ansic(3); onek(question,'AFLMW?');nl;
  case question of
 '?':do_gs_options;
 'A':do_armor_list;
 'F':food_purchase;
 'M':do_magic_list;
 'W':do_weapon_list;
  end;
 sub_moves(2); check_moves;
until question='L';
determine_armorclass;
assign(g7,'weapons.dat'); reset(G7);
for txe:=0 to 10 do
read(g7,weapon[txe]);
close(g7);
assign(g2,'armor.dat'); reset(g2);
for txe:=0 to 5 do
read(g2,armor[txe]);
close(g2);
end;



overlay procedure view_initial_char;
var x,whichone,itemp:integer; temper:char;
    g:helper; temp:str; tempy:string[2];
procedure list_view;
begin
with player do begin
talknl(4,'Equipped Weapon : '+equipweapon.name+' +'+cstr(equipweapon.magical));
talknl(4,'Equipped Armor  : '+equiparmor.name+' +'+cstr(equiparmor.magical));
talknl(4,'Equipped Staff  : '+equipmagic.name);
talknl(4,'Equipped Missile: '+equipmis.name+' +'+cstr(equipmis.magical));
talknl(4,'Equipped Ring   : '+equipring.name+' +'+cstr(equipring.magical)+' with '+cstr(equipring.charges)+' Charges');
end;
end;

procedure pot_view;
var x:integer;
begin
for x:=43 to 51 do
if player.exemptions[x] > 0 then
talknl(4,cstr(player.exemptions[x]) +' Potions of '+potion_array[x-42].name);
end;

begin
cls;
talknl(3,player.name);
for x:=1 to 8 do begin
   talk(5,stat_name[x]+': ');
   talknl(4,cstr(player.stats[x]));
end;
nl;
talk(3,'Class:           ');
talknl(4,class_name[player.class]);
talk(3,'Hit Points:      ');
talknl(4,cstr(player.maxhitpoints)+'/'+cstr(player.act_hitpoints));
display_gold;
list_view; nl; pot_view; pausescr;
with player do begin
talk(3,'Level:           '); talknl(4,cstr(level));
talk(3,'Experience:      '); talknl(4,cstrr(experience,10));
talk(3,'Needed Exper:    '); talknl(4,cstrr(needed_exp,10));
talk(3,'Armor Class:     '); talknl(4,cstr(armorclass));
talk(3,'# Attacks / Rnd  '); talknl(4,cstr(numatt));
talk(3,'Spell Points:    '); talknl(4,cstr(stats[8])+'/'+cstr(act_spellpoints));
talk(3,'Food             '); talknl(4,cstr(food));
talk(3,'Total Moves      '); talknl(4,cstrr(total_moves,10));
end;
display_moves;
pausescr;
end;



overlay procedure init_names;
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

overlay procedure do_opening_screen;
var g1:file of char;
holder:char;
begin
assign(g1,'titler2.ans');
reset(g1);
while (not EOF(g1)) do begin
read(g1,holder);
prompt(holder);
end;
close(g1);
pausescr;
end;

overlay procedure enter_tavern;
var chk:str;
    choicer:char;
    maxbet : integer;
procedure tavern_choices(var chk: str);
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
   totals:array [1..7] of integer; betstr:str;

        procedure do_dicegame;
          var count,temp1,temp2: integer; tie:boolean; begin
          if bet>player.goldpieces then
             talknl(4,'Are you trying to cheat? <-- Don''t Answer This!')
             else begin
              for count:=1 to numplayers do begin
                  totals[count]:=random(6)+1+random(6)+1+random(6)+1;
                  if count=numplayers-1 then begin
                    totals[count]:=totals[count]+2;
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
                  player.goldpieces:=player.goldpieces+(bet*numplayers);
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
   question:str;
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
  bet:=bet*5;
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
  bet:=bet*10;
  talknl(6,'You Win:  '+cstr(bet)+' Gold Pieces');
  player.goldpieces:=bet+player.goldpieces;
  end else
   if totals = 18 then begin
     talknl(5,'Almost, but not quite!');
     bet:=bet*7;
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
    ansic(7); input(question,2);
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
       temp2:=(modifier(player.stats[7])*-1)+5;
       if cost < 1 then cost:=1;
       cost:=temp2 + (10 * town_stuff.price_mod)-10;
       talknl(4,'A drink costs '+cstr(cost)+' Gold Pieces');
       talk(5,'Wish to buy? (Y/N)'); ansic(3); onek(choice,'NY');
       if (choice='Y') and (player.goldpieces > cost-1) then begin
          player.goldpieces:=player.goldpieces-cost;
          talknl(4,'You now have '+cstrr(player.goldpieces,10)+' Gold Pieces');
          cost:=random(100)+1;
          if cost < (20+player.stats[6]+player.level) then begin
             assign(g1,'rumors.dat');
             reset(g1);
             cost:=random(50);
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


overlay procedure create_for_real;
var i,count:integer;
 ok:boolean;
 chk : string[6];
 procedure roll_stats;
    var x,ay,holder:integer;
    begin
    for x:=1 to 8 do begin
    holder:=0;
   talk(3,stat_name[x]+'  = ');
   for ay:=1 to 4 do holder:=holder+random(4)+3;
   player.stats[x]:=holder;
   talknl(5,cstr(holder));
   end;
  nl; nl;
   talknl(5,'Rerolls Left: '+cstr(count));
   end;

 procedure ask_question(var done : boolean;var counter : integer);
 var question:char;
 begin
  nl; orig_stats;
  talk(6,'Do you wish to reroll [Y/N]?  '); ansic(3); onek(question,'YN');
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
var question:char; x: byte; gnu_nam : str;
    class_choosen: boolean;
begin
class_choosen:=false;
repeat
nl; talk(5,'Enter Number of Class You Want: ');
onek(question,chk);
x:=ord(question)-48;
talk(5,'Are you Sure You Want To Be a ');
talk(6,class_name[x]+'? '); ansic(3);
onek(question,'YN');
if question='Y' then class_choosen:=true;
until class_choosen;
player.class:=x;
if (player.class=2) or (player.class=6) then player.spells:=true else
  player.spells:=false;
if player.spells = false then player.stats[8]:=0;
player.act_spellpoints:=player.stats[8];
talk(5,'Do You Wish to Change Your Name? (Y/N): '); ansic(3); onek(question,'YN');
if question='Y' then begin talknl(5,'Then Enter Your New Name (25 Chars Max!): ');
talk(4,':'); input(gnu_nam,25); player.name:=gnu_nam; end else player.name:=thisuser.name;
end;

procedure do_hitpoints;
var temp:integer;
begin
with player do begin
case class of
1:  maxhitpoints:=25;
2:  maxhitpoints:=20;
3:  maxhitpoints:=23;
4:  maxhitpoints:=22;
5:  maxhitpoints:=27;
6:  maxhitpoints:=22;
end;
maxhitpoints:=maxhitpoints+modifier(player.stats[5]);
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
 4:  goldpieces:=150+random(50);
 5:  goldpieces:=200+random(25);
 6:  goldpieces:=150+random(50);
end;
experience:=0; numatt:=1; xactual:=0; yactual:=0; moves:=1;
dungeon_level:=0; level:=1;armorclass:=0; xmap:=0; ymap:=0;
for x:=1 to 51 do exemptions[x]:=0; exemptions[43]:=random(4)+1;
for x:=1 to 255 do door_exemps[x]:=0;
outdoor:=false; city:=true; dungeon:=false; total_moves:=0.0;
outyact:=5; outxact:=10; outxmap:=5; outymap:=5;
food:=25; memory:='                                  ';
case class of
 1:  begin needed_exp:=2000; exemptions[45]:=random(4)+1; end;
 2:  begin needed_exp:=2500; exemptions[44]:=random(4)+1; end;
 3:  begin needed_exp:=1500; exemptions[43]:=random(10)+1; end;
 4:  begin needed_exp:=1000; exemptions[46]:=random(8)+1; end;
 5:  begin needed_exp:=2500; exemptions[45]:=random(2)+1; end;
 6:  needed_exp:=3000;
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
player.equipring:=ring[0];
repeat
 roll_stats;
 choose_class;
 ask_question(ok,count);
until ok or (count=0); if count=0 then return;
pick_class;
do_hitpoints;
do_initial_gold;
orig_stats;
assign_moves;
save_char(1);
end;

overlay procedure get_city_info;
var g2:file of town_rec;
begin
assign(g2,'TOWNDATA.PIT');
reset(g2);
repeat
  read(g2,town_stuff); if IOresult <> 0 then talknl(8,'Pit Fiend F***ed Up!');
until (town_stuff.x=player.outxact) and (town_stuff.y=player.outyact);
close(g2);
end;

overlay procedure welcome;
var colr : integer;
begin
cls; talknl(3,'Welcome to '+town_stuff.city_name); nl;
talk(4,'Your Choices Brave ');
talknl(5,player.name);
if town_stuff.port then colr:=3 else colr:=0;
talknl(3,'(B)oating -- if port');
talknl(3,'(C)hat with People!');
talknl(3,'(D)ocumentation');
talknl(3,'(F)ast Scroll');
if town_stuff.gen then colr:=3 else colr:=0;
talknl(colr,'(G)eneral Store');
talknl(3,'(L)eave Town!');
if town_stuff.pot then colr:=3 else colr:=0;
talknl(colr,'(P)urchase Potions');
talknl(3,'(Q)uit and Save');
if town_stuff.pot then colr:=3 else colr:=0;
talknl(colr,'(R)ing Store');
talknl(3,'(S)ave Character -- No Quit');
if town_stuff.tav then colr:=3 else colr:=0;
talknl(colr,'(T)avern       ');
talknl(3,'(V)iew Character');
talknl(3,'(Y)our Guardian Angel');
talknl(3,'(Z) -- Destroy Character');
display_moves;
end;

overlay procedure enter_city;
var ttext: char;
begin
say_saying('Do You Wish to Enter the City? (Y/N):');
ansic(5); onek(ttext,'NY');
if ttext='Y' then begin exitter:=true; player.outdoor:=false; player.city:=true; end;
end;

overlay procedure load_dungeon(modx,mody : integer);
var du_file : file of dun_rec;
begin
assign(du_file,'DUNGEON.INF');
reset(du_file);
repeat
  read(du_file,dungeon_stuff); if IOresult <> 0 then talknl(8,'Pit FIend F***ed up in Dun!');
until (dungeon_stuff.dlocx=player.outxact+modx) and (dungeon_stuff.dlocy=player.outyact+mody);
close(du_file);
end;

overlay procedure enter_dungeon_check(var tt : byte);
var tinput : char; x,y: byte;
    t1 : array [1..3] of str;
begin
clear_space; y:=0;
if dunchk>3 then begin say_saying('Tried To Enter A Dungeon Too Many Times Today!');
tt:=0; end else begin
  say_saying('Do you wish to Enter the Dungeon '+dungeon_stuff.dname+ ' (Y)es/(N)o? --> ');
if not dungeon_stuff.nilword then say_saying('(Remember you will need the magic words!): ');
ansic(5); onek(tinput,'YN'); if tinput ='N' then tt:=0 else
 if not dungeon_stuff.nilword then begin
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
 say_saying('player  -= Be sure and Read the DOCS next time! =- '); dunchk:=dunchk+1;
 pausescr;
 tt :=1;
end else begin
  for x:=1 to 3 do
  if t1[x]=dungeon_stuff.dwords[x] then y:=y+1;
  if y=3 then begin say_saying('The doors to the dungeon open inward!');
    tt:=2; pausescr;
  end else begin say_saying('Those are NOT the correct words!'); tt:=3; pausescr;
   dunchk:=dunchk+1;
   end;
 end;
end;
if (dungeon_stuff.nilword) and (tinput='Y') then tt:=2;
end;
end;

overlay procedure enter_dun_this_way(x1,y1: integer);
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

overlay procedure check_food_supply;
begin
with player do begin
if equipring.idnum=13 then begin foodmv:=0;
 say_saying('Ring Used A Charge, for Food!'); equipring.charges:=equipring.charges-1;
 if equipring.charges<1 then begin equipring:=ring[12];
 say_saying('Regeneration Ring out of Charges, now a normal Ring of Regeneration!');
 end;
end;
if food=0 then begin
 say_saying('You are OUT OF FOOD!!!  You are wounded now and out of moves!');
 act_hitpoints:=act_hitpoints-act_hitpoints div 4;
 if act_spellpoints>0 then act_spellpoints:=act_spellpoints-act_spellpoints div 2;
 moves:=0; end
else begin food:=food-1;
say_saying('1 Food Ration Consumed, you have '+cstr(player.food)+' Food Left!');
end;
end;
end;

overlay procedure load_rooms;
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

overlay function determin_combat(xx,yy : integer; f1,g1,h1,i1,j1 : byte) : byte;
var tt:byte; afound:boolean;
begin
afound:=false; tt:=0;
for tt:=1 to 75 do
if dung_room[tt].dxmap=player.xmap then
 if dung_room[tt].dymap=player.ymap then
  if dung_room[tt].dlocx=player.xactual+xx then
   if dung_room[tt].dlocy=player.yactual+yy then begin
        determin_combat:=tt; tt:=76; end;
end;

overlay function do_a_bridge(var j,k,l,m,n: BYTE) : boolean;
var gg : char; coster:integer;
begin
j:=0;
   n:=(player.level div 4)+1; if n>4 then n:=4; j:=2;
   k:=50; l:=50; m:=50;
   if n>1 then K:=16;
   if n>2 then l:=16;
   if n>3 then m:=16;
   if dialcnt > 18 then begin clear_space; dialcnt:=18; end;
   if player.level<3 then say_saying('Warning!  Trolls are Hard for your Level!');
   say_saying(cstr(n)+' Troll(s) step from underneath the bridge!');
   say_saying('You have '+cstrr(player.goldpieces,10)+' Gold Pieces!');
   coster:=((player.level div 2)+1) * 50 * n;
   say_saying('They will let you pass for '+cstr(coster)+' Gold Pieces!');
   say_saying('Do you (A)ccept, (F)ight them, (L)eave them. -> ');
   ansic(4); onek(gg,'AFL');
   case gg of
     'A' : if player.goldpieces < coster then begin
                do_a_bridge:=true; j:=2; end
    else begin player.goldpieces:=player.goldpieces-coster; do_a_bridge:=false; bridger:=true; end;
     'F' : begin do_a_bridge:=true; j:=2; end;
     'L' : begin j:=1; do_a_bridge:=false; say_saying('Continue Playing...'); end;
   end;
end;

overlay procedure get_screen;
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
say_saying('Loading/Decrypting, one moment please...');
for y:=1 to 23 do
 for x:=1  to 80 do begin
  read(f1,map[x,y]);
  map[x,y]:=chr(ord(map[x,y]) + (x div 5));
end;
for y:=1 to 23 do
for x:=1  to 80 do
 if map[x,y]='/' then map[x,y]:=' ';
close(f1);
clear_space;
end;

overlay procedure auto_map_view;
var xx,yy,aa,bb: byte;
hack : str;
begin
cls; dialcnt:=18; ansic(0);
for xx:=1 to 23 do begin
 bb:=0;
  for aa:=1 to 78 do if auto_map[aa,xx]=' ' then bb:=bb+1;
  if bb>77 then nl else begin
  for yy:=1 to 78 do
  prompt(auto_map[yy,xx]);
  nl;
  end;
end;
if player.dungeon then goto_ansixy(player.yactual,player.xactual)
 else goto_ansixy(player.outyact,player.outxact);
ansic(8); prompt('๊');
repeat goto_ansixy(1,1); talk(8,'Type "DONE" when finished: '); ansic(4);
input(hack,4); until hack='DONE';
end;

overlay procedure whats_so_special(ghi : byte);
begin
case ghi of
   1  :  begin if dialcnt > 18 then clear_space;
         say_saying('Congratulations... You have defeated the Kobold Chieftain!');
         say_saying('The Kobolds are no longer a threat to the Island Without');
         say_saying('their Leader.  Travel by ship is now safe!');
         end;
  2  :  begin if dialcnt > 18 then clear_space;
         say_saying('Congratulations, you have found the Eyes of Doom Inside the Coffin!');
         say_saying('These ancient Glasses will allow you to Read Ancient Text!');
         pausescr;
        end;
  3 : begin if dialcnt > 18 then clear_space;
        say_saying('Congratulations, you have defeated Xevior and his evil');
        say_saying('Minions of Doom.  Soma Production and his empire is lost');
        say_saying('You have but one more foe!'); player.experience:=player.needed_exp;
        pausescr;
      end;
end;
end;

overlay procedure hunter;
var gained,timer : byte; bg : integer;
begin
gained:=0; bg :=modifier(player.stats[2]); if player.class=6 then bg:=bg+10;
if (conditions.degree>75) and (conditions.degree<125) then bg:=bg+5 else bg:=bg-5;
case map[player.outxact,player.outyact] of
  ' ' : begin if random(100) < 16+bg then gained:=random(3)+1; timer:=10+random(10); end;
  '' : begin if random(100) < 30+bg then gained:=random(5)+1; timer:=10+random(3); end;
  'ฐ','B' : begin if random(100) < 50+bg then gained:=random(3)+1; timer:=8+random(5); end;
  else begin if random(100) < 5+bg then gained:=random(2)+1; timer:=15+random(10); end;
end;
if gained>0 then say_saying('You have found '+cstr(gained)+' Rations') else
   say_saying('You Fail to find any Food!');
say_saying(cstr(timer)+' Moves Used!'); sub_moves(timer);
player.food:=player.food+gained; if player.food>99 then player.food:=99;
end;

overlay procedure enter_inn;
var choicx : char; cost:integer; heni1,heni2: byte;
begin
say_saying('You Come Upon an Lonely Inn, stop by and rest? (Y/N)');
ansic(4); onek(choicx,'YN');
if choicx='Y' then begin
clear_space;
cost:=(player.maxhitpoints-player.act_hitpoints)+5;
cost:=cost+(player.stats[8]-player.act_spellpoints)-modifier(player.stats[7]);
if cost < 1 then cost:=5;
say_saying('It costs '+cstr(cost)+' Gold Pieces to Sleep Here!');
say_saying('You have '+cstrr(player.goldpieces,10)+' Gold Pieces!');
say_saying('All your wounds will be healed! Choice (Y/N) :');
onek(choicx,'YN');
if choicx = 'Y' then begin
 clear_space;
  if player.goldpieces > (cost-1) then begin
    player.act_hitpoints:=player.maxhitpoints;
    player.act_spellpoints:=player.stats[8];
    sub_moves(1);
    player.goldpieces:=player.goldpieces-cost;
    say_saying('You are Completely Healed!');
  end
 else say_saying('No Gold -- No Service!');
end;
end;
cost:=50-modifier(player.stats[7])+random(12);
say_saying('Perhaps you''d be interested in a (auto) map of the area for ');
say_saying(cstr(cost)+' Goldpieces, you have '+cstrr(player.goldpieces,10)+' Goldpieces (Y/N): ');
onek(choicx,'NY');
if choicx='N' then say_saying('Continue Playing...') else
if player.goldpieces<cost then say_saying('Not Enough Gold') else begin
for heni1:=0 to 79 do
 for heni2:=0 to 24 do
 auto_map[heni1,heni2]:=map[heni1,heni2];
 say_saying('Installed into your auto-map, thanks for the business, continue...');
 player.goldpieces:=player.goldpieces-cost;
end;
end;

overlay procedure guard(var c1,d1,e1,f1,g1 : byte);
var cha : char;
begin
say_saying('You Have Run Into a Guard Post! -- COMBAT!');
say_saying('Hit ''A'' to begin the Attack!--> '); ansic(7);
onek(cha,'A');
case player.dungeon_level of
  0: begin c1:=1; d1:=1; e1:=50; f1:=50; g1:=2; end;
  1: begin c1:=1; d1:=1; e1:=1; f1:=50; g1:=3; end;
  2: case random(4) of
       0:  begin c1:=5; d1:=5; e1:=5; f1:=9; g1:=4; end;
       1:  begin c1:=11; d1:=11; e1:=11; f1:=7; g1:=4; end;
       2:  begin c1:=4; d1:=4; e1:=4; f1:=4; g1:=4; end;
       3:  begin c1:=46; d1:=3; e1:=3; f1:=50; g1:=3; end;
     end;
  4: case random(2) of
       0: begin c1:=37; d1:=37; e1:=50; f1:=50; g1:=2; end;
       1: begin c1:=37; d1:=37; e1:=37; f1:=50; g1:=3; end;
     end;
  5: case random(4) of
       0: begin c1:=63; d1:=63; e1:=63; f1:=63; g1:=4; end;
       1: begin c1:=63; d1:=64; e1:=65; f1:=59; g1:=4; end;
       2: begin c1:=64; d1:=64; e1:=65; f1:=65; g1:=4; end;
       3: begin c1:=49; d1:=63; e1:=50; f1:=50; g1:=2; end;
end;
  6: case random(6) of
       0: begin c1:=56; d1:=56; e1:=56; f1:=56; g1:=4; end;
       1: begin c1:=21; d1:=21; e1:=21; f1:=50; g1:=3; end;
       2: begin c1:=21; d1:=21; e1:=50; f1:=50; g1:=2; end;
       3: begin c1:=32; d1:=33; e1:=33; f1:=33; g1:=4; end;
       4: begin c1:=23; d1:=23; e1:=50; f1:=50; g1:=2; end;
       5: begin c1:=62; d1:=62; e1:=62; f1:=50; g1:=3; end;
     end;
  8: case random(6) of
       0: begin c1:=63; d1:=63; e1:=63; f1:=63; g1:=4; end;
       1: begin c1:=63; d1:=63; e1:=63; f1:=64; g1:=4; end;
       2: begin c1:=63; d1:=63; e1:=52; f1:=52; g1:=4; end;
       3: begin c1:=64; d1:=52; e1:=50; f1:=50; g1:=2; end;
       4: begin c1:=54; d1:=54; e1:=63; f1:=63; g1:=4; end;
       5: begin c1:=63; d1:=57; e1:=64; f1:=52; g1:=4; end;
     end;
  9: case random(9) of
       0: begin c1:=41; d1:=23; e1:=23; f1:=23; g1:=4; end;
       1: begin c1:=41; d1:=49; e1:=50; f1:=50; g1:=2; end;
       2: begin c1:=24; d1:=25; e1:=24; f1:=25; g1:=4; end;
       3: begin c1:=49; d1:=23; e1:=23; f1:=23; g1:=4; end;
       4: begin c1:=41; d1:=62; e1:=62; f1:=62; g1:=4; end;
       5: begin c1:=30; d1:=30; e1:=50; f1:=50; g1:=2; end;
       6: begin c1:=49; d1:=50; e1:=50; f1:=50; g1:=1; end;
       7: begin c1:=49; d1:=49; e1:=50; f1:=50; g1:=2; end;
       8: begin c1:=54; d1:=23; e1:=24; f1:=25; g1:=4; end;
     end;
end;
end;

overlay procedure do_a_treasure(mosx,mosy : integer);
type treasure = record
    amount : integer;
    toggler : byte;
    potiont : array [1..2] of byte;
    food   : byte;
    scroll : boolean;
    scrollsay : helper;
    loser : helper;
    dun_num : byte;
    xloc : byte;
    yloc : byte;
  end;
var treas : treasure; treasure_file : file of treasure;
    xx : boolean;

 procedure give_gold;
 begin
 say_saying('In a chest you find: '+cstr(treas.amount)+' Gold Pieces!');
 player.goldpieces:=player.goldpieces+treas.amount;
 say_saying('You now have '+cstrr(player.goldpieces,10)+' Gold Pieces!');
 pausescr;
 end;

 procedure give_potions;
 var gk : byte;
 begin
 say_saying('You Find '+cstr(treas.potiont[2])+' Potion(s) of '+potion_array[treas.potiont[1]].name);
 gk:=player.exemptions[treas.potiont[1]+42]+treas.potiont[2];
 if gk > player.exemptions[treas.potiont[1]+42] then
  player.exemptions[treas.potiont[1]+42]:=gk else
   player.exemptions[treas.potiont[1]+42]:=255;
 say_saying('You Now Have '+cstr(player.exemptions[treas.potiont[1]+42]));
 pausescr;
end;

procedure give_grub;
begin
say_saying('YUMM!  You find '+cstr(treas.food)+' Food!');
player.food:=player.food+treas.food;
if player.food > 99 then player.food:=99;
say_saying('You now have '+cstr(player.food)+' Food Rations!');
pausescr;
end;

procedure read_scroll;
begin
clear_space;
say_saying('Your Angel of Protection appears and says, ');
say_saying(treas.scrollsay);
pausescr;
end;

begin
assign(treasure_file,'TREASURE.DAT'); xx:=true; clear_space;
reset(treasure_file);
while xx do begin
 read(treasure_file,treas);
 if treas.dun_num = player.dungeon_level then
  if treas.xloc=player.xactual+mosx then
   if treas.yloc=player.yactual+mosy then xx:=false;
end;
close(treasure_file);
if (player.exemptions[treas.toggler] = 1) and (treas.toggler > 1)
  then say_saying(treas.loser)
  else begin
  if treas.scroll then read_scroll;
  player.exemptions[treas.toggler]:=1;
  if treas.amount > 0 then give_gold;
  if treas.potiont[2]>0 then give_potions;
  if treas.food > 0 then give_grub;
  map[player.xactual+mosx,player.yactual+mosy]:=' ';
  end;
end;

overlay procedure fountain(var m,n,o,p,q : byte);
var ytest :char;
begin
m:=0;
if use_pool then say_saying('You have already Used a Fountain Today!')
  else begin
  say_saying('Before you is a Pool of Water, do you wish to Inspect it? (Y/N)');
  ansic(3); onek(ytest,'YN');
  if ytest='Y' then begin
    case random(100) of
      1..3:  begin say_saying('You are Completely Healed!');
             player.act_hitpoints:=player.maxhitpoints;
             end;
      9..15:  begin say_saying('A Mean old Water Serpent Attacks you!');
             pausescr; m:=51; n:=50; o:=50; p:=50; q:=1; end;

      4..8:  begin say_saying('Wow, inside is a gleaming Gem worth 150 Gold Pieces');
             player.goldpieces:=player.goldpieces+150; end;

      16..100: begin say_saying('Quite Refreshing!');
               if foodmv>1 then foodmv:=foodmv div 2; end;
   end;
  end;
 end;
end;

overlay procedure fast_mode;
var buth : char;
begin
if player.city then begin
talknl(3,'Do you Wish to Have No-Color Scroll?');
talk(3,'Recommended for 1200 and some 2400 bps? (Y/N): '); end
else begin
say_saying('Do you Wish to Have No-Color Scroll (Faster)?');
say_saying('Recommended for 1200 and some 2400 bps? (Y/N): '); end;
ansic(5); onek(buth,'YN');
if buth='Y' then player.door_exemps[255]:=1 else player.door_exemps[255]:=0;
if player.city then
talk(3,'Do Not View Wilderness/Dungeon Framework Screen (Y/N): ')
else say_saying('Do Not View Wilderness/Dungeon Framework Screen (Y/N): ');
ansic(5); onek(buth,'YN');
if buth='Y' then player.door_exemps[254]:=1 else player.door_exemps[254]:=0;
end;

overlay procedure inspect;
var dirc : char;
    dirnum : integer;

procedure what_is_it(x,y: integer);
var t1,t2 : byte; gg : char;
begin
if player.outdoor then begin t1:=player.outxact; t2:=player.outyact; end
  else begin t1:=player.xactual; t2:=player.yactual; end;
gg:=chr(127);
case map[t1+x,t2+y] of
  '' : say_saying('That''s a Living Statue -- touch it for a "Nice" surprise!');
  '$' : say_saying('That''s Treasure or Something Special!');
  'C' : if player.outdoor then say_saying('That''s a City -- touch it to enter!')
        else say_saying('A Cave Entrance, touch it to enter!');
  'D' : say_saying('That''s a Door, --touch it to enter!');
  'I' : say_saying('That''s an Inn, you can rest here!');
  'o' : say_saying('That''s a well, you can drink from it');
  'W' : say_saying('That''s a stairWay up, touch it to go up!');
  'w' : say_saying('That''s a stairWay going down, touch it to go down!');
  'S' : say_saying('These are the stairs out of the dungeon, touch it to leave!');
  '' : say_saying('These are trees, hard to move around...');
  'ฐ' : say_saying('That''s water... no drinking please!');
  'ฑ' : say_saying('That''s desert/beach, you get thirsty (hungry) out here!');
  'ฒ' : say_saying('This is part of a room...');
  'น'..'฿' :say_saying('Coastline or a wall... impassible terrain!');
  '๏' : say_saying('That''s a dungeon entrance -- BEWARE!');
  'B' : if player.outdoor then say_saying('That''s a bridge with some nasty trolls on it!')
        else say_saying('You see a Bird, Touch it!');
  '',' ' : say_saying('Nothing there!');
  'ใ' : say_saying('These are Pillars -- impassable');
  '๚' : say_saying('Rubble -- impassable');
  'Û'..'฿' : say_saying('Altar, Rubble, or some barrier!');
  'M' : say_saying('Mojave''s Cave Entrance');
  'R' : say_saying('A Riddle Asking Statue!');
  'H' : say_saying('A hut or small building');
  '' : say_saying('A bubbling fountain');
  ' ','P','T' : say_saying('Nothing there!');
  '#' : say_saying('A shimmering portal');
  '็' : say_saying('A green plant, fairly tall, a Soma Plant!');
  'V' : say_saying('A Scenic Spot, check it out!');
  else if map[t1+x,t2+y]=gg then say_saying('Mountains, Hills, or Tomb Stone') else
     say_saying('PIT FIEND MADE A MISTAKE, REPORT THIS TO HIM');
end;
say_saying('Continue playing......');
end;

begin
say_saying('Which Direction (24568,0 = None) --> ');
ansic(3); onek(dirc,'024568');
dirnum:=ord(dirc)-48; sub_moves(4);
case dirnum of
  2 : what_is_it(0,1);
  4 : what_is_it(-1,0);
  5 : what_is_it(0,0);
  6 : what_is_it(1,0);
  8 : what_is_it(0,-1);
  0 : say_saying('Continue playing....');
 end;
end;

overlay procedure x_ray;
var dirc : char; dirnum : integer;

 procedure spy_door(x,y: integer);
  var t1,t2 : byte; chk : char;
      percen : integer;

procedure success(hs1,hs2 : integer);
var tty : integer; oper:byte;
begin
tty:=0;
with player do begin
repeat
tty:=1+tty;
if dung_room[tty].dxmap = xmap then
 if dung_room[tty].dymap = ymap then
  if dung_room[tty].dlocx = xactual+hs1 then
   if dung_room[tty].dlocy = yactual+hs2 then
    if player.door_exemps[dung_room[tty].toggler]=1 then
  begin say_saying('Room Cleaned of Monsters Already!'); tty:=999; end
  else begin
  clear_space;
  say_saying('Monsters inside are:  ');
  for oper:=1 to dung_room[tty].dencount[5] do
 say_saying(cstr(oper)+'. --> '+monster_array[dung_room[tty].dencount[oper]].name);
 if dung_room[tty].special > 0 then say_saying('This Room is IMPORTANT!'); tty:=999;
   end;
until tty=999;
end;
end;


procedure do_it_thief(xx,m1,m2 : integer);
begin
if random(100) > percen then say_saying('You fail to Discover Anything, moves Wasted!')
else begin say_saying('You are able to sneak a Peak!'); success(m1,m2);end;
sub_moves(15);
end;

procedure do_it_pot(hs1,hs2 : integer);
begin
if player.exemptions[51] > 1 then
 begin say_saying('Gulp.... Gulp.... Gulp....');
 player.exemptions[51]:=player.exemptions[51]-1; success(hs1,hs2);
 end else
 if player.equipring.idnum<>14 then say_saying('You don''t have either a Ring or a Potion!')
 else begin player.equipring.charges:=player.equipring.charges-1; success(hs1,hs2);
 end;
sub_moves(1);
end;

begin
with player do begin
if outdoor then begin t1:=outxact; t2:=outyact; end
else begin t1:=xactual; t2:=yactual; end;
if class=4 then percen:=level*4+stats[4];
end;
if map[t1+x,t2+y] <> 'D' then say_saying('The object Pointed to Is not a Door!')
 else
 if player.class=4 then begin
 clear_space;
 say_saying('Do You wish to use your (T)hieving Skills? ('+cstr(percen)+'%) ');
 say_saying('Or a (P)otion, you have '+cstr(player.exemptions[51])+' X-ray Potions (T/P)');
 ansic(5); onek(chk,'TP');
 if chk='T' then do_it_thief(percen,x,y) else do_it_pot(x,y);
 end
else
do_it_pot(x,y);
end;

begin
if player.outdoor then say_saying('You Must be in a Dungeon to Use this!')
else
 if (player.class<>4) and (player.exemptions[51] <1) and (player.equipring.idnum <> 14)
  then
   say_saying('You lack X-Ray Potions/Rings or Thieving Skills!')
  else begin
  say_saying('Which Direction is the Door (2468,0) --> ');
  ansic(3); onek(dirc,'02468');
  dirnum:=ord(dirc)-48;
  case dirnum of
  2 : spy_door(0,1);
  4 : spy_door(-1,0);
  6 : spy_door(1,0);
  8 : spy_door(0,-1);
  0 : say_saying('Continue playing....');
  end;
end;
end;

overlay procedure sell_ring;
var choicc : char; manag: integer;

procedure list_rings;
var cnt : integer;
begin
cls; goto_ansixy(2,1);
for cnt:=1 to 19 do begin
  talk(0,cstr(cnt)+'.  RING OF '+ring[cnt].name); goto_ansixy(cnt+1,40);
  if ring[cnt].magical > 0 then talk(4,' +'+cstr(ring[cnt].magical));
  goto_ansixy(cnt+1,45); talknl(0,chr(9)+' '+cstr(ring[cnt].cost)+' GPS');
end;
talknl(7,'You carry a '+player.equipring.name+' +'+cstr(player.equipring.magical));
talknl(3,'(I)nformation on a Ring');
talknl(3,'(L)eave Ring Store');
talknl(3,'(P)urchase a Ring');
talknl(3,'(S)ell a Ring');
talknl(3,'(?) See List Again');
end;

procedure sell_ring;
var choc2 : char; amounti : real;
begin
amounti:=70-(ring[player.equipring.idnum].charges-player.equipring.charges);
amounti:=(amounti+modifier(player.stats[8]))/100;
if amounti>1 then amounti:=1.0;
if amounti<=0 then amounti:=0.0;
amounti:=int(player.equipring.cost*amounti);
talk(3,'Do you Wish to Sell your '+player.equipring.name+' For '+cstrr(amounti,10)+' GPS (Y/N) -->');
onek(choc2,'YN');
if choc2='Y' then begin
 player.equipring:=ring[0];
 player.goldpieces:=player.goldpieces+amounti;
 talknl(3,'You Now have '+cstrr(player.goldpieces,10)+' Goldpieces!');
end;
end;

procedure inform__ring(whichi : integer);
begin
talknl(3,'Name:  '+ring[whichi].name);
talknl(3,'Magical Bonus (if applicable) '+cstr(ring[whichi].magical));
if ring[whichi].battle then begin
talknl(3,'This Ring is Used in Battle!');
talknl(3,'Minimum Damage '+cstr(ring[whichi].minddam));
talknl(3,'Maximum Damage '+cstr(ring[whichi].maxdam));
end else talknl(3,'This Ring is NOT used in Battle');
if ring[whichi].charges> 0 then
talknl(3,'This Ring Comes with '+cstr(ring[whichi].charges))
else talknl(3,'This Ring Does Not Use Charges!');
talknl(3,'The Cost of This Ring is '+cstr(ring[whichi].cost)+' GPS.');
nl;
end;

function information_ring : integer;
var chk : str; choici: integer;
begin
talk(3,'Enter Digit(s) -->');
input(chk,2);
choici:=value(chk);
if (choici > 0) and (choici<20)
then begin inform__ring(choici); information_ring:=choici end
  else begin talknl(8,'INVALID INPUT'); information_ring:=0; end;
end;

procedure purchase_ring;
var charyn: char;
begin
manag:=information_ring;
if player.equipring.idnum>0 then begin
  talk(3,'You do Realize that your old ring will be lost (Sell it?), (Y/N): ');
  onek(charyn,'YN'); if charyn='N' then manag:=0;
end;
if manag > 0 then begin
 talknl(4,'Do You Wish To Purchase the Ring? (Y/N): ');
 onek(charyn,'NY');
 if charyn='Y' then
  if player.goldpieces<(ring[manag].cost-1) then talknl(4,'Not Enough Gold!')
   else begin
   talknl(4,'You Have Purchased the Ring!');
   player.goldpieces:=player.goldpieces-ring[manag].cost;
   player.equipring:=ring[manag];
   talknl(3,'You now have '+cstrr(player.goldpieces,10)+' Player Goldpieces!');
  end;
end;
end;

begin
list_rings;
repeat
talknl(7,'You Have '+cstrr(player.goldpieces,10)+' Gold Pieces');
talk(4,'Choice ---> (ILPS,?)');
onek(choicc,'ILPS?');
case choicc of
   'I' : manag:=information_ring;
   'L' : ;
   'P' : Purchase_ring;
   'S' : sell_ring;
   '?' : list_rings;
end;
until choicc='L';
determine_armorclass;
end;

overlay function use_ring : boolean;

procedure wall_rem;
var dirc :char;
procedure remit(x3,y3 : integer);
begin
if map[player.xactual+x3,player.yactual+y3] in ['น'.. 'ฮ'] then begin
  map[player.xactual+x3,player.yactual+y3] :=' '; player.equipring.charges:=player.equipring.charges-1;
  if player.equipring.charges<1 then player.equipring:=ring[0];
  use_ring:=true;
  end else say_saying('Not a Valid Wall!');
end;

begin
clear_space;
say_saying('---- Warning! Significant Hazards Go Along with this Device!');
say_saying('Be sure That you have Read the Rules on this Item or you may');
say_saying('Permanently destroy your character!');
say_saying('Direction (2468,0 (none))');
onek(dirc,'02468');
case dirc of
 '0': say_saying('No charges used!');
 '2': remit(0,-1);
 '4': remit(-1,0);
 '6': remit(1,0);
 '8': remit(0,1);
end;
end;

procedure telep;
var first,second : str; newlocx,newlocy : byte;
begin
clear_space;
say_saying('Certain Risks go with the Teleportal Ring, be sure you know what');
say_saying('you are doing!');
say_saying('Please Enter X-coordinate now (1-77) (0 to abort) -->');
input(first,2);
newlocx:=value(first);
if (newlocx>0) and (newlocy< 78) then begin
  say_saying('Please Enter Y-Coordinate Now (1-77) -->');
  input(second,2);
  newlocy:=value(second);
  if (newlocy>0) and (newlocx< 78) then begin
    if player.outdoor then begin
      player.outxact:=newlocx; player.outxact:=newlocy; end
    else begin player.xactual:=newlocx; player.yactual:=newlocy;
    end;
  use_ring:=true;
  if player.equipring.charges < 1 then player.equipring:=ring[0];
  end else say_saying('Invalid Input!');
end else say_saying('Invalid Input!');
end;

procedure xexit;
var chk : char;
begin
say_saying('Are you Sure you Wish to Exit this Dungeon! (Y/N)');
onek(chk,'YN');
if chk='Y' then begin
  player.equipring:=ring[0];
  exitter:=true;
  player.dungeon:=false;
  player.outdoor:=true;
end else say_saying('Continue Playing then....');
end;

begin
use_ring:=false;
case player.equipring.idnum of
   10,11 : if player.dungeon then wall_rem else say_saying('Must be Used in Dungeons!');
   17    : telep;
   18    : if player.dungeon then xexit else say_saying('Must be Used in a Dungeon!');
   14    :say_saying('Use (X)-ray Command!');
   else say_saying('You have no Useable Ring!');
end;
end;

overlay function do_a_stairs(xmd,ymd : integer) : boolean;
var choicic : char; which_way : boolean; desc : string[4];
begin
if map[player.xactual+xmd,player.yactual+ymd]='w' then which_way :=false else
which_way:=true;
if which_way then desc:='up' else desc:='down';
say_saying('Do you Wish to Take the stairway '+desc+' (Y)es/(N)o: ');
onek(choicic,'YN');
if choicic='Y' then begin
do_a_stairs:=true;
if which_way then
player.ymap:=player.ymap+1
else player.ymap:=player.ymap-1;
end else do_a_stairs:=false;
end;

overlay function camper : boolean;
var choicx: char; whet : byte;
begin
if campr>2 then begin
 say_saying('No More Camping For Today....(3 Times per Day Only!');
 camper:=false; end
else begin
whet:=20-modifier(player.stats[6]);
if whet<5 then whet:=5;
if not player.outdoor then begin camper:=false; say_saying('Camping only allowed Outside!');
end else begin
 say_saying('Do you Really Wish to Set Camp (Y/N): ');
 onek(choicx,'YN');
 if random(100) < whet then begin camper:=true; say_saying('You are Ambushed!'); pausescr; end
 else begin
 camper:=false;
 sub_moves(player.maxhitpoints-player.act_hitpoints);
 sub_moves(player.stats[8]-player.act_spellpoints);
 player.act_hitpoints:=player.maxhitpoints;
 player.act_spellpoints:=player.stats[8];
 say_saying('Your rest was very refreshing.....');
 check_moves;
 end;
end;
end;
end;

overlay procedure what_a_view;
var x,y: byte;
begin
say_saying('What a View!  (Check out your Auto-Map!)');
for x:=0 to 79 do
 for y:=0 to 24 do
  auto_map[x,y]:=map[x,y];
end;

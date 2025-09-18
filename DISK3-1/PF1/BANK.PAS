overlay procedure read_weapons;
var g1:file of weapons; g5: file of potions;
g2:file of armors;
g3:file of magic_staff;
g4:file of monsters;
nerd:integer;
begin
assign(g1,'weapons.dat'); reset(G1);
for nerd:=1 to 24 do
read(g1,weapon[nerd]);
close(g1);
assign(g2,'armor.dat'); reset(g2);
for nerd:=1 to 13 do
read(g2,armor[nerd]);
close(g2);
assign(g3,'magic.dat'); reset(g3);
for nerd:=1 to 10 do
read(g3,magici[nerd]);
close(g3);
assign(g4,'monster.dat'); reset(g4);
for nerd:=1 to 72 do
read(g4,monster_array[nerd]);
close(g4);
assign(g5,'POTIONS.DAT'); reset(g5);
for nerd:=1 to 8 do read(g5,potion_array[nerd]); close(g5);
end;

overlay procedure enter_bank;
var question:char; chk:string[6];
  procedure bank_title;
  var g4 : file of char; temp : char;
  begin
  ansic(0); assign(g4,'BANK.ANS'); reset(g4); temp :='0';
  while temp <> '*' do begin
  read(g4,temp); if temp <> '*' then prompt(temp); end; close(g4);
  display_moves; nl;
  end;

 procedure chars_account;
 begin
 nl; talknl(6,'Gold In Account:  '+cstrr(player.bank,10));
 talknl(6,'Gold Carried   :  '+cstrr(player.goldpieces,10));
 end;

procedure Deposit_in_bank;
var amount:real;
stramount:str;
procedure do_deposit_work;
 begin
 talk(4,'Gold in the Bank:  ');
 player.bank:=amount+player.bank;
 talknl(7,cstrr(player.bank,10));
 player.goldpieces:=player.goldpieces-amount;
 end;

  begin
  amount:=0; if player.goldpieces>0 then begin
  talk(4,'How much do you wish to deposit? (0 for none):');
  input(stramount,8);
 amount:=value(stramount);
 if (amount>player.goldpieces) or (amount<0) then
 talknl(4,'You can''t do that!!')
 else do_deposit_work;
  end else talknl(8,'You have no money to deposit!!');
end;

procedure withdrawal_from_bank;
   var amount:real;
     stramount: str;
     begin
 amount:=0;  talk(3,'How much do you wish to withdrawal? (0 for none)');
 ansic(5); input(stramount,8);
 amount:=value(stramount);
 if (amount<0) or (amount>player.bank) then
 talknl(4,'Are You trying to steal from the bank?')
 else begin player.goldpieces:=amount+player.goldpieces;
 player.bank:=player.bank-amount; chars_account;
 end;
end;

begin
cls;
talknl(6,'Greetings and welcome to Geron''s Bank!'); nl;
talknl(7,'Feel free to make deposits and withdrawals here.');
talknl(7,'Your money is entirely safe here from others!'); nl;
bank_title;
repeat
 talk(5,'Choice: DLYW?, ?');
 onek(question,'DLYW?');
 case question of
 'D' : deposit_in_bank;
 'W' : if player.bank>0 then withdrawal_from_bank else
      talknl(4,'You have no money to withdrawal!');
 'Y' : chars_account;
 '?' : bank_title;
 end;
moves:=moves-1; check_moves;
until question='L';
end;

overlay procedure Do_general_store;

   procedure talk(x : integer; saying:helper);
   begin
   ansic(x); prompt(saying);
   end;
   procedure talknl(x:integer; saying:helper);
   begin
   ansic(x); print(saying);
   end;

   procedure do_gs_options;
   begin
cls; talk(7,'WELCOME TO LITTLETON''S GENERAL STORE!');nl;nl;nl;
talknl(7,' ษอออออออออออออออออออออออออออออออออป');
talk(7,' บ (');
talk(4,'A');
talknl(7,')rmor, purchase               บ');
talk(7,' บ (');
talk(4,'L');
talknl(7,')eave, Littleton''s Store      บ');
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
nl; display_gold; display_moves;
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

procedure display_magici(choici:integer);
begin
if (choici > 0) and (choici < 11) then begin
talk(3,'Name             :'+magici[choici].name); nl;
talk(3,'Maximum Damage   :'+cstr(magici[choici].damage*8)); nl;
talk(3,'Gold Piece Cost  :'+cstrr(magici[choici].cost,10)); nl;
talk(3,'Success Chance   :'+cstr(magici[choici].success)+'%'); nl;
talk(3,'Spell Point Cost :'+cstr(magici[choici].spcost)); nl;
display_gold;
pausescr;
end; end;

procedure display_armor(choici:integer);
begin
if (choici > 0) and (choici < 14) then begin
talknl(6,armor[choici].name);
talknl(3,'Protection Value: '+cstr(armor[choici].protect));
talknl(3,'Movement Hinderance : '+cstr(armor[choici].movemod));
talknl(3,'The Cost of the Armor is : '+cstr(armor[choici].cost)+' Gold Pieces');
talknl(3,'The Magical Bonus is: +'+cstr(armor[choici].magical));
display_gold;
pausescr;
end; end;

procedure display_weapon(choici:integer);
begin
if (choici > 0) and (choici < 25) then begin
talknl(6,weapon[choici].name);
if weapon[choici].melee= true then talknl(3,'This Weapon is a Melee Weapon')
   else talknl(3,'This Weapon is not a Melee Weapon');
if weapon[choici].missile  = true then talknl(3,'The Weapon is a Missile Weapon!')
   else talknl(3,'The Weapon is a Not a Missile Weapon');
talknl(3,'Maximum Damage:  '+cstr(weapon[choici].dam));
if weapon[choici].h2h = true then talknl(3,'Two Handed Weapon');
talknl(3,'The Magical Bonus is: +'+cstr(weapon[choici].magical));
talknl(3,'Cost:  '+cstr(weapon[choici].cost));
talknl(3,'Number of Attacks per Round: '+cstr(weapon[choici].numat));
display_gold;
pausescr;
end; end;

procedure list_view;
begin
if player.equipweapon.idnum[1] <>'N' then talknl(4,'Equipped Weapon : '+player.equipweapon.name);
if player.equiparmor.idnum[1] <> 'N' then talknl(4,'Equipped Armor  : '+player.equiparmor.name);
if player.equipmagic.idnum[1] <> 'N' then talknl(4,'Equipped Staff  : '+player.equipmagic.name);
if player.equipshield.idnum[1] <> 'N' then talknl(4,'Equipped Shield : '+player.equipshield.name);
if player.equipmis.idnum[1] <> 'N' then talknl(4,'Equipped Missile: '+player.equipmis.name);
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
if choici>0 then
     case v of
     'W':if choici<25 then clearer:=true else clearer:=false;
     'A':if choici<25 then clearer:=true else clearer:=false;
      end;
if clearer then
        if v='W' then display_weapon(choici) else display_armor(choici);
 end;

procedure determine_armorclass;
var y:integer;
begin
player.armorclass:=0;
if player.equiparmor.idnum[1] <> 'N' then
     player.armorclass:=player.equiparmor.protect+player.equiparmor.magical;
if player.equipshield.idnum[1] <> 'N' then
     player.armorclass:=player.equipshield.protect + player.armorclass + player.equipshield.magical;
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
if typer='A' then if player.equiparmor.idnum[1] <>'N' then price:=player.equiparmor.cost+player.equiparmor.magical*10;
if typer='S' then if player.equipmagic.idnum[1] <>'N' then price:=player.equipmagic.cost;
if typer='M' then if player.equipmis.idnum[1] <> 'N' then price:=player.equipmis.cost+
    player.equipmis.magical*10;
if typer='H' then if player.equipshield.idnum[1] <> 'N' then price:=player.equipshield.cost+player.equipshield.magical*10;
if typer='W' then if player.equipweapon.idnum[1] <> 'N' then price:=player.equipweapon.cost+player.equipweapon.magical*10;
     price:=price*0.5;
talknl(4,'I will give you '+cstrr(price,10)+' Gold Pieces for that item!');
   talk(4,'Do you Accept? (Y/N)');
   onek(choicer,'YN');
  if choicer='Y' then begin
  talknl(7,'SOLD!!'); pausescr;
  player.goldpieces:=player.goldpieces+price;
  delete_item(typer); determine_armorclass; save_char;
  end;
end;

var maxcount,choici,itemp,whichone:integer;
    choice:char;
begin
talknl(5,'Enter:   A:  Armor');
talknl(5,'         S:  Magic Staff ');
talknl(5,'         M:  Missile Weapon');
talknl(5,'         H:  Shield');
talknl(5,'         W:  Weapon');
talknl(5,'         N:  None');
talknl(5,'Enter Number (A to exit): '); ansic(5);
onek(choice,'ASMHWN');
if choice<>'N' then display_offer(choice);
end;

procedure move_mod_armor;
begin
if player.equiparmor.idnum[1] <> 'N' then moves:=moves-player.equiparmor.movemod;
end;

procedure purchase_it(location:integer; which_char:char);
var x,joke:integer;
begin
nl;
if which_char='W' then
if player.goldpieces<weapon[location].cost then
talknl(4,'You Cannot Afford That') else begin
talknl(4,'You Have Purchased the '+weapon[location].name);
if weapon[location].missile then
player.equipmis:=weapon[location]
else player.equipweapon:=weapon[location];
player.goldpieces:=player.goldpieces-weapon[location].cost;
display_gold;
end;
if which_char='A' then
if player.goldpieces<armor[location].cost then
talknl(4,'You Cannot Afford That')
else begin
talknl(4,'You Have Purchased the '+armor[location].name);
if (location=12) or (location=13)
 then player.equipshield:=armor[location] else
 player.equiparmor:=armor[location];
player.goldpieces:=player.goldpieces-armor[location].cost;
display_gold; mod_move_armor; determine_armorclass;
end;
if which_char='M' then
if player.goldpieces<magici[location].cost then
talknl(4,'You Cannot Afford That') else begin
talknl(4,'You Have Purchased the '+magici[location].name);
player.equipmagic:=magici[location];
player.goldpieces:=player.goldpieces-magici[location].cost;
display_gold;
end;
end;

procedure purchase_weapon;
var choice:str;foundit:boolean;grabit:char;
    count4,choici:integer;
    tiddley:string[1];
begin
talk(4,'Enter Corresponding ID Number: ');
input(choice,2);foundit:=false;
choici:=value(choice); str(player.class,tiddley);
for count4:=1 to 6 do
if weapon[choici].classrest[count4]=tiddley then begin
count4:=17;foundit:=true;
display_weapon(choici);
talk(4,'Gold Pieces:  '+cstrr(player.goldpieces,10));
nl; talk(4,'Do You Wish to Purchase It? (Y/N)');
onek(grabit,'YN');
if grabit='Y' then purchase_it(choici,'W'); end;
if foundit=false then talknl(5,'You Cannot Use That!');
end;

procedure purchase_armor;
var choice:str;foundit:boolean;
count4,choici:integer; grabit:char;
tiddley:string[1];
begin
talk(4,'Enter Corresponding ID Number: ');
input(choice,2); foundit:=false;
choici:=value(choice); str(player.class,tiddley);
for count4:=1 to 6 do
if armor[choici].class_rest[count4]=tiddley then
begin
count4:=17;foundit:=true;
display_armor(choici);
talknl(4,'Gold Pieces:  '+cstrr(player.goldpieces,10));
nl;talk(4,'Do You Wish to Purchase It? (Y/N)');
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
nl;talk(4,'Do You Wish to Purchase It? (Y/N)');
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
    for nerd:=1 to 24 do begin
     falser:=false;
     for counter:=1 to length (weapon[nerd].classrest) do
     if (buthole=weapon[nerd].classrest[counter]) then
     falser:=true;
    if falser=true then begin
     row:=row+1;
     dung:=weapon[nerd].idnum[2]+weapon[nerd].idnum[3];
    val(dung,temp,temp2);
    talk(4,cstr(temp-10)+': '+weapon[nerd].name);
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
    dung:=magici[nerd].idnum[2]+magici[nerd].idnum[3];
    val(dung,temp,temp2);
    talk(4,cstr(temp-10)+': '+magici[nerd].name); goto_ansixy(row,32);
    talk(3,cstrr(magici[nerd].cost,10)); goto_ansixy(row,47); talknl(3,'GPS.');
    end;
display_gold;
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
  nerd,counter:integer;buthole:string[1];dung:string[2];
  choicer:char;
   procedure show_armor;
    begin
    row:=4;cls;str(player.class,buthole);
    talknl(4,'Armor Types Available:  ');
    talknl(4,'ID #  NAME');nl; goto_ansixy(row+1,1);
    for nerd:=1 to 13 do begin falser:=false;
    for counter:=1 to length (armor[nerd].class_rest) do
    if (buthole=armor[nerd].class_rest[counter]) then falser:=true;
    if falser=true then begin row:=row+1;
    dung:=armor[nerd].idnum[2]+armor[nerd].idnum[3]; val(dung,temp,temp2);
    talk(4,cstr(temp-10)+': '+armor[nerd].name); goto_ansixy(row,22);
    talk(4,'  '+cstr(armor[nerd].cost));
    if row>23 then row:=24;
    goto_ansixy(row,39); talknl(3,'GPS.');
    end;
 end;
display_gold;
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
if player.dungeon_level > 0 then begin
 for yetter:=1 to 24 do begin
  weapon[yetter].cost:=weapon[yetter].cost+500*player.dungeon_level;
   weapon[yetter].magical:=player.dungeon_level;
end;
 for yetter:=1 to 13 do begin
armor[yetter].cost:=armor[yetter].cost+500*player.dungeon_level;
 armor[yetter].magical:=player.dungeon_level;
 end;
end;
 repeat
  talk(4,'Choice ALMVW ,? ');
  ansic(3); onek(question,'ALMVW?');nl;
  case question of
 '?':do_gs_options;
 'A':do_armor_list;
 'M':do_magic_list;
 'V':view_initial_char;
 'W':do_weapon_list;
  end;
 moves:=moves-2; check_moves;
until question='L';
determine_armorclass;
if player.dungeon_level > 0 then read_weapons;
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
cls; assign(g1,'titler2.ans');
reset(g1);
while (not EOF(g1)) do begin
read(g1,holder);
prompt(holder);
end;
close(g1);
pausescr;
cls; assign(g1,'titler1.ans');
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
       talknl(7,' ษอออออออออออออออออออออออออออออออออป');
       talk(7,' บ (');
       talk(4,'B'); ansic(7);
       talknl(7,')uy a Drink at Bar            บ');
       talk(7,' บ (');
       talk(4,'E');
       talknl(7,')xit Gulliver''s Tavern        บ');
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
   numplayers:=random(5)+1; maxbet:=1000 * (player.dungeon_level+2);
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
    maxbet:=25*(player.dungeon_level+2);
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
       cost:=temp2 + (10 * player.dungeon_level);
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
talknl(8,'        WELCOME   TO    GULLIVER''S   TAVERN!');nl;nl;
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

overlay procedure enter_dun;
var tuss : char;
begin
talknl(5,'There are Six Entrances to Dungeon Level One --> pick one!');
talknl(5,'Please Be Sure that You have purchased your armor & weapons ... ');
talk(4,'Choice (123456):  ');
onek(tuss,'123456'); player.dungeon_level:=1;
case tuss of
'1' : begin player.xmap:=5; player.ymap:=1; player.xactual:=70; player.yactual:=7; end;
'2' : begin player.xmap:=5; player.ymap:=3; player.xactual:=62; player.yactual:=4; end;
'3' : begin player.xmap:=5; player.ymap:=5; player.xactual:=76; player.yactual:=9; end;
'4' : begin player.xmap:=1; player.ymap:=1; player.xactual:=39; player.yactual:=15; end;
'5' : begin player.xmap:=1; player.ymap:=3; player.xactual:=6; player.yactual:=3; end;
'6' : begin player.xmap:=1; player.ymap:=6; player.xactual:=31; player.yactual:=16; end;
end;
end;

overlay procedure fool;
begin
talk(8,'YOU MUST CREATE A CHARACTER FIRST OR HAVE MORE THAN 1 GPS!');
pausescr; nl;
end;

overlay procedure get_screen;
var x,y,xer,yer : integer;
 f1 : file of char;
 filename:string[10];
 temp1,temp2,temp3 : char;
procedure get_char_in_sector;
var filer : file of character_location;
temp  : character_location; x:integer;
begin
assign(filer,'locxy.dat');
reset(filer);
for x:= 1 to 750 do begin
 read(filer,temp);
if temp.dungeon_level = player.dungeon_level then
  if temp.xmaps = player.xmap then
  if temp.ymaps = player.ymap then
  if usernum <> temp.num then
 map[temp.xloc,temp.yloc]:='C';
end;
close(filer);
end;

begin
filename:='LVL';
temp1:=chr(player.dungeon_level+48);
temp2:=chr(player.xmap+48); temp3:=chr(player.ymap+48);
filename:=filename+temp1+temp2+temp3+'.DNG';
assign(f1,filename);
reset(f1);
say_saying('Loading new file, one moment please.....');
for x:=-5 to 85 do
 for y:=-5 to 28 do
 map[x,y]:=' ';
for y:=1 to 23 do
 for x:=1  to 80 do
  read(f1,map[x,y]);
for y:=1 to 23 do
for x:=1  to 80 do
 if map[x,y]='/' then map[x,y]:=' ';
close(f1);
get_char_in_sector;
for x:=0 to 79 do
 for y:=0 to 24 do
  auto_map[x,y]:=' ';
end;

overlay procedure create_for_real;
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
  nl; orig_stats;
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
    class_choosen: boolean;
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
add_constitution_bonus;
Act_hitpoints:=maxhitpoints;
end;
end;

procedure do_initial_gold;
var x: integer;
begin
with player do begin
 case class of
 1:  goldpieces:=250+random(50);
 2:  goldpieces:=175+random(10);
 3:  goldpieces:=200+random(25);
 4:  goldpieces:=150+random(100);
 5:  goldpieces:=200+random(25);
 6:  goldpieces:=200+random(50);
end;
bank:=0; experience:=0; numatt:=1; xactual:=0; yactual:=0;
dungeon_level:=0; level:=1;armorclass:=0; xmap:=0; ymap:=0;
for x:=4 to 50 do player.exemptions[x]:=0; player.exemptions[43]:=random(3)+1;
for x:=1 to 3  do exemptions[x]:=random(9)+1;
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
ok:=false; count:=10;
cls;
player.equiparmor.idnum:='NONE';
player.equipweapon.idnum:='NONE';
player.equipshield.idnum:='NONE';
player.equipmis.idnum:='NONE';
player.equipmagic.idnum:='NONE';
repeat
 roll_stats;
 choose_class;
 ask_question(ok,count);
until ok or (count=0); if count=0 then return;
created_char:=true;
pick_class;
do_hitpoints;
do_initial_gold;
view_initial_char;
save_char;
assign_moves;
end;

overlay procedure welcome;
var g2: file of char; temp :char;
begin
cls; talknl(3,'                    Welcome to Pit Fiend''s Dungeon!'); nl;
player.name:=thisuser.name;
nl;nl;nl;
talk(4,'Your Choices Brave ');
talknl(5,player.name);
assign(g2,'MAIN.ANS'); reset(g2); temp:='p'; ansic(0);
while temp <> '*' do begin
   read(g2,temp); if temp <> '*' then prompt(temp); end; close(g2);
display_moves;
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
goto_ansixy(player.yactual,player.xactual);
ansic(8); prompt('๊');
repeat goto_ansixy(1,1); talk(5,'Type "DONE" when finished: '); ansic(4);
input(hack,4); until hack='DONE';
end;


overlay procedure fast_mode;
var buth : char;
begin
say_saying('Do you Wish to Have No-Color Scroll (Faster)?');
say_saying('Recommended for 1200 and some 2400 bps? (Y/N): ');
onek(buth,'YN');
if buth='Y' then patience:=true else patience:=false;
end;

overlay procedure serial;
var serial_id : string[4]; x: byte;
begin
serial_id:='TTVY';
talk(7,'Serial Number:  ');
for x:=1 to 4 do
 talk(8,cstr(ord(serial_id[x])));
nl;
end;
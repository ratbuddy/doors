overlay procedure init_combat;
var x,n:byte;

begin
clear_space;
dball:=0;
for x:=1 to 4 do begin
meanies[x].armor_class:=monster_array[type_mon[x]].armor_class;
for n:=1 to how_many[x] do begin
meanies[x].hpsleft[n]:=random(monster_array[type_mon[x]].maxhp
   -monster_array[type_mon[x]].minhp+1)
   +monster_array[type_mon[x]].minhp;
meanies[x].com_loc[n]:=true; {set to missile}
meanies[x].spoints[n]:=monster_array[type_mon[x]].spoints;
end;
meanies[x].mis_amnt:=how_many[x];  {chnage nacl}
meanies[x].mel_amnt:=0;
meanies[x].numat:=monster_array[type_mon[x]].numat;
meanies[x].range:=monster_array[type_mon[x]].range;
meanies[x].maxdam:=monster_array[type_mon[x]].maxdam;
meanies[x].mindam:=monster_array[type_mon[x]].mindam;
meanies[x].mis_maxdam:=monster_array[type_mon[x]].mis_maxdam;
meanies[x].mis_mindam:=monster_array[type_mon[x]].mis_mindam;
meanies[x].level:=monster_array[type_mon[x]].level;
meanies[x].staff:=monster_array[type_mon[x]].staff;
meanies[x].speed:=monster_array[type_mon[x]].speed;
end;
for x:=1 to 11 do begin
 goto_ansixy(x,1);
 print(CHR(27)+'[K');
end;
x:=1;
while (type_mon[x]<>50) and (x<4) do x:=x+1;
com_num:=x-1;
for x:=1 to 3 do dam_tab[x]:=random(10)+1;
goto_ansixy(3,20);
talknl(7,'MELEE               MISSILE'); nl;
for x:=1 to com_num do display_monsters(x);
end;


overlay function fire_1st:boolean;
var cntt,maxsp,pl_maxsp:byte;

procedure regenate;
var gg,aa : byte;
begin
 for gg:=1 to com_num do
  for aa:= 1 to how_many[gg] do
   if (monster_array[type_mon[gg]].regen>0) then
     if meanies[gg].hpsleft[aa]>0 then begin
       inc(meanies[gg].hpsleft[aa],monster_array[type_mon[gg]].regen);
       display_monsters(gg);
       say_saying(monster_array[type_mon[gg]].name+' Regnerates '+cstr(monster_array[type_mon[gg]].regen)+
         ' Hit Points');
     end;
for gg:=1 to 3 do
 if player.status[gg]<>8 then
  if (PLAYER.equipring[gg].idnum=12) or (player.equipring[gg].idnum=13) then
   if player.stats[gg,11]<player.stats[gg,10] then begin
    inc(player.stats[gg,11],player.equipring[gg].magical);
    if player.stats[gg,11]>player.stats[gg,10] then player.stats[gg,11]:=player.stats[gg,10];
    say_saying(player.name[gg]+' Regenerates '+cstr(player.equipring[gg].magical)+' Hit Points!');
    display_char(gg);
   end;
end;

begin
maxsp:=0; pl_maxsp:=0;
for cntt:=1 to com_num do
  if meanies[cntt].speed > maxsp then maxsp:=meanies[cntt].speed;
for cntt:=1 to 3 do
 if (player.status[cntt]<>8) then
  if player.stats[cntt,4]>pl_maxsp then
   begin
    if (player.stats[cntt,15]=3) and (dam_tab[cntt]>0) then dam_tab[cntt]:=dam_tab[cntt] div 2;
    pl_maxsp:=player.stats[cntt,4];
    pl_maxsp:=player.stats[cntt,13]-act_stats[cntt,13]+pl_maxsp;
   end;
maxsp:=maxsp+random(20);
pl_maxsp:=pl_maxsp+random(20);
if maxsp>pl_maxsp then fire_1st:=false else fire_1st:=true;
say_saying('Combat Round #'+cstr(roundcnt));
if roundcnt mod 3 =0 then regenate;
end;

overlay procedure player_attack;
var play_num,arr_loc,setnum:byte; cleared:boolean; chx:char;

function which_group:byte;
var tx:byte;
begin
repeat
say_saying('Which Group (0 to Abort) (1-'+cstr(com_num)+') :');
onek(chx,'01234');
tx:=ord(chx)-48;
until (tx<com_num+1) and ((meanies[tx].mel_amnt>0) or (meanies[tx].mis_amnt>0));
which_group:=tx;
end;


function all_dead:boolean;
var gg,aa,d1,d2:byte;
begin
D2:=0;
for gg:=1 to com_num do begin
  d1:=0;
  for aa:=1 to how_many[gg] do
    if  meanies[gg].hpsleft[aa]<1 then d1:=d1+1;
  if d1=how_many[gg] then d2:=d2+1;
end;
if d2=com_num then all_dead:=true else all_dead:=false;
end;

function determine_individual(temp:boolean):boolean;
var bcnt:byte; pass:boolean;
begin
pass:=false; bcnt:=1;
repeat
  if (meanies[setnum].com_loc[bcnt]<>temp) and (meanies[setnum].hpsleft[bcnt]>0)
   then begin pass:=true; arr_loc:=bcnt; bcnt:=how_many[setnum]+6; end;
bcnt:=bcnt+1;
until (pass) or (bcnt>how_many[setnum]);
determine_individual:=pass;
end;

procedure menu;
begin
clear_space;
say_saying('(1..4) Attack Set #  (C)ast Spell');
say_saying('(F)ire Ring          (M)odify A Set''s Missile/Melee Status');
say_saying('(P)ass This Round    (R)etreat From Battle');
say_saying('(U)se Potion         (Z) Return to BBS, No Save');
end;

  procedure loc_change(temp1:byte; yt:boolean);
  var compl,gct:byte; txt:string[8]; b,c:integer;
  begin
  meanies[temp1].speed:=1;
  if yt then txt:='MISSILE' else txt:='MELEE'; compl:=0;
  if yt then begin b:=1; c:=-1; end else begin b:=-1; c:=1; end;
 for gct:=1 to how_many[temp1] do
  if (meanies[temp1].com_loc[gct]<>yt) and (meanies[temp1].hpsleft[gct]>1) then
   if player.stats[play_num,13]+random(20)> meanies[temp1].speed+random(20) then begin
    say_saying('1 '+monster_array[type_mon[temp1]].name+' is now in '+txt+' Combat!');
    binc(meanies[temp1].mis_amnt,b); binc(meanies[temp1].mel_amnt,c);
    meanies[temp1].com_loc[gct]:=yt;
    binc(compl,1);
   end;
   display_monsters(temp1);
   say_saying(cstr(compl)+' Successful Moves to '+txt+' Combat!');
 end;

function changer:boolean;
var temp1:byte;
begin
clear_space;
say_saying('Force Move Action');
temp1:=which_group;
if (temp1=0) then changer:=false else begin changer:=true;
say_saying('Do You Want the '+monster_array[type_mon[temp1]].name+' in 1. Missile or 2. Melee? :');
  onek(chx,'12');
  if chx='1' then loc_change(temp1,true) else loc_change(temp1,false);
end;
end;

 function hit(tem_it:items):boolean;
 var clash:byte; mods:integer;
 begin
 case player.stats[play_num,15] of
 1: clash:=5;
 2: if not tem_it.testers then clash:=5 else clash:=10;
 3: clash:=13;
 4: clash:=7;
 5: clash:=11;
 6: clash:=6;
 7: clash:=7;
end;
if tem_it.testers then mods:=modifier(player.stats[play_num,1])
 else mods:=modifier(player.stats[play_num,4]);
if player.status[play_num]=5 then mods:=mods+random(6)+2;
 mods:=clash-(tem_it.magical+mods+player.stats[play_num,16]+player.stats[play_num,12])
  +meanies[setnum].armor_class; if mods>20 then mods:=20;
 if random(20)+1>mods-1 then hit:=true else begin
  say_saying(player.name[play_num]+' Misses '+monster_array[type_mon[setnum]].name+'!');
  hit:=false;
 end;
end;

 procedure do_damage(tem_it:items);
 var mods:integer;
 begin
 mods:=modifier(player.stats[play_num,1])+tem_it.magical;
 mods:=mods+random(tem_it.maxdam+tem_it.mindam)+1-tem_it.mindam;
 if mods<1 then mods:=1;
 if (player.stats[play_num,15]=5) and (tem_it.testers) then
 if random(20)<player.stats[play_num,12] then begin
  say_saying(player.name[play_num]+' Back Stabs!'); mods:=mods*2; end;
 inc(meanies[setnum].hpsleft[arr_loc],(0-mods));
say_saying(player.name[play_num]+' Hit for '+cstr(mods)+' Points of Damage with a '+tem_it.name);
  inc(dam_tab[play_num],mods);
  end;

  function killed(tester:boolean) : boolean;
  var b,c:integer;
  begin
  if not tester
   then begin b:=0; c:=-1; end else begin b:=-1; c:=0; end;
   if meanies[setnum].hpsleft[arr_loc]<1 then begin
    say_saying('You have Slain a '+monster_array[type_mon[setnum]].name+'!');
    binc(meanies[setnum].mel_amnt,b);
    binc(meanies[setnum].mis_amnt,c);
    killed:=true;
   end else killed:=false;
  end;

  procedure attack_melee(wepon:items);
  var max_at,cnt2:byte;   tft:boolean;
  begin
  tft:=wepon.testers;
  max_at:=player.stats[play_num,13]+wepon.numat+wepon.magical-1;
  for cnt2:=1 to max_at do
    if not determine_individual(tft) then
       cnt2:=max_at else
       if hit(wepon) then begin do_damage(wepon);
         if killed(wepon.testers) then display_monsters(setnum);
       end;
  end;

 function attack_missile:boolean;
 begin
 if player.equipmis[play_num].idnum=10 then begin
   attack_missile:=false; say_saying('You don''t have a Missile Weapon!');
 end else begin attack_melee(player.equipmis[play_num]); attack_missile:=true;
 end;
 end;

 function attack(gg:char):boolean;
 var gj:boolean;
 begin
 setnum:=ord(gg)-48; gj:=true;
 if meanies[setnum].mel_amnt>0 then
     attack_melee(player.equipweapon[play_num])
     else if meanies[setnum].mis_amnt>0 then gj:=attack_missile
     else begin say_saying('This Group is Not Valid!  Try Another Group or Pass!');
          gj:=false; end;
 attack:=gj;
 end;

procedure save_throw(var damage:integer);
begin
if random(20)-player.stats[play_num,12]+3 > (20-meanies[setnum].level-meanies[setnum].staff)
then begin
  say_saying(monster_array[type_mon[setnum]].name+' Has Made His Saving Throw!');
  damage:=damage div 2;
  end;
if damage<1 then damage:=1;
end;

procedure equipview;
begin
clear_space;
say_saying('Armor     :  '+player.equiparmor[play_num].name+' +'+cstr(player.equiparmor[play_num].magical));
say_saying('Weapon    :  '+player.equipweapon[play_num].name+' +'+cstr(player.equipweapon[play_num].magical));
say_saying('Mis Weapon:  '+player.equipmis[play_num].name+' +'+cstr(player.equipmis[play_num].magical));
say_saying('Ring      :  '+player.equipring[play_num].name+' +'+cstr(player.equipring[play_num].magical));
say_saying('Healing   :  '+cstr(player.equippotions[play_num,1]) +' Spell Rest:  '
   +cstr(player.equippotions[play_num,2]));
end;

procedure mosh(var a:byte; var b,c:integer);
var t,addon:integer;
begin
a:=a-1; addon:=0;
for t:=1 to player.stats[play_num,12] do addon:=addon+random(8)+1;
b:=b+addon+modifier(player.stats[play_num,6]);
if b>c then b:=c;
display_char(play_num);
say_saying('Gulp... Gulp... Gulp...');
end;

function use_potion(var p1,p2:byte):boolean;
var cfx:char; holdd:boolean;
begin
holdd:=true;
if (p1=0) and (p2=0) then begin
say_saying('You don''t have any Potions to Use!');
holdd:=false;
end else begin
say_saying('Which? 0. None, 1. Healing ('+cstr(p1)+')  or   2. Sp. Rest ('+cstr(p2)+') :');
onek(cfx,'012');
case cfx of
 '0' : holdd:=false;
 '1' : if p1<0 then begin say_saying('No Healing Potions!'); holdd:=false; end else
       mosh(p1,player.stats[play_num,11],player.stats[play_num,10]);
 '2' : if p1<0 then begin say_saying('No Magic SpellPoint Potions!'); holdd:=false; end
       else mosh(p2,player.stats[play_num,9],player.stats[play_num,8]);
end;
end;
use_potion:=holdd;
end;

function fire_ring(var rng:items) : boolean;
var scale:byte; dama:integer; humty:boolean;
begin
if not rng.testers then begin
 fire_ring:=false; say_saying('A '+rng.name+' is NOT an offensive ring!')
 end else begin
 say_saying('Use Ring!');
 setnum:=which_group;
 if setnum=0 then begin fire_ring:=false; say_saying('Aborted!'); end
  else begin binc(rng.charges,-1);
  for scale:=1 to how_many[setnum] do
  if meanies[setnum].hpsleft[scale]>0 then begin
  fire_ring:=true;
  dama:=random(rng.maxdam-rng.mindam)+rng.mindam;
  save_throw(dama);
  inc(dam_tab[play_num],dama);
  inc(meanies[setnum].hpsleft[scale],0-dama);
  if rng.charges<1 then rng:=ring[1];
  say_saying('Your Ring '+cstr(dama)+' Points of Damage!');
  if meanies[setnum].com_loc[scale] then humty:=false else humty:=true;
  arr_loc:=scale;
  if killed(humty) then display_monsters(setnum);
   end;
  end;
 end;
end;

procedure protevil;
var b:byte;
begin
inc(dam_tab[play_num],random(30)+1);
say_saying(player.name[play_num]+' Casts Protection From Evil!');
for b:=1 to 3 do begin inc(player.stats[b,14],1); display_char(b);
end;
end;

function choose_char:byte;
var whomchar:char;
begin
say_saying('Who do you Wish to cast the Spell Upon? (0 to Abort) (1-3): ');
onek(whomchar,'0123');
choose_char:=ord(whomchar)-48;
if whomchar='0' then say_saying('Spell Aborted!');
end;

function ignore:boolean;
var whom:byte;
begin
whom:=choose_char;
if whom=0 then ignore:=false else begin
  dam_tab[whom]:=-1*random(10*player.stats[play_num,12]);
  say_saying(player.name[play_num]+' Casts Ignore on '+player.name[whom]+'!');
  ignore:=true;
  end;
end;


function shield(affect:byte; mod_level:boolean):boolean;
var whom:byte; how_much:integer;
begin
how_much:=1;
whom:=choose_char;
if whom=0 then shield:=false else begin
 if mod_level then how_much:=how_much*player.stats[play_num,12];
 inc(player.stats[whom,affect],how_much);
 display_char(whom);
end;
end;

 function healspell(min,max:byte; mod_level:boolean):boolean;
 var timez,how_much:integer;  cnnt,whom:byte;
 begin
 how_much:=1;
 if mod_level then timez:=player.stats[play_num,12] else timez:=1;
 whom:=choose_char;
 if whom=0 then healspell:=false else begin
  healspell:=true;
  for cnnt:=1 to timez do inc(how_much,random(max-min)+min);
  inc(player.stats[whom,11],how_much);
  if player.stats[whom,11]> player.stats[whom,10] then
  player.stats[whom,11]:=player.stats[whom,10];
  display_char(whom);
  say_saying(player.name[whom]+' restores '+cstr(how_much)+' Hit Points!');
  inc(dam_tab[play_num],how_much div 2);
 end;
 end;

 function confusion:boolean;
 var cnnt:byte; inx:integer;
 begin
 setnum:=which_group; inx:=4;
 if setnum=0 then begin say_saying('Aborted!'); confusion:=false; end else
  begin
   confusion:=true;
   save_throw(inx);
   if inx=2 then say_saying('Monsters are not affected!') else
   inc(dam_tab[play_num],random(20)+10);
   begin
    say_saying('Monsters are Confused! Less Chance of Moving Around!');
    meanies[setnum].speed:=random(2)+1;
    if meanies[setnum].range>0 then meanies[setnum].range:=random(10)+1;
   end;
 end;
end;

 function invisible:boolean;
 var whom:byte;
 begin
 whom:=choose_char;
 if whom=0 then invisible:=false else begin
   say_saying('Invisibility is cast upon '+player.name[whom]+'!');
   inc(player.stats[whom,14],4);
   inc(player.stats[whom,16],4);
   display_char(whom);
   invisible:=true;
 end;
 end;

 function curse:boolean;
 var chxx:integer;
 begin
 say_saying('Casting Curse');
 setnum:=which_group; chxx:=4;
 if setnum=0 then begin say_saying('Aborted!'); curse:=false end else
 begin
 save_throw(chxx);
 if chxx=2 then say_saying('Spell Not Put in Effect!') else
  begin
  if meanies[setnum].armor_class>0 then binc(meanies[setnum].armor_class,-1);
  say_saying('Curse in Effect!');
  curse:=true;
  end;
 end;
end;

procedure major_heal;
var asd:byte;
begin
for asd:=1 to 3 do begin player.stats[asd,11]:=player.stats[asd,10];
display_char(asd);
end;
say_saying('Party Healed!');
end;

function freezer:boolean;
var asd:integer;
begin
say_saying('Casting Freeze Spell!'); asd:=4;
setnum:=which_group;
if setnum=0 then begin freezer:=false; say_saying('Aborted!'); end else
 begin
  save_throw(asd); freezer:=true;
  if asd=2 then say_saying('Freeze Spell Resisted!') else begin
    meanies[setnum].speed:=1;
    if meanies[setnum].numat>1 then binc(meanies[setnum].numat,-1);
    say_saying('Monsters Frozen!');
  end;
 end;
end;

procedure firebal(mind,maxd:byte; und:boolean);
var acnt,bcnt,ccnt:byte; dama:integer; xc:boolean;
begin
for setnum:=1 to com_num do
  if (und) and (monster_array[type_mon[setnum]].undead=FALSE) then
   say_saying('Spell does not affect '+monster_array[type_mon[setnum]].name)
  else
   for bcnt:=1 to how_many[setnum] do
    if meanies[setnum].hpsleft[bcnt]>0 then begin
       for ccnt:=1 to player.stats[play_num,12] do dama:=random(maxd-mind)+mind;
       save_throw(dama);
       inc(meanies[setnum].hpsleft[bcnt],0-dama);
       inc(dam_tab[play_num],dama div 2);
       say_saying('Your Spell Does '+cstr(dama)+' Points of Damage!');
       arr_loc:=bcnt;
       if meanies[setnum].com_loc[bcnt] then xc:=false else xc:=true;
       if killed(xc) then display_monsters(setnum);
    end;
end;

function flame(mind,maxd:byte; mod_level:boolean; nam:str):boolean;
var dama:integer; timz,acnt,bcnt:byte; xc:boolean;
begin
dama:=0;
if mod_level then timz:=player.stats[play_num,12] else timz:=1;
setnum:=which_group;
if setnum=0 then begin say_saying('Aborted!'); flame:=false; end else
  for bcnt:=1 to how_many[setnum] do
    if meanies[setnum].hpsleft[bcnt]>1 then begin
  for acnt:=1 to timz do inc(dama,random(maxd-mind)+mind);
  save_throw(dama);
  inc(meanies[setnum].hpsleft[bcnt],0-dama);
  inc(dam_tab[play_num],dama div 2);
  say_saying(nam+' did '+cstr(dama)+' Points of Damage!');
  arr_loc:=bcnt;
  if meanies[setnum].com_loc[bcnt] then xc:=false else xc:=true;
  if killed(xc) then display_monsters(setnum);
  flame:=true; dama:=0;
  end;
end;

 function fing_death:boolean;
 var acnt:byte; var dama:integer;
 begin
 say_saying('Casting Finger of Death!'); dama:=4; acnt:=0;
 setnum:=which_group;
 if setnum=0 then begin say_saying('Aborted!'); fing_death:=false; end
 else begin fing_death:=true;
  inc(dam_tab[play_num],random(150)+10);
   repeat
    binc(acnt,1);
    if meanies[setnum].hpsleft[acnt]>1 then begin
     acnt:=101;
     save_throw(dama);
     if dama=2 then say_saying('Spell has no Effect!') else
     begin
     say_saying('Your Finger of Death Takes its Effect!');
     meanies[setnum].hpsleft[acnt]:=-1;
     if killed(meanies[setnum].com_loc[acnt]) then display_monsters(setnum);
     end;
   end;
 until (acnt>100) or (acnt=how_many[setnum]);
end;
end;

procedure listspells;
var x:byte;
begin
for x:=1 to 25 do
 if player.stats[play_num,9]>magic[x].numat-1 then say_saying(cstr(x)+'. '+magic[x].name);
say_saying('Continue Playing....');
end;

 function caster:boolean;
 var blocker:boolean; chstr:str; spellnum:integer;
 begin
 blocker:=true;
 if not player.spells[play_num] then
  begin say_saying('Your Character cannot cast spells!'); blocker:=false; end
  else begin
   repeat
    say_saying('Which Spell do You Wish to Cast? (0 for None, 99 for list)! :');
    input(chstr,2);
    spellnum:=value(chstr);
   until ((spellnum>-1) and (spellnum<26)) or (spellnum=99);
    if (spellnum>0) and (spellnum<99) then
      if magic[spellnum].numat>player.stats[play_num,9] then begin
         say_saying('Not Enough Spell Points!'); blocker:=false; end;
    if blocker then
 case spellnum of
 0,5,8,14,15,16,19,21,25 : begin say_saying('This Spell is NOT used here!');
         blocker:=false; end;
 1: begin protevil; blocker:=true; end;
 2: blocker:=curse;
 3: blocker:=flame(1,8,false,'Fire Finger');
 4: blocker:=shield(14,true);
 6: blocker:=healspell(1,12,false);
 7: begin firebal(1,20,true); blocker:=true; end;
 9: blocker:=ignore;
10: blocker:=confusion;
11: blocker:=healspell(1,10,true);
12: begin firebal(1,8,false); blocker:=true; end;
13: blocker:=flame(1,16,true,'Flame Strike');
17: blocker:=invisible;
18: blocker:=shield(13,false);
20: blocker:=freezer;
22: blocker:=fing_death;
23: begin major_heal; blocker:=true; end;
24: begin firebal(1,20,false); blocker:=true; end;
99: begin listspells; blocker:=false; end;
 end;
end;
if blocker then begin inc(player.stats[play_num,9],0-magic[spellnum].numat);
display_char(play_num); end;
caster:=blocker;
end;

function retreat:boolean;
var chy:char;
begin
say_saying('Are you Sure you Want to Retreat? (Y/N) :');
onek(chy,'NY');
if chy='N' then retreat:=false else begin
retreat:=true;
com_done:=1; {retreat}
end;
end;

begin
for play_num:=1 to 3 do
 if player.status[play_num]<>8 then
 repeat
 cleared:=true;
 say_saying(player.name[play_num]+',  Choice: 1234CEFMPRUZ?, :');
 onek(chx,'1234CEFMPRUZ?');
case chx of
 '1'..'4':cleared:=attack(chx);
 'C':  cleared:=caster;
 'E': begin equipview; cleared:=false; end;
 'F': cleared:=fire_ring(player.equipring[play_num]);
 'M': cleared:=changer;
 'P': say_saying(player.name[play_num]+' Passes this Round');
 'R': cleared:=retreat;
 'U': cleared:=use_potion(player.equippotions[play_num,1],player.equippotions[play_num,2]);
 'Z': return;
 '?': begin menu; cleared:=false; end;
end;
until cleared;
if all_dead then com_done:=2;
end;

overlay procedure monster_attack;
type verber=string[10];
var set_num, arr_loc:byte;
spcost_mon:array [0..25] of byte;

function nail_whom:byte;
var cntt,whom:byte; temp:integer;
begin
temp:=-32000; whom:=1;
for cntt:=1 to 3 do begin
 inc(dam_tab[cntt],random(60)+1);
 if (dam_tab[cntt]>temp) and (player.status[cntt]<>8) then begin
     whom:=cntt; temp:=dam_tab[cntt]; end;
end;
nail_whom:=whom;
end;

function do_save(targ,test:byte; var dama:integer):boolean;
begin
if random(100)+player.stats[targ,12]*5+player.stats[targ,6]+(player.stats[targ,16]*3)
   >80+(meanies[set_num].level*2) then
begin say_saying(player.name[targ]+' made his/her saving throw!'); do_save:=true; end
 else begin say_saying(player.name[targ]+' missed his/her saving throw!>');
      do_save:=false; end;
if (player.equipring[targ].idnum=19) and (test=1) then
 if player.equipring[targ].charges-dama< 0 then
  begin dama:=0-player.equipring[targ].charges-dama;
  player.equipring[targ]:=ring[1];
  say_saying(player.name[targ]+' Ring is Useless now... absorbed some of the damage!');
  end else begin player.equipring[targ].charges:=player.equipring[targ].charges-dama;
  say_saying(player.name[targ]+' Ring Absorbs the Damage, it has '+cstr(player.equipring[targ].charges)+' Left!');
  dama:=0;
 end
end;

procedure drain_exp(targ:byte);
var tt,affts:integer;
begin
affts:=meanies[set_num].level*(100+random(20));
if player.stats[targ,15]=4 then tt:=50 else tt:=0;
if (random(100)+meanies[set_num].level*3)
    >25+player.stats[targ,12]+modifier(player.stats[targ,6])+tt
 then begin
 say_saying(monster_array[type_mon[set_num]].name
  +' Drains '+player.name[targ]+' '+cstr(affts)+' Points of Experience!');
 player.experience[targ,1]:=player.experience[targ,1]-affts;
 end;
end;

procedure poison(victim:byte);
var g:boolean; dam:integer;
begin
g:=do_save(victim,0,dam);
if g then begin
 say_saying(player.name[victim]+' is Poisoned from the Wound!');
 player.status[victim]:=5;
 display_char(victim);
 end;
end;

procedure melee(mid,mad:byte; verb:verber);
var num_att,target:byte; damag:integer;
    namer:string[20];
begin
namer:=monster_array[type_mon[set_num]].name;
for num_att:=1 to meanies[set_num].numat do begin
 target:=nail_whom;
 if player.stats[num_att,14]<random(20)+meanies[set_num].level then
 begin
  damag:=random(mad-mid)+mid;
  say_saying(namer+' '+verb+' and hits for '+cstr(damag)+' Points of Damage against '+player.name[target]);
  if (namer='Swings') and (monster_array[type_mon[set_num]].drainer) then drain_exp(target);
  if (namer='Swings') and (monster_array[type_mon[set_num]].poison>0)
    and (random(100)<monster_array[type_mon[set_num]].poison) then poison(target);
  inc(player.stats[target,11],0-damag);
  check_player_death;
  display_char(target);
 end
else say_saying(namer+', '+verb+' and Misses against '+player.name[target]);
end;
end;

procedure close_melee;
begin
if meanies[set_num].speed*5>random(100) then
 begin
  meanies[set_num].com_loc[arr_loc]:=false;
  binc(meanies[set_num].mel_amnt,1);
  binc(meanies[set_num].mis_amnt,-1);
  say_saying(monster_array[type_mon[set_num]].name+' Closes to Melee!');
  display_monsters(set_num);
 end else say_saying(monster_array[type_mon[set_num]].name+' Fails to Close to Melee!');
end;

procedure missile_fire;
begin
if random(100)+1>meanies[set_num].range then close_melee else
  melee(meanies[set_num].mis_mindam,meanies[set_num].mis_maxdam,'Shoots');
end;

procedure magic_mis(save,base:byte;nam:uv);
var cty,terg:byte; dama:integer;tty:boolean;
begin
terg:=nail_whom; dama:=0;
for cty:=1 to meanies[set_num].level do dama:=random(base)+1;
if save=1 then tty:=do_save(terg,1,dama);
inc(player.stats[terg,11],0-dama);
display_char(terg);
check_player_death;
say_saying(monster_array[type_mon[set_num]].name+' Casts '+nam+' for '+cstr(dama)+' Points of Damage on '
+player.name[terg]);
end;

procedure curser(eff:byte; nam:uv);
var shitz:integer; tty:boolean; trg:byte;
begin
trg:=nail_whom;
say_saying(monster_array[type_mon[set_num]].name+' Casts A '+nam+' at '+player.name[trg]);
tty:=do_save(trg,0,shitz);
if tty then say_saying(nam+' Has No Effect!') else
 begin
 inc(player.stats[trg,16],0-eff);
 inc(player.stats[trg,14],0-eff);
 display_char(trg);
 say_saying('Battle Integrity and Armor Class Affected by -'+cstr(eff));
 end;
end;

procedure shield(adder:byte; nam:uv);
var grpnum:byte;
begin
if adder=5 then for grpnum:=1 to 3 do inc(player.stats[grpnum,16],-1);
grpnum:=random(com_num)+1;
if (adder=1) or (adder=5) then binc(meanies[grpnum].armor_class,1);
if adder=2 then begin
 binc(meanies[grpnum].speed,random(meanies[set_num].level)+1);
 binc(meanies[grpnum].numat,1);
end;
if adder=3 then binc(meanies[grpnum].level,1);
if adder=4 then begin binc(meanies[grpnum].armor_class,4); binc(meanies[grpnum].speed,5); end;
say_saying(monster_array[type_mon[set_num]].name+' Casts '+nam+' on '+monster_array[type_mon[grpnum]].name);
end;

procedure webber;
var tty:boolean; damag:integer; trg:byte;
begin
trg:=nail_whom;
say_saying(monster_array[type_mon[set_num]].name+' Casts Web on '+player.name[trg]);
say_saying('Spewing from the Monsters finger tips comes a sticky web!');
tty:=do_save(trg,0,damag); damag:=1;
if tty then
    say_saying('The Web Spell Has Minimal Effect!')
   else damag:=random(meanies[set_num].level)+1;
say_saying(player.name[trg]+'`s Agility goes down by '+cstr(damag));
inc(player.stats[trg,4],0-damag);
determine_armorclass;
display_char(trg);
end;

procedure fball(nam:uv);
var tty:boolean; a,b:byte; dame:integer;
begin
for a:=1 to 3 do
  if player.status[a]<>8 then begin
   dame:=0;
   for b:=1 to meanies[set_num].level do dame:=dame+random(8)+1;
   say_saying(monster_array[type_mon[set_num]].name+' '+nam);
   tty:=do_save(a,1,dame);
   say_saying('Damage from '+nam+' on '+player.name[a]+' is '+cstr(dame));
   inc(player.stats[a,11],0-dame);
   check_player_death;
   display_char(a);
 end;
end;

procedure mass_invs;
var g:byte;
begin
say_saying(monster_array[type_mon[set_num]].name+' Casts Mass Invisibility!');
say_saying('Improves Speed and Armor Class!');
for g:=1 to com_num do begin
  binc(meanies[g].armor_class,4);
  binc(meanies[g].speed,5);
end;
end;

procedure hpboost;
var cnnt,cnnt2,grpnum,healer:byte;
begin
grpnum:=random(6)+1;
if grpnum>com_num then grpnum:=set_num;
say_saying(monster_array[type_mon[set_num]].name+' Casts Hit Point Boost on '+
  monster_array[type_mon[grpnum]].name);
for cnnt:=1 to how_many[grpnum] do
  if meanies[grpnum].hpsleft[cnnt]>0 then begin healer:=0;
   for cnnt2:=1 to meanies[set_num].level do binc(healer,random(3)+1);
   inc(meanies[grpnum].hpsleft[cnnt],healer);
   say_saying(monster_array[type_mon[grpnum]].name+' Heals '+cstr(healer));
  end;
end;

procedure delayed_blast;
begin
say_saying('*******  '+monster_array[type_mon[set_num]].name+' Casts Delayed Blast Fireball *******');
say_saying('*******  Will detonate at end of combat!');
dball:=roundcnt;
end;

procedure mon_cast(splnum:byte);
begin
inc(meanies[set_num].spoints[arr_loc],0-spcost_mon[meanies[set_num].staff]);
case splnum of
 1: magic_mis(0,4,'Magic Missile');
 2: curser(1,'Curse');
 3: shield(1,'Shield');
 4: webber;
 5: curser(4,'Deadly Curse');
 6: shield(2,'Speed Demon');
 7: shield(3,'Heroism');
 8: magic_mis(1,12,'Lightning Bolt');
 9: fball('Casts Fireball');
10: if dball=0 then delayed_blast else fball('Casts Fireball');
11: shield(4,'Invisibility');
12: mass_invs;
13: hpboost;
14: shield(5,'Protection');
15: magic_mis(1,10,'Acid Stream');
16: fball('Breathes Fire');
17: fball('Breathes Hot Steam');
18: fball('Breathes a Cold Jet');
end;
end;

procedure choices;
var apass:boolean;
begin
apass:=false;
if (meanies[set_num].spoints[arr_loc]>spcost_mon[meanies[set_num].staff]-1)
   and (random(100)>20-meanies[set_num].level)
  then begin mon_cast(meanies[set_num].staff); apass:=true end;
if not apass then
  if meanies[set_num].com_loc[arr_loc] then missile_fire else
   melee(meanies[set_num].mindam,meanies[set_num].maxdam,'Swings');
end;

procedure init_spcost;
begin
spcost_mon[0]:=255;
spcost_mon[1]:=5; spcost_mon[2]:=5; spcost_mon[3]:=5;
spcost_mon[4]:=12; spcost_mon[5]:=20;
spcost_mon[6]:=30; spcost_mon[7]:=45;
spcost_mon[8]:=50; spcost_mon[9]:=50;
spcost_mon[10]:=75; spcost_mon[11]:=25;
spcost_mon[12]:=65; spcost_mon[13]:=20;
spcost_mon[14]:=10; spcost_mon[15]:=60;
spcost_mon[16]:=20; spcost_mon[17]:=60;
spcost_mon[18]:=50;
end;


begin
init_spcost;
say_saying('Monster Attack');
for set_num:=1 to com_num do
 for arr_loc:=1 to how_many[set_num] do
   if meanies[set_num].hpsleft[arr_loc]>0 then choices;
end;

overlay procedure housekeeper(directive:byte);
var treasure:real; dir2:byte;

 procedure increase_stats(playnum:byte);
 var x,y: byte;
    let : char;
begin
 for y:=1 to 3 do begin
 clear_space;
 for x:=1 to 11 do begin
  goto_ansixy(x,1);
  print(CHR(27)+'[K');
 end; goto_ansixy(1,1);
 talknl(4,player.name[playnum]+' Has Gained a Level!'); ansic(0);
 print(' A.  Stength      '+cstr(act_stats[playnum,1]));
 print(' B.  Intelligence '+cstr(act_stats[playnum,2]));
 print(' C.  Wisdom       '+cstr(act_stats[playnum,3]));
 print(' D.  Coordination '+cstr(act_stats[playnum,4]));
 print(' E.  Health       '+cstr(act_stats[playnum,5]));
 print(' F.  Luck         '+cstr(act_stats[playnum,6]));
 print(' G.  Personality  '+cstr(act_stats[playnum,7]));
 say_saying(player.name[playnum]+' May Now Increase any '+cstr(4-y)+' Stats!');
 say_saying('Select Letter (A-G): ');
 onek(let,'ABCDEFG');
 inc(player.stats[playnum,ord(let)-64],1);
 inc(act_stats[playnum,ord(let)-64],1);
end;
if (act_stats[playnum,12] mod 5 = 0) then begin
  inc(player.stats[playnum,13],1);
  inc(act_stats[playnum,13],1);
  say_saying(player.name[playnum]+'Now Has '+cstr(player.stats[playnum,13])+' Attacks per Round');
end;
determine_armorclass;
end;

procedure give_exp;
var ct,ct2,surv : byte;
    atemp : real;
begin
atemp:=0; surv:=0;
for ct:=1 to 3 do if player.status[ct]<>8 then binc(surv,1);
for ct:=1 to com_num do
 for ct2:=1 to how_many[ct] do
 atemp:=monster_array[type_mon[ct]].experience+atemp;
say_saying('The party has earned '+cstrr(atemp,10)+' Experience Points!');
atemp:=int(atemp/surv);
say_saying('Each Living Member of the party has earned '+cstrr(atemp,10)+' Experience Points!');
for ct:=1 to 3 do
 if player.status[ct]<>8 then player.experience[ct,1]:=player.experience[ct,1]+atemp;
end;


function sureyn:boolean;
var chxx:char;
begin
say_saying('Leave Chest Behind Option');
say_saying('Treasure Inside will be Lost forever?  Are you Sure (N/Y)? :');
onek(chxx,'NY');
if chxx='N' then sureyn:=false else sureyn:=true;
end;

procedure give_grub;
begin
say_saying('YUMM!  You find '+cstr(dung_room[room_num].food)+' Food!');
binc(player.food[active],dung_room[room_num].food);
if player.food[active] > 99 then player.food[active]:=99;
say_saying(player.name[active]+' now has '+cstr(player.food[active])+' Food Rations!');
pausescr;
end;

procedure read_scroll;
begin
clear_space;
say_saying('Your Angel of Protection appears and says, ');
say_saying(dung_room[room_num].scrollsay);
pausescr;
end;

 procedure give_gold;
 begin
 say_saying('Additionally the party finds: '+cstr(dung_room[room_num].amount)+' Gold Pieces!');
 player.goldpieces:=player.goldpieces+dung_room[room_num].amount;
 say_saying('The Party now has '+cstrr(player.goldpieces,10)+' Gold Pieces!');
 pausescr;
 end;

function receiver:byte;
var chxx:char; g:boolean;
begin
g:=false;
repeat
say_saying('Who Should Receive this Item, 0 For No One (1-3): ');
onek(chxx,'0123');
g:=true;
if chxx<>'0' then
 if player.status[ord(chxx)-48]=8 then begin
   say_saying(player.name[ord(chxx)-48]+' is Dead!');
   g:=false;
   end;
until g;
receiver:=ord(chxx)-48;
end;

procedure giveweapon(kind,plus:byte);
var b:byte; okl:boolean;
begin
repeat;
say_saying('You find a '+weapon[kind].name+' +'+cstr(plus));
for b:=1 to 3 do
 if weapon[kind].testers then
  say_saying(player.name[b]+' Has a '+player.equipweapon[b].name+' +'+cstr(player.equipweapon[b].magical))
 else
  say_saying(player.name[b]+' Has a '+player.equipmis[b].name+' +'+cstr(player.equipmis[b].magical));
okl:=false;
b:=receiver;
if b=0 then okl:=true
 else if act_stats[b,1]<weapon[kind].charges then say_saying('Not Enough Strength to weild this weapon')
  else begin
    okl:=true;
    if weapon[kind].testers then begin
      player.equipweapon[b]:=weapon[kind];
      player.equipweapon[b].magical:=plus;
    end else begin
      player.equipmis[b]:=weapon[kind];
      player.equipmis[b].magical:=plus;
    end;
   end;
until okl;
end;

procedure givearmor(kind,plus:byte);
var b:byte; okl:boolean;
begin
repeat
say_saying('The Party Finds '+armor[kind].name+' +'+cstr(plus));
for b:=1 to 3 do
 say_saying(player.name[b]+' Has Armor of '+player.equiparmor[b].name+' +'+cstr(player.equiparmor[b].magical));
okl:=false;
b:=receiver;
if b=0 then okl:=true;
if act_stats[b,1]<armor[kind].charges then say_saying('Not Enough Strength To Wear that Armor')
else if b>0 then begin
 player.equiparmor[b]:=armor[kind]; okl:=true;
 player.equiparmor[b].magical:=plus;
 end;
until okl
end;

procedure givering(kind,plus:byte);
var b:byte; okl:boolean;
begin
okl:=false;
repeat
say_saying('The Party Finds '+ring[kind].name+' +'+cstr(plus));
for b:=1 to 3 do
 say_saying(player.name[b]+' Has a Ring of '+player.equipring[b].name+' +'+cstr(plus));
b:=receiver;
okl:=true;
if b>0 then begin player.equipring[b]:=ring[kind];
            player.equipring[b].magical:=plus;
            end;
until okl;
end;

procedure givepot(kind,quant:byte);
var b:byte; okl:boolean;
begin
okl:=false;
repeat
say_saying('The Party finds '+cstr(quant)+' Potions of '+potion_array[kind].name);
for b:=1 to 3 do
  say_saying(player.name[b]+' Has '+cstr(player.equippotions[b,kind]));
b:=receiver;
if b=0 then okl:=true
  else begin
  binc(player.equippotions[b,kind],quant);
  quant:=0;
  if player.equippotions[b,kind]>99 then begin
    quant:=player.equippotions[b,kind]-99;
    player.equippotions[b,kind]:=99;
  end;
  end;
if quant=0 then okl:=true;
until okl;
end;

procedure giveitem;
var x,y:byte;
begin
pausescr; clear_space;
x:=dung_room[room_num].itemnum;
y:=dung_room[room_num].quant;
case x of
1..10 :giveweapon(x,y);
11..15 :givearmor(x-10,y);
17..35 :givering(x-15,y);
36..45 :givepot(x-35,y);
end;
end;

procedure treasroom;
begin
if (dir2=2) and (dung_room[room_num].scroll) then read_scroll;
if (dir2=4) and (dung_room[room_num].amount>0) then give_gold;
if dung_room[room_num].food>0 then give_grub;
if dung_room[room_num].itemnum>0 then giveitem;
if dir2=4 then player.exemptions[dung_room[room_num].toggler]:=1;
end;

procedure give_out;
begin
player.goldpieces:=player.goldpieces+treasure;
say_saying('Inside the container is '+cstrr(treasure,10)+' Gold Pieces');
say_saying('Party Treasure Pot is '+cstrr(player.goldpieces,10)+' Gold Pieces!');
if dir2<>2 then treasroom;
pausescr;
end;

function cast_open:boolean;
var chxx:char; whom:byte; tx:boolean;
begin
tx:=false;
say_saying('Who will Cast the Open Spell? (0,1-3) :');
onek(chxx,'0123');
whom:=ord(chxx)-48;
if (whom=0) then say_saying('* Aborted *') else
 if (player.status[whom]=8) then say_saying('This Player is Dead!')
  else if not player.spells[whom] then say_saying('This Player Cannot Cast Spells!')
  else if player.stats[whom,9]<60 then say_saying('Not Enough Spell Points!')
  else begin
   say_saying(player.name[whom]+' Chants a few words over the chest and presto');
   say_saying('it opens!');
   give_out; inc(player.stats[whom,9],-60);
   tx:=true;
  end;
cast_open:=tx;
end;

function do_save2(targ,loca,streng:integer):boolean;
begin
if random(100)+player.stats[targ,12]*5+player.stats[targ,loca]+(player.stats[targ,16]*3)
   >80+streng then
begin say_saying(player.name[targ]+' made his/her saving throw!');
do_save2:=true; end
 else begin say_saying(player.name[targ]+' missed his/her saving throw!>');
      do_save2:=false; end;
end;

procedure fires(x:integer);
var tmat:boolean; ct3,y:byte; dama:integer;
begin
dama:=0;
if x>1000 then begin
 say_saying('The Delayed Blast Fireball Now Goes Off!');
 x:=x-1000; end else
say_saying('An Explosion Results from the Chest Opening!');
for ct3:=1 to 3 do
 if player.status[ct3]<>8 then begin
  for y:=1 to x do dama:=dama+random(6)+1;
  tmat:=do_save2(ct3,6,x);
  if tmat then dama:=dama div 2;
  say_saying(player.name[ct3]+' Takes '+cstr(dama)+' Points of Damage!');
  inc(player.stats[ct3,11],0-dama);
  check_player_death;
  display_char(ct3);
 end;
end;

procedure poison(x,nnwhom:byte);
var tmat:boolean;
begin
say_saying(player.name[nnwhom]+' is stuck with a Poisoned Needle!');
tmat:=do_save2(nnwhom,5,x);
if tmat then say_saying('Luckily it didn''t effect '+player.name[nnwhom])
 else begin
   say_saying(player.name[nnwhom]+' is Poisoned!');
   player.status[nnwhom]:=5;
   display_char(nnwhom);
 end;
end;

procedure restyn;
var chg:char; cnt2,cnt3:integer;
begin
say_saying('Do You Wish to Rest? (Y/N)');
say_saying('(Do Note that Resting will Remove Any Spells in Effect!) : ');
onek(chg,'NY');
if chg='Y' then begin
  cnt2:=0; feather:=false;
  for cnt3:=1 to 3 do
   if player.status[cnt3]<>8 then
    if player.stats[cnt3,11]-player.stats[cnt3,10]>cnt2 then
      cnt2:=player.stats[cnt3,11]-player.stats[cnt3,10];
  sub_moves(cnt2); return_stats; determine_armorclass;
  for cnt3:=1 to 3 do begin
    player.stats[cnt3,11]:=player.stats[cnt3,10];
    player.stats[cnt3,9]:=player.stats[cnt3,8];
    display_char(cnt3);
  end;
 end;
end;

procedure do_trap(opener,kinder:byte);
var hilo:boolean;
begin
if random(100)>50 then hilo:=true else hilo:=false;
case kinder of
  1 : if hilo then fires(1) else poison(1,opener);
 10 : if hilo then fires(2) else poison(2,opener);
 25 : if hilo then fires(3) else poison(3,opener);
 35 : if hilo then fires(4) else poison(4,opener);
 55 : if hilo then fires(6) else poison(6,opener);
 75 : if hilo then fires(8) else poison(9,opener);
 95 : if hilo then fires(11) else poison(12,opener);
115 : if hilo then fires(13) else poison(15,opener);
end;
restyn;
end;

function pick_it(explo_per:byte):boolean;
var chxx:char;whom,mux:byte; tem:boolean;
begin
tem:=false;
say_saying('Pick Chest to Avoid Trap Option');
say_saying('Who will Pick the Chest? (0,1-3) :');
onek(chxx,'0123');
whom:=ord(chxx)-48;
if (whom=0) or (player.status[whom]=8) then say_saying('* Aborted *')
 else if player.status[whom]=8 then say_saying('This Character is Dead') else
  begin
  tem:=true; mux:=0;
  if player.stats[whom,15]=5 then mux:=35;
  if player.stats[whom,15]=2 then mux:=10;
  if mux+random(100)+player.stats[whom,4]>explo_per then
     say_saying(player.name[whom]+' Opens the Chest Without Incident')
  else do_trap(whom,explo_per);
  give_out;
 end;
pick_it:=tem;
end;

procedure do_chest(nam:uv; trapper:byte);
var aokay:boolean; chx:char;
begin
aokay:=false;
repeat
say_saying('The party finds a '+nam);
say_saying('Choice: (C)ast Open Chest, (L)eave It, (P)ick it :');
onek(chx,'CLP');
case chx of
 'C' : aokay:=cast_open;
 'L' : aokay:=sureyn;
 'P' : aokay:=pick_it(trapper);
end;
until aokay;
end;


procedure do_treas;
var x1,x2 : byte;
begin
treasure:=1;
if (dir2<>4) then
for x1:=1 to com_num do
 for x2:=1 to how_many[x1] do
  treasure:=monster_array[type_mon[x1]].gps+(monster_array[type_mon[x1]].gps*(random(20)-10)/100)+treasure;
if dir2=1 then treasure:=treasure+dung_room[room_num].amount;
if treasure < 0 then treasure:=0;
if treasure<100 then do_chest('Cloth Sack',1) else
 if treasure<400 then do_chest('Leather Sack',10) else
  if treasure<800 then do_chest('Wooden Chest',25) else
   if treasure<1750 then do_chest('Iron Chest',35) else
    if treasure<3000 then do_chest('Bronze Chest',55) else
     if treasure<6000 then do_chest('Silver Chest',75) else
      if treasure<12000 then do_chest('Gold Chest',95) else
       do_chest('Platinum Chest',115);
end;

procedure check_level;
var gg:byte; x:integer;
begin
for gg:=1 to 3 do
if player.experience[gg,1]>player.experience[gg,2]-1 then begin
   player.experience[gg,2]:=2*player.experience[gg,2];
   inc(act_stats[gg,12],1);
   inc(player.stats[gg,12],1);
   clear_space;
   say_saying('Congratulations! '+player.name[gg]+' has gained a Level!');
   say_saying(player.name[gg]+' is now Level:  '+cstr(player.stats[gg,12]));
   say_saying(player.name[gg]+' now needs '+cstrr(player.experience[gg,2],10)+' Experience Points');
case player.stats[gg,15] of
  1 :  x:=random(10)+15;
  2 :  x:=random(10)+8;
  3 :  x:=random(8)+6;
  4 :  x:=random(10)+10;
  5 :  x:=random(10)+8;
  6 :  x:=random(10)+12;
  7 :  x:=random(10)+10;
end;
x:=x+modifier(player.stats[gg,5]);
if x < 1 then x:=1;
say_saying(player.name[gg]+' has gained '+cstr(x)+' Hit Points!');
inc(player.stats[gg,10],x);
say_saying(player.name[gg]+' now has '+cstr(player.stats[gg,10])+' Hit Points');
increase_stats(gg);
end;
end;

procedure dtrmin_active;
var x:byte;
begin
if player.status[active]=8 then
  for x:=1 to 3 do
   if player.status[x]<>8 then begin
      active:=x;
      if player.status[active]=4 then player.status[active]:=7;
   end;
end;

procedure combat_orien;
begin
if dball>0 then fires(1000+roundcnt-dball);
clear_space;
say_saying('**** Victory!  All Monsters have been defeated! ****');
dtrmin_active;
give_exp;
check_level;
restyn;
do_treas;
dball:=0;
dtrmin_active;
end;

begin
dir2:=directive;
case directive of
 1,2:combat_orien;
 3: restyn;
end;
end;

overlay function o_player(directive: byte; mx,my:integer) : boolean;
type location = record
    outdun : boolean;
    xlocx:byte;
    ylocy:byte;
    ymap:byte;
    xmap:byte;
    ussernum:integer;
    usernam:string[30];
    sayer:boolean;
    s_say:string[30];
    s_s2:string[30];
  end;
var floc: file of location; vloc:location; o2_player,pltemp:character;
  fplayer:file of character; fileex:boolean; chx:char; cnt2:integer;


  function read_ch(num:integer; cdx,cdy:byte) : boolean;
   var filename:string[8];
   begin
   filename:='        ';
   str(num,filename);
   assign(fplayer,filename+'.sav');
   {$I-} reset(fplayer); {$I+}
   if IOresult=0 then
     begin read(fplayer,o2_player); close(fplayer); read_ch:=true;
      end else begin
        say_saying('Character''s SAV file not found!  Aborted!');
        read_ch:=false;
      end;
    map[cdx,cdy]:=' ';
   end;

  procedure patch(usnm:integer);
  var fc:file of location;
  begin
  assign(fc,'LOCXY.DAT');
  reset(fc);
  seek(fc,usnm-1);
  write(fc,vloc);
  close(fc);
  end;

  function load_char(inout:boolean; a,b,c,d:byte):boolean;
  var torq,temp:boolean;
  begin
  temp:=false; cnt2:=0;
  assign(floc,'LOCXY.DAT');
  reset(floc);
  repeat
  cnt2:=cnt2+1;
  read(floc,vloc);
  if vloc.outdun=inout then
   if vloc.xlocx=a then
    if vloc.ylocy=b then
     if vloc.ymap=c then
      if vloc.xmap=d then begin
         temp:=true;
         torq:=read_ch(cnt2,a,b); vloc.xmap:=100; close(floc);
         if not torq then patch(cnt2);
         load_char:=torq;
       end;
  until temp;
end;

procedure send_message(reply:str);
begin
vloc.sayer:=true;
vloc.s_say:=thisuser.name;
vloc.s_s2:=reply;
sysoplog(thisuser.name+' Sent '+vloc.usernam+' A Message: ');
sysoplog('       >'+reply);
patch(cnt2);
end;

procedure give_message;
var inputs:str;
begin
say_saying('Please Enter a Message of Up to 30 Characters Long!');
say_saying('All Messages will be reported to SYSOP and NOT ANONYMOUS!');
say_saying('  :');
input(inputs,30);
send_message(inputs);
end;

procedure conversion;
var sp,sf,g:byte; oh:monsters;
begin
for g:=1 to 3 do begin
  oh.name:=o2_player.name[g];
  oh.minhp:=o2_player.stats[g,10]-2;
  oh.maxhp:=o2_player.stats[g,10];
  oh.numat:=o2_player.stats[g,13]+player.equipweapon[g].magical;
if (o2_player.stats[g,15] in [2,3,5]) and (o2_player.equipmis[g].idnum<>10) then
   begin
    oh.range:=75;
    oh.mis_mindam:=o2_player.equipmis[g].magical+1;
    oh.mis_maxdam:=o2_player.equipmis[g].magical + o2_player.equipmis[g].maxdam
   end
else begin
    oh.range:=0;
    oh.mis_mindam:=0;
    oh.mis_maxdam:=0;
  end;
oh.speed:=o2_player.stats[g,4];
oh.undead:=false;
oh.level:=o2_player.stats[g,12];
if (o2_player.equipring[g].idnum=28) or (o2_player.equipring[g].idnum=29)
  then oh.regen:=o2_player.equipring[g].magical else
       oh.regen:=0;
oh.armor_class:=o2_player.stats[g,14];
oh.experience:=o2_player.stats[g,12]*125;
oh.gps:=o2_player.stats[g,12]*150;
oh.poison:=0;
oh.drainer:=false;
oh.mindam:=o2_player.equipweapon[g].mindam+modifier(o2_player.stats[g,1]);
oh.maxdam:=o2_player.equipweapon[g].maxdam+modifier(o2_player.stats[g,1]);
type_mon[g]:=68+g;
how_many[g]:=1; sp:=player.stats[g,9]; sf:=0;
if o2_player.spells[g] then
   case sp of
     0..40 : sf:=1;
    41..60 : sf:=6;
    61..100 : sf:=8;
    101..150 : sf:=9;
    201..2500 : sf:=10;
   end;
oh.spoints:=sp;
oh.staff:=sf;
monster_array[68+g]:=oh;
end;
type_mon[4]:=50;
how_many[4]:=0;
end;

procedure check_4_mess;
begin
assign(floc,'LOCXY.DAT'); reset(floc);
seek(floc,usernum-1);
read(floc,vloc); close(floc);
if vloc.sayer then begin
   talknl(8,'Message While You Were Away:  ');
   talknl(4,'From:   '+vloc.s_say);
   talknl(3,vloc.s_s2);
   vloc.sayer:=false;
   patch(usernum); pausescr;
end;
end;

procedure save_char2(numz:integer);
var saver: file of character;
filename:string[8];
temper:bogus;
begin
 filename:='        ';
 str(numz,filename);
 filename:=filename+'.sav';
 assign(saver,filename);
 rewrite(saver);
 write(saver,o2_player);
 close(saver);
end;

begin
if directive=1 then begin
  if player.outdoor then fileex:=load_char(true,player.outxact+mx,player.outyact+my,player.outymap,player.outxmap)
   else fileex:=load_char(false,player.xactual+mx,player.yactual+my,player.ymap,player.xmap);
  if fileex then begin
    say_saying('Your Party has come Across '+vloc.usernam+'`s Party!');
    say_saying('Choices:  (A)ttack  (G)ive Message  (I)gnore  ');
    onek(chx,'AGI');
    case chx of
    'A' : begin send_message('Attacked You!'); o_player:=true; conversion;
          per_at:=cnt2; binc(player.door_exemps[247],3);
    end;
    'G' : begin give_message; O_player:=false; end;
    'I' : begin send_message('Encountered You and Ignored!'); o_player:=false; end;
    end;
  end;
end;
if directive=2 then begin
  cnt2:=per_at; send_message('Atcked & Dftd. you in Combat!');
  binc(player.door_exemps[247],10);
  if player.door_exemps[247]>100 then player.door_exemps[247]:=100;
  fileex:=read_ch(cnt2,0,0);
  o2_player.outdoor:=false;
  o2_player.dungeon:=false;
  o2_player.city:=true;
  o2_player.outxact:=o2_player.door_exemps[251];
  o2_player.outyact:=o2_player.door_exemps[250];
  o2_player.outxmap:=o2_player.door_exemps[249];
  o2_player.outymap:=o2_player.door_exemps[248];
  save_char2(cnt2);
end;
if directive=3 then begin check_4_mess; o_player:=false; end;
end;

overlay procedure guards;
   procedure assignments(t1,t2,t3,t4,h1,h2,h3,h4:byte);
   begin
   type_mon[1]:=t1;  type_mon[2]:=t2; type_mon[3]:=t3; type_mon[4]:=t4;
   how_many[1]:=h1;  how_many[2]:=h2; how_many[3]:=h3; how_many[4]:=h4;
   end;
begin
case player.dungeon_level of
 1: if player.xmap<>6 then
      assignments(1,50,50,50,random(3)+2,0,0,0)
    else case random(3)+1 of
      0,1: assignments(73,50,50,50,random(3)+1,0,0,0);
      2:   assignments(7,50,50,50,random(4)+2,0,0,0);
      3,4: assignments(2,50,50,50,random(3)+2,0,0,0);
    end;
2:  if (player.xmap=1) and (player.ymap=5) then
     case random(3)+1 of
      0,1: assignments(75,75,50,50, random(2)+1,random(4)+1,0,0);
      2 : assignments(44,43,50,50,random(2)+1,random(4)+4,0,0);
      3 : assignments(75,39,50,50,random(3)+1,random(3)+2,0,0);
     end else
     case random(4)+1 of
      0,1: assignments(37,38,50,50,random(3)+1,1,0,0);
      2  : assignments(37,50,50,50,random(5)+2,0,0,0);
      3  : assignments(6,37,50,50,random(5)+2,random(2)+1,0,0);
      4  : assignments(37,10,50,50,random(3)+1,random(2)+1,0,0);
     end;
 3:  if (player.ymap=6) then
     case random(3)+1 of
       0,1 : assignments(75,74,73,50,random(2)+5,random(3)+5,random(3)+5,0);
       2   : assignments(39,39,75,50,random(4)+4,random(4)+4,random(5)+4,0);
       3,4 : assignments(48,39,75,50,random(2)+random(7)+1,random(6)+1,random(5)+2,0);
     end else assignments(22,23,50,50,random(4)+random(4)+1,random(2)+random(2)+1,0,0);
end;
say_saying('You are Ambushed by some guards!'); pausescr;
end;

overlay procedure jester_camp;
var inputs:str; lesson:integer;
begin
clear_space;
say_saying('A group of funny dressed men and women litter the area.  Telling jokes');
say_saying('and receiving lessons in the art of conversation!');
say_saying('The leader of the camp comes forward and asks if you''d be interested');
say_saying('in learning lessons as well.  The cost is a mere 75 Goldpieces per Point');
repeat
say_saying(player.name[active]+' has '+cstrr(player.goldpieces,10)+' Gold Pieces and a '+cstr(player.stats[active,7])+
   ' Personality');
say_saying('Change Active (-1..-3), lessons 0 - '+cstr(99-player.stats[active,7])+': ');
input(inputs,2);
lesson:=value(inputs);
if lesson=-1 then active_change(1);
if lesson=-2 then active_change(2);
if lesson=-3 then active_change(3);
until (lesson>-1) and (lesson < 99-player.stats[active,7]+1);
if player.goldpieces+1<75*lesson then say_saying('Not Enough Gold!')
else begin
  inc(act_stats[active,7],lesson);
  inc(player.stats[active,7],lesson);
  player.goldpieces:=player.goldpieces-75*lesson;
  player.total_moves:=player.total_moves+(25*lesson);
  say_saying(player.name[active]+' Completes the Training!');
end;
end;

overlay function cast_spell:byte;
var inputss:str; temp,spnum : integer; recept:byte;

function chec:boolean;
 begin
 if player.stats[active,9]<magic[spnum].numat then begin
  chec:=false;
  say_saying('Not Enough Spells Points to Cast that Spell!');
  end else chec:=true;
 end;

 procedure who_gets_it;
 var xx:char;
  begin
  say_saying('Who is to Receive this Spell (0 to Abort) (123): ');
  onek(xx,'0123');
  recept:=ord(xx)-48;
  end;

procedure deccer;
begin
inc(player.stats[active,9],-1*magic[spnum].numat);
end;

procedure prot_evil;
begin
if chec then
 begin
 say_saying(player.name[active]+' Cast '+magic[spnum].name+'!');
 deccer;
 for temp:=1 to 3 do begin
 inc(player.stats[temp,magic[spnum].charges],1);
 if not player.city then display_char(temp);
 end;
end;
end;

procedure shield;
begin
if chec then begin
who_gets_it;
if recept=0 then say_saying('Aborted!') else
begin
 inc(player.stats[recept,14],player.stats[active,12]);
 say_saying(magic[spnum].name+' Cast Successfully!');
  if not player.city then display_char(recept);
  deccer;
  end;
 end;
end;


 procedure jump;
  var ji,jk : char; dis,act_dis:integer;
   begin
 dis:=player.stats[active,12]*3;
 if chec then
  if player.city then say_saying('Spell Cannot be Used in Cities!') else
   begin
  say_saying('Direction (2468, 0 For Abort): ');
  onek(ji,'02468');
  if ji<>'0' then begin
  repeat
  say_saying('Spaces to Jump 1-'+cstr(dis)+': ');
  input(inputss,2); act_dis:=value(inputss);
  until (act_dis>0) and (act_dis<dis+1);
 case ji of
  '8': if player.outyact-act_dis<1 then player.outyact:=1 else
       binc(player.outyact,-1*act_dis);
  '4': if player.outxact-act_dis<1 then player.outxact:=1 else
       binc(player.outxact,-1*act_dis);
  '6': if player.outxact+act_dis>78 then player.outxact:=78 else
       binc(player.outxact,act_dis);
  '2': if player.outyact+act_dis>23 then player.outyact:=23 else
       binc(player.outyact,act_dis);
  end; deccer; cast_spell:=1;
  end;
 end;
 end;

procedure heal(ttest:boolean);
var cnr,n:integer;
begin
if chec then begin who_gets_it;
if recept<>0 then begin
 deccer;
 if ttest then cnr:=player.stats[active,12] else cnr:=1;
 for n:=1 to cnr do
 inc(player.stats[recept,11],random(magic[spnum].maxdam)+1);
 if not player.city then display_char(recept);
 if player.stats[recept,11]>player.stats[recept,10] then
 player.stats[recept,11]:=player.stats[recept,10];
 say_saying('Spell Cast Successfully!');
 end;
 end;
 end;

procedure cast_feat;
begin
if chec then
if feather then say_saying('Feather Fall Already Actived!') else
begin
deccer;
feather:=true;
say_saying('Feather Fall Activated!');
end;
end;


procedure cure_spl;
begin
if chec then begin
who_gets_it;
if (player.status[recept]=5) and (recept<>0) then begin deccer;
player.status[recept]:=4;
if not player.city then display_char(recept);
say_saying(player.name[recept]+' is cured of his Ailment!');
end else say_saying('Aborted');
end;
end;

procedure eyes;
var x,y:byte;
begin
if chec then
 if player.city then say_saying('You can''t cast this spell in Town!') else
  begin
  deccer;
  say_saying('Your Eyes are filled with a Grand Vision in your Auto-Map!');
  for x:=1 to 78 do
   for y:=1 to 23 do
    auto_map[x,y]:=map[x,y];
 end;
end;

procedure leave_dun;
var chx:char;
begin
if chec then
 if not player.dungeon then say_saying('You must be in a dungeon to use this!')
 else begin
 say_saying('Do You Really want to EXIT the dungeon? (Y/N): ');
 onek(chx,'NY');
 if chx='Y' then begin
 deccer; cast_spell:=2;
 player.outdoor:=true;
 player.dungeon:=false; exitter:=true;
 say_saying('You exit from the Dungeon!'); pausescr;
 end;
 end;
end;

procedure wall_rem;
var chx:char; x3,y3:integer;
begin
cast_spell:=1;
if chec then begin
say_saying('Direction (2468,0): ');
onek(chx,'02468');
case chx of
'2': begin x3:=0; y3:=1; end;
'4': begin x3:=-1; y3:=0; end;
'6': begin x3:=1; y3:=0; end;
'8': begin x3:=0; y3:=-1; end;
 end;
if chx <>'0' then
if map[player.xactual+x3,player.yactual+y3] in ['¹'.. 'Î'] then begin
 map[player.xactual+x3,player.yactual+y3] :=' '; deccer;
 say_saying('Wall Removed!');
 end else say_saying('Not a Valid Wall!');
end;
end;

procedure maj_heal;
var xx:byte;
begin
if chec then begin
say_saying('Everybody is Healed!'); deccer;
for xx:= 1 to 3 do begin
player.stats[xx,11]:=player.stats[xx,10];
if not player.city then display_char(xx);
end;
end;
end;

procedure raise_dead;
begin
if chec then begin
  who_gets_it;
  if (recept<0) or (player.status[recept]<>8) then say_saying('Invalid Input!')
   else begin
     inc(act_stats[recept,5],-1);
     deccer;
     if not player.city then display_char(recept);
     say_saying(player.name[recept]+' Has been Raised from the Dead!');
     player.status[recept]:=4;
   end;
end;
end;

procedure listspells;
var x:byte;
begin
for x:=1 to 25 do
 if player.stats[active,9]>magic[x].numat-1 then say_saying(cstr(x)+'. '+magic[x].name);
say_saying('Continue Playing....');
end;

begin
clear_space;
cast_spell:=0;
if not player.spells[active] then say_saying('This Character Has No Spell Casting Ability!')
 else begin
  repeat
  say_saying('Spell To Cast (0 for None,99 for List) (MPS: '+cstr(player.stats[active,9])+'): ');
  input(inputss,2);
 spnum:=value(inputss);
  until ((spnum>-1) and (spnum<26)) or (spnum=99);
  if spnum>0 then
    case spnum of
    1 : prot_evil;
    4 : shield;
    5 : jump;
    6 : heal(false);
    8 : cast_feat;
    11: heal(true);
    14: cure_spl;
    15: eyes;
    16: leave_dun;
    19: wall_rem;
    23: maj_heal;
    25: raise_dead;
    99: listspells;
    2,3,7,9,10,12,13,17,18,20,21,22,24 : say_saying(magic[spnum].name+' Is not Used Here!');
    end;
  end;
end;

overlay procedure exchange;
var achr:char; destin : byte;

  procedure to_whom;
  begin
  say_saying('Who Will be the Receive of the Item? (123)');
  onek(achr,'123');
  destin:=ord(achr)-48;
  end;

  function check_str(a,b:items):boolean;
  begin
  if (player.stats[active,1]+1>b.charges) and (player.stats[destin,1]+1>a.charges)
   then check_str:=true else check_str:=false;
  end;

  procedure exchangeroo(var a,b:items);
  var c:items;
  begin
  c:=b;
  b:=a;
  a:=c;
  end;

  procedure trade(itemer : char);
  var passer:boolean;
  begin
  to_whom;
  case itemer of
   'A' : passer:=check_str(player.equiparmor[active],player.equiparmor[destin]);
   'W' : passer:=check_str(player.equipweapon[active],player.equipweapon[destin]);
   'M' : passer:=check_str(player.equipmis[active],player.equipmis[destin]);
  end;
  if not passer then say_saying('One of the characters doesn''t have the Strength Required!');
  if passer then begin
    case itemer of
    'A' : exchangeroo(player.equiparmor[active],player.equiparmor[destin]);
    'W' : exchangeroo(player.equipweapon[active],player.equipweapon[destin]);
    'M' : exchangeroo(player.equipmis[active],player.equipmis[destin]);
    end; say_saying('Transaction Complete!');
   end;
  end;

  procedure fooder;
  var temp:char; temb:byte; quantstr:str; quant:integer;
  begin
  say_saying('You have '+cstr(player.food[active])+' Who do you wish to give to: ');
  onek(temp,'123');
  temb:=ord(temp)-48;
  say_saying(player.name[temb]+' Has '+cstr(player.food[temb])+' Rations, 99 Max!');
  say_saying('How Much food to give: ');
  input(quantstr,2);
  quant:=value(quantstr);
  if (quant+player.food[temb]<99) and (quant>0) and (quant<player.food[active])
    then begin
     binc(player.food[temb],quant);
     binc(player.food[active],0-quant);
     if not player.city then begin display_char(active); display_char(temb); end;
    end else say_saying('Invalid Transaction!');
end;


  procedure give_pot_trade;
  var x,temp:byte; chk:str; max_am,quant:integer;
  begin
  clear_space; chk:='0';
  for x:=1 to 9 do
  if player.equippotions[active,x]>0 then begin
    say_saying(cstr(x)+'. Potion of '+potion_array[x].name+' Amount: '
      +cstr(player.equippotions[active,x]));
    chk:=chk+chr(x+48);
  end;
  say_saying('Choice ('+chk+'): '); onek(achr,chk);
  x:=(ord(achr)-48);
  if x>0 then begin
  temp:=player.equippotions[active,x];
  to_whom; max_am:=255-player.equippotions[destin,x];
  if max_am>temp then
    max_am:=temp; {insures that dude won't give mor than got}
  repeat
  say_saying('How Many do you Wish to Give 0- '+cstr(max_am)+': ');
  input(chk,3); quant:=value(chk);
  until (quant<max_am+1) and (quant>-1);
 if max_am>0 then begin
  player.equippotions[active,x]:=temp-quant;
  player.equippotions[destin,x]:=player.equippotions[destin,x]+quant;
  say_saying('Transaction Complete!');
 end;
 end;
 end;

begin
clear_space;
say_saying('(A)rmor, exchange,    (F)ood       (G)ive Potion');
say_saying('(M)issile Weapon, exchange,  (W)eapon, Melee Exchange');
say_saying('Do (N)othing, '+player.name[active]+', Choice (AGMNW): ');
onek(achr,'AFGMNW');
if achr in ['A','M','W'] then trade(achr);
if achr='G' then give_pot_trade;
if achr='F' then fooder;
end;


overlay procedure guardian_angel;
var hacker:str;
temp, filenamer:string[12];
begin
cls; ansic(0);
filenamer:='                     ';
temp:=chr(town_stuff.city_num+48);
filenamer:='CREATOR'+temp+'.HLP';
printfile(filenamer);
nl;
repeat goto_ansixy(23,1);
talk(7,'TYPE "DONE" when finished!'); ansic(4);
input(hacker,4) until hacker='DONE'; cls;
end;

overlay procedure read_weapons;
var g7:file of items;
g4: file of monsters;
cnnt:byte;
begin
assign(g7,'items.dat'); reset(G7);
for cnnt:=1 to 10 do
read(g7,weapon[cnnt]);
for cnnt:=1 to 5 do
read(g7,armor[cnnt]);
for cnnt:=1 to 20 do read(g7,ring[cnnt]);
for cnnt:=1 to 10 do read(g7,potion_array[cnnt]);
for cnnt:=1 to 25 do read(g7,magic[cnnt]);
close(g7);
assign(g4,'monster.dat'); reset(g4);
for cnnt:=1 to 77 do
read(g4,monster_array[cnnt]); close(g4);
for cnnt:=1 to 3 do if player.status[cnnt]=7 then active:=cnnt;
end;

overlay procedure init_names;
begin
stat_name[1]:='STRENGTH';
stat_name[2]:='INTELECT';
stat_name[3]:='WISDOM';
stat_name[4]:='AGILITY';
stat_name[5]:='HEALTH';
stat_name[6]:='LUCK';
stat_name[7]:='PERSONALITY';
stat_name[8]:='MAX. SPELL PTS';
stat_name[9]:='ACT. SPELL PTS';
stat_name[10]:='MAX. HIT PTS';
stat_name[11]:='ACT. HIT PTS';
stat_name[12]:='LEVEL';
stat_name[13]:='# AT. RND';
stat_name[14]:='ARMORCLASS';
cond_name[1]:='HEALTHY';
cond_name[2]:='POISONED';
cond_name[3]:='NIL';
cond_name[4]:='ACTIVE';
cond_name[5]:='DEAD';
end;

overlay procedure get_city_info;
var g2:file of town_rec;
begin
assign(g2,'TOWNDATA.PIT');
reset(g2);
repeat
  read(g2,town_stuff);
until (town_stuff.x=player.outxact) and (town_stuff.y=player.outyact);
close(g2);
player.door_exemps[252]:=town_stuff.city_num;
player.door_exemps[251]:=town_stuff.x;
player.door_exemps[250]:=town_stuff.y;
player.door_exemps[249]:=player.outxmap;
player.door_exemps[248]:=player.outymap;
end;

overlay procedure welcome;
var colr : byte;
begin
cls; talknl(3,'Welcome to '+town_stuff.city_name); nl; dialcnt:=18;
talk(4,'Current Active Player: ');
talknl(5,player.name[active]);
if town_stuff.port then colr:=3 else colr:=0;
talknl(3,'(1-3) Change Active Player');
talknl(colr,'(B)oating');
talknl(3,'(C)onverse with Townfolk!');
talk(3,'(D)ocumentation                   ');
talknl(player.status[1],'1. '+player.name[1]);
talk(3,'(E)xchange/Trade                  ');
talknl(player.status[2],'2. '+player.name[2]);
talk(3,'(F)ast Mode                       ');
talknl(player.status[3],'3. '+player.name[3]);
talknl(3,'(G)eneral Store');
talknl(3,'(L)eave Town!                    (M)agic Spell, Cast');
talknl(3,'(P)otions, Use');
talk(3,'(Q)uit and Save                  ');
talknl(3,'(S)ave Character -- No Quit');
talk(3,'(U)tilities, Character           ');
talknl(3,'(V)iew Party');
talk(3,'(Y)our Guardian Angel            ');
talknl(3,'(Z) -- Destroy Party');
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
{$I-}
read(du_file,dungeon_stuff);
{$I+}
if IOresult <> 0 then begin talknl(8,'Pit FIend F***ed up in Dun!'); return; end;
until (dungeon_stuff.dlocx=player.outxact+modx) and (dungeon_stuff.dlocy=player.outyact+mody);
close(du_file);
end;

overlay procedure enter_dungeon_check(var tt : byte);
var tinput : char; x,y: byte;
    t1 : array [1..3] of str;
begin
clear_space; y:=0;
say_saying('Do you wish to Enter the Dungeon '+dungeon_stuff.dname+ ' (Y)es/(N)o? --> ');
if not dungeon_stuff.nilword then say_saying('(Remember you will need the magic words!): ');
onek(tinput,'YN'); if tinput ='N' then tt:=0 else
 if not dungeon_stuff.nilword then begin
  clear_space;
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
end
 else begin
  for x:=1 to 3 do
  if t1[x]=dungeon_stuff.dwords[x] then y:=y+1;
  if y=3 then begin say_saying('The doors to '+dungeon_stuff.dname+' open inward!');
  tt:=2; pausescr;
  end
  else begin say_saying('Those are NOT the correct words!'); tt:=3; end;
 end;
end;
if (dungeon_stuff.nilword) and (tinput='Y') then tt:=2;
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

overlay procedure determin_combat(xx,yy : integer);
var tt:byte; afound:boolean;
begin
afound:=false; tt:=0;
for tt:=1 to 75 do
if dung_room[tt].dxmap=player.xmap then
if dung_room[tt].dymap=player.ymap then
 if dung_room[tt].dlocx=player.xactual+xx then
 if dung_room[tt].dlocy=player.yactual+yy then begin
 room_num:=tt; tt:=76; end;
end;

overlay procedure do_a_bridge(var temp:byte);
var gg : char; coster,amn:integer; okl:boolean;
begin
clear_space; amn:=0; okl:=false;
for coster:=1 to 4 do begin
 how_many[coster]:=0;
 type_mon[coster]:=50;
end;
for coster:=1 to 3 do begin
how_many[coster]:=player.stats[coster,12]+random(3);
if player.status[coster]=8 then how_many[coster]:=1;
if how_many[coster]>10 then how_many[coster]:=10;
if how_many[coster]<1 then how_many[coster]:=1;
type_mon[coster]:=16;
inc(amn,how_many[coster]);
end;
 if player.stats[active,12]<3 then say_saying('Warning!  Trolls are Hard for your Level!');
 say_saying(cstr(amn)+' Ugly Troll(s) step from underneath the bridge!');
 say_saying('You have '+cstrr(player.goldpieces,10)+' Gold Pieces!');
 coster:=(50-modifier(player.stats[active,7])) * amn;
 if coster<50 then coster:=50;
 repeat
 say_saying('They will let you pass for '+cstr(coster)+' Gold Pieces!');
 say_saying('Do you (A)ccept, (F)ight them, (L)eave them. -> ');
 temp:=0;
 onek(gg,'AFL');
 case gg of
  'A' : if player.goldpieces < coster then say_saying('Not Enough Gold!')
    else begin player.goldpieces:=player.goldpieces-coster; bridger:=true; okl:=true; end;
  'F' : begin temp:=2; say_saying('Let the Battle Begin!'); pausescr; okl:=true; end;
  'L' : begin say_saying('Continue Playing...'); okl:=true; end;
 end;
 until okl;
end;

overlay procedure get_screen;

var x,y,xer,yer : integer;
 f1 : file of char;
 filename:string[12];
 temp1,temp2,temp3 : char;

procedure load_chars(inout:boolean; c,d:byte);
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
s_s2 :string[30];
end;

var floc:file of location; vloc:location; hom:integer;
begin
assign(floc,'LOCXY.DAT');
reset(floc);
for hom:=1 to 1500 do begin
read(floc,vloc);
if vloc.ymap=c then
if vloc.outdun=inout then
if vloc.xmap=d then
if usernum<>vloc.ussernum then
 map[vloc.xlocx,vloc.ylocy]:='!';
end;
close(floc);
end;

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
say_saying('Loading/Decrypting/Finding Characters, one moment please...');
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
if player.outdoor then load_chars(true,player.outymap,player.outxmap)
 else load_chars(false,player.ymap,player.xmap);
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
ansic(8); prompt('ê');
repeat goto_ansixy(1,1); talk(8,'Type "DONE" when finished: '); ansic(3);
input(hack,4); until hack='DONE';
end;


overlay procedure hunter;
var gained,timer : byte; bg : integer;
begin
gained:=0; bg:=modifier(player.stats[active,2]);
if player.stats[active,15]=7 then inc(bg,20);
case map[player.outxact,player.outyact] of
  ' ' : begin if random(100) < 16+bg then gained:=random(3)+1; timer:=10+random(10); end;
  '' : begin if random(100) < 30+bg then gained:=random(5)+1; timer:=10+random(3); end;
  '°','B' : begin if random(100) < 50+bg then gained:=random(3)+1; timer:=8+random(5); end;
  else begin if random(100) < 5+bg then gained:=random(2)+1; timer:=15+random(10); end;
end;
if gained>10 then gained:=5;
if gained>0 then say_saying('You have found '+cstr(gained)+' Rations') else
   say_saying('You Fail to find any Food!');
say_saying(cstr(timer)+' Moves Used!'); sub_moves(timer);
 binc(player.food[active],gained);
 if player.food[active]>99 then player.food[active]:=99;
end;

overlay procedure inspect;
var dirc : char;
    dirnum : integer;

procedure what_is_it(x,y: integer);
var t1,t2:byte;
begin
if player.outdoor then begin t1:=player.outxact; t2:=player.outyact; end
  else begin t1:=player.xactual; t2:=player.yactual; end;
case map[t1+x,t2+y] of
  'â' : say_saying('That''s a Sign, Touch it to read it!');
  '›' : say_saying('That''s a Living Statue -- touch it for a "Nice" surprise!');
  '¨' : say_saying('That''s Something Special, touch it!');
  'C' : if player.outdoor then say_saying('That''s a City -- touch it to enter!');
  'D' : say_saying('That''s a Door, --touch it to enter!');
  'I' : say_saying('That''s an Inn, you can rest here!');
  'W' : say_saying('That''s a stairWay up, touch it to go up!');
  'w' : say_saying('That''s a stairWay going down, touch it to go down!');
  'S' : say_saying('These are the stairs out of the dungeon, touch it to leave!');
  '' : say_saying('These are trees/brush, hard to move around...');
  '°' : say_saying('That''s water... no drinking please!');
  '±' : say_saying('That''s desert/beach, you get thirsty (hungry) out here!');
  '²' : say_saying('This is part of a room...');
  '¹'..'ß' :if player.dungeon then say_saying('Coastline or a wall... impassible terrain!')
        else say_saying('Path, usually leads to something interesting.');
  'ï' : say_saying('That''s a dungeon entrance -- BEWARE!');
  'B' : if player.outdoor then say_saying('That''s a bridge with some nasty trolls on it!')
        else say_saying('You see a Bird, Touch it!');
  'Œ',' ','G','P','#' : say_saying('Nothing there!');
  'ã' : say_saying('These are Pillars -- impassable');
  'ú' : say_saying('Rubble -- impassable');
  'Û'..'ß' : say_saying('Altar, Rubble, or some barrier!');
  'R' : say_saying('A Riddle Asking Statue!');
  'ž','H' : say_saying('A hut or small building');
  'J' : say_saying('A Jester''s Training Camp, touch it to Enter!');
  'T' : say_saying('A Temple, Get Healing, Potions, touch it to Enter!');
  'ç' : say_saying('A green plant, fairly tall, a Soma Plant!');
  'F' : say_saying('That''s a ferry... takes you back to the mainland!');
  'è' : say_saying('A fountain of red water, gives off light, quite warm.');
  else say_saying('Mountains, Hills, or Tomb Stone');
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
 var t1,t2 : byte; chk : char; percen : integer;

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
  for oper:=1 to 4 do
 if dung_room[tty].whatkind[oper]<>50 then
  say_saying(cstr(dung_room[tty].howmany[oper])+' '+monster_array[dung_room[tty].whatkind[oper]].name);
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

if player.equippotions[active,10] > 1 then
 begin say_saying('Gulp.... Gulp.... Gulp....');
 binc(player.equippotions[active,10],-1); success(hs1,hs2);
 end else
 if player.equipring[active].idnum<>14 then say_saying('You don''t have either a Ring or a Potion!')
 else begin binc(player.equipring[active].charges,-1); success(hs1,hs2);
 end;
sub_moves(1);
end;

begin
with player do begin
if outdoor then begin t1:=outxact; t2:=outyact; end
else begin t1:=xactual; t2:=yactual; end;
if stats[active,15]=5 then percen:=stats[active,12]*4+stats[active,4];
end;
if map[t1+x,t2+y] <> 'D' then say_saying('The object Pointed to Is not a Door!')
 else
 if player.stats[active,15]=5 then begin
 clear_space;
 say_saying('Do You wish to use your (T)hieving Skills? ('+cstr(percen)+'%) ');
say_saying('Or a (P)otion, you have '+cstr(player.equippotions[active,10])+' X-ray Potions (T/P)');
 onek(chk,'TP');
 if chk='T' then do_it_thief(percen,x,y) else do_it_pot(x,y);
 end
else
do_it_pot(x,y);
end;

begin
if player.outdoor then say_saying('You Must be in a Dungeon to Use this!')
else
 if (player.stats[active,15]<>5) and
   (player.equippotions[active,10]<1) and (player.equipring[active].idnum <> 14)
  then say_saying('You lack X-Ray Potions/Rings or Thieving Skills!')
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

overlay function use_ring : boolean;

procedure wall_rem;
var dirc :char;
procedure remit(x3,y3 : integer);
begin
if map[player.xactual+x3,player.yactual+y3] in ['¹'.. 'Î'] then begin
  map[player.xactual+x3,player.yactual+y3] :=' ';
  binc(player.equipring[active].charges,-1);
  if player.equipring[active].charges<1 then player.equipring[active]:=ring[1];
  use_ring:=true;
  end else say_saying('Not a Valid Wall!');
end;

begin
clear_space;
say_saying('---- Warning! Significant Hazards Go Along with this Device! ----');
say_saying('Be sure That you have Read the Rules on this Item or you may');
say_saying('Permanently destroy your character!');
say_saying('Direction (2468,0 (none))');
onek(dirc,'02468');
case dirc of
 '0': say_saying('No charges used!');
 '2': remit(0,1);
 '4': remit(-1,0);
 '6': remit(1,0);
 '8': remit(0,-1);
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
  if player.equipring[active].charges < 1 then player.equipring[active]:=ring[1];
  end else say_saying('Invalid Input!');
end else say_saying('Invalid Input!');
end;

procedure xexit;
var chk : char;
begin
say_saying('Are you Sure you Wish to Exit this Dungeon! (Y/N)');
onek(chk,'YN');
if chk='Y' then begin
  player.equipring[active]:=ring[1];
  exitter:=true;
  player.dungeon:=false;
  player.outdoor:=true;
end else say_saying('Continue Playing then....');
end;

begin
use_ring:=false;
case player.equipring[active].idnum of
 26,27 : if player.dungeon then wall_rem else say_saying('Must be Used in Dungeons!');
 33    : telep;
 34    : if player.dungeon then xexit else say_saying('Must be Used in a Dungeon!');
 30    :say_saying('Use (X)-ray Command!');
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
 binc(player.ymap,+1)
 else binc(player.ymap,-1);
end else do_a_stairs:=false;
end;

overlay function camper : boolean;
var choicx: char; whet : byte;
begin
if campr>2 then begin
 say_saying('No More Camping For Today....(3 Times per Day Only!)');
 camper:=false; end
else begin
whet:=20-modifier(player.stats[active,6]);
if whet<5 then whet:=5;
if not player.outdoor then begin camper:=false; say_saying('Camping only allowed Outside!');
end else begin
 if random(100) < whet then begin camper:=true; say_saying('You are Ambushed!'); pausescr; end
 else begin
 camper:=false;
 say_saying('Your party''s rest was very refreshing....');
 for whet:=1 to 3 do
  if player.status[whet]<> 8 then begin
   sub_moves(player.stats[whet,10]-player.stats[whet,11]);
   sub_moves(player.stats[whet,8]-player.stats[whet,9]);
   player.stats[whet,11]:=player.stats[whet,10];
   player.stats[whet,9]:=player.stats[whet,8];
  end;
 end;
end;
end;
end;

overlay procedure iport;
var f:text;
    i:str;
    n:integer;
begin
assign(f,paramstr(1));
{$I-} reset(f); {$I+}
if (ioresult=0) then begin
readln(f,usernum);
readln(f,thisuser.name);
readln(f,thisuser.realname);
readln(f,thisuser.callsign);
readln(f,thisuser.age);
readln(f,thisuser.sex);
readln(f,thisuser.gold);
readln(f,thisuser.laston);
readln(f,thisuser.linelen);
readln(f,thisuser.pagelen);
readln(f,thisuser.sl);
readln(f,n);
cs:=(n=1);
readln(f,n);
so:=(n=1);
readln(f,n);
okansi:=(n=1);
readln(f,n);
incom:=(n=1);
readln(f,timeleft);
readln(f,gfilespath);
readln(f,datapath);
readln(f,i);
close(f);
sysopffn:=gfilespath+i;
assign(sysopf,sysopffn);
{$I-} append(sysopf); {$I+}
if (ioresult<>0) then begin
rewrite(sysopf);
end;
end else begin
writeln('%1 file (chain.txt) not found.');
halt;
end;
hangup:=false;
timeon:=timer;
if usernum>1500 then begin
  talknl(8,'Sorry you can''t play, your usernumber is >1500');
  talknl(8,'Have your Sysop Register it!');
  pausescr;
  return;
  end;
end;

overlay procedure intro;
var oneq : char;
begin
printfile('INTRO.ANS');
pausescr; nl;
talk(5,'Do you Still Wish to Play This Adventure? (Y/N): ');
onek(oneq,'NY'); if oneq='N' then return else cls;
end;

overlay procedure create_char(flagg : byte);
type new_char = record
name      : string[25];
experience: array [1..2] of real;
spells    : boolean;
class_name: string[15];
stats     : array [1..15] of byte;
idnum     : byte;
greets    : array [1..4] of helper;
joiner    : helper;
end;
var cchar,te : integer;
person : new_char; person_file: file of new_char;
chx:char; inpuz:str;

 procedure initialize;
 var z:integer;
 begin
  for te:=1 to 3 do player.status[te]:=100;
  for te:=1 to 3 do player.idnum[te]:=0;
  cchar:=0; player.outdoor:=false; player.city:=true; player.dungeon:=false;
  player.goldpieces:=350; player.outxact:=17; player.outyact:=12;
  for z:=1 to 3 do for te:=1 to 10 do player.equippotions[z,te]:=0;
  player.total_moves:=1; active:=1; player.outxmap:=2; player.outymap:=3;
  for z:= 1 to 255 do player.door_exemps[z]:=0;
  for z:=1 to 50 do player.exemptions[z]:=0;
  player.memory:=' ';
 end;

 procedure show_chars;
 begin
 goto_ansixy(15,1);
 for te:=1 to 3 do talknl(4,'                   ');
 goto_ansixy(15,1);
 for te:=1 to 3 do
 if player.status[te]=100 then
 talknl(4,cstr(te)+'. NOT FILLED')
 else talknl(4,cstr(te)+'. '+player.name[te]);
 end;

procedure remove_char;
begin
say_saying('Which Character Do you Wish to Remove? (1..3,0): ');
onek(chx,'0123');
te:=ord(chx)-48;
if te>0 then
 if (player.status[te]=4) or (player.status[te]=7) then begin
   say_saying('Are You Sure you Want to Remove '+player.name[te]+'? (Y/N):');
   onek(chx,'YN');
   if chx='Y' then begin player.status[te]:=100; player.idnum[te]:=0;
   show_chars; cchar:=cchar-1; end;
 end else say_saying('Character Not Valid, must be alive and well!');
end;

procedure pick_char;
var tempy:integer;
begin
repeat
say_saying('Which Character (1-10): ');
input(inpuz,2);
tempy:=value(inpuz);
until (tempy>0) and (tempy<11); reset(person_file);
seek(person_file,tempy-1); read(person_file,person);
end;

procedure view_init;
var gg:byte;
begin
pick_char;
clear_space;
say_saying('Name: '+person.name);
for gg:=1 to 13 do say_saying(stat_name[gg]+'      :   '+cstr(person.stats[gg]));
end;

procedure assigner(gh:integer);
var cnt:byte;
begin
player.name[te]:=person.name;
for cnt:=1 to 15 do player.stats[te,cnt]:=person.stats[cnt];
for cnt:=1 to 2 do player.experience[te,cnt]:=person.experience[cnt];
player.spells[te]:=person.spells;
player.class_name[te]:=person.class_name;
player.idnum[te]:=person.idnum;
player.food[te]:=5;
player.equipweapon[te]:=weapon[9];
player.equipmis[te]:=weapon[10];
player.equiparmor[te]:=armor[1];
player.equipring[te]:=ring[1]; active:=1;
player.status[te]:=4;
cchar:=cchar+1; show_chars;
say_saying(person.joiner);
player.stats[te,16]:=0;
end;

procedure personality;
begin
pick_char;
clear_space;
for te:=1 to 4 do say_saying(person.greets[te]);
end;

procedure invite;
var pass:boolean;
begin
pick_char;
clear_space; pass:=true;
for te:=1 to 3 do
  if player.idnum[te]=person.idnum then pass:=false;
if cchar=3 then pass:=false;
te:=1;
if pass then
 repeat
 if player.status[te]=100 then begin assigner(te); te:=4; end
  else te:=te+1;
 until te=4;
if not pass then say_saying('Duplicate Character Found/Or too Many characters!');
end;

procedure rename;
var xx:integer; xxc:char; doper:str;
begin
say_saying('Which Character to Rename? (1-3): ');
onek(xxc,'123');
xx:=ord(xxc)-48;
if player.status[xx]=100 then say_saying('You can''t do that!') else
  begin
   say_saying('Enter New Name (20 Chars Max) : ');
   input(doper,20);
   player.name[xx]:=doper;
  end;
show_chars;
end;

begin
assign(person_file,'CHARDATA.DAT');
if flagg=1 then initialize else cchar:=3;
printfile('CHARDAT.LST');
show_chars;
repeat
say_saying('Choice (EINPRVZ): ');
onek(chx,'EINPRVZ');
case chx of
  'E' : if cchar<>3 then say_saying('You can''t leave until you have three Characters!');
  'I' : invite;
  'N' : rename;
  'P' : personality;
  'R' : remove_char;
  'V' : view_init;
  'Z' : return;
end;
until (chx='E') and (cchar=3);
close(person_file);
if flagg=1 then player.status[1]:=7;
end;

overlay procedure do_temple;
var chx:char; count:byte;

procedure change_act;
 begin
 goto_ansixy(11,9);
 for count:=1 to 3 do print(CHR(27)+'[K');
 for count:=1 to 3 do begin goto_ansixy(10+count,9);
 talknl(player.status[count],cstr(count)+'. '+player.name[count]+' -- HPS: '
      +cstr(player.stats[count,10])+'/'+cstr(player.stats[count,11]));
end; goto_ansixy(14,9);
 talknl(3,'Goldpieces:  '+cstrr(player.goldpieces,10));
 end;

procedure cure_poison;
var cost:integer; chx:char;
begin
if player.status[active]<>5 then say_saying('This Character Doesn''t Need Curing!')
 else begin
 cost:=35*player.stats[active,12];
 say_saying('This Service costs '+cstr(cost)+' Gold Pieces');
 say_saying(player.name[active]+' Will be Cured, Proceed? (Y/N)');
 onek(chx,'YN');
 if chx='Y' then
  if player.goldpieces<cost then say_saying('Not Enough Gold, Come Back Later!')
   else begin
     player.goldpieces:=player.goldpieces-cost;
     say_saying('Um Chri Tatum Ve!');
     player.status[active]:=4;
     say_saying('Your Character has been Cured of the Affliction!');
     change_act;
   end;
end;
end;

procedure heal_wounds;
var cost:integer; chx:char;
begin
cost:=(player.stats[active,10]-player.stats[active,11])*player.stats[active,12];
if cost=0 then say_saying('You do not need this service') else
 begin
  say_saying('The Service of Healing All Wounds Costs: '+cstr(cost)+' Gold Pieces');
  say_saying(player.name[active]+' Will Receive the Spell, Proceed (Y/N): ');
  onek(chx,'YN');
  if chx='Y' then
   if player.goldpieces<cost then say_saying('You do not have enough Gold for this Action!')
    else begin
      player.goldpieces:=player.goldpieces-cost;
      player.stats[active,11]:=player.stats[active,10];
      say_saying('"Chitra Niridi Nirvada", the Priests Chant in Unison!');
      change_act;
    end;
end;
end;


procedure raise_dead;
var x,modix,cost,oner:integer; chx:char;
begin
say_saying('Which Character Needs to Be Raised? (1-3,0)?: ');
onek(chx,'0123');
if chx<>'0' then begin
 oner:=ord(chx)-48;
 if player.status[oner]<>8 then say_saying('This Character Doesn''t Need to be Resurrected!')
 else begin modix:=1;
 for x:=1 to player.stats[oner,12] do modix:=modix*2;
 cost:=250*modix;
 say_saying('This Service costs '+cstr(cost)+' Gold Pieces');
 say_saying(player.name[oner]+' Will be Raised from the Dead, Proceed? (Y/N)');
 onek(chx,'YN');
 if chx='Y' then
  if player.goldpieces<cost then say_saying('Not Enough Gold, Come Back Later!')
   else begin
     player.goldpieces:=player.goldpieces-cost;
     say_saying('"Glifra Aatum Ung Fintar!", the Head Priest Chants!');
     player.status[oner]:=4; player.stats[oner,11]:=player.stats[oner,10];
     say_saying(player.name[oner]+' Character has been Raised!');
     change_act;
   end;
end;
end;
end;


procedure sell_potion;
var choicer: char; chocstr : str;

 procedure display_list;
 var xx,colr,lister:byte;
 begin
 for xx:=1 to 3 do begin
 if xx=active then colr:=7 else colr:=4;
 for lister:= 1 to 10 do begin
   goto_ansixy(5+lister,44+(xx*4));
   talk(colr,cstr(player.equippotions[xx,lister]));
 end; end;
 goto_ansixy(17,2); talk(3,'       '); goto_ansixy(17,2);
 talk(3,'Party Gold: '+cstrr(player.goldpieces,10));
end;

procedure purchase;
var which1,quant,maxquant : integer;
cost:real;
begin
repeat
say_saying('Which Potion # will you Purchase (0-10): ');
input(chocstr,2);
which1:=value(chocstr);
until (which1>-1) and (which1<11);
if which1>0 then begin
  repeat
  maxquant:=255-player.equippotions[active,which1];
  say_saying('How Many Potions of '+potion_array[which1].name+' Do You Wish ');
  say_saying('To Purchase 0-'+cstr(maxquant)+': ');
  input(chocstr,3);
  quant:=value(chocstr);
  until (quant>-1) and  (quant<maxquant+1);
  if quant>0 then begin
    cost:=quant*potion_array[which1].cost;
    say_saying('This Costs '+cstrr(cost,10)+' Gold Pieces.  OK? (Y/N): ');
    onek(choicer,'YN');
    if choicer='Y' then
     if player.goldpieces<cost then say_saying('Not Enough Gold, Come Back Later')
      else begin
        player.goldpieces:=player.goldpieces-cost;
        player.equippotions[active,which1]:=quant+player.equippotions[active,which1];
        say_saying('Purchased!');
        display_list;
      end;
  end;
 end;
end;

procedure sell;
var which1,quant,maxquant : integer;
cost:real;
begin
repeat
say_saying('Which Potion Number Will you Sell (0-10): ');
input(chocstr,2);
which1:=value(chocstr);
until (which1>-1) and (which1<11);
if which1>0 then begin
  repeat
  maxquant:=player.equippotions[active,which1];
  say_saying('How Many Potions of '+potion_array[which1].name+' Do You Wish ');
  say_saying('To Sell 0-'+cstr(maxquant)+': ');
  input(chocstr,3);
  quant:=value(chocstr);
  until (quant>-1) and  (quant<maxquant+1);
  if quant>0 then begin
    cost:=(quant*potion_array[which1].cost)*0.5;
    say_saying('I Will Pay '+cstrr(cost,10)+' Gold Pieces.  OK? (Y/N): ');
    onek(choicer,'YN');
    if choicer='Y' then
    begin
     player.goldpieces:=player.goldpieces+cost;
     player.equippotions[active,which1]:=player.equippotions[active,which1]-quant;
     say_saying('Sold!');
     display_list;
    end;
  end;
 end;
end;

begin
cls;
printfile('POTION.ANS');
display_list;
repeat
say_saying('Active Player '+player.name[active]+', Choice (123LPS): ');
onek(choicer,'123LPS');
case choicer of
 '1' : begin active_change(1); display_list; end;
 '2' : begin active_change(2); display_list; end;
 '3' : begin active_change(3); display_list; end;
 'L' :;
 'P' : purchase;
 'S' : sell;
end;
until choicer='L';
end;


begin
cls;
printfile('TEMPLE.ANS'); dialcnt:=18; change_act;
repeat
say_saying('Active Player: '+player.name[active]+', Choice: 123CHLPR: ');
onek(chx,'123CHLPR');
case chx of
'1' :begin active_change(1); change_act; end;
'2' :begin active_change(2); change_act; end;
'3' :begin active_change(3); change_act; end;
'C' :cure_poison;
'H' :heal_wounds;
'P' :begin sell_potion; printfile('TEMPLE.ANS'); end;
'L' :;
'R' :raise_dead;
end;
until chx='L';
end;


overlay procedure general_store;
var chx:char; inputs:str;

   procedure disp_gold;
   begin
   goto_ansixy(16,5);
   talknl(3,'Party Gold Pieces: '+cstrr(player.goldpieces,10)+'  ');
   end;

   procedure clear_room;
   var count:byte;
   begin
   for count:=4 to 15 do begin
    goto_ansixy(count,39);
    print(CHR(27)+'[K');
   end;
   end;

   procedure fewd;
   var amnt,cost,charge:integer; maxq:byte;
   begin
   cost:=3*town_stuff.price_mod; maxq:=99-player.food[active];
   say_saying('Food Costs '+cstr(cost)+' Gold Pieces Per Ration');
   say_saying(player.name[active]+' Has '+cstr(player.food[active])+' Rations');
   repeat
   say_saying('How Many Rations Do You Want? (0-'+cstr(maxq)+'): ');
   input(inputs,2); amnt:=value(inputs);
   until (amnt>-1) and (amnt<maxq+1);
   charge:=amnt*cost;
   if (charge>player.goldpieces) or (amnt=0)
      then say_saying('No Gold, No Rations... Come Back Later!')
    else begin
      player.goldpieces:=player.goldpieces-charge;
      player.food[active]:=player.food[active]+amnt;
      say_saying('The Store Keeper Gives you the Rations!');
    end;
    end;
   procedure equip_view;
   begin
   with player do begin
   clear_room;
   goto_ansixy(4,40);
   talk(4,'Food           : '+cstr(food[active]));
   goto_ansixy(5,40);
   talk(4,'Armor          : '+equiparmor[active].name+' +'+cstr(equiparmor[active].magical));
   goto_ansixy(6,40);
   talk(4,'Melee Weapon   : '+equipweapon[active].name+' +'+cstr(equipweapon[active].magical));
   goto_ansixy(7,40);
   talk(4,'Missile Weapon : '+equipmis[active].name+' +'+cstr(equipmis[active].magical));
   end; end;

   procedure gear(categ:char);
   var cnt2,which1 : integer; chcoc:char;

 procedure display_armor;
 begin
  for cnt2:= 1 to 5 do begin
  goto_ansixy(3+cnt2,40);
talk(4,cstr(cnt2)+'. '+armor[cnt2].name+' +'+cstr(armor[cnt2].magical)+' Costs: '+cstrr(armor[cnt2].cost,10));
  end;
 end;

  procedure display_weapon;
  begin
   for cnt2:=1 to 8 do begin
   goto_ansixy(3+cnt2,40);
 talk(4,cstr(cnt2)+'. '+weapon[cnt2].name+' +'+cstr(weapon[cnt2].magical)+' Costs: '+cstrr(weapon[cnt2].cost,10));
   end;
  end;

    procedure getnum(maxer:byte);
    begin
    repeat
    say_saying('Enter Number of the Item (1-'+cstr(maxer)+'): ');
    input(inputs,2);
    which1:=value(inputs);
    until (which1>0) and (which1<maxer+1);
    end;

     procedure show_item(equip : items);
     begin
     clear_space;
     say_saying('Name          : '+equip.name+' +'+cstr(equip.magical));
     say_saying('Cost          : '+cstrr(equip.cost,10));
     say_saying('Min. Strength : '+cstr(equip.charges));
     if categ='A' then
     say_saying('Protection    : '+cstr(equip.protect))
      else begin
     say_saying('Min. Damage   : '+cstr(equip.mindam)+'      Max. Damage   : '+cstr(equip.maxdam));
     say_saying('# of Attacks  : '+cstr(equip.numat));
     if equip.testers then say_saying('This is a Melee Weapon') else
       say_saying('This is Missile Weapon');
    end;
    end;

    procedure information;
    begin
    if categ='W' then getnum(8) else getnum(5);
    if which1>0 then
      if categ='W' then show_item(weapon[which1]) else show_item(armor[which1]);
    end;

    procedure purchase;
    var chxx:char; tempitem:items;
    begin
    information;
    if categ='W' then tempitem:=weapon[which1] else tempitem:=armor[which1];
    say_saying('Purchase The '+tempitem.name+'? (Y/N): ');
    onek(chxx,'YN');
   if chxx='Y' then
    if player.goldpieces<tempitem.cost then say_saying('Not Enough Gold to Buy This!')
     else if player.stats[active,1]<tempitem.charges then say_saying('Not Enough Strength to Use This!')
      else begin
       player.goldpieces:=player.goldpieces-tempitem.cost;
       if categ='A' then player.equiparmor[active]:=tempitem
        else if tempitem.testers then player.equipweapon[active]:=tempitem
         else player.equipmis[active]:=tempitem;
       say_saying('You have Purchased '+tempitem.name+' May it Serve you Well!');
       end;
     end;

   procedure sell;
   var chxx,chx2:char; amnt:real;
       magicplus:array [0..5] of integer;
   begin
   magicplus[1]:=100; magicplus[2]:=750; magicplus[3]:=2500;
   magicplus[4]:=5000; magicplus[5]:=12000; magicplus[0]:=0;
   with player do begin
   clear_space; say_saying('0. No Action');
   say_saying('1. Missile Weapon '+equipmis[active].name+' +'+cstr(equipmis[active].magical));
   say_saying('2. Melee Weapon   '+equipweapon[active].name+' +'+cstr(equipweapon[active].magical));
   say_saying('3. Armor          '+equiparmor[active].name+' +'+cstr(equiparmor[active].magical));
   say_saying('Choice: (0-3): ');
   onek(chxx,'0123');
   case chxx of
    '1' : begin amnt:=equipmis[active].cost * 0.5; amnt:=amnt+magicplus[equipmis[active].magical]; end;
    '2' : begin amnt:=equipweapon[active].cost * 0.5; amnt:=amnt+magicplus[equipweapon[active].magical]; end;
    '3' : begin amnt:=equiparmor[active].cost * 0.5; amnt:=amnt+magicplus[equiparmor[active].magical]; end;
   end;
   if amnt<1 then begin say_saying('That is Not Saleable!'); chxx:='0'; end;
   if chxx<>'0' then begin
   clear_space;
   say_saying('I''ll offer you '+cstrr(amnt,10)+' Gold Pieces, Okay (Y/N): ');
   onek(chx2,'NY');
   if chx2='Y' then begin
     case chxx of
      '1' : equipmis[active]:=weapon[10];
      '2' : begin equipweapon[active]:=weapon[9];
            equipweapon[active].cost:=0; equipweapon[active].magical:=0; end;
      '3' : begin equiparmor[active]:=armor[1];
            equiparmor[active].cost:=0; equiparmor[active].magical:=0; end;
     end;
     goldpieces:=goldpieces+amnt;
   end;
   end;
end;
end;


  begin
   clear_room;
   if categ='A' then display_armor else display_weapon;
   repeat
    say_saying(Player.name[active]+' Choice: (AEFIPLSW123): ');
    onek(chcoc,'AEFIPLSW123');
    case chcoc of
      '1':active_change(1);
      '2':active_change(2);
      '3':active_change(3);
      'A':begin categ:='A'; clear_room; display_armor; end;
      'E':equip_view;
      'F':fewd;
      'I':information;
      'P':purchase;
      'L':;
      'S':sell;
      'W':begin categ:='W'; clear_room; display_weapon; end;
     end;
     disp_gold;
    until chcoc='L';
clear_room;
  end;

begin
cls;
printfile('GENERAL.ANS'); dialcnt:=18; disp_gold;
repeat
say_saying('Active Player, '+player.name[active]+', Choice (AFLW123): ');
onek(CHX,'123AEFLW');
case chx of
  '1' : active_change(1);
  '2' : active_change(2);
  '3' : active_change(3);
  'A','W' : gear(chx);
  'E' : equip_view;
  'F' : begin fewd; disp_gold; end;
end;
until chx='L';
end;

overlay procedure view_act_player;
var s_name:string[15]; count:byte;
begin
cls;
talknl(8,'Name         :    '+player.name[active]);
talknl(7,'Class        :    '+player.class_name[active]);
case player.status[active] of
 3: s_name:='Hungry';
 4,7: s_name:='Healthy';
 5: s_name:='Sick/Poison';
 8: s_name:='Dead' {not possible}
end;
talknl(player.status[active],'Status       :    '+s_name); nl;
for count:=1 to 7 do begin
  talk(4,stat_name[count]);
  goto_ansixy(count+4,21);
  talk(4,':   '+cstr(player.stats[active,count]));
  goto_ansixy(count+4,41);
  talk(4,stat_name[count+7]);
  goto_ansixy(count+4,61);
  talknl(4,':   '+cstr(player.stats[active,count+7]));
end;
nl;
for count:=1 to 5 do begin
  talk(4,potion_array[count].name);
  goto_ansixy(count+12,21);
  talk(4,':   '+cstr(player.equippotions[active,count]));
  goto_ansixy(count+12,41);
  talk(4,potion_array[count+5].name);
  goto_ansixy(count+12,61);
  talknl(4,':   '+cstr(player.equippotions[active,count+5]));
end;
pausescr;
nl;
talknl(3,'Armor          :   '+player.equiparmor[active].name+' +'+cstr(player.equiparmor[active].magical));
talknl(3,'Missile Weapon :   '+player.equipmis[active].name+' +'+cstr(player.equipmis[active].magical));
talknl(3,'Melee Weapon   :   '+player.equipweapon[active].name+' +'+cstr(player.equipweapon[active].magical));
talknl(3,'Ring           :   '+player.equipring[active].name+' +'+cstr(player.equipring[active].magical));
talknl(3,'Current Exper. :   '+cstrr(player.experience[active,1],10));
talknl(3,'Needed Exper.  :   '+cstrr(player.experience[active,2],10));
talknl(3,'Party Gold     :   '+cstrr(player.goldpieces,10)); nl;
pausescr;
end;

overlay procedure fast_mode;
var chx : char; a,b : byte;
begin
say_saying('Do you Wish to Have No-Color Scroll?');
say_saying('Highly Recommended for 1200 and some 2400 bps? (Y/N): ');
onek(chx,'YN');
if chx='Y' then a:=1 else a:=0;
say_saying('Do Not View Wilderness/Dungeon Framework Screen (Y/N): ');
onek(chx,'YN');
if chx='Y' then b:=1 else b:=0;
player.door_exemps[254]:=b;
player.door_exemps[255]:=a;
end;


overlay procedure use_which_potion;
var x: byte; chi: char; chk:str;

procedure use_pot(loc,changee,max_cha,dupper: integer);
var t:integer;
begin
t:=random(player.stats[active,12]*dupper)+3+modifier(player.stats[active,6]);
if t<1 then t:=1;
player.stats[active,changee]:=player.stats[active,changee]+t;
if player.stats[active,changee] > max_cha then begin t:=max_cha-player.stats[active,changee];
   player.stats[active,changee]:=max_cha; end;
if t<1 then t:=1;
say_saying('You Gained '+cstr(t)+' Points of '+stat_name[changee]);
if t>0 then
 binc(player.equippotions[active,loc],-1);
end;

procedure cure_all;
begin
if player.status[active]=5 then begin
  player.status[active]:=4;
  binc(player.equippotions[active,9],-1);
  say_saying('You are cured of your Ailment!');
end else say_saying('You Do Not Need to use This Potion');
end;

procedure bat_integ;
var tt:integer;
begin
if player.stats[active,16]>act_stats[active,16] then say_saying('You already have too much Battle Integ.')
 else begin
   binc(player.equippotions[active,3],-1);
   tt:=random(3)+1;
   inc(player.stats[active,16],tt);
   say_saying('You have gained '+cstr(tt)+' Points of Battle Integrity');
 end;
end;

begin
chk:='0';
say_saying(player.name[active]+' Usable Potions (0 for None): ');
for x:=1 to 9 do
if player.equippotions[active,x]>0 then begin
    say_saying(cstr(x)+'. Potion of '+potion_array[x].name);
    chk:=chk+chr(x+48);
end;
say_saying('Choice ('+chk+'): '); onek(chi,chk);
x:=(ord(chi)-48);
if chi <> '0' then
 case chi of
 '1' : use_pot(1,11,player.stats[active,10],8);
 '2' : use_pot(2,9,player.stats[active,8],8);
 '3' : bat_integ;
 '4' : use_pot(4,1,act_stats[active,1]+20,2);
 '5' : use_pot(5,6,act_stats[active,6]+20,2);
 '6' : use_pot(6,4,act_stats[active,4]+20,2);
 '7' : use_pot(7,7,act_stats[active,7]+20,2);
 '8' : use_pot(8,13,act_stats[active,13]+1,2);
 '9' : cure_all;
 end;
end;

overlay procedure enter_inn;
var choicx : char; cost:integer; heni1,heni2: byte;
begin
say_saying('You Come Upon an Lonely Inn, stop by and rest? (Y/N)');
onek(choicx,'YN');
if choicx='Y' then begin
clear_space; cost:=0;
for heni1:=1 to 3 do if player.status[heni1]<>8 then begin
cost:=(player.stats[heni1,10]-player.stats[heni1,11]);
cost:=cost+(player.stats[heni1,8]-player.stats[heni1,9]-modifier(player.stats[heni1,7]));
end;
if cost < 1 then cost:=5;
say_saying('It costs '+cstr(cost)+' Gold Pieces to Sleep Here!');
say_saying('You have '+cstrr(player.goldpieces,10)+' Gold Pieces!');
say_saying('All your wounds will be healed! Choice (Y/N) :');
onek(choicx,'YN');
if choicx = 'Y' then begin
 clear_space;
  if player.goldpieces > (cost-1) then
    for heni1:=1 to 3 do
     if player.status[heni1]<>8 then begin
    player.stats[heni1,10]:=player.stats[heni1,11];
    player.stats[heni1,9]:=player.stats[heni1,8];
    player.goldpieces:=player.goldpieces-cost;
   end; sub_moves(cost);
   say_saying('Your Party is Completely Healed!');
  end
 else say_saying('No Gold -- No Service!');
end;
cost:=50-modifier(player.stats[active,7])+random(12);
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

overlay procedure destroy_char;
var saver: file of character; ginput:char;
filename:string[8];
begin
filename:='        ';
str(usernum,filename);
filename:=filename+'.SAV';
say_saying('Choice: (D)estroy, (N)othing, (Q)uit w/o Saving, Your Party?: ');
onek(ginput,'DNQ');
if ginput='D' then begin
 assign(saver,filename);
 erase(saver); sysoplog('Killed his/her character by ''Z'' method!');
 say_saying('Play Again Real Soon!'); return;
end;
if ginput='Q' then return;
if ginput='N' then say_saying('Continue Playing......');
end;


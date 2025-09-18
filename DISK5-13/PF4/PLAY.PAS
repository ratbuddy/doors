unit play;
interface
uses common;
procedure start_play;
implementation

procedure start_play;
type data = record
      rep : string[70];
     end;
var max_card,active,c7:byte;
    action_played:array [1..5] of byte;
    funnel:boolean;
    grp_name:array [1..5] of string[12];
    fpower : array [1..5,0..5] of real;
    def_mod : array [1..5] of byte;
    data_file : file of data;
    data_arr  : array [1..50] of data;
    message   : byte;

procedure determine_active;
var a:byte;
begin
for a:=1 to 4 do
if player.names[a]=thisuser.name then active:=a;
end;

procedure report_log(temp:string);
var speed:byte;
begin
for speed:=2 to 50 do
 data_arr[speed-1].rep:=data_arr[speed].rep;
data_arr[50].rep:=temp;
end;

procedure do_name(a:byte);
begin
case a of
  1:goto_ansixy(5,19);
  2:goto_ansixy(5,58);
  3:goto_ansixy(13,19);
  4:goto_ansixy(13,58);
end;
talk(a+1,player.names[a]);
case a of
  1:goto_ansixy(6,6);
  2:goto_ansixy(6,45);
  3:goto_ansixy(14,6);
  4:goto_ansixy(14,45);
end;
case player.races[a] of
  1:talk(7,'Elf');
  2:talk(7,'Human');
  3:talk(7,'Dwarf');
end;
end;

procedure parser(code:byte; namer:helper);
begin
clear_eol(2,1);
goto_ansixy(2,1);
ansic(code);
prompt(namer);
if code<>2 then pausescr;
end;

procedure do_actions(a:byte);
var t,vx,vy:byte;
begin
case a of
 1: begin vx:=3; vy:=7 end;
 2: begin vx:=42; vy:=7; end;
 3: begin vx:=3; vy:=15; end;
 4: begin vx:=42; vy:=15; end;
end;
for t:=1 to 5 do begin
  goto_ansixy(vy,vx);
  inc(vy);
  if action_played[t]>0 then talk(8,'*');
end;
end;

function action_play(poop:byte) : boolean;
begin
if action_played[poop]>0 then action_play:=true else action_play:=false;
end;

procedure do_amounts(a:byte);
var yt,yt2,yt3:byte;
begin
case a of
 1: begin yt:=20; yt2:=7; end;
 2: begin yt:=59; yt2:=7; end;
 3: begin yt:=20; yt2:=15; end;
 4: begin yt:=59; yt2:=15; end;
end;
for yt3:=1 to 5 do begin
 goto_ansixy(yt2,yt);
 talk(2,cstr(player.amounts[a,yt3])+' ');
 inc(yt2);
end;
end;

procedure do_terrains(a:byte);
var yt,yt2,yt3,colr:byte; terr:char;
begin
case a of
 1: begin yt:=24; yt2:=7; end;
 2: begin yt:=63; yt2:=7; end;
 3: begin yt:=24; yt2:=15; end;
 4: begin yt:=63; yt2:=15; end;
end;
for yt3:=1 to 5 do begin
 colr:=2;
 goto_ansixy(yt2,yt);
 case player.terrains[a,yt3] of
   0,100,200..206 : terr:='=';
   1,101 : begin terr:=''; colr:=7; end;
   2,102 : begin terr:='B'; colr:=7; end;
   3,103 : begin terr:='ï'; colr:=3; end;
   4,104 : begin terr:='T'; colr:=0; end;
   5,105 : begin terr:='C'; colr:=0; end;
   6,106 : begin colr:=3; terr:='‘'; end;
 end;
 if player.terrains[a,yt3]>99 then colr:=8;
 if player.terrains[a,yt3]>199 then player.terrains[a,yt3]:=0;
 talk(colr,terr);
 inc(yt2);
end;
end;

procedure do_smokes(a:byte);
var yt,yt2,yt3:byte;
begin
case a of
 1: begin yt:=28; yt2:=7; end;
 2: begin yt:=67; yt2:=7; end;
 3: begin yt:=28; yt2:=15; end;
 4: begin yt:=67; yt2:=15; end;
end;
for yt3:=1 to 5 do begin
 if player.smoked[a,yt3]>0 then begin goto_ansixy(yt2,yt); talk(0,'S'); end;
 inc(yt2);
end;
end;

procedure do_ranges(a:byte);
var yt,yt2,yt3:byte;
begin
case a of
 1: begin yt:=32; yt2:=7; end;
 2: begin yt:=71; yt2:=7; end;
 3: begin yt:=32; yt2:=15; end;
 4: begin yt:=71; yt2:=15; end;
end;
for yt3:=1 to 5 do begin
 goto_ansixy(yt2,yt);
 talk(0,cstr(player.ranges[a,yt3]));
 inc(yt2);
end;
end;

procedure draw_all;
var x:byte;
begin
for x:=1 to 4 do begin
  do_name(x);
  do_amounts(x);
  do_terrains(x);
  do_smokes(x);
  do_ranges(x);
end;
end;

procedure draw_new_cards;
var a:byte;
begin
for a:=1 to 5 do
 action_played[a]:=0;
case player.races[active] of
  1: max_card:=6;
  2: max_card:=5;
  3: max_card:=4;
end;
for a:=1 to max_card do
 if player.cards_held[active,a].idnum=0 then begin
   player.cards_held[active,a]:=player.card[player.current_card];
   inc(player.current_card);
   if player.current_card>184 then begin
      player.current_card:=1;
      load_cards;
      report_log('Reshuffled Deck!');
   end;
 end;
end;

procedure display_cards;
var count:byte; prstring:string[4];
begin
goto_ansixy(1,1);
for count:= 1 to max_card do begin
  case player.cards_held[active,count].idnum of
       0 : prstring:='NILL';
    1..8 : prstring:='WODS';
   9..20 : prstring:='BUSH';
  21..28 : prstring:='HILS';
  29..35 : prstring:='TOWR';
  36..40 : prstring:='CASL';
  41..49 : prstring:='SWAM';
  50..80 : prstring:='MOVE';
  81..85 : prstring:='FI02';
  86..96 : prstring:='FI04';
 97..105 : prstring:='FI06';
106..115 : prstring:='FI08';
116..121 : prstring:='FI10';
122..125 : prstring:='FI12';
126..130 : prstring:='FI14';
131..134 : prstring:='FI16';
135..138 : prstring:='FI18';
139..140 : prstring:='FI20';
141..150 : prstring:='RFAR';
151..160 : prstring:='RFFT';
161..166 : prstring:='RFWZ';
167..170 : prstring:='RFKT';
171..172 : prstring:='RFDG';
173..178 : prstring:='SMKE';
179..180 : prstring:='ERQK';
181..183 : prstring:='FIRE';
     184 : prstring:='HERO';
end;
talk(7,chr(count+64)+'. '+prstring+'   ');
end;
nl;
end;

procedure help_me;
begin
parser(3,'C = Clear D = Discard E = End Turn F = Fire P = Play a Card R = Reports');
end;

function discarder:boolean;
var siq:char; numcar:byte; mover:boolean;
begin
repeat
mover:=true;
parser(2,'Which card do you Wish To Discard? (A-F,0): ');
onek(siq,'ABCDEF0');
numcar:=ord(siq)-64;
if siq<>'0' then
  if player.cards_held[active,numcar].idnum=0 then begin
    parser(8,'That Card is Not Discardable!'); mover:=false;
   end else begin
    parser(7,'Discarded!');
    player.cards_held[active,numcar].idnum:=0;
    funnel:=true;
    display_cards;
  end;
until mover;
if siq='0' then discarder:=false else discarder:=true;
report_log(player.names[active]+' Discarded a Card');
end;

procedure discard;
var testz:boolean; cnt,que:byte;
begin
que:=0;
testz:=false;
case player.races[active] of
  1: begin
      for cnt:=1 to 5 do
        if action_played[cnt]>0 then inc(que);
        if que=0 then testz:=discarder else parser(8,'You have already played an Action!');
        if testz=true then testz:=discarder;
     end;
  2: testz:=discarder;
  3: begin
      for cnt:=1 to 5 do
       if action_played[cnt]>0 then inc(que);
       if que>0 then parser(8,'You have already Played an Action!') else
        repeat testz:=discarder; until testz=false;
     end;
end;
end;

procedure winner;
type table=record
       name:string[25];
       wins:word;
       losses:word;
       inv:char;
    end;
var tab_var: table;
    tab_file: file of table;
    scount,eat:byte;
    cnter: longint;
    game_fil :file of gamer;
    game_var : array [1..26] of gamer;
begin
parser(8,'Congratulations, you have won!');
assign(tab_file,'TABLE.PIT');
for scount:=1 to 4 do begin
   reset(tab_file);
   cnter:=1;
   while cnter<high-1 do begin
     read(tab_file,tab_var);
     if tab_var.name<>player.names[scount] then inc(cnter) else begin
      if scount=active then inc(tab_var.wins);
      if (scount=active) and (player.races[active]=3) then inc(tab_var.wins);
      if scount<>active then inc(tab_var.losses);
      tab_var.inv:=' ';
      reset(tab_file);
      seek(tab_file,cnter-1);
      write(tab_file,tab_var);
      cnter:=high+5;
     end;
   end;
end;
close(tab_file);
assign(game_fil,'GAMES.PIT');
reset(game_fil);
for cnter:=1 to 26 do
  read(game_fil,game_var[cnter]);
close(game_fil);
scount:=ord(player.game_let)-64;
for cnter:=1 to 4 do
  for eat:=1 to 3 do begin
   game_var[scount].laston[cnter,eat]:=0;
   game_var[scount].name[cnter]:='%';
  game_var[scount].races[cnter]:=0;
end;
rewrite(game_fil);
for cnter:=1 to 26 do write(game_fil,game_var[cnter]);
close(game_fil);
assign(game_fil,'GAME'+player.game_let+'.SAV');
reset(game_fil); close(game_fil);
erase(game_fil);
assign(game_fil,'MESS'+player.game_let+'.SAV');
reset(game_fil); close(game_fil);
erase(game_fil);
funnel:=true;
end;

procedure do_terrain(locx:byte);
var rst:char; lcx,save_var:byte;
  procedure do_swamp;
  begin
  parser(2,'Which Person (may be self) do you want to Place the Swamp on (1-4): ');
  onek(rst,'1234');
  report_log(player.names[active]+' Played a Swamp Card on '+player.names[ord(rst)-48]);
  active:=ord(rst)-48;
  end;

begin
save_var:=active;
if player.cards_held[active,locx].special_num=6 then do_swamp;
parser(2,'Which Group would you like to Place this terrain on? (A-E,0): ');
onek(rst,'ABCDE0');
if rst<>'0' then begin
  lcx:=ord(rst)-64;
  if player.terrains[active,lcx]<100 then parser(8,'They are NOT eligible for Terrain!')
   else
    if (action_play(lcx)) and (player.cards_held[save_var,locx].special_num<>6)
     then parser(8,'Already Played an Action this Turn!')
     else begin
     player.terrains[active,lcx]:=player.cards_held[save_var,locx].special_num;
     do_terrains(active);
     player.cards_held[save_var,locx].idnum:=0;
     parser(7,'Group '+rst+'. Now in Their Terrain!');
     report_log(player.names[save_var]+' Played Terrain on Group '+rst);
     if player.cards_held[save_var,locx].special_num<>6 then action_played[lcx]:=1;
     do_actions(save_var);
     player.smoked[active,lcx]:=0;
     do_smokes(active);
     if player.ranges[active,lcx]>4 then winner;
   end;
end;
active:=save_var;
display_cards;
end;

procedure clear_terrain;
var chx,grp:char; carnum,grpnum:byte;
begin
parser(2,'Which Card do you want to use as Clear Terrain (A-F,0): ');
onek(chx,'ABCDEF0');
if chx<>'0' then begin
  carnum:=ord(chx)-64;
  if player.cards_held[active,carnum].idnum=0 then parser(8,'Invalid Card!')
   else begin
     parser(2,'Which Group do you want to Receive Clear Terrain (A-E): ');
     onek(grp,'ABCDE'); grpnum:=ord(grp)-64;
     if player.terrains[active,grpnum]<99 then parser(8,'Not Eligible for Clear Terrain!')
      else if action_play(grpnum) then parser(8,'Already Played an Action this Turn')
      else begin
       player.cards_held[active,carnum].idnum:=0;
       player.terrains[active,grpnum]:=0;
       action_played[grpnum]:=1;
       player.smoked[active,grpnum]:=0;
       report_log('The '+grp_name[grpnum]+' Landed in Clear Terrain!');
       parser(7,'Landed in Clear Terrain...');
       do_terrains(active);
       display_cards;
       do_actions(active);
       do_smokes(active);
       if player.ranges[active,grpnum]>4 then parser(7,'Do Note, you will need a REAL Terrain Card to Win!');
    end;
  end;
 end;
end;

procedure get_outswamp(group,carlox:byte);
var percen:byte;
begin
case group of
  1,2 : percen:=35;
  3,4 : percen:=65;
  5   : percen:=85;
end;
if percen>random(100) then begin
  parser(7,'The Group got out of the Swamp!');
  player.terrains[active,group]:=0;
  report_log(player.names[active]+' Group '+chr(group+64)+' Escaped the Swamp!');
  do_terrains(active);
end else begin
  parser(7,'The Group failed to Get out of the Swamp!');
  report_log(player.names[active]+' Group '+chr(group+64)+' Failed to Escape the Swamp!');
end;
player.cards_held[active,carlox].idnum:=0;
display_cards;
action_played[group]:=1;
do_actions(active);
end;

function not_too_high(test:byte):boolean;
var cnt,cnt2:byte;
begin
not_too_high:=true;
for cnt:=1 to 4 do
 for cnt2:=1 to 5 do
   if cnt<> active then
     if test+player.ranges[cnt,cnt2]+1>5 then
       begin
         parser(4,'Player Number '+cstr(cnt)+' Group '+chr(cnt2+64)+' is Blocking you!');
         not_too_high:=false;
       end;
end;

procedure do_move(locx:byte);
var modm:integer;resi:byte; chj,dir:char;
begin
parser(2,'Which Group do you Want to Play the Movement Option on? (A-E,0): ');
onek(chj,'ABCDE0');
parser(2,'Direction? (B=Backwards  F=Forwards  S=Sideways): ');
onek(dir,'BFS');
case dir of
  'B': modm:=-1;
  'F': modm:=1;
  'S': modm:=0;
end;
if chj<>'0' then begin
  resi:=ord(chj)-64;
 if (modm=-1) and (player.ranges[active,resi]<1) then parser(4,'You can''t move into Negative Ranges!')
 else if player.amounts[active,resi]<1 then parser(4,'Nobody in that Group!') else
  if action_play(resi) then parser(4,'They have already played an Action this Turn!')
   else if player.terrains[active,resi]>199 then parser(4,'Already have TWO Movement Cards there!')
    else if player.terrains[active,resi]=6 then get_outswamp(resi,locx) else
      if ((modm=1) and (not_too_high(player.ranges[active,resi])))
       or (modm<1) then begin
      player.terrains[active,resi]:=player.terrains[active,resi]+100;
      player.cards_held[active,locx].idnum:=0;
      player.ranges[active,resi]:=player.ranges[active,resi]+modm;
      display_cards;
      action_played[resi]:=1;
      do_terrains(active);
      do_ranges(active);
      do_actions(active);
      if modm=-1 then report_log('Group '+chr(resi+64)+' Moved Backwards!');
      if modm=0 then report_log('Group '+chr(resi+64)+' Moved Sideways!');
      if modm=1 then report_log('Group '+chr(resi+64)+' Moved Forwards!');
      end;
end;
end;

procedure do_smoke(locy:byte);
var chx,chy:char;
begin
if player.amounts[active,3]<1 then parser(4,'You must have atleast ONE wizard to cast the Spell!')
 else if action_play(3) then parser(4,'Wizards have already played an action!')
 else begin
  parser(2,'Which Player do you want to Place the Smoke on? (1-4,0): ');
  onek(chx,'01234');
  if chx<>'0' then begin
   parser(2,'Which Group do you want to Place the Smoke on? (A-E,0): ');
   onek(chy,'0ABCDE');
   if chy<>'0' then
     if player.smoked[ord(chx)-48,ord(chy)-64]>0 then parser(8,'Already been Smoked!')
      else begin
      player.cards_held[active,locy].idnum:=0;
      display_cards;
      player.smoked[ord(chx)-48,ord(chy)-64]:=1;
      do_smokes(ord(chx)-48);
      action_played[3]:=1;
      do_actions(active);
      report_log('Placed Smoke on '+player.names[ord(chx)-48]+' Group '+chy);
    end;
  end;
end;
end;

procedure do_reinforcements(locx:byte);
var chy:char; bonus,temp:byte;
begin
temp:=player.cards_held[active,locx].special_num;
case temp of
  1: bonus:=random(6)+1;
  2: bonus:=random(6)+1;
  3: bonus:=random(3)+1;
  4: bonus:=random(3)+1;
  5: bonus:=random(2)+1;
end;
if action_play(temp) then parser(4,grp_name[temp]+' Have already played an Action this Turn!')
 else if player.amounts[active,temp]=0 then parser(4,grp_name[temp]+' have Zero Men -- No Reinforcements Allowed!')
 else begin
   parser(4,grp_name[temp]+' Received '+cstr(bonus)+' Units!');
   player.amounts[active,temp]:=player.amounts[active,temp]+bonus;
   player.cards_held[active,locx].idnum:=0;
   action_played[temp]:=1;
   do_amounts(active);
   do_actions(active);
   display_cards;
   report_log('Placed Reinforcements on his/her '+grp_name[temp]+' Received '+cstr(bonus));
  end;
end;

procedure do_hero(loct:byte);
var fck:char; kills,dews,massa:byte;
begin
kills:=0;
if action_play(4) then parser(4,'Your Knights Have Already Played an Action!')
 else if player.amounts[active,4]<1 then parser(8,'You don''t have Any Knights to become Heroes!')
 else begin
  parser(2,'Which Opponent will You attack with your Heroes? (1234,0): ');
  onek(fck,'01234');
  if (fck<>'0') or (player.amounts[ord(fck)-48,5]>0) then begin
   for dews:=1 to player.amounts[ord(fck)-48,5] do
    if player.amounts[active,4]*10>random(105)+1 then inc(kills);
   massa:=ord(fck)-48;
   parser(3,'You have Killed '+cstr(kills)+' of '+player.names[massa]+'''s Dragons!');
   action_played[4]:=1;
   player.cards_held[active,loct].idnum:=0;
   display_cards;
   if player.amounts[massa,5]<kills then kills:=player.amounts[massa,5];
   player.amounts[massa,5]:=player.amounts[massa,5]-kills;
   report_log('Used a HERO card on '+player.names[massa]+' and Killed '+cstr(kills)+' Dragons!');
   if player.amounts[massa,5]<1 then begin
     player.terrains[massa,5]:=0;
     player.ranges[massa,5]:=0;
     player.smoked[massa,5]:=0;
   end;
   do_amounts(massa);
   do_actions(active);
  end;
end;
end;

procedure do_earthquake(locx:byte);
var chj:char; kills,duez,dz2,massa:byte;
    kill_chance:array[1..4] of byte;
begin
kill_chance[1]:=75;
kill_chance[2]:=75;
kill_chance[3]:=65;
kill_chance[4]:=55;
if action_play(3) then parser(6,'Wizards have already played an Action!')
 else if player.amounts[active,3]<5 then parser(6,'FIVE (5) Wizards are Needed to Cast the Spell!')
  else begin
   parser(2,'Which Player''s Army Will Get the Earthquake? (0,1234): ');
   onek(chj,'01234');
   if chj<>'0' then
    if player.races[ord(chj)-48]=3 then parser(8,'Dwarves are Immune to Earthquakes!')
    else begin
    for duez:=1 to 4 do begin
     massa:=ord(chj)-48;
     kills:=0;
     if (player.terrains[massa,duez]=4) or (player.terrains[massa,duez]=5)
      then if player.amounts[massa,duez]>0 then begin
        for dz2:=1 to player.amounts[massa,duez] do
         if (random(100)<kill_chance[duez]) then inc(kills);
         parser(4,'You have managed to kill '+cstr(kills)+' '+grp_name[duez]+'!');
         report_log('Against '+player.names[massa]);
         report_log('Killed '+cstr(kills)+' '+grp_name[duez]+' with an Earthquake!');
         player.amounts[massa,duez]:=player.amounts[massa,duez]-kills;
         dec(player.terrains[massa,duez]);
         if player.amounts[massa,duez]<1 then begin
            player.terrains[massa,duez]:=0;
            player.ranges[massa,duez]:=0;
            player.smoked[massa,duez]:=0;
         end;
         action_played[3]:=1;
      end;
     end;
     player.cards_held[active,locx].idnum:=0;
     do_amounts(massa);
     do_terrains(massa);
     do_ranges(massa);
   end;
  end;
display_cards;
do_actions(active);
end;

procedure tree_burn(locx:byte);
var chj:char; kills,duez,dz2:byte; massa:byte;
    kill_chance:array[1..5] of byte;
begin
kill_chance[1]:=75; kill_chance[2]:=75; kill_chance[3]:=65; kill_chance[4]:=55;
kill_chance[5]:=15;
if action_play(2) then parser(6,'Footmen have already played an Action!')
 else if player.amounts[active,2]<12 then parser(6,'TWELVE (12) Footmen are Needed to Start a Forestfire!')
  else begin
   parser(2,'Which Player''s Army Will Start a Forest Fire? (0,1234): ');
   onek(chj,'01234');
   if chj<>'0' then begin
    for duez:=1 to 5 do
     begin
     kills:=0;
     massa:=ord(chj)-48;
     if (player.terrains[massa,duez]=1)
      then if player.amounts[massa,duez]>0 then begin
        for dz2:=1 to player.amounts[massa,duez] do
         if (random(100)<kill_chance[duez]) then inc(kills);
         parser(4,'You have managed to kill '+cstr(kills)+' '+grp_name[duez]+'!');
         report_log('Killed '+cstr(kills)+' '+grp_name[duez]+' with a Forest Fire!');
         report_log('Against '+player.names[massa]);
         player.amounts[massa,duez]:=player.amounts[massa,duez]-kills;
         dec(player.terrains[massa,duez]);
         if player.amounts[massa,duez]<1 then begin
            player.terrains[massa,duez]:=0;
            player.ranges[massa,duez]:=0;
            player.smoked[massa,duez]:=0;
         end;
         action_played[2]:=1;
        end;
     end;
     player.cards_held[active,locx].idnum:=0;
     do_amounts(massa);
     do_terrains(massa);
     do_ranges(massa);
   end;
  end;
do_actions(active);
display_cards;
end;

function determine_group(action:helper):char;
var crapper:char;
begin
parser(2,'Which Group is going to '+action+' the firing? (A-E): ');
onek(crapper,'ABCDE');
determine_group:=crapper;
end;

function which_player:char;
var q:char;
begin
repeat
parser(2,'Which Player is going to RECEIVE the firing? (1..4): ');
onek(q,'1234');
until (active<>ord(q)-48);
which_player:=q;
end;

function determine_range(home,plnm,engrp:byte):byte;
var holde:byte;
begin
determine_range:=player.ranges[active,home]+player.ranges[plnm,engrp];
end;

function det_max_str(grty,range:byte):longint;
var shit:longint;
begin
shit:=round(player.amounts[active,grty]*fpower[grty,range]);
if (player.terrains[active,grty]>99) and (shit>0) then shit:=shit div 2;
if shit<1 then shit:=1;
det_max_str:=shit;
end;


function get_defender(att,pln,grp:byte):longint;
var t:longint;
begin
case player.terrains[pln,grp] of
    0,100,200 : t:=0;
    1,101,201 : t:=2;
    2,102,202 : t:=1;
    3,103,203 : t:=1;
    4,104,204 : t:=3;
    5,105,205 : t:=4;
    6,106,206 : t:=1;
end;
if player.terrains[pln,grp]>99 then t:=t-1;
if player.terrains[pln,grp]>199 then t:=t-1;
if player.smoked[pln,grp]>0 then t:=t+1;
if player.smoked[active,att]>0 then t:=t+1;
if player.terrains[active,att]=3 then t:=t-1;
if player.terrains[active,att]=6 then t:=t+1;
t:=t+def_mod[grp];
t:=t*10;
get_defender:=t;
end;


procedure reports;
var temp:char; homer,gomer:helper; crapper:byte; x,y:integer;
begin
repeat
parser(2,'Reports: (M)essage Send (Q)uit  (R)ead All (S)can: ');
onek(temp,'MQRS');
case temp of
  'M' : if message<3 then begin parser(4,'Input Message, up to 70 Characters, LIMIT 2 Messages Per play ');
        parser(2,'-->'); inc(message);
        input(homer,70);
        report_log(homer); parser(4,'Message Posted....');
        end else parser(4,'Too Many messages Posted today...');
  'R' : begin
        cls;
        for crapper:=1 to 50 do begin
          if data_arr[crapper].rep<>'No Message!'
            then talknl(0,cstr(crapper)+'. '+data_arr[crapper].rep);
          if crapper=25 then pausescr;
        end; pausescr;
        cls;
        printfile('MAIN.ANS');
        draw_all;
        display_cards;
        do_actions(active);
        end;
  'S' : begin
        parser(2,'Starting at What Point (1..50): ');
        input(homer,2);
        parser(2,'Ending at What Point (1..50): ');
        input(gomer,2);
        x:=value(homer);
        y:=value(gomer);
        if (x>50) or (y>50) or (y<1) or (x<1) or (x>y) then parser(8,'Invalid Input!')
        else for crapper:=x to y do
        parser(0,cstr(crapper)+'.  '+data_arr[crapper].rep);
        end;
end;
until temp='Q'
end;

procedure do_fire;
var choices:array [1..6] of byte; playnumb,targ,temp,group:char; cardpow,ctx:byte;
range:byte; max_str,defense:longint;
begin
for ctx:=1 to 6 do choices[ctx]:=0;
repeat
cardpow:=0;
for ctx:= 1 to 6 do cardpow:=cardpow+choices[ctx];
parser(2,'Select fire cards, Str. in Cards: '+cstr(cardpow)+' (A-F,(0 to End,?): ');
onek(temp,'ABCDEF?0');
if temp='?' then begin
   group:=determine_group('Do');
   playnumb:=which_player;
   targ:=determine_group('Receive');
   range:=determine_range(ord(group)-64,ord(playnumb)-48,ord(targ)-64);
   max_str:=det_max_str(ord(group)-64,range);
   parser(5,'You can amass a strength of : '+cstr(max_str)+' From that Group!');
end else
 if temp in ['A'..'F'] then
   if player.cards_held[active,ord(temp)-64].idnum in [81..141] then
     if choices[ord(temp)-64]<>0 then parser(7,'You have Already Selected that Card!')
      else choices[ord(temp)-64]:=player.cards_held[active,ord(temp)-64].special_num
   else parser(6,'That is NOT a fire card.... try again...');
until temp='0';
if cardpow=0 then parser(4,'No Actions Played!')
 else
  begin
   group:=determine_group('Do');
   if action_play(ord(group)-64) then parser(8,'Already Played an Action!')
    else begin
     playnumb:=which_player;
     targ:=determine_group('Receive');
     range:=determine_range(ord(group)-64,ord(playnumb)-48,ord(targ)-64);
     max_str:=det_max_str(ord(group)-64,range);
     if cardpow>max_str+1 then parser(4,'Too many fire Cards Selected, try again!')
      else begin
       defense:=get_defender(ord(group)-64,ord(playnumb)-48,ord(targ)-64);
       cardpow:=cardpow*8;
       defense:=cardpow-defense;
       if defense<1 then defense:=1; range:=0;
       if defense>99 then defense:=99;
       parser(7,'You have a '+cstr(defense)+' Chance of Killing Each Enemy!');
       parser(2,'Continue with attack? (Y/N): ');
       if ynq then begin
       for ctx:=1 to 6 do
        if choices[ctx]>0 then player.cards_held[active,ctx].idnum:=0;
       for ctx:=1 to player.amounts[ord(playnumb)-48,ord(targ)-64] do
        if random(100)<defense+1 then inc(range);
       parser(7,'You have Killed '+cstr(range)+' '+grp_name[ord(targ)-64]);
       report_log('Against Player '+player.names[ord(playnumb)-48]+'''s '+grp_name[ord(targ)-64]);
       report_log(player.names[active]+' Fired and killed '+cstr(range));
       display_cards;
       action_played[ord(group)-64]:=1;
       do_actions(active);
  player.amounts[ord(playnumb)-48,ord(targ)-64]:=player.amounts[ord(playnumb)-48,ord(targ)-64]-range;
       do_amounts(ord(playnumb)-48);
       if player.amounts[ord(playnumb)-48,ord(targ)-64]<1 then begin
          player.terrains[ord(playnumb)-48,ord(targ)-64]:=0;
          player.ranges[ord(playnumb)-48,ord(targ)-64]:=0;
          do_terrains(ord(playnumb)-48);
          do_ranges(ord(playnumb)-48);
          player.smoked[ord(playnumb)-48,ord(targ)-64]:=0;
          do_smokes(ord(playnumb)-48);
       end;
       end;
     end;
  end;
end;
end;


procedure play_card;
var chk:char; result:byte;
begin
parser(2,'Which Card do you Want to Play? (A-F,0 for None): ');
onek(chk,'ABCDEF0');
result:=ord(chk)-64;
if chk<>'0' then
 if player.cards_held[active,result].idnum<1 then
    parser(8,'Invalid Card to Play!!!!!') else
      case player.cards_held[active,result].idnum of
        1..49 : do_terrain(result);
       50..80 : do_move(result);
       81..140 : parser(4,'Use the "F" option to use this!');
      141..172 : do_Reinforcements(result);
      173..178 : do_smoke(result);
      179..180 : do_earthquake(result);
      181..183 : tree_burn(result);
           184 : do_hero(result);
      end;
end;

procedure begin_play;
var chx:char;
begin
repeat
funnel:=false;
parser(2,'Choices: (CDEFPR?): ');
onek(chx,'CDEFPR?');
case chx of
  'C' : clear_terrain;
  'D' : discard;
  'E' : begin parser(2,'Are you sure? (Y/N): ');
        funnel:=ynq; end;
  'F' : do_fire;
  'P' : play_card;
  'R' : reports;
  '?' : help_me;
end;
until funnel;
end;

procedure save_game;
var shitfile: file of game; cg:byte;
begin
assign(shitfile,'GAME'+player.game_let+'.SAV');
rewrite(shitfile);
write(shitfile,player);
close(shitfile);
assign(data_file,'MESS'+player.game_let+'.SAV');
rewrite(data_file);
for cg:=1 to 50 do write(data_file,data_arr[cg]);
close(data_file);
end;

procedure load_data;
var cg:byte;
begin
assign(data_file,'MESS'+player.game_let+'.SAV');
{$I-} reset(data_file); {$I+}
IF IOResult<>0 then
  for cg:=1 to 50 do data_arr[cg].rep:='No Message!'
else begin
  for cg:=1 to 50 do read(data_file,data_arr[cg]);
  close(data_file);
end;
end;

procedure check_for_kill_all;
var sum,cntsum,cnt2:integer;
begin
sum:=0;
for cntsum:=1 to 4 do
 if cntsum<>active then
   for cnt2:=1 to 5 do
     sum:=sum+player.amounts[cntsum,cnt2];
if sum=0 then winner else
 for cntsum:=1 to 5 do
  if (player.ranges[active,cntsum]=5) and (player.terrains[active,cntsum]<100) then winner;
end;

procedure remover;
var ct,scount:byte; gamef:file of gamer; gamv:array [1..26] of gamer;
begin
assign(gamef,'GAMES.PIT');
reset(gamef);
for ct:=1 to 26 do read(gamef,gamv[ct]);
close(gamef);
scount:=ord(player.game_let)-64;
gamv[scount].name[active]:='Dead Player';
rewrite(gamef);
for ct:=1 to 26 do write(gamef,gamv[ct]);
close(gamef);
end;

procedure check_for_all_gone;
var sum,ct:byte;
begin
sum:=0;
for ct:=1 to 5 do sum:=sum+player.amounts[active,ct];
if sum=0 then begin remover; parser(8,'You have been Destroyed!'); return; end;
end;

begin
message:=1;
grp_name[1]:='Archers';
grp_name[2]:='Footmen';
grp_name[3]:='Wizards';
grp_name[4]:='Knights';
grp_name[5]:='Dragons';
fpower[1,0]:=1; fpower[1,1]:=1.5; fpower[1,2]:=2; fpower[1,3]:=2; fpower[1,4]:=1; fpower[1,5]:=0.5;
fpower[2,0]:=0.5; fpower[2,1]:=1; fpower[2,2]:=1.25;fpower[2,3]:=1.75; fpower[2,4]:=2.25; fpower[2,5]:=3;
fpower[3,0]:=1;   fpower[3,1]:=2; fpower[3,2]:=3; fpower[3,3]:=3; fpower[3,4]:=1; fpower[3,5]:=0.5;
fpower[4,0]:=0.75;fpower[4,1]:=1; fpower[4,2]:=2; fpower[4,3]:=3; fpower[4,4]:=4; fpower[4,5]:=6;
fpower[5,0]:=5;   fpower[5,1]:=6; fpower[5,2]:=7; fpower[5,3]:=8; fpower[5,4]:=9; fpower[5,5]:=10;
def_mod[1]:=0; def_mod[2]:=1; def_mod[3]:=2; def_mod[4]:=4; def_mod[5]:=6;
cls;
printfile('MAIN.ANS');
load_data;
determine_active;
draw_new_cards;
draw_all;
display_cards;
check_for_all_gone;
report_log(player.names[active]+' is Playing!');
begin_play;
save_game;
check_for_kill_all;
end;
end.
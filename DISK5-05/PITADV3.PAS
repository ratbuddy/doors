{$G1}{$P1}
program on_liner;
{$I RECORDS.H}
{$I COMMON.PAS}

var player: character;
meanies:array [1..4] of monster_set;
dung_room : array [0..75] of dun_room;
potion_array:array [1..10] of items;
stat_name: array[1..14] of string[18];
act_stats:bogus;
feather,bridger,exitter,adoner:boolean;
room_num,com_done:byte;
town_stuff : town_rec;
dungeon_stuff : dun_rec;
weapon:array [1..10] of items;
armor:array [1..5] of items;
magic : array [1..25] of items;
ring : array [1..20] of items;
monster_array:array [1..77] of monsters; {monster 50 is a no monster,69-71 players!}
map : array [-5..85,-5..28] of char;
auto_map : array [0..79,0..24] of char;
cond_name:array [1..5] of string[15];
roundcnt,dball,com_num,active,campr,modder,foodmv,per_at : integer;
dam_tab:array [1..4] of integer;
type_mon,how_many:combat_init;


procedure sub_moves(subb : integer);
begin
player.total_moves:=player.total_moves+subb;
foodmv:=foodmv+subb;
end;

procedure active_change(f:byte);
var gg:byte;
begin
if player.status[f]=8 then say_saying('Invalid Active Player') else begin
for gg:=1 to 3 do
 if player.status[gg]=7 then player.status[gg]:=4;
 if player.status[f]=4 then player.status[f]:=7;
active:=f;
end;
end;

procedure hack_stats(var a,b:bogus);
var x,y,z : byte;
begin
for x:=1 to 3 do begin
  for y:=1 to 7 do
   a[x,y]:=b[x,y];
   for z:=12 to 16 do
   a[x,z]:=b[x,z];
end;
end;

procedure return_stats;
begin
hack_stats(player.stats,act_stats);
end;

procedure orig_stats;
begin
hack_stats(act_stats,player.stats);
end;

procedure statements;
var garbage : str;
begin
say_saying('Reminders for Next Time? (25 chars)?: ');
input(garbage,25);
player.memory:=garbage;
end;

procedure save_char(test : byte);
var saver: file of character;
filename:string[8];
temper:bogus;
begin
hack_stats(temper,player.stats);
return_stats;
 filename:='        ';
 str(usernum,filename);
 filename:=filename+'.sav';
 assign(saver,filename);
 rewrite(saver);
 write(saver,player);
 close(saver);
hack_stats(player.stats,temper);
end;

procedure display_char(q:byte);
begin
goto_ansixy(13+q,8); talk(4,player.name[q]);
goto_ansixy(13+q,25); talk(4,cstr(player.stats[q,10])+'/'+cstr(player.stats[q,11])+'  ');
goto_ansixy(13+q,33); talk(4,cstr(player.stats[q,8])+'/'+cstr(player.stats[q,9])+'  ');
goto_ansixy(13+q,43); talk(4,cstr(player.stats[q,14])+'  ');
goto_ansixy(13+q,48); talk(4,cstr(player.food[q])+'  ');
goto_ansixy(13+q,52); talk(player.status[q],cond_name[player.status[q]-3]+'   ');
end;


procedure check_player_death;
var temr,x : integer;
begin
temr:=0;
for x:=1 to 3 do
if (player.stats[x,11]<1) and (player.status[x]<>8) then begin
 player.status[x]:=8;
 say_saying(player.name[x]+' Has Died.'); pausescr;
end;
for x:=1 to 3 do if player.status[x]=8 then inc(temr,1);
if temr=3 then begin say_saying('All Characters Have Died!'); pausescr; return; end;
end;

procedure determine_armorclass;
var y,x:integer;
begin
for x:=1 to 3 do begin
with player do begin
y:=modifier(stats[x,4]);
stats[x,14]:=equiparmor[x].protect+equiparmor[x].magical+y;
if (equipring[x].idnum>16) and (equipring[x].idnum<22) then
stats[x,14]:=stats[x,14]+equipring[x].magical;
if stats[x,14]<0 then stats[x,14]:=0;
end; end; end;

{$I CONVERSE}

procedure check_moves;
var t:char;
begin
say_saying('Are you Sure you Want to Quit? (Y/N): ');
onek(t,'NY');
if t='Y' then begin
 statements; save_char(1); table_char; return; end;
end;

{$I BANK.PAS}

procedure display_monsters(cnt:byte);
var tempstr:string[20];
begin
tempstr:=monster_array[type_mon[cnt]].name;
goto_ansixy(4+cnt,7);
talk(3,'GROUP #'+cstr(cnt)+'  ('+cstr(meanies[cnt].mel_amnt)+') '+tempstr);
goto_ansixy(4+cnt,43);
talknl(4,'('+cstr(meanies[cnt].mis_amnt)+') '+tempstr);
end;

{$I COMBATC.PAS}

procedure combat(hg:byte);
begin
roundcnt:=0;
init_combat; com_done:=0;
repeat
inc(roundcnt,1);
if fire_1st then begin
player_attack; monster_attack end else begin monster_attack; player_attack; end;
until com_done>0;
if com_done=2 then housekeeper(hg);
end;

procedure main_dun;

procedure show_location;
var r,s,crdx,crdy,x3,y3,xer,yer : integer;
begin
with player do begin
if dungeon then begin crdx:=xactual; crdy:=yactual; end
  else begin crdx:=outxact; crdy:=outyact; end;
if crdx > 78 then
  if dungeon then xactual:=1 else outxact:=1;
if crdy > 23 then if dungeon then yactual:=1 else outyact:=1;
if crdx < 1 then if dungeon then xactual:=78 else outxact:=78;
if crdy < 1 then if dungeon then yactual:=23 else outyact:=23;
if dungeon then begin crdx:=xactual; crdy:=yactual; end
  else begin crdx:=outxact; crdy:=outyact; end;
end;
if player.door_exemps[255]=0 then
for y3:=-3 to 3 do begin
goto_ansixy(6+y3,13);
for x3:=-5 to 5 do begin
 r:=crdx+x3; s:=crdy+y3;
 case map[r,s] of
  '∞' : begin ansic(3); prompt(map[r,s]); end;
  'ù' : begin ansic(7); prompt(map[r,s]); end;
  'B','C','H','I','Ô','W','w','!' : begin ansic(8); prompt(map[r,s]); end;
  'å','P','G','#' : prompt(' ');
  '±' : begin ansic(4); prompt(map[r,s]); end;
  '≤' : begin ansic(0); prompt(map[r,s]); end;
  else begin ansic(5); prompt(map[r,s]); end;
 end;
end;
end;
ansic(0);
if player.door_exemps[255]=1 then
for y3:=-3 to 3 do begin
goto_ansixy(6+y3,13); s:=crdy+y3;
for x3:=-5 to 5 do begin
 r:=crdx+x3;
if map[r,s] in ['#','å','P','G' ] then prompt(' ') else prompt(map[r,s]);
end;
end;
goto_ansixy(6,18); ansic(4); prompt('Í');
for x3:=-1 to 1 do
for y3:= -1 to 1 do
if not(map[crdx+x3,crdy+y3] in ['#','å','P','G']) then
auto_map[crdx+x3,crdy+y3]:=map[crdx+x3,crdy+y3];
end;

procedure display_LOX;
begin
ansic(5);
goto_ansixy(14,69); if player.dungeon then prompt(cstr(player.xactual)+'  ')
else prompt(cstr(player.outxact)+'  ');
end;

procedure display_LOY;
begin
ansic(5);
goto_ansixy(15,69); if player.dungeon then prompt(cstr(player.yactual)+'  ')
else prompt(cstr(player.outyact)+'  ');
end;

procedure main_grid;
begin
cls; dialcnt:=18;
if player.door_exemps[254]=0 then
printfile('MAINDUN.ANS');
end;

procedure display_all;
var g:byte;
begin
for g:=1 to 3 do display_char(g);
display_lox;
display_loy;
if player.dungeon then begin goto_ansixy(11,36); talk(3,dungeon_stuff.dname);
end; end;

procedure encounter;
var yy : file of monster_table;
sholder : monster_table; x,y:byte;
begin
y:=0;
case player.stats[active,12] of
  1,2 : y:=0;
  3..20: y:=1;
  end;
if y > 1 then y:=1 else if y <0 then y:=0;
assign(yy,'ENCOUNTS.PIT'); reset(yy);
x:=random(50)+(y*50);
seek(yy,x); read(yy,sholder); close(yy);
type_mon:=sholder.typs;
how_many:=sholder.howm;
combat(2);
end;

procedure restore;
begin
dialcnt:=18; main_grid; display_all; show_location;
end;

function do_a_room(xer,yer : integer) : BOOLEAN;
begin
determin_combat(xer,yer);
if player.door_exemps[dung_room[room_num].toggler] = 1 then begin do_a_room:=true;
say_saying('This Room is Empty Because of a Previous Battle!');
housekeeper(3); end else
begin
if not (dung_room[room_num].scroll) then say_saying(dung_room[room_num].scrollsay)
 else begin pre_battle(xer,yer); restore; end;
type_mon:=dung_room[room_num].whatkind;
how_many:=dung_room[room_num].howmany;
pausescr;
combat(1);
 if com_done=2 then begin
  if dung_room[room_num].special>0 then whats_so_special(dung_room[room_num].special);
  player.door_exemps[dung_room[room_num].toggler]:=1;   {HE WON THE BATTLE}
  restore; do_a_room:=true; {MOVE THROUGH IT!!}
  end else begin restore; do_a_room:=false; end;
 end;
end;

procedure do_a_wandering;
var choicer : char; tem:boolean;
begin
case (random(6)) of
 1 : begin tem:=do_other_wandering(0,0,0); if tem then begin combat(2); restore; end; end;
 0,2,3,4,5 : begin
 say_saying('An Encounter! Hit ''A'' to begin the Attack!: ');
 onek(choicer,'A'); encounter; restore;
 end;
end;
end;

procedure check_food_supply;
var hh:byte;
begin
for hh:=1 to 3 do begin
if (player.food[hh]>0) and (player.status[hh]<>8) then binc(player.food[hh],-1);
if player.food[hh]<1 then begin player.food[hh]:=0;
say_saying(player.name[hh]+' Is Hungry and Sick!'); player.status[hh]:=5; end;
end;
say_saying('1 Food Ration Consumed!');
end;

procedure check_for_wandering;
begin
if random(125)=25 then do_a_wandering;
if foodmv > 80 then begin check_food_supply; display_all; foodmv:=0; end;
end;

function newmove(x1,y1 : integer) : boolean;
var test:boolean; gh : byte;
begin
newmove:=false;
if player.dungeon then
  case map[(player.xactual)+x1,(player.yactual)+y1] of
 ' ','≤','±' : newmove:=true;
 'S' : begin newmove:=true; exitter:=true; player.outdoor:=true; player.dungeon:=false; end;
 'D' : begin test:=do_a_room(x1,y1); newmove:=test; end;
 'W','w' : begin newmove:=true; test:=do_a_stairs(x1,y1); if test then get_screen; end;
 '∞' : begin newmove:=true;  sub_moves(1); end;
  'ù' : begin newmove:=true; sub_moves(1); end;
  '‚' : begin newmove:=true; do_outsign(x1,y1); end;
  '!' : begin newmove:=true; test:=o_player(1,x1,y1); if test then begin combat(2); restore;
          if com_done=2 then test:=o_player(2,x1,y1); end; end;
  'å' : begin guards; combat(2); restore; if com_done=2 then begin newmove:=true;
        map[player.xactual+x1,player.yactual+y1]:=' '; end; end;
  'P' : begin newmove:=true; test:=do_other_wandering(100,x1,y1); end;
  '®' : begin newmove:=true; test:=do_a_riddle(false,x1,y1); end;
  'R' : begin test:=do_a_riddle(true,x1,y1); newmove:=test; restore; end;
  'G' : begin newmove:=true; test:=do_other_wandering(50,x1,y1); end;
  'Ë' : test:=do_other_wandering(25,x1,y1);
  'Á' : begin newmove:=true; test:=do_other_wandering(10,x1,y1); end;
  '#' : test:=do_other_wandering(35,x1,y1);
  end;
if player.outdoor then
   case map[(player.outxact)+x1,(player.outyact)+y1] of
  ' ','π'..'º','»'..'Œ':newmove:=true;
  'ù' : begin newmove:=true; sub_moves(4); end;
  '∞' : begin newmove:=true; if player.equipring[active].idnum<> 16 then sub_moves(24); end;
  '±' : begin newmove:=true; foodmv:=foodmv+2; end;
  'ü' : begin magic_scool; restore; end;
  'H' : begin newmove:=true; gh:=sage_hut;
        if gh=1 then restore;
        if gh=2 then begin newmove:=false; load_dungeon(0,0); enter_dun_this_way(0,0); end; end;
  'T' : begin cls; do_temple; restore; newmove:=true; end;
  'I' : begin enter_inn; newmove:=true; end;
  'C' : begin newmove:=true; enter_city; end;
  'Ô' : begin newmove:=true; load_dungeon(x1,y1); enter_dungeon_check(gh);
        if gh=2 then begin newmove:=false; enter_dun_This_way(x1,y1); end;
        end;
  'J' : begin newmove:=true; jester_camp; end;
  '‚' : begin newmove:=true; do_outsign(x1,y1); end;
  '!' : begin newmove:=true; test:=o_player(1,x1,y1); if test then begin combat(2); restore;
        if com_done=2 then test:=o_player(2,x1,y1); end; end;
  'F' : do_a_ferry;
  'û' : begin newmove:=true; trainer; end;
'B' : begin
if not bridger then do_a_bridge(gh);
if gh=2 then begin combat(2);
if com_done=2 then begin bridger:=true; newmove:=true; end else newmove:=false;
 restore; end;
if gh<2 then newmove:=false;
if bridger then newmove:=true;
end;
  end;
sub_moves(1);
end;

procedure check_movv(var crrd : byte; agan:byte;var mapch:byte; g,h,j: integer);
var legit : boolean;
begin
if crrd = agan then begin mapch:=mapch+g; get_screen; legit:=true; end else
legit:=newmove(h,j);
if legit then begin
crrd:=crrd+g;
display_lox; display_loy;
show_location;
end else say_saying('Invalid Move!');
end;

var choice: char; tt:byte;
 bh : boolean;
begin
main_grid; if player.dungeon then begin
load_dungeon(0,0); load_rooms; end; display_all; get_screen;
show_location; exitter:=false;
repeat
goto_ansixy(16,69);
onek(choice,'!@#8462ACDEFHIQRSTUVXZ?*');
case choice of
 '8' :if player.dungeon then check_movv(player.yactual,1,player.ymap,-1,0,-1)
   else check_movv(player.outyact,1,player.outymap,-1,0,-1);
 '4' :if player.dungeon then check_movv(player.xactual,1,player.xmap,-1,-1,0)
   else check_movv(player.outxact,1,player.outxmap,-1,-1,0);
 '6' :if player.dungeon then check_movv(player.xactual,78,player.xmap,1,1,0)
  else check_movv(player.outxact,78,player.outxmap,1,1,0);
 '2' :if player.dungeon then check_movv(player.yactual,23,player.ymap,1,0,1)
  else check_movv(player.outyact,23,player.outymap,1,0,1);
 'A' :begin auto_map_view; cls; restore; end;
 'C' :begin tt:=cast_spell;
 case tt of
  1 : show_location;
  2 : begin get_screen; show_location; end;
  end;
 end;
 'D' :detect_trap;
 'E' :begin bh:=camper; if bh then do_a_wandering; display_all; campr:=campr+1; end;
 'F' :fast_mode;
 'H' :if player.outdoor then begin hunter; display_char(active); end
      else say_saying('Hunting Not Allowed in Dungeons!');
 'I' :inspect;
 'Q' :check_moves;
 'U' :begin use_which_potion; display_char(active); end;
 'R' :begin bh:=use_ring; if bh then show_location; end;
 'S' :begin save_char(0); say_saying('Party Saved'); end;
 'T' :exchange;
 'V' :begin view_act_player; restore; end;
 'X' :x_ray;
 'Z' :destroy_char;
 '?' :begin player.door_exemps[254]:=0; restore; end;
 '!' :begin active_change(1); display_all; end;
 '@' :begin active_change(2); display_all; end;
 '#' :begin active_change(3); display_all; end;
 '*' :begin docs; restore; end;
end;
check_for_wandering;
until exitter;
end;

procedure do_main_area_work;
var infinite:boolean; var ginput:char; yt:byte;
begin
infinite:=false;
repeat
say_saying(player.name[active]+' Choice (123BCDEFGLMPQSUVYZ?) -->');
onek(ginput,'BCDEFGLMQPSUVYZ?123');
case ginput of
'1' : active_change(1);
'2' : active_change(2);
'3' : active_change(3);
'B' : if town_stuff.port then infinite:=boating else say_saying('This town is not a port!');
'C'  :conversationz(100);
'D'  :docs;
'E'  :exchange;
'F'  :fast_mode;
'G'  :begin general_store; read_weapons; end;
'L' :begin infinite:=true; player.city:=false; player.outdoor:=true; end;
'M'  :yt:=cast_spell;
'P'  :use_which_potion;
'Q'  :check_moves;
'S'  :begin say_saying('Party Saved'); save_char(0); end;
'V'  :begin view_act_player; welcome; end;
'Y'  :guardian_angel;
'Z'  :destroy_char;
'U'  :if town_stuff.chars then create_char(0) else say_saying('Not available in this town!');
'?'  :welcome;
end;
until infinite;
end;

procedure do_city;
begin
get_city_info;
welcome;
Do_Main_Area_work;
end;

procedure try_to_read_char;
var g1:file of character; ttt:boolean;
    filename:string[8];
begin
filename:='        ';
str(usernum,filename);
assign(g1,filename+'.sav');
{$I-} reset(g1); {$I+}
if IOresult=0 then begin read(g1,player); close(g1);
 talknl(5,'Your Reminders from Last Time are ...');
 talknl(4,player.memory); nl; pausescr; read_weapons; ttt:=o_player(3,1,1);
end else begin intro; read_weapons; create_char(1); end;
determine_armorclass; orig_stats;
for dialcnt:=1 to 3 do player.stats[dialcnt,16]:=0;
end;

begin
adoner:=false; foodmv:=1;
printfile('TITLER2.ANS'); pausescr; printfile('TITLER1.ANS'); pausescr;
modder:=0; maz:=1; bridger:=false; feather:=false;
randomize; campr:=0;
iport;
init_names; try_to_read_char; dialcnt:=18;
repeat if (player.dungeon) OR (player.outdoor) then main_dun
else do_city;
until adoner;
end.
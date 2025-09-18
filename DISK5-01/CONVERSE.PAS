overlay procedure intro;
var intro_file : file of char;
    ytemp,oneq : char;
begin
assign(intro_file,'INTRO.ANS');
reset(intro_file); ytemp:='[';
while ytemp <> '*' do begin
  read(intro_file,ytemp);
  if ytemp <> '*' then prompt(ytemp);
end;
close(intro_file); pausescr;
talk(5,'Do you Still Wish to Play This Adventure? (Y/N)'); ansic(3);
onek(oneq,'NY'); if oneq='N' then halt else cls;
end;


overlay procedure conversationz;
var conver_file : file of conversation;
    person_chat : conversation; ch1, ch2 : char; dummy,choicint:integer;
    all_done    : boolean; chwrd:string[2];
    inputter    : str; inputteri : integer;
procedure display_people;
var xxx : file of char; temps: char; filename:string[12];
begin
filename:='            '; filename:='CONVER'+chr(town_stuff.city_num+48)+'.LST';
assign(xxx,filename); reset(xxx); temps:='x'; ansic(0);
while temps <> '*' do begin
   read(xxx,temps);
   if temps <> '*' then prompt(temps);
end;
close(xxx);
end;

procedure dencrypt;
var a,b,c :integer;
begin
for a:=1 to 3 do
 for b:=1 to length(person_chat.keys[a]) do
  person_chat.keys[a][b]:=chr(ord(person_chat.keys[a][b])-b);
for a:=1 to 3 do
 for c:=1 to 3 do
  for b:=1 to length(person_chat.resp_keys[a][c]) do
   person_chat.resp_keys[a][c][b]:=chr(ord(person_chat.resp_keys[a][c][b])-b);
end;

procedure load_person(personn:integer);
var filename:string[12];
begin
filename:='            '; filename:='CONVER'+chr(town_stuff.city_num+48)+'.CON';
assign(conver_file,filename); reset(conver_file); seek(conver_file, personn-1);
read(conver_file,person_chat); close(conver_file);
dencrypt;
end;

procedure descrip;
begin
if dialcnt > 18 then clear_space;
say_saying('NAME --> '+person_chat.name+':');
say_saying('DESCRIPTION --> '+person_chat.descrip);
end;

procedure tellem(select : byte);
var bcb:byte;
begin
bcb:=1;
repeat
 say_saying(person_chat.resp_keys[select,bcb]);
 bcb:=bcb+1;
until (bcb=4) or (person_chat.resp_keys[select,bcb][1]='%');
player.exemptions[person_chat.toggles[select]]:=1;
end;

procedure give_doe;
var amnt:str; amnti : integer; txtt : byte;
begin
say_saying('You have '+cstrr(player.goldpieces,10)+' Gold Pieces');
say_saying('How Much do you give to the Beggar? -->');
ansic(4); input(amnt,4);
amnti:=value(amnt);
if amnti> player.goldpieces then begin
   say_saying('You will pay for your stupidity!  Teasing a Beggar!');
    if player.goldpieces > 0 then
      player.goldpieces:=player.goldpieces *0.5;
  end else begin
    player.goldpieces:=player.goldpieces-amnti;
    for txtt:=1 to 3 do
      if person_chat.keys[txtt]='GIVE' then begin tellem(txtt); txtt:=3; end;
 if (amnti> 100) and (amnti< 1001) then player.experience:=player.experience+(amnti div 2);
 if (amnti>1002) then player.equiparmor.magical:=player.equiparmor.magical+1;
  end;
end;

procedure inquiry;
var inq : str;
    txt : byte;
begin
say_saying('Inquiry -->');
ansic(3); input(inq,12);
if (inq='GIVE') and (person_chat.name='BEGGAR') then give_doe else
   for txt:=1 to 3 do
      if inq=person_chat.keys[txt] then begin tellem(txt); txt:=3; end
       else if txt=3 then say_saying(person_chat.dunno);
end;

procedure lets_talk(person_num : integer);
var ggg: char; fag: boolean;
begin
goto_ansixy(16,1); talknl(7,'Moves Remaining --> '+cstr(moves));
load_person(person_num);
descrip; fag:=false;
repeat sub_moves(1);  check_moves;
goto_ansixy(16,21); talknl(7,cstr(moves)+'  ');
say_saying('Choice (D)escribe, (G)reet, (I)nquire, (L)eave --> ');
ansic(4); onek(ggg,'DGIL');
  case ggg of
    'D' : descrip;
    'G' : say_saying(person_chat.greeter);
    'I' : inquiry;
    'L' : begin say_saying(person_chat.later); fag:=true; end;
  end;
until fag;
end;

procedure type_file;
var fileb: file of char; tempy : char;
begin
assign(fileb,'riddle7.qst');
reset(fileb);
while not EOF(fileb) do begin
 read(fileb,tempy);
 if tempy<> '$' then prompt(tempy) else prompt(player.name+' ');
end;
nl; nl; pausescr; pausescr;
end;

begin
if (town_stuff.city_num=7) and (player.door_exemps[102] < 100) then
  type_file else begin
cls; display_people; all_done:=false;
repeat
  say_saying('Choice (0 to Leave) --> ');
  input(inputter,2);
  choicint:=value(inputter);
   if choicint=0 then all_done:=true else
   begin
   if (choicint < 0) or (choicint > town_stuff.num_conv) then say_saying('INVALID INPUT!')
   else lets_talk(choicint);
   end;
until all_done;
cls;
end;
end;

overlay function boating : boolean;
var cost,mosh : real; enough : boolean;
    ab2,abc : char;

procedure go_bye_bye(f: real; g,h,i,j : integer);
begin
with player do begin
goldpieces:=goldpieces-f;
outxmap:=g; outxact:=i; outyact:=j;
outymap:=h; outdoor:=true; city:=false;
talknl(4,'Your journey is long and boring.....');
talknl(4,'Finally the ship drops you off outside your new location as......');
boating:=true;
pausescr;
sub_moves(moves+1);
end;
end;

begin
mosh:=50*town_stuff.price_mod; boating:=false;
cost:=mosh+random(25)-random(10)-modifier(player.stats[7]);
if cost< 10.0 then cost:=10.0;
if cost<player.goldpieces-1 then enough:=true else enough:=false;
if town_stuff.port = false then talknl(8,'This Town is Not A port --> no boating!')
  else
case town_stuff.city_num of
 1:  if player.door_exemps[22]<>1 then
     talknl(6,'Sorry, travel is very dangerous at the time! We fear to sail')
     else if not enough then talknl(3,'Sorry but you need '+cstrr(cost,10)+' to sail with us!')
     else begin
     talknl(4,'We Set sail to Torrents, tommorrow, wish to join us for a mere cost of ');
     talk(4,cstrr(cost,10)+' Gps, You have '+cstrr(player.goldpieces,10)+' (Y/N) --> '); ansic(3);
     onek(abc,'NY'); nl;
     if abc='N' then talknl(5,'Oh well, catchya soon....')
       else go_bye_bye(cost,5,4,51,11);
     end;
  3: if not enough then talknl(3,'Sorry but you need '+cstrr(cost,10)+' to sail with Capt. Howdy')
    else begin
    talknl(3,'Is Malago''s Cove, okay? ');
    talk(4,'Cost is '+Cstrr(cost,10)+' and you have '+cstrr(player.goldpieces,10)+' GPS (Y/N)');
    onek(abc,'NY'); nl;
    if abc='N' then talknl(5,'Har har har, enjoy your walk!') else
    go_bye_bye(cost,5,5,10,5);
    end;
  5: if not enough then talknl(3,'Sorry but you need '+cstrr(cost,10)+' to sail with us!')
     else begin
      talknl(4,'We set sail to:');
      talknl(3,'A) Scottsville ');
      talknl(3,'B) Palm Springs ');
      talknl(8,'C) Cancel your travel!');
      talknl(4,'We Set sail tommorrow, wish to join us for a mere cost of ');
      talk(4,cstrr(cost,10)+' Gps, You have '+cstrr(player.goldpieces,10)+' (ABC) --> '); ansic(3);
      onek(abc,'ABC'); nl;
      if abc='C' then talknl(5,'Oh well, catchya later!')
       else
       if abc='A' then go_bye_bye(cost,2,4,17,12) else
       if abc='B' then go_bye_bye(cost,7,3,57,10);
    end;
  6,7:  if not enough then talknl(3,'Sorry but you need '+cstrr(cost,10)+' to sail with us!')
       else begin
        talknl(4,'We set sail to:');
        talknl(3,'A) Apple Valley');
        talknl(3,'B) Malago''s Cove');
        talknl(3,'C) Torrents');
        talknl(8,'D) Cancel your trip!');
        if town_stuff.city_num=7 then
         talknl(5,'E) Catalina');
       talknl(4,'We Set sail tommorrow, wish to join us for a mere cost of ');
       talk(4,cstrr(cost,10)+' Gps, You have '+cstrr(player.goldpieces,10)+' (ABC) --> '); ansic(3);
       onek(abc,'ABCDE'); nl;
        case abc of
         'A' : go_bye_bye(cost,5,1,35,14);
         'B' : go_bye_bye(cost,5,5,10,5);
         'C' : go_bye_bye(cost,5,4,51,11);
         'D' : talknl(4,'Catchya Later!');
         'E' : if town_stuff.city_num=7 then go_bye_bye(cost,1,5,17,10);
        end;
      end;
end;
end;

overlay procedure guardian_angel;
var afiler : file of char; hacker:str;
temp, areadchr : char; filename:string[12];
begin
cls; ansic(0);
filename:='                     ';
temp:=chr(town_stuff.city_num+48);
filename:='CREATOR'+temp+'.HLP';
assign(afiler,filename);
reset(afiler); areadchr:=')';
while not EOF(afiler) do begin
  read(afiler,areadchr);
  prompt(areadchr);
end; nl;
repeat goto_ansixy(23,1);
talk(7,'TYPE "DONE" when finished!'); ansic(4);
input(hacker,4) until hacker='DONE'; close(afiler); cls;
end;

overlay procedure do_a_pit2(a,b: Integer);
var x,damag,modr:integer;
begin
clear_space;
if player.equipring.idnum=15 then say_saying('A pit opens below you!  Luckily your ring saved you!')
else begin
  say_saying('You fall Into a Pit!');
  damag:=0;
  if player.class=4 then modr:=25 else modr:=0;
   for x:=1 to player.level *2 do
   damag:=damag+random(8)+1;
   if random(100)< player.stats[4]+modr then begin
      damag:=damag div 2;
      say_saying('You made your saving throw, half damage');
   end;
 say_saying('You take '+cstr(damag)+' Points of Damage!');
 player.act_hitpoints:=player.act_hitpoints-damag;
 check_player_death; sub_moves(10);
end;
map[player.xactual+a,player.yactual+b]:=' ';
end;

overlay procedure do_a_timetrap(a,b : integer);
var modr: integer;
begin
clear_space;
if player.class=2 then modr:=20 else modr:=0;
if random(100) < player.stats[2]+modr then say_saying('You avoid a Time Trap!')
 else begin
 modr:=50-player.stats[2];
 if modr< 10 then modr:=10;
 say_saying('ACK!!! A time trap freezes you for '+cstr(modr)+' Movement Points!');
 sub_moves(modr);
 end;
map[player.xactual+a,player.yactual+b]:=' ';
end;

overlay function enter_sage(x1,y1 : integer): boolean;
{since only Raelizini right now......}
var fileq : file of char;
    temp : char;

procedure pauser;
var hackz:str;
begin
nl;
pausescr;
repeat
goto_ansixy(23,1);
talk(7,'Type "DONE" when Finished');
input(hackz,4);
until hackz='DONE';
end;

procedure type_file(gh: helper);
var fileq: file of char;
temp:char;
begin
  assign(fileq,gh); ansic(0);
  reset(fileq);
  while not EOF(fileq) do begin
   read(fileq,temp);
   prompt(temp);
  end; pauser; close(fileq);
end;

procedure input_soma;
var ing : str; nt:byte;
begin
for nt:=1 to 6 do nl;
say_saying('Use Simple Verbs to Talk To O''laff, "LEAVE" to Leave!');
repeat
say_saying('Enter Verb: ');
input(ing,12);
if ing =
  'SOMA' then say_saying('Get lost, you don''t look like the type to buy it!') else
if (ing='BUY') or (ing='BUY SOMA') then begin
    say_saying('You purchase some Soma and now your in the hole 1000 gps!');
    player.goldpieces:=player.goldpieces-1000;
    if player.goldpieces<0 then player.goldpieces:=0;
    player.experience:=player.experience-2000; ing:='LEAVE';
  end else
if (ing='ATTACK') or (ing='KILL') or (ing='THREATEN') then begin type_file('SAGE5.TXT');
   player.exemptions[6]:=1;
   ing:='LEAVE'; end
 else if ing<>'LEAVE' then say_saying('Get Lost, I have Business to Conduct!');
until ing='LEAVE';
end;

begin
if player.outxmap=7 then
if player.door_exemps[42]<>1 then
  begin
  say_saying('Raelizini greets you but you do not have what she needs!');
  say_saying('Find the Eyes of Doom first!');
  pausescr; enter_sage:=false;
  end
 else begin
  say_saying('Raelizini''s House!'); pausescr; cls;
  type_file('SAGE1.TXT');
  type_file('SAGE2.TXT');
  type_file('SAGE3.TXT');
  enter_sage:=true;
end;
if player.outxmap=3 then begin
  say_saying('Somavale!'); pausescr; cls;
  type_file('SAGE4.TXT');
  input_soma;
  end;
end;

overlay procedure load_weather;
var filex : file of weather;
    temper,changer : integer;
begin
assign(filex,'WEATHER.INF');
reset(filex);
read(filex,conditions); close(filex);
case conditions.degree of
   1..20 : begin say_saying('Weather Conditions are Very Wet!'); changer:=random(30)-random(10); end;
   21..60 : begin say_saying('Weather Conditions are Wet!'); changer:=random(20)-random(10); end;
   65..155 : begin say_saying('Weather Conditions are Normal!'); changer:=random(30)-random(30); end;
   156..200 : begin say_saying('Weather Conditions are Heating Up!'); changer:=random(10)-random(20); end;
   201..256 :begin say_saying('Weeather Conditions are Very Hot!'); changer:=random(10)-random(30); end;
end;
pausescr;
temper:=conditions.degree+changer;
if temper<0 then temper:=0;
if temper>255 then temper:=255;
conditions.degree:=temper;
assign(filex,'WEATHER.INF');
rewrite(filex);
write(filex,conditions);
close(filex);
end;


overlay function riddler (x11,y11,mojrid : integer) : boolean;

procedure fool;
begin
talknl(3,'The angel changes shape suddenly and begins to laugh as it does so');
talknl(3,'"Fool you are deceived so easily!  The lady-like fingers suddenly get');
talknl(3,'much larger and begin to form talons.  Caught quite by surprise it is');
talknl(3,'not much of a battle.  To save you you find yourself teleported back');
talknl(3,'of the dungeon to start over');
player.dungeon:=false;
player.outdoor:=true;
save_char(1);
moves:=-1;
check_moves;
end;

procedure chant_words;
var wrds : array [1..3] of str;
    xer: integer;
begin
talknl(5,'Type XXX to start Over'); xer:=1;
while xer<4 do begin
  talk(5,'Enter Word Number '+cstr(xer)+': ');
  input(wrds[xer],3); nl;
  if wrds[xer]='XXX' then xer:=0; xer:=xer+1;
end;
if (wrds[1]='BAC') and (wrds[2]='BEG') and (wrds[3]='LOY') then begin
 talknl(5,'Arghhhh!!!!  The beautiful white Angel begins to change shape....');
 talknl(5,'black and red wings grow from her back and the halo disappears into');
 talknl(5,'Dust!  She grows much and begins to form into Mojave!'); nl;
 talknl(5,'The ground begins to shake and tremble... Diving to the side you notice');
 talknl(5,'a flaming circle begin to form around Mojave!  The bird is unable to ');
 talknl(5,'fly it appears as it begins to sink into the ground!  Mojave ');
 talknl(5,'Shreeks in pain as it disappears beneath the earth for yet another 1000');
 talknl(5,'years!');
 player.experience:=player.needed_exp;
 player.door_exemps[101]:=1;
 pausescr;
end else fool;
end;


procedure do_mojave;
var chx:char;
begin
onek(chx,'CLR');
case chx of
  'C' :  chant_words;
  'L' :  fool;
  'R' :  riddler:=false;
end;
end;

procedure do_rid(filx,answer:helper);
var fily:file of char; x,y: integer;
    tempchar : char; filload: char;
    inputt: str;    damag:integer;
begin
assign(fily,filx);
reset(fily);
ansic(0);
while not EOF(fily) do begin
  read(fily,filload);
  prompt(filload);
end;
close(fily); nl;
pausescr;
talk(7,'Answer:  ');
if mojrid=0 then begin
input(inputt,10);
if inputt=answer then begin
  talknl(7,'Correct!  The Statue Disappears!');
  map[player.xactual+x11,player.yactual+y11]:=' ';
  pausescr; player.experience:=player.experience+100;
  riddler:=true;
end else begin
  damag:=random(25)+4*player.level;
  talknl(7,'Incorrect!  You Take '+cstr(damag)+' points of Damage!');
  player.act_hitpoints:=player.act_hitpoints-damag; pausescr;
  check_player_death;
  riddler:=false;
  end;
end else if player.door_exemps[101]=0 then do_mojave else say_saying('Nothing Here!');
end;

procedure judges;
var x,g: byte; h: integer;
begin
printfile('RIDDLE8.QST');
pausescr;
talk(5,'The Judges Debate: ');
for x:=1 to 15 do begin talk(4,'.'); for h:=1 to 1255 do; end; nl;
if (player.door_exemps[101]=1) and (player.door_exemps[127]=1) then begin
  talknl(8,'Innocence is Proven!  You may Enter!');
  riddler:=true; pausescr;
  end else begin
  talknl(8,'Not Innocent, Must Proven Innocence!');
  riddler:=false; pausescr;
  end;
end;

begin
say_saying('A Riddle Asking Statue!'); pausescr;
cls;
case player.xactual+x11 of
  40 : do_rid('riddle1.qst','ANGEL');
  47 : do_rid('riddle2.qst','DOVE');
  26 : do_rid('riddle3.qst','SMILE');
  29 : do_rid('riddle4.qst','BARD');
  32 : do_rid('riddle5.qst','DREAM');
  52 : do_rid('riddle6.qst','NIL');
  63 : judges;
end;
end;

overlay procedure do_a_fountain;
var choicx:char;
begin
clear_space;
say_saying('Before you is a fountain of clear, fresh water!');
say_saying('The fountain is ancient and has many runes on it!');
say_saying('Do You Want to Drink from it? (Y/N)');
onek(choicx,'NY');
if (choicx='Y') and (player.door_exemps[95]=0) then begin
 clear_space;
 say_saying('You feel very different all of the sudden!');
 say_saying('But the feeling subsides and disappears!');
 player.door_exemps[95]:=1;
 player.experience:=player.needed_exp;
end else say_saying('No Effect.... Continue Playing...');
sub_moves(1);
end;

overlay function time_warp : boolean;
var vchar : char;
begin
say_saying('Before you is a Shimmering Light, its seems to twist and move');
say_saying('as the Light Moves!');
say_saying('Move into it?  (Y/N)');
onek(vchar,'YN');
if vchar='N' then say_saying('Continue Playing....') else begin
 clear_space;
 say_saying('When you walk into the shimmering light, a sudden dizziness comes');
 say_saying('over you.  You become momentarily disorientated.  But the feeling');
 say_saying('quickly subsides...');
 if player.outxmap=6 then begin
   player.outxmap:=2; player.outymap:=4; player.outxact:=26; player.outyact:=11; end
else begin
   player.outxmap:=6; player.outymap:=2; player.outxact:=61; player.outyact:=16; end;
 end;
end;

overlay procedure soma_plant(xg,yg : integer);
var jkl : char;
begin
if player.door_exemps[102]<102 then begin
 say_saying('(D)estroy Soma  (L)eave Soma   (U)se Soma: ');
  onek(jkl,'DLU');
 case jkl of
  'D' :begin
  player.door_exemps[102]:=player.door_exemps[102]+1;
  say_saying('Destroyed Soma #'+cstr(player.door_exemps[102]));
  map[player.xactual+xg,player.yactual+yg]:=' ';
  player.experience:=player.experience+100;
  end;
   'L' : say_saying('Continue Playing....');
   'U' :begin say_saying('You begin to Feel Drowsy and Somewhat typsy! -- Ack!');
        player.experience:=player.experience-1500;
          player.stats[1]:=1; player.stats[2]:=1; player.stats[4]:=1;
        determine_armorclass;
       if player.door_exemps[102]>15 then player.door_exemps[102]:=player.door_exemps[102]-15;
        end;
  end;
end else begin
 say_saying('You''ve destroyed enough Soma for the Knights');
 map[player.xactual+xg,player.yactual+yg]:=' ';
end;
end;

overlay procedure docs;
var g1: file of char; btemp, tempchar : char;
procedure typefill(filename:helper);
begin
ansic(0);
printfile(filename);
pausescr; nl;
end;

begin
repeat
talknl(3,'A. Credits and Thank You''s');
talknl(3,'B. Terrain Information');
talknl(3,'C. Outdoor/Dungeon Commands ');
talknl(3,'D. Dungeon Information');
talknl(3,'E. Status Screen Information');
talknl(3,'F. City Commands -- IMPORTANT');
talknl(3,'G. Boating Information');
talknl(3,'H. General Store Information');
talknl(3,'I. Potion Information');
talknl(3,'J. Ring Information');
talknl(3,'K. Combat Rules');
talknl(3,'L. Hints and Strategies');
talknl(3,'M. Disclaimers');
talknl(3,'N. Story/History');
talknl(3,'O. Leave');
nl; talk(4,'Choice (A-O): ');
ONEK(tempchar,'ABCDEFGHIJKLMNO');
case tempchar of
   'A' : typefill('CREDIT.PIT');
   'B' : typefill('TERRAIN.PIT');
   'C' : typefill('OCOMMAND.PIT');
   'D' : TYPEFILL('DUNGINFO.PIT');
   'E' : TYPEFILL('STATUS.PIT');
   'F' : TYPEFILL('CITYCOM.PIT');
   'G' : TYPEFILL('BOATING.PIT');
   'H' : TYPEFILL('GENERAL.PIT');
   'I' : TYPEFILL('POTION.PIT');
   'J' : TYPEFILL('RINGSINF.PIT');
   'K' : TYPEFILL('COMBAT.PIT');
   'L' : TYPEFILL('HINTS.PIT');
   'M' : TYPEFILL('DISCLAIM.PIT');
   'N' : TYPEFILL('STORY.PIT');
END;
UNTIL tempchar='O';
end;

overlay function do_a_ferry : boolean;
var choicx : char;
begin
say_saying('Do You Wish to Take the Free Ferry back to the Mainland? (Y/N): ');
onek(choicx,'NY');
if choicx='Y' then begin
  player.outxact:=52;
  player.outyact:=16;
  do_a_ferry:=false; say_saying('The ferry back the mainland is uneventful!');
  sub_moves(50);
 end
else do_a_ferry:=true;
end;

overlay procedure do_a_bird;
var qustn : str;
begin
cls; printfile('Riddle9.QST');
pausescr; nl;
repeat;
talknl(3,'Ask Questions to the Bird or "LEAVE" to leave');
talk(4,'Inquiry: ');
input(qustn,25);
if qustn='PIT FIEND' then talknl(7,'Yes he lives in a "cave" to the west') else
if qustn='CAVE' then talknl(7,'You will need "words" to enter the cave') else
if qustn='WORDS' then talknl(7,'The Words are: "LUV", "HAT", "PAN"') else
if qustn='YOLIMDAR' then talknl(7,'Yes he was my master and was with me at the "cave"') else
if qustn='DRAGON''S POINT' then talknl(7,'It is a "cave" where "Pit Fiend" lives') else
if qustn<>'LEAVE' Then talknl(7,'Ack... I don''t know what you mean!');
until qustn='LEAVE';
end;

overlay function do_a_cave : boolean;
var gyus : boolean;
    chx : char;
   function get_words : boolean;
    var lastvar : array [1..3] of str;
        counter : byte;
    begin
    say_saying('Enter The Words');
    for counter:=1 to 3 do begin
     say_saying('Enter Word #'+cstr(counter)+': ');
     input(lastvar[counter],3);
    end;
    if (lastvar[1]='LUV') and (lastvar[2]='HAT') and (lastvar[3]='PAN')
     then get_words:=true else get_words:=false;
    end;

  procedure typedon;
  var xxer :str;
  begin
  repeat
  talk(7,'Type DONE When Finished: ');
  input(xxer,4);
  until xxer='DONE';
  end;

begin
say_saying('Do You wish To Enter the Sealed Cave? (Words Req.) (Y/N): ');
onek(chx,'YN');
if chx='N' then do_a_cave:=false
 else begin
  gyus:=get_words; do_a_cave:=gyus;
  if gyus then begin cls;
  printfile('riddle10.QST'); typedon;
  printfile('Riddle11.QST'); typedon;
  printfile('Riddle12.QST'); typedon;
  printfile('Riddle13.QST'); typedon;
 end else say_saying('Nothing Happens!');
end;
end;

overlay procedure serial;
var serial_id : string[4]; x: byte;
begin
serial_id:='DART';
talk(7,'Serial Number:  ');
for x:=1 to 4 do
 talk(8,cstr(ord(serial_id[x])));
nl;
end;
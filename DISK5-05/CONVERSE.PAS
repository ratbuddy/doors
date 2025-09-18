overlay procedure conversationz(directive:integer);
type conversation = record
name   : string[20];
descrip: string[60];
greeter: helper;
later  : helper;
keys   : array [1..4] of string[12];
resp_keys:array[1..4,1..4] of helper;
dunno  : helper;
toggles:array[1..4] of byte;
minchar: byte;
nochar : helper;
bribe  : integer;
end;

var ch1, ch2 : char; dummy,choicint:integer;
    all_done    : boolean; chwrd:string[2];
    person_chat:conversation;
    inputter:str;

procedure dencrypt;
var a,b,c :byte;
begin
for a:=1 to 4 do
 for b:=1 to length(person_chat.keys[a]) do
  person_chat.keys[a][b]:=chr(ord(person_chat.keys[a][b])-b);
for a:=1 to 4 do
 for c:=1 to 4 do
  for b:=1 to length(person_chat.resp_keys[a][c]) do
   person_chat.resp_keys[a][c][b]:=chr(ord(person_chat.resp_keys[a][c][b])-b);
end;

procedure load_person(personn:integer; dir2:boolean);
var filename:string[12];
    conver_file : file of conversation;
begin
filename:='            ';
if not dir2 then filename:='CONVER'+chr(town_stuff.city_num+48)+'.CON' else
  filename:='CONVERSP.PIT';
assign(conver_file,filename); reset(conver_file); seek(conver_file, personn-1);
read(conver_file,person_chat); close(conver_file);
dencrypt;
end;

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
until (bcb=5) or (person_chat.resp_keys[select,bcb][1]='%');
player.exemptions[person_chat.toggles[select]]:=1;
end;

procedure inquiry;
var inq : str;
    txt : byte;
begin
say_saying('Inquiry -->');
input(inq,12);
for txt:=1 to 4 do
if inq=person_chat.keys[txt] then begin tellem(txt); txt:=4; end
 else if txt=4 then say_saying(person_chat.dunno);
end;

function cool : boolean;
begin
if player.stats[active,7]<person_chat.minchar then begin
  say_saying(person_chat.nochar); cool:=false;
  say_saying('Minimum Personality Needed is '+cstr(person_chat.minchar))
  end else cool:=true;
end;

procedure offer;
var inputs:str; amnti:integer;
begin
say_saying('How Many Goldpieces do you wish to Offer? (0-'+cstrr(player.goldpieces,10)+'): ');
input(inputs,4);
amnti:=value(inputs);
if amnti>player.goldpieces then say_saying('You don''t have that much Gold!')
 else begin
  if amnti>person_chat.bribe-1 then begin
    person_chat.minchar:=0;
    say_saying('Okay I am willing to talk about whatever you wish now....');
  end else begin
    say_saying('You think that is going to amount is going to satisfy me?');
    say_saying('Hmmprh...  Not enough thanks for the cash!');
  end;
  player.goldpieces:=player.goldpieces-amnti;
end;
end;

procedure lets_talk;
var ggg: char; term: boolean;
begin
descrip;
term:=false;
repeat
sub_moves(1);
say_saying(player.name[active]+' (1-3), (D)escribe, (G)reet, (I)nquire, (L)eave, (O)ffer -> ');
onek(ggg,'123DGILO');
case ggg of
 '1' : active_change(1);
 '2' : active_change(2);
 '3' : active_change(3);
 'D' : descrip;
 'G' : say_saying(person_chat.greeter);
 'I' : if cool then inquiry;
 'L' : begin say_saying(person_chat.later); term:=true; end;
 'O' : if person_chat.bribe >0 then say_saying('Thanks for the Offer, but I Cannot Accept it!')
        else offer;
end;
until term;
end;

begin
if directive=100 then begin
cls; display_people; all_done:=false;
repeat
  say_saying('Choice (0 to Leave) --> ');
  input(inputter,2);
  choicint:=value(inputter);
   if choicint=0 then all_done:=true else
   begin
   if (choicint < 0) or (choicint > town_stuff.num_conv) then say_saying('INVALID INPUT!')
   else begin load_person(choicint,false); lets_talk; end;
   end;
until all_done;
cls;
end;
if directive<>100 then begin load_person(directive,true); lets_talk; end;
end;

overlay procedure do_outsign(hx,hy:integer);
type signer=record
Descrip: helper;
chatsay: helper;
dlocx  : byte;
dlocy  : byte;
dymap  : byte;
dxmap  : byte;
dunglvl: byte;
outdun : boolean; {TRUE for OUTDOOR, FALSE for DUNGEON!}
end;

var outsign: file of signer;
    signsay: signer; e,okl:boolean;
    var a,b,c,d:integer;
begin
assign(outsign,'SIGNS.PIT');
reset(outsign); okl:=false;
repeat
if player.outdoor then begin
  a:=player.outxact;
  b:=player.outyact;
  c:=player.outymap;
  d:=player.outxmap;
  e:=true;
 end else begin
  a:=player.xactual;
  b:=player.yactual;
  c:=player.ymap;
  d:=player.xmap;
  e:=false;
 end;
if (player.outdoor) then
       player.dungeon_level:=1;
{$I-} read(outsign,signsay); {$I+}
if IOResult<>0 then begin say_saying('MISTAKE REPORT IMMEDIATELY!'); okl:=true; end;
if e=signsay.outdun then
 if a+hx=signsay.dlocx then
  if b+hy=signsay.dlocy then
   if c=signsay.dymap then
    if d=signsay.dxmap then
     if player.dungeon_level=signsay.dunglvl then begin
      clear_space; okl:=true;
      say_saying(signsay.descrip);
      say_saying(signsay.chatsay);
   end;
until okl;
close(outsign);
end;


overlay procedure table_char;
type table = record
name : string[25];
tm   : real;
win : boolean;
end;

var ftab : file of table; tlist : table; axd,stan : integer;
tempx:char;
procedure putinlocx;
type location = record
   outdun:boolean;
   xloc:byte;
   yloc:byte;
   ymap:byte;
   xmap:byte;
   ussernum:integer;
   usernam:string[30];
   sayer:boolean;
   s_say:string[30];
   s_s2:string[30];
   end;

var vloc:location; floc:file of location;
begin
assign(floc,'LOCXY.DAT');
reset(floc);
seek(floc,usernum-1);
if player.outdoor then begin
  vloc.outdun:=true;
  vloc.xloc:=player.outxact;
  vloc.yloc:=player.outyact;
  vloc.ymap:=player.outymap;
  vloc.xmap:=player.outxmap;
  end else
if player.dungeon then begin
  vloc.outdun:=false;
  vloc.xloc:=player.xactual;
  vloc.yloc:=player.yactual;
  vloc.ymap:=player.ymap;
  vloc.xmap:=player.xmap;
end
 else vloc.xmap:=100;
vloc.ussernum:=usernum;
vloc.usernam:=thisuser.name;
vloc.sayer:=false;
vloc.s_say:='NO MESSAGE!                  ';
write(floc,vloc);
close(floc);
end;

begin
assign(ftab,'TABLE.DAT'); reset(ftab);
seek(ftab,usernum-1);
tlist.name:=thisuser.name; axd:=3;
tlist.tm :=player.total_moves;
if player.door_exemps[253]=69 then tlist.win:=true else tlist.win:=false;
write(ftab,tlist);
reset(ftab);
say_saying('Do you Wish to see the Table of Characters (Y/N): ');
onek(tempx,'YN');
if tempx='Y' then begin
cls;
talknl(4,'USER NAME                            TOTAL MOVES'); nl;
for stan:=1 to 1500 do begin
read(ftab,tlist);
if tlist.tm>0 then begin
talk(4,tlist.name);
goto_ansixy(axd,29);
talk(7,' '+cstrr(tlist.tm,10));
goto_ansixy(axd,51);
if tlist.win then talknl(8,'IS A WINNER!') else nl;
axd:=axd+1;
if axd=22 then begin pausescr; cls; axd:=1; end;
end;
end;
pausescr;
end;
close(ftab);
putinlocx;
end;

overlay function do_other_wandering(toy:byte; hf,gf:integer): boolean;
var tter:byte;
procedure do_a_magic_mouth;
type mm = record
 usermouth : string[25];
 saying : helper;
end;
 var g1 : file of mm; inputss : str;
 mag_mouth : mm; choice5 : char;
 begin
 clear_space;
 say_saying('A Magic Mouth appears!');
 assign(g1,'MMOUTH.DAT'); reset(g1);
 read(g1,mag_mouth); close(g1);
 say_saying('From: '+mag_mouth.usermouth);
 say_saying(mag_mouth.saying);
 say_saying('Now you have a chance to change it, do you wish to (Y/N)?');
 onek(choice5,'YN');
 if choice5 ='Y' then begin
  assign(g1,'mmouth.dat');
  rewrite(g1);
  mag_mouth.usermouth:=thisuser.name;
  say_saying('Enter String (70 Characters) ');
  say_saying(':');
  input(inputss,70);
  mag_mouth.saying:=inputss;
  write(g1,mag_mouth);
  close(g1);
  say_saying('Message saved and reported to sysop!');
  sysoplog('Set Magic Mouth = '+inputss);
  sysoplog('RUN CMOUTH.EXE TO RESET IT IF NOT NEED BE......');
 end;
end;

procedure throw_donut;
 begin
 say_saying('The Knights chuckle at you the dogs bark!  It seems you might be');
 say_saying('guilty of something.  Then the sheriff, Knight Pesen says, ');
 say_saying('you aren''t guilty of anything!  He and his men start laughing ');
 say_saying('again.... as they continue down the road, Knight Delfris throws a');
 say_saying('donut at you...... jelly filled too!');
 end;

procedure fight_cops;
begin
say_saying('Realizing that you are still a wanted party the Knights draw ');
say_saying('their swords and start an attack.  Rather than finishing this quest');
say_saying('in jail you decide to fight back, you also realize that these DEADLY');
say_saying('attacks will continue until you pay the debt!');
binc(player.door_exemps[247],15);
if player.door_exemps[247]>100 then player.door_exemps[247]:=100;
save_char(0);
type_mon[1]:=72; type_mon[2]:=29; type_mon[3]:=46; type_mon[4]:=68;
how_many[1]:=10; how_many[2]:=10; how_many[3]:=1; how_many[4]:=1;
pausescr;
end;

procedure payup(charge:real);
var fuk,ty:integer;
begin
say_saying('You are charged with '+cstr(player.door_exemps[247])+' of Murder and Assault');
say_saying('The cost you must pay is '+cstrr(charge,10)+' Gold Pieces');
if player.goldpieces>charge-1 then begin
   say_saying('You gingerly pull out the required coins as the knights count');
   say_saying('out each and every piece!');
   player.goldpieces:=player.goldpieces-charge;
   player.door_exemps[247]:=0;
end else if player.goldpieces>99 then begin
  ty:=0;
  for fuk:= 1 to player.door_exemps[247] do
  if player.goldpieces>99 then begin ty:=ty+1; player.goldpieces:=player.goldpieces-100; end;
  say_saying('You don''t have enough cash, but the Knights take what they can!');
  say_saying('You are able to pay up '+cstr(ty)+' of the Counts!');
  if player.goldpieces<0 then player.goldpieces:=0;
  binc(player.door_exemps[247],0-ty);
end;
save_char(0);
if player.door_exemps[247]>35 then fight_cops;
end;

procedure paycops;
var cost:real;
begin
cost:=100*player.door_exemps[247];
say_saying('The Knights come up to you and check your party''s desciption with');
say_saying('Those in the log......');
delay(1000);
say_saying('Alright... Alright!  If I am guiltly of anything let me take care');
say_saying('of the charges now you beg!');
if cost=0 then throw_donut else payup(cost);
end;

procedure hide;
begin
say_saying('You jump in the brush and pray and hope that the dogs can''t smell');
say_saying('you!..........');
delay(500);
if random(100)+1 < player.door_exemps[247] then begin
   say_saying('As the Knights are passing one of dogs begins to smell in your general');
   say_saying('area.  It appears as though you are not successful.  The Knights');
   say_saying('challenge you to get out of your hiding place.  Carefully you do');
   say_saying('You are heavily outnumbered and you hope you can pay for your crimes!');
   paycops;
end else begin
   say_saying('Breathing quietly and concealing yourself in every way, you lie in ');
   say_saying('In the brush!....');
   delay(500);
   say_saying('The Knights pass on without any regard.....');
end;
end;

procedure cops;
var c:char;
begin
clear_space;
say_saying('While wandering about you come across a group of Knights of Scottsville');
say_saying('They are obviously looking for a criminal because they have dogs!');
say_saying('Do you Wish to (H)ide or (P)ay (not bribe) for YOUR crimes: ');
onek(c,'HP');
if c='P' then paycops else hide;
end;

procedure food_man;
var cchx:char; tt:byte;
 procedure quantity;
 var inputs:str; quant,maxquan:integer;
 begin
 maxquan:=99-player.food[tt];
 say_saying('How Many (0-'+cstr(maxquan)+'): ');
 input(inputs,2);
 quant:=value(inputs);
 if maxquan<quant then say_saying('You can''t purchase that many!')
 else if quant<1 then say_saying('Aborted!')
 else if player.goldpieces<quant*2 then say_saying('Not Enough Gold!')
 else begin
  player.goldpieces:=player.goldpieces-(quant*2);
  binc(player.food[tt],quant);
  if player.food[tt]>99 then player.food[tt]:=99;
  display_char(tt);
  say_saying('Enjoy your Food and and Many Thanks!');
  end;
end;

begin
repeat
say_saying('You are approached quite suddenly by a small man.  He says: ');
say_saying('"Hello and Greets.  Grundar''s the name and food is my game!  I');
say_saying('sell 1 Ration for 2 Gold Pieces. Would you care to purchase any?"');
say_saying('Hit 0 for No Thanks or 1-3 for the buyer: ');
onek(cchx,'0123');
tt:=ord(cchx);
if tt>0 then
 if player.status[tt]<>8 then quantity else say_saying(player.name[tt]+' is in no condition to purchase food!');
until cchx='0';
end;

procedure pitme(typit:boolean);
var xx:byte; typstr:string[6];

  procedure talker(h,yt:byte);
  var dama,cnt:integer;
  begin
  case h of
   1: say_saying('Luckily '+player.name[yt]+'`s Ring of Feather Falling Saved Him!');
   2: say_saying(player.name[yt]+' Throws himself to the side, avoiding the trap!');
   3: begin dama:=0; for cnt:=1 to player.stats[yt,12] do dama:=dama+random(6)+1;
      say_saying(player.name[yt]+' Takes '+cstr(dama)+' Points of Damage!');
      inc(player.stats[yt,11],0-dama);
      check_player_death;
      display_char(yt);
      end;
  end;
if typit then map[player.xactual+hf,player.yactual+gf]:=' ';
  end;

begin
if typit then typstr:='pit!' else typstr:='snare!';
say_saying('While traveling along you are caught off guard by a '+typstr);
if feather then begin
 say_saying('Your Feather Falling Spell Saved you, you are merely delayed...');
 player.total_moves:=player.total_moves+10;
end else
 for xx:=1 to 3 do
 if player.status[xx]<>8 then
  if player.equipring[xx].idnum=31 then talker(1,xx)
   else if player.stats[xx,4]>random(100) then talker(2,xx)
    else talker(3,xx);
end;

procedure glyphme;
var a,x,temp:integer;
begin
say_saying('As you are walking around a Magic Glyph of Warding Goes Off!');
say_saying('Your party is burnt!');
for x:=1 to 3 do
 if player.status[x]<>8 then begin
   temp:=0;
   for a:=1 to player.stats[x,12] do temp:=random(8)+1+temp;
   if (random(100)+1 < player.stats[x,6]) then temp:=temp div 2;
   say_saying(player.name[temp]+' Takes '+cstr(temp)+' Points Of Damage!');
   inc(player.stats[x,11],0-temp);
   display_char(x);
   check_player_death;
 end;
map[player.xactual+hf,player.yactual+gf]:=' ';
end;

procedure firewater;
var x:byte; dama:integer;
begin
dama:=0;
for x:= 1 to 3 do dama:=random(12)+1+dama;
say_saying('Ack!  As '+player.name[active]+' touches the water he/she is scalded');
say_saying('for '+cstr(dama)+ ' Points of Damage!');
inc(player.stats[active,11],0-dama);
display_char(active);
check_player_death;
end;

procedure soma_me;
var chx:char;

  procedure do_soma;
  var t:byte;
  begin
  say_saying(player.name[active]+' Eats Some of the Soma');
  say_saying('Moments later, a rushing, warm sensation comes over '+player.name[active]);
  say_saying('Giggling and somewhat clumsy, '+player.name[active]+' is ready to now adventure');
  player.experience[active,1]:=player.experience[active,1]-100;
  for t:= 1 to 4 do
   player.stats[active,t]:=3;
  determine_armorclass;
  display_char(active);
  end;

begin
if player.door_exemps[48] > 100 then say_saying('You have already destroyed enough Soma!')
else begin
say_saying(player.name[active]+' comes across a Soma Plant:');
say_saying('Choice:  (E)at it  (K)ill It  (L)eave it: ');
onek(chx,'EKL');
case chx of
 'E' : do_soma;
 'K' : begin
 say_saying(player.name[active]+' Kills the plant! 25 Experience!');
 player.experience[active,1]:=player.experience[active,1]+25;
 binc(player.door_exemps[48],1);
 map[player.xactual+hf,player.yactual+gf]:=' ';
 end;
 'L' : say_saying(player.name[active]+' Decides to Leave the plant be....');
end;
end;
say_saying('Continue playing...');
end;

procedure teleport_me;
 procedure set_cord(f1,f2:byte);
 begin
 player.xactual:=f1;
 player.yactual:=f2;
 end;
begin
say_saying('Quite Suddenly, everything becomes red; a sharp sound pierces your ears');
say_saying('and your surroundings change!');
pausescr;
case player.xactual+hf of
 46:set_cord(54,15);
 26:set_cord(38,13);
 14:set_cord(38,13);
 43:set_cord(41,10);
 33:set_cord(14,3);
 66:set_cord(39,9);
 18:set_cord(39,9);
 62:set_cord(39,9);
 22:set_cord(51,20);
 36:set_cord(13,20);
end;
end;

begin
if toy=100 then pitme(true) else
 if toy=50 then glyphme else
  if toy=25 then firewater else
   if toy=10 then soma_me else
    if toy=35 then teleport_me else begin
 tter:=random(5);
 case tter of
  0,1: do_a_magic_mouth;
  2:cops;
  3: if player.outdoor then food_man else do_a_magic_mouth;
  4: pitme(false);
 end; end;
 if tter=2 then do_other_wandering:=true else do_other_wandering:=false;
end;

overlay function sage_hut:byte;
var t:char; tmp:byte;

procedure doner;
var hacker:str;
begin
nl;
repeat
talk(3,'Enter DONE when finished: ');
input(hacker,4);
until hacker='DONE';
nl;
end;

procedure jennifer;
var gh:byte; jk:char; ty:boolean;
begin
ty:=false;
for gh:=1 to 3 do
  talknl(4,player.name[gh]+' Equipped Ring is a '+player.equipring[gh].name);
talk(3,'Who will take the Ring of Wall Removal (0 for none, 1-3): ');
repeat
onek(jk,'0123'); gh:=ord(jk)-48; if gh=0 then ty:=true
else if player.status[gh]<>8 then ty:=true;
until ty;
if gh>0 then begin player.equipring[gh]:=ring[11]; player.equipring[gh].charges:=3;
player.door_exemps[72]:=1; player.outxact:=17; player.outyact:=8;
end;
end;

begin
say_saying('Do you Wish to Enter the Hut? (Y/N): ');
onek(t,'NY');
if t='N' then tmp:=0 else begin
tmp:=1;
cls;
case player.outxmap of
 2: if (player.door_exemps[10]<1) and (player.door_exemps[26]<1) and (player.door_exemps[28]<1)
    then begin
    printfile('SAGE1.TXT'); doner;
    printfile('SAGE2.TXT'); doner;
    end else begin printfile('SAGE3.TXT'); doner; end;
 3: if (player.door_exemps[47]<1) then begin
    printfile('SAGE6.TXT'); doner;
    printfile('SAGE7.TXT'); doner; player.exemptions[3]:=1;
    end else begin printfile('SAGE8.TXT'); doner; player.exemptions[4]:=1; end;
 4: if player.door_exemps[74]=0 then begin
   printfile('SAGE16.TXT'); doner; printfile('SAGE17.TXT'); doner;
   printfile('SAGE18.TXT'); doner; printfile('SAGE19.TXT'); doner;
   jennifer; tmp:=2;
   end else begin printfile('SAGE20.TXT'); doner; end;
end;
end;
sage_hut:=tmp;
end;

overlay procedure docs;
var temp:char;
begin
repeat;
cls;
talknl(4,'A.  City Commands');
talknl(4,'B.  Rings and Potions');
talknl(4,'C.  Conversation -- Very Important');
talknl(4,'D.  General Store');
talknl(4,'E.  Magic Spells -- Detailed Description');
talknl(4,'F.  Combat -- Rules to...');
talknl(4,'G.  Wilderness/Dungeon Commands');
talknl(4,'H.  Character Statistics');
talknl(4,'I.  Warranty and Thankyou''s and Registering Info');
talknl(4,'J.  Quest Description');
talknl(4,'K.  Installation Description');
talknl(4,'L.  Go Back');
onek(temp,'ABCDEFGHIJKL');
case temp of
  'A' : printfile('CITYCOM.DOC');
  'B' : printfile('RINGPOT.DOC');
  'C' : printfile('CONVER.DOC');
  'D' : printfile('GENERAL.DOC');
  'E' : printfile('MAGIC.DOC');
  'F' : printfile('COMBAT.DOC');
  'G' : printfile('WILDER.DOC');
  'H' : printfile('CHARSTUF.DOC');
  'I' : printfile('WARRANTY.DOC');
  'J' : printfile('ANGEL.DOC');
  'K' : printfile('INSTALL.DOC');
end;
if temp<>'L' then pausescr;
until temp='L';
end;

overlay function do_a_riddle(fork:boolean; modx,mody:integer):boolean;
var o_prot:boolean;
procedure doner;
var hamp:str;
begin
nl;
repeat
talk(4,'Type "DONE" when finished:  ');
input(hamp,4);
until hamp='DONE'; nl;
end;

procedure answer(ans:str; mind,maxd:byte);
var realans:str; damage:integer;
begin
doner;
talk(4,'Answer:  ');
input(realans,12);
if realans=ans then begin
  o_prot:=true;
  talk(8,'Correct!'); pausescr;
end else begin
  o_prot:=false;
  damage:=random(maxd-mind)+mind;
  talknl(8,'Incorrect! '+player.name[active]+' Takes '+cstr(damage)+' Points of Damage');
  pausescr;
  inc(player.stats[active,11],0-damage);
 end;
end;

begin
if not fork then say_saying('You find something special....') else
  say_saying('You come across a riddle asking statue!');
pausescr;
cls;
case player.xactual+modx of
45:begin
   talknl(4,'You find this letter on the table:  ');
   printfile('SAGE4.TXT'); doner;
   end;
35:begin
   printfile('RIDDLE1.TXT'); answer('FIRE',4,32); end;
27:begin
   printfile('RIDDLE2.TXT'); answer('HEART',3,18); end;
39:if player.yactual+mody=8 then begin
   printfile('RIDDLE3.TXT'); answer('LIPS',5,25); end
    else begin printfile('SAGE9.TXT'); player.door_exemps[47]:=1; end;
57:begin
   printfile('RIDDLE4.TXT'); answer('SUNSET',6,30); end;

end;
do_a_riddle:=o_prot;
end;

overlay procedure detect_trap;
procedure do_work(x2,x3:integer);
var base:integer; yack:char;
begin
say_saying('The search begins......');
delay(1500);
player.total_moves:=player.total_moves+50+random(25);
yack:=map[player.xactual+x2,player.yactual+x3];
if player.stats[active,15]=5 then base:=35 else base:=10;
inc(base,player.stats[active,12]*8);
if (random(100)+1 > base) or (yack <>'G') or (yack<>'P') or (yack<>'Œ')
 then say_saying('No Traps found!')
 else begin
  case yack of
  'G' : say_saying(player.name[active]+' deactivates a Glyph of Warding');
  'P' : say_saying(player.name[active]+' deactivates the Pit Trap');
  'Œ' : say_saying(player.name[active]+' has the distract the ambush!');
  end;
 map[player.xactual+x2,player.yactual+x3]:=' ';
 end;
end;

procedure check_it;
var chx:char;
begin
say_saying('Direction ? (0 for None), (2468): ');
onek(chx,'02468');
case chx of
 '0':say_saying('No Action Taken!');
 '2':do_work(0,1);
 '4':do_work(-1,0);
 '6':do_work(1,0);
 '8':do_work(0,-1);
end;
end;

begin
if dialcnt> 18 then clear_space;
say_saying('Detect Traps Option');
if (player.stats[active,15]<>5) and (player.stats[active,15]<>2) then
  say_saying(player.name[active]+' Is not a Thief/Archer Class!')
   else if player.outdoor then say_saying('Not available action for outdoors!') else
   check_it;
end;

overlay procedure pre_battle(x1,y1: integer);
  procedure doner;
  var tempo:str;
  begin
  repeat
  nl; talknl(4,'Enter DONE when done:  ');
  input(tempo,4);
  until tempo='DONE';
  end;

begin
case player.xactual+x1 of
 47: if player.door_exemps[39]<>0 then begin
      printfile('SAGE12.TXT'); doner; printfile('SAGE13.TXT'); doner;
      end else begin printfile('SAGE10.TXT'); doner; printfile('SAGE11.TXT');
      doner; end;
 33:  begin cls; printfile('SAGE20.TXT'); doner; end;
end;

end;

overlay procedure magic_scool;
procedure doner;
var tempo:str;
begin
repeat
nl; talk(4,'Enter DONE when done:  ');
input(tempo,4);
until tempo='DONE';
end;

procedure reward1;
var bonus,x:integer;
begin
say_saying('Thank you.... the teacher replies, you have successfully completed');
say_saying('your mission.  In return, we shall help out by giving a boost in');
say_saying('Spell Casting abilities....');
for x:=1 to 3 do
 if player.stats[x,8]>0 then begin
player.stats[x,8]:=player.stats[x,8]*2;
bonus:=random(3)+modifier(act_stats[x,2]);
if player.stats[x,8]<0 then player.stats[x,8]:=0;
player.stats[x,8]:=player.stats[x,8]+bonus;
player.stats[x,9]:=player.stats[x,8];
display_char(x);
end;
pausescr;
end;

begin
case player.exemptions[50] of
 0:  begin binc(player.exemptions[50],1); cls; printfile('SAGE5.TXT');
     doner; player.outxact:=60; player.outyact:=15; player.outxmap:=3;
     player.outymap:=2; exitter:=true; end;
 1:
    if player.door_exemps[71]=0 then begin say_saying('Defeat Cassandra First!');
     pausescr; end else begin reward1; printfile('SAGE15.TXT');
     binc(player.exemptions[50],1); doner; end;
 2: if player.door_exemps[74]=0 then begin say_saying('Defeat Jennifer''s Nightmare First!');
    pausescr; end else begin reward1;
    binc(player.exemptions[50],1);
    say_saying('We can no longer teach you anything!  Begone and Defeat Evil!');
    pausescr;
    end;
 3: begin say_saying('Finish the Game!'); pausescr; end;
end;
end;

overlay procedure trainer;
var inpts:str;

  procedure trainmode(whom,conb:integer; modr:byte);
  begin
  player.goldpieces:=player.goldpieces-conb;
  player.experience[whom,1]:=player.experience[whom,1]+(conb div modr);
  say_saying(player.name[whom]+' Gains '+cstr(conb div modr)+' Experience Points!');
  say_saying('Any levels to be gained will occur at the NEXT combat');
  end;

  procedure train;
  var chx:char; cost:byte; txt,tx2:integer;
  begin
  repeat
  for txt:=1 to 3 do
 say_saying(player.name[txt]+' Has '+cstrr(player.experience[txt,1],10)+'/'+cstrr(player.experience[txt,2],10)+
  ' Experience Points');
 say_saying('Who will train (0 to quit training, or 1-3) : ');
  onek(chx,'0123');
  txt:=ord(chx)-48;
if txt>0 then if player.status[txt]=8 then say_saying('That Player may not Train!')
 else begin
  case player.stats[txt,12] of
   1..3 : cost:=2;
   4..7 : cost:=4;
  8..12 : cost:=6;
 13..99 : cost:=10;
  end;
  say_saying('For every '+cstr(cost)+' Gold Pieces I will give you 1 Experience Point');
  say_saying('Your Party has '+cstrr(player.goldpieces,10)+' Gold Pieces!');
  say_saying('How Many Gold Pieces do you wish to contribue:  ');
  input(inpts,4);
  tx2:=value(inpts);
  if (tx2<0) or (tx2>player.goldpieces) then say_saying('Invalid Number or Not Enough Gold')
  else trainmode(txt,tx2,cost);
 end;
  until chx='0';
  inpts:='EXIT';
  end;

begin
clear_space;
say_saying('You come across a small man, sitting comfortablely near a fire');
say_saying('smoking a long pipe.  What may I do for you adventurers? ');
repeat
say_saying('Enter String or "EXIT" to exit: ');
input(inpts,5);
if inpts='TRAIN' then train
 else if inpts<>'EXIT' then begin
   say_saying('The man blows a thick ring of smoke in the air and says,');
   say_saying('"Enough of your foolishness!  Begone!"');
 end;
until inpts='EXIT';
say_saying('Come back real soon now!');
end;

overlay function boating:boolean;
var tester:char; hold,flage:boolean;

procedure set_sail(a,b,c,d: byte; dist,cost:integer);
begin
say_saying('You soon head off to your destination.');
say_saying('The journey is uneventful, you land '+cstr(dist)+' Moves later...');
pausescr;
player.outxmap:=a;
player.outymap:=b;
player.outxact:=c;
player.outyact:=d;
player.total_moves:=player.total_moves+dist;
player.goldpieces:=player.goldpieces-cost;
player.city:=false;
player.outdoor:=true;
player.dungeon:=false;
hold:=true;
end;

begin
hold:=false;
case town_stuff.city_num of
  1: begin
   say_saying('The only place we sail to currently is:');
   say_saying('A) Mammoth -- 50 Gps.');
   say_saying('B) No thanks, I don''t want to travel');
   say_saying('Choice:  ');
   onek(tester,'AB');
   if tester='A' then
   if player.goldpieces>49 then set_sail(4,3,20,17,265,50) else
   say_saying('Sorry you do not have enough Gold to Travel with Us!')
  else say_saying('Sorry you do not to wish to Travel with Us!');
 end;
 2: begin
   say_saying('Places we set sail to are:');
   say_saying('A) Scottsville -- 50 Gps');
   say_saying('B) Stockton    -- 125 Gps');
   say_saying('C) Forget it, I don''t want to travel');
   say_saying('Choice: ');
   onek(tester,'ABC');
   case tester of
    'A': if player.goldpieces>49 then set_sail(2,3,17,12,265,50) else
       say_saying('No money... No travel!');
    'B': if player.goldpieces>124 then set_sail(4,1,48,19,175,125) else
       say_saying('No money... No travel!');
   'C': say_saying('Sorry you do not wish to travel with us!');
   end;
   end;
 3: begin
    say_saying('Place we set sail to are:');
    say_saying('A) Mammoth -- 125 gps');
    if player.door_exemps[74]>0 then flage:=true else flage:=false;
    if flage then say_saying('B) Isle of Dusk -- 500 gps');
    say_saying('N) No thanks, I don''t want to Travel Right Now...');
    if flage then onek(tester,'ABN') else onek(tester,'AN');
     case tester of
      'A' : if player.goldpieces>49 then set_sail(4,3,20,17,265,125);
      'N' : say_saying('Sorry that you do not want to Travel with us!');
      'B' : if player.goldpieces>499 then begin
            say_saying('Isle of Dusk is a VERY dangerous place.');
            say_saying('Rumored to be Haunted and the home of Evil');
            say_saying('We will not be responsible for what happens to you there!');
            say_saying('Still want to go? (Y/N): ');
            onek(tester,'NY');
            if tester='Y' then set_sail(5,5,16,05,200,500) else
            say_saying('You have chosen wisely not go .....');
            end;
    end;
end;
end;
boating:=hold;
end;

overlay procedure whats_so_special(ghi : byte);
var x:byte;

  procedure doner;
  var tempe: str;
  begin
  repeat
  say_saying('Type DONE when Done: ');
  input(tempe,4);
  until tempe='DONE';
  end;

  procedure choicer(var fool:byte);
  var chk:char; temp:boolean;
  begin
  repeat
  temp:=false;
  say_saying('Who will do the action? (0 for None) (0,1-3): ');
  onek(chk,'0123');
  fool:=ord(chk)-48;
  if (fool=0) or (player.status[fool]<>8) then temp:=true;
  if not temp then say_saying('That Player is dead!');
  until temp;
  end;

  procedure karma(t:byte);
  begin
  say_saying('Gulp.... Gulp... Gulp...');
  say_saying(player.name[t]+' feels a warm sensation.  He is blessed by the Gods!');
  say_saying('+3 to Luck!'); pausescr;
  inc(act_stats[t,6],3);
  player.stats[t,6]:=act_stats[t,6];
  end;

  procedure scullcap(t:byte);
  begin
  say_saying('Gulp.... Gulp... Gulp...');
  say_saying('A numing sensation runs acrosses '+player.name[t]+' as he/she begins to');
  say_saying('quite drowsy....  His/Her muscles tighten and contract....');
  say_saying('-2 to Agility -- Scullcap!');
  inc(act_stats[t,4],-2);
  if act_stats[t,4]<0 then act_stats[t,4]:=1;
  player.stats[t,4]:=act_stats[t,4];
  determine_armorclass;
  display_char(t);
  pausescr;
  end;

  procedure gotu_kola(t:byte);
  begin
  say_saying('The liquid has a bitter taste to it as it goes down...');
  say_saying('For a moment, nothing seems to happen, then '+player.name[t]+' eye''s');
  say_saying('begin to lighten.  Knowledge of "higher" things begin to permeate');
  say_saying('his/her being...  +5 to Intelligence');
  inc(act_stats[t,2],5);
  player.stats[t,2]:=act_stats[t,5];
  pausescr;
  end;

  procedure cosmos(t:byte);
  var c:char; tt:byte;
  begin
  tt:=0;
  repeat
  player.total_moves:=player.total_moves-150;
  player.experience[t,1]:=player.experience[t,1]+250;
  say_saying(player.name[t]+' slowly and carefully takes but a sip.  Nothing');
  say_saying('has apparently happened, take another (Y/N): ');
  onek(c,'NY');
  tt:=tt+1;
  if tt>10 then begin
    say_saying('The potion is now empty!');
    c:='N';
    end;
  until (c='N');
  say_saying('The effect suddenly kicks in....  '+player.name[t]+' begins to');
  say_saying('Tremble a bit.  Clutching his head with his/her hands she begins');
  say_saying('to groan.  '+player.name[t]+' falls to ground, but only for a moment');
  say_saying('Something bizarre has happened..... and now '+player.name[t]+' is fine');
  say_saying('once more and doesn''t even remember the potion!');
  pausescr; clear_space;
  say_saying('<Lukas, don''t forget to get rid of this part after we send it out');
  say_saying('I don''t think too many people are gonna like what I did to their');
  say_saying('character... heheheh... P.F.>');
  say_saying('<P.F., hell, if they are that stupid to drink this one in the first');
  say_saying('place, then they deserve what happens.... so we leave it in..hehhe Lukas!>');
  end;

  procedure handouts;
  var whom:byte;
  begin
  pausescr;
  say_saying('You find a rack full of strange potions...');
  say_saying('Enter the number of the person who you want to drink the potion');
  say_saying('The First out of Four is labeled, "Karma"');
  choicer(whom);
  if whom>0 then karma(whom);
  say_saying('In the second vial you find a green bubbling liquid!');
  say_saying('Still quite warm.  The label is burnt and says, "SXXXXCXP"');
  choicer(whom);
  if whom>0 then scullcap(whom);
  say_saying('The next vial is labeled as Gotu Kola');
  say_saying('It is a dark green and is cold, traces of a herb can be seen');
  say_saying('Floating on the top');
  choicer(whom);
  if whom>0 then gotu_kola(whom);
  say_saying('The Final vial contains a black liquid.  It seems to glow in');
  say_saying('with faint yellow sparkles.  The smell is dark and forbidding');
  say_saying('The potion is labeled as "COSMOS"');
  choicer(whom);
  if whom>0 then cosmos(whom);
  pausescr;
  end;

  procedure magic_book;
  begin
  clear_space;
  say_saying('Following a brief search you come across a black book which is ');
  say_saying('very much different from the others.  It glows with a yellow glow');
  say_saying('and is entitled "FORTE"');
  choicer(x);
  if x>0 then begin
  inc(player.stats[x,1],1);
  inc(act_stats[x,1],1);
  say_saying(player.name[x]+' Gains 1 Point of Strength after studying it!');
  player.total_moves:=player.total_moves+100;
  pausescr;
  end;
  end;

  procedure cassandra;
  var chx:char; x:byte;
  begin
  clear_space;
  say_saying('Off the dead body of Cassandra, you grab the scarlet scarf to claim');
  say_saying('your reward with the Magic School....(1000 Exp)');
  for x:=1 to 3 do if player.status[x]<>8 then player.experience[x,1]:=player.experience[x,1]+1000;
  if player.door_exemps[47]<>0 then begin
   say_saying('By the time you finish with the battle the portal is completely gone');
   say_saying('It appears to track down her mysterious visitor, you must take a boat');
   say_saying('up north!'); end
  else begin say_saying('You have moments to decide whether you wish to take the now closing');
  say_saying('Portal.... do you wish to take it? (Y/N): ');
  onek(chx,'NY');
  if chx='Y' then begin
   player.dungeon:=false; player.outdoor:=true; player.outxmap:=4;
   player.outymap:=1; player.outxact:=47; player.outyact:=19;
   exitter:=true; cls; printfile('SAGE14.TxT'); doner; end
   else say_saying('The portal closes....');
  end;
  end;

begin
case ghi of
1: begin
clear_space;
say_saying('After the fray is over, you realize that the shimmering portal has');
say_saying('disappeared!  But on the wizard''s body is a note which says: ');
say_saying('Relmar, in a couple of days, kill off the family and follow me');
say_saying('You know the spell.  Anyhow, need your help in finding the ');
say_saying('Components for the ceremony.  Will meet you in Mammoth soon.');
say_saying('Yes I have the girl, in good spirits');
say_saying('Your knowledge indicates that Mammoth is on the other side');
say_saying('of the continent!'); doner;
end;
2: begin
clear_space;
say_saying('Having defeated the Leader of crew you help release the family');
say_saying('"Be warned, if you haven''t already found Relmar!  He is a wizard');
say_saying('He is somewhere around here!  He and a mysterious cohort have ');
say_saying('Angel... you must find her soon, they spoke of an evil summoning!"');
say_saying('You escort the family out and are reward +250 experience each!');
for x:=1 to 3 do player.experience[x,1]:=player.experience[x,1]+250;
doner;
end;
3:  begin
clear_space;
say_saying('Congratulations!  You have defeated the Kobold Chieftain.  They will');
say_saying('no longer be a detriment to the forests!  Amidst the clutter of the');
say_saying('you find the following note:  ');
say_saying('"We are heading eastward to get a spell component.  I have had');
say_saying('Relmar cast a Portal to Cassandra''s.  Meet us there soon!"');
for x:=1 to 3 do player.experience[x,1]:=player.experience[x,1]+250;
doner;
end;
4:  begin
clear_space;
say_saying('You have defeated the Kobold Shaman.  The forest will thrive once');
say_saying('again now that the part of the evil has died.  On an ornate scroll');
say_saying('You find the following:  "We need your skills as a magic caster.');
say_saying('Follow your chieftain to Jessoe''s Cottage so that we may proceed!"');
for x:=1 to 3 do player.experience[x,1]:=player.experience[x,1]+250;
doner;
end;
5:  magic_book;
6: begin clear_space;
say_saying('Scavenging through the Minotaur''s assortment of trash you find a');
say_saying('small parchment, in red, which states, "Rexx, remember this and throw ');
say_saying('this away after you have read it, I put the portal to see me on the');
say_saying('Left hand side.  Those who use the other one will be expelled from');
say_saying('from the castle -- Cassandra"'); doner; end;
7: cassandra;
8: begin
say_saying('Congratulations!  You have defeated the Demons that were controlling');
say_saying('Jennifer''s dreams!  +1000 Exp each!');
for x:= 1 to 3 do player.experience[x,1]:=player.experience[x,1]+2500;
doner;
end;
9: begin
for x:= 1 to 3 do player.experience[x,1]:=player.experience[x,1]+7000; pausescr;
cls; printfile('SAGE21.TXT'); player.door_exemps[253]:=69; doner; end;
10:handouts;
end;
end;

overlay procedure do_a_ferry;
var chx:char;
begin
clear_space;
say_saying('In a small hut is a skeleton like hermit, he speaks in a raspy voice');
say_saying('Do you wish to Travel back to the mainland, tis free as it is my job');
say_saying('Choice (Y/N): ');
onek(chx,'YN');
if chx='Y' then begin
  say_saying('It its a long journey back to the mainland.  The ride its rough');
  say_saying('and unpleasant.  Atleast it was free....');
  say_saying('You are dropped off a few miles north of Mammoth!');
  exitter:=true; player.outxact:=16; player.outyact:=12;
  player.outxmap:=4; player.outymap:=3;
  pausescr;
  end else say_saying('Too bad.. come back and see me when you are read to leave!');
end;

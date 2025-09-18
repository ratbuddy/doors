function determine_active(a,b,c,d:integer):byte; external;

procedure report_log(temp:string);
var cnt:byte;
begin
for cnt:=2 to 50 do
 data_arr[cnt-1].rep:=data_arr[cnt].rep;
data_arr[50].rep:=temp;
end;

procedure do_name(a:byte);
begin
case a of
  1:goto_ansixy(5,9);
  2:goto_ansixy(5,46);
  3:goto_ansixy(15,9);
  4:goto_ansixy(15,46);
end;
talk(a+1,player.names[a]);
end;

procedure parser(code:byte; namer:helper);
begin
clear_eol(2,1);
goto_ansixy(2,1);
talk(code,namer);
if code<>2 then pausescr;
end;

procedure do_amounts(a:byte);
var savev,yt,yt2,yt3,yt4:byte;
begin
case a of
 1: begin yt:=5; yt2:=7; end;
 2: begin yt:=42; yt2:=7; end;
 3: begin yt:=5; yt2:=17; end;
 4: begin yt:=42; yt2:=17; end;
end;
savev:=yt2;
for yt3:=1 to 5 do begin
  inc(yt,5);
   yt2:=savev;
 for yt4:=1 to 6 do
 if player.curhit[a,yt3,yt4] >0 then
  begin
  if player.curhit[a,yt3,yt4]>10 then goto_ansixy(yt2,yt-2) else
   goto_ansixy(yt2,yt-1);
  talk(2,' '+cstr(player.curhit[a,yt3,yt4])+'/'+cstr(player.maxhit[a,yt3,yt4])+' ');
  inc(yt2);
  end else
    if player.curhit[a,yt3,yt4]<>backup[a,yt3,yt4] then
      begin goto_ansixy(yt2,yt-1); inc(yt2); prompt('     ');
    end else inc(yt2);
end;
for yt:=1 to 4 do
 for yt2:=1 to 5 do
  for yt3:=1 to 6 do
   backup[yt,yt2,yt3]:=player.curhit[yt,yt2,yt3];
end;

procedure save_game;
var shitfile: file of game; t:file; ftable:file of table; tablev:table;
begin
assign(shitfile,'GAME'+player.game_let+'.SAV');
rewrite(shitfile);
write(shitfile,player);
close(shitfile);
assign(t,'MESS'+player.game_let+'.SAV');
rewrite(t,sizeof(data));
blockwrite(t,data_arr,50);
close(t);
if points>0 then begin
 assign(ftable,'TABLE.PIT');
 reset(ftable);
 seek(ftable,usernum-1);
 read(ftable,tablev);
 inc(tablev.points,points);
 tablev.name:=player.names[active];
 close(ftable);
 reset(ftable);
 seek(ftable,usernum-1);
 write(ftable,tablev);
 close(ftable);
end;
end;

function check_for_kill_all:boolean;
var sum,cntsum,cnt2,cnt3:integer; homo:file;
    gamevar:array [1..26] of games;
    gamefile: file of games;
begin
sum:=0;
for cntsum:=1 to 4 do
 if cntsum<>active then
   for cnt2:=1 to 5 do
    for cnt3:=1 to 6 do
     inc(sum,player.curhit[cntsum,cnt2,cnt3]);
if sum=0 then begin parser(8,'Congratulations!  You have Won!!!!');
parser(8,'Your points have gone up by 75!'); inc(points,75); save_game;
check_for_kill_all:=true;
assign(homo,'GAME'+player.game_let+'.SAV'); reset(homo); close(homo); erase(homo);
assign(homo,'MESS'+player.game_let+'.SAV'); reset(homo); close(homo); erase(homo);
assign(gamefile,'GAMES.PIT'); reset(gamefile);
for cntsum:= 1 to 26 do read(gamefile,gamevar[cntsum]);
close(gamefile);
cnt2:=ord(player.game_let)-64;
for cnt3:= 1 to 4 do begin
 gamevar[cnt2].names[cnt3]:='%';
 gamevar[cnt2].usernum[cnt3]:=0;
 end;
rewrite(gamefile);
for cnt2:=1 to 26 do write(gamefile,gamevar[cnt2]);
close(gamefile);
end else check_for_kill_all:=false;
end;

procedure remover(fuckyou:byte);
var ct,scount:byte; gamef:file of games; gamv:array [1..26] of games;
begin
assign(gamef,'GAMES.PIT');
reset(gamef);
for ct:=1 to 26 do read(gamef,gamv[ct]);
close(gamef);
scount:=ord(player.game_let)-64;
gamv[scount].names[fuckyou]:='Dead Player';
rewrite(gamef);
for ct:=1 to 26 do write(gamef,gamv[ct]);
close(gamef);
end;

procedure kill_player(play:byte);
var cnt,cnt2:byte;  sum:integer;
begin
sum:=0;
for cnt:=1 to 5 do
 for cnt2:=1 to 6 do
  inc(sum,player.curhit[play,cnt,cnt2]);
if (sum=0) and (player.names[play]<>'Dead Player')
  then begin
    parser(8,'You have killed all of '+player.names[play]+' Men');
    inc(points,15);
    parser(4,'Chalk up another 15 points, you now have '+cstr(points)+' points!');
    report_log(player.names[active]+' Knocked '+player.names[play]+' Out of the game!');
    remover(play);
  end;
end;

procedure do_smokes(a:byte);
var yt,yt2:byte;
begin
case a of
 1: begin yt:=13; yt2:=4; end;
 2: begin yt:=50; yt2:=4; end;
 3: begin yt:=13; yt2:=14; end;
 4: begin yt:=50; yt2:=14; end;
end;
 goto_ansixy(yt2,yt);
 talk(0,cstr(player.smoked[a]));
 goto_ansixy(yt2,yt+9);
 if player.fires[a]>0 then yt2:=8 else yt2:=0;
 talk(yt2,cstr(player.fires[a]));
end;

procedure draw_new_cards;
var a:byte;
begin
for a:=1 to 6 do
 if player.cards_held[active,a].idnum=0 then begin
   player.cards_held[active,a]:=player.card[player.current_card];
   inc(player.current_card);
   if player.current_card>254 then begin
      player.current_card:=1;
      load_cards;
      report_log('-=  Reshuffled Deck  =-');
   end;
 end;
end;

procedure display_cards;
var count:byte; prstring:string[4];
begin
goto_ansixy(1,1);
for count:= 1 to 6 do begin
  case player.cards_held[active,count].idnum of
       0 : prstring:='NILL';
    1..10: prstring:='HEL'+chr(player.cards_held[active,count].special_num+48);
   11..20 : prstring:='CLDS';
   21..25 : prstring:='DLFR';
   26..55 : prstring:='STM1';
   56..65 : prstring:='STM2';
   66..85 : prstring:='ACD1';
   86..95 : prstring:='ACD2';
   96..101: prstring:='ACD3';
  102..111: prstring:='MAG1';
  112..121: prstring:='MAG2';
  122..131: prstring:='MAG3';
  132..137: prstring:='ICE1';
  138..145: prstring:='ICE2';
  146..155: prstring:='ICE3';
  156..158: prstring:='ICE4';
  159..164: prstring:='FIR2';
  165..172 : prstring:='FIR3';
  173..178 : prstring:='FIR4';
  179..181 : prstring:='FIR5';
  182..184 : prstring:='HERO';
  185..187 : prstring:='ARCH';
  188..191 : prstring:='BON1';
  192      : prstring:='BON2';
  193..199 : prstring:='RSTM';
  200..206 : prstring:='RACD';
  207..211 : prstring:='RMAG';
  212..216 : prstring:='RICE';
  217..219 : prstring:='RFRE';
  220..229 : prstring:='DAM1';
  230..234 : prstring:='DAM2';
  235..244 : prstring:='GOWD';
  245..247 : prstring:='WAL1';
  248      : prstring:='WAL2';
  249..255 : prstring:='CLDS';
end;
talk(7,chr(count+64)+'. '+prstring+'   ');
end;
nl;
end;

procedure discard;
var siq:char; tester:boolean; t:byte;
begin
repeat
if action_played then begin
  parser(8,'Already have played an Action!!!!!'); siq:='0'; end
 else begin
 parser(2,'Which card do you Wish To Discard? (A-F,0 to end): ');
 onek(siq,'ABCDEF0');
 if (siq<>'0') then
  if player.cards_held[active,ord(siq)-64].idnum>0 then
   begin
    parser(2,'Are you sure you want to discard card '+siq+' (Y/N): ');
    if ynq then begin
    player.cards_held[active,ord(siq)-64].idnum:=0;
    display_cards;
    funnel:=true;
    report_log(thisuser.name+' Discarded a Card');
    end
   end else parser(4,'Invalid Discard!');
end;
until siq='0';
end;

function which_player(verb:string; var testr:boolean):byte;
var q:char;
begin
parser(2,'Which Player is going to RECEIVE the '+verb+'? (1-4,0): ');
onek(q,'12340');
if q='0' then testr:=true else testr:=false;
which_player:=ord(q)-48;
end;
{$L PF5ASM.OBJ}
procedure draw_all; external;

procedure reports;
var temp:char; homer,gomer:helper; crapper:byte; x,y:integer;
begin
repeat
parser(2,'Reports: (M)essage Send  (Q)uit  (R)ead All  (S)can: ');
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
        end; pausescr; cls;
        printfile('MAIN.ANS');
        draw_all;
        display_cards;
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

procedure which_group(var x,y:byte; var abort:boolean; temp:string);
var begme:char;
begin
parser(2,'Which Dragon Group do you wish to '+temp+' (1-5,0):  '); abort:=false;
onek(begme,'012345');
x:=ord(begme)-48;
if x=0 then abort:=true;
if not(abort) then begin
  parser(2,'Which Slot (1-6,0):  ');
  onek(begme,'0123456');
  y:=ord(begme)-48;
  if y=0 then abort:=true;
end;
end;

procedure heal(cardno:byte);
var drag,slot:byte; testr:boolean;
begin
which_group(drag,slot,testr,'heal');
if not(testr) then
 if (player.curhit[active,drag,slot]>=player.maxhit[active,drag,slot])
  or (player.curhit[active,drag,slot]=0) then
   parser(8,'Healing Cannot be Done on an Unwounded '+grp_name[drag]+'!')
   else begin
     inc(player.curhit[active,drag,slot],player.cards_held[active,cardno].special_num);
     if player.curhit[active,drag,slot]>player.maxhit[active,drag,slot] then
       player.curhit[active,drag,slot]:=player.maxhit[active,drag,slot];
     do_amounts(active);
     player.cards_held[active,cardno].idnum:=0;
     display_cards;
     report_log('Played a Heal +'+cstr(player.cards_held[active,cardno].special_num)
       +' on '+grp_name[drag]+'!');
   end;
end;

function anybody_there(drag:byte):byte;
var t2,sum:byte;
begin
sum:=0;
for t2:=1 to 6 do
 inc(sum,player.curhit[active,drag,t2]);
anybody_there:=sum;
end;

procedure fire_card(cardno:byte);
var deter,tot,slot,drag,dragfir:byte; testr:boolean;
begin
case player.cards_held[active,cardno].idnum of
  26..65 : dragfir:=1;
  66..101: dragfir:=2;
 102..131: dragfir:=3;
 132..158: dragfir:=4;
 159..181: dragfir:=5;
end;
deter:=which_player('Firing',testr);
if (deter=active) or (testr) then parser(8,'Aborted!') else begin
  which_group(drag,slot,testr,'Fire at');
  if not(testr) then tot:=anybody_there(dragfir);
  if testr then parser(8,'Aborted!') else
   if player.curhit[deter,drag,slot]=0 then parser(8,'Non-Existant Target!')
    else if action_play[deter]>1 then parser(8,'Too Many shots fired on that Target!')
     else if tot=0 then parser(8,'You don''t have a '+grp_name[drag]+' to fire with!')
      else if random(6)+1<=player.smoked[deter] then begin
        parser(4,'Fire Missed due to Smoke opposing cloud cover!');
        report_log('Fire Missed due to '+player.names[deter]+'s Clouds!');
        player.cards_held[active,cardno].idnum:=0;
        inc(action_play[deter]);
        display_cards;
        action_played:=true;
       end else if random(6)+1<=player.smoked[active] then begin
         action_played:=true;
         parser(4,'Your fire goes awry due to your cloud Cover!');
         report_log('Fire Missed due to '+player.names[active]+' Cloud Cover!');
         player.cards_held[active,cardno].idnum:=0;
         inc(action_play[deter]);
         display_cards;
       end else begin
       if player.cards_held[active,cardno].special_num>player.curhit[deter,drag,slot]
        then player.curhit[deter,drag,slot]:=0 else
         dec(player.curhit[deter,drag,slot],player.cards_held[active,cardno].special_num);
 parser(4,'You have damaged a '+grp_name[drag]+' for '+cstr(player.cards_held[active,cardno].special_num)+
  ' Points of Damage!');
 report_log('Damaged a '+grp_name[drag]+' for '+cstr(player.cards_held[active,cardno].special_num)+' Points of Damage!');
 if (player.curhit[deter,drag,slot]=0) or (player.fires[deter]>player.curhit[deter,drag,slot]-1)
  then begin
     player.curhit[deter,drag,slot]:=0;
     inc(points,player.maxhit[deter,drag,slot]);
     parser(4,'You Killed it!  Congrats!  You now have '+cstr(points)+' points for this turn!');
     report_log('Killed it!  Now has '+cstr(points)+' points for this turn!');
     kill_player(deter);
  end;
  do_amounts(deter);
  inc(action_play[deter]);
  player.cards_held[active,cardno].idnum:=0;
  display_cards;
  action_played:=true;
  end;
 end;
 end;


procedure do_smoke(cardno:byte);
var deter:byte; testr:boolean;
begin
deter:=which_player('Cloud',testr);
if not (testr) then
   if player.smoked[deter]>3 then parser(2,'Too Cloudy to play on '+player.names[deter]+'! (Max is 3)')
    else begin
     inc(player.smoked[deter]);
     do_smokes(deter);
     player.cards_held[active,cardno].idnum:=0;
     display_cards;
     report_log('Played a Cloud card on '+player.names[deter]+'!');
     action_played:=true;
   end;
end;

procedure remove_fire_wall(cardno:byte);
begin
if player.fires[active]<1 then parser(8,'No Need to play a Remove Fire Wall at this Point!')
 else begin
   player.cards_held[active,cardno].idnum:=0;
   display_cards;
   player.fires[active]:=0;
   do_smokes(active);
   report_log(player.names[active]+' Removed his fire wall!');
   action_played:=true;
 end;
end;

procedure bonushps(cardno:byte);
var drag,slot:byte; testr:boolean;
begin
which_group(drag,slot,testr,'Bonus Hit Points');
if not(testr) then
 if player.curhit[active,drag,slot]=0 then parser(8,'No Dragon There!')
  else begin
  inc(player.maxhit[active,drag,slot],player.cards_held[active,cardno].special_num);
  inc(player.curhit[active,drag,slot],player.cards_held[active,cardno].special_num);
  do_amounts(active);
  report_log(player.names[active]+' gave bonus Hit Points to '+grp_name[drag]+' Slot '+cstr(slot));
  player.cards_held[active,cardno].idnum:=0;
  display_cards;
   action_played:=true;
 end;
end;

procedure gow(cardno:byte);
var testr:boolean; deter:byte;
begin
deter:=which_player('Gust of Wind',testr);
if not(testr) then
  if player.smoked[deter]<1 then parser(8,'No Clouds to blow away....')
    else begin
      player.cards_held[active,cardno].idnum:=0;
      display_cards;
      player.smoked[deter]:=0;
      do_smokes(deter);
      report_log('Played a Gust Of Wind on '+player.names[deter]+'!');
      action_played:=true;
    end;
end;

procedure reinf(cardno:byte);
var t,slot,maxhit:byte;
begin
t:=1;
case player.cards_held[active,cardno].idnum of
 193..199:begin slot:=1; maxhit:=3; end;
 200..206:begin slot:=2; maxhit:=5; end;
 207..211:begin slot:=3; maxhit:=6; end;
 212..216:begin slot:=4; maxhit:=8; end;
 217..219:begin slot:=5; maxhit:=10; end;
end;
while t<7 do begin
  if player.curhit[active,slot,t]=0 then begin
    player.curhit[active,slot,t]:=maxhit;
    player.maxhit[active,slot,t]:=maxhit;
    t:=100;
    do_amounts(active);
    report_log(player.names[active]+' Got a Reinforcement for the '+grp_name[slot]+'!');
    player.cards_held[active,cardno].idnum:=0;
    display_cards;
  end else inc(t);
end;
if t=7 then parser(8,'Not enough room to place that reinforcement!');
end;

procedure damage(cardno:byte);
var deter,drag,slot:byte; testr:boolean;
begin
deter:=which_player('Damage',testr);
if (testr) or (deter=active) then parser(8,'Aborted!') else begin
   which_group(drag,slot,testr,'Damage');
   if not(testr) then
    if player.curhit[deter,drag,slot]=player.maxhit[deter,drag,slot]
     then parser(4,'Dragon must be damaged before using it on it!') else
      if player.curhit[deter,drag,slot]<1 then parser(4,'No Dragon to Damage there.....')
      else begin
       if player.curhit[deter,drag,slot]<=player.cards_held[active,cardno].special_num
        then player.curhit[deter,drag,slot]:=0 else
         dec(player.curhit[deter,drag,slot],player.cards_held[active,cardno].special_num);
        if player.curhit[deter,drag,slot]<=player.fires[deter] then
         player.curhit[deter,drag,slot]:=0;
       report_log('Played a Damage Card on '+player.names[deter]);
       parser(4,'Damaged it for '+cstr(Player.cards_held[active,cardno].special_num)+' Points of Damage!');
       if player.curhit[deter,drag,slot]=0 then begin
         parser(4,'You have Killed the '+grp_name[drag]+'!');
         inc(points,player.maxhit[deter,drag,slot]);
         parser(4,'You now have '+cstr(Points)+' points this turn!');
         report_log('Killed a '+grp_name[drag]+'!');
         kill_player(deter);
       end;
       player.cards_held[active,cardno].idnum:=0;
       display_cards;
       do_amounts(deter);
       action_played:=true;
       end;
   end;
end;

procedure wof(cardno:byte);
var cnt,cnt2,deter:byte; testr:boolean;
begin
deter:=which_player('Wall of Fire',testr);
if (testr) or (deter=active) then parser(4,'Aborted!') else
  if player.fires[deter]>3 then parser(4,'Maximum Fire wall already in effect!')
 else begin
 parser(2,'Are you sure you want to use a Wall of fire on '+player.names[deter]+' (Y/N): ');
 if ynq then begin
   inc(player.fires[deter],player.cards_held[active,cardno].special_num);
   do_smokes(deter); testr:=false;
   player.cards_held[active,cardno].idnum:=0;
   display_cards;
   report_log('Played a Fire Wall on '+player.names[deter]);
   action_played:=true;
   for cnt:=1 to 5 do
    for cnt2:= 1 to 6 do
     if (player.curhit[deter,cnt,cnt2]<=player.fires[deter])
      and (player.curhit[deter,cnt,cnt2]>0) then begin
       testr:=true;
       parser(4,'Killed a '+grp_name[cnt]+' got '+cstr(player.maxhit[deter,cnt,cnt2])+' Points!');
     report_log('Killed a '+grp_name[cnt]+' got '+cstr(player.maxhit[deter,cnt,cnt2])+' Points!');
     inc(points,player.maxhit[deter,cnt,cnt2]);
     player.curhit[deter,cnt,cnt2]:=0;
     player.maxhit[deter,cnt,cnt2]:=0;
     end;
   if testr then begin
     do_amounts(deter);
     parser(3,'From your killings you now have '+cstr(points)+'!');
     kill_player(deter);
   end;
  end;
  end;
end;

procedure heroism(cardno:byte);
var deter,drag,slot,chance:byte; testr:boolean;
strnam:string[18];
begin
case player.cards_held[active,cardno].idnum of
 182..184:begin strnam:='Knight Attack'; chance:=3; end;
 else begin strnam:='Archer Attack'; chance:=2; end;
end;
deter:=which_player(strnam,testr);
if (testr) or (deter=active) then parser(8,'Aborted!') else begin
  which_group(drag,slot,testr,strnam);
  if testr then parser(8,'Aborted!')
   else if player.curhit[deter,drag,slot]=0 then parser(7,'Non-Existant dragon!')
    else if (random(6)+1)>chance then begin
      player.cards_held[active,cardno].idnum:=0;
      display_cards;
      parser(4,strnam+' Attack failed!');
      report_log(strnam+' Attack failed against '+player.names[deter]);
    end else begin
     parser(4,'You have Killed it!');
     parser(4,'You have earned '+cstr(player.maxhit[deter,drag,slot])+' Points!');
     inc(points,player.maxhit[deter,drag,slot]);
     parser(4,'You now have '+cstr(points)+' Points!');
     report_log('Used a '+strnam+' Attack on '+player.names[deter]+' and Killed it!');
     player.curhit[deter,drag,slot]:=0;
     player.maxhit[deter,drag,slot]:=0;
     do_amounts(deter);
     player.cards_held[active,cardno].idnum:=0;
     display_cards;
     kill_player(deter);
     action_played:=true;
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
       1..10 : heal(result);
       11..20 : do_smoke(result);
       21..25 : remove_fire_wall(result);
      26..181 : fire_card(result);
     182..187 : heroism(result);
      188..192 : bonushps(result);
      193..219 : reinf(result);
      220..234 : damage(result);
      235..244 : gow(result);
      245..248 : wof(result);
      249..255 : do_smoke(result);
      end;
end;

procedure begin_play;
var chx:char;
begin
repeat
funnel:=false;
parser(2,'Choices: (DEPR,?): ');
onek(chx,'DEPR?');
case chx of
  'D' : discard;
  'E' : begin parser(2,'Are you sure? (Y/N): ');
        funnel:=ynq; end;
  'P' : play_card;
  'R' : reports;
  '?' : parser(3,'D = Discard / E = End Turn /  P = Play a Card /  R = Reports');
end;
until funnel;
end;


procedure load_data;
var t:file; cnt:byte;
begin
assign(t,'MESS'+player.game_let+'.SAV');
{$I-} reset(t,sizeof(data)); {$I+}
IF IOResult<>0 then
  for cnt:=1 to 50 do data_arr[cnt].rep:='No Message!'
else begin
  blockread(t,data_arr,50);
  close(t);
end;
end;

function check_for_all_gone:boolean;
var cnt,cnt2,cnt3:byte;
begin
check_for_all_gone:=false;
cnt:=0;
for cnt2:=1 to 5 do
 for cnt3:=1 to 6 do cnt:=cnt+player.curhit[active,cnt2,cnt3];
  if cnt=0 then begin
     parser(8,'You have been Destroyed!'); check_for_all_Gone:=true; end;
end;

procedure check_for_gusts;
var cnt:byte;
begin
for cnt:=1 to 4 do
 if (player.smoked[cnt]>0) and (random(12)+1 = 1) then begin
   player.smoked[cnt]:=0;
   parser(4,player.names[cnt]+' got a Natural Gust of Wind');
   report_log(player.names[cnt]+' got a Natural Gust of Wind');
   do_smokes(cnt);
 end;
end;

procedure two_player;
var numpla,cnt,cnt2,cnt3:byte; sum:integer;
begin
numpla:=0;
for cnt:=1 to 4 do begin
sum:=0;
for cnt2:=1 to 5 do
 for cnt3:=1 to 6 do inc(sum,player.curhit[cnt,cnt2,cnt3]);
  if sum>0 then inc(numpla);
end;
if numpla=2 then begin
  parser(8,'Note Only Two People left in the Game!!!! - Unlimited Attacks');
  for cnt:=1 to 4 do action_play[cnt]:=-10;
end;
end;

procedure start_play;
var tmp,tmp2,tmp3:byte;
begin
for tmp:=1 to 4 do action_play[tmp]:=0;
message:=1; points:=0; action_played:=false;
grp_name[1]:='Steam Dragon';
grp_name[2]:='Acid Dragon';
grp_name[3]:='Magic Dragon';
grp_name[4]:='Ice Dragon';
grp_name[5]:='Fire Dragon';
printfile('MAIN.ANS');
load_data;
for tmp:=1 to 4 do
 for tmp2:=1 to 5 do
  for tmp3:=1 to 6 do
   backup[tmp,tmp2,tmp3]:=player.curhit[tmp,tmp2,tmp3];
active:=determine_active(player.usernumber[4],player.usernumber[3],player.usernumber[2],player.usernumber[1]);
draw_new_cards;
draw_all;
display_cards;
check_for_gusts;
if not(check_for_all_gone) then begin
   report_log(player.names[active]+' is Playing!');
   two_player;
   begin_play;
   if not (check_for_kill_all) then save_game;
end;
end;

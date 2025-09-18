unit initial;
interface
uses dos,common;
procedure starter;
implementation

procedure starter;
 CONST MAXPLAY = 8;
 type table = record
  name : string[25];
  wins : word;
  losses : word;
  involved_in : char;
 end;
var count:integer;
    table_var : table;
    table_file : file of table;
    y,x:integer;
    chx:char; okay:boolean;
    game_file : file of gamer;
    game_var : array [1..26] of gamer;

   procedure get_high;
   var hi_file:file of integer;
   begin
   assign(hi_file,'HIGH.PIT');
   {$I-} reset(hi_file); {$I+}
   if IOResult=0 then begin
      read(hi_file,high);
      close(hi_file);
   end else begin
      talknl(8,'Have your sysop run CPLAYERS.EXE before playing!');
      pausescr;
      return;
   end;
   end;

   procedure listings;
    var count:word; sex:byte;
    begin
    cls; sex:=2;
    assign(table_file,'TABLE.PIT');
    reset(table_file);
    talknl(7,'NAME                             WINS        LOSSES');
    for count:=1 to high do begin
       read(table_file,table_var);
       if table_var.name[1]<>'%' then begin
       talk(4,table_var.name);
       goto_ansixy(sex,34);
       talk(7,cstr(table_var.wins));
       goto_ansixy(sex,47);
       talknl(7,cstr(table_var.losses));
       inc(sex);
       if sex>22 then begin pausescr; cls; nl; sex:=2; end;
       end;
    end;
    close(table_file);
    end;

procedure load_gamefile;
var ct:byte;
begin
assign(game_file,'GAMES.PIT');
reset(game_File);
for ct:=1 to 26 do
  read(game_File,game_var[ct]);
close(game_file);
end;

procedure sign_up;
var count,cnt2,cnt3:byte;
begin
count:=1;
repeat
  talk(3,chr(count+64)+'.  People Playing: ');
  cnt2:=0;
  for cnt3:=1 to 4 do
   if game_var[count].name[cnt3,1]<>'%' then inc(cnt2);
  talk(7,cstr(cnt2)+'              ');
  talk(3,chr(count+65)+'.  People Playing: ');
  cnt2:=0;
  for cnt3:=1 to 4 do
   if game_var[count+1].name[cnt3,1]<>'%' then inc(cnt2);
   talknl(7,cstr(cnt2));
count:=count+2;
until count>26;
end;

 function full(t:integer) : boolean;
  var h,c:byte;
  begin
  c:=0;
  for h:=1 to 4 do
    if game_var[t].name[h]<>'%' then inc(c);
  if c=4 then full:=true else full:=false;
  end;

procedure check_it_out(gh:char);
  var locx:integer;
  function already_signed :boolean;
  var a1,a2 : byte; testbit:byte; test:boolean;
  begin
  testbit:=0; test:=false;
  for a1:=1 to 26 do
   for a2:=1 to 4 do
    if thisuser.name=game_var[a1].name[a2] then inc(testbit);
  if testbit=MAXPLAY then test:=true;
  for a2:=1 to 4 do
   if thisuser.name=game_var[ord(gh)-64].name[a2] then test:=true;
   already_signed:=test;
  end;

  procedure select_race(fv,fv2:integer);
  var chrac: char; temp:byte;
  begin
  printfile('RACES.ANS');
  goto_ansixy(18,4);
  talk(3,'Which Race (1-3): ');
  onek(chrac,'123');
  temp:=ord(chrac)-48;
  game_var[fv].races[fv2]:=temp;
  end;

  procedure put_in_game(loca:integer);
  var a1:byte; test1:boolean;
  begin
  a1:=1; test1:=false;
  repeat
  if game_var[loca].name[a1]='%' then begin
    test1:=true;
    select_race(loca,a1);
    game_var[loca].name[a1]:=thisuser.name;
  end;
  inc(a1);
  until test1;
  assign(game_file,'GAMES.PIT');
  rewrite(game_file);
  for a1:=1 to 26 do write(game_file,game_var[a1]);
  close(game_file);
  assign(table_file,'TABLE.PIT');
  reset(table_file);
  seek(table_file,usernum-1);
  read(table_file,table_var);
  table_var.name:=thisuser.name;
  reset(table_file);
  seek(table_file,usernum-1);
  write(table_file,table_var);
  close(table_file);
  end;

begin
locx:=ord(gh)-64;
if full(locx) then talknl(8,'Hey, that Game is Full!')
 else if already_signed then talknl(8,'You are already in that Game or Involved in more than '+cstr(MAXPLAY)+ 'Games!')
  else begin put_in_game(locx); talknl(4,'Added into Game'); end;
end;


procedure which_one;
var hacker: char;
begin
talk(5,'Which Game do you want to Sign up For (A-Z,0): ');
onek(hacker,'ABCDEFGHIJKLMNOPQRSTUVWXYZ0');
if hacker<>'0' then check_it_out(hacker);
end;

function load_game(a:char):boolean;
var filer: file of game;
begin
assign(filer,'GAME'+a+'.SAV');
{$I-} reset(filer); {$I+}
if IOresult=0 then begin
  load_game:=true;
  read(filer,player);
  close(filer);
end else load_game:=false;
end;

procedure do_init_amounts(op:byte);
begin
case player.races[op] of
 1: begin player.amounts[op,1]:=12;
          player.amounts[op,2]:=6;
          player.amounts[op,3]:=4;
          player.amounts[op,4]:=2;
          player.amounts[op,5]:=1;
    end;
 2: begin player.amounts[op,1]:=8;
          player.amounts[op,2]:=10;
          player.amounts[op,3]:=3;
          player.amounts[op,4]:=3;
          player.amounts[op,5]:=1;
    end;
 3: begin player.amounts[op,1]:=4;
          player.amounts[op,2]:=20;
          player.amounts[op,3]:=1;
          player.amounts[op,4]:=5;
          player.amounts[op,5]:=1;
    end;
end;
end;


procedure play_game;
var tx1,tx2,tx3,tx4:byte;
begin
talk(3,'Which Game do you want to Play (A-Z): ');
onek(chx,'ABCDEFGHIJKLMNOPQRSTUVWXYZ');
tx1:=ord(chx)-64;
  for tx2:=1 to 4 do
    if game_var[tx1].name[tx2]=thisuser.name then begin
       tx4:=0;
       for tx3:=1 to 4 do
        if game_var[tx1].name[tx3]<>'%' then inc(tx4);
       if tx4=4 then
         if load_game(chr(tx1+64)) then okay:=true
          else begin
           player.game_let:=chr(tx1+64);
           load_cards;
           okay:=true;
           for tx4:=1 to 4 do begin
             player.races[tx4]:=game_var[tx1].races[tx4];
             player.names[tx4]:=game_var[tx1].name[tx4];
             do_init_amounts(tx4);
             for tx3:=1 to 5 do begin
              player.smoked[tx4,tx3]:=0;
              player.ranges[tx4,tx3]:=0;
              player.terrains[tx4,tx3]:=0;
              player.current_card:=1;
             end;
             for tx3:=1 to 6 do
              player.cards_held[tx4,tx3].idnum:=0;
           end;
          end;
    end;
if not okay then talknl(8,'You are not Involved in any Ready Games');
end;

procedure remove_self;
var a1,tx1,tx2:byte; tempor:char; tag:boolean;
begin
tag:=false;
talk(4,'Which Game do you want to Remove Yourself From (A-Z,0): ');
onek(tempor,'ABCDEDEFGHIJKLMNOPQRSTUVWXYZ0');
if tempor<>'0' then begin
talk(4,'Are you Sure you Want to Remove Yourself? (Y/N):  ');
tx1:=ord(tempor)-64;
if ynq then
  for tx2:=1 to 4 do
  if game_var[tx1].name[tx2]=thisuser.name then
  if full(tx1) then talknl(8,'You can''t Remove Yourself, that game is in play!')
   else begin
    tag:=true;
    talknl(5,'Removed!');
    game_var[tx1].name[tx2]:='%';
    assign(game_file,'GAMES.PIT');
    rewrite(game_file);
    for a1:=1 to 26 do write(game_file,game_var[a1]);
    close(game_file);
  end;
end;
if not tag then talknl(8,'We could not find you in that game!');
end;

procedure view_folks;
var tx,ty:byte; chx:char;
begin
talk(2,'Which Game Interests you? (A-Z, 0 for None): ');
onek(chx,'ABCDEFGHIJKLMNOPQRSTUVWXYZ0');
if chx<>'0' then begin
  tx:=ord(chx)-64;
  for ty:=1 to 4 do
   if game_var[tx].name[ty]<>'%' then begin
      talk(3,game_var[tx].name[ty]);
      case game_var[tx].races[ty] of
         1:talknl(0,' Is an Elven Army');
         2:talknl(0,' Is a Human Army');
         3:talknl(0,' Is a Dwarven Army');
      end;
  end else talknl(0,'Slot '+cstr(ty)+' Is Empty!');
end;
end;

procedure get_info;
var tx3,tx4,a,b:byte; w,x,y,z:word;
begin
getdate(w,x,y,z);
for a:=1 to 26 do
 for b:=1 to 4 do
  if game_var[a].name[b]=thisuser.name then
   if (game_var[a].laston[b,1]=w) and (game_var[a].laston[b,2]=x)
    and (game_var[a].laston[b,3]=y) then talknl(7,'Have already played in Game '+chr(a+64)+' for Today')
     else begin
      tx4:=0;
      for tx3:=1 to 4 do
       if game_var[a].name[tx3]<>'%' then inc(tx4);
      if tx4=4 then
       talknl(7,'You can play in Game '+chr(a+64))
     else talknl(5,'You are in Game '+chr(a+64)+' but only '+cstr(tx4)+' people are in it!');
     end;
end;

procedure docs;
var oxi:char;

procedure printer2(filename:helper);
var cnt:byte; shitfile: file of char;  lok:char; aborter:boolean;
function quittme:boolean;
var eatme:helper;
begin
nl;
talk(3,'Type CONT to Continue or DONE if Done Reading: ');
input(eatme,4);
if eatme='DONE' then quittme:=true else quittme:=false;
nl; ansic(0);
end;

begin
cls; cnt:=1; ansic(0);
aborter:=false;
assign(shitfile,filename);
reset(shitfile);
while (not EOF(shitfile)) and (aborter=false) do begin
   read(shitfile,lok);
   prompt(lok);
   if lok=chr(13) then inc(cnt);
   if cnt=22 then begin aborter:=quittme; cnt:=1; end;
end;
close(shitfile);
end;


begin
repeat
talknl(5,'Instruction Reading');
talknl(7,'It is recommended that you Download the Documents');
talknl(7,'in the distributable file, the file to extract is');
talknl(7,'PIT4DOCS.ZIP');
talknl(4,'A)  Install Documents');
talknl(4,'B)  Starting Documents');
talknl(4,'C)  Play Documents');
talknl(4,'D)  Story Documents');
talknl(4,'E)  Quit Reading Documents');
talk(3,'Choice:  ');
onek(oxi,'ABCDE');
case oxi of
  'A' : printer2('Install.Doc');
  'B' : printer2('Start.Doc');
  'C' : printer2('Play.Doc');
  'D' : printer2('Story.Doc');
end;
until oxi='E'
end;

procedure do_date(monger:char);
var tx1,tx2:byte; a,b,c,d: word; var temp:helper;
begin
 tx1:=ord(monger)-64;
 for tx2:=1 to 4 do
   if game_var[tx1].name[tx2]=thisuser.name then begin
     getdate(a,b,c,d);
     if (game_var[tx1].laston[tx2,1]<>a) or (game_var[tx1].laston[tx2,2]<>b)
       or (game_var[tx1].laston[tx2,3]<>c) then begin
          game_var[tx1].laston[tx2,1]:=a;
          game_var[tx1].laston[tx2,2]:=b;
          game_var[tx1].laston[tx2,3]:=c;
          assign(game_file,'GAMES.PIT');
          rewrite(game_file);
          for d:=1 to 26 do write(game_file,game_var[d]);
          close(game_file);
       end else begin
          talknl(8,'You have already played today!');
          talk(5,'Enter Password to Play Again: ');
          input(temp,20);
          if temp='DOGGIE' then okay:=true else okay:=false;
       end;
     end;
end;

procedure iport;
var f:text;
    i:helper;
    n:integer;
begin
assign(f,paramstr(1));
{$I-} reset(f); {$I+}
if (ioresult=0) and (paramcount>0) then begin
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
talknl(8,'%1 file (chain.txt) not found.');
halt;
end;
hangup:=false;
timeon:=timer;
if usernum>high then begin
  talknl(8,'Sorry you can''t play, ask the Sysop to run CPLAYER.EXE');
  pausescr;
  return;
  end;
end;


begin
cls;
load_gamefile;
get_high;
iport;
repeat
nl; nl;
talknl(5,'Welcome to Pit Fiend Volume IV, '+thisuser.name+'!');
get_info;
talknl(2,'Choices:');
talknl(2,'(D)ocumentation');
talknl(2,'(L)istings of People');
talknl(2,'(Q)uit');
talknl(2,'(P)lay your Game');
talknl(2,'(R)emove Self From an UNPLAYED game');
talknl(2,'(S)ign Up for a Game');
talknl(2,'(V)iew People in a Game');
talk(7,'Choice:  ');
okay:=false;
onek(chx,'DLPRSQV');
case chx of
  'D' :docs;
  'L' :listings;
  'P' :play_game;
  'R' :remove_self;
  'S' :begin sign_up; which_one; end;
  'Q' :return;
  'V' :view_folks;
end;
if okay then do_date(chx);
until okay;
end;

end.
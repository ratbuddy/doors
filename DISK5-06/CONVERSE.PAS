{$O+}
unit converse;
interface
uses common,globals;
var shit : integer;
procedure intro;
procedure conversationz;
procedure boating;
implementation

procedure intro;
var oneq : char;
begin
printfile('INTRO.ANS');
talk(5,'Do you Still Wish to Play This Adventure? (Y/N)'); ansic(3);
onek(oneq,'NY'); if oneq='N' then halt else cls;
end;

procedure conversationz;
var conver_file : file of conversation;
    person_chat : conversation; ch1, ch2 : char; dummy,choicint:integer;
    all_done    : boolean; chwrd:string[2];
    inputter    : helper; inputteri : integer;
procedure display_people;
var xxx : file of char; temps: char; filename:string[12];
begin
filename:='            '; filename:='CONVER'+chr(town_stuff.city_num+48)+'.LST';
assign(xxx,filename); reset(xxx); temps:='x';
while temps <> '*' do begin
   read(xxx,temps);
   if temps <> '*' then write(temps);
end;
close(xxx);
end;

procedure load_person(personn:integer);
var filename:string[12];
begin
filename:='            '; filename:='CONVER'+chr(town_stuff.city_num+48)+'.CON';
assign(conver_file,filename); reset(conver_file); seek(conver_file, personn-1);
read(conver_file,person_chat); close(conver_file);
end;
procedure descrip;
begin
say_saying(person_chat.name+':');
say_saying(person_chat.descrip);
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
var amnt:helper; sht,amnti : integer; txtt : byte;
begin
say_saying('You have '+cstrr(player.goldpieces,10)+' Gold Pieces');
say_saying('How Much do you give to the Beggar? -->');
ansic(4); input(amnt,4);
val(amnt,amnti,sht);
if amnti> player.goldpieces then begin
   say_saying('You will pay for your stupidity!  Teasing a Beggar!');
    if player.goldpieces > 0 then
      player.goldpieces:=player.goldpieces *0.5;
  end else begin
    player.goldpieces:=player.goldpieces-amnti;
    for txtt:=1 to 3 do
      if person_chat.keys[txtt]='GIVE' then begin tellem(txtt); txtt:=9; end;
    if (amnti> 100) and (amnti< 1001) then player.experience:=player.experience+(amnti div 2);
    if (amnti>1002) then player.equiparmor.magical:=player.equiparmor.magical+1;
  end;
end;

procedure inquiry;
var inq : helper;
    txt : byte;
begin
say_saying('Inquiry -->');
ansic(4); input(inq,12);
if (inq='GIVE') and (person_chat.name='BEGGAR') then give_doe else
   for txt:=1 to 3 do
      if inq=person_chat.keys[txt] then begin tellem(txt); txt:=9; end
       else if txt=3 then say_saying(person_chat.dunno);
end;

procedure lets_talk(person_num : integer);
var ggg: char; fag: boolean;
begin
load_person(person_num);
if dialcnt > 18 then begin
     clear_space; dialcnt:=18; end; descrip; fag:=false;
repeat
say_saying('Choice (D)escribe, (G)reet, (I)nquire, (L)eave: ');
ansic(4); onek(ggg,'DGIL');
  case ggg of
    'D' : descrip;
    'G' : say_saying(person_chat.greeter);
    'I' : inquiry;
    'L' : begin say_saying(person_chat.later); fag:=true; end;
  end;
until fag;
end;

begin
cls; display_people; all_done:=false;
repeat
  say_saying('Choice (0 to Leave): ');
  input(inputter,2);
val(inputter,choicint,shit);
   if choicint=0 then all_done:=true else
     begin
       if (choicint < 0) or (choicint > town_stuff.num_conv) then say_saying('INVALID INPUT!')
       else lets_talk(choicint);
     end;
until all_done;
end;

procedure boating;
begin
if town_stuff.port = false then talknl(8,'This Town is Not A port --> no boating!')
  else
case town_stuff.city_num of
   1:  if player.door_exemps[22]=1 then talknl(5,'Sorry, not built in yet') else
        talknl(6,'We are sorry, travel is very dangerous at the time, we fear to set sail');
end;
end;

end.
program cchat;
CONST MAX_CON = 4;
type conversation = record
   name:string[20];
   descrip:string[60];
   greeter:string[72];
   later:string[72];
   keys : array [1..3] of string[12];
   resp_keys:array[1..3,1..3] of string[72];
   dunno:string[72];
   toggles:array[1..3] of byte;
   end;

var talker : array[1..MAX_CON] of conversation;
             intt,litx,subx : byte;
    talk_file : file of conversation;
    a,b,c,d,counter: integer;
begin
for intt:=1 to MAX_CON do begin
   talker[intt].name:='                                ';
   talker[intt].descrip:='                                                              ';
   talker[intt].greeter:='                                                                        ';
   talker[intt].later:='                                                                     ';
   for litx:=1 to 3 do begin
    talker[intt].keys[litx]:='                        ';
      for subx:= 1 to 3 do
        talker[intt].resp_keys[litx,subx]:='%                                                                        ';
   talker[intt].toggles[litx]:=1;
   end;
   talker[intt].dunno:='                                                                      ';
end;

talker[1].name:='LYLE';
TALKER[1].DESCRIP:='MAYOR OF LONE PINE';
TALKER[1].LATER:='YOU ARE ALWAYS WELCOME IN LONE PINE';
TALKER[1].DUNNO:='I''M SORRY, I CAN''T HELP YOU WITH THAT';
TALKER[1].GREETER:='WELCOME TO "LONE PINE"';
TALKER[1].KEYS[1]:='LONE PINE';
TALKER[1].RESP_KEYS[1,1]:='YES, YOU STOP BY ON TROUBLED TIMES!  IT SEEMS THAT THE';
TALKER[1].RESP_KEYS[1,2]:='DWARVES HAVE STOLEN OUR CHILDREN AWAY WITH THE EVIL SOMA';
TALKER[1].RESP_KEYS[1,3]:='THAT POISONS THEIR MINDS AND BODIES!  "XEVIOR" IS THE CAUSE';
TALKER[1].KEYS[3]:='XEVIOR';
TALKER[1].RESP_KEYS[3,1]:='YES, HE AND HIS EVIL DWARVES CAUSED OUR CHILDREN TO STEAL';
TALKER[1].RESP_KEYS[3,2]:='AND ROB, THEY HAVE BECOME BANDITS.  THE KNIGHTS WILL NOT HURT';
TALKER[1].RESP_KEYS[3,3]:='THEM, BUT ARE AFTER SEEKING HIS "LOCATION".';
TALKER[1].KEYS[2]:='LOCATION';
TALKER[1].RESP_KEYS[2,1]:='WELL I AM SURE THAT IF YOU "THREATEN" A MAN CALLED O''LAFF';
TALKER[1].RESP_KEYS[2,2]:='HE WILL DIVULGE THE SECRET OF ITS LOCATION!';

talker[2].name:='GOOD LADY LAFORE';
TALKER[2].DESCRIP:='WOMAN -- CRYING';
TALKER[2].LATER:='SAVE THE CHILDREN';
TALKER[2].DUNNO:='SNIFF....';
TALKER[2].GREETER:='THE DWARVES HAVE TAKEN MY "DAUGHTER"';
TALKER[2].KEYS[1]:='DAUGHTER';
TALKER[2].RESP_KEYS[1,1]:='OH LORAINE!  SHE WAS SO INNOCENT!  ONE OF THE EVIL DWARVES''S';
TALKER[2].RESP_KEYS[1,2]:='SPIES TRICKED HER INTO TRYING SOMA... IT ROBBED HER OF HER "SOUL"!';
TALKER[2].KEYS[3]:='SOUL';
TALKER[2].RESP_KEYS[3,1]:='SO INNOCENT AND PRETTY.  SHE IS NOW A HARLOT LIFE WITH';
TALKER[2].RESP_KEYS[3,2]:='THE OTHER FILTH IN THE "CITY" BEYOND THE HILLS.  ONLY NOT USING';
TALKER[2].RESP_KEYS[3,3]:='SOMA WILL SHE REGAIN HER SOUL!';
TALKER[2].KEYS[2]:='CITY';
TALKER[2].RESP_KEYS[2,1]:='THEY CALL IT SOMAVALE... FOR OBVIOUS REASONS....HOW EVIL!';

talker[3].name:='JIMSON';
TALKER[3].DESCRIP:='MAN WITH DARK EYES';
TALKER[3].LATER:='GOOD-BYE';
TALKER[3].DUNNO:='HMM....';
TALKER[3].GREETER:='LOOKS LIKE TOUGH "TIMES" ARE AHEAD!';
TALKER[3].KEYS[1]:='TIMES';
TALKER[3].RESP_KEYS[1,1]:='WELL CERTAINLY FOR THE CHILDREN OF SOMAVALE!  THEY SAY THE';
TALKER[3].RESP_KEYS[1,2]:='KNIGHTS OF SCOTTSVILLE WILL MARCH UPON "SOMAVALE" SOON!';
TALKER[3].KEYS[3]:='SOMAVALE';
TALKER[3].RESP_KEYS[3,1]:='WHAT A SICK NAME!  ACK!  MY SON IS AMONGST THEM!  YOU MUST';
TALKER[3].RESP_KEYS[3,2]:='STOP THE PROBLEM!  BY KILLING "XEVIOR", HE MAKES THE CRYSTALS';
TALKER[3].RESP_KEYS[3,3]:='USED IN FERTILIZING SOMA!';
TALKER[3].KEYS[2]:='XEVIOR';
TALKER[3].RESP_KEYS[2,1]:='A MOST FEARSOME WARRIOR... HE AND HIS BANDITS ARE ATTACKING';
TALKER[3].RESP_KEYS[2,2]:='EVERYWHERE!';

talker[4].name:='KNIGHT LEXUS';
TALKER[4].DESCRIP:='FEMALE KNIGHT OF SCOTTSVILLE';
TALKER[4].LATER:='KEEP THY HONOR!';
TALKER[4].DUNNO:='I''LL CHECK THAT OUT!';
TALKER[4].GREETER:='JUST KEEPING THE "ORDER" AROUND HERE';
TALKER[4].KEYS[1]:='ORDER';
TALKER[4].RESP_KEYS[1,1]:='YES, A KNIGHT MUST LEARN RESTRAINT!  LAST NIGHT THE TOWNFOLK';
TALKER[4].RESP_KEYS[1,2]:='HERE WERE ATTACKED AND RAIDED BY THEIR OWN "CHILDREN"';
TALKER[4].KEYS[3]:='CHILDREN';
TALKER[4].RESP_KEYS[3,1]:='WELL THEY CAME AND RAIDED LOOKING FOR MONEY TO BUY MORE SOMA';
TALKER[4].RESP_KEYS[3,2]:='FROM THAT EVIL XEVIOR!  HE WILL BE STOPPED BY THE KNIGHTS OR';
TALKER[4].RESP_KEYS[3,3]:='PERHAPS BY YOU!';
TALKER[4].KEYS[2]:='LADY LINDA';
TALKER[4].RESP_KEYS[2,1]:='SHE IS MOST RADIANT AND MOST ADMIRABLE.  SHE WOULD''VE STOPPED';
TALKER[4].RESP_KEYS[2,2]:='PIT FIEND AND XEVIOR BY NOW!  HONOR HER ALWAYS.  PERHAPS IF YOU';
TALKER[4].RESP_KEYS[2,3]:='DEFEAT XEVIOR YOU CAN VISIT HER GRAVE SITE, I''VE HEARD RUMORS....';

for counter:=1 to MAX_CON do
   for a:=1 to 3 do
    for b:=1 to length(talker[counter].keys[a]) do
     talker[counter].keys[a][b]:=chr(ord(talker[counter].keys[a][b])+b);

for counter:=1 to MAX_CON do
   for a:=1 to 3 do
    for c:=1 to 3 do
     for b:=1 to length(talker[counter].resp_keys[a][c]) do
     talker[counter].resp_keys[a][c][b]:=chr(ord(talker[counter].resp_keys[a][c][b])+b);

assign(talk_file,'conver8.con');
rewrite(talk_file);
for counter:=1 to MAX_CON do write(talk_file,talker[counter]);
close(talk_file);
end.
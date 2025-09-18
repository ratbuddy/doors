program cpotions;
const MAXINFILE = 9;
type potions = record
       idnum : byte;
       name : string[30];
       cost : real;
      end;
var spotion : array [1..MAXINFILE] of potions;
   x : byte; g1 : file of potions;

begin
for x:=1 to MAXINFILE do spotion[x].idnum:=x;
for x:=1 to MAXINFILE do spotion[x].name:='                                                                   ';
spotion[1].name :='POTION OF HEALING'; spotion[1].cost:= 25;
spotion[2].name :='POTION OF SPELLPOINT RESTORATION';  spotion[2].cost:= 25;
spotion[3].name :='PIT FIEND STRENGTH'; spotion[3].cost:=75;
spotion[4].name :='LORAN INTELLIGENCE'; spotion[4].cost:=75;
spotion[5].name :='ELVEN LUCK';         spotion[5].cost:=75;
spotion[6].name :='THIEVING DEXTERITY'; spotion[6].cost:=75;
spotion[7].name :='TIME DELAY (+50 MOVES)'; spotion[7].cost:=500;
spotion[8].name :='LIQUID SPEED';     spotion[8].cost:=500;
spotion[9].name :='X-RAY VISION';     spotion[9].cost:=100;
assign(g1,'POTIONS.DAT'); rewrite(g1);
for x:=1 to MAXINFILE do write(g1,spotion[x]);
close(g1); end.
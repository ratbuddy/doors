program create_dungeon_room2;
const MAXROOM = 36;
type combat_init= array [1..4] of byte;
type helper=string[75];
type
 dun_room = record
  dxmap:byte;
  dymap:byte;
  dlocx:byte;
  dlocy:byte;
  whatkind:combat_init;
  howmany:combat_init;
  toggler: byte;
  special: byte;
  food   : byte;
  scroll : boolean;
  scrollsay : helper;
  amount:integer;
  itemnum:byte;
  quant:byte;
 end;

var dung_arr : array [1..MAXROOM] of dun_room;
    dung_file : file of dun_room;
    count,count2 : integer;

begin
{TOGGLER 47 is for RED RUBY!!!!!!! NOTE THIS NOTE THIS!!!!}
{TOGGLER 48 is for SOMA Killing IMPORTANT!}

with dung_arr[1] do begin
  dxmap:=1;
  dymap:=2;
  dlocx:=21;
  dlocy:=06;
  whatkind[1]:=37;
  whatkind[2]:=29;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=3;
  howmany[2]:=2;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 49;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Several Red Armored Men Grab Their weapons at your approach!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[2] do begin
  dxmap:=1;
  dymap:=2;
  dlocx:=19;
  dlocy:=19;
  whatkind[1]:=37;
  whatkind[2]:=29;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=4;
  howmany[2]:=2;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 50;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Several Red Armored Men Grab Their weapons at your approach!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[3] do begin
  dxmap:=1;
  dymap:=2;
  dlocx:=19;
  dlocy:=20;
  whatkind[1]:=37;
  whatkind[2]:=29;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=4;
  howmany[2]:=2;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 50;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Several Red Armored Men Grab Their weapons at your approach!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[4] do begin
  dxmap:=1;
  dymap:=3;
  dlocx:=39;
  dlocy:=14;
  whatkind[1]:=37;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=6;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 51;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Several Men Sit around and are Playing cards!';
  amount:=54;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[5] do begin
  dxmap:=1;
  dymap:=3;
  dlocx:=41;
  dlocy:=12;
  whatkind[1]:=37;
  whatkind[2]:=37;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=4;
  howmany[2]:=5;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 52;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Men dressed in red drinking ale and playing darts!';
  amount:=124;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[6] do begin
  dxmap:=1;
  dymap:=3;
  dlocx:=21;
  dlocy:=17;
  whatkind[1]:=37;
  whatkind[2]:=38;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=5;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 53;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='The red warriors are practicing with their weapons.';
  amount:=25;
  itemnum:=15;
  quant:=1;
end;

with dung_arr[7] do begin
  dxmap:=1;
  dymap:=3;
  dlocx:=29;
  dlocy:=14;
  whatkind[1]:=37;
  whatkind[2]:=37;
  whatkind[3]:=37;
  whatkind[4]:=50;

  howmany[1]:=3;
  howmany[2]:=3;
  howmany[3]:=3;
  howmany[4]:=0;
  toggler:= 54;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Several red warriors lie resting in their cots.';
  amount:=00;
  itemnum:=00;
  quant:=0;
end;

with dung_arr[8] do begin
  dxmap:=1;
  dymap:=3;
  dlocx:=22;
  dlocy:=05;
  whatkind[1]:=26;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=1;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 55;
  special:= 6;
  food   := 7;
  scroll := false;
  scrollsay:='The leader of Cassandra''s forces, a Minotaur!';
  amount:=752;
  itemnum:=4;
  quant:=2;
end;

with dung_arr[9] do begin
  dxmap:=1;
  dymap:=4;
  dlocx:=31;
  dlocy:=07;
  whatkind[1]:=37;
  whatkind[2]:=06;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=8;
  howmany[2]:=4;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 56;
  special:= 0;
  food   := 15;
  scroll := false;
  scrollsay:='The mess hall, with Goblin Servants!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[10] do begin
  dxmap:=1;
  dymap:=4;
  dlocx:=24;
  dlocy:=12;
  whatkind[1]:=37;
  whatkind[2]:=06;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=8;
  howmany[2]:=4;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 56;
  special:= 0;
  food   := 15;
  scroll := false;
  scrollsay:='The mess hall, with Goblin Servants!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[11] do begin
  dxmap:=1;
  dymap:=4;
  dlocx:=26;
  dlocy:=17;
  whatkind[1]:=06;
  whatkind[2]:=06;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=7;
  howmany[2]:=5;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 57;
  special:= 0;
  food   := 4;
  scroll := false;
  scrollsay:='In the kitchen are several Goblin workers trying to cook a meal';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[12] do begin
  dxmap:=1;
  dymap:=4;
  dlocx:=29;
  dlocy:=17;
  whatkind[1]:=06;
  whatkind[2]:=06;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=7;
  howmany[2]:=5;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 57;
  special:= 0;
  food   := 4;
  scroll := false;
  scrollsay:='In the kitchen are several Goblin workers trying to cook a meal';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[13] do begin
  dxmap:=1;
  dymap:=4;
  dlocx:=34;
  dlocy:=16;
  whatkind[1]:=06;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 58;
  special:= 0;
  food   := 67;
  scroll := false;
  scrollsay:='A pair of Goblins are taking stock of the food!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[14] do begin
  dxmap:=1;
  dymap:=4;
  dlocx:=47;
  dlocy:=13;
  whatkind[1]:=37;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 59;
  special:= 0;
  food   := 00;
  scroll := false;
  scrollsay:='A pair of Red Warriors are taking stock of the equipment.';
  amount:=0;
  itemnum:=39;
  quant:=8;
end;

with dung_arr[15] do begin
  dxmap:=1;
  dymap:=4;
  dlocx:=35;
  dlocy:=09;
  whatkind[1]:=06;
  whatkind[2]:=06;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=7;
  howmany[2]:=8;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 60;
  special:= 0;
  food   := 00;
  scroll := false;
  scrollsay:='Living in Squalor Conditions are several Goblins!';
  amount:=0;
  itemnum:=00;
  quant:=00;
end;

with dung_arr[16] do begin
  dxmap:=1;
  dymap:=4;
  dlocx:=37;
  dlocy:=12;
  whatkind[1]:=37;
  whatkind[2]:=38;
  whatkind[3]:=37;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=3;
  howmany[3]:=2;
  howmany[4]:=0;
  toggler:= 61;
  special:= 0;
  food   := 00;
  scroll := false;
  scrollsay:='More men resting on cots and talking, while others play dice.';
  amount:=25;
  itemnum:=00;
  quant:=00;
end;


{No rooms for LVL215.DNG}

{No rooms for LVL216.DNG}

with dung_arr[17] do begin
  dxmap:=1;
  dymap:=7;
  dlocx:=40;
  dlocy:=10;
  whatkind[1]:=60;
  whatkind[2]:=60;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=1;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 62;
  special:= 0;
  food   := 00;
  scroll := false;
  scrollsay:='Several motionless women guard a room full of glass vials!';
  amount:=00;
  itemnum:=43;
  quant:=06;
end;

with dung_arr[18] do begin
  dxmap:=1;
  dymap:=7;
  dlocx:=37;
  dlocy:=09;
  whatkind[1]:=60;
  whatkind[2]:=60;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=1;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 63;
  special:= 0;
  food   := 00;
  scroll := false;
  scrollsay:='Several motionless women guard a room full of glass vials!';
  amount:=00;
  itemnum:=44;
  quant:=03;
end;

with dung_arr[19] do begin
  dxmap:=1;
  dymap:=7;
  dlocx:=33;
  dlocy:=08;
  whatkind[1]:=60;
  whatkind[2]:=60;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=1;
  howmany[2]:=2;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 64;
  special:= 0;
  food   := 00;
  scroll := false;
  scrollsay:='Several motionless women guard a room full of glass vials!';
  amount:=00;
  itemnum:=41;
  quant:=08;
end;

with dung_arr[20] do begin
  dxmap:=1;
  dymap:=7;
  dlocx:=29;
  dlocy:=07;
  whatkind[1]:=60;
  whatkind[2]:=60;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=1;
  howmany[2]:=2;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 65;
  special:= 0;
  food   := 00;
  scroll := false;
  scrollsay:='Several motionless women guard a room full of glass vials!';
  amount:=00;
  itemnum:=36;
  quant:=12;
end;

with dung_arr[21] do begin
  dxmap:=1;
  dymap:=7;
  dlocx:=25;
  dlocy:=06;
  whatkind[1]:=60;
  whatkind[2]:=60;
  whatkind[3]:=60;
  whatkind[4]:=50;

  howmany[1]:=1;
  howmany[2]:=1;
  howmany[3]:=1;
  howmany[4]:=0;
  toggler:= 66;
  special:= 0;
  food   := 00;
  scroll := false;
  scrollsay:='Several motionless women guard a room full of glass vials!';
  amount:=00;
  itemnum:=37;
  quant:=18;
end;

with dung_arr[22] do begin
  dxmap:=1;
  dymap:=7;
  dlocx:=39;
  dlocy:=16;
  whatkind[1]:=10;
  whatkind[2]:=10;
  whatkind[3]:=37;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=2;
  howmany[3]:=1;
  howmany[4]:=0;
  toggler:= 67;
  special:= 0;
  food   := 00;
  scroll := false;
  scrollsay:='Several figures in black garb arrange various laboratory items!';
  amount:=00;
  itemnum:=34;
  quant:=1;
end;

with dung_arr[23] do begin
  dxmap:=1;
  dymap:=7;
  dlocx:=47;
  dlocy:=13;
  whatkind[1]:=10;
  whatkind[2]:=10;
  whatkind[3]:=37;
  whatkind[4]:=50;

  howmany[1]:=3;
  howmany[2]:=1;
  howmany[3]:=1;
  howmany[4]:=0;
  toggler:= 68;
  special:= 0;
  food   := 00;
  scroll := false;
  scrollsay:='Dark robed figures are busy working on various potions in the lab!';
  amount:=00;
  itemnum:=40;
  quant:=8;
end;

with dung_arr[24] do begin
  dxmap:=1;
  dymap:=8;
  dlocx:=34;
  dlocy:=15;
  whatkind[1]:=25;
  whatkind[2]:=60;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=1;
  howmany[2]:=2;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 69;
  special:= 0;
  food   := 00;
  scroll := false;
  scrollsay:='This room is full of books, apparently Cassandra''s Study!';
  amount:=00;
  itemnum:=00;
  quant:=0;
end;

with dung_arr[25] do begin
  dxmap:=1;
  dymap:=8;
  dlocx:=34;
  dlocy:=10;
  whatkind[1]:=38;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=1;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 70;
  special:= 0;
  food   := 00;
  scroll := false;
  scrollsay:='An enormous bedroom, a lone guard watches over it!';
  amount:=2535;
  itemnum:=1;
  quant:=2;
end;

with dung_arr[26] do begin
  dxmap:=1;
  dymap:=8;
  dlocx:=47;
  dlocy:=13;
  whatkind[1]:=76;
  whatkind[2]:=31;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=1;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 71;
  special:= 7;  {Cassandra}
  food   := 20;
  scroll := true;
  scrollsay:='An enormous bedroom, a lone guard watches over it!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[27] do begin
  dxmap:=1;
  dymap:=9;
  dlocx:=24;
  dlocy:=11;
  whatkind[1]:=77;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=1;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 73;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Lying upon a mound of treasure is a small white dragon!';
  amount:=4419;
  itemnum:=3;
  quant:=3;
end;
{********* BELOW IS THE NIGHTMARE DUNGEON   *************}

with dung_arr[28] do begin
  dxmap:=3;
  dymap:=3;
  dlocx:=52;
  dlocy:=04;
  whatkind[1]:=62;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;  {A pair of demons are controlling the dream!}
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 74;
  special:= 8;  {Night mare demons!}
  food   := 0;
  scroll := false;
  scrollsay:='Meditating are a pair of nasty demons...!';
  amount:=2300;
  itemnum:=35;  {a ring of Magic Shield!}
  quant:=0;
end;

with dung_arr[29] do begin
  dxmap:=3;
  dymap:=3;
  dlocx:=03;
  dlocy:=20;
  whatkind[1]:=13;
  whatkind[2]:=03;
  whatkind[3]:=13;
  whatkind[4]:=03;

  howmany[1]:=5;  
  howmany[2]:=10;
  howmany[3]:=5;
  howmany[4]:=10;
  toggler:= 75;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A whole group of skeletons wait in ambush!';
  amount:=0;
  itemnum:=0;  {a ring of Magic Shield!}
  quant:=0;
end;

with dung_arr[30] do begin
  dxmap:=3;
  dymap:=3;
  dlocx:=58;
  dlocy:=20;
  whatkind[1]:=61;
  whatkind[2]:=61;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;  
  howmany[2]:=3;
  howmany[3]:=50;
  howmany[4]:=50;
  toggler:= 76;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A series of nasty birds with fangs wait here!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[31] do begin
  dxmap:=3;
  dymap:=3;
  dlocx:=74;
  dlocy:=20;
  whatkind[1]:=59;
  whatkind[2]:=22;
  whatkind[3]:=23;
  whatkind[4]:=50;

  howmany[1]:=2;  
  howmany[2]:=1;
  howmany[3]:=1;
  howmany[4]:=50;
  toggler:= 77;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A witch is in here making a nasty brew!';
  amount:=0;
  itemnum:=43;
  quant:=8;
end;

with dung_arr[32] do begin
  dxmap:=3;
  dymap:=3;
  dlocx:=19;
  dlocy:=21;
  whatkind[1]:=55;
  whatkind[2]:=55;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;  
  howmany[2]:=3;
  howmany[3]:=50;
  howmany[4]:=50;
  toggler:= 78;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='No wonder there were so many cobwebs around here!';
  amount:=0;
  itemnum:=00;
  quant:=0;
end;

with dung_arr[33] do begin
  dxmap:=3;
  dymap:=4;
  dlocx:=57;
  dlocy:=06;
  whatkind[1]:=3;
  whatkind[2]:=4;
  whatkind[3]:=53;
  whatkind[4]:=50;

  howmany[1]:=7;  
  howmany[2]:=6;
  howmany[3]:=2;
  howmany[4]:=50;
  toggler:= 79;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Little graves litter the room when they burst open....';
  amount:=0;
  itemnum:=00;
  quant:=0;
end;

with dung_arr[34] do begin
  dxmap:=3;
  dymap:=4;
  dlocx:=55;
  dlocy:=08;
  whatkind[1]:=3;
  whatkind[2]:=4;
  whatkind[3]:=53;
  whatkind[4]:=50;

  howmany[1]:=7;  
  howmany[2]:=6;
  howmany[3]:=2;
  howmany[4]:=50;
  toggler:= 79;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Little graves litter the room when they burst open....';
  amount:=0;
  itemnum:=00;
  quant:=0;
end;

with dung_arr[35] do begin
  dxmap:=3;
  dymap:=4;
  dlocx:=19;
  dlocy:=07;
  whatkind[1]:=60;
  whatkind[2]:=60;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;  
  howmany[2]:=3;
  howmany[3]:=50;
  howmany[4]:=50;
  toggler:= 80;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Several guardians are in here!';
  amount:=0;
  itemnum:=00;
  quant:=0;
end;

with dung_arr[36] do begin
  dxmap:=3;
  dymap:=4;
  dlocx:=24;
  dlocy:=08;
  whatkind[1]:=60;
  whatkind[2]:=60;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;  
  howmany[2]:=3;
  howmany[3]:=50;
  howmany[4]:=50;
  toggler:= 80;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Several guardians are in here!';
  amount:=0;
  itemnum:=00;
  quant:=0;
end;

assign(dung_file,'DUNRM2.PIT');
rewrite(dung_file);
for count:=1 to MAXROOM do
  write(dung_file,dung_arr[count]);
close(dung_file);
end.


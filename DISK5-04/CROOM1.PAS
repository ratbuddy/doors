program create_dungeon_room1;
const MAXROOM = 66;
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

with dung_arr[1] do begin
  dxmap:=1;
  dymap:=1;
  dlocx:=41;
  dlocy:=11;
  whatkind[1]:=4;
  whatkind[2]:=3;
  whatkind[3]:=3;
  whatkind[4]:=50;

  howmany[1]:=6;
  howmany[2]:=4;
  howmany[3]:=3;
  howmany[4]:=0;
  toggler:= 1;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='The creeking door opens up to a shadowy and dank crypt!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[2] do begin
  dxmap:=1;
  dymap:=1;
  dlocx:=48;
  dlocy:=10;
  whatkind[1]:=4;
  whatkind[2]:=3;
  whatkind[3]:=3;
  whatkind[4]:=50;

  howmany[1]:=6;
  howmany[2]:=4;
  howmany[3]:=3;
  howmany[4]:=0;
  toggler:= 1;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='The creeking door opens up to a shadowy and dank crypt!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[3] do begin
  dxmap:=1;
  dymap:=1;
  dlocx:=33;
  dlocy:=18;
  whatkind[1]:=4;
  whatkind[2]:=3;
  whatkind[3]:=10;
  whatkind[4]:=50;

  howmany[1]:=4;
  howmany[2]:=4;
  howmany[3]:=1;
  howmany[4]:=0;
  toggler:= 2;
  special:= 1;
  food   := 0;
  scroll := false;
  scrollsay:='A Heavy Reinforced door opens into a room with an open teleportal!';
  amount:=123;
  itemnum:=37;
  quant:=5;
end;

with dung_arr[4] do begin
  dxmap:=1;
  dymap:=2;
  dlocx:=41;
  dlocy:=9;
  whatkind[1]:=4;
  whatkind[2]:=3;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=4;
  howmany[2]:=5;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 3;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Rotting already, the door easily falls open where you find...';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[5] do begin
  dxmap:=1;
  dymap:=2;
  dlocx:=47;
  dlocy:=8;
  whatkind[1]:=4;
  whatkind[2]:=3;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=4;
  howmany[2]:=5;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 3;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Rotting already, the door easily falls open where you find...';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[6] do begin
  dxmap:=1;
  dymap:=2;
  dlocx:=24;
  dlocy:=12;
  whatkind[1]:=7;
  whatkind[2]:=7;
  whatkind[3]:=28;
  whatkind[4]:=50;

  howmany[1]:=4;
  howmany[2]:=5;
  howmany[3]:=2;
  howmany[4]:=0;
  toggler:= 4;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Tools and weapons lie about this room... a storage room!';
  amount:=0;
  itemnum:=2;
  quant:=1;
end;

with dung_arr[7] do begin
  dxmap:=1;
  dymap:=2;
  dlocx:=15;
  dlocy:=12;
  whatkind[1]:=4;
  whatkind[2]:=7;
  whatkind[3]:=2;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=3;
  howmany[3]:=2;
  howmany[4]:=0;
  toggler:= 5;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A rotting door easily falls inward revealing its occupents!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[8] do begin
  dxmap:=1;
  dymap:=2;
  dlocx:=16;
  dlocy:=12;
  whatkind[1]:=4;
  whatkind[2]:=7;
  whatkind[3]:=2;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=3;
  howmany[3]:=2;
  howmany[4]:=0;
  toggler:= 5;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A rotting door easily falls inward revealing its occupents!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[9] do begin
  dxmap:=1;
  dymap:=2;
  dlocx:=11;
  dlocy:=10;
  whatkind[1]:=4;
  whatkind[2]:=7;
  whatkind[3]:=2;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=3;
  howmany[3]:=2;
  howmany[4]:=0;
  toggler:= 5;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A rotting door easily falls inward revealing its occupents!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[10] do begin
  dxmap:=1;
  dymap:=3;
  dlocx:=22;
  dlocy:=8;
  whatkind[1]:=5;
  whatkind[2]:=5;
  whatkind[3]:=2;
  whatkind[4]:=50;

  howmany[1]:=1;
  howmany[2]:=1;
  howmany[3]:=2;
  howmany[4]:=0;
  toggler:= 6;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='The barn door clamors inward revealing thieves fighting Spiders!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[11] do begin
  dxmap:=1;
  dymap:=3;
  dlocx:=34;
  dlocy:=10;
  whatkind[1]:=5;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=3;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 7;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='The old house doors fall forward, surprising the Thieves!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[12] do begin
  dxmap:=1;
  dymap:=3;
  dlocx:=39;
  dlocy:=10;
  whatkind[1]:=5;
  whatkind[2]:=5;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=3;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 7;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Having heard you come from the back, a group of nasty men attack!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[13] do begin
  dxmap:=1;
  dymap:=3;
  dlocx:=58;
  dlocy:=12;
  whatkind[1]:=5;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=3;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 8;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='The backdoor leads into the kitchen where some haggard men are eating!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[14] do begin
  dxmap:=1;
  dymap:=4;
  dlocx:=53;
  dlocy:=13;
  whatkind[1]:=5;
  whatkind[2]:=9;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=3;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 9;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A group of men are playing cards, it appears you disturbed them!';
  amount:=25;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[15] do begin
  dxmap:=1;
  dymap:=4;
  dlocx:=53;
  dlocy:=11;
  whatkind[1]:=5;
  whatkind[2]:=9;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=3;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 9;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A group of men are playing cards, it appears you disturbed them!';
  amount:=25;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[16] do begin
  dxmap:=1;
  dymap:=4;
  dlocx:=49;   {COME BACK TO ME}
  dlocy:=10;
  whatkind[1]:=29;
  whatkind[2]:=35;
  whatkind[3]:=5;
  whatkind[4]:=50;

  howmany[1]:=4;
  howmany[2]:=1;
  howmany[3]:=3;
  howmany[4]:=0;
  toggler:= 10;
  special:= 2;
  food   := 0;
  scroll := false;
  scrollsay:='Tied up in rope are several people who are surrounded by.....';
  amount:=125;
  itemnum:=36;
  quant:=8;
end;

with dung_arr[17] do begin
  dxmap:=1;
  dymap:=4;
  dlocx:=41;
  dlocy:=11;
  whatkind[1]:=5;
  whatkind[2]:=9;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 11;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A group of men are resting it appears you disturbed them!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;


with dung_arr[18] do begin
  dxmap:=1;
  dymap:=4;
  dlocx:=41;
  dlocy:=13;
  whatkind[1]:=5;
  whatkind[2]:=9;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 11;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A group of men are resting it appears you disturbed them!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[19] do begin
  dxmap:=3;
  dymap:=3;
  dlocx:=44;
  dlocy:=13;
  whatkind[1]:=1;
  whatkind[2]:=1;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=3;
  howmany[2]:=3;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 12;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A few Kobolds are sorting through some mining tools!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[20] do begin
  dxmap:=3;
  dymap:=3;
  dlocx:=45;
  dlocy:=19;
  whatkind[1]:=1;
  whatkind[2]:=34;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=4;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 13;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A small group of Kobolds are resting, tools lay beside them.';
  amount:=12;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[21] do begin
  dxmap:=3;
  dymap:=3;
  dlocx:=49;
  dlocy:=19;
  whatkind[1]:=1;
  whatkind[2]:=34;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=4;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 13;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A small group of Kobolds are resting, tools lay beside them.';
  amount:=12;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[22] do begin
  dxmap:=3;
  dymap:=4;
  dlocx:=18;
  dlocy:=10;
  whatkind[1]:=1;
  whatkind[2]:=34;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=7;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 14;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A group of Kobolds huddle around their leader, who is telling a story.';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[23] do begin
  dxmap:=3;
  dymap:=4;
  dlocx:=27;
  dlocy:=10;
  whatkind[1]:=1;
  whatkind[2]:=7;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=4;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 15;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='The door leads to the weapon storage, where 4 Kobolds take stock.';
  amount:=0;
  itemnum:=7; {Bow +1!}
  quant:=1;
end;

with dung_arr[24] do begin
  dxmap:=3;
  dymap:=4;
  dlocx:=28;
  dlocy:=10;
  whatkind[1]:=1;
  whatkind[2]:=7;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=4;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 15;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='The door leads to the weapon storage, where 4 Kobolds take stock.';
  amount:=0;
  itemnum:=7; {Bow +1!}
  quant:=1;
end;

with dung_arr[25] do begin
  dxmap:=3;
  dymap:=4;
  dlocx:=8;
  dlocy:=12;
  whatkind[1]:=1;
  whatkind[2]:=28;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=7;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 16;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='The Jackal Kennel.  What a Stench!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[26] do begin
  dxmap:=3;
  dymap:=4;
  dlocx:=61;
  dlocy:=13;
  whatkind[1]:=1;
  whatkind[2]:=34;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=5;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 17;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='The Training Room, and now some real practice!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[27] do begin
  dxmap:=3;
  dymap:=4;
  dlocx:=63;
  dlocy:=17;
  whatkind[1]:=1;
  whatkind[2]:=34;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=5;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 17;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='The Training Room, and now some real practice!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;


with dung_arr[28] do begin
  dxmap:=3;
  dymap:=4;
  dlocx:=10;
  dlocy:=14;
  whatkind[1]:=1;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=5;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 18;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Barracks, several Kobolds resting after a tough day.';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[29] do begin
  dxmap:=3;
  dymap:=4;
  dlocx:=16;
  dlocy:=14;
  whatkind[1]:=1;
  whatkind[2]:=28;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=3;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 19;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Several Kobolds tease a starving Jackal!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;


with dung_arr[30] do begin
  dxmap:=3;
  dymap:=4;
  dlocx:=49;
  dlocy:=15;
  whatkind[1]:=1;
  whatkind[2]:=7;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 20;
  special:= 0;
  food   := 12;
  scroll := false;
  scrollsay:='A Pair of Kobolds are preparing some food and feeding a fat rat';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[31] do begin
  dxmap:=3;
  dymap:=4;
  dlocx:=28;
  dlocy:=18;
  whatkind[1]:=34;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 21;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Two Kobold Leaders sit on their mats discussing evil plans';
  amount:=25;
  itemnum:=39;
  quant:=2;
end;

with dung_arr[32] do begin
  dxmap:=3;
  dymap:=4;
  dlocx:=44;
  dlocy:=18;
  whatkind[1]:=1;
  whatkind[2]:=1;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=3;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 22;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A trio of Kobolds sit here drinking water while another urinates in it';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[33] do begin
  dxmap:=3;
  dymap:=4;
  dlocx:=54;
  dlocy:=19;
  whatkind[1]:=1;
  whatkind[2]:=7;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=1;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 20;
  special:= 0;
  food   := 12;
  scroll := false;
  scrollsay:='A Pair of Kobolds are preparing some food and feeding a fat rat';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[34] do begin
  dxmap:=3;
  dymap:=5;
  dlocx:=58;
  dlocy:=6;
  whatkind[1]:=34;
  whatkind[2]:=1;
  whatkind[3]:=5;
  whatkind[4]:=50;

  howmany[1]:=1;
  howmany[2]:=2;
  howmany[3]:=1;
  howmany[4]:=0;
  toggler:= 23;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='You have apparently disturbed a very important meeting here.';
  amount:=56;
  itemnum:=40;
  quant:=1;
end;

with dung_arr[35] do begin
  dxmap:=3;
  dymap:=5;
  dlocx:=44;
  dlocy:=9;
  whatkind[1]:=1;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 24;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A nice comfortable, warm spring, the bathing site.';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[36] do begin
  dxmap:=3;
  dymap:=5;
  dlocx:=33;
  dlocy:=14;
  whatkind[1]:=34;
  whatkind[2]:=5;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=2;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 25;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A group of men and Kobolds ask for passes to see the Chief!';
  amount:=32;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[37] do begin
  dxmap:=3;
  dymap:=5;
  dlocx:=29;
  dlocy:=15;
  whatkind[1]:=34;
  whatkind[2]:=5;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=2;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 25;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A group of men and Kobolds ask for passes to see the Chief!';
  amount:=132;
  itemnum:=0;
  quant:=0;
end;


with dung_arr[38] do begin
  dxmap:=3;
  dymap:=5;
  dlocx:=24;
  dlocy:=18;
  whatkind[1]:=34;
  whatkind[2]:=5;
  whatkind[3]:=35;
  whatkind[4]:=50;

  howmany[1]:=1;
  howmany[2]:=1;
  howmany[3]:=1;
  howmany[4]:=0;
  toggler:= 26;
  special:= 3; {Hey dude its the Captain}
  food   := 0;
  scroll := false;
  scrollsay:='A Huge Chief sits comfortably with his best men';
  amount:=235;
  itemnum:=31;
  quant:=1;
end;

with dung_arr[39] do begin
  dxmap:=4;
  dymap:=5;
  dlocx:=14;
  dlocy:=5;
  whatkind[1]:=1;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=3;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 27;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A trio of Kobolds sit praying here at the Kobold Temple.';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[40] do begin
  dxmap:=4;
  dymap:=5;
  dlocx:=21;
  dlocy:=5;
  whatkind[1]:=1;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=3;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 27;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A trio of Kobolds sit praying here at the Kobold Temple.';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;


with dung_arr[41] do begin
  dxmap:=4;
  dymap:=5;
  dlocx:=38;
  dlocy:=11;
  whatkind[1]:=36;
  whatkind[2]:=1;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=1;
  howmany[2]:=3;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 28;
  special:= 4; {Shaman}
  food   := 0;
  scroll := false;
  scrollsay:='Several Kobolds stand chanting out hymms of evil';
  amount:=240;
  itemnum:=13;
  quant:=1;
end;

with dung_arr[42] do begin
  dxmap:=4;
  dymap:=5;
  dlocx:=34;
  dlocy:=13;
  whatkind[1]:=36;
  whatkind[2]:=1;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=1;
  howmany[2]:=3;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 28;
  special:= 4; {Shaman}
  food   := 0;
  scroll := false;
  scrollsay:='Several Kobolds stand chanting out hymms of evil';
  amount:=240;
  itemnum:=13;
  quant:=1;
end;


{FOR LIGHTHOUSE -- EVERYTHING THAT FOLLOWS}

with dung_arr[43] do begin
  dxmap:=6;
  dymap:=1;
  dlocx:=49;
  dlocy:=9;
  whatkind[1]:=73;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=3;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 29;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='The Sounds of Croaking comes from a ruined wooden dinghy.';
  amount:=0;
  itemnum:=32;
  quant:=1;
end;

with dung_arr[44] do begin
  dxmap:=6;
  dymap:=1;
  dlocx:=48;
  dlocy:=19;
  whatkind[1]:=2;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=5;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 30;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Several cloaks hang on walls covered in cobwebs!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[45] do begin
  dxmap:=6;
  dymap:=2;
  dlocx:=31;
  dlocy:=8;
  whatkind[1]:=7;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=8;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 31;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Trophies of various adorn the walls here!';
  amount:=62;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[46] do begin
  dxmap:=6;
  dymap:=2;
  dlocx:=36;
  dlocy:=8;
  whatkind[1]:=7;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=8;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 31;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Trophies of various big fishes adorn the wall!';
  amount:=62;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[47] do begin
  dxmap:=6;
  dymap:=2;
  dlocx:=49;
  dlocy:=9;
  whatkind[1]:=74;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=4;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 32;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='The room contains several paintings of boats, smells like mildew.';
  amount:=122;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[48] do begin
  dxmap:=6;
  dymap:=2;
  dlocx:=30;
  dlocy:=17;
  whatkind[1]:=7;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=7;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 33;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='The kitchen, smells of rotting food!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;


with dung_arr[49] do begin
  dxmap:=6;
  dymap:=2;
  dlocx:=33;
  dlocy:=19;
  whatkind[1]:=7;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=7;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 33;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='The kitchen, smells of rotting food!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[50] do begin
  dxmap:=6;
  dymap:=2;
  dlocx:=48;
  dlocy:=19;
  whatkind[1]:=43;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=4;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 34;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='An ornate dining room, home of some nasty birds!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[51] do begin
  dxmap:=6;
  dymap:=3;
  dlocx:=31;
  dlocy:=9;
  whatkind[1]:=2;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=4;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 35;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Bed spreads on the beds are a mess, covered in webs!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[52] do begin
  dxmap:=6;
  dymap:=3;
  dlocx:=47;
  dlocy:=9;
  whatkind[1]:=2;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=4;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 36;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Bed spreads on the beds are a mess, covered in webs!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[53] do begin
  dxmap:=6;
  dymap:=3;
  dlocx:=25;
  dlocy:=16;
  whatkind[1]:=7;
  whatkind[2]:=7;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=3;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 37;
  special:= 5; {Libarary}
  food   := 0;
  scroll := false;
  scrollsay:='The Library.  Most of the books in shambles!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[54] do begin
  dxmap:=6;
  dymap:=3;
  dlocx:=46;
  dlocy:=19;
  whatkind[1]:=73;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 38;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Sounds of croaking come from a collection of tools!';
  amount:=0;
  itemnum:=14;
  quant:=1;
end;

{For that one cave!}
with dung_arr[55] do begin
  dxmap:=2;
  dymap:=2;
  dlocx:=30;
  dlocy:=18;
  whatkind[1]:=1; {KOBOLDS}
  whatkind[2]:=1; {KOBOLDS}
  whatkind[3]:=6; {GOBLINS}
  whatkind[4]:=34;{KOB LEADER}

  howmany[1]:=7;
  howmany[2]:=5;
  howmany[3]:=4;
  howmany[4]:=2;
  toggler:= 39;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A LARGE group of monsters are inside, the leaders yells "SURPRISE!"';
  amount:=675;
  itemnum:=4;
  quant:=2;
end;

{for the Temple!}

with dung_arr[56] do begin
  dxmap:=9;
  dymap:=5;
  dlocx:=35;
  dlocy:=6;
  whatkind[1]:=55;
  whatkind[2]:=2;
  whatkind[3]:=2;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=5;
  howmany[3]:=4;
  howmany[4]:=0;
  toggler:= 40;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Cobwebs litter the area, a few steps away is a stairwell down';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;


with dung_arr[57] do begin
  dxmap:=9;
  dymap:=5;
  dlocx:=35;
  dlocy:=13;
  whatkind[1]:=13;
  whatkind[2]:=13;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=2;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 41;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A group of skeletons dressed in red armor advance to defend the temple';
  amount:=0;
  itemnum:=17; {A RING +1}
  quant:=0;
end;

with dung_arr[58] do begin
  dxmap:=9;
  dymap:=5;
  dlocx:=36;
  dlocy:=13;
  whatkind[1]:=13;
  whatkind[2]:=13;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=2;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 41;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A group of skeletons dressed in red armor advance to defend the temple';
  amount:=0;
  itemnum:=17; {A RING +1}
  quant:=0;
end;

with dung_arr[59] do begin
  dxmap:=9;
  dymap:=4;
  dlocx:=19;
  dlocy:=4;
  whatkind[1]:=13;
  whatkind[2]:=31;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=2;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 42;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A room that is exceedinly hot, is home to some evil creatures!';
  amount:=250;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[60] do begin
  dxmap:=9;
  dymap:=4;
  dlocx:=26;
  dlocy:=9;
  whatkind[1]:=13;
  whatkind[2]:=10;
  whatkind[3]:=10;
  whatkind[4]:=10;

  howmany[1]:=2;
  howmany[2]:=1;
  howmany[3]:=1;
  howmany[4]:=1;
  toggler:= 43;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Several Evil Wizards in Suspended Animation Awaken at your arrival!';
  amount:=0;
  itemnum:=22;
  quant:=0;
end;

with dung_arr[61] do begin
  dxmap:=9;
  dymap:=4;
  dlocx:=8;
  dlocy:=11;
  whatkind[1]:=44;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=5;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 44;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A family of Killer Shrews seems to have occupied this room!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[62] do begin
  dxmap:=9;
  dymap:=4;
  dlocx:=12;
  dlocy:=13;
  whatkind[1]:=44;
  whatkind[2]:=50;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=5;
  howmany[2]:=0;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 44;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='A family of Killer Shrews seems to have occupied this room!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[63] do begin
  dxmap:=9;
  dymap:=4;
  dlocx:=38;
  dlocy:=13;
  whatkind[1]:=48;
  whatkind[2]:=3;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=3;
  howmany[2]:=5;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 45;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Some of the former occupents are here along with their followers!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[64] do begin
  dxmap:=9;
  dymap:=4;
  dlocx:=38;
  dlocy:=18;
  whatkind[1]:=48;
  whatkind[2]:=3;
  whatkind[3]:=50;
  whatkind[4]:=50;

  howmany[1]:=3;
  howmany[2]:=5;
  howmany[3]:=0;
  howmany[4]:=0;
  toggler:= 45;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Some of the former occupents are here along with their followers!';
  amount:=0;
  itemnum:=0;
  quant:=0;
end;

with dung_arr[65] do begin
  dxmap:=8;
  dymap:=4;
  dlocx:=50;
  dlocy:=14;
  whatkind[1]:=48;
  whatkind[2]:=10;
  whatkind[3]:=31;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=2;
  howmany[3]:=2;
  howmany[4]:=0;
  toggler:= 46;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Several types of monsters here protect the last encounter!';
  amount:=1267;
  itemnum:=36;
  quant:=8;
end;

with dung_arr[66] do begin
  dxmap:=8;
  dymap:=4;
  dlocx:=56;
  dlocy:=14;
  whatkind[1]:=48;
  whatkind[2]:=10;
  whatkind[3]:=31;
  whatkind[4]:=50;

  howmany[1]:=2;
  howmany[2]:=2;
  howmany[3]:=2;
  howmany[4]:=0;
  toggler:= 46;
  special:= 0;
  food   := 0;
  scroll := false;
  scrollsay:='Several types of monsters here protect the last encounter!';
  amount:=1267;
  itemnum:=36;
  quant:=8;
end;

{TOGGLER 47 is for RED RUBY!!!!!!! NOTE THIS NOTE THIS!!!!}
{TOGGLER 48 is for SOMA Killing IMPORTANT!}
assign(dung_file,'DUNRM1.PIT');
rewrite(dung_file);
for count:=1 to MAXROOM do
  write(dung_file,dung_arr[count]);
close(dung_file);
end.


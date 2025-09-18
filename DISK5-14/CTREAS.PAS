program ctreasure;
{CREATES a treasure file!}
{DO NOTE THAT TOGGLER '1' is DEFAUT, meaning it can be hit more than ONCE!!!!!}
CONST MAXTREAS = 115;
type helper=string[70];
type treasure = record
    amount : integer;
    toggler : byte;                {1. what kind, 2. how many}
    potiont : array [1..2] of byte;
    food   : byte;
    scroll : boolean;
    scrollsay : helper;
    loser     : helper;
    dun_num : byte;
    xloc : byte;
    yloc : byte;
  end;
var treas_file : file of treasure;
    treas_ar   : array [1..MAXTREAS] of treasure;
    x : byte;
begin
assign(treas_file,'TREASURE.DAT');
rewrite(treas_file);
for x:= 1 to MAXTREAS do begin
    treas_ar[x].scrollsay:='                                                                            ';
    treas_ar[x].loser:='                                                                                ';
    treas_ar[x].food:=0;
    treas_ar[x].amount:=0;
    treas_ar[x].potiont[1]:=0;
    treas_ar[x].potiont[2]:=0;
    treas_ar[x].scroll:=false;
    treas_ar[x].toggler:=1;
end;


with treas_ar[1] do begin
   amount:=187; toggler:=41;
   scroll:=true; scrollsay:='In the Dirt you Find Some Treasure!';
   dun_num:=0; xloc:=55; yloc:=21;
   loser:='You find nothing but dirt and stone.....';
end;

with treas_ar[2] do begin
   amount:=625; toggler:=40;
   scroll:=true; scrollsay:='You Found the Treasure Room!';
   dun_num:=0; xloc:=58; yloc:=11;
   loser:='Nothing remains in this room but an empty chest and dead bodies...';
end;


with treas_ar[3] do begin
    scroll:=true;
    scrollsay:='The Kobold''s Water Supply!  Surprisingly Fresh!';
    dun_num:=1; xloc:=30; yloc:=15;
end;

with treas_ar[4] do begin
scroll:=true;
scrollsay:='Better Be Quiet, Kobolds are Lurking near, Welcome to your Doom!';
dun_num:=1; xloc:=10; yloc:=13;
end;

with treas_ar[5] do begin
scroll:=true;
scrollsay:='Wow, Look at all This Food!  Some Rotten but ...';
food:=25;
amount:=15;
toggler:=39;
dun_num:=1; xloc:=54; yloc:=13;
loser:='Nothing but rotting food .....';
end;

with treas_ar[6] do begin
scroll:=true;
scrollsay:='In a satchel you find ......';
food:=2; potiont[1]:=1; potiont[2]:=5;
toggler:=38; amount:=25;
dun_num:=1; xloc:=19; yloc:=12;
loser:='Nothing in this room but dead bodies....';
end;

with treas_ar[7] do begin
scroll:=true;
scrollsay:='You have Found your Reward!';
potiont[1]:=3; potiont[2]:=2;
toggler:=37; amount:=226;
dun_num:=1; xloc:=13; yloc:=11;
loser:='Nothing in this room but some dead bodies';
end;

{for dungeon II}
with treas_ar[8] do begin
scroll:=true;
scrollsay:='The Rusty Cemetary Gates Open to a Most Gloomy Place!';
dun_num:=2; xloc:=10; yloc:=13;
end;

with treas_ar[9] do begin
scroll:=true;
scrollsay:='Underneath two dying Tress is a Clean Well!';
dun_num:=2; xloc:=47; yloc:=8;
end;

with treas_ar[10] do begin
scroll:=true;
scrollsay:='Unfortunately you were here too late!  Bandits Stole the Loot!';
dun_num:=2; xloc:=63; yloc:=17;
end;

with treas_ar[11] do begin
scroll:=true;
scrollsay:='All Around you are ornate pillars in various states of decay.';
dun_num:=2; xloc:=35; yloc:=13;
end;


with treas_ar[12] do begin
scroll:=true;
scrollsay:='To the east you can see a dark building, very large!';
dun_num:=2; xloc:=10; yloc:=12;
end;

with treas_ar[13] do begin
scroll:=true;
scrollsay:='Underneath two dying Tress is a Clean Well!';
dun_num:=2; xloc:=57; yloc:=21;
end;

with treas_ar[14] do begin
scroll:=true;
scrollsay:='Inside is the family Treasure!';
dun_num:=2; xloc:=13; yloc:=8;
amount:=51; toggler:=36;
loser:='Nothing here but an empty chest!';

end;

with treas_ar[15] do begin
scroll:=true;
scrollsay:='Inside is the family Treasure!';
dun_num:=2; xloc:=68; yloc:=22;
amount:=521; toggler:=35;
loser:='Nothing in this burial site but an empty chest!';
end;

with treas_ar[16] do begin
scroll:=true;
scrollsay:='A sturdy oaken door is in front of you!';
dun_num:=2; xloc:=37; yloc:=11;
end;

with treas_ar[17] do begin
scroll:=true;
scrollsay:='Inside a satchel is.....';
dun_num:=2; xloc:=42; yloc:=8;
potiont[1]:=1; potiont[2]:=7;
loser:='Nothing here but an empty satchel';
toggler:=34;
end;

with treas_ar[18] do begin
scroll:=true;
scrollsay:='In the distance you can hear hearty Dwarven Warriors laughing!';
dun_num:=4; xloc:=35; yloc:=16;
end;

with treas_ar[19] do begin
scroll:=true;
scrollsay:='It appears that this part of the tower has collapsed slightly!';
dun_num:=4; xloc:=22; yloc:=16;
end;

with treas_ar[20] do begin
scroll:=true;
scrollsay:='Standing near the ledge, you can see for miles, what a view!';
dun_num:=4; xloc:=23; yloc:=8;
end;

with treas_ar[21] do begin
scroll:=true;
scrollsay:='Inside a large metal chest is some gems worth.....';
dun_num:=4; xloc:=41; yloc:=9;
loser:='Nothing here but an chest!';
toggler:=33; amount:=2791;
end;

with treas_ar[22] do begin
scroll:=true;
scrollsay:='Wow, a rack full of potions!';
dun_num:=4; xloc:=33; yloc:=9;
loser:='Nothing here but an empty rack and some dead bodies!';
toggler:=32; potiont[1]:=1; potiont[2]:=15;
end;

with treas_ar[23] do begin
scroll:=true;
scrollsay:='Wow, a rack full of potions!';
dun_num:=4; xloc:=33; yloc:=15;
loser:='Nothing here but an empty rack and some dead bodies!';
toggler:=31; potiont[1]:=3; potiont[2]:=14;
end;

with treas_ar[24] do begin
scroll:=true;
scrollsay:='Wow, some gold and food!';
dun_num:=4; xloc:=39; yloc:=15;
loser:='Nothing here but an empty supply room and some dead bodies!';
toggler:=30; food:=61; amount:=1510;
end;

with treas_ar[25] do begin
scroll:=true;
scrollsay:='Gee a camoflaged cavern, looks inhabited too!';
dun_num:=6; xloc:=69; yloc:=10;
loser:='Nothing here but an empty supply room and some dead bodies!';
end;

with treas_ar[26] do begin
scroll:=true;
scrollsay:='The Bandits Treasure, in a nice chest too!';
dun_num:=6; xloc:=42; yloc:=17;
toggler:=29; amount:=1429; food:=10;
potiont[1]:=4; potiont[2]:=8;
loser:='Nothing here but an empty room and some dead bodies!';
end;

with treas_ar[27] do begin
scroll:=true;
scrollsay:='The Abbey''s Hidden Stash!';
dun_num:=6; xloc:=54; yloc:=5;
toggler:=28; amount:=2429; food:=0;
potiont[1]:=1; potiont[2]:=15;
loser:='Nothing here but an empty and dusty room!';
end;

with treas_ar[28] do begin
scroll:=true;
scrollsay:='To the east is an altar and standing to the side are statues!';
dun_num:=6; xloc:=14; yloc:=14;
loser:='Nothing here but an empty and dusty room!';
end;

with treas_ar[29] do begin
scroll:=true;
scrollsay:='An overwhelming sense of evil fills the air!';
dun_num:=6; xloc:=35; yloc:=14;
loser:='Nothing here but an empty and dusty room!';
end;
{ **** Mojave's Tower *****}

with treas_ar[30] do begin
scroll:=true;
scrollsay:='Welcome to Mojave''s Tower!  It could be your resting place!';
dun_num:=7; xloc:=33; yloc:=18;
loser:='Nothing here but an empty and dusty room!';
end;

with treas_ar[31] do begin
scroll:=true;
scrollsay:='You can hear the sounds of bubbling water!';
dun_num:=7; xloc:=44; yloc:=19;
loser:='Nothing here but an empty and dusty room!';
end;

with treas_ar[32] do begin
scroll:=true;
scrollsay:='Slumped Against the Wall is a Body of a Thief!';
dun_num:=7; xloc:=22; yloc:=5; amount:=100; toggler:=27;
loser:='Nothing here but a dead body!!';
end;

with treas_ar[33] do begin
scroll:=true;
scrollsay:='Watch your Step....the Checkerboard Room!!';
dun_num:=7; xloc:=18; yloc:=18;
loser:='Nothing here but a dead body!!';
end;

with treas_ar[34] do begin
scroll:=true;
scrollsay:='If you''ve made this far you are lucky!!!';
dun_num:=7; xloc:=26; yloc:=12;
loser:='Nothing here but a dead body!!';
end;

with treas_ar[35] do begin
scroll:=true;
scrollsay:='Watchout Pits ahead!!!';
dun_num:=7; xloc:=42; yloc:=8;
loser:='Nothing here but a dead body!!';
end;

with treas_ar[36] do begin
scroll:=true;
scrollsay:='Watchout Pits ahead!!!';
dun_num:=7; xloc:=42; yloc:=16;
loser:='Nothing here but a dead body!!';
end;

with treas_ar[37] do begin
scroll:=true;
scrollsay:='You must know the chant to get out of here!!';
dun_num:=7; xloc:=15; yloc:=19;
loser:='Nothing here but a dead body!!';
end;

with treas_ar[38] do begin
scroll:=true;
scrollsay:='Mojave can shape change -- how else can he live....';
dun_num:=7; xloc:=17; yloc:=19;
loser:='Nothing here but a dead body!!';
end;

with treas_ar[39] do begin
scroll:=true;
scrollsay:='Mojave is close at hand, I can feel his presence!!';
dun_num:=7; xloc:=25; yloc:=19;
loser:='Nothing here but a dead body!!';
end;

with treas_ar[40] do begin
scroll:=true;
scrollsay:='Nothing here but a skeleton of a dead knight!!';
dun_num:=7; xloc:=29; yloc:=19;
loser:='Nothing here but a dead body!!';
end;

with treas_ar[41] do begin
scroll:=true;
scrollsay:='There are traps near the water!';
dun_num:=7; xloc:=35; yloc:=19;
loser:='Nothing here but a dead body!!';
end;

with treas_ar[42] do begin
scroll:=true;
scrollsay:='Think of Goodness when you answer the riddles!!';
dun_num:=7; xloc:=39; yloc:=19;
loser:='Nothing here but a dead body!!';
end;

with treas_ar[43] do begin
scroll:=true;
scrollsay:='What a view... Finally at the top and near Mojave''s Cave!';
dun_num:=7; xloc:=25; yloc:=11;
loser:='Nothing here but a dead body!!';
end;

with treas_ar[44] do begin
scroll:=true;
scrollsay:='Below you is a dry gulley!  And to the East is a Cave!';
dun_num:=7; xloc:=30; yloc:=11;
loser:='Nothing here but a dead body!!';
end;

with treas_ar[45] do begin
scroll:=true;
scrollsay:='A Sultan''s Stash!!';
dun_num:=6;xloc:=28; yloc:=10; toggler:=26; amount:=3500;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[46] do begin
scroll:=true;
scrollsay:='A Sultan''s Stash!!';
dun_num:=6;xloc:=42; yloc:=10; toggler:=25; amount:=2543;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[47] do begin
scroll:=true;
scrollsay:='A Sultan''s Stash!!';
dun_num:=6;xloc:=42; yloc:=13; toggler:=24; amount:=1754;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[48] do begin
scroll:=true;
scrollsay:='A Sultan''s Stash!!';
dun_num:=6;xloc:=27; yloc:=16; toggler:=23;
potiont[1]:=1; potiont[2]:=25;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[49] do begin
scroll:=true;
scrollsay:='A Sultan''s Wifes''s Stash!!';
dun_num:=6;xloc:=42; yloc:=16; toggler:=22;
potiont[1]:=2; potiont[2]:=25; amount:=4102;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[50] do begin
scroll:=true;
scrollsay:='A musty Smelling Crypt is Before you!!';
dun_num:=6;xloc:=24; yloc:=13;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[51] do begin
scroll:=true;
scrollsay:='The Smell of the Herby Soma Fills the Castle Air!';
dun_num:=8;xloc:=38; yloc:=17;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[52] do begin
scroll:=true;
scrollsay:='A Warm Natural Fountain produces a Moist Atmosphere!';
dun_num:=8;xloc:=34; yloc:=13;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[53] do begin
scroll:=true;
scrollsay:='An ornate fountain shoots fresh water into a pool!';
dun_num:=8;xloc:=40; yloc:=13;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[54] do begin
scroll:=true;
scrollsay:='Above you is a High Ceiling!  Walkaways cross over above!';
dun_num:=8; xloc:=37; yloc:=10;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[55] do begin
scroll:=true;
scrollsay:='The Dwarves Stash of Food is here!  Yum!';
dun_num:=8; xloc:=14; yloc:=14; toggler:=21;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[56] do begin
scroll:=true;
scrollsay:='You can see the Fountain Below.. very moist and hot up here!';
dun_num:=8; xloc:=37; yloc:=18;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[57] do begin
scroll:=true;
scrollsay:='You can see the Fountain Below.. very moist and hot up here!';
dun_num:=8; xloc:=37; yloc:=9;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[58] do begin
scroll:=true;
scrollsay:='Far below you is the fountain.... walkway reaches the other side';
dun_num:=8; xloc:=32; yloc:=13;
loser:='Nothing here but an empty crypt';
end;


with treas_ar[59] do begin
scroll:=true;
scrollsay:='Far below you is the fountain.... walkway reaches the other side';
dun_num:=8; xloc:=43; yloc:=13;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[60] do begin
scroll:=true;
scrollsay:='A Smug and Humid Cave is here, evidence of Dwarves and Soma!';
dun_num:=8; xloc:=33; yloc:=6;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[61] do begin
scroll:=true;
scrollsay:='A Whole Room filled with Green Soma!';
dun_num:=8; xloc:=41; yloc:=14;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[62] do begin
scroll:=true;
scrollsay:='Water Feeds here to the Soma Farm, sound of rushing water can be heard!';
dun_num:=8; xloc:=17; yloc:=16;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[63] do begin
scroll:=true;
scrollsay:='Water Feeds here to the Soma Farm, sound of rushing water can be heard!';
dun_num:=8; xloc:=19; yloc:=16;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[64] do begin
scroll:=true;
scrollsay:='Water Feeds here to the Soma Farm, sound of rushing water can be heard!';
dun_num:=8; xloc:=30; yloc:=16;
loser:='Nothing here but an empty crypt';
end;
with treas_ar[65] do begin
scroll:=true;
scrollsay:='Water Feeds here to the Soma Farm, sound of rushing water can be heard!';
dun_num:=8; xloc:=45; yloc:=16;
loser:='Nothing here but an empty crypt';
end;

with treas_ar[66] do begin
scroll:=true;
scrollsay:='Near a Water Fall is a Dwarven Stash!!';
dun_num:=8; xloc:=51; yloc:=21; toggler:=20; amount:=5913; food:=30;
potiont[1]:=3; potiont[2]:=34;
loser:='What a Beautify Waterfall!';
end;

with treas_ar[67] do begin
scroll:=true;
scrollsay:='A Ruined Fortress forlorn and evil looking!!';
dun_num:=8; xloc:=7; yloc:=12;
loser:='A ruined Fortress forlorn and Evil Looking!!';
end;

with treas_ar[68] do begin
scroll:=true;
scrollsay:='Evidence of a Dwarven Exploration Party, a dropped axe!';
dun_num:=8; xloc:=8;yloc:=12;
loser:='A ruined Fortress forlorn and Evil Looking!!';
end;
{Xevior's palace!!!!}

with treas_ar[69] do begin
scroll:=true;
scrollsay:='Graphitti depicting elves being chopped apart line the walls!';
dun_num:=5; xloc:=22;yloc:=3;
loser:='A ruined Fortress forlorn and Evil Looking!!';
end;

with treas_ar[70] do begin
scroll:=true;
scrollsay:='An ornate marble floor with a huge pool adorn this room!';
dun_num:=5; xloc:=53;yloc:=17;
loser:='An ornate marble floor with a huge pool adorn this room!';
end;

with treas_ar[71] do begin
scroll:=true;
scrollsay:='A murky pool of water fills the room!!';
dun_num:=5; xloc:=30;yloc:=12;
loser:='An ornate marble floor with a huge pool adorn this room!';
end;

with treas_ar[72] do begin
scroll:=true;
scrollsay:='Xevior''s Stash!!!';
dun_num:=5; xloc:=56; yloc:=6; toggler:=19;
amount:=10115; potiont[1]:=1; potiont[2]:=69; food:=58;
loser:='Xevior lies dead on the floor!!';
end;

with treas_ar[73] do begin
scroll:=true;
scrollsay:='Graphitti depicting Elves as whimps adorn the wall!!';
dun_num:=5; xloc:=50;yloc:=3;
loser:='A ruined Fortress forlorn and Evil Looking!!';
end;

with treas_ar[74] do begin
scroll:=true;
scrollsay:='An ornate fountain with Magic Ruins Bubbles forth water!';
dun_num:=6; xloc:=35;yloc:=12;
loser:='A ruined Fortress forlorn and Evil Looking!!';
end;

with treas_ar[75] do begin
scroll:=true;
scrollsay:='An old well sits upon a dusty dried hill.  You are high up!';
dun_num:=9; xloc:=15;yloc:=4;
loser:='Junk';
end;

with treas_ar[76] do begin
scroll:=true;
scrollsay:='A Dusty path leads up to the mountainous hills ahead!';
dun_num:=9; xloc:=52;yloc:=7;
loser:='Junk';
end;

with treas_ar[77] do begin
scroll:=true;
scrollsay:='Some Vegatation is around, high hills to the West';
dun_num:=9; xloc:=38;yloc:=12;
loser:='Junk';
end;

with treas_ar[78] do begin
scroll:=true;
scrollsay:='High hills surround the area as the silence prevails!';
dun_num:=9; xloc:=55;yloc:=12;
loser:='Junk';
end;

with treas_ar[79] do begin
scroll:=true;
scrollsay:='High hills can be seen in the north and to the west!';
dun_num:=9; xloc:=60;yloc:=12;
loser:='Junk';
end;

with treas_ar[80] do begin
scroll:=true;
scrollsay:='To the far west you can see the outlines of a dominant hill';
dun_num:=9; xloc:=21;yloc:=13;
loser:='Junk';
end;

with treas_ar[81] do begin
scroll:=true;
scrollsay:='About 100 yards to the east is a grove of trees!';
dun_num:=9; xloc:=32;yloc:=8;
loser:='Junk';
end;

with treas_ar[82] do begin
scroll:=true;
scrollsay:='Inside the trees you can hear a bird chirping!';
dun_num:=9; xloc:=39;yloc:=9;
loser:='Junk';
end;

with treas_ar[83] do begin
scroll:=true;
scrollsay:='From here, you can see a lot!';
dun_num:=9; xloc:=42;yloc:=5;
loser:='Junk';
end;

with treas_ar[84] do begin
scroll:=true;
scrollsay:='From here, you can see a lot!';
dun_num:=9; xloc:=73;yloc:=5;
loser:='Junk';
end;

with treas_ar[85] do begin
scroll:=true;
scrollsay:='A brackish river flows from the north, it is knee deep';
dun_num:=9; xloc:=22;yloc:=15;
loser:='Junk';
end;

with treas_ar[86] do begin
scroll:=true;
scrollsay:='You can see a line of trees in a gully to the west!';
dun_num:=9; xloc:=57;yloc:=15;
loser:='Junk';
end;

with treas_ar[87] do begin
scroll:=true;
scrollsay:='A fork in the road, the one to the south slopes down sharply!';
dun_num:=9; xloc:=61;yloc:=10;
loser:='Junk';
end;

with treas_ar[88] do begin
scroll:=true;
scrollsay:='Purple Plants litter the area...!';
dun_num:=9; xloc:=22;yloc:=3;
loser:='Junk';
end;

with treas_ar[89] do begin
scroll:=true;
scrollsay:='An Opening from the plants reveals a path going west!';
dun_num:=9; xloc:=24;yloc:=12;
loser:='Junk';
end;

with treas_ar[90] do begin
scroll:=true;
scrollsay:='Looming North now is a hill that resembles a Dragon';
dun_num:=9; xloc:=68;yloc:=10;
loser:='Junk';
end;

with treas_ar[91] do begin
scroll:=true;
scrollsay:='You find yourself in a large gulley surrounded by hills!';
dun_num:=9; xloc:=68;yloc:=9;
loser:='Junk';
end;

with treas_ar[92] do begin
scroll:=true;
scrollsay:='A Large Outcropping of Rock lies in the middle of this bowl';
dun_num:=9; xloc:=67;yloc:=9;
loser:='Junk';
end;

with treas_ar[93] do begin
scroll:=true;
scrollsay:='Twisted pieces of wood lie on top of this unclimable rock';
dun_num:=9; xloc:=42;yloc:=10;
loser:='Junk';
end;

with treas_ar[94] do begin
scroll:=true;
scrollsay:='A Dusty path leads up the face of the hill';
dun_num:=9; xloc:=38;yloc:=20;
loser:='Junk';
end;

with treas_ar[95] do begin
scroll:=true;
scrollsay:='A Dusty path leads up the face of the hill';
dun_num:=9; xloc:=46;yloc:=20;
loser:='Junk';
end;


with treas_ar[96] do begin
scroll:=true;
scrollsay:='A strange formation of rock is here!  Sealed Entrance!';
dun_num:=9; xloc:=26;yloc:=5;
loser:='Junk';
end;

with treas_ar[97] do begin
scroll:=true;
scrollsay:='The Dragon Shaped hill is to west!!';
dun_num:=9; xloc:=31;yloc:=9;
loser:='Junk';
end;

with treas_ar[98] do begin
scroll:=true;
scrollsay:='Rubble Blocks this path (from a landslide)';
dun_num:=9; xloc:=57;yloc:=13;
loser:='Junk';
end;


with treas_ar[99] do begin
scroll:=true;
scrollsay:='You are right next to the dragon shaped hill!';
dun_num:=9; xloc:=29;yloc:=15;
loser:='Junk';
end;

with treas_ar[100] do begin
scroll:=true;
scrollsay:='Rubble Blocks this path (from landslide)';
dun_num:=9; xloc:=54;yloc:=16;
loser:='Junk';
end;

with treas_ar[101] do begin
scroll:=true;
scrollsay:='Many dusty trails lead northward towards the hill!';
dun_num:=9; xloc:=60;yloc:=17;
loser:='Junk';
end;

WITH TREAS_AR[102] DO BEGIN
SCROll:=true;
scrollsay:='The Distant sound of Water can be heard from the West!';
dun_num:=9; xloc:=57; yloc:=19;
loser:='Junk';
end;


for x:=1 to MAXTREAS do
  write(treas_file,treas_ar[x]);
close(treas_file);
end.

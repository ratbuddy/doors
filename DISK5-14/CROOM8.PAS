program create_room_filez;
const MAX_IN_FILE = 37;
type
 dun_room = record
     dxmap:byte;
     dymap:byte;
     dlocx:byte;
     dlocy: byte;
     dencount : array [1..5] of byte;
     toggle : byte;
     special : byte;
 end;

var cramps:byte;
    dunner: array [1.. MAX_IN_FILE] of dun_room;
    dun_room_file : file of dun_room;
begin
for cramps:=1 to MAX_IN_FILE do dunner[cramps].special :=0;
with dunner[1] do begin
   dxmap:=1; dymap:=1; dlocx:=14; dlocy:=7;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=63; dencount[4]:=63;
   dencount[5]:=4;
   toggle:=103;
end;


with dunner[2] do begin
   dxmap:=1; dymap:=1; dlocx:=14; dlocy:=9;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=63; dencount[4]:=63;
   dencount[5]:=4;
   toggle:=103;
end;


with dunner[3] do begin
   dxmap:=1; dymap:=1; dlocx:=51; dlocy:=10;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=63; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=104;
end;


with dunner[4] do begin
   dxmap:=1; dymap:=1; dlocx:=60; dlocy:=10;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=63; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=104;
end;


with dunner[5] do begin
   dxmap:=1; dymap:=1; dlocx:=20; dlocy:=14;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=105;
end;


with dunner[6] do begin
   dxmap:=1; dymap:=1; dlocx:=56; dlocy:=14;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=31; dencount[4]:=31;
   dencount[5]:=4;
   toggle:=106;
end;


with dunner[7] do begin
   dxmap:=1; dymap:=1; dlocx:=16; dlocy:=18;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=63; dencount[4]:=63;
   dencount[5]:=4;
   toggle:=107;
end;


with dunner[8] do begin
   dxmap:=1; dymap:=1; dlocx:=11; dlocy:=19;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=63; dencount[4]:=63;
   dencount[5]:=4;
   toggle:=107;
end;


with dunner[9] do begin
   dxmap:=1; dymap:=1; dlocx:=59; dlocy:=18;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=63; dencount[4]:=62;
   dencount[5]:=4;
   toggle:=108;
end;



with dunner[10] do begin
   dxmap:=1; dymap:=1; dlocx:=60; dlocy:=20;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=63; dencount[4]:=62;
   dencount[5]:=4;
   toggle:=108;
end;


with dunner[11] do begin
   dxmap:=1; dymap:=2; dlocx:=64; dlocy:=10;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=64;
   dencount[5]:=4;
   toggle:=109;
end;


with dunner[12] do begin
   dxmap:=1; dymap:=2; dlocx:=64; dlocy:=14;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=64;
   dencount[5]:=4;
   toggle:=109;
end;


with dunner[13] do begin
   dxmap:=1; dymap:=2; dlocx:=10; dlocy:=13;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=110;
end;


with dunner[14] do begin
   dxmap:=1; dymap:=2; dlocx:=9; dlocy:=17;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=110;
end;

with dunner[15] do begin
   dxmap:=1; dymap:=3; dlocx:=64; dlocy:=6;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=64;
   dencount[5]:=4;
   toggle:=111;
end;

with dunner[16] do begin
   dxmap:=1; dymap:=3; dlocx:=62; dlocy:=8;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=64;
   dencount[5]:=4;
   toggle:=111;
end;

with dunner[17] do begin
   dxmap:=1; dymap:=3; dlocx:=59; dlocy:=9;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=64;
   dencount[5]:=4;
   toggle:=111;
end;


with dunner[18] do begin
   dxmap:=1; dymap:=3; dlocx:=64; dlocy:=10;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=64;
   dencount[5]:=4;
   toggle:=111;
end;

with dunner[19] do begin
   dxmap:=1; dymap:=3; dlocx:=12; dlocy:=7;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=62;
   dencount[5]:=4;
   toggle:=112;
end;

with dunner[20] do begin
   dxmap:=1; dymap:=3; dlocx:=14; dlocy:=8;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=62;
   dencount[5]:=4;
   toggle:=112;
end;

with dunner[21] do begin
   dxmap:=1; dymap:=3; dlocx:=15; dlocy:=9;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=62;
   dencount[5]:=4;
   toggle:=112;
end;

with dunner[22] do begin
   dxmap:=1; dymap:=3; dlocx:=11; dlocy:=10;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=62;
   dencount[5]:=4;
   toggle:=112;
end;

with dunner[23] do begin
   dxmap:=1; dymap:=3; dlocx:=11; dlocy:=18;
   dencount[1]:=64; dencount[2]:=64; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=113;
end;

with dunner[24] do begin
   dxmap:=1; dymap:=3; dlocx:=12; dlocy:=21;
   dencount[1]:=64; dencount[2]:=64; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=113;
end;

with dunner[25] do begin
   dxmap:=1; dymap:=3; dlocx:=64; dlocy:=18;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=63; dencount[4]:=52;
   dencount[5]:=4;
   toggle:=114;
end;

with dunner[26] do begin
   dxmap:=1; dymap:=3; dlocx:=63; dlocy:=21;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=63; dencount[4]:=52;
   dencount[5]:=4;
   toggle:=114;
end;


with dunner[27] do begin
   dxmap:=1; dymap:=4; dlocx:=21; dlocy:=13;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=63; dencount[4]:=63;
   dencount[5]:=4;
   toggle:=115;
end;

with dunner[28] do begin
   dxmap:=1; dymap:=4; dlocx:=43; dlocy:=13;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=52; dencount[4]:=52;
   dencount[5]:=4;
   toggle:=117;
end;

with dunner[29] do begin
   dxmap:=1; dymap:=4; dlocx:=30; dlocy:=19;
   dencount[1]:=64; dencount[2]:=63; dencount[3]:=52; dencount[4]:=50;
   dencount[5]:=4;
   toggle:=118;
end;

with dunner[30] do begin
   dxmap:=1; dymap:=5; dlocx:=32; dlocy:=6;
   dencount[1]:=65; dencount[2]:=64; dencount[3]:=64; dencount[4]:=52;
   dencount[5]:=4;
   toggle:=119;
end;

with dunner[31] do begin
   dxmap:=1; dymap:=5; dlocx:=33; dlocy:=6;
   dencount[1]:=65; dencount[2]:=64; dencount[3]:=64; dencount[4]:=52;
   dencount[5]:=4;
   toggle:=119;
end;

with dunner[32] do begin
   dxmap:=1; dymap:=5; dlocx:=24; dlocy:=8;
   dencount[1]:=65; dencount[2]:=64; dencount[3]:=64; dencount[4]:=52;
   dencount[5]:=4;
   toggle:=119;
end;

with dunner[33] do begin
   dxmap:=1; dymap:=5; dlocx:=38; dlocy:=8;
   dencount[1]:=65; dencount[2]:=64; dencount[3]:=64; dencount[4]:=52;
   dencount[5]:=4;
   toggle:=119;
end;

with dunner[34] do begin
   dxmap:=1; dymap:=5; dlocx:=32; dlocy:=10;
   dencount[1]:=65; dencount[2]:=64; dencount[3]:=64; dencount[4]:=52;
   dencount[5]:=4;
   toggle:=119;
end;

with dunner[35] do begin
   dxmap:=1; dymap:=6; dlocx:=23; dlocy:=11;
   dencount[1]:=53; dencount[2]:=53; dencount[3]:=53; dencount[4]:=53;
   dencount[5]:=4;
   toggle:=120;
end;

with dunner[36] do begin
   dxmap:=1; dymap:=6; dlocx:=9; dlocy:=16;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=64;
   dencount[5]:=4;
   toggle:=121;
end;

with dunner[37] do begin
   dxmap:=1; dymap:=6; dlocx:=33; dlocy:=17;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=65;
   dencount[5]:=4;
   toggle:=122;
end;


assign(dun_room_file,'DUNRM8.PIT');
rewrite(dun_room_file);
for cramps := 1 to MAX_IN_FILE do
  write(dun_room_file,dunner[cramps]);
close(dun_room_file);
end.


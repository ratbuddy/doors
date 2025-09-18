program create_room_filez;
const MAX_IN_FILE = 45;
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
   dxmap:=1; dymap:=1; dlocx:=38; dlocy:=5;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=1;
   dencount[5]:=4;
   toggle:=2;
end;

with dunner[2] do begin
   dxmap:=1; dymap:=1; dlocx:=65; dlocy:=5;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=3;
end;

with dunner[13] do begin
   dxmap:=1; dymap:=1; dlocx:=41; dlocy:=7;
   dencount[1]:=1; dencount[2]:=50; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=1;
   toggle:=2;
end;

with dunner[3] do begin
   dxmap:=1; dymap:=1; dlocx:=15; dlocy:=9;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=34; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=3;
end;

with dunner[4] do begin
   dxmap:=1; dymap:=1; dlocx:=65; dlocy:=9;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=1;
   dencount[5]:=4;
   toggle:=4;
end;

with dunner[5] do begin
   dxmap:=1; dymap:=1; dlocx:=18; dlocy:=11;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=4;
end;

with dunner[6] do begin
   dxmap:=1; dymap:=1; dlocx:=15; dlocy:=13;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=4;
end;

with dunner[7] do begin
   dxmap:=1; dymap:=1; dlocx:=69; dlocy:=14;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=28;
   dencount[5]:=4;
   toggle:=5;
end;

with dunner[8] do begin
   dxmap:=1; dymap:=1; dlocx:=38; dlocy:=15;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=28; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=6;
end;

with dunner[9] do begin
   dxmap:=1; dymap:=1; dlocx:=15; dlocy:=16;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=7;
end;

with dunner[10] do begin
   dxmap:=1; dymap:=1; dlocx:=50; dlocy:=19;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=8;
end;

with dunner[11] do begin
   dxmap:=1; dymap:=1; dlocx:=69; dlocy:=19;
   dencount[1]:=1; dencount[2]:=28; dencount[3]:=28; dencount[4]:=28;
   dencount[5]:=4;
   toggle:=5;
end;

with dunner[12] do begin
   dxmap:=1; dymap:=1; dlocx:=14; dlocy:=20;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=7;
end;
{************   NEW SEGMENT OF MAP   ******************}
with dunner[14] do begin
   dxmap:=1; dymap:=2; dlocx:=19; dlocy:=5;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=1;
   dencount[5]:=4;
   toggle:=8;
end;

with dunner[15] do begin
   dxmap:=1; dymap:=2; dlocx:=39; dlocy:=11;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=9;
end;

with dunner[16] do begin
   dxmap:=1; dymap:=2; dlocx:=45; dlocy:=11;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=9;
end;

with dunner[17] do begin
   dxmap:=1; dymap:=2; dlocx:=19; dlocy:=12;
   dencount[1]:=7; dencount[2]:=1; dencount[3]:=1; dencount[4]:=1;
   dencount[5]:=4;
   toggle:=10;
end;

with dunner[18] do begin
   dxmap:=1; dymap:=2; dlocx:=58; dlocy:=13;
   dencount[1]:=1; dencount[2]:=7; dencount[3]:=1; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=11;
end;

with dunner[19] do begin
   dxmap:=1; dymap:=2; dlocx:=35; dlocy:=14;
   dencount[1]:=1; dencount[2]:=7; dencount[3]:=28; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=12;
end;

with dunner[20] do begin
   dxmap:=1; dymap:=2; dlocx:=15; dlocy:=17;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=34;
   dencount[5]:=4;
   toggle:=13;
end;

with dunner[21] do begin
   dxmap:=1; dymap:=2; dlocx:=24; dlocy:=17;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=34;
   dencount[5]:=4;
   toggle:=13;
end;

with dunner[22] do begin
   dxmap:=1; dymap:=2; dlocx:=48; dlocy:=19;
   dencount[1]:=5; dencount[2]:=5; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=14;
end;


{NEW MAP SECTION!!!!!!!!!!!!!!!!!!!!!!!!!!}
with dunner[23] do begin
   dxmap:=1; dymap:=3; dlocx:=14; dlocy:=5;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=1;
   dencount[5]:=4;
   toggle:=15;
end;


with dunner[24] do begin
   dxmap:=1; dymap:=3; dlocx:=18; dlocy:=7;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=15;
end;


with dunner[25] do begin
   dxmap:=1; dymap:=3; dlocx:=32; dlocy:=7;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=16;
end;


with dunner[26] do begin
   dxmap:=1; dymap:=3; dlocx:=27; dlocy:=9;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=16;
end;


with dunner[27] do begin
   dxmap:=1; dymap:=3; dlocx:=59; dlocy:=10;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=1;
   dencount[5]:=4;
   toggle:=17;
end;

with dunner[28] do begin
   dxmap:=1; dymap:=3; dlocx:=65; dlocy:=10;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=1;
   dencount[5]:=4;
   toggle:=17;
end;

{NEW SECTION}

with dunner[29] do begin
   dxmap:=2; dymap:=1; dlocx:=10; dlocy:=18;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=18;
end;


with dunner[30] do begin
   dxmap:=2; dymap:=1; dlocx:=5; dlocy:=20;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=50;
   dencount[5]:=4;
   toggle:=18;
end;



with dunner[31] do begin
   dxmap:=2; dymap:=1; dlocx:=13; dlocy:=20;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=18;
end;



with dunner[32] do begin
   dxmap:=2; dymap:=1; dlocx:=19; dlocy:=20;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=34; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=19;
end;


with dunner[33] do begin
   dxmap:=2; dymap:=1; dlocx:=24; dlocy:=20;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=34; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=19;
end;


{NEW SECTION!!!!!}

with dunner[34] do begin
   dxmap:=2; dymap:=2; dlocx:=36; dlocy:=7;
   dencount[1]:=2; dencount[2]:=2; dencount[3]:=2; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=20;
end;


with dunner[35] do begin
   dxmap:=2; dymap:=2; dlocx:=13; dlocy:=8;
   dencount[1]:=35; dencount[2]:=34; dencount[3]:=7; dencount[4]:=1;
   dencount[5]:=4;
   toggle:=21;   special:=1;
end;


with dunner[36] do begin
   dxmap:=2; dymap:=2; dlocx:=20; dlocy:=9;
   dencount[1]:=36; dencount[2]:=34; dencount[3]:=1; dencount[4]:=1;
   dencount[5]:=4;
   toggle:=22;
end;


with dunner[37] do begin
   dxmap:=2; dymap:=2; dlocx:=23; dlocy:=12;
   dencount[1]:=36; dencount[2]:=34; dencount[3]:=1; dencount[4]:=1;
   dencount[5]:=4;
   toggle:=22;
end;

with dunner[38] do begin
   dxmap:=2; dymap:=2; dlocx:=28; dlocy:=12;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=1;
   dencount[5]:=4;
   toggle:=23;
end;


with dunner[39] do begin
   dxmap:=2; dymap:=2; dlocx:=33; dlocy:=12;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=1;
   dencount[5]:=4;
   toggle:=23;
end;


with dunner[40] do begin
   dxmap:=2; dymap:=2; dlocx:=12; dlocy:=13;
   dencount[1]:=35; dencount[2]:=34; dencount[3]:=7; dencount[4]:=1;
   dencount[5]:=4;
   toggle:=21;
end;


with dunner[41] do begin
   dxmap:=2; dymap:=2; dlocx:=20; dlocy:=15;
   dencount[1]:=36; dencount[2]:=34; dencount[3]:=1; dencount[4]:=1;
   dencount[5]:=4;
   toggle:=22;
end;


with dunner[42] do begin
   dxmap:=2; dymap:=2; dlocx:=33; dlocy:=18;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=24;
end;


{NEW SECTION!!!!}
with dunner[43] do begin
   dxmap:=2; dymap:=3; dlocx:=33; dlocy:=8;
   dencount[1]:=7; dencount[2]:=7; dencount[3]:=7; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=25;
end;

with dunner[44] do begin
   dxmap:=2; dymap:=3; dlocx:=3; dlocy:=14;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=26;
end;

with dunner[45] do begin
   dxmap:=2; dymap:=3; dlocx:=9; dlocy:=15;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=26;
end;

assign(dun_room_file,'DUNRM1.PIT');
rewrite(dun_room_file);
for cramps := 1 to MAX_IN_FILE do
  write(dun_room_file,dunner[cramps]);
close(dun_room_file);
end.


program create_room_filez;
const MAX_IN_FILE = 27;
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
   dxmap:=1; dymap:=1; dlocx:=29; dlocy:=8;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=46;
end;

with dunner[2] do begin
   dxmap:=1; dymap:=1; dlocx:=25; dlocy:=10;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=46;
end;

with dunner[3] do begin
   dxmap:=1; dymap:=1; dlocx:=40; dlocy:=8;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=1; dencount[4]:=34;
   dencount[5]:=4;
   toggle:=47;
end;

with dunner[4] do begin
   dxmap:=1; dymap:=1; dlocx:=44; dlocy:=10;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=1; dencount[4]:=34;
   dencount[5]:=4;
   toggle:=47;
end;

with dunner[5] do begin
   dxmap:=1; dymap:=1; dlocx:=25; dlocy:=14;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=1; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=48;
end;

with dunner[6] do begin
   dxmap:=1; dymap:=1; dlocx:=29; dlocy:=16;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=1; dencount[4]:=28;
   dencount[5]:=3;
   toggle:=48;
end;

with dunner[7] do begin
   dxmap:=1; dymap:=1; dlocx:=44; dlocy:=14;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=49;
end;

with dunner[8] do begin
   dxmap:=1; dymap:=1; dlocx:=40; dlocy:=16;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=49;
end;
{new section!!!!}
with dunner[9] do begin
   dxmap:=1; dymap:=2; dlocx:=38; dlocy:=7;
   dencount[1]:=5; dencount[2]:=9; dencount[3]:=5; dencount[4]:=8;
   dencount[5]:=4;
   toggle:=50;
end;

with dunner[10] do begin
   dxmap:=1; dymap:=2; dlocx:=47; dlocy:=11;
   dencount[1]:=10; dencount[2]:=37; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=51;
end;

with dunner[11] do begin
   dxmap:=1; dymap:=2; dlocx:=36; dlocy:=10;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=31; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=52;
end;

with dunner[12] do begin
   dxmap:=1; dymap:=2; dlocx:=32; dlocy:=12;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=31; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=52;
end;

with dunner[13] do begin
   dxmap:=1; dymap:=2; dlocx:=39; dlocy:=12;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=31; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=52;
end;

with dunner[14] do begin
   dxmap:=1; dymap:=2; dlocx:=36; dlocy:=13;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=31; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=52;
end;


with dunner[15] do begin
   dxmap:=1; dymap:=3; dlocx:=42; dlocy:=7;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=37; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=53;
end;

with dunner[16] do begin
   dxmap:=1; dymap:=3; dlocx:=47; dlocy:=9;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=37; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=53;
end;

with dunner[17] do begin
   dxmap:=1; dymap:=3; dlocx:=29; dlocy:=13;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=7; dencount[4]:=7;
   dencount[5]:=4;
   toggle:=54;
end;


with dunner[18] do begin
   dxmap:=1; dymap:=4; dlocx:=26; dlocy:=7;
   dencount[1]:=37; dencount[2]:=31; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=55;
end;

with dunner[19] do begin
   dxmap:=1; dymap:=4; dlocx:=29; dlocy:=8;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=56;
end;


with dunner[20] do begin
   dxmap:=1; dymap:=4; dlocx:=38; dlocy:=8;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=38; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=57;
end;


with dunner[21] do begin
   dxmap:=1; dymap:=4; dlocx:=37; dlocy:=11;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=38; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=57;
end;

with dunner[22] do begin
   dxmap:=1; dymap:=4; dlocx:=38; dlocy:=13;
   dencount[1]:=37; dencount[2]:=38; dencount[3]:=31; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=58;
end;


with dunner[23] do begin
   dxmap:=1; dymap:=4; dlocx:=33; dlocy:=16;
   dencount[1]:=37; dencount[2]:=38; dencount[3]:=31; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=58;
end;

with dunner[24] do begin
   dxmap:=1; dymap:=5; dlocx:=29; dlocy:=11;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=31; dencount[4]:=38;
   dencount[5]:=4;
   toggle:=59;
end;


with dunner[25] do begin
   dxmap:=1; dymap:=5; dlocx:=42; dlocy:=11;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=31; dencount[4]:=52;
   dencount[5]:=4;
   toggle:=60;
end;


with dunner[26] do begin
   dxmap:=1; dymap:=5; dlocx:=29; dlocy:=13;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=52; dencount[4]:=52;
   dencount[5]:=4;
   toggle:=61;
end;

with dunner[27] do begin
   dxmap:=1; dymap:=5; dlocx:=42; dlocy:=13;
   dencount[1]:=37; dencount[2]:=37; dencount[3]:=37; dencount[4]:=37;
   dencount[5]:=4;
   toggle:=62;
end;
assign(dun_room_file,'DUNRM0.PIT');
rewrite(dun_room_file);
for cramps := 1 to MAX_IN_FILE do
  write(dun_room_file,dunner[cramps]);
close(dun_room_file);
end.


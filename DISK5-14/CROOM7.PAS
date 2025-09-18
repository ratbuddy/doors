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
{starts at 78 for exemptions}
var cramps:byte;
    dunner: array [1.. MAX_IN_FILE] of dun_room;
    dun_room_file : file of dun_room;
begin
for cramps:=1 to MAX_IN_FILE do dunner[cramps].special :=0;
with dunner[1] do begin
   dxmap:=1; dymap:=1; dlocx:=37; dlocy:=6;
   dencount[1]:=61; dencount[2]:=61; dencount[3]:=61; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=78;
end;

with dunner[2] do begin
   dxmap:=1; dymap:=1; dlocx:=43; dlocy:=6;
   dencount[1]:=61; dencount[2]:=61; dencount[3]:=61; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=78;
end;

with dunner[3] do begin
   dxmap:=1; dymap:=1; dlocx:=18; dlocy:=7;
   dencount[1]:=62; dencount[2]:=61; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=79;
end;

with dunner[4] do begin
   dxmap:=1; dymap:=1; dlocx:=19; dlocy:=11;
   dencount[1]:=59; dencount[2]:=59; dencount[3]:=61; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=80;
end;

with dunner[5] do begin
   dxmap:=1; dymap:=1; dlocx:=19; dlocy:=14;
   dencount[1]:=59; dencount[2]:=59; dencount[3]:=61; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=80;
end;

with dunner[6] do begin
   dxmap:=1; dymap:=1; dlocx:=39; dlocy:=11;
   dencount[1]:=53; dencount[2]:=53; dencount[3]:=31; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=81;
end;

with dunner[7] do begin
   dxmap:=1; dymap:=1; dlocx:=37; dlocy:=13;
   dencount[1]:=53; dencount[2]:=53; dencount[3]:=31; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=81;
end;

with dunner[8] do begin
   dxmap:=1; dymap:=3; dlocx:=49; dlocy:=11;
   dencount[1]:=19; dencount[2]:=19; dencount[3]:=19; dencount[4]:=19;
   dencount[5]:=4;
   toggle:=82;
end;

with dunner[9] do begin
   dxmap:=1; dymap:=3; dlocx:=15; dlocy:=12;
   dencount[1]:=55; dencount[2]:=55; dencount[3]:=55; dencount[4]:=55;
   dencount[5]:=4;
   toggle:=83;
end;

with dunner[10] do begin
   dxmap:=1; dymap:=4; dlocx:=20; dlocy:=6;
   dencount[1]:=61; dencount[2]:=61; dencount[3]:=61; dencount[4]:=61;
   dencount[5]:=4;
   toggle:=84;
end;

with dunner[11] do begin
   dxmap:=1; dymap:=4; dlocx:=46; dlocy:=6;
   dencount[1]:=47; dencount[2]:=47; dencount[3]:=47; dencount[4]:=47;
   dencount[5]:=4;
   toggle:=85;
end;


with dunner[12] do begin
   dxmap:=1; dymap:=4; dlocx:=39; dlocy:=10;
   dencount[1]:=47; dencount[2]:=47; dencount[3]:=47; dencount[4]:=47;
   dencount[5]:=4;
   toggle:=85;
end;


with dunner[13] do begin
   dxmap:=1; dymap:=4; dlocx:=34; dlocy:=14;
   dencount[1]:=31; dencount[2]:=31; dencount[3]:=31; dencount[4]:=31;
   dencount[5]:=4;
   toggle:=86;
end;


with dunner[14] do begin
   dxmap:=1; dymap:=4; dlocx:=33; dlocy:=17;
   dencount[1]:=31; dencount[2]:=31; dencount[3]:=31; dencount[4]:=31;
   dencount[5]:=4;
   toggle:=86;
end;


with dunner[15] do begin
   dxmap:=1; dymap:=4; dlocx:=37; dlocy:=15;
   dencount[1]:=62; dencount[2]:=62; dencount[3]:=62; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=87;
end;

with dunner[16] do begin
   dxmap:=1; dymap:=4; dlocx:=38; dlocy:=19;
   dencount[1]:=62; dencount[2]:=62; dencount[3]:=62; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=87;
end;

with dunner[17] do begin
   dxmap:=1; dymap:=4; dlocx:=30; dlocy:=19;
   dencount[1]:=62; dencount[2]:=62; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=88;
end;

with dunner[18] do begin
   dxmap:=1; dymap:=5; dlocx:=20; dlocy:=5;
   dencount[1]:=53; dencount[2]:=62; dencount[3]:=53; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=89;
end;

with dunner[19] do begin
   dxmap:=1; dymap:=5; dlocx:=18; dlocy:=7;
   dencount[1]:=53; dencount[2]:=62; dencount[3]:=53; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=89;
end;

with dunner[20] do begin
   dxmap:=1; dymap:=5; dlocx:=44; dlocy:=6;
   dencount[1]:=61; dencount[2]:=61; dencount[3]:=61; dencount[4]:=61;
   dencount[5]:=4;
   toggle:=90;
end;

with dunner[21] do begin
   dxmap:=1; dymap:=5; dlocx:=48; dlocy:=8;
   dencount[1]:=61; dencount[2]:=61; dencount[3]:=61; dencount[4]:=61;
   dencount[5]:=4;
   toggle:=90;
end;

with dunner[22] do begin
   dxmap:=1; dymap:=5; dlocx:=34; dlocy:=16;
   dencount[1]:=22; dencount[2]:=22; dencount[3]:=22; dencount[4]:=22;
   dencount[5]:=4;
   toggle:=91;
end;


with dunner[23] do begin
   dxmap:=1; dymap:=5; dlocx:=30; dlocy:=18;
   dencount[1]:=22; dencount[2]:=22; dencount[3]:=22; dencount[4]:=22;
   dencount[5]:=4;
   toggle:=91;
end;

with dunner[24] do begin
   dxmap:=1; dymap:=5; dlocx:=17; dlocy:=17;
   dencount[1]:=61; dencount[2]:=61; dencount[3]:=61; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=92;
end;

with dunner[25] do begin
   dxmap:=1; dymap:=5; dlocx:=20; dlocy:=18;
   dencount[1]:=61; dencount[2]:=61; dencount[3]:=61; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=92;
end;

with dunner[26] do begin
   dxmap:=1; dymap:=5; dlocx:=49; dlocy:=17;
   dencount[1]:=62; dencount[2]:=62; dencount[3]:=31; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=93;
end;

with dunner[27] do begin
   dxmap:=1; dymap:=5; dlocx:=46; dlocy:=18;
   dencount[1]:=62; dencount[2]:=62; dencount[3]:=31; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=93;
end;

assign(dun_room_file,'DUNRM7.PIT');
rewrite(dun_room_file);
for cramps := 1 to MAX_IN_FILE do
  write(dun_room_file,dunner[cramps]);
close(dun_room_file);
end.


program create_room_filez;
const MAX_IN_FILE = 26;
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
   dxmap:=1; dymap:=1; dlocx:=25; dlocy:=7;
   dencount[1]:=65; dencount[2]:=65; dencount[3]:=65; dencount[4]:=65;
   dencount[5]:=4;
   toggle:=123;
end;


with dunner[2] do begin
   dxmap:=1; dymap:=1; dlocx:=22; dlocy:=10;
   dencount[1]:=65; dencount[2]:=65; dencount[3]:=65; dencount[4]:=65;
   dencount[5]:=4;
   toggle:=123;
end;


with dunner[3] do begin
   dxmap:=1; dymap:=1; dlocx:=30; dlocy:=11;
   dencount[1]:=66; dencount[2]:=67; dencount[3]:=67; dencount[4]:=67;
   dencount[5]:=4;
   toggle:=124;
end;

with dunner[4] do begin
   dxmap:=1; dymap:=1; dlocx:=39; dlocy:=14;
   dencount[1]:=66; dencount[2]:=67; dencount[3]:=67; dencount[4]:=67;
   dencount[5]:=4;
   toggle:=124;
end;

with dunner[5] do begin
   dxmap:=1; dymap:=1; dlocx:=13; dlocy:=14;
   dencount[1]:=65; dencount[2]:=65; dencount[3]:=65; dencount[4]:=59;
   dencount[5]:=4;
   toggle:=125;
end;

with dunner[6] do begin
   dxmap:=1; dymap:=1; dlocx:=15; dlocy:=15;
   dencount[1]:=65; dencount[2]:=65; dencount[3]:=65; dencount[4]:=59;
   dencount[5]:=4;
   toggle:=125;
end;

with dunner[7] do begin
   dxmap:=1; dymap:=1; dlocx:=42; dlocy:=16;
   dencount[1]:=65; dencount[2]:=65; dencount[3]:=65; dencount[4]:=65;
   dencount[5]:=4;
   toggle:=126;
end;

with dunner[8] do begin
   dxmap:=1; dymap:=1; dlocx:=44; dlocy:=18;
   dencount[1]:=65; dencount[2]:=65; dencount[3]:=65; dencount[4]:=65;
   dencount[5]:=4;
   toggle:=126;
end;

with dunner[9] do begin
   dxmap:=1; dymap:=1; dlocx:=53; dlocy:=8;
   dencount[1]:=39; dencount[2]:=49; dencount[3]:=52; dencount[4]:=65;
   dencount[5]:=4;
   toggle:=127; special:=3;
end;

with dunner[10] do begin
   dxmap:=1; dymap:=2; dlocx:=58; dlocy:=6;
   dencount[1]:=49; dencount[2]:=64; dencount[3]:=63; dencount[4]:=65;
   dencount[5]:=4;
   toggle:=128;
end;

with dunner[11] do begin
   dxmap:=1; dymap:=2; dlocx:=18; dlocy:=11;
   dencount[1]:=49; dencount[2]:=64; dencount[3]:=63; dencount[4]:=62;
   dencount[5]:=4;
   toggle:=129;
end;

with dunner[12] do begin
   dxmap:=1; dymap:=2; dlocx:=38; dlocy:=11;
   dencount[1]:=49; dencount[2]:=54; dencount[3]:=49; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=130;
end;

with dunner[13] do begin
   dxmap:=1; dymap:=2; dlocx:=57; dlocy:=18;
   dencount[1]:=49; dencount[2]:=54; dencount[3]:=63; dencount[4]:=63;
   dencount[5]:=4;
   toggle:=131;
end;

with dunner[14] do begin
   dxmap:=1; dymap:=3; dlocx:=58; dlocy:=10;
   dencount[1]:=63; dencount[2]:=64; dencount[3]:=32; dencount[4]:=54;
   dencount[5]:=4;
   toggle:=132;
end;

with dunner[15] do begin
   dxmap:=1; dymap:=4; dlocx:=37; dlocy:=8;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=49;
   dencount[5]:=4;
   toggle:=133;
end;

with dunner[16] do begin
   dxmap:=1; dymap:=4; dlocx:=31; dlocy:=12;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=49;
   dencount[5]:=4;
   toggle:=133;
end;

with dunner[17] do begin
   dxmap:=1; dymap:=4; dlocx:=42; dlocy:=13;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=49;
   dencount[5]:=4;
   toggle:=133;
end;

with dunner[18] do begin
   dxmap:=1; dymap:=4; dlocx:=37; dlocy:=15;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=49;
   dencount[5]:=4;
   toggle:=133;
end;

with dunner[19] do begin
   dxmap:=1; dymap:=4; dlocx:=29; dlocy:=15;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=64; dencount[4]:=65;
   dencount[5]:=4;
   toggle:=134;
end;

with dunner[20] do begin
   dxmap:=1; dymap:=4; dlocx:=41; dlocy:=17;
   dencount[1]:=49; dencount[2]:=49; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=135;
end;

with dunner[21] do begin
   dxmap:=1; dymap:=5; dlocx:=18; dlocy:=4;
   dencount[1]:=63; dencount[2]:=63; dencount[3]:=62; dencount[4]:=64;
   dencount[5]:=4;
   toggle:=136;
end;

with dunner[22] do begin
   dxmap:=1; dymap:=5; dlocx:=55; dlocy:=4;
   dencount[1]:=63; dencount[2]:=59; dencount[3]:=62; dencount[4]:=64;
   dencount[5]:=4;
   toggle:=137;
end;

with dunner[23] do begin
   dxmap:=1; dymap:=5; dlocx:=29; dlocy:=5;
   dencount[1]:=63; dencount[2]:=59; dencount[3]:=62; dencount[4]:=65;
   dencount[5]:=4;
   toggle:=138;
end;

with dunner[24] do begin
   dxmap:=1; dymap:=5; dlocx:=29; dlocy:=9;
   dencount[1]:=63; dencount[2]:=59; dencount[3]:=62; dencount[4]:=65;
   dencount[5]:=4;
   toggle:=138;
end;

with dunner[25] do begin
   dxmap:=1; dymap:=5; dlocx:=45; dlocy:=5;
   dencount[1]:=63; dencount[2]:=59; dencount[3]:=54; dencount[4]:=65;
   dencount[5]:=4;
   toggle:=139;
end;

with dunner[26] do begin
   dxmap:=1; dymap:=5; dlocx:=46; dlocy:=9;
   dencount[1]:=63; dencount[2]:=59; dencount[3]:=54; dencount[4]:=65;
   dencount[5]:=4;
   toggle:=139;
end;


assign(dun_room_file,'DUNRM5.PIT');
rewrite(dun_room_file);
for cramps := 1 to MAX_IN_FILE do
  write(dun_room_file,dunner[cramps]);
close(dun_room_file);
end.


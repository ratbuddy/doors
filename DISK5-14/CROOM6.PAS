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
   dxmap:=1; dymap:=1; dlocx:=44; dlocy:=10;
   dencount[1]:=56; dencount[2]:=56; dencount[3]:=56; dencount[4]:=56;
   dencount[5]:=4;
   toggle:=63;
end;

with dunner[2] do begin
   dxmap:=1; dymap:=1; dlocx:=48; dlocy:=10;
   dencount[1]:=56; dencount[2]:=56; dencount[3]:=56; dencount[4]:=56;
   dencount[5]:=4;
   toggle:=63;
end;

with dunner[3] do begin
   dxmap:=1; dymap:=1; dlocx:=46; dlocy:=12;
   dencount[1]:=56; dencount[2]:=56; dencount[3]:=56; dencount[4]:=56;
   dencount[5]:=4;
   toggle:=63;
end;

with dunner[4] do begin
   dxmap:=1; dymap:=1; dlocx:=41; dlocy:=16;
   dencount[1]:=56; dencount[2]:=54; dencount[3]:=42; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=64;
end;


with dunner[5] do begin
   dxmap:=1; dymap:=1; dlocx:=45; dlocy:=17;
   dencount[1]:=56; dencount[2]:=54; dencount[3]:=42; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=64;
end;

with dunner[6] do begin
   dxmap:=1; dymap:=1; dlocx:=57; dlocy:=17;
   dencount[1]:=56; dencount[2]:=56; dencount[3]:=56; dencount[4]:=5;
   dencount[5]:=4;
   toggle:=65;
end;

with dunner[7] do begin
   dxmap:=1; dymap:=1; dlocx:=63; dlocy:=19;
   dencount[1]:=56; dencount[2]:=56; dencount[3]:=56; dencount[4]:=5;
   dencount[5]:=4;
   toggle:=65;
end;
{for 611.dng all the above!!!}
{NOW FOR 621.DNG ALL BELOW!!!}

with dunner[8] do begin
   dxmap:=2; dymap:=1; dlocx:=50; dlocy:=8;
   dencount[1]:=53; dencount[2]:=53; dencount[3]:=53; dencount[4]:=53;
   dencount[5]:=4;
   toggle:=66;
end;

with dunner[9] do begin
   dxmap:=2; dymap:=1; dlocx:=50; dlocy:=13;
   dencount[1]:=53; dencount[2]:=53; dencount[3]:=53; dencount[4]:=53;
   dencount[5]:=4;
   toggle:=66;
end;

with dunner[10] do begin
   dxmap:=2; dymap:=1; dlocx:=33; dlocy:=11;
   dencount[1]:=56; dencount[2]:=56; dencount[3]:=56; dencount[4]:=56;
   dencount[5]:=4;
   toggle:=67;
end;

with dunner[11] do begin
   dxmap:=2; dymap:=1; dlocx:=33; dlocy:=17;
   dencount[1]:=55; dencount[2]:=55; dencount[3]:=55; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=68;
end;

with dunner[12] do begin
   dxmap:=2; dymap:=1; dlocx:=41; dlocy:=13;
   dencount[1]:=31; dencount[2]:=31; dencount[3]:=31; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=69;
end;

with dunner[13] do begin
   dxmap:=2; dymap:=1; dlocx:=44; dlocy:=13;
   dencount[1]:=47; dencount[2]:=47; dencount[3]:=47; dencount[4]:=47;
   dencount[5]:=4;
   toggle:=70;
end;

with dunner[14] do begin
   dxmap:=2; dymap:=1; dlocx:=47; dlocy:=13;
   dencount[1]:=13; dencount[2]:=13; dencount[3]:=13; dencount[4]:=13;
   dencount[5]:=4;
   toggle:=71;
end;


with dunner[15] do begin
   dxmap:=2; dymap:=1; dlocx:=33; dlocy:=14;
   dencount[1]:=53; dencount[2]:=53; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=72;
end;

with dunner[16] do begin
   dxmap:=2; dymap:=1; dlocx:=53; dlocy:=14;
   dencount[1]:=53; dencount[2]:=53; dencount[3]:=53; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=73;
end;

with dunner[17] do begin
   dxmap:=2; dymap:=1; dlocx:=41; dlocy:=15;
   dencount[1]:=55; dencount[2]:=44; dencount[3]:=55; dencount[4]:=44;
   dencount[5]:=4;
   toggle:=74;
end;

with dunner[18] do begin
   dxmap:=2; dymap:=1; dlocx:=44; dlocy:=15;
   dencount[1]:=47; dencount[2]:=47; dencount[3]:=53; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=75;
end;

with dunner[19] do begin
   dxmap:=2; dymap:=1; dlocx:=47; dlocy:=15;
   dencount[1]:=47; dencount[2]:=47; dencount[3]:=53; dencount[4]:=47;
   dencount[5]:=4;
   toggle:=76;
end;

with dunner[20] do begin
   dxmap:=2; dymap:=1; dlocx:=50; dlocy:=15;
   dencount[1]:=31; dencount[2]:=47; dencount[3]:=53; dencount[4]:=47;
   dencount[5]:=4;
   toggle:=77;
end;

with dunner[21] do begin
   dxmap:=5; dymap:=1; dlocx:=23; dlocy:=12;
   dencount[1]:=62; dencount[2]:=62; dencount[3]:=31; dencount[4]:=31;
   dencount[5]:=4;
   toggle:=94;
end;

{#95 toggle is the fountain in the Oasis}


with dunner[22] do begin
   dxmap:=4; dymap:=1; dlocx:=32; dlocy:=10;
   dencount[1]:=53; dencount[2]:=53; dencount[3]:=53; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=96;
end;

with dunner[23] do begin
   dxmap:=4; dymap:=1; dlocx:=38; dlocy:=10;
   dencount[1]:=53; dencount[2]:=53; dencount[3]:=53; dencount[4]:=53;
   dencount[5]:=4;
   toggle:=97;
end;

with dunner[24] do begin
   dxmap:=4; dymap:=1; dlocx:=38; dlocy:=13;
   dencount[1]:=56; dencount[2]:=56; dencount[3]:=56; dencount[4]:=56;
   dencount[5]:=4;
   toggle:=98;
end;

with dunner[25] do begin
   dxmap:=4; dymap:=1; dlocx:=32; dlocy:=16;
   dencount[1]:=22; dencount[2]:=22; dencount[3]:=23; dencount[4]:=60;
   dencount[5]:=4;
   toggle:=99;
end;

with dunner[26] do begin
   dxmap:=4; dymap:=1; dlocx:=38; dlocy:=16;
   dencount[1]:=62; dencount[2]:=62; dencount[3]:=31; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=100;
end;


{byte 102 is Soma Kills and 101 is Mojave!!!}












assign(dun_room_file,'DUNRM6.PIT');
rewrite(dun_room_file);
for cramps := 1 to MAX_IN_FILE do
  write(dun_room_file,dunner[cramps]);
close(dun_room_file);
end.


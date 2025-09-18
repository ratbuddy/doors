program create_room_filez;
const MAX_IN_FILE = 14;
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
   dxmap:=1; dymap:=1; dlocx:=42; dlocy:=13;
   dencount[1]:=4; dencount[2]:=4; dencount[3]:=4; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=34;
end;

with dunner[2] do begin
   dxmap:=1; dymap:=1; dlocx:=60; dlocy:=17;
   dencount[1]:=4; dencount[2]:=3; dencount[3]:=3; dencount[4]:=3;
   dencount[5]:=4;
   toggle:=35;
end;

with dunner[3] do begin
   dxmap:=2; dymap:=1; dlocx:=10; dlocy:=7;
   dencount[1]:=44; dencount[2]:=44; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=36;
end;

with dunner[4] do begin
   dxmap:=2; dymap:=1; dlocx:=59; dlocy:=7;
   dencount[1]:=3; dencount[2]:=3; dencount[3]:=3; dencount[4]:=13;
   dencount[5]:=4;
   toggle:=37;
end;

with dunner[5] do begin
   dxmap:=2; dymap:=1; dlocx:=68; dlocy:=7;
   dencount[1]:=3; dencount[2]:=3; dencount[3]:=3; dencount[4]:=13;
   dencount[5]:=4;
   toggle:=37;
end;

with dunner[6] do begin
   dxmap:=2; dymap:=1; dlocx:=40; dlocy:=11;
   dencount[1]:=4; dencount[2]:=4; dencount[3]:=4; dencount[4]:=4;
   dencount[5]:=4;
   toggle:=38;
end;

with dunner[7] do begin
   dxmap:=2; dymap:=1; dlocx:=46; dlocy:=11;
   dencount[1]:=4; dencount[2]:=4; dencount[3]:=4; dencount[4]:=4;
   dencount[5]:=4;
   toggle:=38;
end;

with dunner[8] do begin
   dxmap:=2; dymap:=1; dlocx:=60; dlocy:=13;
   dencount[1]:=47; dencount[2]:=3; dencount[3]:=3; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=39;
end;

with dunner[9] do begin
   dxmap:=2; dymap:=1; dlocx:=19; dlocy:=16;
   dencount[1]:=44; dencount[2]:=7; dencount[3]:=7; dencount[4]:=7;
   dencount[5]:=4;
   toggle:=40;
end;

with dunner[10] do begin
   dxmap:=2; dymap:=1; dlocx:=50; dlocy:=17;
   dencount[1]:=13; dencount[2]:=3; dencount[3]:=3; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=41;
end;

with dunner[11] do begin
   dxmap:=2; dymap:=1; dlocx:=71; dlocy:=20;
   dencount[1]:=13; dencount[2]:=47; dencount[3]:=3; dencount[4]:=4;
   dencount[5]:=4; special:=2;
   toggle:=42; {****** SPECIAL EYES OF DOOM *******}
end;

with dunner[12] do begin
   dxmap:=1; dymap:=2; dlocx:=27; dlocy:=4;
   dencount[1]:=9; dencount[2]:=9; dencount[3]:=9; dencount[4]:=9;
   dencount[5]:=4;
   toggle:=43;
end;

with dunner[13] do begin
   dxmap:=1; dymap:=2; dlocx:=41; dlocy:=6;
   dencount[1]:=3; dencount[2]:=3; dencount[3]:=3; dencount[4]:=3;
   dencount[5]:=4;
   toggle:=44;
end;

with dunner[14] do begin
   dxmap:=1; dymap:=2; dlocx:=27; dlocy:=10;
   dencount[1]:=11; dencount[2]:=7; dencount[3]:=7; dencount[4]:=11;
   dencount[5]:=4;
   toggle:=45;
end;

assign(dun_room_file,'DUNRM2.PIT');
rewrite(dun_room_file);
for cramps := 1 to MAX_IN_FILE do
  write(dun_room_file,dunner[cramps]);
close(dun_room_file);
end.


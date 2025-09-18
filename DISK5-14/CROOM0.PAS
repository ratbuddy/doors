program create_room_filez;
const MAX_IN_FILE = 7;
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
   dxmap:=1; dymap:=1; dlocx:=64; dlocy:=9;
   dencount[1]:=1; dencount[2]:=34; dencount[3]:=45; dencount[4]:=1;
   dencount[5]:=4;
   toggle:=27;
end;

with dunner[2] do begin
   dxmap:=1; dymap:=1; dlocx:=16; dlocy:=10;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=28;
end;

with dunner[3] do begin
   dxmap:=1; dymap:=1; dlocx:=24; dlocy:=10;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=29;
end;

with dunner[4] do begin
   dxmap:=1; dymap:=1; dlocx:=54; dlocy:=11;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=1;
   dencount[5]:=4;
   toggle:=30;
end;

with dunner[5] do begin
   dxmap:=1; dymap:=1; dlocx:=24; dlocy:=12;
   dencount[1]:=1; dencount[2]:=1; dencount[3]:=1; dencount[4]:=50;
   dencount[5]:=3;
   toggle:=31;
end;

with dunner[6] do begin
   dxmap:=1; dymap:=1; dlocx:=45; dlocy:=12;
   dencount[1]:=28; dencount[2]:=1; dencount[3]:=1; dencount[4]:=28;
   dencount[5]:=4;
   toggle:=32;
end;

with dunner[7] do begin
   dxmap:=1; dymap:=1; dlocx:=23; dlocy:=19;
   dencount[1]:=1; dencount[2]:=36; dencount[3]:=50; dencount[4]:=50;
   dencount[5]:=2;
   toggle:=33;
end;

assign(dun_room_file,'DUNRM0.PIT');
rewrite(dun_room_file);
for cramps := 1 to MAX_IN_FILE do
  write(dun_room_file,dunner[cramps]);
close(dun_room_file);
end.


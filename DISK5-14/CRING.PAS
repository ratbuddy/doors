program crings;
const MAXRING=19;
type ringer = record
       idnum : byte;
       name  : string[20];
     magical : byte;
      battle : boolean;
      charges: byte;
      minddam: byte;
      maxdam : byte;
      cost   : integer;
      end;

var ring: array [0..MAXRING] of ringer;
   filex : file of ringer;
   x: integer;
begin
for x:=0 to MAXRING do ring[x].idnum:=x;
with ring[0] do begin
 name:='No Ring'; magical:=0; battle:=false; charges:= 0;
 minddam:=0; maxdam:=1; cost:=0;
end;

with ring[1] do begin
  name:='PROTECTION'; magical:=1; battle:=false; charges:=0;
  minddam:=0; maxdam:=1; cost:=600;
end;

with ring[2] do begin
  name:='PROTECTION'; magical:=2; battle:=false; charges:=0;
  minddam:=0; maxdam:=1; cost:=1200;
end;

with ring[3] do begin
  name:='PROTECTION'; magical:=3; battle:=false; charges:=0;
  minddam:=0; maxdam:=1; cost:=2400;
end;

with ring[4] do begin
  name:='PROTECTION'; magical:=4; battle:=false; charges:=0;
  minddam:=0; maxdam:=1; cost:=4800;
end;

with ring[5] do begin
  name:='PROTECTION'; magical:=5; battle:=false; charges:=0;
  minddam:=0; maxdam:=1; cost:=6800;
end;

with ring[6] do begin
  name:='SHOCKING'; magical:=0; battle:=true; charges:=10;
  minddam:=1; maxdam:=8; cost:=200;
end;

with ring[7] do begin
  name:='ICE CHILL'; magical:=0; battle:=true; charges:=10;
  minddam:=2; maxdam:=16; cost:=400;
end;

with ring[8] do begin
  name:='SHARP PAINS'; magical:=0; battle:=true; charges:=10;
  minddam:=3; maxdam:=30; cost:=800;
end;

with ring[9] do begin
  name:='SKULL CRUSHER'; magical:=0; battle:=true; charges:=10;
  minddam:=5; maxdam:=50; cost:=1600;
end;

with ring[10] do begin
  name:='WALL REMOVER'; magical:=0; battle:=false; charges:=20;
  minddam:=0; maxdam:=1; cost:=2500;
end;

with ring[11] do begin
  name:='WALL REMOVER #2'; magical:=0; battle:=false; charges:=40;
  minddam:=0; maxdam:=1; cost:=5000;
end;

with ring[12] do begin
  name:='REGENERATION'; magical:=1; battle:=false; charges:=0;
  minddam:=0; maxdam:=1; cost:=2500;
end;

with ring[13] do begin
  name:='REGENERATION'; magical:=2; battle:=false; charges:=40;
  minddam:=0; maxdam:=1; cost:=4000;
end;

with ring[14] do begin
  name:='X-RAY VISION'; magical:=0; battle:=false; charges:=40;
  minddam:=0; maxdam:=1; cost:=2000;
end;

with ring[15] do begin
  name:='FEATHER FALLING'; magical:=0; battle:=false; charges:=0;
  minddam:=0; maxdam:=1; cost:=100;
end;

with ring[16] do begin
  name:='WATER WALKING'; magical:=0; battle:=false; charges:=30;
  minddam:=0; maxdam:=1; cost:=350;
end;

with ring[17] do begin
  name:='TELEPORTATION'; magical:=0; battle:=false; charges:=10;
  minddam:=0; maxdam:=1; cost:=8000;
end;

with ring[18] do begin
  name:='GROUND LEVEL'; magical:=0; battle:=false; charges:=1;
  minddam:=0; maxdam:=1; cost:=50;
end;

with ring[19] do begin
  name:='MAGIC SHIELD'; magical:=0; battle:=false; charges:=255;
  minddam:=0; maxdam:=1; cost:=10000;
end;

assign(filex,'RINGS.DAT');
rewrite(filex);
for x:=0 to MAXRING do begin
  write(filex,ring[x]);
  writeln(ring[x].name);
end;
close(filex);
end.
program create_dungeons;
{This program creates DUNGEON.INF, all the neccessary information that
 may be required to get in and out of a lame dungeon}

CONST MAXDUNS =11;
type
dun_rec = record
dwords : array [1..3] of string[3];
nilword: boolean;
dnum   : byte;
dlocx  : byte;
dlocy  : byte;
dname  : string[30];
ttoggle: byte;
xmap   : byte;
ymap   : byte;
xactual: byte;
yactual: byte;
end;

var dun_arr : array [1.. MAXDUNS] of dun_rec;
    dun_file: file of dun_rec;
    count: integer;
begin
with dun_arr[1] do begin
   dwords[1]:='NIL';
   dwords[2]:='NIL';
   dwords[3]:='NIL';
   nilword:=true; {hey, like no words neccessary to get in!}
   dnum:=1;
   dlocx:=16;
   dlocy:=19;
   dname:='JESSOE''S COTTAGE';
   ttoggle:=0;
   xmap:=1;
   ymap:=3;
   xactual:=22;
   yactual:=5;
end;

with dun_arr[2] do begin
   dwords[1]:='NIL';
   dwords[2]:='NIL';
   dwords[3]:='NIL';
   nilword:=true; {hey, like no words neccessary to get in!}
   dnum:=1;
   dlocx:=37;
   dlocy:=13;
   dname:='KOBOLD''S CAVE';
   ttoggle:=0;
   xmap:=3;
   ymap:=3;
   xactual:=29;
   yactual:=4;
end;

with dun_arr[3] do begin
   dwords[1]:='SAL';
   dwords[2]:='SEA';
   dwords[3]:='CAP';
   nilword:=false; {hey, like words neccessary to get in!}
   dnum:=1;
   dlocx:=41;
   dlocy:=15;
   dname:='CRILEY''S LIGHTHOUSE';
   ttoggle:=2;
   xmap:=6;
   ymap:=1;
   xactual:=41;
   yactual:=21;
end;

with dun_arr[4] do begin
   dwords[1]:='NIL';
   dwords[2]:='NIL';
   dwords[3]:='NIL';
   nilword:=true; {hey, like no words to get in}
   dnum:=1;
   dlocx:=53;
   dlocy:=11;
   dname:='THE CAVE';
   ttoggle:=1;
   xmap:=2;
   ymap:=2;
   xactual:=16;
   yactual:=12;
end;

with dun_arr[5] do begin
   dwords[1]:='BLD';
   dwords[2]:='RAG';
   dwords[3]:='CAM';
   nilword:=false;
   dnum:=1;
   dlocx:=60;
   dlocy:=12;
   dname:='HEMO''S ABBEY';
   ttoggle:=3;  { sage by hut}
   xmap:=9;
   ymap:=5;
   xactual:=36;
   yactual:=17;
end;

with dun_arr[6] do begin
   dwords[1]:='BLD';
   dwords[2]:='RED';
   dwords[3]:='DTH';
   nilword:=false;
   dnum:=2;
   dlocx:=40;
   dlocy:=07;
   dname:='CASSANDRA''S COMPLEX';
   ttoggle:=4;  { sage by hut}
   xmap:=1;
   ymap:=2;
   xactual:=14;
   yactual:=04;
end;

with dun_arr[7] do begin
   dwords[1]:='NIL';
   dwords[2]:='NIL';
   dwords[3]:='NIL';
   nilword:=true;
   dnum:=2;
   dlocx:=37;
   dlocy:=10;
   dname:='THE COLD CAVERN';
   ttoggle:=1;
   xmap:=1;
   ymap:=9;
   xactual:=56;
   yactual:=5;
end;

with dun_arr[8] do begin
   dwords[1]:='NIL';
   dwords[2]:='NIL';
   dwords[3]:='NIL';
   nilword:=true;
   dnum:=2;
   dlocx:=17;
   dlocy:=08;
   dname:='THE NIGHTMARE';
   ttoggle:=1;
   xmap:=3;
   ymap:=4;
   xactual:=10;
   yactual:=20;
end;

with dun_arr[9] do begin
   dwords[1]:='NIL';
   dwords[2]:='NIL';
   dwords[3]:='NIL';
   nilword:=true;
   dnum:=3;
   dlocx:=46;
   dlocy:=10;
   dname:='THE FINAL TOWER';
   ttoggle:=1;
   xmap:=1;
   ymap:=1;
   xactual:=35;
   yactual:=18;
end;

with dun_arr[10] do begin
   dwords[1]:='NIL';
   dwords[2]:='NIL';
   dwords[3]:='NIL';
   nilword:=true;
   dnum:=3;
   dlocx:=50;
   dlocy:=16;
   dname:='THE NEST';
   ttoggle:=1;
   xmap:=3;
   ymap:=3;
   xactual:=10;
   yactual:=06;
end;

with dun_arr[11] do begin
   dwords[1]:='NIL';
   dwords[2]:='NIL';
   dwords[3]:='NIL';
   nilword:=true;
   dnum:=3;
   dlocx:=50;
   dlocy:=03;
   dname:='THE HUT';
   ttoggle:=1;
   xmap:=4;
   ymap:=4;
   xactual:=24;
   yactual:=15;
end;


assign(dun_file,'DUNGEON.INF');
rewrite(dun_file);
for count:=1 to MAXDUNS do
  write(dun_file,dun_arr[count]);
close(dun_file);
end.
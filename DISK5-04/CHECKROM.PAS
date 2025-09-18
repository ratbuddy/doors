program checker;
type combat_init= array [1..4] of byte;
type helper=string[75];
type
 dun_room = record
  dxmap:byte;
  dymap:byte;
  dlocx:byte;
  dlocy:byte;
  whatkind:combat_init;
  howmany:combat_init;
  toggler: byte;
  special: byte;
  food   : byte;
  scroll : boolean;
  scrollsay : helper;
  amount:integer;
  itemnum:byte;
  quant:byte;
 end;

var  room_file :file of dun_room;
     rom_ar    : array [1..75] of dun_room;
     x,y,lvl :integer;
     mapfile: file of char;
     mapper: array [1..80,1..23] of char;

procedure intro;
begin
writeln('Welcome to PF3''s Dungeon Room Checker!');
writeln('This program checks the validity of coords in dungeons and stuff');
writeln('This program is Copyrighted (1990) by Eddie Gaul');
writeln('All rights reserved');
writeln;
end;

procedure get_level;
begin
writeln('Enter the Level of the Dungeon you wish to check');
writeln('Enter 0 to Quit');
write('Choice :  ');
read(lvl);
writeln;
end;

procedure load_rooms;
begin
assign(room_file,'DUNRM'+chr(lvl+48)+'.PIT');
reset(room_file);
for x:= 1 to 75 do begin
  {$I-} read(room_file,rom_ar[x]); {$I+}
  if IOresult<>0 then x:=77;
end;
close(room_File);
end;

procedure check_room(t1,t2:integer);
var a,b,c,d: integer; test:boolean;
begin
c:=0;
for a:=1 to 23 do
 for b:=1 to 80 do
  if mapper[b,a]='D' then
  while not test do begin
    c:=c+1; test:=false;
    if t1=rom_ar[c].dxmap then
     if t2=rom_ar[c].dymap then
       if b=rom_ar[c].dlocx then
        if a=rom_ar[c].dlocy then
          test:=true;
     if c>74 then begin
       writeln('Room NOT FOUND!!!!');
       writeln('XMAP ',t1,' YMAP ',t2,' XLOC ',a,' YLOC ',b);
       halt;
       end;
  end;
end;


procedure do_work;
var c1,c2:integer;
begin
for c1:=0 to 9 do
 for c2:=0 to 9 do begin
   writeln('Working on Map LVL',lvl,c1,c2,'.DNG  ......');
   assign(mapfile,'LVL'+chr(lvl+48)+chr(c1+48)+chr(c2+48)+'.DNG');
   {$I-} reset(mapfile); {$I+}
   if IOresult=0 then begin
     for y:=1 to 23 do
       for x:=1 to 80 do
         read(mapfile,mapper[x,y]);
         check_room(c1,c2);
      close(mapfile);
   end;
end;
end;


begin
intro;
repeat
get_level;
if lvl>0 then begin
  load_rooms;
  do_work;
end;
until lvl=0;
end.
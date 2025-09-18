program finddoor;
var tx: string[12];
    map : array [1..80,1..23] of char;
    x,y : byte; okay : boolean;
    map_file : file of char;
    finder: char;
begin
textcolor(WHITE);
repeat
write('INPUT FILE NAME! -->'); okay :=false;
readln(tx);
if (tx='END') or (tx='end') then halt;
write('Enter Find Character --> ');
read(finder);
writeln;
assign(map_file,tx);
reset(map_file);

for x:=1 to 80 do
  for y:=1 to 23 do
   map[x,y]:=' ';
for y:=1 to 23 do
  for x:=1 to 80 do
   read(map_file,map[x,y]);
for y:=1 to 23 do
  for x:=1 to 80 do
    if map[x,y]=finder then writeln('       (',x,',',y,')  ');
close(map_file);
until okay;
end.
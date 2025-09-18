program shit;
var y,x: integer;
   map: array [1..80,1..23] of char;
   newf,filer : file of char;
   filename,file2 : string[25];
begin
textcolor(WHITE);
repeat
write('Enter Read File Name: ');
readln(filename);
if filename <> 'END' then begin
write('Now Enter Write File Name:  ');
readln(file2);
assign(filer,filename);
reset(filer);
assign(newf,file2);
rewrite(newf);
writeln('DE--->FUCKING FILES');
for y:=1 to 23 do
 for x:=1  to 80 do begin
  read(filer,map[x,y]);
  map[x,y]:=chr(ord(map[x,y]) + (x div 5));
  end;
for y:=1 to 23 do
 for x:=1  to 80 do
  write(newf,map[x,y]);
close(newf);
close(filer);
end;
until filename='END';
end.
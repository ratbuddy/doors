program view;
var y,x: integer;
   temp:char;
   map: array [1..80,1..23] of char;
   newf,filer : file of char;
   filename,file2 : string[25];
begin
textcolor(WHITE);
repeat
clrscr;
writeln('Enter "END" to Terminate Program! or Type File Name');
writeln('To View Dungeon File (i.e. WILDERXX.PIT or LVLXXX.DNG)');
write('Enter File Name: ');
readln(filename);
for y := 1 to Length(filename) do
  filename[y] := UpCase(filename[y]);
if filename <> 'END' then begin
assign(filer,filename);
{$I-} reset(filer); {$I+}
if IOResult <>0 then begin writeln('Invalid Filename! -- Enter any Key and Return'); read(temp); end
else begin
for y:=1 to 23 do
 for x:=1  to 80 do begin
  read(filer,map[x,y]);
  map[x,y]:=chr(ord(map[x,y]) + (x div 5));
  if map[x,y]<>'/' then write(map[x,y]) else write(' ');
  end;
close(filer);
writeln('Enter Any Key + Return');
read(temp);
end; end;
until filename='END';
end.
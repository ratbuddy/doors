program weather_changer;
type weather = record
       degree : byte;
    end;
type tickler = string[15];
var filex : file of char;
    filew : file of weather;
    conditions : weather;
    map: array [1..80,1..23] of char;

{$I COMMON.PAS}




procedure save_changes(filevar : tickler);
var x,y : integer;
begin
assign(filex,filevar);
rewrite(filex);
for y:=1 to 23 do
 for x:=1  to 80 do begin
  map[x,y]:=chr(ord(map[x,y]) - (x div 5));
  write(filex,map[x,y]);
 end;
close(filex);
end;

function check_river_formation(xxx,yyy: integer) :byte;
var t1,t2 : integer;
temper:byte;
begin
temper:=0;
for t1:=-1 to 1 do
  for t2:=-1 to 1 do
    if map[xxx+t2,yyy+t1]='∞' then
    temper:=temper+1;
check_river_formation:=temper;
end;

procedure do_wet;
var modr,xxa, xx,yy : integer;
test: byte;
begin
xxa:=conditions.degree;
modr:=xxa div 2;
modr:=modr+1;
for yy:=1 to 23 do
 for xx:=1 to 80 do
   if map[xx,yy]=' ' then
     if random(modr) = 1 then map[xx,yy]:='ù';
if map[xx,yy]=' ' then
    if random(modr+20) =1 then  begin test:=check_river_formation(xx,yy);
                      if test>2 then map[xx,yy]:='∞';
    end;
if map[xx,yy]='±' then
  if random(modr)=1 then map[xx,yy]:=' ';
end;


procedure do_hot;
var xx,yy,modr : integer;
test:byte;
begin
modr:=(256-conditions.degree) div 2;
for yy:=1 to 23 do
  for xx:=1 to 80 do
    if map[xx,yy]='ù' then
      if random(modr)=1 then map[xx,yy]:=' ';
if map[xx,yy]='∞' then
   if random(modr+25)=1 then begin
          test:=check_river_formation(xx,yy);
          if test<3 then map[xx,yy]:=' ';
   end;
if map[xx,yy]=' ' then
  if random(modr+25)=1 then map[xx,yy]:='±';
end;



procedure do_changes;
begin
if conditions.degree<86 then do_wet else do_hot;
end;

procedure load_map(filevar : tickler);
var x,y : integer;
begin
assign(filex,filevar);
{$I-} reset(filex); {$I+}
if IOresult = 0 then begin
for y:=1 to 23 do
 for x:=1  to 80 do begin
  read(filex,map[x,y]);
  map[x,y]:=chr(ord(map[x,y]) + (x div 5));
 end;
close(filex); do_changes; save_changes(filevar);
end;
end;

procedure load_weather;
begin
assign(filew,'WEATHER.INF');
reset(filew);
read(filew,conditions);
close(filew);
if (conditions.degree>85) and (conditions.degree<125) then begin
  ansic(8); print('No work needs to be done!'); halt; end;
end;

procedure do_work;
var filename : tickler;
    g,h : integer; temp2,temp3:char;
begin
ansic(8); print('Hold on a Sec... recreating Wilderness files!');
load_weather;
for g:=1 to 8 do
  for h:=1 to 8 do begin
  filename:='WILDER';
    temp2:=chr(g+48); temp3:=chr(h+48);
    filename:=filename+temp2+temp3+'.PIT';
    load_map(filename);
  end;
end;

begin
do_work;
end.
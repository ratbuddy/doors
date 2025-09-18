program tile_maker;
uses dos,crt,graph;
var coords : array [1..16,1..16] of byte;

procedure init_graphics;
var cd, cm : integer;
begin
cd :=CGA;
cm:= CGAC2;
initgraph(cd,cm,'B:\');
end;

procedure draw_letters;
var x,y:byte;
begin
settextstyle(Defaultfont, Horizdir,1);
moveto(1,175);
for x:= 1 to 16 do begin
   setcolor(x);
   outtext(chr(x+40));
   outtext(' ');
end;
moveto(175,10); setcolor(WHITE);
for x:=1 to 17 do begin
  for y:=1 to 16 do
    outtext('.');
    moveto(175,(10*x));
  end;
moveto(175,10); outtext(' '); moveto(175,10); setcolor(1); outtext('X');
end;


procedure inputter;
var ch,hole : char;
begin
read(ch);
if ch='0' then read(ch);

end;

begin
init_graphics;
draw_letters;
inputter;
end.
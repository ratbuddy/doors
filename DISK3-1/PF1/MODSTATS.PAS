function modifier(score: integer) : integer;
var temp:integer;
begin
temp:=0;
if score<7 then temp:=score-7;
if score>20 then temp :=(-1) * (20-score);
modifier:=temp;
end;

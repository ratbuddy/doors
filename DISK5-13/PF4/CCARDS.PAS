program ccards;
CONST MAXCARD=184;
type cards=record
      idnum:byte;
      spec : word;
      end;
var
  card_file : file of cards;
  card      : array [1..MAXCARD] of cards;
  count     : word;

  begin
  for count:=1 to MAXCARD do
   card[count].idnum:=count;
  for count:=1 to 8 do
    card[count].spec:=1; {woods}
  for count:= 9 to 20 do
    card[count].spec:=2; {Brush}
  for count:=21 to 28 do
    card[count].spec:=3; {Hills}
  for count:=29 to 35 do
    card[count].spec:=4; {towers}
  for count:=36 to 40 do
    card[count].spec:=5; {castles}
  for count:=41 to 49 do
    card[count].spec:=6; {swamps}
  for count:=50 to 80 do
    card[count].spec:=1; {movement cards}
  for count:=81 to 85 do
    card[count].spec:=2; {requires 2 fps}
  for count:=86 to 96 do
    card[count].spec:=4; {requires 4 fps}
  for count:=97 to 105 do
    card[count].spec:=6; {reqiures 6 fps}
  for count:=106 to 115 do
    card[count].spec:=8;
  for count:=116 to 121 do
    card[count].spec:=10;
  for count:=122 to 125 do
    card[count].spec:=12;
  for count:=126 to 130 do
    card[count].spec:=14;
  for count:=131 to 134 do
    card[count].spec:=16;
  for count:=135 to 138 do
    card[count].spec:=18;
  for count:=139 to 140 do
    card[count].spec:=20;
  for count:=141 to 150 do   {reinforces Archers}
    card[count].spec:=1;
  for count:=151 to 160 do   {reinforces Footmen}
    card[count].spec:=2;
  for count:=161 to 166 do   {reinforces Wizards}
    card[count].spec:=3;
  for count:=167 to 170 do
    card[count].spec:=4;     {reinforces Knights}
  for count:=171 to 172 do
    card[count].spec:=5;     {reinforces Dragons}
  for count:=173 to 178 do   {smoke clouds}
    card[count].spec:=0;
  for count:=179 to 180 do
    card[count].spec:=1;    {earthquake}
  for count:=181 to 183 do
    card[count].spec:=2;    {tree Burn}
    card[184].spec:=3;      {hero}
assign(card_file,'CARDS.PIT');
rewrite(card_file);
for count:=1 to MAXCARD do
   write(card_file,card[count]);
close(card_file);
end.
program ccards;
CONST MAXCARD = 255;
type cardrec = record
     idnum : byte;
     special_num: byte;
  end;
var count:integer;
    card_ar : array [1.. MAXCARD] of cardrec;
    card_file : file of cardrec;
begin
for count:=1 to MAXCARD do card_ar[count].idnum:=count;

{HEAL CARDS}
for count:=1 to 5 do card_ar[count].special_num:=1;
for count:=6 to 10 do card_ar[count].special_num:=2;
card_ar[count].special_num:=3;

{SMOKE CARDS}
for count:=11 to 20 do
 card_ar[count].special_num:=card_ar[count-10].special_num;

{DISPEL FIRE}
for count:=21 to 25 do
  card_ar[count].special_num:=1;

{ATTACK STM}
{40 total 30 = 1, 10 = 2}
for count:=26 to 55 do card_ar[count].special_num:=1;
for count:=56 to 65 do card_ar[count].special_num:=2;

{ATTACK ACD}
{35 Total, 20 = 1; 10 = 2; 5 =3 }
for count:=66 to 85 do card_ar[count].special_num:=1;
for count:=86 to 95 do card_ar[count].special_num:=2;
for count:=96 to 101 do card_ar[count].special_num:=3;

{ATTACK WIZ}
{30 Total, 10 = 1; 10 = 2; 10 =3 }
for count:=102 to 111 do card_ar[count].special_num:=1;
for count:=112 to 121 do card_ar[count].special_num:=2;
for count:=122 to 131 do card_ar[count].special_num:=3;

{ATTACK ICE}
{27 Total, 6 = 1; 8 = 2; 10 = 3; 3 =4}
for count:=132 to 137 do card_ar[count].special_num:=1;
for count:=138 to 145 do card_ar[count].special_num:=2;
for count:=146 to 155 do card_ar[count].special_num:=3;
for count:=156 to 158 do card_ar[count].special_num:=4;

{ATTACK FIRE}
{23 Total, 6 = 2; 8 = 3; 6 = 4; 3 = 5}
for count:=159 to 164 do card_ar[count].special_num:=2;
for count:=165 to 172 do card_ar[count].special_num:=3;
for count:=173 to 178 do card_ar[count].special_num:=4;
for count:=179 to 181 do card_ar[count].special_num:=5;

{Hero/Archer}
for count:=182 to 187 do card_ar[count].special_num:=1;

{BONUS HPS}
for count:=188 to 191 do card_ar[count].special_num:=1;
card_ar[192].special_num:=2;

{Cards 193 to 219 are reinforcement cards
    193 to 199 Steam
    200 to 206 Acid
    207 to 211 Wiz
    212 to 216 Ice
    217 to 219 Fire}


{damage Cards}
for count:=220 to 229 do card_ar[count].special_num:=1;
for count:=230 to 234 do card_ar[count].special_num:=2;

{GUST OF WIND}
{cards 235 to 244 are GOW}

{WALL OF FIRE}
{245 to 247 are 1 248 = 2;}
for count:=245 to 247 do card_ar[count].special_num:=1;
card_ar[248].special_num:=2;
for count:=249 to 255 do
 card_ar[count].special_num:=1;
assign(card_file,'CARDS.PIT');
rewrite(card_file);
for count:=1 to MAXCARD do write(card_file,card_ar[count]);
close(card_file);
end.

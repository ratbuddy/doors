program magici;

{This program makes wizard's items for use}

type magici = record
        idnum: byte;
        m_names:  string[30];
        damage: integer;{in d8}
        cost:real;
        spcost:integer;
        success_chance: integer;
        end;

var magic: array [0..10] of magici;
    g1: file of magici;
     x,y:integer;
begin
for x:=0 to 10 do
  for y:=1 to 30 do
    magic[x].m_names[y]:=' ';
for x:=0 to 10 do magic[x].idnum:=x;
magic[0].m_names:='No Staff';
magic[1].m_names:='Staff of Tiny Flames';
magic[2].m_names:='Staff of Glowing Missiles';
magic[3].m_names:='Wand of Shooting Sparks';
magic[4].m_names:='Wand of Shocking Streaks';
magic[5].m_names:='Rod of Chill';
magic[6].m_names:='Orb of Crushing';
magic[7].m_names:='Wand of Hellish Flames';
magic[8].m_names:='Wand of Chain Lightning';
magic[9].m_names:='Staff of Black Death';
magic[10].m_names:='Staff of Fire';
magic[0].damage:=0;
magic[1].damage:=1;
magic[2].damage:=2;
magic[3].damage:=4;
magic[4].damage:=5;
magic[5].damage:=6;
magic[6].damage:=9;
magic[7].damage:=12;
magic[8].damage:=20;
magic[9].damage:=25;
magic[10].damage:=32;
magic[0].spcost:=32000;
magic[1].spcost:=5;
magic[2].spcost:=10;
magic[3].spcost:=15;
magic[4].spcost:=20;
magic[5].spcost:=25;
magic[6].spcost:=30;
magic[7].spcost:=35;
magic[8].spcost:=40;
magic[9].spcost:=45;
magic[10].spcost:=50;
magic[0].cost:=0;
magic[1].cost:=100;
magic[2].cost:=500;
magic[3].cost:=1000;
magic[4].cost:=2000;
magic[5].cost:=8000;
magic[6].cost:=11000;
magic[7].cost:=15000;
magic[8].cost:=40000.0;
magic[9].cost:=100000.0;
magic[10].cost:=250000.0;
magic[1].success_chance:=70;
magic[2].success_chance:=65;
magic[3].success_chance:=60;
magic[4].success_chance:=55;
magic[5].success_chance:=50;
magic[6].success_chance:=45;
magic[7].success_chance:=45;
magic[8].success_chance:=40;
magic[9].success_chance:=35;
magic[10].success_chance:=30;
assign(g1,'magic.dat');
rewrite(g1);
for x:=0 to 10 do
    write(g1,magic[x]);
close(G1);
end.
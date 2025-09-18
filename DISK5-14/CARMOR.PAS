program create_armor_rec;


type armortype = record
        number: byte;
        name: string[14];
        protect: integer;
        cost:  integer;
        magical: integer;
        use_class: string[6];
     end;

var
count,X: integer;
g1:file of armortype;
armor:array[0..5] of armortype;

begin
FOR COUNT:=0 TO 5 DO ARMOR[COUNT].NAME:='                    ';
for count:=0 to 5 do armor[count].magical:=0;
for count:=0 to 5 do armor[count].number:=count;
ARMOR[0].name:='CLOTHING';
ARMOR[1].NAME:='LEATHER ARMOR';
ARMOR[2].NAME:='RING MAIL';
ARMOR[3].NAME:='SCALE MAIL';
ARMOR[4].NAME:='CHAIN MAIL';
ARMOR[5].NAME:='PLATE MAIL';
armor[0].protect:=1;
armor[1].protect:=3;
ARMOR[2].PROTECT:=4;
ARMOR[3].PROTECT:=6;
ARMOR[4].PROTECT:=8;
ARMOR[5].PROTECT:=10;
armor[0].cost:=0;
ARMOR[1].COST:=25;
ARMOR[2].COST:=75;
ARMOR[3].COST:=150;
ARMOR[4].COST:=500;
ARMOR[5].COST:=1000;
FOR COUNT:=0 TO 5 DO ARMOR[COUNT].USE_CLASS:='      ';
armor[0].use_class:='123456';
ARMOR[1].USE_CLASS:='123456';
ARMOR[2].USE_CLASS:='13456';
ARMOR[3].USE_CLASS:='13456';
ARMOR[4].USE_CLASS:='1356';
ARMOR[5].USE_CLASS:='135';
ASSIGN(G1,'ARMOR.DAT');
REWRITE(G1);
FOR COUNT:=0 TO 5 DO WRITE(G1,ARMOR[COUNT]);
RESET(G1);
FOR COUNT:=0 TO 5 DO BEGIN READ(G1,ARMOR[COUNT]); WRITE(ARMOR[COUNT].NAME);
END;
end.

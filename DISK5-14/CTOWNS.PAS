program ctowns;
CONST MAX_TOWNS =8;
type town_rec = record
    city_num : byte;
    num_conv : byte;
    City_name: string[20];
    tav_name : string[20];
    gen_name : string[20];
    pot_name : string[20];
    price_mod : byte;
    port     : boolean;
    pot      : boolean;
    gen      : boolean;
    tav      : boolean;
    x : byte;
    y : byte;
  end;

var x,y : integer;
    town : array [1..MAX_TOWNS] of town_rec;
    town_file : file of town_rec;
begin
FOR X:=1 TO MAX_TOWNS DO BEGIN
town[X].city_name:='                               ';
town[X].tav_name:='                                ';
town[X].gen_name:='                                ';
town[X].pot_name:='                                ';
END;
town[1].city_num:=1;
town[1].num_conv:=26;
town[1].city_name:='MALAGO''S COVE';
town[1].tav_name:='THE SWINGING TRESSLE';
town[1].gen_name:='MALAGO''S COVE';
town[1].pot_name:='ALCHEMY MADNESS';
town[1].price_mod:=1;
town[1].port:=true;    town[1].tav :=true; town[1].gen:=true; town[1].pot :=true;
town[1].x:=10;
town[1].y:=5;

town[2].city_num:=2;
town[2].num_conv:=6;
town[2].city_name:='RIVERSIDE';
town[2].tav_name:='THE QUIVERING BOW';
town[2].gen_name:='THE OAKEN STAFF';
town[2].pot_name:='ELVEN WONDERS';
town[2].price_mod:=2;
town[2].port:=false; town[2].tav:=true; town[2].gen:=true; town[2].pot :=true;
town[2].x:=31;
town[2].y:=9;

TOWN[3].CITY_NUM:=3;
TOWN[3].NUM_CONV:=10;
TOWN[3].CITY_NAME:='TORRENTS';
TOWN[3].TAV_NAME:='SEA MAN''S WHARF';
TOWN[3].GEN_NAME:='FISHERMAN''S NET';
TOWN[3].POT_NAME:='NIL';
TOWN[3].PRICE_MOD:=1;
TOWN[3].PORT:=TRUE; TOWN[3].TAV:=TRUE; TOWN[3].GEN:=TRUE; TOWN[3].POT:=FALSE;
TOWN[3].X:=51;
TOWN[3].Y:=11;

TOWN[4].CITY_NUM:=4;
TOWN[4].NUM_CONV:=6;
TOWN[4].CITY_NAME:='CARMEL';
TOWN[4].TAV_NAME:='LITTLE SHIRE BREW';
TOWN[4].GEN_NAME:='NIL';
TOWN[4].POT_NAME:='ERNIE''S HERBERY';
TOWN[4].PRICE_MOD:=2;
TOWN[4].PORT:=FALSE; TOWN[4].TAV:=TRUE; TOWN[4].GEN:=FALSE; TOWN[4].POT:=TRUE;
TOWN[4].X:=31;
TOWN[4].Y:=21;

TOWN[5].CITY_NUM:=5;
TOWN[5].NUM_CONV:=6;
TOWN[5].CITY_NAME:='APPLE VALLEY';
TOWN[5].TAV_NAME:='SPIKED CIDER TAVERN';
TOWN[5].GEN_NAME:='JOHNNY APPLESEED''S';
TOWN[5].POT_NAME:='LADY McINTOSH''S POTIONS';
TOWN[5].PRICE_MOD:=3;
TOWN[5].PORT:=TRUE; TOWN[5].TAV:=TRUE; TOWN[5].GEN:=TRUE; TOWN[5].POT:=TRUE;
TOWN[5].X:=35;
TOWN[5].Y:=14;

TOWN[6].CITY_NUM:=6;
TOWN[6].NUM_CONV:=8;
TOWN[6].CITY_NAME:='PALM SPRINGS';
TOWN[6].TAV_NAME:='HAMBURGER HAMLET';
TOWN[6].GEN_NAME:='DESERT UTILITIES';
TOWN[6].POT_NAME:='DESERT HERBS';
TOWN[6].PRICE_MOD:=4;
TOWN[6].PORT:=TRUE; TOWN[6].TAV:=TRUE; TOWN[6].GEN:=TRUE; TOWN[6].POT:=TRUE;
TOWN[6].X:=57;
TOWN[6].Y:=10;

TOWN[7].CITY_NUM:=7;
TOWN[7].NUM_CONV:=7; {PUT THIS BACK CORRECTLY!}
TOWN[7].CITY_NAME:='SCOTTSVILLE';
TOWN[7].TAV_NAME:='THE TEA ROOM';
TOWN[7].GEN_NAME:='WEAPONS OF WAR';
TOWN[7].POT_NAME:='HEALING MEDICINES';
TOWN[7].PRICE_MOD:=6;
TOWN[7].PORT:=TRUE; TOWN[7].TAV:=TRUE; TOWN[7].GEN:=TRUE; TOWN[7].POT:=TRUE;
TOWN[7].X:=17;
TOWN[7].Y:=12;

TOWN[8].CITY_NUM:=8;
TOWN[8].NUM_CONV:=4;
TOWN[8].CITY_NAME:='LONE PINE';
TOWN[8].TAV_NAME:='SAPPY PINE';
TOWN[8].GEN_NAME:='AXES AND THINGS!';
TOWN[8].POT_NAME:='FORESTAL HERBS';
TOWN[8].PRICE_MOD:=3;
TOWN[8].PORT:=FALSE; TOWN[8].TAV:=TRUE; TOWN[8].GEN:=TRUE; TOWN[8].POT:=FALSE;
TOWN[8].X:=24;
TOWN[8].Y:=12;

assign(town_file,'TOWNDATA.PIT');
rewrite(town_file);
for x:=1 to MAX_TOWNS do
  write(town_file,town[x]);
close(town_file);
end.

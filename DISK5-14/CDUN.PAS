program cdunner;
CONST MAX_DUN = 20;
type
 dun_rec = record
     dwords : array [1..3] of string[3];
     nilword: boolean;
     dnum   : byte;
     dlocx  : byte;
     dlocy  : byte;
     dname  : string[30];
     ttoggle: byte;
     wrong  : array [1..5] of byte;
     xmap   : byte;
     ymap   : byte;
     xactual: byte;
     yactual: byte;
   end;

var dun_array : array [1..MAX_DUN] of dun_rec;
    dun_file  : file of dun_rec;
    x: integer;
begin
for x:=1 to MAX_DUN do dun_array[x].dname:='                                                                  ';
dun_array[1].dwords[1]:='RUY';
dun_array[1].dwords[2]:='RAK';
dun_array[1].dwords[3]:='YAR';
dun_array[1].nilword:=false;
dun_array[1].dnum:=1;
dun_array[1].dlocx:=59;
dun_array[1].dlocy:=16;
dun_array[1].dname:='RUY''S WATCHPOINT ';
dun_array[1].ttoggle:=2;
dun_array[1].wrong[1]:=1;
dun_array[1].wrong[2]:=1;
dun_array[1].wrong[3]:=1;
dun_array[1].wrong[4]:=1;
dun_array[1].wrong[5]:=4;
dun_array[1].xactual:=7;
dun_array[1].yactual:=13;
dun_array[1].xmap:=1;
dun_array[1].ymap:=2;
{**** THIS IS DUNGEON 0! ***********}
dun_array[2].dwords[1]:='DWA';
dun_array[2].dwords[2]:='MIN';
dun_array[2].dwords[3]:='DTH';
dun_array[2].nilword:=false;
dun_array[2].dnum:=0;
dun_array[2].dlocx:=20;
dun_array[2].dlocy:=8;
dun_array[2].dname:='THE LOST MINE';
dun_array[2].ttoggle:=3;
dun_array[2].wrong[1]:=1;
dun_array[2].wrong[2]:=1;
dun_array[2].wrong[3]:=1;
dun_array[2].wrong[4]:=50;
dun_array[2].wrong[5]:=3;
dun_array[2].xactual:=4;
dun_array[2].yactual:=4;
dun_array[2].xmap:=1;
dun_array[2].ymap:=1;
{****** end of dungeon 0 *********}

{****** DRUIDS GROVE *********}
dun_array[3].dwords[1]:='DOM';
dun_array[3].dwords[2]:='EVL';
dun_array[3].dwords[3]:='DTH';
dun_array[3].nilword:=false;
dun_array[3].dnum:=2;
dun_array[3].dlocx:=48;
dun_array[3].dlocy:=19;
dun_array[3].dname:='DRUID''S GROVE';
dun_array[3].ttoggle:=4;
dun_array[3].wrong[1]:=3;
dun_array[3].wrong[2]:=4;
dun_array[3].wrong[3]:=3;
dun_array[3].wrong[4]:=4;
dun_array[3].wrong[5]:=4;
dun_array[3].xactual:=9;
dun_array[3].yactual:=13;
dun_array[3].xmap:=1;
dun_array[3].ymap:=1;

dun_array[4].dwords[1]:='DES';
dun_array[4].dwords[2]:='PAI';
dun_array[4].dwords[3]:='RON';
dun_array[4].nilword:=false;
dun_array[4].dnum:=4;
dun_array[4].dlocx:=22;
dun_array[4].dlocy:=20;
dun_array[4].dname:='LORAN''S TOWER';
dun_array[4].ttoggle:=5;
dun_array[4].wrong[1]:=37;
dun_array[4].wrong[2]:=37;
dun_array[4].wrong[3]:=37;
dun_array[4].wrong[4]:=50;
dun_array[4].wrong[5]:=3;
dun_array[4].xactual:=35;
dun_array[4].yactual:=17;
dun_array[4].xmap:=1;
dun_array[4].ymap:=1;

dun_array[5].dwords[1]:='NIL';
dun_array[5].dwords[2]:='NIL';
dun_array[5].dwords[3]:='NIL';
dun_array[5].nilword:=true;
dun_array[5].dnum:=6;
dun_array[5].dlocx:=18;
dun_array[5].dlocy:=19;
dun_array[5].dname:='NATURAL CAVERN';
dun_array[5].ttoggle:=1;
dun_array[5].wrong[1]:=1;
dun_array[5].wrong[2]:=1; {JUST IN CASE, ALTHOUGH NEVER USED?!?!?}
dun_array[5].wrong[3]:=1;
dun_array[5].wrong[4]:=1;
dun_array[5].wrong[5]:=4;
dun_array[5].xactual:=69;
dun_array[5].yactual:=9;
dun_array[5].xmap:=1;
dun_array[5].ymap:=1;

dun_array[6].dwords[1]:='NIL';
dun_array[6].dwords[2]:='NIL';
dun_array[6].dwords[3]:='NIL';
dun_array[6].nilword:=true;
dun_array[6].dnum:=6;
dun_array[6].dlocx:=52;
dun_array[6].dlocy:=21;
dun_array[6].dname:='THE LOST ABBEY';
dun_array[6].ttoggle:=1;
dun_array[6].wrong[1]:=1;
dun_array[6].wrong[2]:=1; {JUST IN CASE, ALTHOUGH NEVER USED?!?!?}
dun_array[6].wrong[3]:=1;
dun_array[6].wrong[4]:=1;
dun_array[6].wrong[5]:=4;
dun_array[6].xactual:=12;
dun_array[6].yactual:=14;
dun_array[6].xmap:=2;
dun_array[6].ymap:=1;

dun_array[7].dwords[1]:='TRP';
dun_array[7].dwords[2]:='TRK';
dun_array[7].dwords[3]:='DTH';
dun_array[7].nilword:=false;
dun_array[7].dnum:=7;
dun_array[7].dlocx:=48;
dun_array[7].dlocy:=14;
dun_array[7].dname:='MOJAVE''S TOWER';
dun_array[7].ttoggle:=6;
dun_array[7].wrong[1]:=61;
dun_array[7].wrong[2]:=61;
dun_array[7].wrong[3]:=61;
dun_array[7].wrong[4]:=61;
dun_array[7].wrong[5]:=4;
dun_array[7].xactual:=33;
dun_array[7].yactual:=19;
dun_array[7].xmap:=1;
dun_array[7].ymap:=1;

dun_array[8].dwords[1]:='NIL';
dun_array[8].dwords[2]:='NIL';
dun_array[8].dwords[3]:='NIL';
dun_array[8].nilword:=TRUE;
dun_array[8].dnum:=6;
dun_array[8].dlocx:=36;
dun_array[8].dlocy:=18;
dun_array[8].dname:='FORBIDDEN OASIS';
dun_array[8].ttoggle:=1;
dun_array[8].wrong[1]:=1;
dun_array[8].wrong[2]:=1;
dun_array[8].wrong[3]:=1;
dun_array[8].wrong[4]:=1;
dun_array[8].wrong[5]:=4;
dun_array[8].xactual:=9;
dun_array[8].yactual:=12;
dun_array[8].xmap:=5;
dun_array[8].ymap:=1;

dun_array[9].dwords[1]:='NIL';
dun_array[9].dwords[2]:='NIL';
dun_array[9].dwords[3]:='NIL';
dun_array[9].nilword:=TRUE;
dun_array[9].dnum:=6;
dun_array[9].dlocx:=2;
dun_array[9].dlocy:=3;
dun_array[9].dname:='SULTAN''S TOMB';
dun_array[9].ttoggle:=1;
dun_array[9].wrong[1]:=1;
dun_array[9].wrong[2]:=1;
dun_array[9].wrong[3]:=1;
dun_array[9].wrong[4]:=1;
dun_array[9].wrong[5]:=4;
dun_array[9].xactual:=21;
dun_array[9].yactual:=13;
dun_array[9].xmap:=4;
dun_array[9].ymap:=1;

dun_array[10].dwords[1]:='WRI';
dun_array[10].dwords[2]:='TEX';
dun_array[10].dwords[3]:='IT!';
dun_array[10].nilword:=FALSE;
dun_array[10].dnum:=6;
dun_array[10].dlocx:=26;
dun_array[10].dlocy:=11;
dun_array[10].dname:='CONTINENTAL WALK';
dun_array[10].ttoggle:=5;
dun_array[10].wrong[1]:=18;
dun_array[10].wrong[2]:=18;
dun_array[10].wrong[3]:=22;
dun_array[10].wrong[4]:=22;
dun_array[10].wrong[5]:=4;
dun_array[10].xactual:=11;
dun_array[10].yactual:=17;
dun_array[10].xmap:=6;
dun_array[10].ymap:=1;

dun_array[11].dwords[1]:='WRI';
dun_array[11].dwords[2]:='TEX';
dun_array[11].dwords[3]:='IT!';
dun_array[11].nilword:=FALSE;
dun_array[11].dnum:=6;
dun_array[11].dlocx:=61;
dun_array[11].dlocy:=16;
dun_array[11].dname:='CONTINENTAL WALK';
dun_array[11].ttoggle:=5;
dun_array[11].wrong[1]:=18;
dun_array[11].wrong[2]:=18;
dun_array[11].wrong[3]:=22;
dun_array[11].wrong[4]:=22;
dun_array[11].wrong[5]:=4;
dun_array[11].xactual:=41;
dun_array[11].yactual:=17;
dun_array[11].xmap:=6;
dun_array[11].ymap:=1;

dun_array[12].dwords[1]:='NIL';
dun_array[12].dwords[2]:='NIL';
dun_array[12].dwords[3]:='NIL';
dun_array[12].nilword:=TRUE;
dun_array[12].dnum:=8;
dun_array[12].dlocx:=41;
dun_array[12].dlocy:=16;
dun_array[12].dname:='THE STONE CASTLE';
dun_array[12].ttoggle:=1;
dun_array[12].wrong[1]:=1;
dun_array[12].wrong[2]:=1;
dun_array[12].wrong[3]:=1;
dun_array[12].wrong[4]:=1;
dun_array[12].wrong[5]:=4;
dun_array[12].xactual:=38;
dun_array[12].yactual:=18;
dun_array[12].xmap:=1;
dun_array[12].ymap:=1;

dun_array[13].dwords[1]:='NIL';
dun_array[13].dwords[2]:='NIL';
dun_array[13].dwords[3]:='NIL';
dun_array[13].nilword:=TRUE;
dun_array[13].dnum:=8;
dun_array[13].dlocx:=45;
dun_array[13].dlocy:=13;
dun_array[13].dname:='THE HEWN CAVE';
dun_array[13].ttoggle:=1;
dun_array[13].wrong[1]:=1;
dun_array[13].wrong[2]:=1;
dun_array[13].wrong[3]:=1;
dun_array[13].wrong[4]:=1;
dun_array[13].wrong[5]:=4;
dun_array[13].xactual:=32;
dun_array[13].yactual:=4;
dun_array[13].xmap:=1;
dun_array[13].ymap:=4;

dun_array[14].dwords[1]:='NIL';
dun_array[14].dwords[2]:='NIL';
dun_array[14].dwords[3]:='NIL';
dun_array[14].nilword:=TRUE;
dun_array[14].dnum:=8;
dun_array[14].dlocx:=54;
dun_array[14].dlocy:=17;
dun_array[14].dname:='THE RUIN';
dun_array[14].ttoggle:=1;
dun_array[14].wrong[1]:=1;
dun_array[14].wrong[2]:=1;
dun_array[14].wrong[3]:=1;
dun_array[14].wrong[4]:=1;
dun_array[14].wrong[5]:=4;
dun_array[14].xactual:=6;
dun_array[14].yactual:=12;
dun_array[14].xmap:=1;
dun_array[14].ymap:=6;

dun_array[15].dwords[1]:='XEX';
dun_array[15].dwords[2]:='BOW';
dun_array[15].dwords[3]:='NIT';
dun_array[15].nilword:=FALSE;
dun_array[15].dnum:=5;
dun_array[15].dlocx:=35;
dun_array[15].dlocy:=9;
dun_array[15].dname:='ANGEL''S GATE';
dun_array[15].ttoggle:=6;
dun_array[15].wrong[1]:=49;
dun_array[15].wrong[2]:=63;
dun_array[15].wrong[3]:=63;
dun_array[15].wrong[4]:=64;
dun_array[15].wrong[5]:=4;
dun_array[15].xactual:=29;
dun_array[15].yactual:=19;
dun_array[15].xmap:=1;
dun_array[15].ymap:=5;

dun_array[16].dwords[1]:='LET';
dun_array[16].dwords[2]:='MEA';
dun_array[16].dwords[3]:='INA';
dun_array[16].nilword:=FALSE;
dun_array[16].dnum:=9;
dun_array[16].dlocx:=13;
dun_array[16].dlocy:=8;
dun_array[16].dname:='LADERA LINDA';
dun_array[16].ttoggle:=7;
dun_array[16].wrong[1]:=41;
dun_array[16].wrong[2]:=41;
dun_array[16].wrong[3]:=50;
dun_array[16].wrong[4]:=50;
dun_array[16].wrong[5]:=2;
dun_array[16].xactual:=70;  {FIX}
dun_array[16].yactual:=12;  {THIS}
dun_array[16].xmap:=3;  {CORRECTLY!}
dun_array[16].ymap:=3;  {SOOON!}




assign(dun_file,'DUNGEON.INF');
rewrite(dun_file);
for x:=1 to MAX_DUN do write(dun_file,dun_array[x]); close(dun_file);
end.

program cencount1;
const MAXIN = 201;
type monster_table = record
mon1 : byte; mon2 : byte;  mon3 : byte; mon4 : byte; amount:byte; end;
var mt : array [1..MAXIN] of monster_table;
    mt_file : file of monster_table;
    x: byte;
begin
assign(mt_file,'ENCOUNTS.PIT');
rewrite(mt_file);
with mt[1] do begin
  mon1:=1;
  mon2:=1;
  mon3:=1;
  mon4:=50;
  amount:=3;
end;

with mt[2] do begin
  mon1:=1;
  mon2:=1;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[3] do begin
  mon1:=3;
  mon2:=3;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[4] do begin
  mon1:=2;
  mon2:=2;
  mon3:=2;
  mon4:=50;
  amount:=3;
end;

with mt[5] do begin
  mon1:=1;
  mon2:=1;
  mon3:=1;
  mon4:=1;
  amount:=4;
end;

with mt[6] do begin
  mon1:=4;
  mon2:=3;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[7] do begin
  mon1:=5;
  mon2:=5;
  mon3:=5;
  mon4:=50;
  amount:=3;
end;

with mt[8] do begin
  mon1:=6;
  mon2:=5;
  mon3:=1;
  mon4:=50;
  amount:=3;
end;


with mt[9] do begin
  mon1:=10;
  mon2:=1;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;


with mt[10] do begin
  mon1:=1;
  mon2:=1;
  mon3:=1;
  mon4:=1;
  amount:=4;
end;

with mt[11] do begin
  mon1:=8;
  mon2:=8;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[12] do begin
  mon1:=1;
  mon2:=1;
  mon3:=1;
  mon4:=1;
  amount:=4;
end;
with mt[13] do begin
  mon1:=6;
  mon2:=1;
  mon3:=6;
  mon4:=50;
  amount:=3;
end;
with mt[14] do begin
  mon1:=11;
  mon2:=11;
  mon3:=11;
  mon4:=50;
  amount:=3;
end;

with mt[15] do begin
  mon1:=9;
  mon2:=9;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[16] do begin
  mon1:=8;
  mon2:=9;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[17] do begin
  mon1:=28;
  mon2:=28;
  mon3:=28;
  mon4:=50;
  amount:=3;
end;

with mt[18] do begin
  mon1:=28;
  mon2:=28;
  mon3:=28;
  mon4:=28;
  amount:=4;
end;

with mt[19] do begin
  mon1:=43;
  mon2:=43;
  mon3:=43;
  mon4:=50;
  amount:=3;
end;

with mt[20] do begin
  mon1:=36;
  mon2:=1;
  mon3:=1;
  mon4:=50;
  amount:=3;
end;

with mt[21] do begin
  mon1:=36;
  mon2:=1;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[22] do begin
  mon1:=34;
  mon2:=1;
  mon3:=1;
  mon4:=50;
  amount:=3;
end;

with mt[23] do begin
  mon1:=33;
  mon2:=1;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[24] do begin
  mon1:=28;
  mon2:=28;
  mon3:=1;
  mon4:=50;
  amount:=3;
end;

with mt[25] do begin
  mon1:=28;
  mon2:=28;
  mon3:=1;
  mon4:=1;
  amount:=4;
end;

with mt[26] do begin
  mon1:=10;
  mon2:=1;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[27] do begin
  mon1:=3;
  mon2:=3;
  mon3:=3;
  mon4:=50;
  amount:=3;
end;

with mt[28] do begin
  mon1:=3;
  mon2:=3;
  mon3:=3;
  mon4:=3;
  amount:=4;
end;

with mt[29] do begin
  mon1:=3;
  mon2:=4;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[30] do begin
  mon1:=9;
  mon2:=9;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[31] do begin
  mon1:=33;
  mon2:=50;
  mon3:=50;
  mon4:=50;
  amount:=1;
end;

with mt[32] do begin
  mon1:=1;
  mon2:=1;
  mon3:=1;
  mon4:=50;
  amount:=3;
end;

with mt[33] do begin
  mon1:=15;
  mon2:=15;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[34] do begin
  mon1:=4;
  mon2:=4;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[35] do begin
  mon1:=8;
  mon2:=8;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[36] do begin
  mon1:=12;
  mon2:=12;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[37] do begin
  mon1:=5;
  mon2:=5;
  mon3:=5;
  mon4:=50;
  amount:=3;
end;

with mt[38] do begin
  mon1:=6;
  mon2:=6;
  mon3:=6;
  mon4:=50;
  amount:=3;
end;

with mt[39] do begin
  mon1:=7;
  mon2:=7;
  mon3:=7;
  mon4:=50;
  amount:=3;
end;


with mt[40] do begin
  mon1:=7;
  mon2:=7;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[41] do begin
  mon1:=7;
  mon2:=7;
  mon3:=1;
  mon4:=1;
  amount:=4;
end;

with mt[42] do begin
  mon1:=2;
  mon2:=2;
  mon3:=7;
  mon4:=50;
  amount:=3;
end;

with mt[43] do begin
  mon1:=1;
  mon2:=1;
  mon3:=1;
  mon4:=50;
  amount:=3;
end;

with mt[44] do begin
  mon1:=3;
  mon2:=3;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[45] do begin
  mon1:=8;
  mon2:=50;
  mon3:=50;
  mon4:=50;
  amount:=1;
end;

with mt[46] do begin
  mon1:=6;
  mon2:=6;
  mon3:=6;
  mon4:=50;
  amount:=3;
end;

with mt[47] do begin
  mon1:=43;
  mon2:=43;
  mon3:=43;
  mon4:=50;
  amount:=3;
end;

with mt[48] do begin
  mon1:=1;
  mon2:=6;
  mon3:=1;
  mon4:=6;
  amount:=4;
end;

with mt[49] do begin
  mon1:=1;
  mon2:=1;
  mon3:=1;
  mon4:=6;
  amount:=4;
end;

with mt[50] do begin
  mon1:=1;
  mon2:=1;
  mon3:=6;
  mon4:=7;
  amount:=4;
end;
{***********************NEW SECTION FOR LEVELS 3-4 **********************}

with mt[51] do begin
  mon1:=12;
  mon2:=12;
  mon3:=12;
  mon4:=12;
  amount:=4;
end;
with mt[52] do begin
  mon1:=12;
  mon2:=12;
  mon3:=12;
  mon4:=50;
  amount:=3;
end;

with mt[53] do begin
  mon1:=12;
  mon2:=12;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[54] do begin
  mon1:=9;
  mon2:=9;
  mon3:=9;
  mon4:=9;
  amount:=4;
end;

with mt[55] do begin
  mon1:=8;
  mon2:=8;
  mon3:=8;
  mon4:=50;
  amount:=3;
end;

with mt[56] do begin
  mon1:=13;
  mon2:=3;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[57] do begin
  mon1:=6;
  mon2:=10;
  mon3:=1;
  mon4:=1;
  amount:=4;
end;

with mt[58] do begin
  mon1:=6;
  mon2:=6;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[59] do begin
  mon1:=19;
  mon2:=50;
  mon3:=50;
  mon4:=50;
  amount:=1;
end;

with mt[60] do begin
  mon1:=19;
  mon2:=1;
  mon3:=1;
  mon4:=50;
  amount:=3;
end;

with mt[61] do begin
  mon1:=31;
  mon2:=31;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[62] do begin
  mon1:=1;
  mon2:=1;
  mon3:=1;
  mon4:=34;
  amount:=4;
end;

with mt[63] do begin
  mon1:=1;
  mon2:=1;
  mon3:=34;
  mon4:=35;
  amount:=4;
end;

with mt[64] do begin
  mon1:=37;
  mon2:=37;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[65] do begin
  mon1:=1;
  mon2:=1;
  mon3:=1;
  mon4:=36;
  amount:=4;
end;

with mt[66] do begin
  mon1:=15;
  mon2:=15;
  mon3:=15;
  mon4:=50;
  amount:=3;
end;

with mt[67] do begin
  mon1:=5;
  mon2:=5;
  mon3:=5;
  mon4:=5;
  amount:=4;
end;

with mt[68] do begin
  mon1:=3;
  mon2:=4;
  mon3:=3;
  mon4:=4;
  amount:=4;
end;

with mt[69] do begin
  mon1:=4;
  mon2:=4;
  mon3:=3;
  mon4:=4;
  amount:=4;
end;

with mt[70] do begin
  mon1:=10;
  mon2:=1;
  mon3:=1;
  mon4:=1;
  amount:=4;
end;

with mt[71] do begin
  mon1:=11;
  mon2:=11;
  mon3:=11;
  mon4:=11;
  amount:=4;
end;

with mt[72] do begin
  mon1:=6;
  mon2:=6;
  mon3:=9;
  mon4:=50;
  amount:=3;
end;

with mt[73] do begin
  mon1:=28;
  mon2:=28;
  mon3:=28;
  mon4:=28;
  amount:=4;
end;

with mt[74] do begin
  mon1:=8;
  mon2:=8;
  mon3:=8;
  mon4:=50;
  amount:=3;
end;

with mt[75] do begin
  mon1:=12;
  mon2:=12;
  mon3:=12;
  mon4:=50;
  amount:=3;
end;

with mt[76] do begin
  mon1:=12;
  mon2:=12;
  mon3:=12;
  mon4:=50;
  amount:=3;
end;

with mt[77] do begin
  mon1:=33;
  mon2:=33;
  mon3:=33;
  mon4:=50;
  amount:=3;
end;

with mt[78] do begin
  mon1:=33;
  mon2:=33;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[79] do begin
  mon1:=27;
  mon2:=50;
  mon3:=50;
  mon4:=50;
  amount:=1;
end;

with mt[80] do begin
  mon1:=33;
  mon2:=1;
  mon3:=1;
  mon4:=1;
  amount:=4;
end;

with mt[81] do begin
  mon1:=37;
  mon2:=37;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[82] do begin
  mon1:=19;
  mon2:=50;
  mon3:=50;
  mon4:=50;
  amount:=1;
end;

with mt[83] do begin
  mon1:=8;
  mon2:=8;
  mon3:=8;
  mon4:=50;
  amount:=3;
end;

with mt[84] do begin
  mon1:=2;
  mon2:=7;
  mon3:=2;
  mon4:=7;
  amount:=4;
end;

with mt[85] do begin
  mon1:=44;
  mon2:=44;
  mon3:=7;
  mon4:=7;
  amount:=4;
end;

with mt[86] do begin
  mon1:=44;
  mon2:=44;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[87] do begin
  mon1:=45;
  mon2:=45;
  mon3:=45;
  mon4:=45;
  amount:=4;
end;

with mt[88] do begin
  mon1:=45;
  mon2:=45;
  mon3:=45;
  mon4:=45;
  amount:=4;
end;

with mt[89] do begin
  mon1:=45;
  mon2:=45;
  mon3:=14;
  mon4:=50;
  amount:=3;
end;

with mt[90] do begin
  mon1:=36;
  mon2:=36;
  mon3:=1;
  mon4:=50;
  amount:=3;
end;

with mt[91] do begin
  mon1:=45;
  mon2:=45;
  mon3:=45;
  mon4:=1;
  amount:=4;
end;

with mt[92] do begin
  mon1:=8;
  mon2:=10;
  mon3:=8;
  mon4:=50;
  amount:=3;
end;

with mt[93] do begin
  mon1:=1;
  mon2:=45;
  mon3:=45;
  mon4:=50;
  amount:=3;
end;

with mt[94] do begin
  mon1:=1;
  mon2:=45;
  mon3:=45;
  mon4:=44;
  amount:=4;
end;

with mt[95] do begin
  mon1:=45;
  mon2:=45;
  mon3:=45;
  mon4:=45;
  amount:=4;
end;

with mt[96] do begin
  mon1:=6;
  mon2:=45;
  mon3:=45;
  mon4:=6;
  amount:=4;
end;

with mt[97] do begin
  mon1:=14;
  mon2:=45;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[98] do begin
  mon1:=31;
  mon2:=50;
  mon3:=50;
  mon4:=50;
  amount:=1;
end;

with mt[99] do begin
  mon1:=43;
  mon2:=43;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[100] do begin
  mon1:=1;
  mon2:=37;
  mon3:=37;
  mon4:=50;
  amount:=3;
end;

with mt[101] do begin
  mon1:=31;
  mon2:=31;
  mon3:=31;
  mon4:=50;
  amount:=3;
end;
with mt[102] do begin
  mon1:=36;
  mon2:=36;
  mon3:=36;
  mon4:=35;
  amount:=4;
end;

with mt[103] do begin
  mon1:=42;
  mon2:=9;
  mon3:=9;
  mon4:=9;
  amount:=4;
end;

with mt[104] do begin
  mon1:=10;
  mon2:=18;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[105] do begin
  mon1:=10;
  mon2:=10;
  mon3:=18;
  mon4:=50;
  amount:=3;
end;

with mt[106] do begin
  mon1:=13;
  mon2:=13;
  mon3:=13;
  mon4:=13;
  amount:=4;
end;

with mt[107] do begin
  mon1:=48;
  mon2:=48;
  mon3:=44;
  mon4:=44;
  amount:=4;
end;

with mt[108] do begin
  mon1:=26;
  mon2:=26;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[109] do begin
  mon1:=21;
  mon2:=21;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;


with mt[110] do begin
  mon1:=16;
  mon2:=50;
  mon3:=50;
  mon4:=50;
  amount:=1;
end;

with mt[111] do begin
  mon1:=19;
  mon2:=50;
  mon3:=50;
  mon4:=50;
  amount:=1;
end;

with mt[112] do begin
  mon1:=37;
  mon2:=37;
  mon3:=37;
  mon4:=50;
  amount:=3;
end;

with mt[113] do begin
  mon1:=37;
  mon2:=37;
  mon3:=37;
  mon4:=37;
  amount:=4;
end;

with mt[114] do begin
  mon1:=27;
  mon2:=50;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[115] do begin
  mon1:=33;
  mon2:=33;
  mon3:=33;
  mon4:=33;
  amount:=4;
end;

with mt[116] do begin
  mon1:=31;
  mon2:=38;
  mon3:=38;
  mon4:=50;
  amount:=3;
end;


with mt[117] do begin
  mon1:=26;
  mon2:=26;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[118] do begin
  mon1:=37;
  mon2:=38;
  mon3:=38;
  mon4:=50;
  amount:=3;
end;


with mt[119] do begin
  mon1:=38;
  mon2:=38;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[120] do begin
  mon1:=37;
  mon2:=37;
  mon3:=37;
  mon4:=50;
  amount:=3;
end;


with mt[121] do begin
  mon1:=48;
  mon2:=48;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[122] do begin
  mon1:=44;
  mon2:=44;
  mon3:=44;
  mon4:=44;
  amount:=4;
end;

with mt[123] do begin
  mon1:=33;
  mon2:=33;
  mon3:=33;
  mon4:=50;
  amount:=3;
end;

with mt[124] do begin
  mon1:=8;
  mon2:=8;
  mon3:=8;
  mon4:=50;
  amount:=3;
end;

with mt[125] do begin
  mon1:=5;
  mon2:=5;
  mon3:=5;
  mon4:=5;
  amount:=4;
end;

with mt[126] do begin
  mon1:=12;
  mon2:=12;
  mon3:=12;
  mon4:=12;
  amount:=4;
end;

with mt[127] do begin
  mon1:=56;
  mon2:=56;
  mon3:=56;
  mon4:=50;
  amount:=3;
end;

with mt[128] do begin
  mon1:=55;
  mon2:=55;
  mon3:=55;
  mon4:=50;
  amount:=3;
end;

with mt[129] do begin
  mon1:=54;
  mon2:=54;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[130] do begin
  mon1:=53;
  mon2:=53;
  mon3:=53;
  mon4:=50;
  amount:=3;
end;

with mt[131] do begin
  mon1:=56;
  mon2:=55;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[132] do begin
  mon1:=52;
  mon2:=34;
  mon3:=34;
  mon4:=34;
  amount:=4;
end;

with mt[133] do begin
  mon1:=52;
  mon2:=35;
  mon3:=34;
  mon4:=34;
  amount:=4;
end;


with mt[134] do begin
  mon1:=26;
  mon2:=26;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;


with mt[135] do begin
  mon1:=13;
  mon2:=13;
  mon3:=13;
  mon4:=13;
  amount:=4;
end;

with mt[136] do begin
  mon1:=14;
  mon2:=14;
  mon3:=14;
  mon4:=14;
  amount:=4;
end;

with mt[137] do begin
  mon1:=16;
  mon2:=50;
  mon3:=50;
  mon4:=50;
  amount:=1;
end;

with mt[138] do begin
  mon1:=32;
  mon2:=50;
  mon3:=50;
  mon4:=50;
  amount:=1;
end;


with mt[139] do begin
  mon1:=19;
  mon2:=19;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;


with mt[140] do begin
  mon1:=37;
  mon2:=37;
  mon3:=37;
  mon4:=37;
  amount:=4;
end;

with mt[141] do begin
  mon1:=33;
  mon2:=33;
  mon3:=33;
  mon4:=8;
  amount:=4;
end;

with mt[142] do begin
  mon1:=48;
  mon2:=48;
  mon3:=8;
  mon4:=8;
  amount:=4;
end;

with mt[143] do begin
  mon1:=47;
  mon2:=47;
  mon3:=47;
  mon4:=47;
  amount:=4;
end;

with mt[144] do begin
  mon1:=10;
  mon2:=10;
  mon3:=10;
  mon4:=10;
  amount:=4;
end;

with mt[145] do begin
  mon1:=31;
  mon2:=31;
  mon3:=31;
  mon4:=31;
  amount:=4;
end;

with mt[146] do begin
  mon1:=12;
  mon2:=12;
  mon3:=12;
  mon4:=36;
  amount:=4;
end;

with mt[147] do begin
  mon1:=12;
  mon2:=12;
  mon3:=36;
  mon4:=50;
  amount:=3;
end;

with mt[148] do begin
  mon1:=27;
  mon2:=27;
  mon3:=27;
  mon4:=50;
  amount:=3;
end;

with mt[149] do begin
  mon1:=20;
  mon2:=45;
  mon3:=45;
  mon4:=45;
  amount:=4;
end;

with mt[150] do begin
  mon1:=20;
  mon2:=45;
  mon3:=45;
  mon4:=50;
  amount:=4;
end;

with mt[151] do begin
  mon1:=44;
  mon2:=44;
  mon3:=44;
  mon4:=44;
  amount:=4;
end;

{****************** NEW SECTION FOR HIGHER LEVELS  ***********************}

with mt[152] do begin
  mon1:=62;
  mon2:=62;
  mon3:=62;
  mon4:=62;
  amount:=4;
end;

with mt[153] do begin
  mon1:=63;
  mon2:=63;
  mon3:=63;
  mon4:=63;
  amount:=4;
end;

with mt[154] do begin
  mon1:=64;
  mon2:=63;
  mon3:=64;
  mon4:=63;
  amount:=4;
end;

with mt[155] do begin
  mon1:=64;
  mon2:=63;
  mon3:=64;
  mon4:=65;
  amount:=4;
end;

with mt[156] do begin
  mon1:=61;
  mon2:=61;
  mon3:=61;
  mon4:=61;
  amount:=4;
end;

with mt[157] do begin
  mon1:=63;
  mon2:=63;
  mon3:=63;
  mon4:=52;
  amount:=4;
end;

with mt[158] do begin
  mon1:=63;
  mon2:=63;
  mon3:=64;
  mon4:=52;
  amount:=4;
end;

with mt[159] do begin
  mon1:=42;
  mon2:=42;
  mon3:=42;
  mon4:=42;
  amount:=4;
end;

with mt[160] do begin
  mon1:=54;
  mon2:=54;
  mon3:=54;
  mon4:=54;
  amount:=4;
end;

with mt[161] do begin
  mon1:=32;
  mon2:=32;
  mon3:=32;
  mon4:=32;
  amount:=4;
end;

with mt[162] do begin
  mon1:=25;
  mon2:=32;
  mon3:=33;
  mon4:=33;
  amount:=4;
end;

with mt[163] do begin
  mon1:=25;
  mon2:=24;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[164] do begin
  mon1:=25;
  mon2:=25;
  mon3:=50;
  mon4:=50;
  amount:=2;
end;

with mt[165] do begin
  mon1:=30;
  mon2:=50;
  mon3:=50;
  mon4:=50;
  amount:=1;
end;

with mt[166] do begin
  mon1:=21;
  mon2:=21;
  mon3:=21;
  mon4:=21;
  amount:=4;
end;

with mt[167] do begin
  mon1:=61;
  mon2:=62;
  mon3:=61;
  mon4:=62;
  amount:=4;
end;

with mt[168] do begin
  mon1:=63;
  mon2:=63;
  mon3:=63;
  mon4:=63;
  amount:=4;
end;

with mt[169] do begin
  mon1:=64;
  mon2:=64;
  mon3:=64;
  mon4:=64;
  amount:=4;
end;

with mt[170] do begin
  mon1:=52;
  mon2:=52;
  mon3:=62;
  mon4:=62;
  amount:=4;
end;

with mt[171] do begin
  mon1:=16;
  mon2:=16;
  mon3:=16;
  mon4:=16;
  amount:=4;
end;

with mt[172] do begin
  mon1:=19;
  mon2:=62;
  mon3:=64;
  mon4:=52;
  amount:=4;
end;

with mt[173] do begin
  mon1:=26;
  mon2:=26;
  mon3:=26;
  mon4:=26;
  amount:=4;
end;

with mt[174] do begin
  mon1:=32;
  mon2:=37;
  mon3:=38;
  mon4:=63;
  amount:=4;
end;

with mt[175] do begin
  mon1:=42;
  mon2:=42;
  mon3:=42;
  mon4:=42;
  amount:=4;
end;

with mt[176] do begin
  mon1:=62;
  mon2:=63;
  mon3:=63;
  mon4:=62;
  amount:=4;
end;

with mt[177] do begin
  mon1:=57;
  mon2:=57;
  mon3:=54;
  mon4:=57;
  amount:=4;
end;

with mt[178] do begin
  mon1:=40;
  mon2:=50;
  mon3:=50;
  mon4:=50;
  amount:=1;
end;

with mt[179] do begin
  mon1:=63;
  mon2:=64;
  mon3:=65;
  mon4:=63;
  amount:=1;
end;

with mt[180] do begin
  mon1:=59;
  mon2:=59;
  mon3:=63;
  mon4:=63;
  amount:=4;
end;

with mt[181] do begin
  mon1:=59;
  mon2:=63;
  mon3:=63;
  mon4:=63;
  amount:=4;
end;

with mt[182] do begin
  mon1:=59;
  mon2:=63;
  mon3:=63;
  mon4:=52;
  amount:=4;
end;

with mt[183] do begin
  mon1:=59;
  mon2:=61;
  mon3:=61;
  mon4:=51;
  amount:=4;
end;

with mt[184] do begin
  mon1:=18;
  mon2:=18;
  mon3:=63;
  mon4:=63;
  amount:=4;
end;

with mt[185] do begin
  mon1:=63;
  mon2:=63;
  mon3:=63;
  mon4:=63;
  amount:=4;
end;

with mt[186] do begin
  mon1:=63;
  mon2:=63;
  mon3:=63;
  mon4:=63;
  amount:=4;
end;

with mt[187] do begin
  mon1:=63;
  mon2:=63;
  mon3:=63;
  mon4:=63;
  amount:=4;
end;

with mt[188] do begin
  mon1:=63;
  mon2:=63;
  mon3:=64;
  mon4:=63;
  amount:=4;
end;

with mt[189] do begin
  mon1:=63;
  mon2:=52;
  mon3:=64;
  mon4:=63;
  amount:=4;
end;

with mt[190] do begin
  mon1:=63;
  mon2:=52;
  mon3:=65;
  mon4:=63;
  amount:=4;
end;

with mt[191] do begin
  mon1:=62;
  mon2:=62;
  mon3:=62;
  mon4:=50;
  amount:=3;
end;

with mt[192] do begin
  mon1:=17;
  mon2:=17;
  mon3:=63;
  mon4:=63;
  amount:=4;
end;

with mt[193] do begin
  mon1:=17;
  mon2:=17;
  mon3:=17;
  mon4:=50;
  amount:=3;
end;

with mt[194] do begin
  mon1:=16;
  mon2:=16;
  mon3:=16;
  mon4:=16;
  amount:=4;
end;

with mt[195] do begin
  mon1:=53;
  mon2:=53;
  mon3:=53;
  mon4:=53;
  amount:=4;
end;

with mt[196] do begin
  mon1:=52;
  mon2:=52;
  mon3:=52;
  mon4:=63;
  amount:=4;
end;

with mt[197] do begin
  mon1:=57;
  mon2:=57;
  mon3:=57;
  mon4:=57;
  amount:=4;
end;

with mt[198] do begin
  mon1:=30;
  mon2:=50;
  mon3:=50;
  mon4:=50;
  amount:=1;
end;

with mt[199] do begin
  mon1:=63;
  mon2:=64;
  mon3:=65;
  mon4:=52;
  amount:=4;
end;

with mt[200] do begin
  mon1:=62;
  mon2:=62;
  mon3:=62;
  mon4:=62;
  amount:=4;
end;

with mt[201] do begin
  mon1:=63;
  mon2:=63;
  mon3:=63;
  mon4:=64;
  amount:=4;
end;


for x:=1 to MAXIN do
write(mt_file,mt[x]);
close(mt_file);
end.
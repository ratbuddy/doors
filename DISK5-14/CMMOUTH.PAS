program cmmmouth;
type mm = record
       username : string[25];
       saying : string[70];
     end;
var shit : mm;
    shit_file: file of mm;
begin
shit.username:='PIT FIEND                               ';
shit.saying:='WELCOME TO THE PIT FIEND''S ADVENTURE VOLUME 2!';
assign(shit_file,'MMOUTH.DAT');
rewrite(shit_file);
write(shit_file,shit);
close(shit_file);
end.
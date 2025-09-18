program test;
uses common;
{$L testasm}
procedure write_me( temp:string); external;
begin
write_me('Hello');
end.
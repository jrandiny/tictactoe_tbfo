program main;

uses UDFA,UTipe,UData;

{KAMUS}

{ALGORITMA}
begin
  loadDFA('dfa.txt');

  while(true)do
  begin
    inputAlphabet();
    writeln('currState = ',currState);
  end;
end.

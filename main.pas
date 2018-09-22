program main;

uses UDFA,UTipe,UData;

{KAMUS}
var
  userFirst:boolean;
  input:integer;

{ALGORITMA}
begin
  writeln('  TUGAS BESAR IF2220  ');
  writeln('    DFA TIK TAK TU    ');
  writeln('----------------------');

  writeln('Ingin siapa yang mulai dahulu ?');
  writeln('1 untuk komputer (O)');
  writeln('0 untuk kamu (X)');

  repeat
    write('Masukkan pilihan (1/O) = ');
    readln(input);
  until((input=1)or(input=0));

  userFirst := (input = 0);

  writeln('Loading DFA...');

  if(userFirst)then
  begin
    loadDFA('dfa_user.txt');
  end else
  begin
    loadDFA('dfa_computer.txt');
  end;

  writeln();

  if(currState <> VALUNDEF)then
  begin
    while(not(isFinalState(currState)))do
    begin
      output();
      inputAlphabet('Masukkan angka lokasi (1-9) = ');
      writeln('currState = ',currState);
    end;

    writeln('SELESAI, komputer menang');
  end;


end.

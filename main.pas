program tictactoe;

uses UDFA,UTipe,UData;

{KAMUS}
var
  userFirst:boolean;
  input:char;

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
  until((input='1')or(input='0'));

  userFirst := (input = '0');

  writeln('Loading DFA...');

  if(userFirst)then
  begin
    loadDFA('dfa_user.txt');
  end else
  begin
    loadDFA('dfa_computer.txt');
  end;

  writeln();

  {Jika berhasil diload, currState akan diisi sesuai startState}
  if(currState <> VALUNDEF)then
  begin
    outputDesc();
    while(not(isFinalState(currState)))do
    begin
      output();
      inputAlphabet('Masukkan angka lokasi (1-9) = ');
    end;
    {isFinalState(currState)}

    {Cek menang atau seri}
    if(getStateRepresentation(currState)[10]='w')then
    begin
      writeln('SELESAI, komputer menang');
      output();
    end else if(getStateRepresentation(currState)[10]='d')then
    begin
      writeln('SELESAI, seri');
      output();
    end else
    begin
      writeln('ERROR, undefined final state condition');
    end;

    writeln();

    {print langkah}
    outputHistory();
  end;
end.

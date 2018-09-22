unit UDFA;

interface
  uses UTipe,SysUtils,UData;

  {KAMUS}
  var
    currState:integer;

  {*** KELOMPOK LOAD ***}
  procedure loadDFA(namaFile:string);
  {I.S. : DFA belum diload, namaFile terdefinisi (boleh kosong)}
  {F.S. : DFA berhasil diload sesuai namaFile, jika kosong maka diminta ke user}

  {*** KELOMPOK I/O ***}
  procedure inputAlphabet();
  {I.S. : DFA sudah diload, currState terdefinisi}
  {F.S. : Meminta input user lalu mengubah currState sesuai input dan transitionTable}

  {*** KELOMPOK OPERASI ***}
  procedure transition(inputAlphabet:integer);
  {I.S. : DFA sudah diload, currState terdefinisi, inputAlphabet terdefinisi}
  {F.S. : Mengubah currState sesuai inputAlphabet dan ransitionTable}

  function getNextState(inputAlphabet:integer): integer;
  {Menerima inputAlphabet lalu mengeluarkan state yang akan dituju berdasarkan
   transitionTable}


  {*** KELOMPOK TEST ***}
  function isFinalState(state:integer): boolean;
  {Menerima input state sekarang (format sudah integer) dan cek apa final}

  procedure debugPrint();

implementation
  procedure loadDFA(namaFile:string);

  {KAMUS LOKAL}

  {ALGORITMA}
  begin
    {Jika namaFile belum ditentukan}
    if(namaFile='')then
    begin
      write('Masukkan nama file = ');
      readln(namaFile);
    end;

    loadFile(namaFile);

    if(not(loadSukses))then
    begin
      writeln('LOAD GAGAL');
    end else
    begin
      writeln('LOAD BERHASIL');
      currState := startState;
    end;

  end;
  {END of loadDFA}

  {********************************************}
  function isFinalState(state:integer): boolean;

  {KAMUS LOKAL}
  var
    i:integer;
    fin:boolean;

  begin
    i:=1;
    fin:=false;
    while(not(fin)and(i<=finalState.neff))do
    begin
      if(finalState.isi[i]=state)then
      begin
        fin := true;
      end else
      begin
        {finalState.isi[i] =/= state}
        inc(i);
      end;
    end;
    {fin atau i>finalState.neff}

    isFinalState:=fin;
  end;
  {END of isFinalState}

  {********************************************}
  procedure inputAlphabet();

  {KAMUS LOKAL}
  var
    input:string;
    alphabet:integer;

  {ALGORITMA}
  begin
    write('Input = ');
    readln(input);

    alphabet := getAlphabet(input);

    if(alphabet <> VALUNDEF)then
    begin
      transition(alphabet);
    end;

  end;
  {END of inputAlphabet}

  {********************************************}
  procedure transition(inputAlphabet:integer);

  {KAMUS LOKAL}
  var
    nextState :integer;

  {ALGORITMA}
  begin
    nextState := getNextState(inputAlphabet);
    if((nextState <> VALUNDEF) and (nextState<=states.neff))then
    begin
      currState := nextState;
    end else
    begin
      writeln('ERROR, δ(' ,getStateLabel(currState), ',' , getAlphabetLabel(inputAlphabet), ') tidak terdefinisi ')
    end;
  end;
  {END of transition}

  {*******************************************}
  function getNextState(inputAlphabet:integer): integer;
  begin
    getNextState := transitionTable.isi[currState][inputAlphabet];
  end;
  {END of getNextState}

  procedure debugPrint();
  var
    i,j:integer;
  begin
    writeln('STATES');
    for i:=1 to states.neff do
    begin
      writeln(states.isi[i]);
    end;

    writeln('ALPHABET');
    for i:=1 to alphabets.neff do
    begin
      writeln(alphabets.isi[i]);
    end;

    writeln('FINAL');
    for i:=1 to finalState.neff do
    begin
      writeln(finalState.isi[i]);
    end;

    writeln('START');
    writeln(startState);

    writeln('TRANSITION');
    for i:=1 to 10 do
    begin
      for j:=1 to 5 do
      begin
        write(Format('%-3d',[transitionTable.isi[i][j]]),' ');
      end;

      writeln('');
    end;
  end;

initialization
  currState := VALUNDEF;

end.

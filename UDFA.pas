unit UDFA;

interface
  uses UTipe,SysUtils,UData;

  {KAMUS}
  var
    currState : integer;
    history   : ArrHistory;

  {*** KELOMPOK LOAD ***}
  procedure loadDFA(namaFile:string);
  {I.S. : DFA belum diload, namaFile terdefinisi (boleh kosong)}
  {F.S. : DFA berhasil diload sesuai namaFile, jika kosong maka diminta ke user}

  {*** KELOMPOK I/O ***}
  procedure inputAlphabet(prompt:string);
  {I.S. : DFA sudah diload, currState terdefinisi}
  {F.S. : Meminta input user lalu mengubah currState sesuai input dan transitionTable}

  procedure output();
  {I.S. : DFA sudah diload, currState terdefinisi}
  {F.S. : Tercetak kondisi papan sekarang}

  procedure outputHistory();
  {I.S. : currState adalah final state}
  {F.S. : Tercetak semua state yang dilalui}

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
      history.States[1] := getStateLabel(startState);
      history.Neff:=1;
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
  procedure inputAlphabet(prompt:string);

  {KAMUS LOKAL}
  var
    input:string;
    alphabet:integer;

  {ALGORITMA}
  begin
    write(prompt);
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
      history.Input[history.Neff]  := getAlphabetLabel(inputAlphabet);
      inc(history.Neff);
      history.States[history.Neff] := getStateLabel(nextState);
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

  {*******************************************}
  procedure output();

  {KAMUS LOKAL}
  var
    i:integer;
    stringState:string;
    currCode:char;

  {ALGORITMA}
  begin
    stringState := getStateRepresentation(currState);

    for i := 1 to 9 do
    begin
      currCode := stringState[i];
      if(currCode <> '0')then
      begin
        write(currCode);
      end else
      begin
        write(' ');
      end;

      if((i mod 3) = 0)then
      begin
        writeln();
      end else
      begin
        write('|');
      end;

    end;

  end;
  {END of output}
  procedure outputHistory();

  {KAMUS LOKAL}
  var
    i : integer;

  {ALGORITMA}
  begin
    if(isFinalState(currState))then
    begin
      writeln('States yang dilewati');

      {Print semua isi history, dipastikan history.Neff > 2}
      for i := 1 to (history.Neff-1) do
      begin
        writeln(history.States[i]);
        writeln('↓ ',history.Input[i]);
      end;
      writeln(history.States[i+1]);
    end;
  end;
  {END of outputHistory}

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
  history.Neff := 0;

end.

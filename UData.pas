unit UData;

interface
  uses UTipe,SysUtils;

  var
    states: ArrString;
    alphabets: ArrString;
    transitionTable : TabInt;
    finalState : ArrInt;
    startState: integer;

    loadSukses : boolean = false;

  {*** KUMPULAN PROSEDUR FUNGSI I/O FILE ***}
  procedure initTransition();
  {I.S. : Terdapat transitionTable belum diinisialisasi }
  {F.S. : transitionTable diisi dengan -99 (VALUNDEF)}

  procedure loadFile(namaFile : string);
  {I.S. : Terdapat file dengan namaFile yang telah diformat sesuai ketentuan.
          Ketentuan file adalah terdapat states,start state, final state,
          transition, dan alphabet.
          Setiap memulai kategori ditandai dengan tanda kurung siku,
          contoh: [STATES]
          Setelah header, ditulis isinya dengan pemisah berupa enter.
          Saat sudah semua, berikan baris kosong tambahan untuk memisahkan ke
          kategori berikut.
          Khusus untuk transition ditulis dengan format from|input|to,
          contoh: S0|X|S1}
  {F.S. : File sesuai namaFile dibaca dan isinya diisikan ke states, alphabets,
          finalState, startState, dan transitionTable}


  procedure readAlphabets(var fileIn:TextFile);
  {I.S. : Terdapat file text dengan posisi line berada di tulisan [ALPHABET]/[ALPHABETS]}
  {F.S. : Array alphabets diisi dari file, posisi line berada di baris kosong}
  procedure readStates(var fileIn:TextFile);
  {I.S. : Terdapat file text dengan posisi line berada di tulisan [STATE]/[STATES]}
  {F.S. : Array states diisi dari file, posisi line berada di baris kosong}
  procedure readFinal(var fileIn:TextFile);
  {I.S. : Terdapat file text dengan posisi line berada di tulisan [FINAL]/[FINALS]}
  {F.S. : Array finalState diisi dari file, posisi line berada di baris kosong}
  procedure readStart(var fileIn:TextFile);
  {I.S. : Terdapat file text dengan posisi line berada di tulisan [START]}
  {F.S. : startState diisi dari file, posisi line berada di baris kosong}
  procedure readTransitionFunction(var fileIn:TextFile);
  {I.S. : Terdapat file text dengan posisi line berada di tulisan [TRANSITION-F]/[TRANSITIONS-F]}
  {F.S. : Tabel transitionTable diisi dari file, kolom sebagai alphabet,
          baris sebagai from state, dan isi sebagai to state.
          Posisi line berada di baris kosong}
  procedure readTransitionTable(var fileIn:TextFile);
  {I.S. : Terdapat file text dengan posisi line berada di tulisan [TRANSITION-T]/[TRANSITIONS-T]}
  {F.S. : Tabel transitionTable diisi dari file, kolom sebagai alphabet,
          baris sebagai from state, dan isi sebagai to state.
          Posisi line berada di baris kosong}


  {*** KUMPULAN FUNGSI TRANSLATION ***}
  function getAlphabet(alphabet:string):integer;
  {Menerima alphabet berupa tulisan lalu mengoutput versi integernya}
  function getState(state:string):integer;
  {Menerima state berupa tulisan lalu mengoutput versi integernya}
  function getAlphabetLabel(alphabet:integer):string;
  {Menerima alphabet berupa integer lalu mengoutput versi stringnya}
  function getStateLabel(state:integer):string;
  {Menerima state berupa integer lalu mengoutput versi stringnya}

implementation
  procedure loadFile(namaFile : string);

  { KAMUS LOKAL}
  var
    fileIn:TextFile;  {file}
    line:string; {data per baris}


  begin
    if(FileExists(namaFile))then
    begin
      assign(fileIn,namaFile);
      reset(fileIn);

      initTransition();
      loadSukses := true;

      while(not(eof(fileIn)))do
      begin
        readln(fileIn,line);

        case (line) of
          '[STATE]','[STATES]':
          begin
            readStates(fileIn);
          end;
          '[START]':
          begin
            readStart(fileIn);
          end;
          '[FINAL]','[FINALS]':
          begin
            readFinal(fileIn);
          end;
          '[ALPHABET]','[ALPHABETS]':
          begin
            readAlphabets(fileIn);
          end;
          '[TRANSITION-F]','[TRANSITIONS-F]':
          begin
            readTransitionFunction(fileIn);
          end;
          '[TRANSITION-T]','[TRANSITIONS-T]':
          begin
            readTransitionTable(fileIn);
          end;
          else
          begin
            writeln('ERROR, Unknown input type');
            loadSukses:=false;
          end;
        end;
        {End of case of}


      end;
      {eof(fileIn)}

      close(fileIn);

    end else
    begin
      {File not exist}
      writeln('ERROR, File not exist');
    end;
  end;
  {END of loadFile}

  {********************************************}
  procedure readAlphabets(var fileIn:TextFile);

  {KAMUS LOKAL}
  var
    i:integer;
    line:string;

  {ALGORITMA}
  begin
    i := 0;

    repeat
      {Baca baris}
      readln(fileIn,line);

      if(line <> '')then
      begin
        inc(i);
        alphabets.isi[i] := line;
      end;

    until(line = '');
    {line = ''}

    alphabets.neff := i;
  end;
  {END of readAlphabets}

  {*******************************************}
  procedure readStates(var fileIn:TextFile);

  {KAMUS LOKAL}
  var
    i:integer;
    line:string;

  {ALGORITMA}
  begin
    i := 0;

    repeat
      {Baca baris}
      readln(fileIn,line);

      if(line <> '')then
      begin
        inc(i);
        states.isi[i] := line;
      end;

    until(line = '');
    {line = ''}

    states.neff := i;
  end;
  {End of readStates}

  {*******************************************}
  procedure readFinal(var fileIn:TextFile);

  {KAMUS LOKAL}
  var
    i:integer;
    line:string;

  {ALGORITMA}
  begin
    i := 0;

    repeat
      {Baca baris}
      readln(fileIn,line);

      if(line <> '')then
      begin
        inc(i);
        finalState.isi[i] := getState(line);
        if(finalState.isi[i]=VALUNDEF)then
        begin
          loadSukses:=false;
        end;
      end;

    until(line = '');
    {line = ''}

    finalState.neff := i;
  end;
  {END of readFinal}

  {*******************************************}
  procedure readStart(var fileIn:TextFile);

  {KAMUS LOKAL}
  var
    line:string;

  {ALGORITMA}
  begin
    readln(fileIn,line);
    startState := getState(line);
    if(startState=VALUNDEF)then
    begin
      loadSukses:=false;
    end;

    {crunch empty}
    readln(fileIn,line);
  end;
  {END of readStart}

  {*******************************************}
  procedure readTransitionFunction(var fileIn:TextFile);

  {KAMUS LOKAL}
  var
    i,j:integer;
    line:string;
    cc:char;    {Karakter sekarang}
    cc2:char;
    ingested:string; {String yang telah diingest}
    secondIngest:string;
    part:integer;
    inputCount:integer;

    tempFromState:integer;
    tempInput:ArrInt;
    tempToState:integer;

  begin
    {Proses per baris}
    repeat
      readln(fileIn, line);

      if(line <> '')then
      begin
        {Belum habis}
        i:=1; {indeks karakter line}
        part:=1; {part keberapa}
        ingested:='';
        while(i<=length(line))do
        begin
          cc := line[i];

          {Proses karakter}
          if(cc='|')then
          begin
            case (part) of
              1:
              begin
                tempFromState := getState(ingested);
              end;
              2:
              begin
                j:=1; {untuk multi input}
                inputCount:=1;
                secondIngest:='';
                while(j<=length(ingested))do
                begin
                  cc2 := ingested[j];
                  if(cc2 = ',')then
                  begin
                    tempInput.isi[inputCount] := getAlphabet(secondIngest);
                    inc(inputCount);
                    secondIngest := '';
                  end else
                  begin
                    secondIngest := secondIngest + cc2;
                  end;

                  inc(j);
                end;

                tempInput.isi[inputCount] := getAlphabet(secondIngest);

                tempInput.neff := inputCount;
              end;
              else
              begin
                writeln('ERROR, Failed at line "',line,'"');
                loadSukses:=false;
              end;
            end;
            {end of case of}

            inc(part);
            ingested := '';
          end else
          begin
            {cc bukan |}
            ingested := ingested + cc;
          end;

          inc(i);

        end;
        {i>length(line)}

        tempToState := getState(ingested);
        {cek valid}
        if((tempToState=VALUNDEF)or(tempToState=VALUNDEF))then
        begin
          loadSukses := false;
        end else
        begin
          {Insert to table}
          for j:=1 to tempInput.neff do
          begin
            if(tempInput.isi[j] <> VALUNDEF)then
            begin
              transitionTable.isi[tempFromState][tempInput.isi[j]] := tempToState;
            end else
            begin
              loadSukses := false;
            end;
          end;
        end;

      end;
    until(line='');

  end;
  {END of readTransitionFunction}

  {*******************************************}
  procedure readTransitionTable(var fileIn:TextFile);

  {KAMUS LOKAL}
  var
    i:integer;
    line:string;
    baris:integer;
    cc:char;    {Karakter sekarang}
    ingested:string; {String yang telah diingest}
    part:integer;

    tempFromState:integer;
    tempInput:ArrInt;

  begin
    {Proses per baris}
    baris:=0;
    repeat
      readln(fileIn, line);
      inc(baris);

      if(line <> '')then
      begin
        {Belum habis}
        i:=1; {indeks karakter line}
        part:=1; {part keberapa}
        ingested:='';
        while(i<=length(line))do
        begin
          cc := line[i];

          {Proses karakter}
          if(cc='|')then
          begin
            if(baris = 1)then
            begin
              {Proses urutan state}
              tempInput.isi[part] := getAlphabet(ingested);
              if(tempInput.isi[part] = VALUNDEF)then
              begin
                loadSukses := false;
              end;
            end else
            begin
              {Isi}
              if(part = 1)then
              begin
                tempFromState := getState(ingested);
                if(tempFromState = VALUNDEF)then
                begin
                  loadSukses := false;
                end;
              end else
              begin
                transitionTable.isi[tempFromState][tempInput.isi[part-1]] := getState(ingested);
                if(transitionTable.isi[tempFromState][tempInput.isi[part-1]] = VALUNDEF)then
                begin
                  loadSukses := false;
                end;
              end;

            end;


            inc(part);
            ingested := '';
          end else
          begin
            {cc bukan |}
            if(cc <> ' ')then
            begin
              {Hilangkan spasi}
              ingested := ingested + cc;
            end;
          end;

          inc(i);

        end;
        {i>length(line)}



      end;
    until(line='');


  end;
  {END of readTransitionTable}

  {*******************************************}
  procedure initTransition();

  {KAMUS LOKAL}
  var
    i,j:integer;

  {ALGORITMA}
  begin
    for i:=1 to NMAX do
    begin
      for j:=1 to NMAX do
      begin
        transitionTable.isi[i][j] := VALUNDEF;
      end;
    end;
  end;
  {END of initTransition}

  {*******************************************}
  function getAlphabet(alphabet:string):integer;

  {KAMUS LOKAL}
  var
    i:integer;

  begin
    i:=1;
    while((i<=alphabets.neff)and(alphabets.isi[i]<>alphabet))do
    begin
      inc(i)
    end;

    if(i>alphabets.neff)then
    begin
      writeln('ERROR, alphabet not defined (',alphabet,')');
      i:=VALUNDEF;
    end;

    getAlphabet:=i;
  end;
  {END of getAlphabet}

  {*******************************************}
  function getState(state:string):integer;

  {KAMUS LOKAL}
  var
    i:integer;

  begin
    i:=1;
    while((i<=states.neff)and(states.isi[i]<>state))do
    begin
      inc(i)
    end;

    if(i>states.neff)then
    begin
      writeln('ERROR, state not defined (',state,')');
      i := VALUNDEF;
    end;

    getState:=i;
  end;
  {END of getState}

  {*******************************************}
  function getAlphabetLabel(alphabet:integer):string;
  begin
    getAlphabetLabel:=alphabets.isi[alphabet]
  end;
  {END of getAlphabetLabel}

  {*******************************************}
  function getStateLabel(state:integer):string;
  begin
    getStateLabel:=states.isi[state];
  end;
  {END of getStateLabel}

initialization
  loadSukses := false;

end.

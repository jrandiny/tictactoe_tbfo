unit UTipe;

interface
  const
    NMAX = 100;
    VALUNDEF = -99;


  type TabInt = record
    Isi  : array[1..NMAX] of array[1..NMAX] of integer;
    NKol : integer;
    NBar : integer;
  end;

  type ArrString = record
    Isi  : array[1..NMAX] of string;
    Neff : integer;
  end;

  type ArrInt = record
    Isi  : array[1..NMAX] of integer;
    Neff : integer;
  end;

  type ArrHistory = record
    States : array[1..NMAX] of string;
    Input  : array[1..NMAX] of string;
    Neff   : integer;
  end;

implementation

end.

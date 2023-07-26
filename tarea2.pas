function esVocal (c: TLetras): boolean;
begin
  esVocal := (c = 'A') or (c = 'E') or (c = 'I') or (c = 'O') or (c = 'U')
end;

procedure traducir (palabra: TPalabra;  var traducida: TPalabra);
var i:integer;
begin
traducida.tope :=  0;
for i:=1 to palabra.tope do
begin
if esVocal(palabra.palabra[i]) = false then
    begin
        traducida.tope := traducida.tope + 1;
        traducida.palabra[traducida.tope]:=palabra.palabra[i];
    end
  else if (palabra.palabra[i]) <> 'U' then
   begin
      traducida.tope := traducida.tope + 1;
      traducida.palabra[traducida.tope]:=palabra.palabra[i];
      traducida.tope := traducida.tope + 1;
      traducida.palabra[traducida.tope]:='P';
      traducida.tope := traducida.tope + 1;
      traducida.palabra[traducida.tope]:=palabra.palabra[i];
    end
else if (palabra.palabra[i-1]) = 'Q' then
    begin
        traducida.tope := traducida.tope + 1;
        traducida.palabra[traducida.tope]:=palabra.palabra[i];
    end
else
    begin
      traducida.tope := traducida.tope + 1;
      traducida.palabra[traducida.tope]:=palabra.palabra[i];
      traducida.tope := traducida.tope + 1;
      traducida.palabra[traducida.tope]:='P';
      traducida.tope := traducida.tope + 1;
      traducida.palabra[traducida.tope]:=palabra.palabra[i];
     end
end;
end;

function buscarEnPos(sopa: TSopa; pos: TPos; palabra: TPalabra): Orientacion;
var
  i, j, contadorPalabra: integer;
begin
  buscarEnPos := ninguna;
  {primero buscamos de arriba a abajo, recorremos i(filas)}
  i := pos.f;
  contadorPalabra := 1;
  while (i <= Alto) and (contadorPalabra <= palabra.tope) and ( (sopa[i,pos.c]) = (palabra.palabra[contadorPalabra]) ) do
  begin
    i := i + 1;
    contadorPalabra := (contadorPalabra) + 1;
  end;
  if ((contadorPalabra - 1) = palabra.tope) then
  begin
    buscarEnPos := vertical;
  end
  else
    {si no se encontro en vertical, buscamos de izquierda a derecha, recorremos j(columnas)}
  begin
    j := pos.c;
    contadorPalabra := 1;
    while (j <= Ancho) and (contadorPalabra <= palabra.tope) and (sopa[pos.f,j] = palabra.palabra[contadorPalabra]) do
    begin
      j:= j + 1;
      contadorPalabra := contadorPalabra + 1;
    end;
    if ((contadorPalabra - 1) = palabra.tope) then
    begin
      buscarEnPos := horizontal
    end;
  end;
end;

function resolver(sopa: TSopa; palabras: TListaPalabras): TListaSolucion;
var
  aux, sol, ult: TListaSolucion;
  pos: TPos;
  i, j: integer;
  traducida: TPalabra;
  p: TListaPalabras;
  e: boolean;
begin
  sol := nil;
  p := palabras;
  while p <> nil do
  begin
    i := 1;
    j := 1;
    pos.f := i;
    pos.c := j;
    e := false;
    while (i <= Alto) and not (e) do
    begin
      j := 1;
      while (j <= Ancho) and not (e) do
      begin
        pos.f := i;
        pos.c := j;
        if (buscarEnPos(sopa, pos, p^.palabra) <> Orientacion(ninguna)) then
          e := true;
        j := j + 1;
      end;
      i := i + 1;
    end;

    new(aux);
    aux^.palabra := p^.palabra;
    aux^.dir := buscarEnPos(sopa, pos, p^.palabra);
    aux^.inicio := pos;

    if e then
    begin
      aux^.esJeringoso := false;
    end
    else
    begin
      traducir(p^.palabra, traducida);
      i := 1;
      while (i <= Alto) and not (e) do
      begin
        j := 1;
        while (j <= Ancho) and not (e) do
        begin
          pos.f := i;
          pos.c := j;
          if (buscarEnPos(sopa, pos, traducida) <> Orientacion(ninguna)) then
            e := true;
          j := j + 1;
        end;
        i := i + 1;
      end;

      if e then
      begin
        aux^.esJeringoso := true;
        aux^.dir := buscarEnPos(sopa, pos, traducida);
        aux^.inicio := pos;
      end;

    end;

    if sol = nil then
    begin
      sol:=aux;
      ult:=aux;
    end
    else
    begin
      ult^.sig:=aux;
      ult:=aux;
    end;

    p:=p^.sig;
  end;

  resolver:=sol;
end;

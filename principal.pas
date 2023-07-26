program principal;

{ Con esta directiva queda incluido el archivo definiciones.pas }
{$INCLUDE definiciones.pas}

{ Con esta directiva queda incluido el archivo tarea1.pas }
{$INCLUDE tarea2.pas}

procedure leerTSopa (var s: TSopa);
var
  i: 1..Alto;
  j: 1..Ancho;
begin
  for i := 1 to Alto do
  begin
    for j := 1 to Ancho do
      read(s[i,j]);
    readln
  end
end;

procedure mostrarTSopa(s:TSopa);
var
  i: 1..Alto;
  j: 1..Ancho;
begin
  for i := 1 to Alto do
  begin
    for j := 1 to Ancho do
      write(s[i,j],' ');
    writeln
  end
end;

procedure leerTPalabra (var p: TPalabra);
const FinPalabra = '.';
var
  c: char;
begin
  with p do
  begin
    tope := 1;
    read(palabra[tope], c);
    while c <> FinPalabra do
    begin
      tope := tope + 1;
      palabra[tope] := c;
      read(c)
    end;
    readln
  end
end;

procedure mostrarTPalabra (p: TPalabra);
var i: 1..MaxPalabra;
begin
  with p do
    for i := 1 to tope do
      write(palabra[i])
end;

procedure leerTListaPalabras (var l: TListaPalabras);
var
  i, n: integer;
  iter: TListaPalabras;
begin
  readln(n);
  new(l);
  iter := l;
  for i := 2 to n do
  begin
    leerTPalabra(iter^.palabra);
    new(iter^.sig);
    iter := iter^.sig
  end;
  leerTPalabra(iter^.palabra);
  iter := nil
end;


procedure mostrarTListaPalabras (l: TListaPalabras);
begin
  while l<>nil do
  begin
    mostrarTPalabra(l^.palabra);
    write(' ');
    l := l^.sig
  end;
  writeln
end;

procedure liberarTListaPalabras (var l: TListaPalabras);
var aux: TListaPalabras;
begin
  while l <> nil do
  begin
    aux := l^.sig;
    dispose(l);
    l := aux
  end
end;

procedure mostrarTListaSolucion (l: TListaSolucion);
begin
  while l <> nil do
  begin
    mostrarTPalabra(l^.palabra);
    if l^.dir <> ninguna then
    begin
      write(' - Encontrada en: ', l^.inicio.f:0, ', ' , l^.inicio.c:0, ' - ');
      if l^.esJeringoso then
        write('es jeringoso - ')
      else
        write('no es jeringoso - ');
      case l^.dir of
        vertical: writeln('vertical');
        horizontal: writeln('horizontal')
      end
    end
    else
      writeln(' No encontrada');
    l := l^.sig
  end
end;

procedure liberarTListaSolucion (var l: TListaSolucion);
var aux: TListaSolucion;
begin
  while l <> nil do
  begin
    aux := l^.sig;
    dispose(l);
    l := aux
  end
end;

var
  opt: Char;
  c: char;
  p1, p2: TPalabra;
  sopa: TSopa;
  pos: TPos;
  lp: TListaPalabras;
  ls: TListaSolucion;

begin
  readln(opt);
  repeat
    case opt of
      'v': { Prueba del subprograma esVocal }
      begin
        readln(c);
        if esVocal(c) then
          writeln('Si')
        else
          writeln('No')
      end;
      't': { Prueba del subprograma traducir }
      begin
        leerTPalabra(p1);
        traducir(p1, p2);
        mostrarTPalabra(p2);
        writeln;
      end;
      's': { Lectura de TSopa }
      begin
        leerTSopa(sopa);
        mostrarTSopa(sopa);
      end;
      'b': { Prueba del subprograma buscarEnPos }
      begin
        readln(pos.f, pos.c);
        leerTPalabra(p1);
        case buscarEnPos (sopa, pos, p1) of
          vertical: writeln('vertical');
          horizontal: writeln('horizontal');
          ninguna: writeln('ninguna')
        end
      end;
      'r': { Prueba del subprograma resolver }
      begin
        leerTListaPalabras(lp);
        ls := resolver(sopa, lp);
        mostrarTListaSolucion(ls);
        liberarTListaPalabras(lp);
        liberarTListaSolucion(ls)
      end
    end;
    readln(opt)
  until opt = '.'
end.
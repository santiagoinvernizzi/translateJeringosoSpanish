const
  Alto = 11; {Alto de la sopa de letras}
  Ancho = 11; {Ancho de la sopa de letras}
  MaxPalabra = 11; {Tamanio máximo que puede tener una palabra}

type

  {Subrango de caracteres que contiene solo las letras mayúsculas}
  TLetras = 'A'..'Z';

  {Matriz de letras, representando la sopa de letras}
  TSopa = array [1..Alto, 1..Ancho] of TLetras;

  {Arreglo de letras con tope para representar palabras}
  TPalabra = record 
              tope : 0..MaxPalabra;
              palabra : array [1..MaxPalabra] of TLetras
            end;

  {Record con la información de una posición en la matríz}
  TPos = record
          f : 1..Alto;
          c : 1..Ancho
        end;

  {Enumerado para indicar la dirección en la que una palabra fue encontrada. El caso "ninguna" representa que no se encontró}
  Orientacion = (vertical, horizontal, ninguna);


  {Lista de elementos de tipo TPalabra}
  TListaPalabras = ^TCeldaPalabras;

  TCeldaPalabras = record
                      palabra : TPalabra;
                      sig : TListaPalabras;
                  end;

  {Lista de elementos utilizada para representar la solución de la sopa de letras}
  TListaSolucion = ^TCeldaSolucion;

  TCeldaSolucion = record
                      palabra : TPalabra;
                      sig : TListaSolucion;
                      case dir : Orientacion of
                          vertical, horizontal : (inicio : TPos; esJeringoso : boolean);
                          ninguna : ();
                  end;

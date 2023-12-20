Autor: Mateo Amado Ares

Traductor de documentos en formato musicXML a MNX mediante flex y bison 

MusicXML es un formato basado en XML disñado para almacenar notación musical en digital. Cumple una función similar al protocolo MIDI pero es mucho mas legible y sencillo de parsear.
MNX es un sucesor diseñado con el objetivo de mejorar en las partes donde MusicXML es mas deficiente y está basado en Json.

No se reconocerán DTDs ya que quedaron deprecados a partir de la version 4.0 de MusicXML.
Puede ser tipo  <score-partwise> o tipo  <score-timewise>. En principio solo se reconocerá el tipo part-wise ya que el intercambio entre estos dos tipos es trivial (https://www.w3.org/2021/06/musicxml40/listings/timepart.xsl/).

Structura MusicXML:
    header
        metadata: <work>, contiene <work-number>, <work-title> y <opus> (referencia sobre una obra mayor), <movement-number>, <movement-title>, <identification>, contiene <creator type="composer">, <rights>, <encoding> (+info dentro de este) y <source>
        La mayoría de estos elementos no tiene un equivalente en MNX por lo que los ignoraré.
        <part-list> (unico obligatorio del header), contiene los <score-parts>
        Cada score-part tiene como único elemento obligatorio <part-name>, el resto son opcionales y no se suelen utilizar por lo que tampoco los reconoceré.
        La mayoría de ejemplos contienen 1 solo score-part ya que es el caso mas común.

<part> debe tener un atributo con su id, contiene una secuencia de <measures>.
cada <measure> puede contener un elemento <atributes>, que puede contener:
<divisions>, <key> (que contiene <fifths>), <time> (debe contener <beats> y <beat-type), <clef> (<sign> y <line>)...
hay muchos otros elementos que puede haber dentro de un measure pero el mas importante es <note>
<note> debe tener como mínimo <pitch>, <duration> y <type>
tambien puede contener el elmento <chord>, que añade mucha complejidad.
    
Structura MNX: (json), 3 objetos principales:
    "MNX", contiene "version"
    "global", contiene:
        "measures", que puede contener entre otros: "barline"(contiene "type"), "key" (contiene "fifths") y "time" (contiene "count" y "unit").
    "parts" contiene "measures" (diferentes del measures-global, este se denomina measures-part), los cuales decben contener "sequences"
        "sequences" que contiene "content", el cual contiene los objetos finales, casi siempre de tipo "event"
            estos objetos contienen "type" (="event" casi siempre), "duration" (que contiene "base"), "notes" (que contiene "pitch" [que contiene "octave", "step" y "alter"])

El lenguaje común ambos sería la notación muscial tradicional, la cúal contiene muchos elementos redundantes pero que deben poder reflejarse en estos formatos por lo que se tienen muchas opcionalidades que no influyen al resultado final de la partitura.

Puede provocar confusión que lo que se denomina measures en MusicXML no corresponde con los measures de MNX sino con los sequences.
Otro caso curioso es que la posición de la clave (clef) se codifica al revés, correspondiendo G2 (clave de sol común) en MusicXML con G(-2) en MNX.
Se implementaron los acordes (varias notas en un mismo instante de timepo), silencios, alteraciones accidentales (alteraciones no indicadas en la armadura),puntillos.
Faltan bastantes otros objetos pero para partituras sencillas es suficiente.

ejemplos:
    - PRUEBA1 : una nota larga
    - PRUEBA2 : escala do mayor en dos medidas
    - PRUEBA3 : acorde y silencio
    - PRUEBA4 : accidentales
    - PRUEBA5 : puntillos
    - PRUEBA6 : error timeswise
    - PRUEBA7 : error nota incorrecta
    - PRUEBA8 : error measure sin contenido
    - PRUEBA9 : error accidental no reconocido
    - PRUEBA10 : error faltan atributos
    ...


Para probar ejecutar comando make, que coge xml de la carpeta ejemplos.
En la carpeta ejemplos tambien están los resultados correctos de esta traducción, en su mayoría extraídos de https://w3c.github.io/mnx/docs/comparisons/musicxml/

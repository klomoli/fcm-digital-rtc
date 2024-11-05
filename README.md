#README

Tres son los servicios que se han creado para la resolución de este problema.

--> [FileReaderReservationsService]

  |--> Leemos el archivo de texto y lo separamos por lineas
  |--> Separamos el contenido en RESERVATION

--> [SegmentParserService]

  |--> Para cada RESERVATION:
    |--> Extraemos para cada linea aquellas que comienzan por SEGMENT
    |--> Para cada SEGMENT:
      |--> Llamamos al método parse_segment que se encarga de extraer la información necesaria (line) usando expresiones regulares para obtener los valores de cada campo y así poder crear una instancia de Segment que sea facil de extender en un futuro.
        |--> Para el line extraido lo que hacemos es crear una instancia de Segment
        |--> Creamos una instancia de Segment y la retornamos
    
--> [ItineraryOrganicerService]


  
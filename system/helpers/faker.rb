module Admin
    def store_museum
      museum_data = {
        'creation_date' => '16-10-2017',
        'info' => {
          'name' => 'Museo de geología',
          'description' => '
El Museo de Geología del Departamento de Geología de la Universitat de Valencia (MGUV), es el custodio de varias colecciones de materiales geológicos y paleontológicos (rocas ornamentales, estructuras sedimentarias, minerales, meteoritos, fósiles) además de otros objetos de carácter histórico -científico relacionado de manera directa o indirecta con la Geología (instrumental científico, bibliografía). Desde 1996, año en que fue reconocido como Museo por la Conselleria de Cultura de la Generalitat Valenciana el MGUV está desarrollando una importante labor de conservación, mantenimiento, investigación e inventario de los ejemplares que componen sus colecciones, poniendolas a disposición de los investigadores interesados y también organizará su exhibición pública, confiriéndole el carácter abierto de un centro de divulgación científica.'
        },
        'location' => {
          'street' => 'Carrer Dr. Moliner, 50',
          'postal' => '46.100',
          'city' => 'Valencia',
          'region' => 'Burjasot',
          'link' => 'https://www.google.es/maps/place/Carrer+del+Dr.+Moliner,+50,+46100+Burjassot,+Valencia/@39.507831,-0.4214757,17z/data=!3m1!4b1!4m5!3m4!1s0xd60450d182e2083:0x4286f51f529bb0d!8m2!3d39.5078269!4d-0.419287'
        },
        'contact' => {
          'phone' => ['963 544 605'],
          'email' => [],
          'web' => ['http://www.uv.es/mguv']
        },
        'price' => {
          'freeEntrance' => ['?'],
          'general' => ['?'],
          'reduced' => ['?']
        },
        'schedule' => {
          'MON' => [],
          'TUE' => ['09:00-13:30'],
          'WED' => ['09:00-13:30'],
          'THU' => ['09:00-13:30'],
          'FRI' => ['09:00-13:30'],
          'SAT' => [],
          'SUN' => [],
        }
      }
      Museums::Service.store(museum_data)
    end

    def store_exhibition(museum_id)
      exhibition_data = {
        "show" => true,
        "name" => "Cultura Accesible Geología",
        "museum_id" => museum_id,
        "general_description" => "Esta aplicación está creada y pensada para todos.",
        "date_start" => "23/10/17",
        "date_finish" => "30/12/17",
        "type" => "mixed-art",
        "beacon" => 0,
        "description" => "",
        "image" => "https://s3.amazonaws.com/pruebas-cova/Demo+Feedback/Feedback+Cultural+sala+grande+1.jpg",
        'deleted' => false,
        'iso_codes' => ['es','cat'],
      }
      exhibition = Exhibitions::Service.store(exhibition_data)
      exhibition_id = exhibition[:id]
      translations = [
          {
            'name' => "Cultura Accesible Geología",
            'general_description' =>'Esta aplicación está creada y pensada para todos.',
            'extended_description' => 'Una manera de tener todas las audio-guías de los museos participantes en tu mano. Especialmente diseñada para su fácil utilización por las personas con discapacidad visual.',
            'iso_code' => 'es',
            'exhibition_id' => exhibition_id
          },
          {
            'name' => 'Cultura Accesible Geología',
            'general_description' =>'Aquesta aplicació està creada i pensada per a tots.',
            'extended_description' => 'Una manera de tenir totes les audioguies dels museus participants a la teva mà. Especialment dissenyada per a la seva fàcil utilització per les persones amb discapacitat visual.',
            'iso_code' => 'cat',
            'exhibition_id' => exhibition_id
          },
      ]
      Exhibitions::Service.store_translations(translations, exhibition_id)
      Actions::Exhibition.add_museum_info(exhibition)
    end

    def store_sculpture_room(exhibition_id)
      room = {
        'id' => '',
        'name' => 'Escultura',
        'beacon' => 1,
        'image' => 'https://s3.amazonaws.com/pruebas-cova/Demo+Feedback/Giacometti+-+Hombrequecamina+mosaico+512x504.jpg',
        'parent_id' => exhibition_id,
        'exhibition_id' => exhibition_id,
        'parent_class' => 'exhibition',
        'type' => 'room',
        'number' => '1-0-0',
        'room' => true
      }
      room_id = add_item(room, exhibition_id)
      translations = [
        {
          'name' => 'Escultura',
          'description' => 'Bienvenido a la sala de esculturas',
          'video' => 'https://s3.amazonaws.com/pruebas-cova/Demo+Feedback/La+escultura+griega.mp4',
          'iso_code' => 'es',
          'item_id' => room_id
        },
        {
          'name' => 'Escultura',
          'description' => "Benvingut a la sala d'esculturas",
          'video' => 'https://s3.amazonaws.com/pruebas-cova/Demo+Feedback/La+escultura+griega.mp4',
          'iso_code' => 'cat',
          'item_id' => room_id
        },
      ]
      add_translations( translations, room_id )
      parent_id = room_id

      scene = {
        'id' => '',
        'name' => 'Hombre que camina',
        'author' => 'Alberto Giacometti',
        'date' => '1939',
        'beacon' => 2,
        'image' => 'https://s3.amazonaws.com/pruebas-cova/Demo+Feedback/Giacometti+-+Hombrequecamina+mosaico+512x504.jpg',
        'parent_id' => parent_id,
        'exhibition_id' => exhibition_id,
        'parent_class' => 'room',
        'type' => 'scene',
        'number' => '1-1-0'
        }
      scene_id = add_item(scene, exhibition_id)
        translations = [
          {
            'name' => 'El hombre que camina',
            'description' => 'Tras su interés inicial por el cubismo, Giacometti (Yacometi) pasa a relacionarse con la vanguardia surrealista produciendo obras de notable factura. Pero no es hasta después de la II Guerra Mundial, y su retorno a la figuración, cuando el artista alcanza su madurez artística. A lo largo de su trayectoria, sus esculturas se van reduciendo a la mínima expresión, alargando sus extremidades hasta llegar a las formas por las cuales es mundialmente reconocido hoy en día. Estas figuras largas y delgadas, de una rigidez casi sagrada, fueron interpretadas por el mismísimo Jean-Paul Sartre (Yan Pol Sartre’), gran amigo de Giacometti (Yacometi), como una metáfora del "hombre que emergía de las secuelas de la guerra". La expresión moderna de un absoluto existencial. Su hombre que camina es la segunda escultura en una serie de 6. Es una figura casi a tamaño natural, esquelética y desgarbada, hecha en bronce, oscuro y sin pulir, y con una superficie rugosa que le da un mayor aspecto retorcido y agónico. Una figura en movimiento en el mismo momento que da un paso, inestable, como el hombre ante el devenir del destino.',
            'video' => 'https://s3.amazonaws.com/pruebas-cova/Demo+Feedback/Alberto+Giacometti++TateShots.mp4',
            'iso_code' => 'es',
            'item_id' => scene_id
          },
          {
            'name' => "L'home que camina",
            'description' => "Després del seu interés inicial pel cubisme, Giacometti (Yacometi) passa a relacionar-se amb l'avantguarda surrealista produint obres de notable factura. Però no és fins després de la II Guerra Mundial, i el seu retorn a la figuració, quan l'artista aconsegueix la seua maduresa artística. Al llarg de la seua trajectòria, les seues escultures es van reduint a la mínima expressió, allargant les seues extremitats fins a arribar a les formes per les quals és mundialment reconegut hui en dia. Aquestes figures llargues i primes, d'una rigidesa quasi sagrada, van ser interpretades pel mateix Jean-Paul Sartre (Yan Pol Sartre'), gran amic de Giacometti (Yacometi) , com una metàfora de l’home que emergia de les seqüeles de la guerra. L'expressió moderna d'un absolut existencialisme. El seu home que camina és la segona escultura en una sèrie de sis. És una figura quasi a grandària natural, esquelètica i desmanegada, realitzada en bronze, fosc i sense polir, i amb una superfície rugosa que li atorga un major aspecte retorçut i agònic. Una figura en moviment en el mateix moment que fa un pas, inestable, com l'home davant del pas del destí.",
            'video' => 'https://s3.amazonaws.com/pruebas-cova/Demo+Feedback/Alberto+Giacometti++TateShots.mp4',
            'iso_code' => 'cat',
            'item_id' => scene_id
          }
        ]
        add_translations( translations, scene_id )
    end

    def store_painting_room(exhibition_id)
      room = {
        'id' => '',
        'name' => 'Pintura y fotografía',
        'beacon' => 3,
        'image' => 'https://s3.amazonaws.com/pruebas-cova/Demo+Feedback/pintura-e-foto-23.jpg',
        'parent_id' => exhibition_id,
        'exhibition_id' => exhibition_id,
        'parent_class' => 'exhibition',
        'type' => 'room',
        'number' => '2-0-0',
        'room' => true
      }
      room_id = add_item(room, exhibition_id)
      translations = [
        {
          'name' => 'Escultura',
          'description' => 'Bienvenido a la sala de pintura y fotografía',
          'video' => 'https://s3.amazonaws.com/pruebas-cova/Demo+Feedback/Impresionistas+y+postimpresionistas.+El+nacimiento+del+arte+moderno.mp4',
          'iso_code' => 'es',
          'item_id' => room_id
        },
        {
          'name' => 'Room sensera',
          'description' => "Benvingut a la sala de pintura i fotografia",
          'video' => 'https://s3.amazonaws.com/pruebas-cova/Demo+Feedback/Impresionistas+y+postimpresionistas.+El+nacimiento+del+arte+moderno.mp4',
          'iso_code' => 'cat',
          'item_id' => room_id
        },
      ]
      add_translations(translations, room_id)
      parent_id = room_id
      scene = {
        'id' => '',
        'name' => 'El Balandrito',
        'author' => 'Joaquín Sorolla',
        'date' => '1909',
        'beacon' => 4,
        'image' => 'https://s3.amazonaws.com/pruebas-cova/Demo+Feedback/Sorolla+-+Balandrito+mosaico+512x504.jpg',
        'parent_id' => parent_id,
        'exhibition_id' => exhibition_id,
        'parent_class' => 'room',
        'type' => 'scene',
        'number' => '2-1-0'
      }
      scene_id = add_item(scene, exhibition_id)
      translations = [
        {
          'name' => 'El Balandrito',
          'description' => 'Un niño desnudo juega con un barco de juguete, en torno suyo el mar, uno de los temas más recurrentes e identificables de Joaquín Sorolla. El agua y la playa permiten observar en el lienzo los dos aspectos más destacables del pintor: la luz y la pincelada. En El Balandrito, como en otras obras de la misma época, el punto de vista se eleva hasta hacer desaparecer el horizonte. Aunque el niño y su juguete son los elementos que más captan la atención, la peculiar colocación de ambos en la esquina superior izquierda del lienzo permite que el agua sea la que llene casi toda la composición. Destaca, como es habitual en el pintor valenciano, el excepcional cromatismo empleado para capturar todos y cada uno de los efectos del sol sobre los distintos elementos que forman el cuadro. La imagen del niño, entretenido en su juego, se traduce en un despliegue de tonos rojizos que recrean vivamente su piel desnuda y su consecuente reflejo sobre la superficie del mar. Los característicos blancos de Sorolla están presentes en las velas del barquito y en la espuma de las olas. El festival de azules que reflejan el agua unido a la pincelada ágil fuerte y gruesa dejan ver claramente el talento del pintor para representar el movimiento de las olas y el juego de luces y efectos que éstas despliegan en cada ir y venir. Son los colores del mar en puro movimiento. Sorolla pintaba instantáneas de escenas cotidianas plantando su caballete durante varias horas en la playa de el Cabañal, captando como nadie la luz característica del Mediterráneo.',
          'video' => 'https://s3.amazonaws.com/pruebas-cova/videos/castellano_el_balandrito_q30.mp4',
          'iso_code' => 'es',
          'item_id' => scene_id
        },
        {
          'name' => "El Balandrito",
          'description' => "Un xiquet despullat juga amb un vaixell de joguet, al seu voltant el mar, un dels temes més recurrents i identificables de Joaquín Sorolla. L'aigua i la platja permeten observar en el llenç els dos aspectes més destacables del pintor: la llum i la pinzellada. En El Balandret, com en altres obres de la mateixa època, el punt de vista s'eleva fins a fer desaparèixer l'horitzó. Encara que el xiquet i el seu joguet són els elements que més capten l'atenció, la peculiar col·locació d'ambdós al cantó superior esquerre del llenç permet que l'aigua siga la que òmpliga quasi tota la composició. Destaca, com és habitual en el pintor valencià, l'excepcional cromatisme emprat per a capturar tots i cada un dels efectes del sol sobre els distints elements que formen el quadro. La imatge del xiquet, entretingut en el seu joc, es tradueix en un desplegament de tons rogencs que recreen vivament la seua pell nua i el seu conseqüent reflex sobre la superfície del mar. Els característics blancs de Sorolla estan presents a les veles del xicotet vaixell i a la bromera de les ones. El festival de blaus que reflecteixen l'aigua unit a la pinzellada àgil, forta i grossa deixen veure clarament el talent del pintor per a representar el moviment de les ones i el joc de llums i efectes que aquestes despleguen en cada anada i tornada. Són els colors del mar en pur moviment. Sorolla pintava instantànies d'escenes quotidianes plantant el seu cavallet durant diverses hores a la platja del Cabanyal, captant com ningú la llum característica de la Mediterrània.",
          'video' => 'https://s3.amazonaws.com/pruebas-cova/videos/castellano_el_balandrito_q30.mp4',
          'iso_code' => 'cat',
          'item_id' => scene_id
        }
      ]
      add_translations( translations, scene_id )
      scene = {
        'id' => '',
        'name' => 'El corsé Mainbocher',
        'author' => 'Horst P. Horst',
        'date' => '1939',
        'beacon' => 5,
        'image' => 'https://s3.amazonaws.com/pruebas-cova/Demo+Feedback/Horst+-+Mainbocher+Corset+gde+1500x1102.jpg',
        'parent_id' => parent_id,
        'exhibition_id' => exhibition_id,
        'parent_class' => 'room',
        'type' => 'scene',
        'number' => '2-2-0'
      }
      scene_id = add_item(scene, exhibition_id)
      translations = [
        {
          'name' => 'El corset Mainbocher',
          'description' => 'Desde su Alemania natal, Horst (Jors) se trasladó a París para ser aprendiz de Le Corbusier (Le Corbusié). En 1931 y de la mano de los fotógrafos Hoyningen-Huene (juiningen june) y Cecil Beaton (sesil biton) entró en la revista Vogue, publicación para la que trabajaría durante el resto de su vida. Sus fotografías se caracterizaban por su dramática iluminación y la imaginación de sus decorados, claramente influenciados por el Surrealismo. Sus estudios de pintura clásica y de escultura griega, quedaban a menudo reflejados en el tratamiento que la figura humana tenía en sus obras. En "El corsé Mainbocher" (Meinbojar), la fotografía en blanco y negro muestra una figura femenina sentada de espaldas, con los brazos plegados sobre los codos a punto de desperezarse. La cabeza con el pelo recogido y en reposo inclinada en escorzo a su derecha. Es una modelo agotada tras una larga sesión fotográfica, que ya se ha despojado de la ropa y se ha desatado el corsé. Su cuerpo descansa en una superficie de mármol sobre la que se extienden sus cintas. La iluminación que entra lateralmente por la parte derecha crea un juego de luces que centra la atención sobre el corsé y la espalda del cuerpo al que envuelve. La imagen en todo su clasicismo formal recuerda a la de un gladiador de la antigua Roma, quien tras el combate, se deshace cansado de sus sandalias. Como una escultura viva, la imagen resultante es casi un estudio académico de la figura humana. Esta fotografía, sin duda la más famosa de su autor, y una de las más icónicas del siglo XX, fue tomada en los estudios de Vogue en París en las vísperas de la II Guerra Mundial. El propio Horst (Jors) abandonó la ciudad al día siguiente huyendo del conflicto que se avecinaba, y acabó siendo fotógrafo oficial del ejército norteamericano.',
          'video' => 'https://s3.amazonaws.com/pruebas-cova/Demo+Feedback/Horst+Photographer+of+Style.mp4',
          'iso_code' => 'es',
          'item_id' => scene_id
        },
        {
          'name' => "L'home que camina",
          'description' => "Des de la seua Alemanya natal, Horst (Jors) es va traslladar a París per a ser aprenent de Le Corbusier (Li Corbusié). En 1931 i de la mà dels fotògrafs Hoyningen-Huene (juiningen june) i Cecil Beató (sèssil biton) va entrar a la revista Vogue, publicació per a la qual treballaria durant la resta de la seua vida. Les seues fotografies es caracteritzaven per la seua dramàtica il·luminació i la imaginació dels seus decorats, clarament influenciats pel Surrealisme. Els seus estudis de pintura clàssica i d'escultura grega, quedaven sovint reflectits en el tractament que la figura humana tenia a les seues obres. A 'El Corset Mainbocher' (Meinbojar), la fotografia en blanc i negre mostra una figura femenina aseguda d'esquena, amb els braços plegats sobre els colzes a punt de desemperesir-se. El cap amb els cabells recollits i en repòs inclinat en escorç cap a la seua dreta. És una model esgotada després d'una llarga sessió fotogràfica, que ja s'ha desposseït de la roba i s'ha deslligat el corset. El seu cos descansa sobre una superfície de marbre en la qual s'estenen les seues cintes. La il·luminació que entra lateralment per la part dreta crea un joc de llums que centra l'atenció sobre el corset i l'esquena del cos a qui envolta. La imatge en tot el seu classicisme formal recorda a la d'un gladiador de l'antiga Roma, qui, després del combat, es desfà cansat de les seues sandàlies. Com una escultura viva, la imatge resultant és quasi un estudi acadèmic de la figura humana. Aquesta fotografia, sens dubte la més famosa del seu autor, i una de les més icòniques del segle XX, va ser presa als estudis de Vogue a París en les vespres de la II Guerra Mundial. El propi Horst (Jors) va abandonar la ciutat l'endemà fugint del conflicte que s'acostava, i va acabar sent fotògraf oficial de l'exèrcit nord-americà.",
          'video' => 'https://s3.amazonaws.com/pruebas-cova/Demo+Feedback/Horst+Photographer+of+Style.mp4',
          'iso_code' => 'cat',
          'item_id' => scene_id
        }
      ]
      add_translations( translations, scene_id )
    end

    def add_item(item_data, exhibition_id)
      if item_data['type'] == 'room'
        item = Items::Service.store_room(item_data)
      else
        item = Items::Service.store_scene(item_data)
      end
      item_id = item[:id]
      Exhibitions::Service.register_order(exhibition_id, item_id, item_data['number'])
      item_id
    end

    def add_translations(translations, item_id)
      Items::Service.store_translations(translations, item_id)
    end
end

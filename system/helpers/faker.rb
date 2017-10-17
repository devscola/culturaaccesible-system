module Admin
    def store_museum
      museum_data = {
        'creation_date' => '16-10-2017',
        'info' => {
          'name' => 'The museum',
          'description' => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
        },
        'location' => {
          'street' => 'Las 13 rosas',
          'postal' => '36.000',
          'city' => 'Madrid',
          'region' => 'Madrid',
          'link' => 'https://www.google.es/maps/place/MuVIM,+Museu+Valenci%C3%A0+de+la+Il%C2%B7lustraci%C3%B3+i+la+Modernitat/@39.4698131,-0.383297,17z/data=!3m1!4b1!4m5!3m4!1s0xd604f4f615718bb:0xccd4cfd7781d3a4f!8m2!3d39.4698131!4d-0.3811083'
        },
        'contact' => {
          'phone' => ['11111111'],
          'email' => ['nnnnnnnlorem@gmail.com'],
          'web' => ['https://www.google.es']
        },
        'price' => {
          'freeEntrance' => ['0'],
          'general' => ['5'],
          'reduced' => ['10']
        },
        'schedule' => {
          'MON' => ['16:00-20:00'],
          'TUE' => ['10:00-14:00', '16:00-20:00'],
          'WED' => ['10:00-14:00', '16:00-20:00'],
          'THU' => ['10:00-14:00', '16:00-20:00'],
          'FRI' => ['10:00-14:00', '16:00-20:00'],
          'SAT' => ['10:00-14:00', '16:00-20:00'],
          'SUN' => ['10:00-14:00'],
        }
      }
      Museums::Service.store(museum_data)
    end

    def store_exhibition( museum_id )
      exhibition_data = {
        'show' => true,
        'name' => 'Homenaje 13 Rosas',
        'museum_id' => museum_id,
        'general_description' => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor.',
        'date_start' => '20-10-2017',
        'date_finish' => '20-10-2018',
        'type' => 'sculpture',
        'beacon' => '0',
        'description' => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
        'image' => 'http://mujeresmasonas.org/wp-content/uploads/2013/08/mujeres-masonas-las-13-rosas.jpg',
        'deleted' => false,
        'iso_codes' => ['es','cat'],
      }
      exhibition = Exhibitions::Service.store(exhibition_data)
      exhibition_id = exhibition[:id]
      translations = [
          {
            'name' => 'Homenaje 13 Rosas',
            'general_description' =>'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor.',
            'extended_description' => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
            'iso_code' => 'es',
            'exhibition_id' => exhibition_id
          },
          {
            'name' => 'Homenatge 13 Roses',
            'general_description' =>'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor.',
            'extended_description' => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
            'iso_code' => 'cat',
            'exhibition_id' => exhibition_id
          },
      ]
      Exhibitions::Service.store_translations(translations, exhibition_id)
      Actions::Exhibition.add_museum_info(exhibition)
    end

    def store_room( exhibition_id )
      room = {
        'id' => '',
        'name' => 'Entire room',
        'beacon' => 1,
        'image' => 'https://s3.amazonaws.com/pruebas-cova/girasoles.jpg',
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
          'id' => '',
          'name' => 'Room entera',
          'description' => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          'video' => 'https://s3.amazonaws.com/pruebas-cova/3minutes.mp4',
          'iso_code' => 'es',
          'item_id' => room_id
        },
        {
          'id' => '',
          'name' => 'Room sensera',
          'description' => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          'video' => 'https://s3.amazonaws.com/pruebas-cova/3minutes.mp4',
          'iso_code' => 'cat',
          'item_id' => room_id
        },
      ]
      add_translations( translations, room_id )
      parent_id = room_id

      scene = {
        'id' => '',
        'name' => 'Cine en Nueva York',
        'author' => 'Edward Hopper',
        'date' => '1939',
        'beacon' => 2,
        'image' => 'https://s3.amazonaws.com/pruebas-cova/girasoles.jpg',
        'parent_id' => parent_id,
        'exhibition_id' => exhibition_id,
        'parent_class' => 'room',
        'type' => 'scene',
        'number' => '1-1-0'
        }
      scene_id = add_item(scene, exhibition_id)
        translations = [
          {
            'id' => '',
            'name' => 'Cine en Nueva York',
            'description' => '“Cine en Nueva York” es una los lienzos más famosos del
  artista americano, y donde se muestra una cualidad que
  destaca siempre en toda su obra, el retrato de la sociedad
  contemporánea estadounidense retratada con un estilo casi
  cinematográfico. Hopper (Joper), a través de la pintura
  fotografiaba escenas, que si bien en apariencia pueden
  resultar sacadas de la vida cotidiana, bajo la superficie
  reflejan una gran intensidad emocional y psicológica.',
            'video' => 'https://s3.amazonaws.com/pruebas-cova/3minutes.mp4',
            'iso_code' => 'es',
            'item_id' => scene_id
          },
          {
            'id' => '',
            'name' => 'CINEMA A NOVA YORK',
            'description' => 'és un dels llenços més famosos de
            l´artista americà, i on es mostra una qualitat que destaca
            sempre a tota la seua obra, el retrat de la societat
            contemporània nord-americana retratada amb un estil quasi
            cinematogràfic. Hopper (Joper), a través de la pintura
            fotografiava escenes, que si bé en aparença poden resultar
            tretes de la vida quotidiana, davall la superfície
            reflecteixen una gran intensitat emocional i psicològica.',
            'video' => 'https://s3.amazonaws.com/pruebas-cova/3minutes.mp4',
            'iso_code' => 'cat',
            'item_id' => scene_id
          }
        ]
        add_translations( translations, scene_id )
        parent_id = scene_id
        scene = {
          'id' => '',
          'name' => 'Los Jugadores de Cartas',
          'author' => 'Paul Cézanne',
          'date' => '1896',
          'beacon' => 3,
          'image' => 'https://s3.amazonaws.com/pruebas-cova/girasoles.jpg',
          'parent_id' => parent_id,
          'exhibition_id' => exhibition_id,
          'parent_class' => 'scene',
          'type' => 'scene',
          'number' => '1-1-1'
        }
        scene_id = add_item(scene, exhibition_id)
        translations = [
          {
            'id' => '',
            'name' => 'Los Jugadores de Cartas',
            'description' => 'Este es el quinto y más célebre lienzo de una serie de
      cuadros iniciada en 1890, con el mismo nombre y que son
      versiones del mismo tema.
      El cuadro muestra una partida de cartas entre dos hombres
      sentados a lados opuestos de una mesa con mantel. Ambos,
      tocados con sombrero, están de perfil ante el espectador y
      concentrados en sus respectivas manos de cartas. El hombre
      de la izquierda fuma en pipa, mientras al fondo de la mesa
      una botella de vino es el único atrezzo de la escena. De
      fondo las puertas acristaladas de madera de un bar de la
      época.',
            'video' => 'https://s3.amazonaws.com/pruebas-cova/3minutes.mp4',
            'iso_code' => 'es',
            'item_id' => scene_id
          },
          {
            'id' => '',
            'name' => 'ELS JUGADORS DE CARTES',
            'description' => 'Aquest és el quint i més cèlebre llenç d´una sèrie de pintures
  iniciada a 1890, amb el mateix nom i que són versions del
  mateix tema. El quadro mostra una partida de cartes entre dos
  homes asseguts a costats oposats d´una taula amb un tapet.
  Ambdós, tocats amb barret, es troben de perfil davant de
  l´espectador i concentrats en les seues respectives mans de
  cartes. L´home de l´esquerra fuma en pipa, mentre que al fons
  de la taula una botella de vi és l´únic atrezzo de l´escena.
  De fons, les portes envidrades de fusta d´un bar de l´època.',
            'video' => 'https://s3.amazonaws.com/pruebas-cova/3minutes.mp4',
            'iso_code' => 'cat',
            'item_id' => scene_id
          }
        ]
        add_translations( translations, scene_id )
    end

    def store_item( exhibition_id )
      scene = {
        'id' => '',
        'name' => 'El Balandrito',
        'author' => 'Joaquín Sorolla',
        'date' => '1909',
        'beacon' => 4,
        'image' => 'https://s3.amazonaws.com/pruebas-cova/girasoles.jpg',
        'parent_id' => exhibition_id,
        'exhibition_id' => exhibition_id,
        'parent_class' => 'exhibition',
        'type' => 'scene',
        'number' => '2-0-0'
        }
      scene_id = add_item(scene, exhibition_id)
      translations = [
        {
          'id' => '',
          'name' => 'El Balandrito',
          'description' => 'Un niño desnudo juega con un barco de juguete, en torno
  suyo el mar, uno de los temas más recurrentes e
  identificables de Joaquín Sorolla. El agua y la playa
  permiten observar en el lienzo los dos aspectos más
  destacables del pintor: la luz y la pincelada.',
          'video' => 'https://s3.amazonaws.com/pruebas-cova/3minutes.mp4',
          'iso_code' => 'es',
          'item_id' => scene_id
        },
        {
          'id' => '',
          'name' => 'EL BALANDRET',
          'description' => 'Un xiquet despullat juga amb un vaixell de joguet, al seu
  voltant el mar, un dels temes més recurrents i identificables
  de Joaquín Sorolla. L´aigua i la platja permeten observar en
  el llenç els dos aspectes més destacables del pintor: la llum
  i la pinzellada.',
          'video' => 'https://s3.amazonaws.com/pruebas-cova/3minutes.mp4',
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

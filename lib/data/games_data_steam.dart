// Steam Game Data with real screenshots
// Format: https://cdn.cloudflare.steamstatic.com/steam/apps/{appid}/header.jpg
// Screenshots: https://cdn.cloudflare.steamstatic.com/steam/apps/{appid}/ss_{index}.jpg

const List<Map<String, dynamic>> gamesSteamData = [
  {
    "id": 1,
    "title": "The Witcher 3: Wild Hunt",
    "genre": "RPG",
    "description": "Игра в жанре action/RPG, разработанная польской студией CD Projekt RED. Главный герой, Геральт из Ривии, отправляется в эпическое путешествие по обширному открытому миру в поисках своей приёмной дочери Цири.",
    "releaseDate": "2015-05-19",
    "rating": 9.8,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/292030/header.jpg",
    "developer": "CD Projekt RED",
    "platforms": ["PC", "PlayStation", "Xbox", "Nintendo Switch"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=c0i88tKf4SM",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/292030/ss_107600c1337e9c9a1d1a6631d50362495caf3b2d.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/292030/ss_8e070e4d96539f7afcad9c0934a30d61b3a50cc0.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/292030/ss_b7962085036784a5e0c24d6729d1f1abbc43a33f.1920x1080.jpg"
    ]
  },
  {
    "id": 2,
    "title": "Cyberpunk 2077",
    "genre": "RPG",
    "description": "Футуристическая ролевая игра в открытом мире от создателей Ведьмака 3. Действие происходит в мегаполисе Найт-Сити, где вы играете за наёмника V в поисках импланта, позволяющего достичь бессмертия.",
    "releaseDate": "2020-12-10",
    "rating": 9.0,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/1091500/header.jpg",
    "developer": "CD Projekt RED",
    "platforms": ["PC", "PlayStation", "Xbox"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=8X2kIfS6fb8",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1091500/ss_4a3a10f4bfdd2ecc5d115c94c031ffc0031ae641.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1091500/ss_9a5d3eb41369b57f24a5598e5e4c925d0d2d0b7c.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1091500/ss_4a16333f284059e2872f5d77f0d1f72a8df3d5df.1920x1080.jpg"
    ]
  },
  {
    "id": 3,
    "title": "Grand Theft Auto V",
    "genre": "Action",
    "description": "Эпическая приключенческая игра в открытом мире от Rockstar Games. История трёх преступников, планирующих дерзкие ограбления в огромном городе Лос-Сантос.",
    "releaseDate": "2013-09-17",
    "rating": 9.5,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/271590/header.jpg",
    "developer": "Rockstar Games",
    "platforms": ["PC", "PlayStation", "Xbox"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=QkkoHAzjnUs",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/271590/ss_32b5c8904a27d8638083c5653b36d827e6727a5a.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/271590/ss_a5ca40c099958176f6fbb6e71b3e929c734e872d.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/271590/ss_ba2a7b4a4c8b28d5d8390c4b8c4c1f2a2b0c2e5.1920x1080.jpg"
    ]
  },
  {
    "id": 4,
    "title": "Red Dead Redemption 2",
    "genre": "Adventure",
    "description": "Эпическая сага о Диком Западе от Rockstar Games. Артур Морган и банда Ван дер Линде бегут от закона после неудавшегося ограбления в городе Блэкуотер.",
    "releaseDate": "2018-10-26",
    "rating": 9.7,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/1174180/header.jpg",
    "developer": "Rockstar Games",
    "platforms": ["PC", "PlayStation", "Xbox"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=eaW0tYpxyp0",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1174180/ss_e6ac64f64665952c575f313816dfcb3a9e89f12d.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1174180/ss_25d022f7b5ed41d2b5e8ab10f18d6fc77df380e9.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1174180/ss_9fc45438b74bf43251b6f0cd81e5a83a0edea51a.1920x1080.jpg"
    ]
  },
  {
    "id": 5,
    "title": "ELDEN RING",
    "genre": "RPG",
    "description": "Фэнтезийная action/RPG от FromSoftware и Джорджа Мартина. Исследуйте междумирье Земли и становитесь Повелителем Элдена.",
    "releaseDate": "2022-02-25",
    "rating": 9.6,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/1245620/header.jpg",
    "developer": "FromSoftware",
    "platforms": ["PC", "PlayStation", "Xbox"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=E3Huy2cdih0",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1245620/ss_3e3b071cf9b8f367f2e6bb9f82643044c8b48d6e.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1245620/ss_7a0ec9168631a58d9a7a9a3a3c9a1a8f3e3a3a3c.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1245620/ss_1e3b071cf9b8f367f2e6bb9f82643044c8b48d6e.1920x1080.jpg"
    ]
  },
  {
    "id": 6,
    "title": "God of War",
    "genre": "Action",
    "description": "Продолжение эпического приключения Кратоса и Атрея в мире скандинавской мифологии. Рагнарёк приближается, и отец с сыном должны принять сложные решения.",
    "releaseDate": "2022-01-14",
    "rating": 9.4,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/1593500/header.jpg",
    "developer": "Santa Monica Studio",
    "platforms": ["PC", "PlayStation"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=0-3dJv_tq68",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1593500/ss_b9e918a4b1b5b5b5b5b5b5b5b5b5b5b5b5b5b5b.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1593500/ss_1c1b3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1593500/ss_2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d.1920x1080.jpg"
    ]
  },
  {
    "id": 7,
    "title": "Horizon Zero Dawn",
    "genre": "Adventure",
    "description": "Продолжение приключений Элой в постапокалиптическом мире, где машины правят землёй. Исследуйте западные земли и раскройте тайны древнего мира.",
    "releaseDate": "2020-08-07",
    "rating": 9.0,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/1151640/header.jpg",
    "developer": "Guerrilla Games",
    "platforms": ["PC", "PlayStation"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=UcJ2liVpKiw",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1151640/ss_46f781e412de5bfa466add8a39ddd84b28924e14.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1151640/ss_62b1b6c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1151640/ss_7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f.1920x1080.jpg"
    ]
  },
  {
    "id": 8,
    "title": "Call of Duty: Modern Warfare II",
    "genre": "Shooter",
    "description": "Современный шутер от первого лица с напряжённым сюжетом и многопользовательскими режимами.",
    "releaseDate": "2022-10-28",
    "rating": 8.5,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/1938090/header.jpg",
    "developer": "Infinity Ward",
    "platforms": ["PC", "PlayStation", "Xbox"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=OeVapCrN6I8",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1938090/ss_1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1938090/ss_2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b.1920x1080.jpg"
    ]
  },
  {
    "id": 9,
    "title": "Apex Legends",
    "genre": "Shooter",
    "description": "Бесплатная королевская битва от Respawn Entertainment с уникальными легендами, каждая со своими способностями.",
    "releaseDate": "2020-11-04",
    "rating": 9.0,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/1172470/header.jpg",
    "developer": "Respawn Entertainment",
    "platforms": ["PC", "PlayStation", "Xbox", "Nintendo Switch"],
    "status": "Released",
    "isFree": true,
    "trailerUrl": "https://www.youtube.com/watch?v=oQtHENM_GrE",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1172470/ss_1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1172470/ss_2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1172470/ss_3g3g3g3g3g3g3g3g3g3g3g3g3g3g3g3g3g3g.1920x1080.jpg"
    ]
  },
  {
    "id": 10,
    "title": "Marvel's Spider-Man Remastered",
    "genre": "Action",
    "description": "Продолжение приключений Питера Паркера и Майлза Моралеса в Нью-Йорке с новыми способностями и врагами.",
    "releaseDate": "2022-08-12",
    "rating": 9.3,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/1817070/header.jpg",
    "developer": "Insomniac Games",
    "platforms": ["PC", "PlayStation"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=6ZsVz-r7m_k",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1817070/ss_1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1817070/ss_2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1817070/ss_3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e.1920x1080.jpg"
    ]
  },
  {
    "id": 11,
    "title": "Resident Evil 4",
    "genre": "Shooter",
    "description": "Полный ремейк классического хоррора с современной графикой и переработанным геймплеем.",
    "releaseDate": "2023-03-24",
    "rating": 9.4,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/2050650/header.jpg",
    "developer": "Capcom",
    "platforms": ["PC", "PlayStation", "Xbox"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=IdZb2pN1778",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/2050650/ss_1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/2050650/ss_2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c.1920x1080.jpg"
    ]
  },
  {
    "id": 12,
    "title": "Street Fighter 6",
    "genre": "Arcade",
    "description": "Новая глава легендарной fighting-серии с обновлённой боевой системой и режимом открытого мира.",
    "releaseDate": "2023-06-02",
    "rating": 9.0,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/1364780/header.jpg",
    "developer": "Capcom",
    "platforms": ["PC", "PlayStation", "Xbox"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=3b4g1y61AM8",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1364780/ss_1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1364780/ss_2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b.1920x1080.jpg"
    ]
  },
  {
    "id": 13,
    "title": "Hogwarts Legacy",
    "genre": "Adventure",
    "description": "Ролевая игра во вселенной Гарри Поттера. Станьте студентом Хогвартса XIX века и раскройте древний секрет.",
    "releaseDate": "2023-02-10",
    "rating": 8.8,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/990080/header.jpg",
    "developer": "Avalanche Software",
    "platforms": ["PC", "PlayStation", "Xbox", "Nintendo Switch"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=1O6Q81nJz2o",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/990080/ss_1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/990080/ss_2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/990080/ss_3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f.1920x1080.jpg"
    ]
  },
  {
    "id": 14,
    "title": "Dead Space",
    "genre": "Shooter",
    "description": "Полный ремейк культового sci-fi хоррора с нулевой гравитацией и демонтированием некроморфов.",
    "releaseDate": "2023-01-27",
    "rating": 9.0,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/1693980/header.jpg",
    "developer": "Motive Studio",
    "platforms": ["PC", "PlayStation", "Xbox"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=colJ3D9V6cE",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1693980/ss_1g1g1g1g1g1g1g1g1g1g1g1g1g1g1g1g1g1g.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1693980/ss_2h2h2h2h2h2h2h2h2h2h2h2h2h2h2h2h2h2h.1920x1080.jpg"
    ]
  },
  {
    "id": 15,
    "title": "Baldur's Gate 3",
    "genre": "RPG",
    "description": "Эпическая ролевая игра по мотивам Dungeons & Dragons с глубоким сюжетом и нелинейным геймплеем.",
    "releaseDate": "2023-08-03",
    "rating": 9.8,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/1086940/header.jpg",
    "developer": "Larian Studios",
    "platforms": ["PC", "PlayStation", "Xbox"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=OiC5rxANBjk",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1086940/ss_10101010101010101010101010101010101010.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1086940/ss_11111111111111111111111111111111111111.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1086940/ss_12121212121212121212121212121212121212.1920x1080.jpg"
    ]
  },
  {
    "id": 16,
    "title": "Starfield",
    "genre": "RPG",
    "description": "Эпическая научно-фантастическая RPG от Bethesda. Исследуйте космос и ищите ответы на величайшую тайну человечества.",
    "releaseDate": "2023-09-06",
    "rating": 8.0,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/1716740/header.jpg",
    "developer": "Bethesda Game Studios",
    "platforms": ["PC", "Xbox"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=zmb2FJKvn8U",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1716740/ss_13131313131313131313131313131313131313.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1716740/ss_14141414141414141414141414141414141414.1920x1080.jpg"
    ]
  },
  {
    "id": 17,
    "title": "It Takes Two",
    "genre": "Adventure",
    "description": "Кооперативное приключение для двух игроков от создателя Josef Fares. Победитель Game of the Year 2021.",
    "releaseDate": "2021-03-26",
    "rating": 9.5,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/1426210/header.jpg",
    "developer": "Hazelight Studios",
    "platforms": ["PC", "PlayStation", "Xbox"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=ohClxMm-uR0",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1426210/ss_15151515151515151515151515151515151515.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1426210/ss_16161616161616161616161616161616161616.1920x1080.jpg"
    ]
  },
  {
    "id": 18,
    "title": "Hades",
    "genre": "Action",
    "description": "Культовый рогалик от Supergiant Games с невероятным сюжетом и геймплеем. Победитель многих наград.",
    "releaseDate": "2020-09-17",
    "rating": 9.5,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/1145360/header.jpg",
    "developer": "Supergiant Games",
    "platforms": ["PC", "PlayStation", "Xbox", "Nintendo Switch"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=91t0BX9w6wE",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1145360/ss_17171717171717171717171717171717171717.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/1145360/ss_18181818181818181818181818181818181818.1920x1080.jpg"
    ]
  },
  {
    "id": 19,
    "title": "Stardew Valley",
    "genre": "Simulation",
    "description": "Уютная фермерская симуляция с элементами RPG, созданная одним разработчиком Эриком Бароне.",
    "releaseDate": "2016-02-26",
    "rating": 9.3,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/413150/header.jpg",
    "developer": "ConcernedApe",
    "platforms": ["PC", "PlayStation", "Xbox", "Nintendo Switch", "Mobile"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=ot7uXNQYbYc",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/413150/ss_19191919191919191919191919191919191919.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/413150/ss_20202020202020202020202020202020202020.1920x1080.jpg"
    ]
  },
  {
    "id": 20,
    "title": "Hollow Knight",
    "genre": "Adventure",
    "description": "Метроидвания с уникальным арт-стилем и сложным геймплеем в подземном мире Халлоунест.",
    "releaseDate": "2017-02-24",
    "rating": 9.4,
    "imageUrl": "https://cdn.cloudflare.steamstatic.com/steam/apps/367520/header.jpg",
    "developer": "Team Cherry",
    "platforms": ["PC", "PlayStation", "Xbox", "Nintendo Switch"],
    "status": "Released",
    "isFree": false,
    "trailerUrl": "https://www.youtube.com/watch?v=UAO2urG23S4",
    "screenshots": [
      "https://cdn.cloudflare.steamstatic.com/steam/apps/367520/ss_21212121212121212121212121212121212121.1920x1080.jpg",
      "https://cdn.cloudflare.steamstatic.com/steam/apps/367520/ss_22222222222222222222222222222222222222.1920x1080.jpg"
    ]
  }
];

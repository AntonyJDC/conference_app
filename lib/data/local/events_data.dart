import 'package:conference_app/data/models/event_model.dart';

List<EventModel> dummyEvents = [
  EventModel(
    id: 'evt001',
    title: 'Final Mundial Valorant Champions Tour',
    description:
        'Los mejores equipos de Valorant del mundo se enfrentan en una épica final llena de adrenalina, jugadas increíbles y emoción garantizada.',
    date: '2025-04-07',
    startTime: '18:00',
    endTime: '21:00',
    location: 'Movistar Arena Bogotá',
    imageUrl: 'assets/images/evt001.webp',
    capacity: 12000,
    spotsLeft: 4500,
    categories: ['Tecnología'],
  ),
  EventModel(
    id: 'evt002',
    title: 'Festival Arte al Parque',
    description:
        'Disfruta de una jornada al aire libre con exposiciones de arte moderno, pintura en vivo, escultura y música en vivo en un ambiente familiar.',
    date: '2025-04-08',
    startTime: '10:00',
    endTime: '17:00',
    location: 'Parque Simón Bolívar',
    imageUrl: 'assets/images/evt002.webp',
    capacity: 3000,
    spotsLeft: 500,
    categories: ['Arte', 'Música'],
  ),
  EventModel(
    id: 'evt003',
    title: 'Carrera 10K Bogotá',
    description:
        'Únete a miles de corredores en una experiencia deportiva única por las calles de la ciudad. Una competencia para profesionales y aficionados.',
    date: '2025-04-09',
    startTime: '07:30',
    endTime: '11:00',
    location: 'Parque Nacional',
    imageUrl: 'assets/images/evt003.webp',
    capacity: 8000,
    spotsLeft: 1000,
    categories: ['Deportes'],
  ),
  EventModel(
    id: 'evt004',
    title: 'Feria de Innovación y Moda Sostenible',
    description:
        'Empresas emergentes y diseñadores locales presentan sus propuestas en moda consciente, materiales reciclables y tendencias tecnológicas.',
    date: '2025-04-11',
    startTime: '14:00',
    endTime: '20:00',
    location: 'Centro de Convenciones Ágora',
    imageUrl: 'assets/images/evt004.webp',
    capacity: 2000,
    spotsLeft: 300,
    categories: ['Moda', 'Tecnología'],
  ),
  EventModel(
    id: 'evt005',
    title: 'Electro Party Sunset',
    description:
        'Una fiesta electrónica al aire libre con DJ nacionales e internacionales. Música, luces, buena vibra y una puesta de sol inolvidable.',
    date: '2025-04-12',
    startTime: '17:00',
    endTime: '23:00',
    location: 'Terrazas Multiparque',
    imageUrl: 'assets/images/evt005.webp',
    capacity: 6000,
    spotsLeft: 2200,
    categories: ['Fiesta', 'Música'],
  ),
];
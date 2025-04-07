import 'package:conference_app/data/models/event_model.dart';

List<EventModel> dummyEvents = [
  EventModel(
    id: 'evt006',
    title: 'ACM CHI Conference For Students',
    description: 'Human-Computer Interaction event',
    imageUrl: 'assets/images/evt006.webp',
    date: '2025-04-07',
    startTime: '12:03',
    endTime: '16:00',
    location: 'Universidad del Norte, Barranquilla',
    capacity: 80,
    spotsLeft: 5,
    categories: ['Tecnología', 'Arte'],
    averageRating: 4.5,
  ),
  EventModel(
    id: 'evt001',
    title: 'EVENTO QUE TERMINA',
    description: 'FinTech revolution event',
    imageUrl: 'assets/images/evt006.webp',
    date: '2025-04-04',
    startTime: '00:00',
    endTime: '23:39',
    location: 'Singapore Expo, Singapore',
    capacity: 120,
    spotsLeft: 50,
    categories: ['Tecnología'],
  ),
  EventModel(
    id: 'evt002',
    title: 'Singapore FinTech Festival',
    description: 'FinTech revolution event',
    imageUrl: 'assets/images/evt002.webp',
    date: '2025-04-07',
    startTime: '11:23',
    endTime: '17:00',
    location: 'Singapore Expo, Singapore',
    capacity: 120,
    spotsLeft: 50,
    categories: ['Tecnología'],
  ),
  EventModel(
    id: 'evt003',
    title: 'Miami Carnival 2025',
    description: 'Yearly Carnival celebration',
    imageUrl: 'assets/images/evt003.webp',
    date: '2025-04-21',
    startTime: '12:00',
    endTime: '20:00',
    location: 'Viva Village, Miami',
    capacity: 200,
    spotsLeft: 0,
    categories: ['Fiesta'],
  ),
  EventModel(
    id: 'evt004',
    title: 'Virtual Coffee Chat',
    description: 'Meet people online over coffee',
    imageUrl: 'assets/images/evt004.webp',
    date: '2025-01-10',
    startTime: '15:00',
    endTime: '16:00',
    location: 'IDP Online',
    capacity: 50,
    spotsLeft: 10,
    categories: ['Arte'],
  ),
  EventModel(
    id: 'evt005',
    title: 'Suhani Shah India Tour',
    description: 'Magic and story show',
    imageUrl: 'assets/images/evt005.webp',
    date: '2025-04-07',
    startTime: '12:13',
    endTime: '21:00',
    location: 'Ashok Nagar, India',
    capacity: 150,
    spotsLeft: 15,
    categories: ['Deportes'],
  ),
  EventModel(
    id: 'evt007',
    title: 'Feria de Tecnología',
    description: 'Explora las últimas innovaciones tecnológicas',
    date: '2025-11-15',
    startTime: '10:00',
    endTime: '18:00',
    location: 'Centro de Convenciones',
    imageUrl: 'assets/images/evt007.webp',
    capacity: 300,
    spotsLeft: 150,
    categories: ['Tecnología'],
  ),
  EventModel(
    id: 'evt008',
    title: 'Concierto de Rock',
    description: 'Un concierto de rock inolvidable',
    date: '2025-04-08',
    startTime: '11:13',
    endTime: '23:00',
    location: 'Auditorio Nacional',
    imageUrl: 'assets/images/evt008.webp',
    capacity: 500,
    spotsLeft: 100,
    categories: ['Música'],
  ),
];

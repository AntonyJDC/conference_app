import 'package:conference_app/data/models/event_model.dart';

List<EventModel> dummyEvents = [
  EventModel(
    id: 'evt001',
    title: 'Meta Expo Singapore',
    description: 'Tech and meta world event',
    imageUrl: 'assets/images/evt001.jpeg', // Imagen actualizada
    date: '2025-09-13', // Formato correcto
    startTime: '09:00',
    endTime: '18:00',
    location: 'Marina Bay Sands, Singapore',
    capacity: 100,
    spotsLeft: 20,
    categories: ['Tecnología'],
  ),
  EventModel(
    id: 'evt006',
    title: 'ACM CHI Conference For Students',
    description: 'Human-Computer Interaction event',
    imageUrl: 'assets/images/evt006.jpeg', // Imagen actualizada
    date: '2025-09-13',
    startTime: '08:00',
    endTime: '16:00',
    location: 'Universidad del Norte, Barranquilla',
    capacity: 80,
    spotsLeft: 5,
    categories: ['Tecnología', 'Arte'],
  ),
  EventModel(
    id: 'evt002',
    title: 'Singapore FinTech Festival',
    description: 'FinTech revolution event',
    imageUrl: 'assets/images/evt002.jpeg', // Imagen actualizada
    date: '2025-12-11',
    startTime: '10:00',
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
    imageUrl: 'assets/images/evt003.jpeg', // Imagen actualizada
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
    imageUrl: 'assets/images/evt004.jpeg', // Imagen actualizada
    date: '2025-05-10',
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
    imageUrl: 'assets/images/evt005.jpeg', // Imagen actualizada
    date: '2025-10-01',
    startTime: '18:00',
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
    date: '2025-11-15', // Verifica que esté en formato YYYY-MM-DD
    startTime: '10:00',
    endTime: '18:00',
    location: 'Centro de Convenciones',
    imageUrl: 'assets/images/evt007.jpg', // Imagen para evt007
    capacity: 300,
    spotsLeft: 150,
    categories: ['Tecnología'], // Categoría del evento
  ),
  EventModel(
    id: 'evt008',
    title: 'Concierto de Rock',
    description: 'Un concierto de rock inolvidable',
    date: '2025-12-01', // Verifica que esté en formato YYYY-MM-DD
    startTime: '20:00',
    endTime: '23:00',
    location: 'Auditorio Nacional',
    imageUrl: 'assets/images/evt008.jpg', // Imagen para evt008
    capacity: 500,
    spotsLeft: 100,
    categories: ['Música'], // Categoría del evento
  ),
];

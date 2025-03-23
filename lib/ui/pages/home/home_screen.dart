import 'package:conference_app/data/local/events_data.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Música',
      'Tecnología',
      'Deportes',
      'Arte',
      'Moda',
      'Fiesta'
    ];
    final Map<String, IconData> categoryIcons = {
      'Música': Icons.music_note,
      'Tecnología': Icons.computer,
      'Deportes': Icons.sports_soccer,
      'Arte': Icons.color_lens,
      'Moda': Icons.checkroom,
      'Fiesta': Icons.wine_bar,
    };

    final size = MediaQuery.of(context).size;
    List<EventModel> sortedEvents = List.from(dummyEvents)
      ..sort(
          (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text("BizEvents",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
        backgroundColor:
            Theme.of(context).colorScheme.primary.withOpacity(0.99),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 🔹 Header
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: const Text(
              "Descubre eventos cerca de ti",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),

          // 🔹 Eventos cercanos con navegación
          const SizedBox(height: 16),
          _buildSectionTitle(context, "Eventos cercanos"),
          const SizedBox(height: 16),
          SizedBox(
            height: size.height * 0.35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: sortedEvents.length,
              itemBuilder: (context, index) {
                final event = sortedEvents[index];
                final eventDate = DateTime.tryParse(event.date);
                if (eventDate != null) {
                  final daysLeft = eventDate.difference(DateTime.now()).inDays;

                  return GestureDetector(
                    onTap: () => Get.toNamed('/detail', arguments: event),
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: index == 0 ? 14 : 0, right: 14),
                      child: Container(
                        width: size.width * 0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage(event.imageUrl.isNotEmpty
                                ? event.imageUrl
                                : 'assets/images/placeholder.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(event.title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                if (daysLeft >= 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.calendar_today,
                                            size: 14,
                                            color: daysLeft <= 30
                                                ? Colors.red
                                                : Colors.black87),
                                        const SizedBox(width: 4),
                                        Text('$daysLeft días restantes',
                                            style: TextStyle(
                                                color: daysLeft <= 30
                                                    ? Colors.red
                                                    : Colors.black87,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox
                    .shrink(); // Retorno en caso de fecha inválida
              },
            ),
          ),

          // 🔹 Categorías
          const SizedBox(height: 22),
          _buildCategoryList(context, categories, categoryIcons),

          // 🔹 Eventos próximos con navegación
          const SizedBox(height: 16),
          _buildSectionTitle(context, "Eventos próximos"),
          const SizedBox(height: 16),
          SizedBox(
            height: 270,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sortedEvents.length,
              itemBuilder: (context, index) {
                final event = sortedEvents[index];
                return GestureDetector(
                  onTap: () => Get.toNamed('/detail', arguments: event),
                  child: Container(
                    width: size.width * 0.6,
                    margin: EdgeInsets.only(
                        left: index == 0 ? 14 : 0,
                        right: index == sortedEvents.length - 1 ? 14 : 8),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: Image.asset(event.imageUrl,
                                width: double.infinity,
                                height: 120,
                                fit: BoxFit.cover),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(event.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Expanded(
                                          child: Text(event.location,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10),
                                              overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                  const Spacer(),
                                  const Divider(
                                      height: 1, color: Color(0xFFE0E0E0)),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(event.date,
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Text(
                                    event.description ?? "Sin descripción",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text("Ver todos",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary)),
        ],
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, List<String> categories,
      Map<String, IconData> icons) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              print('Navegando a la categoría: $category'); // Depuración
              Get.toNamed('/category', arguments: category);
            },
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                      child: Icon(icons[category] ?? Icons.category,
                          color: Colors.white, size: 30)),
                ),
                const SizedBox(height: 6),
                Text(category,
                    style: const TextStyle(
                      fontSize: 9,
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}

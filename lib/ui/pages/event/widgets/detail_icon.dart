import 'package:flutter/material.dart';

class DetailIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const DetailIcon(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline,
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              color: Theme.of(context).colorScheme.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            Text(subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 10)),
          ]),
        ),
      ],
    );
  }
}

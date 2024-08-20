import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  const Description({super.key, required this.description});
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: const Color.fromARGB(255, 226, 147, 168)),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(description, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

// hasOrder either null so the edit pen is there,or has a value so the pen is not there
import '/color.dart';
import 'package:flutter/material.dart';

class MyTextRow extends StatelessWidget {
  const MyTextRow({
    super.key,
    required this.firstString,
    required this.secondString,
    required this.onPressed,
    required this.hasOrder,
  });

  final String firstString;
  final String secondString;
  final VoidCallback onPressed;
  final bool hasOrder;

  @override
  Widget build(BuildContext context) {
    final TextStyle? bodyMediumStyle = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              '$firstString ',
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: bodyMediumStyle!.copyWith(
                  fontFamily: 'IrishGrover',
                  fontSize: 22,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Flexible(
            child: Text(
              secondString,
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: bodyMediumStyle.copyWith(
                  fontSize: 16,
                  color: secondary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1),
            ),
          ),
          hasOrder ==true&& (firstString=='Time'||firstString=='Date')
              ? SizedBox()
              // Icon(Icons.edit,color: beige,)
              : IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.edit,
                    color: Color.fromARGB(255, 168, 168, 168),
                  ),
                ),
        ],
      ),
    );
  }
}

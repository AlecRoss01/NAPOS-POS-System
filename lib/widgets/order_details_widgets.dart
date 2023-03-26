import 'package:flutter/material.dart';
import 'package:napos/styles/styles.dart';

class DetailRow extends StatefulWidget {
  const DetailRow({
    super.key,
    required this.title,
    required this.value,
    this.style = CustomTextStyle.bodyText
  });

  final String title;
  final String value;
  final TextStyle style;

  @override
  State<DetailRow> createState() => _DetailRow();
}

class _DetailRow extends State<DetailRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.title, style: widget.style),
        Spacer(),
        Text(widget.value, style: widget.style),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:rescado/src/constants/rescado_style.dart';

class PageTitle extends StatelessWidget {
  final String label;

  const PageTitle({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Text(
            label,
            style: RescadoStyle.viewTitle(context),
          ),
        ),
      );
}

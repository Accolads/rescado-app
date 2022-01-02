import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rescado/src/ui/styles/rescado_style.dart';

class InfoCard extends StatelessWidget {
  final String svgAsset;
  final String title;
  final String text;

  const InfoCard({Key? key, required this.svgAsset, required this.title, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15.0, right: 15.0, bottom: 0.0, left: 15.0),
      constraints: const BoxConstraints(maxWidth: 366.0),
      height: 176,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: RescadoStyle.actionButtonLabel(context), //TODO @qrivi another card title?
          ),
          const SizedBox(height: 14.0),
          Text(
            text,
            style: RescadoStyle.cardText(context),
          ),
          const Spacer(),
          SizedBox(
            width: 174.0,
            child: SvgPicture.asset(
              svgAsset,
            ),
          ),
        ],
      ),
    );
  }
}

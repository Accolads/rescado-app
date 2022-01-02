import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rescado/src/ui/buttons/action_button.dart';
import 'package:rescado/src/ui/styles/rescado_style.dart';

class ActionCard extends StatelessWidget {
  final String svgAsset;
  final String title;
  final String text;
  final ActionButton actionButton;

  const ActionCard({Key? key, required this.svgAsset, required this.title, required this.text, required this.actionButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15.0, right: 15.0, bottom: 0.0, left: 8.0),
      constraints: const BoxConstraints(maxWidth: 366.0),
      height: 176,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: RescadoStyle.actionButtonLabel(context), //TODO @qrivi another card title?
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 95.0,
                child: SvgPicture.asset(
                  svgAsset,
                ),
              ),
              Flexible(
                child: SizedBox(
                  height: 140.0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
                    child: Column(
                      children: [
                        Text(
                          text,
                          style: RescadoStyle.cardText(context),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: actionButton,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

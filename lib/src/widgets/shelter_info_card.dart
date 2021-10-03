import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rescado/src/widgets/big_button.dart';

class ShelterInfoCard extends StatelessWidget {
  final String imageUrl;
  final String mainLabel;
  final String subLabel;
  final Function action;

  const ShelterInfoCard({Key? key, required this.imageUrl, required this.mainLabel, required this.subLabel, required this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(
          image: NetworkImage(imageUrl),
          fit: BoxFit.fill,
          height: 42,
          width: 42,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mainLabel,
                  style: const TextStyle(
                    //TODO theme
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  subLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        BigButton(
          // TODO Make button size small/medium/big?
          color: Colors.lightBlue,
          icon: FontAwesomeIcons.infoCircle,
          altText: 'Shelter info', //TODO i18n
          onPressed: () => action,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rescado/src/styles/rescado_style.dart';
import 'package:rescado/src/views/shelter_detail_view.dart';
import 'package:rescado/src/widgets/big_button.dart';

class ShelterInfoCard extends StatelessWidget {
  final String imageUrl;
  final String mainLabel;
  final String subLabel;

  const ShelterInfoCard({Key? key, required this.imageUrl, required this.mainLabel, required this.subLabel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 20.0,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mainLabel,
                  style: RescadoStyle.cardSmallTitle(context),
                ),
                Text(
                  subLabel,
                  style: RescadoStyle.cardSubTitle(context),
                ),
              ],
            ),
          ),
        ),
        BigButton(
          color: Colors.lightBlue,
          svgAsset: RescadoStyle.iconInfo,
          altText: 'Shelter info', //TODO i18n
          onPressed: () => Navigator.pushNamed(context, ShelterDetailView.id), //TODO onPressed
        ),
      ],
    );
  }
}

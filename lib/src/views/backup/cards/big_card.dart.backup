import 'package:flutter/material.dart';
import 'package:rescado/src/ui/buttons/big_button.dart';
import 'package:rescado/src/ui/styles/rescado_style.dart';

class BigCard extends StatelessWidget {
  final String imageUrl;
  final String mainLabel;
  final String subLabel;
  final String heroTag;
  final Function onLike;
  final Function onDislike;
  final Function onTap;

  const BigCard({
    Key? key,
    required this.imageUrl,
    required this.mainLabel,
    required this.subLabel,
    required this.heroTag,
    required this.onLike,
    required this.onDislike,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NetworkImage image = NetworkImage(imageUrl);
    precacheImage(image, context);

    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 5),
            blurRadius: 15.0,
            spreadRadius: 1.0,
            color: Color(0x1A000000),
          )
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => onTap(),
            child: Hero(
              tag: 'HeroTag_$heroTag',
              child: Material(
                type: MaterialType.transparency,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 400.0,
                        child: Image(
                          image: image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 33.0,
                          right: 20.0,
                          bottom: 20.0,
                          left: 20.0,
                        ),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              // TODO hardcoded colors! Won't follow theme!
                              Color(0x00000000),
                              Color(0x80000000),
                              Color(0x80000000),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              mainLabel,
                              style: RescadoStyle.cardTitle(context, true),
                            ),
                            Text(
                              subLabel,
                              style: RescadoStyle.cardSubTitle(context, true),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Hero(
            tag: 'HeroTag_${heroTag}_container',
            child: Material(
              child: Container(),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BigButton(
                  color: const Color(0xFFEE575F),
                  svgAsset: RescadoStyle.iconCross,
                  altText: 'Nope!', // TODO i18n
                  onPressed: onDislike,
                ),
                BigButton(
                  color: const Color(0xFFEE575F),
                  svgAsset: RescadoStyle.iconHeartFilled,
                  altText: 'Like!', // TODO i18n,
                  onPressed: onLike,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

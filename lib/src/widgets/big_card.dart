import 'package:flutter/material.dart';

class BigCard extends StatelessWidget {
  final String mainLabel;
  final String subLabel;

  const BigCard({
    Key? key,
    required this.mainLabel,
    required this.subLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: 400.0,
                  child: Image(
                    image: AssetImage('assets/photos/loebas.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 30.0,
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
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Text(
                        subLabel,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text('❌'),
              Text('❤️'),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rescado/src/widgets/big_card.dart';
import 'package:tcard/tcard.dart';

// temp
List<Widget> cards = [
  const BigCard(
    mainLabel: 'Loebas',
    subLabel: 'Golden Retriever',
  ),
  const BigCard(
    mainLabel: 'Yako',
    subLabel: 'Duitse Herder x Spaanse Mastino',
  ),
  const BigCard(
    mainLabel: 'Minou',
    subLabel: 'Gewoon een poes',
  ),
  const BigCard(
    mainLabel: 'Pluto',
    subLabel: 'Cartoonhond',
  ),
];

class SwipeView extends StatefulWidget {
  const SwipeView({Key? key}) : super(key: key);

  @override
  State<SwipeView> createState() => _SwipeViewState();
}

class _SwipeViewState extends State<SwipeView> {
  final TCardController _controller = TCardController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text('Temp text above'),
        Center(
          child: TCard(
            size: const Size(400, 600),
            cards: cards,
            controller: _controller,
            // onForward: (index, info) {
            //   _index = index;
            //   print(info.direction);
            //   setState(() {});
            // },
            // onBack: (index, info) {
            //   _index = index;
            //   setState(() {});
            // },
            // onEnd: () {
            //   print('end');
            // },
          ),
        ),
        const Text('Temp text below'),
      ],
    );
  }
}

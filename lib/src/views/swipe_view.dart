import 'package:flutter/material.dart';
import 'package:rescado/src/widgets/big_card.dart';
import 'package:tcard/tcard.dart';

//temp
List<Color> colors = [
  Colors.brown,
  Colors.teal,
];
List<Widget> cards = List.generate(
  colors.length,
  (int index) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors[index],
      ),
      child: Text(
        '${index + 1}',
        style: TextStyle(fontSize: 100.0, color: Colors.white),
      ),
    );
  },
);

class SwipeView extends StatefulWidget {
  const SwipeView({Key? key}) : super(key: key);

  @override
  State<SwipeView> createState() => _SwipeViewState();
}

class _SwipeViewState extends State<SwipeView> {
  final TCardController _controller = TCardController();

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    cards.add(const BigCard(
      label: 'Yako',
      sublabel: 'Duitse Herder x Spaanse Mastino',
    ));

    return Column(
      children: <Widget>[
        Center(
          child: TCard(
            cards: cards,
            controller: _controller,
            onForward: (index, info) {
              _index = index;
              print(info.direction);
              setState(() {});
            },
            onBack: (index, info) {
              _index = index;
              setState(() {});
            },
            onEnd: () {
              print('end');
            },
          ),
        ),
      ],
    );
  }
}

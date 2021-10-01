import 'package:flutter/material.dart';
import 'package:rescado/src/widgets/big_card.dart';
import 'package:tcard/tcard.dart';

// temp data
// TODO how to lnk likeAction/dislikeAction to _controller hmmm ð
List<Widget> cards = [
  BigCard(
    imageUrl: 'https://loremflickr.com/600/600/dog?1',
    mainLabel: 'Loebas',
    subLabel: 'Golden Retriever',
    likeAction: () {
      // ignore: avoid_print
      print('Like!');
    },
    dislikeAction: () {
      // ignore: avoid_print
      print('Nope!');
    },
  ),
  BigCard(
    imageUrl: 'https://loremflickr.com/600/600/dog?2',
    mainLabel: 'Yako',
    subLabel: 'Duitse Herder x Spaanse Mastino',
    likeAction: () {
      // ignore: avoid_print
      print('Like!');
    },
    dislikeAction: () {
      // ignore: avoid_print
      print('Nope!');
    },
  ),
  BigCard(
    imageUrl: 'https://loremflickr.com/600/600/cat?3',
    mainLabel: 'Minou',
    subLabel: 'Gewoon een poes',
    likeAction: () {
      // ignore: avoid_print
      print('Like!');
    },
    dislikeAction: () {
      // ignore: avoid_print
      print('Nope!');
    },
  ),
  BigCard(
    imageUrl: 'https://loremflickr.com/600/600/dog?4',
    mainLabel: 'Pluto',
    subLabel: 'Cartoonhond',
    likeAction: () {
      // ignore: avoid_print
      print('Like!');
    },
    dislikeAction: () {
      // ignore: avoid_print
      print('Nope!');
    },
  ),
];

class SwipeView extends StatefulWidget {
  const SwipeView({
    Key? key,
  }) : super(key: key);

  @override
  State<SwipeView> createState() => _SwipeViewState();
}

class _SwipeViewState extends State<SwipeView> {
  final TCardController _controller = TCardController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text('Temp text above'),
        Center(
          child: TCard(
            size: const Size(370, 570),
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

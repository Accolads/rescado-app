import 'package:flutter/material.dart';
import 'package:rescado/config/constants.dart';

class AnimalDetailView extends StatefulWidget {
  static const id = 'AnimalDetailView';

  final List<String> images = const ['assets/photos/loebas.jpg', 'assets/photos/loebas.jpg'];

  const AnimalDetailView({Key? key}) : super(key: key);

  @override
  _AnimalDetailViewState createState() => _AnimalDetailViewState();
}

class _AnimalDetailViewState extends State<AnimalDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.icecream_outlined),
              onPressed: () {
                print('hello');
              },
            ),
            stretch: true,
            pinned: false,
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            flexibleSpace: Stack(
              clipBehavior: Clip.none,
              children: [
                const Positioned(
                    child: Hero(
                      tag: HeroConstants.animal,
                      child: Image(
                        image: NetworkImage('https://loremflickr.com/600/600/dog?1'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0),
                Positioned(
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(50),
                      ),
                    ),
                  ),
                  bottom: -1,
                  left: 0,
                  right: 0,
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  color: index.isOdd ? Colors.white : Colors.white,
                  height: 100.0,
                  child: Center(
                    child: Text('$index', textScaleFactor: 5),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}

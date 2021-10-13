import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List<String> images;
  final String heroTag;

  const ImageSlider({Key? key, required this.images, required this.heroTag}) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final PageController _controller = PageController();
  int _index = 0;

  void dotsTapped(double index) {
    _controller.animateToPage(index.toInt(), duration: const Duration(milliseconds: 400), curve: Curves.ease);
    setState(() => _index = index.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.images.length,
          onPageChanged: (int index) => setState(() => _index = index),
          itemBuilder: (_, i) {
            return Hero(
              tag: widget.heroTag,
              child: Material(
                type: MaterialType.transparency,
                child: Image(
                  image: NetworkImage(widget.images[i]),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: DotsIndicator(
            dotsCount: widget.images.length,
            position: _index.toDouble(),
            onTap: dotsTapped,
            decorator: DotsDecorator(
              color: Colors.white,
              size: const Size.square(10.0),
              spacing: const EdgeInsets.all(4.0),
              activeSize: const Size(16.0, 10.0),
              activeColor: const Color(0XFFFBD45C),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rescado/views/labels/page_title.dart';

// Wrapper around Scaffold that adds a nicely formatted title and makes the body scrollable if need be
class FullPage extends StatelessWidget {
  final String title;
  final Widget body;

  const FullPage({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Scrollbar(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              flexibleSpace:  PageTitle(label: title,),
            ),
             SliverToBoxAdapter(
              child: body,
            ),
          ],
        ),
      ),
    );
}

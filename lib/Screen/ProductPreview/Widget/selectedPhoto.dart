import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';

class SelectedPhoto extends StatelessWidget {
  final int? numberOfDots;
  final int? photoIndex;

  SelectedPhoto({this.numberOfDots, this.photoIndex});

  Widget _inactivePhoto(BuildContext context) {
    return Padding(
      padding:  EdgeInsetsDirectional.only(start: 3.0, end: 3.0),
      child: Container(
        height: 8.0,
        width: 8.0,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.fontColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(circularBorderRadius4),
        ),
      ),
    );
  }

  Widget _activePhoto(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 5.0, end: 5.0),
      child: Container(
        height: 10.0,
        width: 10.0,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.fontColor,
          borderRadius: BorderRadius.circular(circularBorderRadius5),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 0.0,
              blurRadius: 2.0,
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDots(context) {
    List<Widget> dots = [];
    for (int i = 0; i < numberOfDots!; i++) {
      dots.add(i == photoIndex ? _activePhoto(context) : _inactivePhoto(context));
    }
    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildDots(context),
      ),
    );
  }
}

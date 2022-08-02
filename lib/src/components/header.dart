import 'package:flutter/material.dart';
import 'package:todo/src/localization.dart';

class CustomHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: Delegate(),
    );
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  Delegate();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    ThemeData theme = Theme.of(context);
    AppLocalizations localizations = Localization.of(context);
    return Container(
      color: theme.primaryColor,
      height: 125,
      child: Stack(
        children: [
          Positioned(
            left: 60,
            top: 50,
            child: Text(
              localizations.my_tasks,
              style: theme.textTheme.headline1,
            ),
          ),
          Positioned(
            top: 70,
            right: 25,
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.visibility,
                  color: theme.secondaryHeaderColor,
                )),
          ),
          Positioned(
            top: 90,
            left: 60,
            child: Text(
              localizations.done,
              style: theme.textTheme.headline2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 125;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

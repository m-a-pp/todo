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
    final progress = shrinkOffset / maxExtent;
    ThemeData theme = Theme.of(context);
    AppLocalizations localizations = Localization.of(context);
    return Card(
      color: theme.primaryColor,
      elevation: progress * 4,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            padding: EdgeInsets.lerp(
              EdgeInsets.fromLTRB(60, 50, 0, 0),
              EdgeInsets.fromLTRB(16, 0, 0, 0),
              progress,
            ),
            alignment: Alignment.lerp(
              Alignment.topLeft,
              Alignment.centerLeft,
              progress,
            ),
            child: Text(
              localizations.my_tasks,
              style: TextStyle.lerp(theme.textTheme.headline1,
                  theme.textTheme.headline3, progress),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            padding: EdgeInsets.lerp(
              EdgeInsets.fromLTRB(0, 0, 20, 16),
              EdgeInsets.fromLTRB(0, 0, 20, 0),
              progress,
            ),
            alignment: Alignment.lerp(
              Alignment.bottomRight,
              Alignment.centerRight,
              progress,
            ),
            child: Icon(
              Icons.visibility,
              color: theme.secondaryHeaderColor,
            ),
          ),
          Positioned(
            top: 90,
            left: 60,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: 1 - progress,
              child: Text(
                localizations.done,
                style: theme.textTheme.headline2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 125;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

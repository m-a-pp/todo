import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/src/localization.dart';

import '../models/todo_model.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,

      delegate: Delegate(),
    );
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  Delegate();
  int done = 0;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    done = context.watch<ToDoListData>().doneCounter();
    final progress = shrinkOffset / maxExtent;
    ThemeData theme = Theme.of(context);
    AppLocalizations localizations = Localization.of(context);
    return Container(
      color: theme.primaryColor,
      child: Card(
        color: theme.primaryColor,
        elevation: progress * 4,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              padding: EdgeInsets.lerp(
                const EdgeInsets.fromLTRB(60, 50, 0, 0),
                const EdgeInsets.fromLTRB(16, 0, 0, 0),
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
                  const EdgeInsets.fromLTRB(0, 0, 25, 0),
                  const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  progress,
                ),
                alignment: Alignment.lerp(
                  Alignment.bottomRight,
                  Alignment.centerRight,
                  progress,
                ),
                child: IconButton(
                  onPressed: () {
                    context.read<ToDoListData>().changeVisibility();
                  },
                  icon: Icon(
                    context.watch<ToDoListData>().getVisibility
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: theme.secondaryHeaderColor,
                  ),
                )),
            Positioned(
              top: 90,
              left: 60,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: 1 - progress,
                child: Text(
                  '${localizations.done} $done',
                  style: theme.textTheme.headline2,
                ),
              ),
            ),
          ],
        ),
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

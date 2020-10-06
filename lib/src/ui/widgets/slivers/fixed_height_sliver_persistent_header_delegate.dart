import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class FixedHeightSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  FixedHeightSliverPersistentHeaderDelegate({
    @required this.child,
    @required this.height,
    this.rebuild,
  });

  FixedHeightSliverPersistentHeaderDelegate.snap(
      {@required this.child, @required this.height, @required TickerProvider tickerProvider}) {
    _vsync = tickerProvider;
    snapConfiguration = FloatingHeaderSnapConfiguration(
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 200),
    );
  }

  double height;

  Widget child;

  bool rebuild;

  TickerProvider _vsync;
  
  @override
  TickerProvider get vsync => _vsync;

  @override
  FloatingHeaderSnapConfiguration snapConfiguration;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return snapConfiguration != null ? _FloatingAppBar(child: child) : child;
  }

  @override
  bool shouldRebuild(FixedHeightSliverPersistentHeaderDelegate oldDelegate) {
    return rebuild ?? false;
  }
}

class _FloatingAppBar extends StatefulWidget {
  const _FloatingAppBar({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _FloatingAppBarState createState() => _FloatingAppBarState();
}

// A wrapper for the widget created by _SliverAppBarDelegate that starts and
// stops the floating app bar's snap-into-view or snap-out-of-view animation.
class _FloatingAppBarState extends State<_FloatingAppBar> {
  ScrollPosition _position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_position != null) {
      _position.isScrollingNotifier.removeListener(_isScrollingListener);
    }
    _position = Scrollable.of(context)?.position;
    if (_position != null) {
      _position.isScrollingNotifier.addListener(_isScrollingListener);
    }
  }

  @override
  void dispose() {
    if (_position != null) {
      _position.isScrollingNotifier.removeListener(_isScrollingListener);
    }
    super.dispose();
  }

  RenderSliverFloatingPersistentHeader _headerRenderer() {
    return context.findAncestorRenderObjectOfType<RenderSliverFloatingPersistentHeader>();
  }

  void _isScrollingListener() {
    if (_position == null) {
      return;
    }

    // When a scroll stops, then maybe snap the appbar into view.
    // Similarly, when a scroll starts, then maybe stop the snap animation.
    final RenderSliverFloatingPersistentHeader header = _headerRenderer();
    if (_position.isScrollingNotifier.value) {
      header?.maybeStopSnapAnimation(_position.userScrollDirection);
    } else {
      header?.maybeStartSnapAnimation(_position.userScrollDirection);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

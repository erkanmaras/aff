import 'package:aff/infrastructure.dart';
import 'package:aff/ui.dart';
import 'package:flutter/material.dart';
 
typedef LoadMoreCallback = Future<void> Function();

typedef LoadMoreBuilder = Widget Function(BuildContext context, LoadMoreStatus status);

enum LoadMoreStatus {
  normal,
  error,
  loading,
  completed,
}

class LoadMore extends StatefulWidget {
  LoadMore({
    @required this.status,
    @required this.child,
    @required this.onLoadMore,
    this.endLoadMore = true,
    this.bottomTriggerDistance = 100,
    this.loadMoreBuilder,
  });
  final LoadMoreStatus status;
  final LoadMoreCallback onLoadMore;
  final LoadMoreBuilder loadMoreBuilder;
  final CustomScrollView child;
  final bool endLoadMore;
  final double bottomTriggerDistance;
  final Key _lastItemKey = Key('¯\_(ツ)_/¯');
  @override
  State<StatefulWidget> createState() => _LoadMoreState();
}

class _LoadMoreState extends State<LoadMore> {
  AffLocalizer localizer;
  AppTheme appTheme;
  @override
  void didChangeDependencies() {
    localizer = context.getLocalizer();
    appTheme = context.getTheme();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    dynamic check = widget.child.slivers.elementAt(widget.child.slivers.length - 1);

    if (check is SliverSafeArea && check.key == widget._lastItemKey) {
      widget.child.slivers.removeLast();
    }

    widget.child.slivers.add(
      SliverSafeArea(
        key: widget._lastItemKey,
        top: false,
        left: false,
        right: false,
        sliver: SliverToBoxAdapter(
          child: _buildLoadMore(context, widget.status),
        ),
      ),
    );
    return NotificationListener<ScrollNotification>(
      onNotification: _handleNotification,
      child: widget.child,
    );
  }

  Widget _buildLoadMore(BuildContext context, LoadMoreStatus status) {
    if (widget.loadMoreBuilder != null) {
      Widget loadMoreBuilder = widget.loadMoreBuilder(context, status);
      if (loadMoreBuilder != null) {
        return loadMoreBuilder;
      }
    }

    if (status == LoadMoreStatus.loading) {
      return _buildLoading();
    } else if (status == LoadMoreStatus.error) {
      return _buildLoadError();
    } else if (status == LoadMoreStatus.completed) {
      return _buildLoadFinish();
    } else {
      return WidgetFactory.emptyWidget();
    }
  }

  Widget _buildLoading() {
    return Container(
      color: appTheme.colors.primary,
      height: kMinInteractiveDimension,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          WidgetFactory.circularProgressIndicator(size: 20, color: appTheme.colors.canvasLight, strokeWidth: 2),
          SizedBox(width: Space.m),
          Text(
            localizer.loadMoreLoading,
            style: appTheme.textStyles.subtitle.copyWith(color: appTheme.colors.fontLight),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadError() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (widget.onLoadMore != null) {
          widget.onLoadMore();
        }
      },
      child: Container(
        color: appTheme.colors.error,
        height: kMinInteractiveDimension,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              AppIcons.alertCircleOutline,
              color: appTheme.colors.fontLight,
              size: 20,
            ),
            SizedBox(width: Space.m),
            Text(
              localizer.loadMoreError,
              style: appTheme.textStyles.subtitle.copyWith(color: appTheme.colors.fontLight),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadFinish() {
    return Container(
      color: appTheme.colors.success,
      height: kMinInteractiveDimension,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            AppIcons.checkCircleOutline,
            color: appTheme.colors.fontLight,
            size: 20,
          ),
          SizedBox(width: Space.m),
          Text(
            localizer.loadMoreEnd,
            style: appTheme.textStyles.subtitle.copyWith(color: appTheme.colors.fontLight),
          ),
        ],
      ),
    );
  }

  bool _handleNotification(ScrollNotification notification) {
    double currentExtent = notification.metrics.pixels;
    double maxExtent = notification.metrics.maxScrollExtent;

    if (notification is ScrollUpdateNotification) {
      return _checkLoadMore(maxExtent - currentExtent <= widget.bottomTriggerDistance);
    }

    if (notification is ScrollEndNotification) {
      return _checkLoadMore(currentExtent >= maxExtent);
    }

    return false;
  }

  bool _checkLoadMore(bool canLoad) {
    if (canLoad && widget.status == LoadMoreStatus.normal && widget.onLoadMore != null) {
      widget.onLoadMore();
      return true;
    }
    return false;
  }
}

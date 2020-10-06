import 'package:flutter/material.dart';
import 'package:aff/ui.dart';
class GroupedListView<K, V> extends StatelessWidget {
  GroupedListView(
      {Key key,
      @required this.groupedData,
      @required this.headerBuilder,
      @required this.contentBuilder})
      : super(key: key);

  final Map<K, List<V>> groupedData;
  final Widget Function(BuildContext context, K value) headerBuilder;
  final Widget Function(BuildContext context, V value) contentBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: groupedData.keys.toList().length,
        itemBuilder: (context, indexHeader) {
          return ScrollableStickyHeader(
              header: _headerBuilder(
                  context, groupedData.keys.toList()[indexHeader]),
              content: ListView.separated(
                itemCount: groupedData.values.toList()[indexHeader].length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return _contentBuilder(
                      context, groupedData.values.toList()[indexHeader][index]);
                },
                separatorBuilder: (context, index) => Divider(),
              ));
        });
  }

  Widget _headerBuilder(BuildContext context, K value) {
    return headerBuilder(context, value);
  }

  Widget _contentBuilder(BuildContext context, V value) {
    return contentBuilder(context, value);
  }
}

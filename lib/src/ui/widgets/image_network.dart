import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:aff/ui.dart';
class ImageNetwork extends StatefulWidget {
  ImageNetwork({
    @required this.src,
    this.loadingBuilder,
    this.errorBuilder,
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
    this.height,
    this.width,
    this.color,
  });

  final String src;
  final Widget Function(BuildContext context) loadingBuilder;
  final Widget Function(BuildContext context, Object error) errorBuilder;
  final double width;
  final double height;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final Color color;

  @override
  _ImageNetworkState createState() => _ImageNetworkState();
}

class _ImageNetworkState extends State<ImageNetwork>
    with SingleTickerProviderStateMixin {
  //consolidateHttpClientResponseBytes function perform autoUncompress
  static final HttpClient _httpClient = HttpClient()..autoUncompress = false;

  Future<Uint8List> getImage() async {
    var uri = Uri.base.resolve(widget.src);
    var request = await _httpClient.getUrl(uri);
    var response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      throw NetworkImageLoadException(
          statusCode: response.statusCode, uri: uri);
    }
    return consolidateHttpClientResponseBytes(response);
  }

  Future<Uint8List> imageLoadFuture;
  AnimationController animationController;
  Animation<double> animation;
  @override
  void initState() {
    imageLoadFuture = getImage();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: imageLoadFuture,
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || !snapshot.hasData) {
            return buildError(context, snapshot.error);
          }
          animationController.forward();
          return FadeTransition(
            opacity: animation,
            child: Image.memory(
              snapshot.data,
              alignment: widget.alignment,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              color: widget.color,
            ),
          );
        }
        return buildLoading(context);
      },
    );
  }

  Widget buildError(BuildContext context, Object error) {
    if (widget.errorBuilder != null) {
      return widget.errorBuilder(context, error);
    }

    return Container(
      alignment: widget.alignment,
      width: widget.width,
      height: widget.height,
      child: Center(
          child: Icon(
        AppIcons.imageOffOutline,
        color: context.getTheme().colors.canvasDark,
      )),
    );
  }

  Widget buildLoading(BuildContext context) {
    if (widget.loadingBuilder != null) {
      return widget.loadingBuilder(context);
    }


    return Container(
      alignment: widget.alignment,
      width: widget.width,
      height: widget.height,
      child: Center(
          child: WidgetFactory.circularProgressIndicator(
              size: kMinInteractiveDimension / 2)),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ImageBody extends StatefulWidget {
  final String local_url;
  final String url;
  final createChild;

  ImageBody({@required this.local_url, @required this.url, @required this.createChild});

  @override
  _ImageBodyState createState() => _ImageBodyState();
}

class _ImageBodyState extends State<ImageBody> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller ??=
        AnimationController(duration: Duration(milliseconds: 1000), lowerBound: 0.0, upperBound: 1.0, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.local_url != null && widget.local_url.isNotEmpty) {
      return _loadImageFromLocal();
    } else {
      return _loadImageFromNetwork();
    }
  }

  _loadImageFromLocal() {
    return ExtendedImage.file(
      File(widget.local_url),
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            _controller.reset();
            break;
          case LoadState.completed:
            _controller.forward();
            return FadeTransition(opacity: _controller, child: widget.createChild(state.extendedImageInfo?.image));
            break;
          case LoadState.failed:
            _controller.reset();
            state.imageProvider.evict();
            _loadImageFromNetwork();
            break;
        }
        return _loadFailImage();
      },
    );
  }

  Widget _loadImageFromNetwork() {
    return ExtendedImage.network(
      widget.url,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            _controller.reset();
            break;
          case LoadState.completed:
            _controller.forward();
            return FadeTransition(opacity: _controller, child: widget.createChild(state.extendedImageInfo?.image));
            break;
          case LoadState.failed:
            _controller.reset();
            state.imageProvider.evict();
            return GestureDetector(
              child: _loadFailImage(),
              onTap: () => state.reLoadImage(),
            );
            break;
        }
        return Container();
      },
    );
  }

  Widget _loadFailImage() {
    return Container(
      color: Colors.grey.withOpacity(0.1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

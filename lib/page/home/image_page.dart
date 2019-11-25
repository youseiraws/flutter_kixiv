import 'dart:async';
import 'dart:ui' as ui show Image;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../entity/entity.dart';
import '../../util/util.dart';
import '../../widget/widget.dart';

class ImagePage extends StatefulWidget {
  List<Post> posts;
  num count;
  final int index;
  final load;

  ImagePage({@required this.posts, this.count = double.infinity, @required this.index, @required this.load});

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  PageController _pageController;
  StreamSubscription _subscription;
  int currentIndex;
  bool isNextPage = true;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    currentIndex = widget.index;
    _pageController ??= PageController(initialPage: currentIndex);
    _refreshHandler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              NoBehaviorView(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.posts.length,
                  itemBuilder: (context, index) {
                    if (widget.load != null && index == widget.posts.length - 1 && index != widget.count - 1) {
                      widget.load(isLoadInImagePage: true);
                      return LoadingIndicator();
                    } else {
                      return AutoScrollListView(children: <Widget>[
                        GestureDetector(
                          child: Card(
                            elevation: 2.0,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            child: ImageBody(
                                local_url: widget.posts[index].sample_local_url,
                                url: widget.posts[index].sample_url,
                                createChild: (ui.Image image) =>
                                    Stack(children: <Widget>[ExtendedRawImage(fit: BoxFit.fill, image: image)])),
                          ),
                          onDoubleTap: () {
                            Navigator.of(context).pop(_pageController.page);
                          },
                        )
                      ], onScrollEnd: isNextPage ? _pageSlideTimer : null);
                    }
                  },
                  onPageChanged: (int index) {
                    if (index > currentIndex) {
                      int nextIndex = index + 1;
                      if (nextIndex < widget.posts.length) {
                        ExtendedNetworkImageProvider(widget.posts[nextIndex].sample_url)
                            .resolve(createLocalImageConfiguration(context));
                      }
                      setState(() => isNextPage = true);
                    } else {
                      setState(() => isNextPage = false);
                    }
                    currentIndex = index;
                  },
                ),
              ),
              Positioned(
                top: 6.0,
                left: 6.0,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop(_pageController.page);
                  },
                ),
              )
            ],
          ),
        ),
        onWillPop: () {
          Navigator.of(context).pop(_pageController.page);
          return Future.value(false);
        });
  }

  _refreshHandler() {
    _subscription ??= bus.on<PostRefreshedEvent>().listen((PostRefreshedEvent event) {
      widget.posts = event.posts;
      widget.count = event.count;
      setState(() {});
    });
  }

  _pageSlideTimer() {
    Timer(Duration(milliseconds: 1500), () {
      if (_pageController.hasClients) {
        _pageController.nextPage(duration: Duration(milliseconds: 1000), curve: Curves.linear);
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _pageController.dispose();
    _subscription.cancel();
    super.dispose();
  }
}

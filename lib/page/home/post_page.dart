import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui show Image;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper/wallpaper.dart';

import '../../config/config.dart';
import '../../entity/entity.dart';
import '../../util/util.dart';
import '../../widget/widget.dart';
import '../page.dart';

class PostPage extends StatefulWidget {
  List<Post> posts;
  num count;
  final int id;
  final load;

  PostPage({@required this.posts, this.count = double.infinity, @required this.id, @required this.load});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  static const List<String> POST_PAGE_OPERATIONS = <String>['设为壁纸'];
  PageController _controller;
  StreamSubscription _subscription;
  int currentIndex;
  bool isLoading = false;

  @override
  void initState() {
    currentIndex = widget.posts.indexWhere((post) => post.id == widget.id);
    _controller ??= PageController(initialPage: currentIndex);
    _refreshHandler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          NoBehaviorView(
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.posts.length,
              itemBuilder: (context, index) {
                if (widget.load != null && index == widget.posts.length - 1 && index != widget.count - 1) {
                  widget.load(isLoadInImagePage: true);
                  return LoadingIndicator();
                } else {
                  return ListView(
                    shrinkWrap: true,
                    children: _pageBuilder(index),
                  );
                }
              },
              onPageChanged: (int index) {
                if (index > currentIndex) {
                  int nextIndex = index + 1;
                  if (nextIndex < widget.posts.length) {
                    ExtendedNetworkImageProvider(widget.posts[nextIndex].sample_url)
                        .resolve(createLocalImageConfiguration(context));
                  }
                }
                currentIndex = index;
              },
            ),
          ),
          Positioned(
            top: 24.0,
            child: BackButton(color: Colors.white),
          )
        ],
      ),
    );
  }

  List<Widget> _pageBuilder(int index) {
    Post post = widget.posts[index];
    return <Widget>[
      Card(
          elevation: 2.0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: post.sample_width / post.sample_height,
                    child: ImageBody(
                      local_url: post.sample_local_url,
                      url: post.sample_url,
                      createChild: (ui.Image image) => Stack(
                        children: <Widget>[
                          ExtendedRawImage(fit: BoxFit.fill, image: image),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8.0),
                                splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
                                highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                onDoubleTap: () async {
                                  dynamic result = await Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ImagePage(posts: widget.posts, index: index, load: widget.load),
                                  ));
                                  if (result != null && result is num) {
                                    _controller.jumpToPage(result.toInt());
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InfoRow(text: '评分', value: '${post.score}'),
                        InfoRow(text: '评级', value: '${ratingToString(post.rating)}'),
                        InfoRow(
                          text: '图片尺寸',
                          value: '${post.width} x ${post.height}',
                        ),
                        InfoRow(
                            text: '图片大小',
                            value: post.file_size / 1024 < 1024
                                ? '${(post.file_size / 1024).toStringAsFixed(2)} KB'
                                : '${(post.file_size / (1024 * 1024)).toStringAsFixed(2)} MB'),
                        InfoRow(text: '图片来源', value: _computeSource(post.source)),
                        InfoRow(text: '上传者', value: '${post.author}'),
                        InfoRow(
                          text: '上传时间',
                          value: DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(DateTime.fromMillisecondsSinceEpoch(post.created_at * 1000, isUtc: true)),
                        ),
                        Wrap(
                          spacing: 4.0,
                          children: post.tags.map((tag) {
                            return ActionChip(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                backgroundColor: tagTypeToColor(tag.type),
                                label: Text(tag.name),
                                onPressed: () => Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) => TagPage(tag: tag))));
                          }).toList(),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                top: 8.0,
                right: 8.0,
                child: PopupMenuButton(
                  child: Icon(Feather.getIconData('more-vertical'), color: Colors.white),
                  onSelected: (index) => _popupMenuHandler(index, post),
                  itemBuilder: (context) {
                    return POST_PAGE_OPERATIONS.map((String item) {
                      return PopupMenuItem<int>(
                        value: POST_PAGE_OPERATIONS.indexOf(item),
                        child: Text(item),
                      );
                    }).toList();
                  },
                ),
              )
            ],
          )),
    ];
  }

  String _computeSource(String source) {
    if (source.isNotEmpty) {
      Uri uri = Uri.tryParse(source);
      if (uri != null) {
        return uri.host;
      }
    }
    return '未知';
  }

  _refreshHandler() {
    _subscription ??= bus.on<PostRefreshedEvent>().listen((PostRefreshedEvent event) {
      widget.posts = event.posts;
      widget.count = event.count;
      setState(() {});
    });
  }

  _popupMenuHandler(int index, Post post) async {
    switch (index) {
      case 0:
        await _setWallpaper(post);
        break;
    }
  }

  Future<WallpaperType> _chooseWallpaperType() async {
    return await showDialog<WallpaperType>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('设为'),
            children: <Widget>[
              SimpleDialogOption(
                child: const Text('壁纸'),
                onPressed: () => Navigator.pop(context, WallpaperType.FLAG_SYSTEM),
              ),
              SimpleDialogOption(
                child: const Text('锁屏壁纸'),
                onPressed: () => Navigator.pop(context, WallpaperType.FLAG_LOCK),
              ),
              SimpleDialogOption(
                child: const Text('壁纸和锁屏壁纸'),
                onPressed: () => Navigator.pop(context, WallpaperType.BOTH),
              )
            ],
          );
        });
  }

  _setWallpaper(Post post) async {
    WallpaperType type = await _chooseWallpaperType();
    if (type == null) {
      return;
    }

    Wallpaper.ImageDownloadProgress(post.file_url).listen((_) {
      if (!isLoading) {
        showLoadingDialog(context, msg: '图片正在加载中...');
        isLoading = true;
      }
    }, onDone: () async {
      Navigator.pop(context);
      isLoading = false;

      String wallpaperPath = path.join((await getExternalStorageDirectory()).path, 'myimage.jpeg');
      File croppedFile = await ImageCropper.cropImage(
          aspectRatio: CropAspectRatio(ratioX: 9.0, ratioY: 16.0),
          sourcePath: wallpaperPath,
          androidUiSettings: AndroidUiSettings(
            toolbarTitle: '壁纸裁切',
            toolbarColor: PRIMARY_COLORS,
            toolbarWidgetColor: LABEL_COLOR,
            lockAspectRatio: true,
          ),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      croppedFile.copySync(wallpaperPath);

      switch (type) {
        case WallpaperType.FLAG_SYSTEM:
          Wallpaper.homeScreen();
          break;
        case WallpaperType.FLAG_LOCK:
          Wallpaper.lockScreen();
          break;
        case WallpaperType.BOTH:
          Wallpaper.bothScreen();
          break;
      }
      Fluttertoast.showToast(msg: WALLPAPER_SET);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _subscription.cancel();
    super.dispose();
  }
}

enum WallpaperType { FLAG_SYSTEM, FLAG_LOCK, BOTH }

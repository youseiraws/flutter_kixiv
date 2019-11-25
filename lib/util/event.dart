import 'package:event_bus/event_bus.dart';

import '../entity/entity.dart';
import '../model/model.dart';

EventBus bus = EventBus();

class LatestTabTappedEvent {}

class RandomTabTappedEvent {}

class PopularTabTaggedEvent {}

class CategoryTabTappedEvent {}

class TagTabTappedEvent {}

class PostRequestedEvent {
  List<Post> posts;

  PostRequestedEvent(this.posts);
}

class TagRequestedEvent {
  List<Tag> tags;

  TagRequestedEvent(this.tags);
}

class PostRefreshedEvent {
  List<Post> posts;
  num count;

  PostRefreshedEvent(this.posts, this.count);
}

class ConnectivityChangedEvent {
  ConnectivityStatus status;

  ConnectivityChangedEvent(this.status);
}

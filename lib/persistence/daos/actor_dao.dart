import 'package:hive/hive.dart';
import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/persistence/persistence_constants.dart';

class ActorDao {
  static final ActorDao _singleton = ActorDao._internal();

  factory ActorDao() => _singleton;

  ActorDao._internal();

  void saveAllActors(List<ActorVO> actorList) async {
    Map<int, ActorVO> actorMap = {
      for (var actor in actorList) actor.id ?? -1: actor
    };
    await getActorBox().putAll(actorMap);
  }

  List<ActorVO> getAllActors() {
    return getActorBox().values.toList();
  }

  /// reactive programming
  Stream<void> getAllEventsFromActorBox() {
    return getActorBox().watch();
  }

  Stream<List<ActorVO>> getAllActorsStream() {
    return Stream.value(getAllActors());
  }

  Box<ActorVO> getActorBox() {
    return Hive.box<ActorVO>(BOX_NAME_ACTOR_VO);
  }
}

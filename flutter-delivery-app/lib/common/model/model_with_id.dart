// 모든 모델은 id 값을 필수로 가지고 있어야 함

abstract class IModelWithId {
  final String id;

  IModelWithId({required this.id});
}

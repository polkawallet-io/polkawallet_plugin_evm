import 'package:get_storage/get_storage.dart';

class StoreCache {
  late GetStorage Function() storage;

  late ReadWriteValue<Map<dynamic, dynamic>> tokens;

  init(String container) {
    storage = () => GetStorage(container);
    tokens = {}.val('tokens', getBox: storage);
  }
}

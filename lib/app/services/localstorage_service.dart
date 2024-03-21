import 'package:dough_calculator/app/models/dough_config.dart';
import 'package:dough_calculator/app/services/notification_service.dart';
import 'package:localstorage/localstorage.dart';

class LocalStorageService {
  static final LocalStorage storage = LocalStorage('fdsaafeaesfa34w4aw3sf');
  static const String _doughKey = 'dough_key';
  static const String _poolishKey = 'poolish_key';
  static const String _fridgeKey = 'fridge_key';
  static const String _outFridgeKey = 'out_fridge_key';
  static const String _ballsKey = 'balls_key';

  static Future resetAll() async {
    await storage.ready;
    setDoughConfig(null);
    setPoolishMixedAt(null);
    setInFridgeAt(null);
    setOutOfFridgeAt(null);
    setBallsCreatedAt(null);
    NotificationService.removeAllNotifications();
  }

  // first stage
  static Future setDoughConfig(DoughConfig? doughConfig) async {
    await storage.ready;
    await storage.setItem(_doughKey, doughConfig?.toJson());
  }

  static Future<DoughConfig?> get dougConfig async {
    await storage.ready;
    var doughConfig = await storage.getItem(_doughKey);
    return doughConfig == null ? null : DoughConfig.fromJson(doughConfig);
  }

  // second stage
  static Future setPoolishMixedAt(DateTime? datetime) async {
    await storage.ready;
    await storage.setItem(_poolishKey, datetime?.toString());
  }

  static Future<DateTime?> get poolishMixedAt async {
    await storage.ready;
    var storedTime = await storage.getItem(_poolishKey);
    return storedTime == null ? null : DateTime.parse(storedTime);
  }

  // third stage
  static Future setInFridgeAt(DateTime? datetime) async {
    await storage.ready;
    await storage.setItem(_fridgeKey, datetime?.toString());
  }

  static Future<DateTime?> get inFridgeAt async {
    await storage.ready;
    var storedTime = await storage.getItem(_fridgeKey);
    return storedTime == null ? null : DateTime.parse(storedTime);
  }

  // fourth stage
  static Future setOutOfFridgeAt(DateTime? datetime) async {
    await storage.ready;
    await storage.setItem(_outFridgeKey, datetime?.toString());
  }

  static Future<DateTime?> get outOfFridgeAt async {
    await storage.ready;
    var storedTime = await storage.getItem(_outFridgeKey);
    return storedTime == null ? null : DateTime.parse(storedTime);
  }

  // fifth stage
  static Future setBallsCreatedAt(DateTime? datetime) async {
    await storage.ready;
    await storage.setItem(_ballsKey, datetime?.toString());
  }

  static Future<DateTime?> get ballsCreatedAt async {
    await storage.ready;
    var storedTime = await storage.getItem(_ballsKey);
    return storedTime == null ? null : DateTime.parse(storedTime);
  }
}

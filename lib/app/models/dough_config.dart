class DoughConfig {
  int? flour;
  int? water;
  int? salt;
  DateTime? readyAt;

  DoughConfig(this.flour, this.water, this.salt, this.readyAt);

  DoughConfig.fromJson(Map<String, dynamic> json) {
    flour = json['flour'];
    water = json['water'];
    salt = json['salt'];
    readyAt = DateTime.parse(json['readyAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flour'] = flour;
    data['water'] = water;
    data['salt'] = salt;
    data['readyAt'] = readyAt.toString();
    return data;
  }
}
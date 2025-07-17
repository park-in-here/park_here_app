class SearchLocModel {
    List<LocData>? data;

    SearchLocModel({
         this.data,
    });

    factory SearchLocModel.fromJson(Map<String, dynamic> json) => SearchLocModel(
        data: List<LocData>.from(json["data"].map((x) => LocData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class LocData {
    int? id;
    String? name;
    Location? location;

    LocData({
         this.id,
         this.name,
         this.location,
    });

    factory LocData.fromJson(Map<String, dynamic> json) => LocData(
        id: json["id"],
        name: json["name"],
        location: Location.fromJson(json["location"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location": location!.toJson(),
    };
}

class Location {
    double? latitude;
    double? longitude;

    Location({
         this.latitude,
         this.longitude,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
    };
}

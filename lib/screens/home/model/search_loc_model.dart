class SearchLocModel {
    List<LocDatas>? data;

    SearchLocModel({
         this.data,
    });

    factory SearchLocModel.fromJson(Map<String, dynamic> json) => SearchLocModel(
        data: List<LocDatas>.from(json["data"].map((x) => LocDatas.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class LocDatas {
    String? addressLine1;
    String? addressLine2;
    String? city;
    String? state;
    String? country;
    dynamic postalCode;
    double? latitude;
    double? longitude;

    LocDatas({
         this.addressLine1,
         this.addressLine2,
         this.city,
         this.state,
         this.country,
         this.postalCode,
         this.latitude,
         this.longitude,
    });

    factory LocDatas.fromJson(Map<String, dynamic> json) => LocDatas(
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        postalCode: json["postalCode"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "city": city,
        "state": state,
        "country": country,
        "postalCode": postalCode,
        "latitude": latitude,
        "longitude": longitude,
    };
}


class NearbyModel {
    List<NearbyLoc>? data;

    NearbyModel({
         this.data,
    });

    factory NearbyModel.fromJson(Map<String, dynamic> json) => NearbyModel(
        data: List<NearbyLoc>.from(json["data"].map((x) => NearbyLoc.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class NearbyLoc {
    String? id;
    String? name;
    LocationData? location;

    NearbyLoc({
         this.id,
         this.name,
         this.location,
    });

    factory NearbyLoc.fromJson(Map<String, dynamic> json) => NearbyLoc(
        id: json["id"],
        name: json["name"],
        location: LocationData.fromJson(json["location"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location": location!.toJson(),
    };
}

class LocationData {
    double? latitude;
    double? longitude;

    LocationData({
         this.latitude,
         this.longitude,
    });

    factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
    };
}

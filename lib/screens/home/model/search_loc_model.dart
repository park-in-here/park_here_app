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
  final List<NearbyLoc> data;
  final String? message;

  NearbyModel({
    required this.data,
    this.message,
  });

  factory NearbyModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return NearbyModel(
        data: [],
        message: null,
      );
    }

    // If API returned only message
    final rawData = json["data"];
    List<NearbyLoc> locations = [];

    if (rawData is List) {
      locations = rawData
          .map((x) => NearbyLoc.fromJson(x as Map<String, dynamic>?))
          .toList();
    }

    return NearbyModel(
      data: locations,
      message: json["message"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.map((x) => x.toJson()).toList(),
      };
}


class NearbyLoc {
  final String? id;
  final String? name;
  final LocationData? location;

  NearbyLoc({
    this.id,
    this.name,
    this.location,
  });

  factory NearbyLoc.fromJson(Map<String, dynamic>? json) {
    if (json == null) return NearbyLoc();

    return NearbyLoc(
      id: json["id"]?.toString(),
      name: json["name"]?.toString(),
      location: json["location"] != null
          ? LocationData.fromJson(json["location"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        if (location != null) "location": location!.toJson(),
      };
}


class LocationData {
  final double? latitude;
  final double? longitude;
  final String? address;

  LocationData({
    this.latitude,
    this.longitude,
    this.address,
  });

  factory LocationData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return LocationData();

    return LocationData(
      latitude: _toDouble(json["latitude"]),
      longitude: _toDouble(json["longitude"]),
      address: json["address"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
      };
}

/// safe double conversion
double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}


class SearchParkingModel {
    List<Parkings>? data;

    SearchParkingModel({
         this.data,
    });

    factory SearchParkingModel.fromJson(Map<String, dynamic> json) => SearchParkingModel(
        data: List<Parkings>.from(json["data"].map((x) => Parkings.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Parkings {
    String? id;
    String? name;
    int? availableSlots;
    int? pricePerHour;
    int? pricePerDay;
    ParkingLocation? location;

    Parkings({
         this.id,
         this.name,
         this.availableSlots,
         this.pricePerHour,
         this.pricePerDay,
         this.location,
    });

    factory Parkings.fromJson(Map<String, dynamic> json) => Parkings(
        id: json["id"],
        name: json["name"],
        availableSlots: json["availableSlots"],
        pricePerHour: json["pricePerHour"],
        pricePerDay: json["pricePerDay"],
        location: ParkingLocation.fromJson(json["location"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "availableSlots": availableSlots,
        "pricePerHour": pricePerHour,
        "pricePerDay": pricePerDay,
        "location": location!.toJson(),
    };
}

class ParkingLocation {
    String? addressLine1;
    String? addressLine2;
    String? city;
    String? state;
    String? country;
    dynamic postalCode;
    double? latitude;
    double? longitude;

    ParkingLocation({
         this.addressLine1,
         this.addressLine2,
         this.city,
         this.state,
         this.country,
         this.postalCode,
         this.latitude,
         this.longitude,
    });

    factory ParkingLocation.fromJson(Map<String, dynamic> json) => ParkingLocation(
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
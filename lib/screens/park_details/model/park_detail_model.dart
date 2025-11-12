class ParkDetailModel {
    List<ParkDetail>? data;

    ParkDetailModel({
         this.data,
    });

    factory ParkDetailModel.fromJson(Map<String, dynamic> json) => ParkDetailModel(
        data: List<ParkDetail>.from(json["data"].map((x) => ParkDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class ParkDetail {
    String? uuid;
    String? name;
    dynamic description;
    double? latitude;
    double? longitude;
    String? addressLine1;
    String? addressLine2;
    String? city;
    String? state;
    String? country;
    dynamic postalCode;
    bool? isVerified;
    int? totalSlots;
    List<String>? availableDays;
    List<String>? features;
    int? pricePerHour;
    int? pricePerDay;
    String? createdBy;
    String? updatedBy;
    DateTime? createdAt;
    DateTime? updatedAt;
    List<Attachment>? attachments;

    ParkDetail({
         this.uuid,
         this.name,
         this.description,
         this.latitude,
         this.longitude,
         this.addressLine1,
         this.addressLine2,
         this.city,
         this.state,
         this.country,
         this.postalCode,
         this.isVerified,
         this.totalSlots,
         this.availableDays,
         this.features,
         this.pricePerHour,
         this.pricePerDay,
         this.createdBy,
         this.updatedBy,
         this.createdAt,
         this.updatedAt,
         this.attachments,
    });

    factory ParkDetail.fromJson(Map<String, dynamic> json) => ParkDetail(
        uuid: json["uuid"],
        name: json["name"],
        description: json["description"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        postalCode: json["postalCode"],
        isVerified: json["isVerified"],
        totalSlots: json["totalSlots"],
        availableDays: List<String>.from(json["availableDays"].map((x) => x)),
        features: List<String>.from(json["features"].map((x) => x)),
        pricePerHour: json["pricePerHour"],
        pricePerDay: json["pricePerDay"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        attachments: List<Attachment>.from(json["attachments"].map((x) => Attachment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
        "description": description,
        "latitude": latitude,
        "longitude": longitude,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "city": city,
        "state": state,
        "country": country,
        "postalCode": postalCode,
        "isVerified": isVerified,
        "totalSlots": totalSlots,
        "availableDays": List<dynamic>.from(availableDays!.map((x) => x)),
        "features": List<dynamic>.from(features!.map((x) => x)),
        "pricePerHour": pricePerHour,
        "pricePerDay": pricePerDay,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "attachments": List<dynamic>.from(attachments!.map((x) => x.toJson())),
    };
}

class Attachment {
    String? uuid;
    String? slotUuid;
    String? documentType;
    String? filePath;
    String? fileType;
    DateTime? createdAt;
    DateTime? updatedAt;

    Attachment({
         this.uuid,
         this.slotUuid,
         this.documentType,
         this.filePath,
         this.fileType,
         this.createdAt,
         this.updatedAt,
    });

    factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        uuid: json["uuid"],
        slotUuid: json["slotUuid"],
        documentType: json["documentType"],
        filePath: json["filePath"],
        fileType: json["fileType"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "slotUuid": slotUuid,
        "documentType": documentType,
        "filePath": filePath,
        "fileType": fileType,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
    };
}
class ModelUser {
  final String? address;
  final String applicationId;
  final String? avatarUrl;
  final String? birthdate;
  final String? company;
  // final String? contractSigningDate;
  final Country? country;
  final String? countryCode;
  final String? currency;
  // final String? currentTotalLeaveDay;
  final String? designation;
  final String email;
  // final String? fullTextAddress;
  final String? gtsNumber;
  final String id;
  final String? identificationNumber;
  final bool isLockedOut;
  final String language;
  final String lastActivityDate;
  // final String lastPayment;
  final int level;
  final String localTime;
  final Location? location;
  final String? locationCode;
  final String? locationString;
  final String name;
  // final String partner;
  final String? phoneNumber;
  final String? recentPaymentString;
  final String? timeZone;
  final int type;
  final String? userName;

  ModelUser({
    this.address,
    required this.applicationId,
    this.avatarUrl,
    this.birthdate,
    this.company,
    this.country,
    this.countryCode,
    this.currency,
    this.designation,
    required this.email,
    this.gtsNumber,
    required this.id,
    this.identificationNumber,
    required this.isLockedOut,
    required this.language,
    required this.lastActivityDate,
    required this.level,
    required this.localTime,
    this.location,
    this.locationCode,
    this.locationString,
    required this.name,
    this.phoneNumber,
    this.recentPaymentString,
    this.timeZone,
    required this.type,
    this.userName,
  });

  ModelUser.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        userName = json['userName'] as String?,
        name = json['name'] as String,
        email = json['email'] as String,
        avatarUrl = json['avatarUrl'] as String?,
        phoneNumber = json['phoneNumber'] as String?,
        address = json['address'] as String?,
        company = json['company'] as String?,
        designation = json['designation'] as String?,
        gtsNumber = json['gtsNumber'] as String?,
        identificationNumber = json['identificationNumber'] as String?,
        countryCode = json['countryCode'] as String?,
        country = (json['country'] as Map<String, dynamic>?) != null
            ? Country.fromJson(json['country'] as Map<String, dynamic>)
            : Country.fromJson({}),
        locationString = json['locationString'] as String?,
        localTime = json['localTime'] as String,
        locationCode = json['locationCode'] as String?,
        location = (json['location'] as Map<String, dynamic>?) != null
            ? Location.fromJson(json['location'] as Map<String, dynamic>)
            : null,
        timeZone = json['timeZone'] as String?,
        currency = json['currency'] as String?,
        language = json['language'] as String,
        type = json['type'] as int,
        recentPaymentString = json['recentPaymentString'] as String?,
        birthdate = json['birthdate'] as String?,
        lastActivityDate = json['lastActivityDate'] as String,
        applicationId = json['applicationId'] as String,
        level = json['level'] as int,
        isLockedOut = json['isLockedOut'] as bool;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
        'phoneNumber': phoneNumber,
        'address': address,
        'company': company,
        'designation': designation,
        'gtsNumber': gtsNumber,
        'identificationNumber': identificationNumber,
        'countryCode': countryCode,
        'country': country?.toJson(),
        'locationString': locationString,
        'locationCode': locationCode,
        'location': location?.toJson(),
        'timeZone': timeZone,
        'currency': currency,
        'language': language,
        'type': type,
        'recentPaymentString': recentPaymentString,
        'birthdate': birthdate,
        'lastActivityDate': lastActivityDate,
        'applicationId': applicationId,
        'level': level,
        'isLockedOut': isLockedOut,
        'localTime': localTime,
      };
}

class PreferredIndustryList {
  final String? title;
  final String? code;

  PreferredIndustryList({
    this.title,
    this.code,
  });

  PreferredIndustryList.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String?,
        code = json['code'] as String?;

  Map<String, dynamic> toJson() => {'title': title, 'code': code};
}

class Country {
  final String? name;
  final String? iso2;
  final String? currency;
  final String? phoneCode;
  final String? locationId;
  final String? flagUrl;
  final int? latitude;
  final int? longitude;

  Country({
    this.name,
    this.iso2,
    this.currency,
    this.phoneCode,
    this.locationId,
    this.flagUrl,
    this.latitude,
    this.longitude,
  });

  Country.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        iso2 = json['iso2'] as String?,
        currency = json['currency'] as String?,
        phoneCode = json['phoneCode'] as String?,
        locationId = json['locationId'] as String?,
        flagUrl = json['flagUrl'] as String?,
        latitude = json['latitude'] as int?,
        longitude = json['longitude'] as int?;

  Map<String, dynamic> toJson() => {
        'name': name,
        'iso2': iso2,
        'currency': currency,
        'phoneCode': phoneCode,
        'locationId': locationId,
        'flagUrl': flagUrl,
        'latitude': latitude,
        'longitude': longitude
      };
}

class Location {
  final String? name;
  final String? code;
  final String? type;
  final Country? country;

  Location({
    this.name,
    this.code,
    this.type,
    this.country,
  });

  Location.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        code = json['code'] as String?,
        type = json['type'] as String?,
        country = (json['country'] as Map<String, dynamic>?) != null
            ? Country.fromJson(json['country'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {'name': name, 'code': code, 'type': type, 'country': country?.toJson()};
}

class PreferredLocationList {
  final String? name;
  final String? code;
  final String? type;
  final Country? country;

  PreferredLocationList({
    this.name,
    this.code,
    this.type,
    this.country,
  });

  PreferredLocationList.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        code = json['code'] as String?,
        type = json['type'] as String?,
        country = (json['country'] as Map<String, dynamic>?) != null
            ? Country.fromJson(json['country'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {'name': name, 'code': code, 'type': type, 'country': country?.toJson()};
}

class ListRole {
  final String? id;
  final String? code;
  final String? name;
  final bool? isSystem;
  final int? level;

  ListRole({
    this.id,
    this.code,
    this.name,
    this.isSystem,
    this.level,
  });

  ListRole.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        code = json['code'] as String?,
        name = json['name'] as String?,
        isSystem = json['isSystem'] as bool?,
        level = json['level'] as int?;

  Map<String, dynamic> toJson() => {'id': id, 'code': code, 'name': name, 'isSystem': isSystem, 'level': level};
}

class AppSettings {
  final List<String>? reloadOrderListAfterOrderActions;
  final List<String>? reloadMenuAfterOrderActions;
  final String? productListStyle;

  AppSettings({
    this.reloadOrderListAfterOrderActions,
    this.reloadMenuAfterOrderActions,
    this.productListStyle,
  });

  AppSettings.fromJson(Map<String, dynamic> json)
      : reloadOrderListAfterOrderActions =
            (json['reloadOrderListAfterOrderActions'] as List?)?.map((dynamic e) => e as String).toList(),
        reloadMenuAfterOrderActions =
            (json['reloadMenuAfterOrderActions'] as List?)?.map((dynamic e) => e as String).toList(),
        productListStyle = json['productListStyle'] as String?;

  Map<String, dynamic> toJson() => {
        'reloadOrderListAfterOrderActions': reloadOrderListAfterOrderActions,
        'reloadMenuAfterOrderActions': reloadMenuAfterOrderActions,
        'productListStyle': productListStyle
      };
}

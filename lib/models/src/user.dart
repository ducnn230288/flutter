class MUser {
  MUser({
    List<MRole>? listRole,
    MRole? role,
    num? totalClinic,
    num? totalOrder,
    // MProfileFarmer? profileFarmer,
    String? id,
    String? userName,
    String? name,
    String? phoneNumber,
    String? countryCode,
    String? gender,
    String? genderString,
    String? email,
    String? avatarUrl,
    String? bankAccountNo,
    String? bankName,
    String? bankUsername,
    String? birthdate,
    String? lastActivityDate,
    bool? isLockedOut,
    bool? isActive,
    String? activeDate,
    num? level,
    String? facebookUserId,
    String? googleUserId,
    String? emailVerifyToken,
    bool? isEmailVerified,
    List<String>? roleListCode,
    String? profileType,
    String? createdOnDate,
  }) {
    _listRole = listRole;
    _role = role;
    _id = id;
    _totalClinic = totalClinic;
    _totalOrder = totalOrder;
    // _profileFarmer = profileFarmer;
    _userName = userName;
    _name = name;
    _phoneNumber = phoneNumber;
    _countryCode = countryCode;
    _gender = gender;
    _genderString = genderString;
    _email = email;
    _avatarUrl = avatarUrl;
    _bankAccountNo = bankAccountNo;
    _bankName = bankName;
    _bankUsername = bankUsername;
    _birthdate = birthdate;
    _lastActivityDate = lastActivityDate;
    _isLockedOut = isLockedOut;
    _isActive = isActive;
    _activeDate = activeDate;
    _level = level;
    _facebookUserId = facebookUserId;
    _googleUserId = googleUserId;
    _emailVerifyToken = emailVerifyToken;
    _isEmailVerified = isEmailVerified;
    _roleListCode = roleListCode;
    _profileType = profileType;
    _createdOnDate = createdOnDate;
  }

  MUser.fromJson(dynamic json) {
    if (json['listRole'] != null) {
      _listRole = [];
      json['listRole'].forEach((v) {
        _listRole?.add(MRole.fromJson(v));
      });
    }
    _role = json['role'] != null ? MRole.fromJson(json['role']) : null;
    _id = json['id'];
    _totalClinic = json['totalClinic'];
    _totalOrder = json['totalOrder'];
    // _profileFarmer = json['profileFarmer'] != null ? MProfileFarmer.fromJson(json['profileFarmer']) : null;
    _userName = json['userName'];
    _name = json['name'];
    _phoneNumber = json['phoneNumber'];
    _countryCode = json['countryCode'];
    _gender = json['gender'];
    _genderString = json['genderString'];
    _email = json['email'];
    _avatarUrl = json['avatarUrl'];
    _bankAccountNo = json['bankAccountNo'];
    _bankName = json['bankName'];
    _bankUsername = json['bankUsername'];
    _birthdate = json['birthdate'];
    _lastActivityDate = json['lastActivityDate'];
    _isLockedOut = json['isLockedOut'];
    _isActive = json['isActive'];
    _activeDate = json['activeDate'];
    _level = json['level'];
    _facebookUserId = json['facebookUserId'];
    _googleUserId = json['googleUserId'];
    _emailVerifyToken = json['emailVerifyToken'];
    _isEmailVerified = json['isEmailVerified'];
    _roleListCode = json['roleListCode'] != null ? json['roleListCode'].cast<String>() : [];
    _profileType = json['profileType'];
    _createdOnDate = json['createdOnDate'];
  }

  List<MRole>? _listRole;
  MRole? _role;
  num? _totalClinic;
  num? _totalOrder;

  // MProfileFarmer? _profileFarmer;
  String? _id;
  String? _userName;
  String? _name;
  String? _phoneNumber;
  String? _countryCode;
  String? _gender;
  String? _genderString;
  String? _email;
  String? _avatarUrl;
  String? _bankAccountNo;
  String? _bankName;
  String? _bankUsername;
  String? _birthdate;
  String? _lastActivityDate;
  bool? _isLockedOut;
  bool? _isActive;
  String? _activeDate;
  num? _level;
  String? _facebookUserId;
  String? _googleUserId;
  String? _emailVerifyToken;
  bool? _isEmailVerified;
  List<String>? _roleListCode;
  String? _profileType;
  String? _createdOnDate;

  MUser copyWith({
    List<MRole>? listRole,
    MRole? role,
    num? totalClinic,
    num? totalOrder,
    // MProfileFarmer? profileFarmer,
    String? id,
    String? userName,
    String? name,
    String? phoneNumber,
    String? countryCode,
    String? gender,
    String? genderString,
    String? email,
    String? avatarUrl,
    String? bankAccountNo,
    String? bankName,
    String? bankUsername,
    String? birthdate,
    String? lastActivityDate,
    bool? isLockedOut,
    bool? isActive,
    String? activeDate,
    num? level,
    String? facebookUserId,
    String? googleUserId,
    String? emailVerifyToken,
    bool? isEmailVerified,
    List<String>? roleListCode,
    String? profileType,
    String? createdOnDate,
  }) =>
      MUser(
        listRole: listRole ?? _listRole,
        role: role ?? _role,
        id: id ?? _id,
        totalClinic: totalClinic ?? _totalClinic,
        totalOrder: totalOrder ?? _totalOrder,
        // profileFarmer: profileFarmer ?? _profileFarmer,
        userName: userName ?? _userName,
        name: name ?? _name,
        phoneNumber: phoneNumber ?? _phoneNumber,
        countryCode: countryCode ?? _countryCode,
        gender: gender ?? _gender,
        genderString: genderString ?? _genderString,
        email: email ?? _email,
        avatarUrl: avatarUrl ?? _avatarUrl,
        bankAccountNo: bankAccountNo ?? _bankAccountNo,
        bankName: bankName ?? _bankName,
        bankUsername: bankUsername ?? _bankUsername,
        birthdate: birthdate ?? _birthdate,
        lastActivityDate: lastActivityDate ?? _lastActivityDate,
        isLockedOut: isLockedOut ?? _isLockedOut,
        isActive: isActive ?? _isActive,
        activeDate: activeDate ?? _activeDate,
        level: level ?? _level,
        facebookUserId: facebookUserId ?? _facebookUserId,
        googleUserId: googleUserId ?? _googleUserId,
        emailVerifyToken: emailVerifyToken ?? _emailVerifyToken,
        isEmailVerified: isEmailVerified ?? _isEmailVerified,
        roleListCode: roleListCode ?? _roleListCode,
        profileType: profileType ?? _profileType,
        createdOnDate: createdOnDate ?? _createdOnDate,
      );

  List<MRole> get listRole => _listRole ?? [];

  MRole get role => _role ?? MRole();

  num get totalClinic => _totalClinic ?? 0;

  num get totalOrder => _totalOrder ?? 0;

  // MProfileFarmer get profileFarmer => _profileFarmer ?? MProfileFarmer();
  String get id => _id ?? '';

  String get userName => _userName ?? '';

  String get name => _name ?? '';

  String get phoneNumber => _phoneNumber ?? '';

  String get countryCode => _countryCode ?? '';

  String get gender => _gender ?? '';

  String get genderString => _genderString ?? '';

  String get email => _email ?? '';

  String get avatarUrl => _avatarUrl ?? '';

  String get bankAccountNo => _bankAccountNo ?? '';

  String get bankName => _bankName ?? '';

  String get bankUsername => _bankUsername ?? '';

  String get birthdate => _birthdate ?? '';

  String get lastActivityDate => _lastActivityDate ?? '';

  bool get isLockedOut => _isLockedOut ?? false;

  bool get isActive => _isActive ?? false;

  String get activeDate => _activeDate ?? '';

  num get level => _level ?? 0;

  String get facebookUserId => _facebookUserId ?? '';

  String get googleUserId => _googleUserId ?? '';

  String get emailVerifyToken => _emailVerifyToken ?? '';

  bool get isEmailVerified => _isEmailVerified ?? false;

  List<String> get roleListCode => _roleListCode ?? [];

  String get profileType => _profileType ?? '';

  String get createdOnDate => _createdOnDate ?? '';

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_listRole != null) {
      map['listRole'] = _listRole?.map((v) => v.toJson()).toList();
    }
    if (_role != null) {
      map['role'] = _role?.toJson();
    }
    map['totalClinic'] = _totalClinic;
    map['totalOrder'] = _totalOrder;
    // if (_profileFarmer != null) {
    //   map['profileFarmer'] = _profileFarmer?.toJson();
    // }
    map['id'] = _id;
    map['userName'] = _userName;
    map['name'] = _name;
    map['phoneNumber'] = _phoneNumber;
    map['countryCode'] = _countryCode;
    map['gender'] = _gender;
    map['genderString'] = _genderString;
    map['email'] = _email;
    map['avatarUrl'] = _avatarUrl;
    map['bankAccountNo'] = _bankAccountNo;
    map['bankName'] = _bankName;
    map['bankUsername'] = _bankUsername;
    map['birthdate'] = _birthdate;
    map['lastActivityDate'] = _lastActivityDate;
    map['isLockedOut'] = _isLockedOut;
    map['isActive'] = _isActive;
    map['activeDate'] = _activeDate;
    map['level'] = _level;
    map['facebookUserId'] = _facebookUserId;
    map['googleUserId'] = _googleUserId;
    map['emailVerifyToken'] = _emailVerifyToken;
    map['isEmailVerified'] = _isEmailVerified;
    map['roleListCode'] = _roleListCode;
    map['profileType'] = _profileType;
    map['createdOnDate'] = _createdOnDate;
    return map;
  }
}

class MRole {
  MRole({
    String? id,
    String? code,
    String? name,
    bool? isSystem,
    num? level,
  }) {
    _id = id;
    _code = code;
    _name = name;
    _isSystem = isSystem;
    _level = level;
  }

  MRole.fromJson(dynamic json) {
    _id = json['id'];
    _code = json['code'];
    _name = json['name'];
    _isSystem = json['isSystem'];
    _level = json['level'];
  }

  String? _id;
  String? _code;
  String? _name;
  bool? _isSystem;
  num? _level;

  MRole copyWith({
    String? id,
    String? code,
    String? name,
    bool? isSystem,
    num? level,
  }) =>
      MRole(
        id: id ?? _id,
        code: code ?? _code,
        name: name ?? _name,
        isSystem: isSystem ?? _isSystem,
        level: level ?? _level,
      );

  String get id => _id ?? '';

  String get code => _code ?? '';

  String get name => _name ?? '';

  bool get isSystem => _isSystem ?? false;

  num get level => _level ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['name'] = _name;
    map['isSystem'] = _isSystem;
    map['level'] = _level;
    return map;
  }
}

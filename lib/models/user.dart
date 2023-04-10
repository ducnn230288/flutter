class MUser {
  MUser({
    String? id,
    String? userName,
    String? name,
    String? phoneNumber,
    String? countryCode,
    String? gender,
    String? email,
    String? avatarUrl,
    String? birthdate,
    String? lastActivityDate,
    bool? isLockedOut,
    bool? isActive,
    String? activeDate,
    num? level,
    String? facebookUserId,
    String? googleUserId,
    String? emailVerifyToken,
    List<String>? roleListCode,
    String? profileType,
    String? bankUsername,
    String? bankName,
    String? bankAccountNo,
  }){
    _id = id;
    _userName = userName;
    _name = name;
    _phoneNumber = phoneNumber;
    _countryCode = countryCode;
    _gender = gender;
    _email = email;
    _avatarUrl = avatarUrl;
    _birthdate = birthdate;
    _lastActivityDate = lastActivityDate;
    _isLockedOut = isLockedOut;
    _isActive = isActive;
    _activeDate = activeDate;
    _level = level;
    _facebookUserId = facebookUserId;
    _googleUserId = googleUserId;
    _emailVerifyToken = emailVerifyToken;
    _roleListCode = roleListCode;
    _profileType = profileType;
    _bankUsername = bankUsername;
    _bankName = bankName;
    _bankAccountNo = bankAccountNo;
  }

  MUser.fromJson(dynamic json) {
    _id = json['id'];
    _userName = json['userName'];
    _name = json['name'];
    _phoneNumber = json['phoneNumber'];
    _countryCode = json['countryCode'];
    _gender = json['gender'];
    _email = json['email'];
    _avatarUrl = json['avatarUrl'];
    _birthdate = json['birthdate'];
    _lastActivityDate = json['lastActivityDate'];
    _isLockedOut = json['isLockedOut'];
    _isActive = json['isActive'];
    _activeDate = json['activeDate'];
    _level = json['level'];
    _facebookUserId = json['facebookUserId'];
    _googleUserId = json['googleUserId'];
    _emailVerifyToken = json['emailVerifyToken'];
    _roleListCode = json['roleListCode'] != null ? json['roleListCode'].cast<String>() : [];
    _profileType = json['profileType'];
    _bankUsername = json['bankUsername'] ?? '';
    _bankName = json['bankName'] ?? '';
    _bankAccountNo = json['bankAccountNo'] ?? '';
  }
  String? _id;
  String? _userName;
  String? _name;
  String? _phoneNumber;
  String? _countryCode;
  String? _gender;
  String? _email;
  String? _avatarUrl;
  String? _birthdate;
  String? _lastActivityDate;
  bool? _isLockedOut;
  bool? _isActive;
  String? _activeDate;
  num? _level;
  String? _facebookUserId;
  String? _googleUserId;
  String? _emailVerifyToken;
  List<String>? _roleListCode;
  String? _profileType;
  String? _bankUsername;
  String? _bankName;
  String? _bankAccountNo;
  MUser copyWith({  String? id,
    String? userName,
    String? name,
    String? phoneNumber,
    String? countryCode,
    String? gender,
    String? email,
    String? avatarUrl,
    String? birthdate,
    String? lastActivityDate,
    bool? isLockedOut,
    bool? isActive,
    String? activeDate,
    num? level,
    String? facebookUserId,
    String? googleUserId,
    String? emailVerifyToken,
    List<String>? roleListCode,
    String? profileType,
    String? bankUsername,
    String? bankName,
    String? bankAccountNo,
  }) => MUser(  id: id ?? _id,
    userName: userName ?? _userName,
    name: name ?? _name,
    phoneNumber: phoneNumber ?? _phoneNumber,
    countryCode: countryCode ?? _countryCode,
    gender: gender ?? _gender,
    email: email ?? _email,
    avatarUrl: avatarUrl ?? _avatarUrl,
    birthdate: birthdate ?? _birthdate,
    lastActivityDate: lastActivityDate ?? _lastActivityDate,
    isLockedOut: isLockedOut ?? _isLockedOut,
    isActive: isActive ?? _isActive,
    activeDate: activeDate ?? _activeDate,
    level: level ?? _level,
    facebookUserId: facebookUserId ?? _facebookUserId,
    googleUserId: googleUserId ?? _googleUserId,
    emailVerifyToken: emailVerifyToken ?? _emailVerifyToken,
    roleListCode: roleListCode ?? _roleListCode,
    profileType: profileType ?? _profileType,
    bankUsername: googleUserId ?? _bankUsername,
    bankName: bankName ?? _bankName,
    bankAccountNo: bankAccountNo ?? _bankAccountNo,
  );
  String? get id => _id;
  String? get userName => _userName;
  String? get name => _name;
  String? get phoneNumber => _phoneNumber;
  String? get countryCode => _countryCode;
  String? get gender => _gender;
  String? get email => _email;
  String? get avatarUrl => _avatarUrl;
  String? get birthdate => _birthdate;
  String? get lastActivityDate => _lastActivityDate;
  bool? get isLockedOut => _isLockedOut;
  bool? get isActive => _isActive;
  String? get activeDate => _activeDate;
  num? get level => _level;
  String? get facebookUserId => _facebookUserId;
  String? get googleUserId => _googleUserId;
  String? get emailVerifyToken => _emailVerifyToken;
  List<String>? get roleListCode => _roleListCode;
  String? get profileType => _profileType ?? '';
  String? get bankName => _bankName ?? '';
  String? get bankAccountNo => _bankAccountNo ?? '';
  String? get bankUsername => _bankUsername ?? '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userName'] = _userName;
    map['name'] = _name;
    map['phoneNumber'] = _phoneNumber;
    map['countryCode'] = _countryCode;
    map['gender'] = _gender;
    map['email'] = _email;
    map['avatarUrl'] = _avatarUrl;
    map['birthdate'] = _birthdate;
    map['lastActivityDate'] = _lastActivityDate;
    map['isLockedOut'] = _isLockedOut;
    map['isActive'] = _isActive;
    map['activeDate'] = _activeDate;
    map['level'] = _level;
    map['facebookUserId'] = _facebookUserId;
    map['googleUserId'] = _googleUserId;
    map['emailVerifyToken'] = _emailVerifyToken;
    map['roleListCode'] = _roleListCode;
    map['profileType'] = _profileType;
    map['bankName'] = bankName;
    map['bankAccountNo'] = bankAccountNo;
    map['bankAccountNo'] = bankAccountNo;
    return map;
  }
}

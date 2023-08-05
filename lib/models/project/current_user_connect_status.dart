class CurrentUserConnectStatus {
  CurrentUserConnectStatus({
    bool? isOwner,
    bool? isConnectAvailable,
    bool? isConnected,
    List<String>? allowedActions,
    bool? isDistributed,
    bool? isClaims,
  }) {
    _isOwner = isOwner;
    _isConnectAvailable = isConnectAvailable;
    _isConnected = isConnected;
    _allowedActions = allowedActions;
    _isDistributed = isDistributed;
    _isClaims = isClaims;
  }

  CurrentUserConnectStatus.fromJson(dynamic json) {
    _isOwner = json['isOwner'];
    _isConnectAvailable = json['isConnectAvailable'];
    _isConnected = json['isConnected'];
    _isDistributed = json['isDistributed'];
    _isClaims = json['isClaims'];
    _allowedActions = json['allowedActions'] != null ? json['allowedActions'].cast<String>() : [];
  }

  bool? _isOwner;
  bool? _isConnectAvailable;
  bool? _isConnected;
  bool? _isDistributed;
  bool? _isClaims;
  List<String>? _allowedActions;

  CurrentUserConnectStatus copyWith({
    bool? isOwner,
    bool? isConnectAvailable,
    bool? isConnected,
    bool? isDistributed,
    bool? isClaims,
    List<String>? allowedActions,
  }) =>
      CurrentUserConnectStatus(
        isOwner: isOwner ?? _isOwner,
        isConnectAvailable: isConnectAvailable ?? _isConnectAvailable,
        isConnected: isConnected ?? _isConnected,
        isDistributed: isConnected ?? _isDistributed,
        isClaims: isClaims ?? _isClaims,
        allowedActions: allowedActions ?? _allowedActions,
      );

  bool get isOwner => _isOwner ?? false;

  bool get isConnectAvailable => _isConnectAvailable ?? false;

  bool get isConnected => _isConnected ?? false;

  bool get isDistributed => _isDistributed ?? false;

  bool get isClaims => _isClaims ?? false;

  List<String> get allowedActions => _allowedActions ?? [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isOwner'] = _isOwner;
    map['isConnectAvailable'] = _isConnectAvailable;
    map['isConnected'] = _isConnected;
    map['isDistributed'] = _isDistributed;
    map['allowedActions'] = _allowedActions;
    return map;
  }
}

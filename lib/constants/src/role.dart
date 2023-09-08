import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/cubit/index.dart';

class Role {
  // Role._();

  static bool _isFarmer = false;

  static bool _isAdmin = false;

  static bool _isOrder = false;

  static void initState(BuildContext context) {
    _isOrder = context.read<AuthC>().state.user?.profileType.contains('ORDERER') ?? false;
    _isAdmin = context.read<AuthC>().state.user?.profileType.contains('ADMIN') ?? false;
    _isFarmer = context.read<AuthC>().state.user?.profileType.contains('FARMER') ?? false;
  }

  static bool get isOrder => _isOrder;

  static bool get isAdmin => _isAdmin;

  static bool get isFarmer => _isFarmer;
}

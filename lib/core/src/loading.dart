import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

WLoading() => Center(
      child: Lottie.asset(
        'assets/json/trail_loading.json',
        height: 150,
        width: 150,
        fit: BoxFit.scaleDown,
      ),
    );

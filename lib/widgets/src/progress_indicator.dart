import 'package:flutter/material.dart';

import '/constants/index.dart';

progressIndicator() => const Column(
      children: [
        SizedBox(height: CSpace.medium),
        CircularProgressIndicator(),
        SizedBox(height: CSpace.medium),
      ],
    );

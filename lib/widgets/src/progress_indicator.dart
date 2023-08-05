import 'package:flutter/material.dart';

import '/constants/index.dart';

progressIndicator() => Column(
      children: const [
        SizedBox(height: CSpace.medium),
        CircularProgressIndicator(),
        SizedBox(height: CSpace.medium),
      ],
    );

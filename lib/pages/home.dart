import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      appBar: appBar(title: 'Home'),
      drawer: drawer(),
      body: BlocBuilder<AuthC, AuthS>(
        builder: (context, state) {
          return Container(
              padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
              child: Column(
                children: [CIcon.logo],
              ));
        },
      ),
    );
  }

  @override
  void initState() {
    Role.initState(context);
    super.initState();
  }
}

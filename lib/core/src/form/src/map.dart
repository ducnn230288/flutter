import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';

import '/utils/index.dart';
import '/constants/index.dart';
import '/cubit/bloc.dart';
import '/core/index.dart';

class WInputMap<T> extends StatefulWidget {
  final String label;
  final List? value;
  final String name;
  final Function(dynamic value)? onCondition;


  const WInputMap({
    Key? key,
    this.label = '',
    this.value,
    this.name = '',
    this.onCondition,
  }) : super(key: key);

  @override
  State<WInputMap> createState() => WInputMapState<T>();
}

class WInputMapState<T> extends State<WInputMap> {
  final GlobalKey<WMapState<T>> _mapKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocC<T>, BlocS<T>>(
      builder: (context, state) {
        return SizedBox(
          height: CSpace.width * 0.5,
          child: WMap<T>(
            onlyPoint: true,
            key: _mapKey,
            address: state.value['${widget.name}fullAddress'] ?? [],
            fullScreen: false,
            name: widget.name,
          ),
        );
      },
    );
  }

  Future<void> getAddress(Map<String, TextEditingController> listController) async {
    await UDialog().delay();
    final cubit = context.read<BlocC<T>>();
    final value = cubit.state.value;
    if (widget.onCondition != null) {
      final List<String>? fromAddress = widget.onCondition!(listController);
      if (fromAddress != null) {
        try {
          final List<Location> locations = await locationFromAddress(fromAddress.join(', '), localeIdentifier: 'vi');
          _mapKey.currentState!.moveCamera([locations[0].latitude, locations[0].longitude]);
          cubit.setValue(value: {...value, widget.name: [locations[0].latitude, locations[0].longitude], '${widget.name}fullAddress': fromAddress});
        } catch (e) {
          cubit.setValue(value: {...value, '${widget.name}fullAddress': fromAddress});
          USnackBar.smallSnackBar(title: 'Không tìm thấy địa chỉ phù hợp', width: 195);
        }
      }
    }
  }

  void setAddress(Map<String, TextEditingController> listController) {
    if (widget.onCondition != null && widget.onCondition!(listController) != null) {
        Delay(milliseconds: 200).run(() { getAddress(listController); });
    } else {
      final cubit = context.read<BlocC<T>>();
      cubit.setValue(value: {widget.name: [], '${widget.name}fullAddress': null});
    }
  }

  @override
  void initState() {
    super.initState();
  }
}

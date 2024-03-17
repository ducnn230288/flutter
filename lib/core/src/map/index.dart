import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '/models/index.dart';
import '/cubit/index.dart';
import '/constants/index.dart';
import '/utils/index.dart';
import '../form/src/input.dart';
import '../line.dart';
import '../spacer.dart';

part '_address_point.dart';
part '_map_picker.dart';
part '_floating_button.dart';
part '_click_point.dart';
part '_locate_option.dart';

class WMap<T> extends StatefulWidget {
  final List? latLn;
  final List<String> address;
  final bool fullScreen;
  final bool onlyPoint;
  final String name;

  const WMap({super.key, this.latLn, required this.address, required this.fullScreen, required this.name, required this.onlyPoint});

  @override
  State<WMap> createState() => WMapState<T>();
}

class WMapState<T> extends State<WMap> {
  final GlobalKey<LocateOptionState> _globalLocateKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final value = context.read<BlocC<T>>().state.value;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          MapPicker(
            showIcon: true,
            iconWidget: CustomPaint(
              size: Size(30, (30 * 1.3863593954095912).toDouble()),
              painter: _AddressPoint(),
            ),
            mapPickerController: _mapPickerController,
            child: GoogleMap(
              onMapCreated: (controller) {
                _controller = controller;
              },
              initialCameraPosition: CameraPosition(
                target: value[widget.name].length > 0
                    ? LatLng(value[widget.name]![0], value[widget.name]![1])
                    : const LatLng(0, 0),
                zoom: 15,
              ),
              mapType: _mapType,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: true,
              onCameraMove: _updateCameraPosition,
              onCameraMoveStarted: () {
                _globalKeyClickPoint.currentState?.hideClickPoint();
                _mapPickerController.mapMoving!();
                _streamController.add('Đang tìm...');
              },
              onCameraIdle: () async {
                _mapPickerController.mapFinishedMoving!();
                _streamController.add('');
                _globalKeyClickPoint.currentState?.showClickPoint(
                  _position.target.latitude > 0 ? _position.target.latitude : widget.latLn![0],
                  _position.target.longitude > 0 ? _position.target.longitude : widget.latLn![1], widget.address,
                );
              },
            ),
          ),
          if (!widget.fullScreen)
          LocateOption<T>(
            key: _globalLocateKey,
            name: widget.name,
            getLocate: (x, y) async {
              await moveCamera([x, y]);
              final cubit = context.read<BlocC<T>>();
              cubit.saved(value: [x, y], name: widget.name);
            },
          ),
          if (widget.fullScreen)
            Positioned(
                top: 30,
                child: SafeArea(
                  child: StreamBuilder<String>(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!, style: const TextStyle(fontWeight: FontWeight.w600));
                      }
                      return Container();
                    },
                  ),
                )),
          if (widget.fullScreen)
            Positioned(
                top: 10,
                left: 10,
                child: SafeArea(
                  child: InkWell(
                    onTap: () => context.pop(),
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.8)),
                        child: const Icon(Icons.arrow_back, color: Colors.white)),
                  ),
                )),
          Positioned(
            top: 10,
            right: 10,
            child: SafeArea(
              child: widget.fullScreen
                  ? InkWell(
                      onTap: () {
                        switch (_mapType.index) {
                          case 1:
                            setState(() {
                              _mapType = MapType.values[2];
                            });
                            break;
                          case 2:
                            setState(() {
                              _mapType = MapType.values[1];
                            });
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.8)),
                        child: const Icon(Icons.layers_outlined, color: Colors.white, size: 18),
                      ),
                    )
                  : BlocBuilder<BlocC<T>, BlocS<T>>(
                      builder: (context, state) {
                        if (value[widget.name].isEmpty) return Container();
                        return InkWell(
                          splashColor: CColor.primary.shade100,
                          onTap: () async {
                            var check = await context.pushNamed<List>(CRoute.map, queryParameters: {
                              'latLn': [_position.target.latitude, _position.target.longitude]
                                  .map((e) => e.toString())
                                  .toList()
                                  .join(','),
                              'name': widget.name,
                              'onlyPoint': 'true',
                            }, extra: widget.address);
                            if (check != null) {
                              await UDialog().delay();
                              await Future.delayed(const Duration(milliseconds: 500));
                              moveCamera([check[0], check[1]]);
                              final cubit = context.read<BlocC<T>>();
                              cubit.setValue(value: {...value, widget.name: check});
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: CColor.black.shade300.withOpacity(0.65),
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            child: const Icon(Icons.edit_location_alt_outlined, color: Colors.black, size: 24),
                          ),
                        );
                      },
                    ),
            ),
          ),
          if (widget.fullScreen)
            Positioned(
                bottom: 10,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _FloatingButton(
                      location: () async {
                        if (await UrlLauncher().checkAndRequestPermission()) {
                          final pos = await UrlLauncher().determinePosition();
                          LatLng newLatLng = LatLng(pos.latitude, pos.longitude);
                          _controller.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(target: newLatLng, zoom: 15)),
                          );
                        }
                      },
                      zoomIn: () => _controller.moveCamera(CameraUpdate.zoomIn()),
                      zoomOut: () => _controller.moveCamera(CameraUpdate.zoomOut()),
                    ),
                    ClickPoint(
                      key: _globalKeyClickPoint,
                      onlyPoint: widget.onlyPoint,
                      latLn: value[widget.name],
                      close: () {
                        if (_globalKeyMapPicker.currentState?.visibleMapPicker() == true) {
                          _globalKeyMapPicker.currentState?.hideMapPicker();
                        }
                      },
                    )
                  ],
                ))
        ],
      ),
    );
  }

  final GlobalKey<MapPickerState> _globalKeyMapPicker = GlobalKey();
  final GlobalKey<ClickPointState> _globalKeyClickPoint = GlobalKey();
  final StreamController<String> _streamController = StreamController<String>.broadcast();
  final MapPickerController _mapPickerController = MapPickerController();

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 11.0,
  );

  CameraPosition _position = _kInitialPosition;
  MapType _mapType = MapType.normal;
  late GoogleMapController _controller;

  @override
  void initState() {
    final cubit = context.read<BlocC<T>>();
    if (widget.latLn != null) cubit.setValue(value: {...cubit.state.value, widget.name: widget.latLn});
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<void> moveCamera(List latLn) async {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latLn[0], latLn[1]),
      zoom: 12.5,
    )));
  }

  void _updateCameraPosition(CameraPosition position) {
    _position = position;
  }
}

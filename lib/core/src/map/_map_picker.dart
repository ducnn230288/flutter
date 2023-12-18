part of 'index.dart';

class MapPickerController {
  Function? mapMoving;
  Function? mapFinishedMoving;
}

/// MapPicker widget is main widget that gets map as a child.
/// It does not restrict user from using maps other than google map.
/// [MapPicker] is controlled with [MapPickerController] class object
class MapPicker extends StatefulWidget {
  /// Map widget, Google, Yandex Map or any other map can be used, see example
  final Widget child;

  /// Map pin widget in the center of the screen. [iconWidget] is used with
  /// animation controller
  final Widget? iconWidget;

  /// default value is true, defines, if there is a dot, at the bottom of the pin
  final bool showDot;
  final bool showIcon;

  /// [MapPicker] can be controller with [MapPickerController] object.
  /// you can call mapPickerController.mapMoving!() and
  /// mapPickerController.mapFinishedMoving!() for controlling the Map Pin.
  final MapPickerController mapPickerController;

  const MapPicker({
    Key? key,
    required this.child,
    required this.mapPickerController,
    this.iconWidget,
    this.showDot = true,
    this.showIcon = false,
  }) : super(key: key);

  @override
  MapPickerState createState() => MapPickerState();
}

class MapPickerState extends State<MapPicker>
    with SingleTickerProviderStateMixin {
  bool _showMapPicker = false;
  final double _dotRadius = 2.2;
  late AnimationController _animationController;
  late Animation<double> _translateAnimation;

  final StreamController<bool> _streamController =
  StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    widget.mapPickerController.mapMoving = mapMoving;
    widget.mapPickerController.mapFinishedMoving = mapFinishedMoving;

    _translateAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  void mapMoving() {
    if (!_animationController.isAnimating &&
        !_animationController.isCompleted) {
      _animationController.forward();
    }
  }

  void mapFinishedMoving() {
    _animationController.reverse();
  }

  void showMapPicker() {
    _streamController.add(true);
  }

  void hideMapPicker() {
    _streamController.add(false);
  }

  bool visibleMapPicker() => _showMapPicker;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            widget.child,
            StreamBuilder<bool>(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  bool check = false;
                  if (widget.showIcon) {
                    check = true;
                  }
                  if (snapshot.hasData) {
                    _showMapPicker = snapshot.data!;
                    if (snapshot.data!) {
                      check = true;
                    }
                  }
                  if (check) {
                    return Positioned(
                      bottom: constraints.maxHeight * 0.5,
                      child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, snapshot) {
                            return Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                if (widget.showDot)
                                  Container(
                                    width: _dotRadius,
                                    height: _dotRadius,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                      BorderRadius.circular(_dotRadius),
                                    ),
                                  ),
                                Transform.translate(
                                  offset: Offset(
                                      0, -15 * _translateAnimation.value),
                                  child: widget.iconWidget,
                                )
                              ],
                            );
                          }),
                    );
                  } else {
                    return const SizedBox(height: 0, width: 0);
                  }
                }),
          ],
        );
      },
    );
  }
}

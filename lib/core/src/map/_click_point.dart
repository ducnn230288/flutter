part of 'index.dart';

class ClickPoint extends StatefulWidget {
  final List latLn;
  final Function close;
  final bool onlyPoint;

  const ClickPoint({
    Key? key,
    required this.close,
    required this.latLn,
    required this.onlyPoint,
  }) : super(key: key);

  @override
  State<ClickPoint> createState() => ClickPointState();
}

class ClickPointState extends State<ClickPoint> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller!,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: [
            Container(
                width: MediaQuery.of(context).size.width - 20,
                constraints: BoxConstraints(maxHeight: _sizeTween!.value),
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(10, _sizeTween!.value != 0 ? 5 : 0, 10, 0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                  BoxShadow(color: CColor.black.shade300.withOpacity(0.8), blurRadius: 5, offset: const Offset(0, 2))
                ]),
                child: SingleChildScrollView(child: child!)),
            Positioned(
              right: 15,
              top: 10,
              child: InkWell(
                onTap: () {
                  widget.close();
                  _controller!.reverse();
                },
                child: const Icon(Icons.close, size: 18, color: Colors.black),
              ),
            )
          ],
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 95,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_name, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                  const SizedBox(height: 3),
                  Text(
                    _address,
                    style: TextStyle(color: CColor.black.shade300, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  line(),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                          text: '${_latLnInfo[0].toStringAsFixed(6)}, ${_latLnInfo[1].toStringAsFixed(6)}'));
                      USnackBar.smallSnackBar(title: 'Đã sao chép tọa độ');
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        '${_latLnInfo[0].toStringAsFixed(6)}, ${_latLnInfo[1].toStringAsFixed(6)}',
                        style: TextStyle(color: CColor.primary, decoration: TextDecoration.underline),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const HSpacer(CSpace.small),
          InkWell(
            onTap: () async {
              if (widget.onlyPoint) { context.pop(_latLnInfo); }
              else {
                Position position = await UrlLauncher().determinePosition();
                String mapOptions =
                ['${position.latitude},${position.longitude}', '${_latLnInfo[0]},${_latLnInfo[1]}'].join('/');
                final url = 'https://www.google.com/maps/dir/$mapOptions';
                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              }
            },
            child: Container(
              height: 35,
              width: 35,
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 1, color: CColor.primary.shade300),
                  color: CColor.primary),
              child: Icon(widget.onlyPoint ? Icons.check : Icons.directions, color: Colors.white, size: 20),
            ),
          )
        ],
      ),
    );
  }

  AnimationController? _controller;
  Animation<double>? _sizeTween;

  String _name = '';
  String _address = '';
  List _latLnInfo = [0, 0];

  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    final curve = CurvedAnimation(parent: _controller!, curve: Curves.easeIn);
    _sizeTween = Tween<double>(begin: 0, end: 300).animate(curve);
    _latLnInfo = widget.latLn;
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Future<void> showClickPoint(double latitude, double longitude, [List<String>? address]) async {
    if (address != null) {
      setState(() {
        if (address.length == 4) {
          _name = address[0];
          address.removeAt(0);
          _address = address.join(', ');
        } else {
          _name = '';
          _address = address.join(', ');
        }
        _latLnInfo = [latitude, longitude];
      });
      if (_controller!.isDismissed) {
        _controller!.forward();
      }
      return;
    }
    try{
      List<Placemark> placeMarks = await placemarkFromCoordinates(latitude, longitude, localeIdentifier: 'vi');
      Placemark place = placeMarks[0];
      _latLnInfo = [latitude, longitude];
      if (Platform.isIOS) {
        setState(() {
          _name = place.street!;
          _address = '${place.subLocality}, ${place.locality}, ${place.postalCode}${place.country}';
        });
      } else {
        setState(() {
          _name = place.street!;
          _address = '${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}';
        });
      }
      if (_controller!.isDismissed) {
        _controller!.forward();
      }
    } catch(e){
      AppConsole.dump(e.toString(), name: 'Error Placemark');
    }
  }

  void hideClickPoint() {
    if (_controller!.isCompleted) {
      _controller!.reverse();
    }
  }
}

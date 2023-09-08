import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class WQRScan extends StatefulWidget {
  final Function onLoad;

  const WQRScan({Key? key, required this.onLoad}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WQRScanState();
}

class WQRScanState extends State<WQRScan> {
  Barcode? result;
  QRViewController? controller;
  bool status = true;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildQrView(context),
          Positioned(
            left: 0.0,
            top: MediaQuery.of(context).size.height / 5,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const Text(
                'Di chuyển camera đến mã QR để quét',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            top: 30.0,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.all(8),
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    )),
                Container(
                    margin: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        FutureBuilder(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            return IconButton(
                              color: Colors.white,
                              icon: snapshot.data != false
                                  ? const Icon(Icons.flashlight_off)
                                  : const Icon(Icons.flashlight_on),
                              onPressed: () async {
                                await controller?.toggleFlash();
                                setState(() {});
                              },
                            );
                          },
                        ),
                        FutureBuilder(
                          future: controller?.getCameraInfo(),
                          builder: (context, snapshot) {
                            return IconButton(
                              color: Colors.white,
                              icon: const Icon(Icons.cameraswitch),
                              onPressed: () async {
                                await controller?.flipCamera();
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = MediaQuery.of(context).size.width * 0.7;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      await controller.pauseCamera();
      widget.onLoad(scanData.code, controller);
      // setState(() {result = scanData;});
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

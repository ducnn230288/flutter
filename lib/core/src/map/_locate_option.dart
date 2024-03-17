part of 'index.dart';

class LocateOption<T> extends StatefulWidget {
  final String name;
  final Function(double x, double y) getLocate;

  const LocateOption({
    super.key,
    required this.name,
    required this.getLocate,
  });

  @override
  State<LocateOption> createState() => LocateOptionState<T>();
}

class LocateOptionState<T> extends State<LocateOption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: _edit ? 120 : 35,
      padding: const EdgeInsets.all(8),
      child: _edit ? locateEdit() : locateData(),
    );
  }

  Widget locateData() {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        'Tọa độ hiện tại: ',
        overflow: TextOverflow.ellipsis,
        maxLines: 4,
      ),
      BlocBuilder<BlocC<T>, BlocS<T>>(
        builder: (context, state) {
          setPositioning(state.value[widget.name]);
          return Expanded(
              child: InkWell(
                onTap: () {
                  setState(() { _edit = true; });
                },
                child: Row(
                  children: [
                    Text(
                      positioning() ?? '(Trống)',
                      style: TextStyle(
                        color: state.value[widget.name].isNotEmpty ? CColor.black.shade200 : CColor.danger,
                        decoration: positioning() == null ? null : TextDecoration.underline,
                      ),
                    ),
                    const HSpacer(CSpace.xs),
                    state.value[widget.name].isNotEmpty ? const Icon(Icons.edit, size: 18) : Container()
                  ],
                ),
              ),
            );
        },
      ),
    ]);
  }


  Widget locateEdit() {
    return Form(
      key: _formKey,
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () async {
              if (await UrlLauncher().checkAndRequestPermission()) {
                try {
                  final position = await UrlLauncher().determinePosition();
                  await widget.getLocate(position.latitude, position.longitude);
                } catch (e) {
                  UDialog().showError(text: 'Không thể lấy được vị trí hiện tại');
                  return;
                }
              }
            },
            child: Icon(
              Icons.radio_button_checked,
              size: 30,
              color: CColor.primary,
            ),
          ),
          const HSpacer(CSpace.sm),
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: WInput(
                        hintText: 'Latitude',
                        keyBoard: EFormItemKeyBoard.number,
                        formatNumberType: FormatNumberType.normal,
                        name: 'x',
                        value: _x,
                        // setText: true,
                        onChanged: (text) {
                          _x = text;
                        },
                      ),
                    ),
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(left: 10),
                      child: SizedBox(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                await widget.getLocate(double.parse(_x), double.parse(_y));
                              } catch (e) {
                                return;
                              }
                              setState(() { _edit = false; });
                            }
                          },
                          child: const Text('Xác nhận')
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: WInput(
                        hintText: 'Longitude',
                        keyBoard: EFormItemKeyBoard.number,
                        formatNumberType: FormatNumberType.normal,
                        name: 'y',
                        value: _y,
                        // setText: true,
                        onChanged: (text) {
                          _y = text;
                        },
                      ),
                    ),
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(left: 10),
                      child: SizedBox(
                        child: ElevatedButton(
                          style: CStyle.buttonOutline,
                          onPressed: () {
                            setState(() { _edit = false; });
                          },
                          child: const Text('Hủy bỏ')
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _edit = false;
  String _x = '';
  String _y = '';

  String? positioning() {
    if (_x == '' || _y == '') {
      return null;
    }
    _x = double.parse(_x).toStringAsFixed(6);
    _y = double.parse(_y).toStringAsFixed(6);
    return '$_x, $_y';
  }

  void setPositioning(List latLn) {
    if (latLn.isNotEmpty && latLn[0] != null && latLn[1] != null) {
      _x = latLn[0]!.toStringAsFixed(6);
      _y = latLn[1]!.toStringAsFixed(6);
    } else if (_x != '' && _y != '') {
      _x = '';
      _y = '';
      widget.getLocate(0, 0);
    }
  }

  bool checkPositioning() {
    if (positioning() != null) return true;
    return false;
  }

  @override
  void initState() {
    super.initState();
  }
}

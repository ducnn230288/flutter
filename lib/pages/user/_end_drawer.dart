part of 'index.dart';

class _EndDrawer<T> extends StatefulWidget {
  final Function format;
  final bool isCustomer;
  const _EndDrawer({super.key, required this.format, this.isCustomer = false});

  @override
  State<_EndDrawer> createState() => _EndDrawerState<T>();
}

class _EndDrawerState<T> extends State<_EndDrawer> {

  int _count = 0;
  @override
  Widget build(BuildContext context) {
    final value = context.read<BlocC<T>>().state.value;
    return Drawer(
      width: CSpace.width * 0.85,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: BlocProvider(
          create: (context) => BlocC(),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Builder(
              builder: (context) {
                final blocC = context.read<BlocC>();
                while (_count < 1) {
                  blocC.saved(name: 'dateRange', value: value['dateRange']);
                  blocC.saved(name: 'isLockedOut', value: value['isLockedOut']);
                  blocC.saved(name: 'isEmailVerified', value: value['isEmailVerified']);
                  _count++;
                }
                return ListView(
                  padding: const EdgeInsets.all(CSpace.xl3),
                  children: [
                    Text('Chọn ngày tham gia', style: CStyle.title),
                    const VSpacer(CSpace.xl3),
                    WDate(
                      name: 'dateRange',
                      controller: TextEditingController(),
                      value: (value['dateRange'] != null ? '${value['dateRange'][0]}|${value['dateRange'][1]}' : ''),
                      space: false,
                      mode: DateRangePickerSelectionMode.range,
                      required: false,
                      onChanged: (value) {
                        dynamic val = value;
                        if (value.contains('|')) {
                          val = value.split('|');
                          blocC.addValue(value: [val[0], val[1]], name: 'dateRange');
                          blocC.addValue(value: val[0], name: 'fromDate');
                          blocC.addValue(value: val[1], name: 'toDate');
                        } else {
                          blocC.state.value
                              .removeWhere((key, value) => ['dateRange', 'fromDate', 'toDate'].contains(key));
                        }
                      },
                    ),
                    _status(),
                    _active(),
                  ],
                );
              },
            ),
            bottomNavigationBar: Builder(builder: (context) {
              final blocC = context.read<BlocC>();
              return Padding(
                padding: const EdgeInsets.all(CSpace.base),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(0)),
                              side: BorderSide(width: 1.0, color: CColor.primary))),
                        ),
                        onPressed: () {
                          Map<String, dynamic> newValue = Map.from(context.read<BlocC<T>>().state.value);
                          newValue.remove('isLockedOut');
                          newValue.remove('dateRange');
                          newValue.remove('fromDate');
                          newValue.remove('toDate');
                          if (widget.isCustomer) {
                            newValue.remove('isEmailVerified');
                          }
                          _getData(newValue);
                        },
                        child: Text('Thiết lập lại', style: TextStyle(color: CColor.primary)),
                      ),
                    ),
                    const HSpacer(CSpace.base),
                    Expanded(
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                          )),
                        ),
                        onPressed: () {
                          Map<String, dynamic> currentValue = {
                            ...context.read<BlocC<T>>().state.value,
                            ...blocC.state.value
                          };
                          currentValue.removeWhere((key, value) => !blocC.state.value.containsKey(key));
                          context.read<BlocC<T>>().resetValue(value: currentValue);
                          _getData(null);
                        },
                        child: const Text('Áp dụng'),
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
  void _getData(Map<String, dynamic>? newValue) {
    context.read<BlocC<T>>().submit(
      getData: true,
      api: (filter, page, size, sort) => RepositoryProvider.of<Api>(context).user.get(
            filter: newValue ?? filter,
            page: page,
            size: size,
          ),
      format: widget.format,
      submit: (_) {
        context.pop();
        if (newValue != null) {
          context.read<BlocC<T>>().removeKey(name: 'isLockedOut');
          context.read<BlocC<T>>().removeKey(name: 'dateRange');
          context.read<BlocC<T>>().removeKey(name: 'fromDate');
          context.read<BlocC<T>>().removeKey(name: 'toDate');
          if (widget.isCustomer) {
            context.read<BlocC<T>>().removeKey(name: 'isEmailVerified');
          }
        }
      });
  }

  Widget _status() {
    if (!widget.isCustomer) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trạng thái', style: CStyle.title),
        const VSpacer(CSpace.xl3),
        Wrap(
          spacing: CSpace.xl,
          runSpacing: CSpace.xl,
          children: [
            buttonSelect(title: 'Đã xác thực', key: 'isEmailVerified', value: true, width: 120),
            buttonSelect(title: 'Chưa xác thực', key: 'isEmailVerified', value: false, width: 130),
          ],
        ),
        const VSpacer(CSpace.xl3),
      ],
    );
  }

  Widget _active() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kích hoạt', style: CStyle.title),
        const VSpacer(CSpace.xl3),
        Wrap(
          spacing: CSpace.xl,
          runSpacing: CSpace.xl,
          children: [
            buttonSelect(title: 'Khóa', key: 'isLockedOut', value: true, width: 70),
            buttonSelect(title: 'Mở khóa', key: 'isLockedOut', value: false, width: 90),
          ],
        )
      ],
    );
  }
}

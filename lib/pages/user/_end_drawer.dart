part of 'index.dart';

class _EndDrawer<T> extends StatefulWidget {
  final Function format;
  const _EndDrawer({Key? key, required this.format}) : super(key: key);

  @override
  State<_EndDrawer> createState() => _EndDrawerState<T>();
}

class _EndDrawerState<T> extends State<_EndDrawer> {
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
                while (count < 1) {
                  blocC.saved(name: 'isLockedOut', value: value['isLockedOut']);
                  blocC.saved(name: 'isEmailVerified', value: value['isEmailVerified']);
                  count++;
                }
                return ListView(
                  padding: const EdgeInsets.all(CSpace.large),
                  children: [
                    Text('Chọn ngày tham gia', style: CStyle.title),
                    const VSpacer(CSpace.large),
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
                    status(),
                    const VSpacer(CSpace.superLarge),
                    active(),
                  ],
                );
              },
            ),
            bottomNavigationBar: Builder(builder: (context) {
              final blocC = context.read<BlocC>();
              return Padding(
                padding: const EdgeInsets.all(CSpace.mediumSmall),
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
                          if (isCustomerAccount) {
                            newValue.remove('isEmailVerified');
                          }
                          getData(newValue);
                        },
                        child: Text('Thiết lập lại', style: TextStyle(color: CColor.primary)),
                      ),
                    ),
                    const HSpacer(CSpace.mediumSmall),
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
                          getData(null);
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

  final bool isCustomerAccount =
      GoRouter.of(rootNavigatorKey.currentState!.context).location.contains(CRoute.customerUser);

  int count = 0;

  void getData(Map<String, dynamic>? newValue) {
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
            if (isCustomerAccount) {
              context.read<BlocC<T>>().removeKey(name: 'isEmailVerified');
            }
          }
        });
  }

  Widget status() {
    if (!isCustomerAccount) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VSpacer(CSpace.superLarge),
        Text('Trạng thái', style: CStyle.title),
        const VSpacer(CSpace.large),
        Wrap(
          spacing: CSpace.medium,
          runSpacing: CSpace.medium,
          children: [
            buttonSelect(title: 'Đã xác thực', key: 'isEmailVerified', value: true, width: 120),
            buttonSelect(title: 'Chưa xác thực', key: 'isEmailVerified', value: false, width: 130),
          ],
        )
      ],
    );
  }

  Widget active() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kích hoạt', style: CStyle.title),
        const VSpacer(CSpace.large),
        Wrap(
          spacing: CSpace.medium,
          runSpacing: CSpace.medium,
          children: [
            buttonSelect(title: 'Khóa', key: 'isLockedOut', value: true, width: 70),
            buttonSelect(title: 'Mở khóa', key: 'isLockedOut', value: false, width: 90),
          ],
        )
      ],
    );
  }
}

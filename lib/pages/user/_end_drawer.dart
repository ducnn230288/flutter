part of 'index.dart';

class _EndDrawer<T> extends StatefulWidget {
  const _EndDrawer({Key? key}) : super(key: key);

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
                      value: (value['dateRange'] ?? ''),
                      space: false,
                      mode: DateRangePickerSelectionMode.range,
                      onChanged: (value) {
                        dynamic val = value;
                        if (value.contains('|')) {
                          val = value.split('|');
                        }
                        blocC.addValue(value: value, name: 'dateRange');
                        blocC.addValue(value: val[0], name: 'fromDate');
                        blocC.addValue(value: val[1], name: 'toDate');
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
                          newValue.remove('fromDate');
                          newValue.remove('toDate');
                          newValue.remove('isLockedOut');
                          newValue.remove('dateRange');
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
                          context
                              .read<BlocC<T>>()
                              .setValue(value: {...context.read<BlocC<T>>().state.value, ...blocC.state.value});
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
        format: MUser.fromJson,
        submit: (_) {
          context.pop();
          if (newValue != null) {
            context.read<BlocC<T>>().removeKey(name: 'fromDate');
            context.read<BlocC<T>>().removeKey(name: 'toDate');
            context.read<BlocC<T>>().removeKey(name: 'isLockedOut');
            context.read<BlocC<T>>().removeKey(name: 'dateRange');
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
            button(title: 'Đã xác thực', key: 'isEmailVerified', value: true, width: 120),
            button(title: 'Chưa xác thực', key: 'isEmailVerified', value: false, width: 130),
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
            button(title: 'Khóa', key: 'isLockedOut', value: true, width: 70),
            button(title: 'Mở khóa', key: 'isLockedOut', value: false, width: 90),
          ],
        )
      ],
    );
  }

  Widget button({
    required String title,
    required String key,
    required dynamic value,
    required double width,
  }) {
    return BlocBuilder<BlocC, BlocS>(
      builder: (context, state) {
        final bool selected = state.value[key] == value;
        return SizedBox(
          height: 32,
          width: width,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(CColor.black.shade100.withOpacity(0.2)),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  side: BorderSide(width: selected ? 1 : 0.00001, color: CColor.primary))),
            ),
            onPressed: () {
              final cubit = context.read<BlocC>();
              if (selected) {
                cubit.removeKey(name: key, isEmit: true);
              } else {
                cubit.addValue(value: value, name: key);
              }
            },
            child: FittedBox(
              child: Text(
                title,
                style: TextStyle(
                  color: selected ? CColor.primary : CColor.black,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

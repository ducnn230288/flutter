part of 'my_account_info.dart';

class _AccountInfo extends StatefulWidget {
  final MUser user;

  const _AccountInfo({required this.user});

  @override
  State<_AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<_AccountInfo> {
  final double _widthImage = CSpace.width * 0.3;
  @override
  Widget build(BuildContext context) {
    return WForm<MUser>(
      list: _listFormItem,
      builder: (items) {
        return CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(CSpace.xl3),
                child: Row(
                  children: [
                    Container(
                      height: _widthImage,
                      width: _widthImage,
                      padding: const EdgeInsets.all(CSpace.xl3),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        color: CColor.primary,
                        boxShadow: const [BoxShadow(color: Colors.grey, offset: Offset(0.5, 0.5), blurRadius: 1)],
                        shape: BoxShape.circle,
                      ),
                      child: FittedBox(
                        child: Text(
                          widget.user.name.substring(0, 2),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const HSpacer(CSpace.xl3),
                    _buildCommonInfo(),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: CSpace.xl3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!Role.isAdmin)
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: CSpace.xl3),
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: CStyle.buttonDanger,
                          onPressed: () {
                            UDialog().showConfirm(
                                title: 'Xóa tài khoản',
                                text: 'Bạn có muốn xoá tài khoản này không?',
                                btnOkOnPress: () {
                                  context.read<BlocC>().submit(
                                      onlyApi: true,
                                      notification: false,
                                      api: (_, __, ___, ____) => RepositoryProvider.of<Api>(context).auth.delete(),
                                      submit: (_) async {
                                        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                        sharedPreferences.clear();
                                        await UDialog().delay();
                                        context.goNamed(CRoute.login);
                                      });
                                });
                          },
                          child: const Text('Xoá tài khoản'),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: CSpace.sm),
                      child:
                          Text('Chỉnh sửa chi tiết', style: TextStyle(fontSize: CFontSize.lg, color: CColor.primary)),
                    ),
                    const VSpacer(CSpace.xl3),
                    items['name'] ?? const SizedBox.shrink(),
                    items['gender'] ?? const SizedBox.shrink(),
                    items['phoneNumber'] ?? const SizedBox.shrink(),
                    items['note'] ?? const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  List<MFormItem> _listFormItem = [];
  Future<void> _init() async {
    List<MOption> opts = [
      MOption(value: 'male', label: 'Nam'),
      MOption(value: 'female', label: 'Nữ'),
      MOption(value: 'custom', label: 'Không hiển thị'),
    ];

    int optIndex = opts.indexWhere((element) => element.value.toLowerCase() == widget.user.gender.toLowerCase());

    _listFormItem = [
      MFormItem(name: 'name', label: 'Họ và tên', value: widget.user.name),
      MFormItem(
        name: 'gender',
        label: 'Giới tính',
        value: optIndex > -1 ? opts[optIndex].label : '',
        code: optIndex > -1 ? opts[optIndex].value : '',
        type: EFormItemType.select,
        items: opts,
      ),
      MFormItem(name: 'phoneNumber', label: 'Số điện thoại', value: widget.user.phoneNumber),
      MFormItem(name: 'note', label: 'Giới thiệu bản thân', maxLines: 4),
    ];
  }

  Widget _buildCommonInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: CSpace.sm),
          child: Text(widget.user.name,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: CFontSize.xl, color: CColor.primary)),
        ),
        Text(
          widget.user.userName,
          style: TextStyle(color: CColor.primary),
        ),
        const VSpacer(CSpace.lg),
        Row(
          children: [
            const Text(
              'Thành viên từ:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const HSpacer(CSpace.base),
            Text(
              Convert.dateTime(widget.user.createdOnDate),
            ),
          ],
        ),
        const VSpacer(CSpace.base),
        const Row(
          children: [
            Text(
              'Bộ dữ liệu:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            HSpacer(CHeight.base),
            Text(
              '0',
            ),
          ],
        )
      ],
    );
  }
}

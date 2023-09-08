part of 'my_account_info.dart';

class _AccountInfo extends StatefulWidget {
  final MUser user;

  const _AccountInfo({Key? key, required this.user}) : super(key: key);

  @override
  State<_AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<_AccountInfo> {
  @override
  Widget build(BuildContext context) {
    List<MOption> opts = [
      MOption(
        value: 'male',
        label: 'Nam',
      ),
      MOption(
        value: 'female',
        label: 'Nữ',
      ),
      MOption(
        value: 'custom',
        label: 'Không hiển thị',
      ),
    ];

    final double widthImage = CSpace.width * 0.3;
    int optIndex = opts.indexWhere((element) =>
        element.value.toLowerCase() == widget.user.gender.toLowerCase());

    List<MFormItem> listFormItem = [
      MFormItem(
        name: 'name',
        label: 'Họ và tên',
        value: widget.user.name,
      ),
      MFormItem(
        name: 'gender',
        label: 'Giới tính',
        value: optIndex > -1 ? opts[optIndex].label : '',
        code: optIndex > -1 ? opts[optIndex].value : '',
        type: EFormItemType.select,
        items: opts,
      ),
      MFormItem(
        name: 'phoneNumber',
        label: 'Số điện thoại',
        value: widget.user.phoneNumber,
      ),
      MFormItem(
        name: 'bankName',
        label: 'Tên ngân hàng',
        value: widget.user.bankName,
      ),
      MFormItem(
        name: 'bankAccountNo',
        label: 'Số tài khoản ngân hàng',
        value: widget.user.bankAccountNo,
      ),
      MFormItem(
        name: 'bankUsername',
        label: 'Tên chủ tài khoản',
        value: widget.user.bankUsername,
      ),
    ];

    return WForm(
      list: listFormItem,
      builder: (items) {
        return CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [CColor.primary.shade600, CColor.primary],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: widthImage,
                      width: widthImage,
                      padding: const EdgeInsets.all(CSpace.medium),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        color: CColor.primary,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.5, 0.5),
                              blurRadius: 1)
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: FittedBox(
                        child: Text(
                          widget.user.name.substring(0, 2),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    _buildCommonInfo(),
                  ],
                ),
              ),
            ),
            // SliverToBoxAdapter(
            //   child: _buildCommonInfo(),
            // ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const VSpacer(CSpace.large),
                    items['name'] ?? const SizedBox.shrink(),
                    items['gender'] ?? const SizedBox.shrink(),
                    items['phoneNumber'] ?? const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: CSpace.large, top: CSpace.small / 2),
                      child: Row(
                        children: [
                          Text(
                            'Thông tin ngân hàng',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: CColor.black.shade300),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: line())
                        ],
                      ),
                    ),
                    _buildBankInfo(items),
                    const VSpacer(CSpace.medium),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCommonInfo() {
    return Column(
      children: [
        const VSpacer(CSpace.medium),
        Text(
          widget.user.userName,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: CFontSize.body,
              color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: CSpace.small),
          child: Text(widget.user.profileType,
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildBankInfo(Map<String, Widget> items) {
    return Column(
      children: [
        items['bankName'] ?? const SizedBox.shrink(),
        items['bankAccountNo'] ?? const SizedBox.shrink(),
        items['bankUsername'] ?? const SizedBox.shrink(),
      ],
    );
  }
}

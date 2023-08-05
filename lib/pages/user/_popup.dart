part of 'index.dart';

class _PopUpItem extends StatelessWidget {
  final MUser data;
  final BuildContext ctx;

  const _PopUpItem({Key? key, required this.ctx, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getData() => ctx.read<BlocC>().submit(
        getData: true,
        api: (filter, page, size, sort) =>
            RepositoryProvider.of<Api>(context).user.get(filter: filter, page: page, size: size),
        format: MUser.fromJson);

    Widget button({required Widget child, required String code}) => GestureDetector(
          onTap: () => context.pop(MCodeType(code: code)),
          child: Container(
            width: 50,
            height: 38,
            color: Colors.transparent,
            child: child,
          ),
        );

    List<PopupMenuEntry<MCodeType>> popupMenu() => [
          PopupMenuItem<MCodeType>(
            padding: EdgeInsets.zero,
            height: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                button(code: 'DELETE', child: Icon(Icons.delete_forever_outlined, color: CColor.danger)),
                line(height: 38, width: 0.5, color: CColor.hintColor.withOpacity(0.3)),
                button(code: 'EDIT', child: Icon(Icons.edit_square, color: CColor.primary)),
                line(height: 38, width: 0.5, color: CColor.hintColor.withOpacity(0.3)),
                button(code: 'PASSWORD', child: Icon(Icons.key, color: CColor.warning)),
              ],
            ),
          ),
        ];

    return BlocProvider(
      create: (context) => BlocC(),
      child: Builder(builder: (context) {
        return PopupMenuButton<MCodeType>(
            shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(CSpace.mediumSmall)),
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(CSpace.mediumSmall)),
              0,
            ),
            onSelected: (MCodeType item) {
              switch (item.code) {
                case 'EDIT':
                  context.goNamed(
                    CRoute.createInternalUser,
                    queryParams: {'formType': FormType.edit.name, 'data': jsonEncode(data)},
                  );
                  break;
                case 'DELETE':
                  UDialog().showConfirm(
                    title: 'Xác nhận trước khi xoá',
                    text: 'Thao tác này sẽ làm mất đi dữ liệu của bạn. Bạn có chắc chắn thực hiện?',
                    btnOkOnPress: () async {
                      context.pop();
                      context.read<BlocC>().submit(
                            onlyApi: true,
                            submit: (_) => getData(),
                            api: (_, __, ___, ____) =>
                                RepositoryProvider.of<Api>(context).user.delete(id: data.id),
                          );
                    },
                  );
                  break;
                case 'PASSWORD':
                  context.goNamed(
                    CRoute.createInternalUser,
                    queryParams: {'formType': FormType.password.name, 'data': jsonEncode(data)},
                  );
              }
            },
            itemBuilder: (_) => popupMenu(),
            splashRadius: CRadius.mediumSmall,
            child: Icon(Icons.more_vert, color: CColor.black));
      }),
    );
  }
}

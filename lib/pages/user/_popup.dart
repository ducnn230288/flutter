part of 'index.dart';

class _PopUpItem extends StatelessWidget {
  final MUser data;
  final BuildContext ctx;
  final int index;

  const _PopUpItem({Key? key, required this.ctx, required this.data, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                line(height: 38, width: 0.5, color: CColor.black.shade300.withOpacity(0.3)),
                button(code: 'EDIT', child: Icon(Icons.edit_square, color: CColor.primary)),
                line(height: 38, width: 0.5, color: CColor.black.shade300.withOpacity(0.3)),
                button(code: 'PASSWORD', child: Icon(Icons.key, color: CColor.warning)),
              ],
            ),
          ),
        ];

    return BlocProvider(
      create: (context) => BlocC<MUser>(),
      child: Builder(builder: (context) {
        return PopupMenuButton<MCodeType>(
            shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(CSpace.mediumSmall)),
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(CSpace.mediumSmall)),
              0,
            ),
            onSelected: (MCodeType item) async {
              final user = RepositoryProvider.of<Api>(context).user;
              switch (item.code) {
                case 'EDIT':
                  await context.pushNamed(
                    CRoute.createInternalUser,
                    queryParams: {'formType': FormType.edit.name},
                    extra: data,
                  );
                  ctx.read<BlocC<MUser>>().refreshPage(
                        index: index,
                        apiId: user.details(id: data.id),
                        format: MUser.fromJson,
                      );
                  break;
                case 'DELETE':
                  UDialog().showConfirm(
                    title: 'Xác nhận trước khi xoá',
                    text: 'Thao tác này sẽ làm mất đi dữ liệu của bạn. Bạn có chắc chắn thực hiện?',
                    btnOkOnPress: () async {
                      ctx.read<BlocC<MUser>>().submit(
                            onlyApi: true,
                            submit: (_) {
                              ctx.pop();
                              ctx.read<BlocC<MUser>>().refreshPage(
                                    index: index,
                                    apiId: user.details(id: data.id),
                                    format: MUser.fromJson,
                                  );
                            },
                            api: (_, __, ___, ____) => user.delete(id: data.id),
                          );
                    },
                  );
                  break;
                case 'PASSWORD':
                  context.goNamed(CRoute.createInternalUser,
                      queryParams: {'formType': FormType.password.name}, extra: data);
              }
            },
            itemBuilder: (_) => popupMenu(),
            splashRadius: CRadius.mediumSmall,
            child: Icon(Icons.more_vert, color: CColor.black));
      }),
    );
  }
}

part of 'index.dart';

class _PopUpItem extends StatefulWidget {
  final MUser data;
  final BuildContext ctx;
  final int index;

  const _PopUpItem({required this.ctx, required this.data, required this.index});

  @override
  State<_PopUpItem> createState() => _PopUpItemState();
}

class _PopUpItemState extends State<_PopUpItem> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlocC<MUser>(),
      child: Builder(builder: (context) {
        return PopupMenuButton<MCodeType>(
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(CSpace.base)),
            BeveledRectangleBorder(borderRadius: BorderRadius.circular(CSpace.base)),
            0,
          ),
          onSelected: (MCodeType item) async {
            final user = RepositoryProvider.of<Api>(context).user;
            switch (item.code) {
              case 'EDIT':
                await context.pushNamed(
                  CRoute.createInternalUser,
                  queryParameters: {'formType': FormType.edit.name},
                  extra: widget.data,
                );
                widget.ctx.read<BlocC<MUser>>().refreshPage(
                      index: widget.index,
                      apiId: user.details(id: widget.data.id),
                      format: MUser.fromJson,
                    );
                break;
              case 'DELETE':
                UDialog().showConfirm(
                  title: 'Xác nhận trước khi xoá',
                  text: 'Thao tác này sẽ làm mất đi dữ liệu của bạn. Bạn có chắc chắn thực hiện?',
                  btnOkOnPress: () async {
                    widget.ctx.read<BlocC<MUser>>().submit(
                          onlyApi: true,
                          submit: (_) {
                            widget.ctx.pop();
                            widget.ctx.read<BlocC<MUser>>().refreshPage(
                                  index: widget.index,
                                  apiId: user.details(id: widget.data.id),
                                  format: MUser.fromJson,
                                );
                          },
                          api: (_, __, ___, ____) => user.delete(id: widget.data.id),
                        );
                  },
                );
                break;
              case 'PASSWORD':
                context.goNamed(CRoute.createInternalUser,
                    queryParameters: {'formType': FormType.password.name}, extra: widget.data);
            }
          },
          itemBuilder: (_) => _popupMenu(),
          splashRadius: CSpace.base,
          child: Icon(Icons.more_vert, color: CColor.black));
      }),
    );
  }

  Widget _button({required Widget child, required String code}) => GestureDetector(
    onTap: () => context.pop(MCodeType(code: code)),
    child: Container(
      width: 50,
      height: 38,
      color: Colors.transparent,
      child: child,
    ),
  );

  List<PopupMenuEntry<MCodeType>> _popupMenu() => [
    PopupMenuItem<MCodeType>(
      padding: EdgeInsets.zero,
      height: 15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _button(code: 'DELETE', child: Icon(Icons.delete_forever_outlined, color: CColor.danger)),
          line(height: 38, width: 0.5, color: CColor.black.shade300.withOpacity(0.3)),
          _button(code: 'EDIT', child: Icon(Icons.edit_square, color: CColor.primary)),
          line(height: 38, width: 0.5, color: CColor.black.shade300.withOpacity(0.3)),
          _button(code: 'PASSWORD', child: Icon(Icons.key, color: CColor.warning)),
        ],
      ),
    ),
  ];

}

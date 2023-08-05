part of 'index.dart';

class _Filter extends StatelessWidget {
  const _Filter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isInternalUser = GoRouter.of(context).location.contains(CRoute.internalUser);
    final List<MFilter> roleFilter = [
      MFilter(label: 'Tất cả', value: ''),
      isInternalUser ? MFilter(label: 'CSKH', value: 'CSKH') : MFilter(label: 'Order Side', value: 'ORDERER'),
      isInternalUser ? MFilter(label: 'Kế toán', value: 'KT') : MFilter(label: 'Farmer Side', value: 'FARMER'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CSpace.mediumSmall, horizontal: CSpace.large),
      child: WidgetFilter(
        filter: roleFilter,
        submit: () => context.read<BlocC>().submit(
            getData: true,
            notification: false,
            api: (filter, page, size, sort) =>
                RepositoryProvider.of<Api>(context).user.get(filter: filter, page: page, size: size),
            format: MUser.fromJson),
        keyValue: 'roleCode',
      ),
    );
  }
}

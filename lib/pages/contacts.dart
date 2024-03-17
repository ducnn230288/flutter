import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';

class Contracts extends StatefulWidget {
  const Contracts({super.key});

  @override
  State<Contracts> createState() => _ContractsState();
}

class _ContractsState extends State<Contracts> with TickerProviderStateMixin {

  double _height = 87.0;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BlocC<Contact>>();
    return Scaffold(
      appBar: appBar(
        title: 'Danh bạ của tôi',
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: _height,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: CSpace.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextSearch<Contact>(
                  margin: const EdgeInsets.symmetric(horizontal: CSpace.xl3),
                  api: (filter, page, size, sort) => cubit.setValue(value: filter),
                  format: Contact.fromJson,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: CSpace.xl3, top: CSpace.sm),
                  child: totalElementTitle<Contact>(suffix: 'liên lạc'),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<BlocC<Contact>, BlocS<Contact>>(
              builder: (context, state) {
                return WList<Contact>(
                  onScroll: (controller, number) {
                    double height = controller.position.pixels < 150 || number >= 0 ? 123 : 0;
                    if (height != _height && controller.position.pixels < controller.position.maxScrollExtent) {
                      setState(() => _height = height);
                    }
                  },
                  items: cubit.state.data.content.where((i) => cubit.state.value['fullTextSearch'] == null || i.displayName.toUpperCase().contains(cubit.state.value['fullTextSearch'].toUpperCase())).toList(),
                  item: (data, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index == 0) const VSpacer(CSpace.lg),
                        Container(
                          padding: const EdgeInsets.all(CSpace.lg),
                          margin: const EdgeInsets.only(left: CSpace.lg, right: CSpace.lg),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(CSpace.xs),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  data.displayName,
                                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          data.phones.first.number,
                                          textAlign: TextAlign.right,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  onTap: (data) => context.pop(data),
                  separator: const VSpacer(CSpace.sm),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  Future getData() async {
    List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: false);
    List listContent = [];
    for (var e in contacts) {
      listContent.add(e.toJson());
    }
    MData<Contact> data = MData<Contact>.fromJson(MApi
        .fromJson(listContent)
        .data, Contact.fromJson);
    context.read<BlocC<Contact>>().setData(data: data);
  }
}

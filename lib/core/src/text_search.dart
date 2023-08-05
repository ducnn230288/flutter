import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/utils/index.dart';

class TextSearch<T> extends StatefulWidget {
  final String? hintText;
  final Function(Map<String, dynamic> value, int page, int size, Map<String, dynamic> sort) api;
  final Function format;
  final EdgeInsets? margin;

  const TextSearch({Key? key, required this.api, required this.format, this.hintText, this.margin}) : super(key: key);

  @override
  State<TextSearch> createState() => _TextSearchState<T>();
}

class _TextSearchState<T> extends State<TextSearch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: widget.margin ?? EdgeInsets.zero,
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: CColor.primary),
        onChanged: (text) {
          Delay().run(() {
            api(text);
          });
        },
        decoration: InputDecoration(
            hintText: widget.hintText ?? 'Tìm kiếm',
            hintStyle: TextStyle(color: CColor.hintColor, fontSize: CFontSize.body),
            prefixIcon: CIcon.search,
            prefixIconConstraints: const BoxConstraints(minWidth: 40),
            focusedBorder: borderStyle,
            enabledBorder: borderStyle,
            fillColor: CColor.black.shade50,
            filled: true,
            contentPadding: EdgeInsets.zero,
            suffixIcon: BlocBuilder<BlocC<T>, BlocS<T>>(
              builder: (context, state) {
                if (state.value['fullTextSearch'] == null || state.value['fullTextSearch'] == '') {
                  return const SizedBox(width: 0);
                } else {
                  return InkWell(
                    splashColor: CColor.primary.shade100,
                    onTap: () async {
                      await api('');
                      controller.clear();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: CSpace.medium),
                      child: CIcon.close,
                    ),
                  );
                }
              },
            )),
        minLines: 1,
      ),
    );
  }

  final OutlineInputBorder borderStyle = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    borderSide: BorderSide(width: 0, style: BorderStyle.none),
  );

  final TextEditingController controller = TextEditingController();

  Future<void> api(String text) async {
    final cubit = context.read<BlocC<T>>();
    Future block = cubit.stream.first;
    cubit.saved(value: text, name: 'fullTextSearch');
    cubit.setPage(page: 1, api: widget.api, format: widget.format);
    await block;
  }
}

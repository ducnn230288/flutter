import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/utils/index.dart';

class TextSearch<T> extends StatefulWidget {
  final String? hintText;
  final Function(Map<String, dynamic> value, int page, int size, Map<String, dynamic> sort) api;
  final Function(Map<String, dynamic> json) format;
  final EdgeInsets? margin;

  const TextSearch({super.key, required this.api, required this.format, this.hintText, this.margin});

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
        key: ValueKey(widget.hintText ?? 'Tìm kiếm'),
        controller: controller,
        style: TextStyle(color: CColor.primary, fontSize: CFontSize.base),
        onChanged: (text) {
          Delay().run(() {
            api(text);
          });
        },
        decoration: InputDecoration(
            hintText: widget.hintText ?? 'Tìm kiếm',
            hintStyle: TextStyle(color: CColor.black.shade300, fontSize: CFontSize.base),
            prefixIcon: CIcon.search,
            prefixIconConstraints: const BoxConstraints(minWidth: 40),
            focusedBorder: borderStyle,
            enabledBorder: borderStyle,
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.zero,
            suffixIcon: BlocBuilder<BlocC<T>, BlocS<T>>(
              builder: (context, state) {
                if (state.value['fullTextSearch'] == null || state.value['fullTextSearch'] == '') {
                  return const SizedBox();
                } else {
                  return InkWell(
                    splashColor: CColor.primary.shade100,
                    onTap: () async {
                      await api('');
                      controller.clear();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: CSpace.xl),
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

  final OutlineInputBorder borderStyle = OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(CSpace.sm)),
    borderSide: BorderSide(color: CColor.black.shade100, width: 1),
  );

  final TextEditingController controller = TextEditingController();

  Future<void> api(String text) async {
    final cubit = context.read<BlocC<T>>();
    cubit.saved(value: text, name: 'fullTextSearch');
    await cubit.setPage(page: 1, api: widget.api, format: widget.format);
  }
}

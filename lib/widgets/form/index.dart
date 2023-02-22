import 'package:flutter/material.dart';

import '/models.dart';
import 'input.dart';
import 'select.dart';

class WidgetForm extends StatefulWidget {
  final List<ModelFormItem> list;
  final WidgetFormNotifier notifier;

  WidgetForm({Key? key, required this.list, required this.notifier}) : super(key: key);

  @override
  WidgetFormState createState() => WidgetFormState();
}

class WidgetFormNotifier extends ChangeNotifier {
  dynamic dataForm = {};
  final formKey = GlobalKey<FormState>();
}

class WidgetFormState extends State<WidgetForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.notifier.formKey,
      child: Column(
        children: <Widget>[
          ...List.generate(widget.list.length, (index) {
            ModelFormItem item = widget.list[index];
            switch (item.type) {
              // case 'upload':
              //   return WidgetUpload(
              //     label: item.label,
              //   );
              case 'select':
                return item.show
                    ? WidgetSelect(
                        label: item.label,
                        value: item.value != '' ? item.value : null,
                        space: index != widget.list.length - 1,
                        required: item.required,
                        enabled: item.enabled,
                        icon: item.icon,
                        items: item.items,
                        onChanged: (text) {
                          widget.notifier.dataForm[item.name] = text;
                          if (item.onChange != null) {
                            item.onChange!(text);
                          }
                        },
                      )
                    : Container();
              default:
                return item.show
                    ? WidgetInput(
                        label: item.label,
                        value: item.value,
                        space: index != widget.list.length - 1,
                        maxLines: item.maxLines,
                        required: item.required,
                        enabled: item.enabled,
                        password: item.password,
                        number: item.number,
                        placeholder: item.placeholder,
                        onChanged: (text) {
                          widget.notifier.dataForm[item.name] = text;
                          if (item.onChange != null) {
                            item.onChange!(text);
                          }
                        },
                        email: item.email,
                        onTap: item.onTap,
                        icon: item.icon,
                        suffix: item.suffix,
                      )
                    : Container();
            }
          }),
        ],
      ),
    );
  }
}

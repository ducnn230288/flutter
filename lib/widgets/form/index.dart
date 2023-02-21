import 'package:flutter/material.dart';

import '/models.dart';
import 'input.dart';
import 'select.dart';

class WidgetForm extends StatefulWidget {
  final ModelForm modelForm;
  final WidgetFormNotifier widgetFormNotifier;

  WidgetForm({Key? key, required this.modelForm, required this.widgetFormNotifier}) : super(key: key);

  @override
  WidgetFormState createState() => WidgetFormState();
}

class WidgetFormNotifier extends ChangeNotifier {
  dynamic dataForm = {};
  final formKey = GlobalKey<FormState>();
}

class WidgetFormState extends State<WidgetForm> {
  ModelForm modelForm = ModelForm();

  @override
  void initState() {
    modelForm = widget.modelForm;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.widgetFormNotifier.formKey,
      child: Column(
        children: <Widget>[
          ...List.generate(modelForm.items.length, (index) {
            switch (modelForm.items[index].type) {
              // case 'upload':
              //   return WidgetUpload(
              //     label: modelForm.items[index].label,
              //   );
              case 'select':
                return WidgetSelect(
                  label: modelForm.items[index].label,
                  value: modelForm.items[index].value != '' ? modelForm.items[index].value : null,
                  space: index != modelForm.items.length - 1,
                  required: modelForm.items[index].required,
                  enabled: modelForm.items[index].enabled,
                  icon: modelForm.items[index].icon,
                  items: modelForm.items[index].items,
                  onChanged: (text) {
                    widget.widgetFormNotifier.dataForm[modelForm.items[index].name] = text;
                  },
                );
              default:
                return WidgetInput(
                  label: modelForm.items[index].label,
                  value: modelForm.items[index].value,
                  space: index != modelForm.items.length - 1,
                  maxLines: modelForm.items[index].maxLines,
                  required: modelForm.items[index].required,
                  enabled: modelForm.items[index].enabled,
                  password: modelForm.items[index].password,
                  number: modelForm.items[index].number,
                  placeholder: modelForm.items[index].placeholder,
                  onChanged: (text) {
                    widget.widgetFormNotifier.dataForm[modelForm.items[index].name] = text;
                  },
                  onTap: modelForm.items[index].onTap,
                  icon: modelForm.items[index].icon,
                  suffix: modelForm.items[index].suffix,
                );
            }
          }),
        ],
      ),
    );
  }
}

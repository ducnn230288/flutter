import 'package:flutter/material.dart';

import '/models.dart';
import 'input.dart';
import 'select.dart';

class WidgetForm extends StatefulWidget {
  final ModelForm modelForm;

  const WidgetForm({
    Key? key,
    required this.modelForm,
  }) : super(key: key);

  @override
  WidgetFormState createState() => WidgetFormState();
}

class WidgetFormState extends State<WidgetForm> {
  final _formKey = GlobalKey<FormState>();
  ModelForm modelForm = ModelForm();
  dynamic dataForm = {};

  @override
  void initState() {
    modelForm = widget.modelForm;

    super.initState();
  }

  handleLogin() async {
    if (_formKey.currentState!.validate()) {
      modelForm.submit!(dataForm);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
                  onChanged: (text) {
                    dataForm[modelForm.items[index].name] = text;
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
                    dataForm[modelForm.items[index].name] = text;
                  },
                  onTap: modelForm.items[index].onTap,
                  icon: modelForm.items[index].icon,
                  suffix: modelForm.items[index].suffix,
                );
            }
          }),
          // WidgetButton(title: modelForm.textSubmit, onClick: () => handleLogin(), color: modelForm.colorSubmit),
        ],
      ),
    );
  }
}

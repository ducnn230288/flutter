import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants/index.dart';
import '../models/index.dart';
import '../widgets/index.dart';

class Dialogs {
  late BuildContext context;

  Dialogs(this.context);

  Future<void> startLoading() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          children: <Widget>[
            Center(
              child: Lottie.asset(
                'assets/json/trail_loading.json',
                height: 150,
                width: 150,
                fit: BoxFit.scaleDown,
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> stopLoading() async {
    Navigator.of(context).pop();
  }

  Future<void> showSuccess({String? text, String? title, Function? onDismiss}) async {
    return AwesomeDialog(
        padding: const EdgeInsets.all(0),
        context: context,
        autoHide: const Duration(seconds: 2),
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        titleTextStyle: Style.title,
        title: title,
        desc: text,
        onDismissCallback: (DismissType type) {
          if (onDismiss != null) {
            onDismiss(context);
          }
        }).show();
  }

  Future<void> showForm(
      {required String title,
      required List<ModelFormItem> formItem,
      required submit,
      String textButton = 'Xác nhận'}) async {
    late AwesomeDialog dialog;
    dialog = AwesomeDialog(
      padding: const EdgeInsets.all(0),
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.question,
      headerAnimationLoop: false,
      keyboardAware: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: Style.title,
            ),
            const SizedBox(
              height: Space.large,
            ),
            // WidgetForm(list: formItem),
            const SizedBox(
              height: Space.large,
            ),
            ElevatedButton(
                onPressed: () {
                  // if (formNotifier.formKey.currentState!.validate()) {
                  //   dialog.dismiss();
                  //   submit(formNotifier.dataForm);
                  // }
                },
                child: Text(textButton))
          ],
        ),
      ),
    )..show();
  }
}

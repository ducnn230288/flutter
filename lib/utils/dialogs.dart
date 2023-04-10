import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/widgets/index.dart';

class UDialog {
  Future<void> startLoading() async {
    return await showDialog<void>(
      context: rootNavigatorKey.currentState!.context,
      barrierDismissible: false,
      builder: (_) {
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
    Navigator.of(rootNavigatorKey.currentState!.context).pop();
  }

  Future<void> showError({String? text, String? title}) async {
    return AwesomeDialog(
      context: rootNavigatorKey.currentState!.context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.error,
      titleTextStyle: CStyle.title,
      title: title,
      desc: text,
    ).show();
  }

  Future<void> showSuccess({String? text, String? title, Function? onDismiss}) async {
    return AwesomeDialog(
        context: rootNavigatorKey.currentState!.context,
        autoHide: const Duration(seconds: 2),
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        titleTextStyle: CStyle.title,
        title: title,
        desc: text,
        onDismissCallback: (DismissType type) {
          if (onDismiss != null) {
            onDismiss(rootNavigatorKey.currentState!.context);
          }
        }).show();
  }

  Future<dynamic> showConfirm({
    String? text,
    String? title,
    Function(BuildContext context)? onDismiss,
    void Function()? btnCancelOnPress,
    void Function()? btnOkOnPress,
    String btnOkText = 'Đồng ý',
    String btnCancelText = 'Huỷ bỏ',
    Widget? body,
  }) async {
    return AwesomeDialog(
        context: rootNavigatorKey.currentState!.context,
        autoDismiss: false,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.warning,
        titleTextStyle: CStyle.title,
        title: title,
        desc: text,
        btnCancelText: btnCancelText,
        btnCancel: ElevatedButton(
          style: CStyle.buttonWhite.copyWith(elevation: const MaterialStatePropertyAll(0)),
          onPressed: btnCancelOnPress ?? () => rootNavigatorKey.currentState!.pop(),
          child: Text(btnCancelText),
        ),
        btnOk: ElevatedButton(
          style: CStyle.button,
          onPressed: btnOkOnPress ?? () => rootNavigatorKey.currentState!.pop(),
          child: Text(btnOkText),
        ),
        body: body,
        onDismissCallback: (DismissType type) {
          if (onDismiss != null) {
            onDismiss(rootNavigatorKey.currentState!.context);
          }
        }).show();
  }

  Future<void> showForm(
      {required String title,
      required List<MFormItem> formItem,
      required Function(Map<String, dynamic> value, int page, int size, Map<String, dynamic> sort) api,
      Function()? submit,
      String textButton = 'Xác nhận'}) async {
    late AwesomeDialog dialog;
    dialog = AwesomeDialog(
      padding: const EdgeInsets.all(0),
      context: rootNavigatorKey.currentState!.context,
      animType: AnimType.scale,
      dialogType: DialogType.question,
      headerAnimationLoop: false,
      keyboardAware: true,
      body: BlocProvider(
        create: (context) => BlocC(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                title,
                style: CStyle.title,
              ),
              const SizedBox(
                height: CSpace.large,
              ),
              WForm(list: formItem),
              const SizedBox(
                height: CSpace.large,
              ),
              BlocBuilder<BlocC, BlocS>(
                builder: (context, state) {
                  return BlocListener<BlocC, BlocS>(
                    listenWhen: (context, state) => state.status == AppStatus.success,
                    listener: (context, state) {
                      dialog.dismiss();
                      if (submit != null) {
                        submit();
                      }
                    },
                    child: ElevatedButton(
                        onPressed: () {
                          context.read<BlocC>().submit(api: api);
                        },
                        child: Text(textButton)),
                  );
                },
              )
            ],
          ),
        ),
      ),
    )..show();
  }

  Future<void> delay([int milliseconds = 100]) async {
    if (rootNavigatorKey.currentState!.context.mounted == false) {
      await Future.delayed(Duration(milliseconds: milliseconds));
    }
  }
}

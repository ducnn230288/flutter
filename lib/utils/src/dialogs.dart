import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';

class UDialog {
  static bool _isDialog = false;

  Future<void> startLoading() async {
    _isDialog = true;
    return await showDialog<void>(
      context: rootNavigatorKey.currentState!.context,
      barrierDismissible: false,
      barrierColor: CColor.black.withOpacity(0.2),
      builder: (_) {
        return const PopScope(
          canPop: true,
          child: SimpleDialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            children: <Widget>[WLoading()],
          ),
        );
      },
    ).timeout(const Duration(seconds: 3), onTimeout: () {
      stopLoading();
    }).then((value) => _isDialog = false);
  }

  Future<void> stopLoading() async {
    if (_isDialog) {
      Navigator.of(rootNavigatorKey.currentState!.context).pop();
    }
  }

  Future<void> showError({String? text, String? title}) async {
    return common(
      title: title ?? 'Cảnh báo',
      text: text,
      textButton: 'Thoát',
      titleColor: CColor.danger,
      secondTimeOut: 5,
    );
  }

  Future<void> showSuccess({
    String? text,
    String? title,
    Function(BuildContext context)? onDismiss,
  }) async {
    return common(
      title: title ?? 'Thông báo',
      text: text,
      onDismiss: onDismiss,
      textButton: 'Đồng ý',
    );
  }

  Future<void> common(
      {String? title,
      String? text,
      required String textButton,
      Function(BuildContext)? onDismiss,
      Color? titleColor,
      int secondTimeOut = 2}) {
    final BuildContext context = rootNavigatorKey.currentState!.context;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CSpace.xl3)),
              title: Text(
                title ?? 'Thông báo',
                style: TextStyle(fontSize: CFontSize.xl, fontWeight: FontWeight.w600, color: titleColor),
                textAlign: TextAlign.center,
              ),
              titlePadding: const EdgeInsets.fromLTRB(CSpace.xl4, CSpace.xl4, CSpace.xl4, 0),
              contentPadding: const EdgeInsets.fromLTRB(CSpace.xl3, CSpace.xl3, CSpace.xl3, 0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (text != null) Text(text, textAlign: TextAlign.center),
                  line(margin: const EdgeInsets.only(top: 23)),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: SizedBox(
                      width: 300,
                      child: Text(textButton, style: const TextStyle(fontSize: CFontSize.sm),
                        textAlign: TextAlign.center,
                      )),
                  )
                ],
              ));
        }).timeout(Duration(seconds: secondTimeOut), onTimeout: () {
      context.pop();
    }).then((value) {
      if (onDismiss != null) {
        onDismiss(context);
      }
    });
  }

  Future<dynamic> showConfirm({
    String? text,
    String? title,
    bool showTitle = true,
    Function(BuildContext context)? onDismiss,
    void Function()? btnCancelOnPress,
    void Function()? btnOkOnPress,
    String btnOkText = 'Đồng ý',
    String btnCancelText = 'Huỷ bỏ',
    Widget? body,
  }) async {
    final BuildContext context = rootNavigatorKey.currentState!.context;
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CSpace.xl3)),
              title: showTitle
                  ? Text(
                      title ?? 'Thông báo',
                      style: const TextStyle(fontSize: CFontSize.xl, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    )
                  : null,
              titlePadding: const EdgeInsets.fromLTRB(CSpace.xl4, CSpace.xl4, CSpace.xl4, 0),
              contentPadding: const EdgeInsets.fromLTRB(CSpace.xl3, CSpace.xl3, CSpace.xl3, 0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (text != null) Text(text, textAlign: TextAlign.center),
                  if (body != null) body,
                  line(margin: const EdgeInsets.only(top: 23)),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: btnCancelOnPress ?? () => context.pop(),
                          highlightColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: CSpace.xl),
                            child: Text(
                              btnCancelText,
                              style: TextStyle(color: CColor.black.shade300),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      line(width: 0.5, height: 33),
                      Expanded(
                        child: InkWell(
                          onTap: btnOkOnPress ?? () => context.pop(),
                          highlightColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: CSpace.xl),
                            child: Text(
                              btnOkText,
                              style: TextStyle(
                                color: CColor.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ));
        }).then((value) { if (onDismiss != null) onDismiss(context); });
  }

  Future<void> showForm({
    required String title,
    required List<MFormItem> formItem,
    required Function(Map<String, dynamic> value, int page, int size, Map<String, dynamic> sort) api,
    Function(Map<String, dynamic>)? onSubmit,
    Function()? submit,
    String textButton = 'Xác nhận',
  }) async {
    final BuildContext context = rootNavigatorKey.currentState!.context;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CSpace.xl3)),
            title: Text(title, style: const TextStyle(fontSize: CFontSize.base), textAlign: TextAlign.center),
            titlePadding: const EdgeInsets.fromLTRB(CSpace.xl4, CSpace.xl4, CSpace.xl4, 0),
            contentPadding: const EdgeInsets.fromLTRB(CSpace.xl3, CSpace.xl3, CSpace.xl3, 0),
            insetPadding: const EdgeInsets.symmetric(horizontal: CSpace.xl3),
            content: BlocProvider(
              create: (context) => BlocC(),
              child: Container(
                width: CSpace.width,
                padding: const EdgeInsets.symmetric(vertical: CSpace.base),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    WForm(list: formItem),
                    const VSpacer(CSpace.xl3),
                    BlocBuilder<BlocC, BlocS>(
                      builder: (context, state) {
                        return BlocListener<BlocC, BlocS>(
                          listenWhen: (context, state) => state.status == AppStatus.success,
                          listener: (context, state) {
                            context.pop();
                            if (submit != null) {
                              submit();
                            }
                          },
                          child: ElevatedButton(
                              onPressed: () {
                                if (onSubmit != null) onSubmit(context.read<BlocC>().state.value);
                                context.read<BlocC>().submit(api: api);
                              },
                              child: Text(textButton)),
                        );
                      },
                    ),
                    const VSpacer(CSpace.base),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> delay([int milliseconds = 100]) async {
    if (rootNavigatorKey.currentState!.context.mounted == false) {
      await Future.delayed(Duration(milliseconds: milliseconds));
    }
  }
}

class Delay {
  final int milliseconds;

  Delay({this.milliseconds = 700});

  static Timer? _timer;

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

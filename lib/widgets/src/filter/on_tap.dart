import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';

class OnTapFilter {
  OnTapFilter._();

  static final BuildContext context = rootNavigatorKey.currentState!.context;

  static DateTime? toDate;
  static DateTime? fromDate;

  static dynamic dialog({
    required String title,
    required String? value,
    required List<MFilter> filters,
    required String submitText,
    required Function(String? label, String? value) submit,
  }) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(vertical: CSpace.xl5 * 2),
            contentPadding: EdgeInsets.zero,
            content: Container(
              height: CSpace.height * 0.8,
              width: CSpace.width - 2 * CSpace.xl3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(CSpace.xl3),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: CHeight.xl2,
                    decoration: BoxDecoration(
                      color: CColor.primary,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(CSpace.xl3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: CSpace.xl5),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: CFontSize.base,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                            splashRadius: CSpace.xl3,
                            onPressed: () => context.pop(),
                            icon: const Icon(Icons.close_rounded, color: Colors.white))
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: filters.length,
                          itemBuilder: (_, index) {
                            final MFilter filter = filters[index];
                            final bool selected = value == filter.value;
                            return InkWell(
                              onTap: () async {
                                if (filter.onTap != null) {
                                  filter.onTap!();
                                } else {
                                  context.pop();
                                  submit(selected ? null : filter.label, selected ? null : filter.value);
                                }
                              },
                              child: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(CSpace.xl3),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  filter.color ?? (selected ? CColor.primary : CColor.black.shade300),
                                              shape: BoxShape.circle,
                                            ),
                                            margin: const EdgeInsets.only(right: CSpace.base),
                                            height: CSpace.base,
                                            width: CSpace.base,
                                          ),
                                          Expanded(
                                            child: Text(
                                              filter.label,
                                              style: TextStyle(
                                                fontWeight: selected ? FontWeight.w600 : null,
                                                color: selected ? CColor.black : CColor.black.shade400,
                                              ),
                                            ),
                                          ),
                                          if (selected)
                                            Icon(
                                              Icons.check_circle_outline,
                                              color: CColor.primary,
                                              size: CFontSize.xl,
                                            )
                                        ],
                                      )),
                                  if (index < filters.length - 1)
                                    line(margin: const EdgeInsets.symmetric(horizontal: CSpace.xl3))
                                ],
                              ),
                            );
                          })),
                  if (filters.any((element) => element.value == value))
                    Padding(
                      padding: const EdgeInsets.all(CSpace.xl3),
                      child: ElevatedButton(
                        style: CStyle.buttonHint,
                        onPressed: () {
                          context.pop();
                          submit(null, null);
                        },
                        child: Text('Đặt lại bộ lọc', style: TextStyle(color: CColor.primary)),
                      ),
                    ),
                ],
              ),
            ),
          );
        });
  }

  static dynamic dateRange({
    required String title,
    required List<String> value,
    String submitText = 'Xác nhận',
    required Function(List<String>? value) submit,
  }) {
    final bool check = value.length == 2;
    showDialog(
        context: context,
        builder: (_) {
          final Size size = MediaQuery.of(context).size;
          return BlocProvider(
            create: (context) => BlocC(),
            child: Builder(builder: (context) {
              if (check) {
                context.read<BlocC>().saved(value: value[0], name: 'fromDate');
                context.read<BlocC>().saved(value: value[1], name: 'toDate');
              }
              return AlertDialog(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                insetPadding: const EdgeInsets.symmetric(vertical: CSpace.xl5 * 4, horizontal: 0),
                contentPadding: EdgeInsets.zero,
                content: Container(
                  height: size.height * 0.8,
                  width: size.width - 2 * CSpace.xl3,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(CSpace.xl3)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: CHeight.xl2 - 3,
                        decoration: BoxDecoration(
                          color: CColor.primary,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(CSpace.xl3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: CSpace.xl5),
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: CFontSize.base,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                                splashRadius: CSpace.xl3,
                                onPressed: () => context.pop(),
                                icon: const Icon(Icons.close_rounded, color: Colors.white))
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: CSpace.xl3),
                        margin: const EdgeInsets.symmetric(vertical: CSpace.xl3),
                        child: BlocBuilder<BlocC, BlocS>(
                          builder: (context, state) {
                            return Form(
                              key: state.formKey,
                              child: Column(
                                children: [
                                  textFormField(
                                    context: context,
                                    label: 'Ngày bắt đầu',
                                    name: 'fromDate',
                                    onTap: () => selectDate(
                                      name: 'fromDate',
                                      initialSelectedDate: fromDate ?? (check ? DateTime.parse(value[0]) : null),
                                      limit: check ? value[1] : state.value['toDate'],
                                    ),
                                    value: check ? value[0] : state.value['toDate'],
                                  ),
                                  const SizedBox(height: CSpace.xl),
                                  textFormField(
                                    context: context,
                                    label: 'Ngày kết thúc',
                                    name: 'toDate',
                                    onTap: () => selectDate(
                                      name: 'toDate',
                                      initialSelectedDate: toDate ?? (check ? DateTime.parse(value[1]) : null),
                                      limit: check ? value[0] : state.value['fromDate'],
                                    ),
                                    value: check ? value[1] : state.value['toDate'],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(CSpace.xl3),
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            children: [
                              if (check)
                                Expanded(
                                    child: ElevatedButton(
                                        style: CStyle.buttonHint,
                                        onPressed: () {
                                          context.read<BlocC>().submit(api: (filter, page, size, sort) {
                                            context.pop();
                                            context.pop();
                                            context.pop();
                                            return submit(null);
                                          });
                                        },
                                        child: Text('Đặt lại bộ lọc', style: TextStyle(color: CColor.primary)))),
                              if (check) const HSpacer(CSpace.xl3),
                              Expanded(child: BlocBuilder<BlocC, BlocS>(builder: (context, state) {
                                return ElevatedButton(
                                    onPressed: () {
                                      context.read<BlocC>().submit(api: (filter, page, size, sort) {
                                        context.pop();
                                        context.pop();
                                        context.pop();
                                        return submit(filter.values.toList().map((e) => e.toString()).toList());
                                      });
                                    },
                                    child: Text(
                                      submitText,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ));
                              })),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        }).then((value) {
      toDate = null;
      fromDate = null;
    });
  }

  static Future<dynamic> selectDate({
    DateTime? initialSelectedDate,
    required String name,
    String? limit,
  }) async {
    DateTime? limitDate = limit != null ? DateTime.parse(limit) : null;
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
              child: SizedBox(
                  width: 250,
                  child: SfDateRangePicker(
                    maxDate: name == 'fromDate' ? limitDate : null,
                    minDate: name == 'toDate' ? limitDate : null,
                    initialSelectedDate: initialSelectedDate,
                    initialDisplayDate: initialSelectedDate,
                    headerStyle: DateRangePickerHeaderStyle(textStyle: CStyle.title),
                    view: DateRangePickerView.month,
                    selectionMode: DateRangePickerSelectionMode.single,
                    onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                      if (name == 'toDate') {
                        toDate = args.value;
                      } else {
                        fromDate = args.value;
                      }
                      context.pop(args.value);
                    },
                  ))),
          contentPadding: const EdgeInsets.all(CSpace.sm),
        );
      },
    );
  }

  static Widget textFormField({
    required BuildContext context,
    required String label,
    required String name,
    required Function() onTap,
    String? value,
  }) {
    final TextEditingController textEditingController = TextEditingController();
    final OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(CSpace.xl)),
      borderSide: BorderSide(color: CColor.primary.shade200.withOpacity(0.2), width: 3),
    );
    final OutlineInputBorder errorBorderStyle = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(CSpace.xl)),
      borderSide: BorderSide(color: CColor.danger.shade200, width: 3),
    );
    if (value != null) {
      textEditingController.text = DateFormat('dd MMMM, yyyy', 'vi').format(DateTime.parse(value));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: CColor.black.shade400)),
        const SizedBox(height: CSpace.xl),
        TextFormField(
          controller: textEditingController,
          onTap: () async {
            var dateTime = await onTap();
            if (dateTime != null) {
              textEditingController.text = DateFormat('dd MMMM, yyyy', 'vi').format(dateTime);
              context.read<BlocC>().saved(name: name, value: dateTime.toIso8601String());
            }
          },
          readOnly: true,
          textInputAction: TextInputAction.next,
          style: TextStyle(color: CColor.primary),
          validator: (value) {
            if (value == '') {
              return 'widgets.form.input.rulesRequired'.tr(args: [label.toLowerCase()]);
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: 'dd/MM/YYYY',
            hintStyle: TextStyle(color: CColor.black.shade400, fontSize: CFontSize.sm),
            suffixIcon: Icon(Icons.calendar_month_rounded, color: CColor.primary),
            border: borderStyle,
            enabledBorder: borderStyle,
            focusedBorder: borderStyle,
            disabledBorder: borderStyle,
            errorBorder: errorBorderStyle,
            focusedErrorBorder: errorBorderStyle,
            fillColor: Colors.white,
            filled: true,
          ),
          minLines: 1,
        ),
      ],
    );
  }
}

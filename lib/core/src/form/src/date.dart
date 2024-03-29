import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

class WDate<T> extends StatefulWidget {
  final String name;
  final String label;
  final String value;
  final String? subtitle;
  final String? hintText;
  final bool space;
  final bool readOnly;
  final int maxLines;
  final bool required;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final String? icon;
  final bool stackedLabel;
  final bool showTime;
  final TextEditingController controller;
  final SelectDateType selectDateType;
  final DateRangePickerSelectionMode mode;
  final double? height;
  final double? width;
  final DateRangePickerView view;

  const WDate({
    super.key,
    this.label = '',
    this.value = '',
    this.subtitle = '',
    this.onChanged,
    this.required = false,
    this.enabled = true,
    this.space = false,
    this.readOnly = true,
    this.maxLines = 1,
    this.icon,
    required this.controller,
    this.selectDateType = SelectDateType.full,
    this.stackedLabel = false,
    this.showTime = false,
    this.hintText,
    this.mode = DateRangePickerSelectionMode.single,
    this.height,
    this.width,
    required this.name,
    this.view = DateRangePickerView.month,
  });

  @override
  State<WDate> createState() => _WDateState<T>();
}

class _WDateState<T> extends State<WDate> {
  @override
  Widget build(BuildContext context) {
    final double width =
        (CSpace.width / (widget.mode == DateRangePickerSelectionMode.single ? 1.15 : 2)) - (2 * CSpace.xl5);
    String mark = '';
    String format = '';
    switch(widget.view) {
      case DateRangePickerView.year:
        mark = '##/####';
        format = 'MM/yyyy';
        break;
      default:
        mark = '##/##/####';
        format = 'dd/MM/yyyy';
    }
    return WInput<T>(
      height: widget.height,
      width: widget.width,
      controller: widget.controller,
      hintText: widget.hintText ?? 'widgets.form.input.Choose'.tr(args: [widget.label.toLowerCase()]),
      rulesRequired: 'widgets.form.date.rulesRequired'.tr(),
      label: widget.label,
      value: widget.value != '' ?
        widget.mode == DateRangePickerSelectionMode.single
          ? Convert.dateLocation(selectedDateSingle!.toIso8601String())
          : Convert.dateTimeMultiple([selectedDateMultiple!.startDate!.toIso8601String(), selectedDateMultiple!.endDate!.toIso8601String()])
        : '',
      subtitle: widget.subtitle,
      space: widget.space,
      maxLines: widget.maxLines,
      required: widget.required,
      enabled: widget.enabled,
      stackedLabel: widget.stackedLabel,
      onChanged: (text) {
        if (widget.mode == DateRangePickerSelectionMode.single) {
          final List<String> dateTime = text.split('/');
          if (dateTime.length == 3 && dateTime[2].length == 4) {
            selectedDateSingle = DateTime.parse('${dateTime[2]}-${dateTime[1]}-${dateTime[0]}');
            widget.onChanged!(selectedDateSingle!.toIso8601String());
          }
        } else {
          final List<String> dateTime = text.split(' - ');
          final List<String> date1 = dateTime[0].split('/');
          final List<String> date2 = dateTime[1].split('/');
          if (date1.length < 3 || date1[2].length < 4 || date2.length < 3 || date2[2].length < 4) return;
          timeFrom = DateTime.parse('${date1[2]}-${date1[1]}-${date1[0]}');
          timeTo = DateTime.parse('${date2[2]}-${date2[1]}-${date2[0]}');
          selectedDateMultiple = PickerDateRange(timeFrom, timeTo);
        }
      },
      suffix: widget.enabled ? InkWell(
        splashColor: CColor.primary.shade100,
        onTap: () async => onTap(width: width, mark: mark, format:format),
        child: Icon(Icons.calendar_month_rounded, color: CColor.black.shade300, size: CFontSize.xl2)
      ) : const SizedBox(),
      onTap: widget.readOnly ? (_) async => onTap(width: width, mark: mark, format:format) : null,
      focus: false,
      focusNode: focusNode,
      icon: widget.icon,
      inputFormatters: [MaskTextInputFormatter(
        mask: widget.mode == DateRangePickerSelectionMode.single ? mark : '$mark - $mark',
        filter: { "#": RegExp(r'[0-9]') },
        type: MaskAutoCompletionType.lazy
      )],
    );
  }

  Future<void> onTap({required double width, required String mark, required String format}) async {
    if (intermediateDate != null) {
      if (widget.mode == DateRangePickerSelectionMode.single) {
        selectedDateSingle = intermediateDate;
      } else {
        selectedDateMultiple = intermediateDate;
      }
    }
    if (intermediateTimeFrom != null) {
      timeFrom = intermediateTimeFrom!;
    }
    if (intermediateTimeTo != null) {
      timeTo = intermediateTimeTo!;
    }
    focusNode.unfocus();

    return showDialog<dynamic>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
              child: SizedBox(
                  width: CSpace.width,
                  child: Column(
                    children: [
                      SfDateRangePicker(
                        maxDate: widget.selectDateType == SelectDateType.before ? DateTime.now() : null,
                        minDate: widget.selectDateType == SelectDateType.after ? DateTime.now() : null,
                        initialSelectedDate: selectedDateSingle,
                        initialSelectedDates: selectedDateMultiple != null
                            ? [
                          selectedDateMultiple!.startDate!,
                          selectedDateMultiple!.endDate ?? selectedDateMultiple!.startDate!
                        ]
                            : null,
                        initialDisplayDate: widget.mode == DateRangePickerSelectionMode.single
                            ? selectedDateSingle
                            : selectedDateMultiple?.startDate,
                        initialSelectedRange: selectedDateMultiple,

                        headerStyle: DateRangePickerHeaderStyle(textStyle: CStyle.title),
                        view: widget.view,
                        selectionMode: widget.mode,
                        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                          SchedulerBinding.instance.addPostFrameCallback((duration) async {
                            intermediateDate = args.value;
                          });
                        },
                        monthViewSettings: const DateRangePickerMonthViewSettings(
                          showWeekNumber: true,
                          showTrailingAndLeadingDates: true,
                        ),
                        allowViewNavigation: widget.view == DateRangePickerView.month,
                      ),
                      if (isShowTime)
                        SizedBox(
                          child: Column(
                            children: [
                              const VSpacer(CSpace.base),
                              Row(
                                children: [
                                  SizedBox(
                                    width: width,
                                    child: Text(
                                      '   ${'widgets.form.date.Time from'.tr()}',
                                      style:
                                      const TextStyle(fontWeight: FontWeight.w600, fontSize: CFontSize.base),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width,
                                    child: Text(
                                      '   ${'widgets.form.date.Time to'.tr()}',
                                      style:
                                      const TextStyle(fontWeight: FontWeight.w600, fontSize: CFontSize.base),
                                    ),
                                  ),
                                ],
                              ),
                              const VSpacer(CSpace.base),
                              Row(
                                children: [
                                  Container(
                                    height: 90,
                                    width: width,
                                    padding: const EdgeInsets.symmetric(horizontal: CSpace.xl),
                                    child: CupertinoTheme(
                                      data: CupertinoThemeData(
                                        textTheme: CupertinoTextThemeData(
                                          dateTimePickerTextStyle:
                                          TextStyle(fontSize: CFontSize.xs, color: CColor.black),
                                        ),
                                      ),
                                      child: CupertinoDatePicker(
                                        mode: CupertinoDatePickerMode.time,
                                        use24hFormat: true,
                                        initialDateTime: timeFrom,
                                        onDateTimeChanged: (DateTime value) => intermediateTimeFrom = value,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 90,
                                    width: width,
                                    padding: const EdgeInsets.symmetric(horizontal: CSpace.xl),
                                    child: CupertinoTheme(
                                      data: CupertinoThemeData(
                                        textTheme: CupertinoTextThemeData(
                                          dateTimePickerTextStyle:
                                          TextStyle(fontSize: CFontSize.xs, color: CColor.black),
                                        ),
                                      ),
                                      child: CupertinoDatePicker(
                                        mode: CupertinoDatePickerMode.time,
                                        use24hFormat: true,
                                        initialDateTime: timeTo,
                                        onDateTimeChanged: (DateTime value) => intermediateTimeTo = value,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      line(margin: const EdgeInsets.only(top: CSpace.xl4)),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => context.pop(),
                              highlightColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: CSpace.xl),
                                child: Text(
                                  'widgets.form.upload.Cancel'.tr(),
                                  style: TextStyle(color: CColor.black.shade300),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          line(width: 0.5, height: 33),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                if (widget.onChanged != null) {
                                  initializeDateFormatting();
                                  if (widget.mode == DateRangePickerSelectionMode.single) {
                                    if (intermediateDate != null) {
                                      selectedDateSingle = intermediateDate;
                                    }
                                    if (selectedDateSingle == null) {
                                      UDialog().showError(text: 'widgets.form.date.Error message'.tr());
                                      return;
                                    }
                                    widget.controller.text =
                                        Convert.dateLocation(selectedDateSingle!.toIso8601String(), format: format);
                                    widget.onChanged!(selectedDateSingle!.toIso8601String());
                                  } else {
                                    if (intermediateDate != null) {
                                      selectedDateMultiple = intermediateDate;
                                    }
                                    if (intermediateTimeFrom != null) {
                                      timeFrom = intermediateTimeFrom!;
                                    }
                                    if (intermediateTimeTo != null) {
                                      timeTo = intermediateTimeTo!;
                                    }
                                    if (selectedDateMultiple == null) {
                                      UDialog().showError(text: 'widgets.form.date.Error message'.tr());
                                      return;
                                    }
                                    if (selectedDateMultiple!.startDate == null ||
                                        selectedDateMultiple!.endDate == null) {
                                      selectedDateMultiple = PickerDateRange(
                                        selectedDateMultiple!.startDate ?? selectedDateMultiple!.endDate,
                                        selectedDateMultiple!.endDate ?? selectedDateMultiple!.startDate,
                                      );
                                    }

                                    final DateTime startDate = selectedDateMultiple!.startDate!.copyWith(
                                      hour: isShowTime ? timeFrom.hour : null,
                                      minute: isShowTime ? timeFrom.minute : null,
                                    );
                                    final DateTime endDate = selectedDateMultiple!.endDate!.copyWith(
                                      hour: isShowTime ? timeTo.hour : null,
                                      minute: isShowTime ? timeTo.minute : null,
                                    );

                                    selectedDateMultiple = PickerDateRange(startDate, endDate);
                                    widget.controller.text = Convert.dateTimeMultiple(
                                        [startDate.toIso8601String(), endDate.toIso8601String()],
                                        format: format
                                    );
                                    widget.onChanged!(
                                        '${selectedDateMultiple!.startDate!.toIso8601String()}|${selectedDateMultiple!.endDate!.toIso8601String()}');
                                  }
                                  await UDialog().delay();
                                  UDialog().stopLoading();
                                  context.pop({
                                    'intermediateDate': intermediateDate,
                                    'intermediateTimeFrom': intermediateTimeFrom,
                                    'intermediateTimeTo': intermediateTimeTo
                                  });
                                }
                              },
                              highlightColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: CSpace.xl),
                                child: Text(
                                  'widgets.form.date.Save'.tr(),
                                  style: TextStyle(color: CColor.primary, fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ))),
          contentPadding: const EdgeInsets.all(CSpace.sm),
        );
      },
    ).then((value) {
      intermediateDate = value?['intermediateDate'];
      intermediateTimeFrom = value?['intermediateTimeFrom'];
      intermediateTimeTo = value?['intermediateTimeTo'];
    });
  }

  FocusNode focusNode = FocusNode();
  DateTime? selectedDateSingle;
  PickerDateRange? selectedDateMultiple;
  DateTime timeFrom = DateTime.now();
  DateTime timeTo = DateTime.now();
  late final bool isShowTime = widget.showTime && widget.mode != DateRangePickerSelectionMode.single;
  dynamic intermediateDate;
  DateTime? intermediateTimeFrom;
  DateTime? intermediateTimeTo;

  @override
  void initState() {
    if (widget.value != '') {
      if (widget.mode == DateRangePickerSelectionMode.single) {
        selectedDateSingle = DateTime.parse(widget.value);
      } else {
        final List<String> dateTime = widget.value.split('|');
        timeFrom = DateTime.parse(dateTime[0]);
        timeTo = DateTime.parse(dateTime[1]);
        selectedDateMultiple = PickerDateRange(timeFrom, timeTo);
        widget.controller.text = Convert.dateTimeMultiple(
            [selectedDateMultiple!.startDate!.toIso8601String(), selectedDateMultiple!.endDate!.toIso8601String()]);
      }
    }
    super.initState();
  }
}

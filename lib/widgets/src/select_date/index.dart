import 'package:flutter/material.dart';

import '/constants/index.dart';
import '/utils/index.dart';
import '/core/index.dart';

part '_title.dart';

class SelectDate extends StatefulWidget {
  final EdgeInsets? margin;
  final DateTime? initialFromDate;
  final DateTime? initialToDate;
  final Function(String fromDate, String toDate) onChanged;

  const SelectDate({
    Key? key,
    this.margin,
    required this.onChanged,
    this.initialFromDate,
    this.initialToDate,
  }) : super(key: key);

  @override
  State<SelectDate> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {
  @override
  Widget build(BuildContext context) {
    const Color strokeColor = Color(0xffc2c2c2);
    return Container(
      margin: widget.margin,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: strokeColor),
          borderRadius: BorderRadius.circular(3),
          color: Colors.white,
          // boxShadow: [Utils.mediumBoxShadow],
        ),
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            _dateTitle(title: 'Từ', date: _fromDate, onPressed: fromDate),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 1, color: strokeColor)),
              child: Icon(Icons.date_range, size: 20, color: CColor.hintColor),
            ),
            _dateTitle(title: 'Đến', date: _toDate, onPressed: toDate),
            InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                if (_fromDate != '' && _toDate != '') {
                  widget.onChanged('', '');
                }
                setState(() {
                  _fromDate = '';
                  _toDate = '';
                  _initialFromDate = DateTime.now();
                  _initialToDate = DateTime.now();
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Icons.close, color: CColor.primary, size: 20),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _fromDate = '';
  String _toDate = '';

  DateTime _initialFromDate = DateTime.now();
  DateTime _initialToDate = DateTime.now();

  @override
  void initState(){
    if (widget.initialFromDate != null){
      _initialFromDate = widget.initialFromDate!;
      _fromDate = Convert.date(_initialFromDate.toIso8601String());
    }
    if (widget.initialToDate != null){
      _initialToDate = widget.initialToDate!;
      _toDate = Convert.date(_initialToDate.toIso8601String());
    }
    super.initState();
  }

  Future<void> fromDate() async {
    final picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2022),
        lastDate: DateTime.now(),
        locale: const Locale('vi'),
        initialDate: _initialFromDate.compareTo(_initialToDate) > 0 ? _initialToDate : _initialFromDate,
        currentDate: _initialToDate,
        selectableDayPredicate: (dateTime) {
          if (_toDate != '') {
            if (dateTime.compareTo(_initialToDate) > 0) {
              return false;
            }
          }
          return true;
        });
    if (picked != null) {
      setState(() {
        _initialFromDate = picked;
        _fromDate = Convert.date(_initialFromDate.toIso8601String());
        if (_toDate != '') {
          widget.onChanged(
            _initialFromDate.toIso8601String(),
            _initialToDate.toIso8601String(),
          );
        }
      });
    }
  }

  Future<void> toDate() async {
    final picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2022),
        lastDate: DateTime.now(),
        locale: const Locale('vi'),
        initialDate: _initialToDate,
        currentDate: _initialFromDate,
        selectableDayPredicate: (dateTime) {
          if (_fromDate != '') {
            if (dateTime.compareTo(_initialFromDate) < 0) {
              return false;
            }
          }
          return true;
        });
    if (picked != null) {
      setState(() {
        _initialToDate = picked;
        _toDate = Convert.date(_initialToDate.toIso8601String());
        if (_fromDate != '') {
          widget.onChanged(
            _initialFromDate.toIso8601String(),
            _initialToDate.toIso8601String(),
          );
        }
      });
    }
  }
}

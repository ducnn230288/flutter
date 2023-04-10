import 'package:flutter/material.dart';

import '/constants/index.dart';
import '/models/common/form.dart';

listHorizontal({required List<MOption> list, required String value, required Function setValue, double height = 40}) =>
    Container(
      margin: const EdgeInsets.symmetric(horizontal: CSpace.large, vertical: CSpace.medium),
      height: height,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          ...List.generate(list.length, (index) {
            MOption item = list[index];
            return Row(
              children: [
                SizedBox(
                  width: item.label.length * 9.5,
                  child: OutlinedButton(
                    style: item.value == value ? CStyle.buttonOutlinePrimary : CStyle.buttonOutline,
                    onPressed: () {
                      setValue(item.value);
                    },
                    child: Text(
                      item.label,
                      style: TextStyle(
                          color: item.value == value ? Colors.white : CColor.black, fontSize: CFontSize.paragraph2),
                    ),
                  ),
                ),
                SizedBox(
                  width: list.length - 1 != index ? CSpace.medium : 0,
                ),
              ],
            );
          }),
        ],
      ),
    );

part of 'index.dart';

_dateTitle({required String title, required String date, required Function() onPressed}) =>Expanded(
    child: InkWell(
      onTap: () {
        onPressed();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      child: Text(
                        title,
                        style: TextStyle(fontSize: CFontSize.caption2, color: CColor.hintColor),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Center(
                    child: Text(
                      date,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 10)
              ],
            ),
          ),
          line(margin: const EdgeInsets.symmetric(horizontal: CSpace.medium))
        ],
      ),
    ));

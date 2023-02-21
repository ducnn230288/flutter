import 'package:flutter/material.dart';

import '/utils.dart';

appBar(title, height, context, h) => PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, height + h),
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.transparent,
            height: height + h,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 13.0 + h),
            child: Center(
              child: Text(
                title,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w800, color: AppThemes.blackColor),
              ),
            ),
          ),
          Positioned(
            top: AppThemes.gap + h,
            left: AppThemes.gap,
            right: AppThemes.gap,
            child: AppBar(
              toolbarHeight: 40,
              leadingWidth: 40,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              leading: ElevatedButton(
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 18.0,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              primary: false,
            ),
          )
        ],
      ),
    );

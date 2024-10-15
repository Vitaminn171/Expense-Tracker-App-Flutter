import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class BackgroundWidget extends StatelessWidget {

  AlignmentDirectional? alignmentDirectional;
  double? imgHeight;

  BackgroundWidget({super.key,
    this.alignmentDirectional,
    this.imgHeight
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignmentDirectional ?? const AlignmentDirectional(0, 0),
      child: ClipRect(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: 2,
            sigmaY: 2,
          ),
          child: Align(
            alignment: alignmentDirectional ?? const AlignmentDirectional(0, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.asset(
                'assets/images/back.jpg',
                width: double.infinity,
                height: imgHeight ?? double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
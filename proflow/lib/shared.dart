// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

const Map<String, Map<String, dynamic>> themes = {
  "proflow": {
    "gradient": [
      Color(0xFF1C1B22),
      Color(0xFF2A2A2E),
      Color(0xFF2A2A2E),
    ],
    "button": Color.fromARGB(255, 175, 174, 174),
    "shadow": Color.fromARGB(255, 243, 237, 237),
    "foreground": Color(0xFFf2f0ec),
  },
  "purple-haze": {
    "gradient": [Color(0xFF210535), Color(0xFF430d4b)],
    "button": Color(0xFF7b337d),
    "shadow": Color(0xFFc874b2),
    "foreground": Color(0xFFf5d5e0),
  },
  "swiss-chalet": {
    "gradient": [Color.fromARGB(255, 38, 38, 38), Color(0xFF41474a)],
    "button": Color(0xFF81847d),
    "shadow": Color(0xFFb9c1b9),
    "foreground": Color(0xFFf2f0ec),
  },
  "cherry-blossom": {
    "gradient": [Color(0xFFbc244a), Color(0xFFf25477)],
    "button": Color(0xFFffa7a6),
    "shadow": Color(0xFFffdcdc),
    "foreground": Color.fromARGB(255, 239, 240, 243),
  },
  "business-man": {
    "gradient": [Color(0xFF090d11), Color(0xFF48596c)],
    "button": Color(0xFFa1aab3),
    "shadow": Color(0xFFe1e4eb),
    "foreground": Color(0xFFfffffd),
  },
  "avatar": {
    "gradient": [Color(0xFF0F2347), Color(0xFF1C3F6E), Color(0xFF2E67A0)],
    "button": Color(0xFF5AACCF),
    "shadow": Color(0xFFEFFC93),
    "foreground": Color(0xFFC0E1B8),
  }
};

enum ToolLabel {
  Calculator,
  Alarm_Timer,
  Notes,
  Todos__List,
  Dictionary,
  Reminder,
  Email,
  Screen__Recorder,
  Settings,
  Exit;

  String get labelName => name.replaceAll('__', ' ').replaceAll('_', '/');
}

const double defaultHeight = 70;
const double maxExtendHeight = 550;
const double btnWidth = 79;
const double btnHeight = 70;

void resizeUI(Size toSize) {
  appWindow.minSize = toSize;
  appWindow.maxSize = toSize;
  appWindow.size = toSize;
}

void moveUI(Offset offset) {
  appWindow.position += offset;
}

Timer? animationTimer;

Function postAnimationCall = () {};
void callAfterDelay(Function postCall,
    {Duration delay = const Duration(milliseconds: 500)}) {
  Future.delayed(delay, () {
    postCall();
  });
}

bool isTolerateOrExceed(
    double current, double start, double end, double tolerance) {
  double direction = (end - start);
  if (direction == 0) return true;
  if (direction > 0 && (current < start || current >= end)) return true;
  if (direction < 0 && (current > start || current <= end)) return true;

  double disToEnd = (end - current);
  return disToEnd.abs() <= tolerance.abs();
}

void stopAnimationTimer() {
  if (animationTimer != null) {
    animationTimer!.cancel();
  }
}

void setPostAnimation(Function postCall) {
  postAnimationCall = postCall;
}

void addAdditionalPostAnimation(Function additionalCall) {
  Function lastPostAnimation = postAnimationCall;
  postAnimationCall = () async {
    await lastPostAnimation();
    additionalCall();
  };
}

void usePostAnimation() {
  postAnimationCall();
  postAnimationCall = () {};
}

void animateResize(Size toSize,
    {double percentChangePerTime = 0.07,
    double tolerance = 3,
    double percentChangeAcc = 0.01}) {
  double startHeight = appWindow.size.height;
  double startWidth = appWindow.size.width;
  animationTimer = Timer.periodic(const Duration(microseconds: 6500), (timer) {
    Size currentSize = appWindow.size;
    double lastWidth = currentSize.width, lastHeight = currentSize.height;
    double diffWidth = toSize.width - lastWidth;
    double diffHeight = toSize.height - lastHeight;
    double newWidth = lastWidth + (percentChangePerTime * diffWidth);
    double newHeight = lastHeight + (percentChangePerTime * diffHeight);
    //unsignificant change
    if (lastHeight.round() == newHeight.round() ||
        lastWidth.round() == newWidth.round()) {
      percentChangePerTime += percentChangeAcc;
    }

    resizeUI(Size(newWidth, newHeight));
    if (isTolerateOrExceed(newWidth, startWidth, toSize.width, tolerance) &&
        isTolerateOrExceed(newHeight, startHeight, toSize.height, tolerance)) {
      resizeUI(toSize);
      timer.cancel();
      usePostAnimation();
    }
  });
}

void animateMove(double dx, double dy,
    {double percentChangePerTime = 0.05, double tolerance = 0.5}) {
  double totalMoveX = 0, totalMoveY = 0;
  double finalPosX = appWindow.position.dx + dx,
      finalPosY = appWindow.position.dy + dy;

  animationTimer = Timer.periodic(const Duration(microseconds: 7000), (timer) {
    double moveX = dx * percentChangePerTime, moveY = dy * percentChangePerTime;

    Offset move = Offset(moveX, moveY);
    totalMoveX += moveX;
    totalMoveY += moveY;
    moveUI(move);

    if (isTolerateOrExceed(totalMoveX, 0, dx, tolerance) &&
        isTolerateOrExceed(totalMoveY, 0, dy, tolerance)) {
      appWindow.position = Offset(finalPosX, finalPosY);
      // debugPrint("end: ${finalPosX}, ${finalPosY}");
      timer.cancel();
      usePostAnimation();
    }
  });
}

// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:proflow/models/dictionary_m.dart';
import 'package:proflow/models/word.dart';
import 'package:proflow/screens/dictionary.dart';

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

String capitalize(String word) =>
    "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}";

const String appName = "proflow";
String appNameCap = capitalize(appName);

Map<ToolLabel, dynamic> easterEggs = {
  ToolLabel.Dictionary: DictionaryM(words: [
    Word(
      word: appNameCap,
      defAndExamples: {
        "A productivity desktop-app, which boosts efficiency through various tools like: an alarm, timer, to-do list, calculator, screen recorder, and etc.":
            [
          "The Proflow software, is the best productivity booster on the market."
        ]
      },
      audioUrl: "assets/app_name.mp3",
      partOfSpeech: "Noun",
      pronounciation: "/proʊ floʊ/",
      synonyms: ["Software", "Productivity", "Efficiency"],
    )
  ])
};

const double defaultHeight = 70;
const double maxExtendHeight = 550;
const double btnWidth = 79;
const double btnHeight = 70;

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

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

// void addAdditionalPostAnimation(Function additionalCall) {
//   Function lastPostAnimation = postAnimationCall;
//   postAnimationCall = () async {
//     await lastPostAnimation();
//     additionalCall();
//   };
// }

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

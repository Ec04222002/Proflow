// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:proflow/shared.dart';
import '/services/hot_keys.dart';
import 'package:window_manager/window_manager.dart';

import 'package:proflow/screens/calculator.dart';
import 'package:proflow/screens/email.dart';
import 'package:proflow/screens/notes.dart';
import 'package:proflow/screens/reminder.dart';
import 'package:proflow/screens/screen_recorder.dart';
import 'package:proflow/screens/settings.dart';
import 'package:proflow/screens/alarm_timer.dart';
import 'package:proflow/screens/todo_list.dart';
import 'package:proflow/screens/dictionary.dart';

class Tools with ChangeNotifier {
  dynamic currentTheme = themes["avatar"];
  bool isMainPanelClosed = true;
  bool isToolTipPanelClosed = true;
  bool isUsingKeys = false;
  bool isCurrentExiting = false;
  bool containsHover = false;
  bool containsActive = false;

  final double bottomToolTipMargin = 20;
  final double bottomMarginRate = 0.01;
  final double bottomMarginAcc = 0.005;
  final double bottomMarginTolerance = 3.5;
  HotKeys hotKeys = HotKeys();
  Widget currentMainWidget = const SizedBox(
    width: 0,
    height: 0,
  );
  Map<ToolLabel, Map<String, dynamic>> tools = {
    ToolLabel.Calculator: {
      "widget": const Calculator(),
      "icon": const Icon(Ionicons.calculator_outline, size: 30),
      "isActive": false,
      "isHovered": false,
      "isSaved": true,
      "toolTipKey": null,
    },
    ToolLabel.Alarm_Timer: {
      "widget": const AlarmAndTimer(),
      "icon": const Icon(Ionicons.alarm_outline, size: 30),
      "isActive": false,
      "isHovered": false,
      "isSaved": true,
      "toolTipKey": null,
    },
    ToolLabel.Notes: {
      "widget": const Notes(),
      "icon": const Icon(LineIcons.stickyNote, size: 30),
      "isActive": false,
      "isHovered": false,
      "isSaved": true,
      "toolTipKey": null,
    },
    ToolLabel.Todos__List: {
      "widget": const TodosList(),
      "icon": const Icon(LineIcons.check, size: 30),
      "isActive": false,
      "isHovered": false,
      "isSaved": true,
      "toolTipKey": null,
    },
    ToolLabel.Dictionary: {
      "widget": const Dictionary(),
      "icon": const Icon(LineIcons.spellCheck, size: 30),
      "isActive": false,
      "isHovered": false,
      "isSaved": true,
      "toolTipKey": null,
    },
    ToolLabel.Reminder: {
      "widget": const Reminder(),
      "icon": const Icon(LineIcons.bell, size: 30),
      "isActive": false,
      "isHovered": false,
      "isSaved": true,
      "toolTipKey": null,
    },
    ToolLabel.Email: {
      "widget": const Email(),
      "icon": const Icon(LineIcons.envelope, size: 30),
      "isActive": false,
      "isHovered": false,
      "isSaved": true,
      "toolTipKey": null,
    },
    ToolLabel.Screen__Recorder: {
      "widget": const ScreenRecorder(),
      "icon": const Icon(LineIcons.video, size: 30),
      "isActive": false,
      "isHovered": false,
      "isSaved": true,
      "toolTipKey": null,
    },
    ToolLabel.Settings: {
      "widget": const Settings(),
      "icon": const Icon(LineIcons.cog, size: 30),
      "isActive": false,
      "isHovered": false,
      "isSaved": true,
      "toolTipKey": null,
    },
    ToolLabel.Exit: {
      "icon": const Icon(LineIcons.timesCircle, size: 30),
      "isActive": false,
      "isHovered": false,
      "isSaved": true,
      "toolTipKey": null,
    },
  };
  //update firebase and local tools
  // Map<ToolLabel, Map<String, dynamic>> add(ToolLabel label) {}
  // Map<ToolLabel, Map<String, dynamic>> remove(ToolLabel label) {}

  Map<ToolLabel, Map<String, dynamic>> get allTools => tools;
  Map<ToolLabel, Map<String, dynamic>> get activeTools =>
      Map.from(tools)..removeWhere((_, value) => !value['isActive']);
  Map<ToolLabel, Map<String, dynamic>> get savedTools =>
      Map.from(tools)..removeWhere((_, value) => !value['isSaved']);
  Map<ToolLabel, Map<String, dynamic>> get hoveredTools =>
      Map.from(tools)..removeWhere((_, value) => !value['isHovered']);
  List<ToolLabel> toToolList(Map<ToolLabel, Map<String, dynamic>> toolMap) =>
      toolMap.keys.toList();
  int getCurrentActiveIndex() {
    if (activeTools.isEmpty) return 0;

    ToolLabel tool = toToolList(activeTools)[0];
    int currentActiveIndex = toToolList(savedTools).indexOf(tool);

    //can't find tool in saved list;
    if (currentActiveIndex == -1) {
      throw "Cannot find $tool in active tools";
    }
    return currentActiveIndex;
  }

  int getCurrentHoveredIndex() {
    if (hoveredTools.isEmpty) return getCurrentActiveIndex();

    ToolLabel tool = toToolList(hoveredTools)[0];
    int currentHoverIndex = toToolList(savedTools).indexOf(tool);

    if (currentHoverIndex == -1) {
      throw "Cannot find $tool in hovered tools";
    }

    return currentHoverIndex;
  }

  ToolLabel get hoveredLabel =>
      toToolList(savedTools)[getCurrentHoveredIndex()];
  ToolLabel get activeLabel => toToolList(savedTools)[getCurrentActiveIndex()];
  dynamic get theme => currentTheme;
  double get buttonBarWidth => btnWidth * tools.length;
  Widget get mainWidget => currentMainWidget;

  bool isOpenToolTipPanel(isHover) =>
      isHover && isMainPanelClosed && isToolTipPanelClosed && !isCurrentExiting;

  void setToolTipKey(ToolLabel toolLabel, GlobalKey key) {
    tools[toolLabel]!['toolTipKey'] = key;
  }

  //set local from firebase
  void setInitTools() {}
  void setInitTheme() {}

  void setMainWidget(Widget assignWidget) {
    currentMainWidget = assignWidget;
  }

  //set local from local settings
  void setHover(ToolLabel label, bool newHover) {
    bool currentToolHover = tools[label]!['isHovered'];
    if (newHover == currentToolHover) return;

    tools[label]!['isHovered'] = newHover;
    // debugPrint("${label} is hovered: ${newHover}");
    containsHover = hoveredTools.isNotEmpty;
    isUsingKeys = false;
    notifyListeners();
    // debugPrint("in set hover");
  }

  void setActive(ToolLabel label, bool newActive) {
    bool currentToolActive = tools[label]!['isActive'];
    if (newActive == currentToolActive) return;

    tools[label]!['isActive'] = newActive;
    containsActive = activeTools.isNotEmpty;
    if (!containsActive) {
      isMainPanelClosed = true;
    }
    isUsingKeys = false;
    notifyListeners();
  }

  void setSaved(ToolLabel label, bool newSave) {
    tools[label]!['isSaved'] = newSave;
    notifyListeners();
  }

  void defaultToolActive({bool toActive = false}) {
    tools.forEach((_, value) {
      value['isActive'] = toActive;
    });
    containsActive = false;
    notifyListeners();
  }

  void defaultToolHover({bool toHover = false}) {
    tools.forEach((_, value) {
      value['isHovered'] = toHover;
      final dynamic toolTip = value['toolTipKey'].currentState;
      toolTip.deactivate();
    });
    containsHover = false;
    notifyListeners();
  }

//hot key function
  int validateNavDisp(int displace) {
    if (!containsHover && !containsActive) return 0;
    return displace;
  }

  void nav(int? displace, {int? index}) {
    List<ToolLabel> savedToolList = toToolList(savedTools);

    if (index != null) {
      handleHover(savedToolList[index], true);
      isUsingKeys = true;
      return;
    }
    int disp = validateNavDisp(displace!);
    int endIndex = (getCurrentHoveredIndex() + disp) % savedToolList.length;
    ToolLabel hoverTool = savedToolList[endIndex];
    handleHover(hoverTool, true);
    isUsingKeys = true;
  }

  void enter() {
    // debugPrint("enter");
    ToolLabel hoverTool = hoveredLabel;
    bool isActive = tools[hoverTool]!['isActive'];
    //was active => closing
    handlePress(hoverTool, !isActive);

    isUsingKeys = true;
  }

  void handlePress(ToolLabel toolLabel, bool toActive) {
    defaultToolHover();
    //toggle button
    if (toolLabel != ToolLabel.Exit) {
      defaultToolActive();
      setActive(toolLabel, toActive);
      //was active
      if (!toActive) {
        animateClosePanel();
      } else {
        animateOpenPanel();
        showMainWidget(toolLabel);
      }
    } else {
      animateExitTool();
    }
  }

  void handleHover(ToolLabel toolLabel, bool toHover) {
    // debugPrint("in handlehover");
    if (toHover) {
      defaultToolHover();
      final dynamic tooltip = tools[toolLabel]!['toolTipKey'].currentState;

      tooltip.ensureTooltipVisible();
    }

    if (isOpenToolTipPanel(toHover)) {
      // debugPrint("adding margin panel");
      openBottomMargin();
    }
    setHover(toolLabel, toHover);
  }

//animations
  void animateExitTool() {
    isCurrentExiting = true;
    final Function savedPostFunction = postAnimationCall;
    setPostAnimation(() async {
      // debugPrint('in post of animeExitTool');
      isCurrentExiting = false;
      await exitPostMove();

      //undo hover on exit button
      if (!containsActive) {
        resizeUI(Size(buttonBarWidth, btnHeight));
        isToolTipPanelClosed = true;
        isMainPanelClosed = true;
      }
      savedPostFunction();
    });
    animateMove(0, -appWindow.size.height);
  }

  Future<void> exitPostMove() async {
    await windowManager.setOpacity(0);
    await windowManager.setAlignment(Alignment.topRight);
    await windowManager.minimize();
    await windowManager.setOpacity(1);
  }

  void showMainWidget(ToolLabel showTool) {
    Widget currentWidget = tools[showTool]!["widget"];
    setMainWidget(currentWidget);
    notifyListeners();
  }

  void animateOpenPanel({double toHeight = maxExtendHeight}) {
    stopAnimationTimer();
    animateResize(Size(buttonBarWidth, toHeight));
    isMainPanelClosed = false;
  }

  void animateClosePanel() {
    // debugPrint(isMainPanelClosed.toString());
    stopAnimationTimer();

    //closing bottomTooltip
    if (containsHover) {
      // debugPrint("in first");
      animateResize(Size(buttonBarWidth, defaultHeight + bottomToolTipMargin));
    } else if (isMainPanelClosed && !isToolTipPanelClosed) {
      // debugPrint('only small panel');
      animateResize(Size(buttonBarWidth, defaultHeight),
          percentChangePerTime: bottomMarginRate,
          percentChangeAcc: bottomMarginAcc,
          tolerance: bottomMarginTolerance);
    } else {
      animateResize(Size(buttonBarWidth, defaultHeight));
    }

    isMainPanelClosed = true;
    isToolTipPanelClosed = true;
  }

  void openBottomMargin() {
    stopAnimationTimer();
    animateResize(Size(buttonBarWidth, btnHeight + bottomToolTipMargin),
        percentChangePerTime: bottomMarginRate,
        percentChangeAcc: bottomMarginAcc,
        tolerance: bottomMarginTolerance);
    isToolTipPanelClosed = false;
  }
}

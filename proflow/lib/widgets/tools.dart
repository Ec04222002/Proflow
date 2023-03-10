// ignore_for_file: non_constant_identifier_names
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import '../providers/tools_provider.dart';
import 'tool_button.dart';
import '/shared.dart';

class ToolsUI extends StatefulWidget {
  const ToolsUI({Key? key}) : super(key: key);

  @override
  State<ToolsUI> createState() => _ToolsUIState();
}

class _ToolsUIState extends State<ToolsUI> {
  @override
  Widget build(BuildContext context) {
    Tools toolsProvider = context.watch<Tools>();
    Widget mainWidget = toolsProvider.mainWidget;

    void mouseExit() {
      bool isShouldClose =
          !toolsProvider.containsActive && !toolsProvider.isCurrentExiting;
      toolsProvider.defaultToolHover();
      if (isShouldClose) {
        toolsProvider.animateClosePanel();
      }
    }

    return Scaffold(
      body: Center(
        child: MouseRegion(
          onExit: (_) => mouseExit(),
          onEnter: (_) async => await windowManager.focus(),
          child: FocusScope(
            child: Focus(
              onKey: (_, __) => KeyEventResult.ignored,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: context.read<Tools>().theme['gradient'],
                )),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topCenter,
                      child: ToolBar(),
                    ),
                    Expanded(child: mainWidget),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ToolBar extends StatefulWidget {
  const ToolBar({super.key});

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  dynamic currentTheme;

  Color? btnClr;
  Color? shadow;
  Color? foreground;
  final double _elevation = 7;
  List<Widget> getTools(Map<ToolLabel, Map<String, dynamic>> savedTools) {
    final tools = <Widget>[];
    savedTools.forEach((toolStatus, toolParam) {
      tools.add(ToolButton(
          elevation: _elevation,
          shadow: shadow,
          btnClr: btnClr,
          foreground: foreground,
          icon: toolParam['icon'],
          label: toolStatus));
    });

    return tools;
  }

  @override
  Widget build(BuildContext context) {
    Tools currentTools = context.watch<Tools>();
    currentTheme = currentTools.theme;
    btnClr = currentTheme["button"];
    shadow = currentTheme["shadow"];
    foreground = currentTheme["foreground"];
    return ButtonBar(children: getTools(currentTools.savedTools));
  }
}

import "package:flutter/material.dart";
import 'package:proflow/models/dictionary_m.dart';
import 'package:proflow/screens/dictionary.dart';
import 'package:proflow/services/theme.dart';
import "package:proflow/shared.dart";
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../providers/tools_provider.dart';
import 'package:proflow/screens/dictionary.dart';

class ToolButton extends StatefulWidget {
  final Icon icon;
  final ToolLabel label;
  const ToolButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  State<ToolButton> createState() => _ToolButtonState();
}

class _ToolButtonState extends State<ToolButton> {
  final _key = GlobalKey();
  final double pressBorderWidth = 4;
  final double activeBorderWidth = 3;
  final double hoverBorderWidth = 2;
  late double borderWidth;
  bool isPressed = false;
  @override
  void initState() {
    super.initState();
    borderWidth = hoverBorderWidth;
  }

  @override
  Widget build(BuildContext context) {
    final Tools toolsProvider = context.read<Tools>();
    final Color foreground =
        themes[currentTheme.text]![colorType.foreground.text];
    bool isActive = toolsProvider.tools[widget.label]!['isActive'];
    bool isHovered = toolsProvider.tools[widget.label]!['isHovered'];

    if (isHovered) borderWidth = hoverBorderWidth;
    if (isActive) borderWidth = activeBorderWidth;
    if (isPressed) borderWidth = pressBorderWidth;
    ToolLabel toolLabel = widget.label;
    toolsProvider.setToolTipKey(toolLabel, _key);

    // debugPrint(toolsProvider.isUsingKeys.toString());
    void handlePress() {
      toolsProvider.handlePress(toolLabel, !isActive);
    }

    void handleHover(bool hover) {
      // debugPrint("in tool button");
      toolsProvider.handleHover(toolLabel, hover);
    }

    return Listener(
      onPointerDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onPointerUp: (_) {
        setState(() {
          isPressed = false;
        });
      },
      // ignore: avoid_returning_null_for_void
      onPointerHover: (_) => null,
      child: Tooltip(
        message: widget.label.labelName,
        key: _key,
        child: ElevatedButton(
          onPressed: handlePress,
          onHover: (isHover) => handleHover(isHover),
          style: ElevatedButton.styleFrom(
            foregroundColor: isHovered || isActive
                ? foreground.withOpacity(1)
                : foreground.withOpacity(0.7),
            side: isHovered || isActive
                ? BorderSide(
                    color: foreground,
                    width: borderWidth,
                  )
                : const BorderSide(color: Colors.transparent, width: 0),
          ),
          child: widget.icon,
        ),
      ),
    );
  }
}

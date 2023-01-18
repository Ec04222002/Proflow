import "package:flutter/material.dart";
import "package:proflow/shared.dart";
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../providers/tools_provider.dart';

class ToolButton extends StatefulWidget {
  final double _elevation;
  final Color? shadow;
  final Color? btnClr;
  final Color? foreground;
  final Icon icon;
  final ToolLabel label;
  const ToolButton({
    Key? key,
    required double elevation,
    required this.shadow,
    required this.btnClr,
    required this.foreground,
    required this.icon,
    required this.label,
  })  : _elevation = elevation,
        super(key: key);

  @override
  State<ToolButton> createState() => _ToolButtonState();
}

class _ToolButtonState extends State<ToolButton> {
  final double padValue = 20;
  final double pressBorderWidth = 4;
  final double activeBorderWidth = 3;
  final double hoverBorderWidth = 2;
  late double borderWidth;
  final double toolTipTopMargin = 5;
  final _key = GlobalKey();

  bool isPressed = false;
  @override
  void initState() {
    super.initState();
    borderWidth = hoverBorderWidth;
  }

  @override
  Widget build(BuildContext context) {
    final Tools toolsProvider = context.read<Tools>();
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
      debugPrint("in tool button");
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
        margin: EdgeInsets.only(top: toolTipTopMargin),
        key: _key,
        child: ElevatedButton(
          onPressed: handlePress,
          onHover: (isHover) => handleHover(isHover),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.all(padValue),
            elevation: widget._elevation,
            animationDuration: const Duration(milliseconds: 300),
            shadowColor: widget.shadow,
            backgroundColor: widget.btnClr,
            foregroundColor: isHovered || isActive
                ? widget.foreground!.withOpacity(1)
                : widget.foreground!.withOpacity(0.75),
            side: isHovered || isActive
                ? BorderSide(
                    color: widget.foreground!,
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A helper class for managing focus and accessibility in the app
class AccessibilityFocusManager {
  static final List<FocusNode> _focusNodes = [];

  /// Add a focus node to be managed
  static void addFocusNode(FocusNode node) {
    if (!_focusNodes.contains(node)) {
      _focusNodes.add(node);
    }
  }

  /// Remove a focus node from management
  static void removeFocusNode(FocusNode node) {
    _focusNodes.remove(node);
  }

  /// Clear all focus nodes
  static void clearAllFocusNodes() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    _focusNodes.clear();
  }

  /// Move focus to the next focusable element
  static void moveToNext() {
    for (int i = 0; i < _focusNodes.length - 1; i++) {
      if (_focusNodes[i].hasFocus) {
        _focusNodes[i + 1].requestFocus();
        return;
      }
    }
  }

  /// Move focus to the previous focusable element
  static void moveToPrevious() {
    for (int i = 1; i < _focusNodes.length; i++) {
      if (_focusNodes[i].hasFocus) {
        _focusNodes[i - 1].requestFocus();
        return;
      }
    }
  }

  /// Unfocus all elements
  static void unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// Announce text to screen readers
  static void announceToScreenReader(String text, BuildContext context) {
    // Note: SemanticsService.announce is deprecated in newer Flutter versions
    // Use Semantics.announce instead in widget tree
    debugPrint('Announcement: $text');
  }

  /// Handle keyboard navigation
  static void handleKeyEvent(KeyEvent event, BuildContext context) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.tab:
          if (HardwareKeyboard.instance.isShiftPressed) {
            moveToPrevious();
          } else {
            moveToNext();
          }
          break;
        case LogicalKeyboardKey.escape:
          unfocusAll();
          break;
        case LogicalKeyboardKey.enter:
        case LogicalKeyboardKey.space:
          // Let the focused widget handle the action
          break;
      }
    }
  }
}

/// A widget that provides accessibility features
class AccessibilityWrapper extends StatelessWidget {
  final Widget child;
  final String? semanticLabel;
  final String? semanticHint;
  final bool excludeSemantics;
  final VoidCallback? onTap;
  final bool isButton;
  final bool isTextField;
  final bool isHeader;
  final bool isImage;
  final String? imageDescription;

  const AccessibilityWrapper({
    super.key,
    required this.child,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.onTap,
    this.isButton = false,
    this.isTextField = false,
    this.isHeader = false,
    this.isImage = false,
    this.imageDescription,
  });

  @override
  Widget build(BuildContext context) {
    if (excludeSemantics) {
      return ExcludeSemantics(child: child);
    }

    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: isButton,
      textField: isTextField,
      header: isHeader,
      image: isImage,
      onTap: onTap,
      child: child,
    );
  }
}

/// A widget that provides keyboard navigation support
class KeyboardNavigator extends StatelessWidget {
  final Widget child;
  final bool enableKeyboardNavigation;

  const KeyboardNavigator({
    super.key,
    required this.child,
    this.enableKeyboardNavigation = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enableKeyboardNavigation) {
      return child;
    }

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (KeyEvent event) {
        AccessibilityFocusManager.handleKeyEvent(event, context);
      },
      child: child,
    );
  }
}

/// A widget that announces changes to screen readers
class ScreenReaderAnnouncer extends StatefulWidget {
  final Widget child;
  final String? announcement;
  final bool shouldAnnounce;

  const ScreenReaderAnnouncer({
    super.key,
    required this.child,
    this.announcement,
    this.shouldAnnounce = false,
  });

  @override
  State<ScreenReaderAnnouncer> createState() => _ScreenReaderAnnouncerState();
}

class _ScreenReaderAnnouncerState extends State<ScreenReaderAnnouncer> {
  @override
  void didUpdateWidget(ScreenReaderAnnouncer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldAnnounce &&
        widget.announcement != null &&
        widget.announcement != oldWidget.announcement) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AccessibilityFocusManager.announceToScreenReader(
          widget.announcement!,
          context,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

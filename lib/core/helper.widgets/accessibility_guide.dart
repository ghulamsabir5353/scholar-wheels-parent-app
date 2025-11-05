/// Accessibility Implementation Guide for Scholar Wheels App
///
/// This file contains documentation and examples for implementing accessibility
/// features throughout the app. It serves as a reference for developers.

import 'package:flutter/material.dart';

/// Accessibility Best Practices:
///
/// 1. **Semantic Labels**: Always provide meaningful labels for interactive elements
///    Example:
///    ```dart
///    Semantics(
///      label: 'Login button',
///      hint: 'Tap to login to your account',
///      button: true,
///      child: ElevatedButton(...),
///    )
///    ```
///
/// 2. **Focus Management**: Implement proper focus navigation
///    Example:
///    ```dart
///    FocusNode focusNode = FocusNode();
///    TextField(focusNode: focusNode)
///    ```
///
/// 3. **Screen Reader Support**: Use semantic widgets and proper hierarchy
///    Example:
///    ```dart
///    Semantics(
///      label: 'User profile',
///      header: true,
///      child: Text('Profile Information'),
///    )
///    ```
///
/// 4. **Keyboard Navigation**: Support keyboard-only navigation
///    Example:
///    ```dart
///    KeyboardNavigator(
///      child: YourWidget(),
///    )
///    ```
///
/// 5. **Color Contrast**: Ensure sufficient contrast ratios
///    - Use AppColor constants for consistent theming
///    - Test with color blindness simulators
///
/// 6. **Touch Targets**: Maintain minimum 44x44 logical pixels
///    - Use proper padding and sizing
///    - Consider finger-friendly spacing
///
/// 7. **Dynamic Text**: Support system font scaling
///    - Use flutter_screenutil for responsive sizing
///    - Test with large text settings
///
/// 8. **Alternative Text**: Provide descriptions for images and icons
///    Example:
///    ```dart
///    Semantics(
///      label: 'Bus icon',
///      image: true,
///      child: SvgPicture.asset('bus.svg'),
///    )
///    ```

/// Common Accessibility Patterns Used in the App:

/// **Button Accessibility Pattern**
class AccessibleButton extends StatelessWidget {
  final String label;
  final String? hint;
  final VoidCallback? onPressed;
  final Widget child;

  const AccessibleButton({
    super.key,
    required this.label,
    this.hint,
    this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: onPressed != null,
      onTap: onPressed,
      child: child,
    );
  }
}

/// **TextField Accessibility Pattern**
class AccessibleTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? helperText;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  const AccessibleTextField({
    super.key,
    required this.label,
    this.hint,
    this.helperText,
    this.focusNode,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      textField: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(hintText: hint, helperText: helperText),
          ),
        ],
      ),
    );
  }
}

/// **Card Accessibility Pattern**
class AccessibleCard extends StatelessWidget {
  final String label;
  final String? hint;
  final Widget child;
  final VoidCallback? onTap;

  const AccessibleCard({
    super.key,
    required this.label,
    this.hint,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      button: onTap != null,
      onTap: onTap,
      child: Card(child: child),
    );
  }
}

/// **Navigation Accessibility Pattern**
class AccessibleTabBar extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<Widget> children;

  const AccessibleTabBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onTap,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Bottom navigation',
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTap,
        items: labels.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          return BottomNavigationBarItem(icon: children[index], label: label);
        }).toList(),
      ),
    );
  }
}

/// **Image Accessibility Pattern**
class AccessibleImage extends StatelessWidget {
  final String imagePath;
  final String description;
  final double? width;
  final double? height;

  const AccessibleImage({
    super.key,
    required this.imagePath,
    required this.description,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: description,
      image: true,
      child: Image.asset(imagePath, width: width, height: height),
    );
  }
}

/// **Status Accessibility Pattern**
class AccessibleStatus extends StatelessWidget {
  final String status;
  final Color color;
  final String description;

  const AccessibleStatus({
    super.key,
    required this.status,
    required this.color,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$status status: $description',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(status, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

/// **Loading State Accessibility Pattern**
class AccessibleLoading extends StatelessWidget {
  final String message;

  const AccessibleLoading({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: message,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }
}

/// **Error State Accessibility Pattern**
class AccessibleError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AccessibleError({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Error: $message',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(message),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}

/// Testing Accessibility Features:
/// 
/// 1. **Screen Reader Testing**:
///    - Enable TalkBack (Android) or VoiceOver (iOS)
///    - Navigate through the app using gestures
///    - Verify all interactive elements are announced
/// 
/// 2. **Keyboard Navigation Testing**:
///    - Use only keyboard/tab navigation
///    - Verify focus indicators are visible
///    - Test tab order is logical
/// 
/// 3. **Color Contrast Testing**:
///    - Use accessibility tools to check contrast ratios
///    - Test with color blindness simulators
///    - Verify information isn't conveyed by color alone
/// 
/// 4. **Font Scaling Testing**:
///    - Test with large text settings
///    - Verify UI remains usable at 200% scaling
///    - Check for text truncation issues
/// 
/// 5. **Touch Target Testing**:
///    - Verify minimum 44x44 logical pixels
///    - Test with different finger sizes
///    - Ensure adequate spacing between targets

/// Common Accessibility Issues to Avoid:
/// 
/// 1. **Missing Labels**: Always provide semantic labels
/// 2. **Poor Focus Management**: Implement proper focus flow
/// 3. **Insufficient Contrast**: Use proper color combinations
/// 4. **Small Touch Targets**: Maintain minimum sizes
/// 5. **Color-Only Information**: Provide alternative indicators
/// 6. **Missing Alternative Text**: Describe images and icons
/// 7. **Poor Error Handling**: Provide clear error messages
/// 8. **Inconsistent Navigation**: Maintain predictable patterns

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';

/// Custom App Button Widget
/// Provides consistent button styling throughout the app
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : type = AppButtonType.primary;

  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : type = AppButtonType.secondary;

  const AppButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : type = AppButtonType.outline;

  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : type = AppButtonType.text;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final textStyle = _getTextStyle();
    final buttonSize = _getButtonSize();

    Widget buttonChild = _buildButtonContent(textStyle);

    if (isLoading) {
      buttonChild = _buildLoadingContent();
    }

    Widget button;

    switch (type) {
      case AppButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonChild,
        );
        break;
      case AppButtonType.secondary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonChild,
        );
        break;
      case AppButtonType.outline:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonChild,
        );
        break;
      case AppButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonChild,
        );
        break;
    }

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        height: buttonSize.height,
        child: button,
      );
    }

    return SizedBox(
      height: buttonSize.height,
      child: button,
    );
  }

  ButtonStyle _getButtonStyle() {
    final buttonSize = _getButtonSize();
    
    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 2,
          shadowColor: AppColors.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          padding: buttonSize.padding,
          minimumSize: Size(buttonSize.minWidth, buttonSize.height),
        );
      case AppButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.textPrimary,
          elevation: 1,
          shadowColor: AppColors.shadowLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          padding: buttonSize.padding,
          minimumSize: Size(buttonSize.minWidth, buttonSize.height),
        );
      case AppButtonType.outline:
        return OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          padding: buttonSize.padding,
          minimumSize: Size(buttonSize.minWidth, buttonSize.height),
        );
      case AppButtonType.text:
        return TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          padding: buttonSize.padding,
          minimumSize: Size(buttonSize.minWidth, buttonSize.height),
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSize.small:
        return AppTypography.buttonSmall;
      case AppButtonSize.medium:
        return AppTypography.buttonMedium;
      case AppButtonSize.large:
        return AppTypography.buttonLarge;
    }
  }

  _ButtonSize _getButtonSize() {
    switch (size) {
      case AppButtonSize.small:
        return _ButtonSize(
          height: 36,
          minWidth: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        );
      case AppButtonSize.medium:
        return _ButtonSize(
          height: 48,
          minWidth: 120,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        );
      case AppButtonSize.large:
        return _ButtonSize(
          height: 56,
          minWidth: 140,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        );
    }
  }

  Widget _buildButtonContent(TextStyle textStyle) {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: AppSpacing.sm),
          Text(text, style: textStyle),
        ],
      );
    }
    return Text(text, style: textStyle);
  }

  Widget _buildLoadingContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              type == AppButtonType.primary || type == AppButtonType.secondary
                  ? AppColors.textOnPrimary
                  : AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          'Loading...',
          style: _getTextStyle(),
        ),
      ],
    );
  }
}

/// Button Types
enum AppButtonType {
  primary,
  secondary,
  outline,
  text,
}

/// Button Sizes
enum AppButtonSize {
  small,
  medium,
  large,
}

/// Internal button size configuration
class _ButtonSize {
  final double height;
  final double minWidth;
  final EdgeInsets padding;

  const _ButtonSize({
    required this.height,
    required this.minWidth,
    required this.padding,
  });
}

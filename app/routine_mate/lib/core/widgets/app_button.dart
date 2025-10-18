import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// 앱 공통 버튼 위젯
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool expanded;
  final Color? color;

  const AppButton({
    required this.text,
    super.key,
    this.onPressed,
    this.type = ButtonType.filled,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.expanded = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: isLoading
          ? SizedBox(
              width: _getLoadingSize(),
              height: _getLoadingSize(),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  type == ButtonType.filled
                      ? Colors.white
                      : color ?? AppColors.primaryIndigo,
                ),
              ),
            )
          : Row(
              mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: _getIconSize(),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: _getTextStyle(),
                ),
              ],
            ),
    );

    Widget button = switch (type) {
      ButtonType.filled => _buildFilledButton(context, buttonChild),
      ButtonType.outlined => _buildOutlinedButton(context, buttonChild),
      ButtonType.text => _buildTextButton(context, buttonChild),
      ButtonType.ghost => _buildGhostButton(context, buttonChild),
    };

    // Add haptic feedback
    button = GestureDetector(
      onTap: () {
        if (onPressed != null && !isLoading) {
          HapticFeedback.lightImpact();
          onPressed!();
        }
      },
      child: AbsorbPointer(
        child: button,
      ),
    );

    return expanded
        ? SizedBox(
            width: double.infinity,
            child: button,
          )
        : button;
  }

  Widget _buildFilledButton(BuildContext context, Widget child) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primaryIndigo,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.gray300,
        disabledForegroundColor: AppColors.gray500,
        padding: _getPadding(),
        minimumSize: _getMinimumSize(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
      ),
      child: child,
    );
  }

  Widget _buildOutlinedButton(BuildContext context, Widget child) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color ?? AppColors.primaryIndigo,
        disabledForegroundColor: AppColors.gray400,
        side: BorderSide(
          color: isLoading || onPressed == null
              ? AppColors.gray300
              : color ?? AppColors.primaryIndigo,
          width: 1.5,
        ),
        padding: _getPadding(),
        minimumSize: _getMinimumSize(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
      ),
      child: child,
    );
  }

  Widget _buildTextButton(BuildContext context, Widget child) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color ?? AppColors.primaryIndigo,
        disabledForegroundColor: AppColors.gray400,
        padding: _getPadding(),
        minimumSize: _getMinimumSize(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
      ),
      child: child,
    );
  }

  Widget _buildGhostButton(BuildContext context, Widget child) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: isDark ? AppColors.onSurfaceDark : AppColors.onSurface,
        disabledForegroundColor: AppColors.gray400,
        padding: _getPadding(),
        minimumSize: _getMinimumSize(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
      ),
      child: child,
    );
  }

  EdgeInsets _getPadding() {
    return switch (size) {
      ButtonSize.small => const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ButtonSize.medium => const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ButtonSize.large => const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    };
  }

  Size _getMinimumSize() {
    return switch (size) {
      ButtonSize.small => const Size(64, 32),
      ButtonSize.medium => const Size(88, 40),
      ButtonSize.large => const Size(112, 48),
    };
  }

  double _getBorderRadius() {
    return switch (size) {
      ButtonSize.small => 8,
      ButtonSize.medium => 10,
      ButtonSize.large => 12,
    };
  }

  double _getIconSize() {
    return switch (size) {
      ButtonSize.small => 16,
      ButtonSize.medium => 18,
      ButtonSize.large => 20,
    };
  }

  double _getLoadingSize() {
    return switch (size) {
      ButtonSize.small => 16,
      ButtonSize.medium => 20,
      ButtonSize.large => 24,
    };
  }

  TextStyle _getTextStyle() {
    return switch (size) {
      ButtonSize.small => AppTextStyles.labelMedium,
      ButtonSize.medium => AppTextStyles.button,
      ButtonSize.large => AppTextStyles.buttonLarge,
    };
  }
}

/// 버튼 타입
enum ButtonType {
  filled, // 배경색 채움
  outlined, // 테두리만
  text, // 텍스트만
  ghost, // 텍스트만 (회색)
}

/// 버튼 크기
enum ButtonSize {
  small,
  medium,
  large,
}

/// 아이콘 버튼
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final String? tooltip;
  final bool isLoading;

  const AppIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = 24,
    this.tooltip,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = color ?? (isDark ? AppColors.onSurfaceDark : AppColors.onSurface);

    Widget iconWidget = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: isLoading
          ? SizedBox(
              width: size * 0.8,
              height: size * 0.8,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(iconColor),
              ),
            )
          : Icon(
              icon,
              color: iconColor,
              size: size,
            ),
    );

    Widget button = IconButton(
      icon: iconWidget,
      onPressed: isLoading ? null : onPressed,
      padding: const EdgeInsets.all(8),
      constraints: BoxConstraints(
        minWidth: size + 24,
        minHeight: size + 24,
      ),
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        disabledBackgroundColor: backgroundColor?.withValues(alpha: 0.5),
      ),
    );

    // Add haptic feedback
    button = GestureDetector(
      onTap: () {
        if (onPressed != null && !isLoading) {
          HapticFeedback.lightImpact();
          onPressed!();
        }
      },
      child: AbsorbPointer(
        child: button,
      ),
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}
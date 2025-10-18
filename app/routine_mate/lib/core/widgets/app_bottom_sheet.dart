import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

/// 앱 공통 바텀시트
class AppBottomSheet {
  /// 기본 바텀시트 표시
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool isDismissible = true,
    bool enableDrag = true,
    bool showHandle = true,
    double? height,
    EdgeInsets? padding,
    bool isScrollControlled = false,
  }) {
    HapticFeedback.lightImpact();

    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) => _BottomSheetWrapper(
        title: title,
        showHandle: showHandle,
        height: height,
        padding: padding,
        child: child,
      ),
    );
  }

  /// 전체 화면 바텀시트
  static Future<T?> showFullScreen<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return show<T>(
      context: context,
      child: child,
      title: title,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      height: MediaQuery.of(context).size.height * 0.9,
    );
  }

  /// 액션 시트 (옵션 선택)
  static Future<T?> showActions<T>({
    required BuildContext context,
    required List<BottomSheetAction<T>> actions,
    String? title,
    String? message,
    bool showCancel = true,
    String cancelText = '취소',
  }) {
    return show<T>(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null || message != null) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: AppTextStyles.headline4,
                      textAlign: TextAlign.center,
                    ),
                  if (message != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      message,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.gray600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            const Divider(height: 1),
          ],
          ...actions.map((action) => _ActionItem(
                action: action,
                onTap: () => Navigator.of(context).pop(action.value),
              )),
          if (showCancel) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppButton(
                text: cancelText,
                type: ButtonType.ghost,
                onPressed: () => Navigator.of(context).pop(),
                expanded: true,
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// 확인 다이얼로그
  static Future<bool> showConfirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = '확인',
    String cancelText = '취소',
    Color? confirmColor,
    bool isDestructive = false,
  }) async {
    final result = await show<bool>(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTextStyles.headline4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: cancelText,
                    type: ButtonType.outlined,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    text: confirmText,
                    type: ButtonType.filled,
                    color: isDestructive
                        ? AppColors.error
                        : confirmColor ?? AppColors.primaryIndigo,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return result ?? false;
  }
}

/// 바텀시트 래퍼
class _BottomSheetWrapper extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool showHandle;
  final double? height;
  final EdgeInsets? padding;

  const _BottomSheetWrapper({
    required this.child,
    this.title,
    this.showHandle = true,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showHandle) ...[
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.gray700 : AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
        if (title != null) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: AppTextStyles.headline4,
                  ),
                ),
                AppIconButton(
                  icon: Icons.close,
                  size: 20,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
        ],
        Flexible(
          child: Padding(
            padding: padding ??
                EdgeInsets.only(
                  left: 0,
                  right: 0,
                  top: title != null ? 0 : 16,
                  bottom: bottomPadding + 20,
                ),
            child: child,
          ),
        ),
      ],
    );

    if (height != null) {
      content = SizedBox(
        height: height! + bottomPadding,
        child: content,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: content,
      ),
    );
  }
}

/// 액션 아이템
class _ActionItem<T> extends StatelessWidget {
  final BottomSheetAction<T> action;
  final VoidCallback onTap;

  const _ActionItem({
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.isEnabled
            ? () {
                HapticFeedback.lightImpact();
                onTap();
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              if (action.icon != null) ...[
                Icon(
                  action.icon,
                  size: 24,
                  color: action.isDestructive
                      ? AppColors.error
                      : action.isEnabled
                          ? (isDark ? AppColors.onSurfaceDark : AppColors.onSurface)
                          : AppColors.gray400,
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Text(
                  action.title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: action.isDestructive
                        ? AppColors.error
                        : action.isEnabled
                            ? (isDark ? AppColors.onSurfaceDark : AppColors.onSurface)
                            : AppColors.gray400,
                    fontWeight: action.isDefault ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (action.trailing != null) ...[
                const SizedBox(width: 16),
                action.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 바텀시트 액션
class BottomSheetAction<T> {
  final String title;
  final T value;
  final IconData? icon;
  final Widget? trailing;
  final bool isEnabled;
  final bool isDestructive;
  final bool isDefault;

  const BottomSheetAction({
    required this.title,
    required this.value,
    this.icon,
    this.trailing,
    this.isEnabled = true,
    this.isDestructive = false,
    this.isDefault = false,
  });
}
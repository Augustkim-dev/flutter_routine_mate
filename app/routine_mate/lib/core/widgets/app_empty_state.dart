import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

/// 빈 상태 표시 위젯
class AppEmptyState extends StatelessWidget {
  final String title;
  final String? message;
  final IconData? icon;
  final Widget? image;
  final String? actionText;
  final VoidCallback? onAction;
  final EdgeInsets padding;

  const AppEmptyState({
    required this.title,
    super.key,
    this.message,
    this.icon,
    this.image,
    this.actionText,
    this.onAction,
    this.padding = const EdgeInsets.all(32),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 아이콘 또는 이미지
          if (image != null)
            image!
          else if (icon != null)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryIndigo.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.primaryIndigo,
              ),
            ),

          if (icon != null || image != null) const SizedBox(height: 24),

          // 제목
          Text(
            title,
            style: AppTextStyles.headline4.copyWith(
              color: isDark ? AppColors.onSurfaceDark : AppColors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          // 메시지
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.onSurfaceVariantDark
                    : AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],

          // 액션 버튼
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: 24),
            AppButton(
              text: actionText!,
              onPressed: onAction,
              type: ButtonType.filled,
              icon: Icons.add,
            ),
          ],
        ],
      ),
    );
  }
}

/// 로딩 상태 위젯
class AppLoadingState extends StatelessWidget {
  final String? message;

  const AppLoadingState({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryIndigo),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.onSurfaceVariantDark
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 에러 상태 위젯
class AppErrorState extends StatelessWidget {
  final String title;
  final String? message;
  final String? retryText;
  final VoidCallback? onRetry;

  const AppErrorState({
    required this.title,
    super.key,
    this.message,
    this.retryText,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 에러 아이콘
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              size: 40,
              color: AppColors.error,
            ),
          ),

          const SizedBox(height: 24),

          // 제목
          Text(
            title,
            style: AppTextStyles.headline4.copyWith(
              color: isDark ? AppColors.onSurfaceDark : AppColors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          // 메시지
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.onSurfaceVariantDark
                    : AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],

          // 재시도 버튼
          if (retryText != null && onRetry != null) ...[
            const SizedBox(height: 24),
            AppButton(
              text: retryText!,
              onPressed: onRetry,
              type: ButtonType.outlined,
              icon: Icons.refresh,
            ),
          ],
        ],
      ),
    );
  }
}
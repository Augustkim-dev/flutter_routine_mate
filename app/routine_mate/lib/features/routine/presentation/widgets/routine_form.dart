import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

/// 루틴 추가/수정 폼
class RoutineForm extends StatefulWidget {
  final Map<String, dynamic>? routine;
  final Function(Map<String, dynamic>) onSave;

  const RoutineForm({
    required this.onSave,
    super.key,
    this.routine,
  });

  @override
  State<RoutineForm> createState() => _RoutineFormState();
}

class _RoutineFormState extends State<RoutineForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  late int _selectedIconIndex;
  late int _selectedColorIndex;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // 초기값 설정
    if (widget.routine != null) {
      _nameController.text = widget.routine!['name'] ?? '';
      _selectedIconIndex = widget.routine!['iconIndex'] ?? 0;
      _selectedColorIndex = widget.routine!['colorIndex'] ?? 0;
    } else {
      _selectedIconIndex = 0;
      _selectedColorIndex = 0;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    HapticFeedback.lightImpact();

    // 데이터 준비
    final data = {
      'name': _nameController.text.trim(),
      'iconIndex': _selectedIconIndex,
      'colorIndex': _selectedColorIndex,
    };

    // 수정 모드인 경우 ID 추가
    if (widget.routine != null) {
      data['id'] = widget.routine!['id'];
    }

    // 콜백 호출
    widget.onSave(data);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 루틴 이름 입력
            Text(
              '루틴 이름',
              style: AppTextStyles.labelLarge.copyWith(
                color: isDark ? AppColors.onSurfaceDark : AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              maxLength: 20,
              decoration: InputDecoration(
                hintText: '예: 아침 운동',
                counterText: '${_nameController.text.length}/20',
              ),
              style: AppTextStyles.bodyLarge,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '루틴 이름을 입력해주세요';
                }
                if (value.trim().length > 20) {
                  return '20자 이내로 입력해주세요';
                }
                return null;
              },
              onChanged: (_) {
                setState(() {}); // 글자수 카운터 업데이트
              },
            ),
            const SizedBox(height: 24),

            // 아이콘 선택
            Text(
              '아이콘',
              style: AppTextStyles.labelLarge.copyWith(
                color: isDark ? AppColors.onSurfaceDark : AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.gray900 : AppColors.gray50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: AppIcons.routineIcons.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedIconIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIconIndex = index;
                      });
                      HapticFeedback.selectionClick();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryIndigo.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryIndigo
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        AppIcons.getRoutineIcon(index),
                        size: 24,
                        color: isSelected
                            ? AppColors.primaryIndigo
                            : (isDark
                                ? AppColors.onSurfaceDark
                                : AppColors.onSurface),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // 색상 선택
            Text(
              '색상',
              style: AppTextStyles.labelLarge.copyWith(
                color: isDark ? AppColors.onSurfaceDark : AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.gray900 : AppColors.gray50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(AppColors.routineColors.length, (index) {
                  final color = AppColors.getRoutineColor(index);
                  final isSelected = _selectedColorIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColorIndex = index;
                      });
                      HapticFeedback.selectionClick();
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryIndigo
                              : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            )
                          : null,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 32),

            // 미리보기
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.gray900
                    : AppColors.gray50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '미리보기',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // 아이콘 미리보기
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.getRoutineColor(_selectedColorIndex)
                              .withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          AppIcons.getRoutineIcon(_selectedIconIndex),
                          color: AppColors.getRoutineColor(_selectedColorIndex),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 이름 미리보기
                      Expanded(
                        child: Text(
                          _nameController.text.trim().isEmpty
                              ? '루틴 이름'
                              : _nameController.text.trim(),
                          style: AppTextStyles.routineName.copyWith(
                            color: _nameController.text.trim().isEmpty
                                ? AppColors.gray400
                                : (isDark
                                    ? AppColors.onSurfaceDark
                                    : AppColors.onSurface),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 저장 버튼
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: '취소',
                    type: ButtonType.outlined,
                    size: ButtonSize.large,
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: AppButton(
                    text: widget.routine != null ? '수정하기' : '추가하기',
                    type: ButtonType.filled,
                    size: ButtonSize.large,
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _handleSave,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
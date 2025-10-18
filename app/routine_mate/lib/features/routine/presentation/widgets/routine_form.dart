import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/schedule_type.dart';

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
  late ScheduleType _selectedScheduleType;
  Set<int> _selectedCustomDays = {};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // 초기값 설정
    if (widget.routine != null) {
      _nameController.text = widget.routine!['name'] ?? '';
      _selectedIconIndex = widget.routine!['iconIndex'] ?? 0;
      _selectedColorIndex = widget.routine!['colorIndex'] ?? 0;
      _selectedScheduleType = widget.routine!['scheduleType'] ?? ScheduleType.daily;
      if (widget.routine!['customDays'] != null) {
        _selectedCustomDays = Set<int>.from(widget.routine!['customDays']);
      }
    } else {
      _selectedIconIndex = 0;
      _selectedColorIndex = 0;
      _selectedScheduleType = ScheduleType.daily;
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

    // 커스텀 요일 선택 시 최소 1개 이상 선택 검증
    if (_selectedScheduleType == ScheduleType.custom && _selectedCustomDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('커스텀 요일을 선택할 경우 최소 1개 이상의 요일을 선택해주세요'),
          backgroundColor: Colors.red,
        ),
      );
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
      'scheduleType': _selectedScheduleType,
      'customDays': _selectedScheduleType == ScheduleType.custom
          ? _selectedCustomDays.toList()
          : null,
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
            const SizedBox(height: 24),

            // 반복 요일 선택
            Text(
              '반복 요일',
              style: AppTextStyles.labelLarge.copyWith(
                color: isDark ? AppColors.onSurfaceDark : AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            // 빠른 선택 버튼들
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.gray900 : AppColors.gray50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // SegmentedButton for schedule types
                  SegmentedButton<ScheduleType>(
                    segments: const [
                      ButtonSegment<ScheduleType>(
                        value: ScheduleType.daily,
                        label: Text('매일'),
                      ),
                      ButtonSegment<ScheduleType>(
                        value: ScheduleType.weekday,
                        label: Text('평일'),
                      ),
                      ButtonSegment<ScheduleType>(
                        value: ScheduleType.weekend,
                        label: Text('주말'),
                      ),
                      ButtonSegment<ScheduleType>(
                        value: ScheduleType.custom,
                        label: Text('커스텀'),
                      ),
                    ],
                    selected: {_selectedScheduleType},
                    onSelectionChanged: (Set<ScheduleType> newSelection) {
                      setState(() {
                        _selectedScheduleType = newSelection.first;

                        // 빠른 선택 시 customDays 자동 설정
                        if (_selectedScheduleType == ScheduleType.weekday) {
                          _selectedCustomDays = {1, 2, 3, 4, 5}; // 월-금
                        } else if (_selectedScheduleType == ScheduleType.weekend) {
                          _selectedCustomDays = {6, 7}; // 토-일
                        } else if (_selectedScheduleType == ScheduleType.daily) {
                          _selectedCustomDays = {1, 2, 3, 4, 5, 6, 7}; // 모든 요일
                        }
                      });
                      HapticFeedback.selectionClick();
                    },
                  ),

                  // 커스텀 요일 선택 (커스텀 모드일 때만 표시)
                  if (_selectedScheduleType == ScheduleType.custom) ...[
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      children: [
                        _buildDayChip('월', DateTime.monday),
                        _buildDayChip('화', DateTime.tuesday),
                        _buildDayChip('수', DateTime.wednesday),
                        _buildDayChip('목', DateTime.thursday),
                        _buildDayChip('금', DateTime.friday),
                        _buildDayChip('토', DateTime.saturday),
                        _buildDayChip('일', DateTime.sunday),
                      ],
                    ),
                  ],
                ],
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
                  const SizedBox(height: 8),
                  // 요일 정보 미리보기
                  Text(
                    _getScheduleDescription(),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.gray500,
                    ),
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

  // 스케줄 설명 텍스트 생성
  String _getScheduleDescription() {
    switch (_selectedScheduleType) {
      case ScheduleType.daily:
        return '매일';
      case ScheduleType.weekday:
        return '월-금';
      case ScheduleType.weekend:
        return '토-일';
      case ScheduleType.custom:
        if (_selectedCustomDays.isEmpty) {
          return '요일을 선택해주세요';
        }
        final sortedDays = _selectedCustomDays.toList()..sort();
        final dayNames = sortedDays.map((day) => _getDayName(day)).join(', ');
        return dayNames;
    }
  }

  // 요일 번호를 요일 이름으로 변환
  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return '월';
      case DateTime.tuesday:
        return '화';
      case DateTime.wednesday:
        return '수';
      case DateTime.thursday:
        return '목';
      case DateTime.friday:
        return '금';
      case DateTime.saturday:
        return '토';
      case DateTime.sunday:
        return '일';
      default:
        return '';
    }
  }

  // 요일 선택 칩 빌더
  Widget _buildDayChip(String label, int weekday) {
    final isSelected = _selectedCustomDays.contains(weekday);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedCustomDays.add(weekday);
          } else {
            _selectedCustomDays.remove(weekday);
          }
        });
        HapticFeedback.selectionClick();
      },
      selectedColor: AppColors.primaryIndigo,
      backgroundColor: isDark ? AppColors.gray800 : AppColors.gray100,
      labelStyle: TextStyle(
        color: isSelected
            ? Colors.white
            : (isDark ? AppColors.onSurfaceDark : AppColors.onSurface),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected
              ? AppColors.primaryIndigo
              : (isDark ? AppColors.gray700 : AppColors.gray300),
        ),
      ),
    );
  }
}
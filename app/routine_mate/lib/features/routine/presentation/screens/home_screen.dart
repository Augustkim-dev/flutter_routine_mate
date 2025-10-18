import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../widgets/routine_card.dart';
import '../widgets/routine_form.dart';

/// 홈 화면
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final offset = _scrollController.offset;
      final shouldShow = offset <= 100;

      if (shouldShow != _isFabVisible) {
        setState(() {
          _isFabVisible = shouldShow;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // TODO: 실제 데이터로 교체
    final List<Map<String, dynamic>> mockRoutines = [
      {
        'id': '1',
        'name': '아침 운동',
        'iconIndex': 0,
        'colorIndex': 0,
        'isCompleted': true,
        'streak': 5,
      },
      {
        'id': '2',
        'name': '물 마시기',
        'iconIndex': 13,
        'colorIndex': 2,
        'isCompleted': false,
        'streak': 3,
      },
      {
        'id': '3',
        'name': '독서하기',
        'iconIndex': 6,
        'colorIndex': 4,
        'isCompleted': false,
        'streak': 0,
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 앱바
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '오늘의 루틴',
                    style: AppTextStyles.headline3.copyWith(
                      color: isDark ? AppColors.onSurfaceDark : AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryIndigo.withValues(alpha: 0.1),
                      AppColors.primaryIndigo.withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(AppIcons.settings),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  // TODO: 설정 화면으로 이동
                },
              ),
            ],
          ),

          // 진행률 카드
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 진행률 표시
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryIndigo,
                        width: 4,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '33%',
                        style: AppTextStyles.percentage.copyWith(
                          color: AppColors.primaryIndigo,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // 텍스트 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1개 완료',
                          style: AppTextStyles.headline4.copyWith(
                            color: isDark
                                ? AppColors.onSurfaceDark
                                : AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '3개 중 1개의 루틴을 완료했어요',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.onSurfaceVariantDark
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 루틴 리스트
          if (mockRoutines.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: AppEmptyState(
                icon: AppIcons.routineIcons[0],
                title: '아직 루틴이 없어요',
                message: '새로운 루틴을 추가해보세요',
                actionText: '루틴 추가하기',
                onAction: () => _showRoutineForm(context),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final routine = mockRoutines[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RoutineCard(
                        id: routine['id'],
                        name: routine['name'],
                        iconIndex: routine['iconIndex'],
                        colorIndex: routine['colorIndex'],
                        isCompleted: routine['isCompleted'],
                        streak: routine['streak'],
                        onTap: () {
                          // TODO: 루틴 체크 토글
                          HapticFeedback.lightImpact();
                        },
                        onLongPress: () {
                          _showRoutineOptions(context, routine);
                        },
                      ),
                    );
                  },
                  childCount: mockRoutines.length,
                ),
              ),
            ),

          // 하단 여백
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset: _isFabVisible ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isFabVisible ? 1 : 0,
          child: FloatingActionButton(
            onPressed: () => _showRoutineForm(context),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  // 루틴 추가/수정 폼 표시
  void _showRoutineForm(BuildContext context, [Map<String, dynamic>? routine]) {
    AppBottomSheet.showFullScreen(
      context: context,
      title: routine != null ? '루틴 수정' : '새 루틴 추가',
      child: RoutineForm(
        routine: routine,
        onSave: (data) {
          // TODO: 루틴 저장
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(routine != null ? '루틴이 수정되었습니다' : '루틴이 추가되었습니다'),
            ),
          );
        },
      ),
    );
  }

  // 루틴 옵션 메뉴 표시
  void _showRoutineOptions(
      BuildContext context, Map<String, dynamic> routine) {
    AppBottomSheet.showActions(
      context: context,
      title: routine['name'],
      actions: [
        BottomSheetAction(
          title: '수정하기',
          value: 'edit',
          icon: Icons.edit,
        ),
        BottomSheetAction(
          title: '삭제하기',
          value: 'delete',
          icon: Icons.delete,
          isDestructive: true,
        ),
      ],
    ).then((value) {
      if (!mounted) return;

      if (value == 'edit') {
        _showRoutineForm(context, routine);
      } else if (value == 'delete') {
        _confirmDelete(context, routine);
      }
    });
  }

  // 삭제 확인 다이얼로그
  void _confirmDelete(BuildContext context, Map<String, dynamic> routine) {
    AppBottomSheet.showConfirm(
      context: context,
      title: '루틴 삭제',
      message: '${routine['name']}을(를) 삭제하시겠습니까?\n삭제한 루틴은 복구할 수 없습니다.',
      confirmText: '삭제',
      cancelText: '취소',
      isDestructive: true,
    ).then((confirmed) {
      if (!mounted) return;

      if (confirmed) {
        // TODO: 루틴 삭제
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('루틴이 삭제되었습니다'),
          ),
        );
      }
    });
  }
}
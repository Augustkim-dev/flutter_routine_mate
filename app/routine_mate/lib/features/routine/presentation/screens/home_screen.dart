import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../domain/entities/routine.dart';
import '../../domain/entities/schedule_type.dart';
import '../providers/routine_providers.dart';
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

  void _showAddRoutineSheet() {
    AppBottomSheet.showFullScreen(
      context: context,
      title: '새로운 루틴',
      child: RoutineForm(
        onSave: (routineData) async {
          // 새로운 루틴 생성 및 추가
          final routine = Routine(
            id: '',
            name: routineData['name'] ?? '',
            iconIndex: routineData['iconIndex'] ?? 0,
            colorIndex: routineData['colorIndex'] ?? 0,
            scheduleType: routineData['scheduleType'] ?? ScheduleType.daily,
            customDays: routineData['customDays'],
            sortOrder: 0,
            isReminderEnabled: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          // Navigator를 먼저 가져옴
          final navigator = Navigator.of(context);
          await ref.read(routineListProvider.notifier).addRoutine(routine);
          navigator.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final routineListState = ref.watch(routineListProvider);
    final filteredRoutines = ref.watch(filteredRoutinesProvider);
    final completionRate = ref.watch(todayCompletionRateProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: routineListState.when(
        data: (state) {
          return CustomScrollView(
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
                        'RoutineMate',
                        style: AppTextStyles.headline2.withColor(
                          isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getGreetingMessage(),
                        style: AppTextStyles.body2.withColor(
                          isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withValues(alpha: 0.1),
                          (isDark ? AppColors.surfaceDark : AppColors.surface),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 진행률 카드
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    color: isDark ? AppColors.surfaceDark : AppColors.surface,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.border.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '오늘의 진행률',
                            style: AppTextStyles.label1.withColor(
                              isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                '${(completionRate * 100).toInt()}%',
                                style: AppTextStyles.headline1.withColor(
                                  AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '완료',
                                style: AppTextStyles.body1.withColor(
                                  isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: completionRate,
                              minHeight: 8,
                              backgroundColor: isDark
                                  ? AppColors.borderDark
                                  : AppColors.border.withValues(alpha: 0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 루틴 목록
              if (filteredRoutines.isEmpty)
                SliverFillRemaining(
                  child: AppEmptyState(
                    icon: AppIcons.getIcon(0),
                    title: '루틴이 없어요',
                    description: '새로운 루틴을 추가해보세요',
                    actionText: '루틴 추가',
                    onAction: _showAddRoutineSheet,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final routine = filteredRoutines[index];
                        final isCompleted = state.todayCompletions[routine.id] ?? false;
                        final streak = state.streaks[routine.id] ?? 0;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: RoutineCard(
                            id: routine.id,
                            name: routine.name,
                            iconIndex: routine.iconIndex,
                            colorIndex: routine.colorIndex,
                            isCompleted: isCompleted,
                            streak: streak,
                            scheduleDescription: routine.scheduleDescription,
                            onTap: () {
                              // 토글 기능을 onTap에서 처리
                              ref.read(routineListProvider.notifier).toggleCompletion(routine.id);
                              HapticFeedback.lightImpact();
                            },
                            onLongPress: () {
                              // 길게 누르면 수정
                              ref.read(selectedRoutineProvider.notifier).state = routine;
                              ref.read(routineFormModeProvider.notifier).state = FormMode.edit;
                              AppBottomSheet.showFullScreen(
                                context: context,
                                title: '루틴 수정',
                                child: RoutineForm(
                                  routine: {
                                    'id': routine.id,
                                    'name': routine.name,
                                    'iconIndex': routine.iconIndex,
                                    'colorIndex': routine.colorIndex,
                                    'scheduleType': routine.scheduleType,
                                    'customDays': routine.customDays,
                                  },
                                  onSave: (routineData) async {
                                    // 루틴 수정
                                    final updatedRoutine = routine.copyWith(
                                      name: routineData['name'] ?? routine.name,
                                      iconIndex: routineData['iconIndex'] ?? routine.iconIndex,
                                      colorIndex: routineData['colorIndex'] ?? routine.colorIndex,
                                      scheduleType: routineData['scheduleType'] ?? routine.scheduleType,
                                      customDays: routineData['customDays'],
                                    );

                                    final navigator = Navigator.of(context);
                                    await ref.read(routineListProvider.notifier).updateRoutine(updatedRoutine);
                                    navigator.pop();
                                  },
                                ),
                              );
                            },
                            onDelete: () {
                              ref.read(routineListProvider.notifier).deleteRoutine(routine.id);
                              HapticFeedback.mediumImpact();
                            },
                          ),
                        );
                      },
                      childCount: filteredRoutines.length,
                    ),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: AppEmptyState(
            icon: Icons.error_outline,
            title: '오류가 발생했어요',
            description: error.toString(),
            actionText: '다시 시도',
            onAction: () {
              ref.invalidate(routineListProvider);
            },
          ),
        ),
      ),
      floatingActionButton: AnimatedScale(
        scale: _isFabVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton(
          onPressed: () {
            ref.read(selectedRoutineProvider.notifier).state = null;
            ref.read(routineFormModeProvider.notifier).state = FormMode.add;
            _showAddRoutineSheet();
            HapticFeedback.lightImpact();
          },
          backgroundColor: AppColors.primary,
          elevation: 4,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 6) {
      return '🌙 편안한 새벽이에요';
    } else if (hour < 12) {
      return '☀️ 좋은 아침이에요';
    } else if (hour < 17) {
      return '🌤 활기찬 오후예요';
    } else if (hour < 21) {
      return '🌆 여유로운 저녁이에요';
    } else {
      return '🌜 고요한 밤이에요';
    }
  }
}
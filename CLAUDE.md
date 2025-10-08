# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 📋 프로젝트 작업 규칙

### 작업 계획 및 문서화
모든 작업을 수행할 때는 다음의 문서화 규칙을 따릅니다:

#### 1. 작업 계획 (Plans)
- **경로**: `docs/plans/XXX.작업명.md`
- **형식**: `001.flutter_초기설정.md`, `002.루틴_추가_기능.md`
- **내용**: 작업 시작 전 상세한 구현 계획 작성
  - 작업 목표
  - 구현할 기능 목록
  - 기술적 접근 방법
  - 예상 파일 구조
  - 테스트 계획

#### 2. 작업 일지 (Work Logs)
- **경로**: `docs/worklogs/XXX.작업명.md`
- **형식**: `001.flutter_초기설정.md`, `002.루틴_추가_기능.md`
- **내용**: 작업 완료 후 실제 구현 내역 정리
  - 구현된 기능
  - 생성/수정된 파일 목록
  - 주요 코드 스니펫
  - 발생한 이슈 및 해결 방법
  - 테스트 결과
  - 다음 단계 제안

#### 3. 번호 체계
- **3자리 순차 번호** 사용 (001, 002, 003...)
- **순차적 증가**: 새 작업은 항상 이전 번호 + 1
- **중복 방지**: 번호는 재사용하지 않음
- **Plans와 Worklogs 동기화**: 동일한 작업은 동일한 번호 사용
- 예: `001.flutter_초기설정.md` (plan) ↔ `001.flutter_초기설정.md` (worklog)

**현재 사용된 번호:**
- 000: 작업 규칙 (특별 문서)
- 001: Flutter 초기설정 ✅
- 002: 프로젝트 구조 생성 (예정)
- 003: 데이터베이스 변경 (SQLite) 📝

**중요**: 새로운 작업을 시작할 때는 반드시 기존 파일들을 확인하여 가장 큰 번호를 찾고, 그 다음 번호를 사용해야 합니다.

---

## 🎯 Project Overview

RoutineMate is a minimalist habit tracking Flutter application focused on simplicity and accessibility. The core value proposition is "3-second routine checking" with home widget support.

**Target Platform:** iOS & Android
**Framework:** Flutter 3.24+
**Primary Language:** Korean (UI/documentation)

## 🏗 Architecture

The project follows a feature-first clean architecture pattern:

```
lib/
├── features/
│   ├── routine/          # Core routine tracking functionality
│   │   ├── data/         # Repositories, data sources, models
│   │   ├── domain/       # Entities, use cases, repository interfaces
│   │   └── presentation/ # UI, state management (Riverpod)
│   └── widget/           # Home widget integration
├── core/
│   ├── theme/            # App-wide theming (Primary: #6366F1)
│   └── utils/            # Shared utilities
└── main.dart
```

### Key Technical Decisions

- **State Management:** Riverpod 2.0 (provider-based)
- **Local Database:** SQLite (sqflite 2.3+) - 관계형 데이터베이스로 복잡한 쿼리와 트랜잭션 지원
- **Widget Platform:** home_widget 0.5 for native home screen widgets
- **Monetization:** google_mobile_ads (AdMob banner at bottom)
- **Analytics:** Firebase Analytics

### Design Constraints

- **Performance Targets:**
  - Cold start: < 2 seconds
  - Widget update latency: < 1 second
  - Memory usage: < 100MB
  - Minimal battery impact

- **UI Principles:**
  - One-tap actions for all primary interactions
  - Maximum 2-level navigation depth
  - Immediate visual feedback on all actions

## 📱 Development Commands

```bash
# Flutter 기본 명령어
flutter pub get           # 패키지 설치
flutter run              # 개발 모드 실행
flutter test             # 테스트 실행
flutter build apk        # Android 빌드
flutter build ios        # iOS 빌드

# 프로젝트 관련
flutter analyze          # 코드 분석
flutter format .         # 코드 포맷팅
```

## 🚀 Feature Scope

### MVP (P0) - Must Have
- Add/delete routines with icon, color, and schedule
- One-tap routine check/uncheck with animation
- Local data persistence (SQLite)
- Swipe-to-delete with confirmation

### Post-MVP (P1)
- Home widgets (1x1, 2x2, 4x2) showing up to 3 routines
- Time-based reminders with encouragement messages
- Streak notifications

### Future (P2)
- Statistics dashboard
- AI journaling integration
- Social features
- Premium subscription model

## 💾 Data Models

### Routine Entity (Planned)
- `id`: String (UUID)
- `name`: String (max 20 chars)
- `icon`: Enum (30 presets)
- `color`: Enum (8 options)
- `schedule`: Enum (daily/weekday/weekend/custom)
- `completionHistory`: Map<Date, bool>

## 📊 Success Metrics

- 7-Day Retention: ≥ 30%
- DAU/MAU Ratio: ≥ 40%
- Average routines per user: ≥ 3
- Daily completion rate: ≥ 50%

## 🧪 Testing Strategy

Focus areas:
- Routine CRUD operations
- Widget synchronization with app state
- SQLite transaction integrity
- Query performance optimization
- Animation performance
- Battery usage during widget updates

## 🌐 Localization

Primary language is Korean. All user-facing strings, documentation, and comments should be in Korean unless interfacing with English-only libraries.

## 📚 Project Documentation

### PRD Documents
- `docs/plans/routine_mate.md` - Original PRD (Hive 기반)
- `docs/plans/routine_mate_detailed_prd.md` - Detailed technical PRD (SQLite로 업데이트됨)
- `docs/plans/003.데이터베이스_변경_sqlite.md` - Hive → SQLite 변경 계획 및 마이그레이션 전략

### Work Documentation Pattern
Always follow the XXX.name.md pattern for plans and worklogs to maintain consistency and trackability.

### Database Decision
프로젝트는 초기 Hive 계획에서 SQLite로 변경되었습니다. 주요 이유:
- 복잡한 쿼리 지원 (통계, 필터링, 정렬)
- 트랜잭션 보장으로 데이터 무결성 확보
- 관계형 데이터 구조로 루틴과 완료 기록 간 관계 명확화
- 향후 서버 동기화 시 SQL 기반 확장 용이
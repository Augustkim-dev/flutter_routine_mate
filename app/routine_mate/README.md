# RoutineMate

매일 작은 실천을 통해 큰 변화를 만드는 가장 심플한 습관 트래커

## 📱 프로젝트 정보

- **Package Name**: com.accu.routine.mate
- **Bundle ID**: com.accu.routine.mate
- **Platforms**: iOS, Android
- **Flutter Version**: 3.24+
- **Dart Version**: 3.0+

## 🚀 시작하기

### 필요 환경

- Flutter SDK 3.24 이상
- Dart SDK 3.0 이상
- Android Studio / Xcode
- iOS: iOS 11.0 이상
- Android: API 21 (Lollipop) 이상

### 설치

```bash
# 패키지 설치
flutter pub get

# iOS 설정 (macOS만)
cd ios && pod install && cd ..

# 실행
flutter run
```

## 📁 프로젝트 구조

```
lib/
├── core/               # 핵심 유틸리티
│   ├── database/      # SQLite 데이터베이스
│   ├── theme/         # 테마 설정
│   └── utils/         # 유틸리티
├── features/          # 기능별 모듈
│   ├── routine/       # 루틴 관리
│   │   ├── data/     # 데이터 레이어
│   │   ├── domain/   # 도메인 레이어
│   │   └── presentation/ # UI 레이어
│   └── widget/        # 홈 위젯
└── main.dart          # 앱 진입점
```

## 🛠 기술 스택

- **State Management**: Riverpod 2.0
- **Database**: SQLite (sqflite)
- **Architecture**: Clean Architecture
- **Design Pattern**: Repository Pattern

## 📝 개발 규칙

1. **Commit Message**: [타입] 메시지 (예: [feat] 루틴 추가 기능 구현)
2. **Branch**: feature/기능명, fix/이슈명
3. **Code Style**: flutter_lints 준수

## 🔗 관련 문서

- [PRD 문서](/docs/plans/routine_mate_detailed_prd.md)
- [작업 계획](/docs/plans/)
- [작업 일지](/docs/worklogs/)

---

© 2025 ACCU. All rights reserved.
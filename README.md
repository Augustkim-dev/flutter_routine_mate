# 📱 RoutineMate - 심플한 습관 트래커

<div align="center">
  <img src="assets/images/app_logo.png" alt="RoutineMate Logo" width="120" height="120">

  **작은 습관, 큰 변화**

  [![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)
  [![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

</div>

## 🎯 프로젝트 소개

RoutineMate는 복잡한 기능 없이 오직 습관 체크에만 집중한 미니멀한 습관 관리 앱입니다.
3초 안에 오늘의 루틴을 체크할 수 있도록 설계되었으며, 홈 위젯을 통해 앱을 열지 않고도 빠르게 접근할 수 있습니다.

### 개발 현황
- **MVP 개발 완료** (2025년 1월)
- **현재 버전**: 1.0.0
- **상태**: 테스트 및 최적화 진행 중

### 핵심 가치
- **Simple**: 불필요한 기능 없는 직관적인 UI
- **Fast**: 3초 안에 루틴 체크 완료
- **Accessible**: 홈 위젯으로 즉시 접근

## ✨ 주요 기능

### MVP (개발 완료)
- ✅ **루틴 관리**: 추가, 수정, 삭제, 체크
- ✅ **스케줄 설정**: 매일, 평일, 주말, 요일별 커스텀
- ✅ **로컬 저장**: SQLite 기반 안정적인 데이터 관리
- ✅ **스트릭 시스템**: 연속 달성일 자동 계산 및 표시
- ✅ **다크모드**: 시스템 설정 연동
- ✅ **애니메이션**: 부드러운 인터랙션

### Post-MVP (예정)
- 📱 **홈 위젯**: iOS/Android 네이티브 위젯
- 🔔 **알림 시스템**: 리마인더 & 스트릭 축하
- 📊 **통계 대시보드**: 완료율, 히트맵, 트렌드
- 💰 **수익화**: AdMob 배너 광고

## 🛠 기술 스택

### Framework & Language
- **Flutter** 3.24+ - 크로스 플랫폼 UI 프레임워크
- **Dart** 3.0+ - 프로그래밍 언어

### State Management
- **Riverpod** 2.0 - 타입 세이프한 상태 관리

### Database
- **SQLite** (sqflite) - 로컬 데이터베이스
- 관계형 데이터 구조로 복잡한 쿼리 지원

### Architecture
- **Clean Architecture** - 관심사 분리
- **Feature-First** - 기능별 모듈 구조
- **Repository Pattern** - 데이터 추상화

## 📂 프로젝트 구조

```
lib/
├── core/                      # 공통 모듈
│   ├── animations/           # 애니메이션 효과
│   ├── database/            # SQLite DB 설정
│   ├── providers/           # Riverpod 프로바이더
│   ├── theme/              # 테마, 색상, 아이콘
│   ├── utils/              # 유틸리티
│   └── widgets/            # 공통 위젯
├── features/               # 기능별 모듈
│   └── routine/           # 루틴 관리
│       ├── data/         # 데이터 레이어
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/       # 도메인 레이어
│       │   ├── entities/
│       │   └── repositories/
│       └── presentation/ # UI 레이어
│           ├── notifiers/
│           ├── providers/
│           ├── screens/
│           ├── states/
│           └── widgets/
└── main.dart             # 앱 진입점
```

## 🚀 시작하기

### 필수 요구사항
- Flutter SDK 3.24.0 이상
- Dart SDK 3.0.0 이상
- iOS: Xcode 14+ (Mac 필요)
- Android: Android Studio / VS Code

### 설치 방법

1. **저장소 클론**
```bash
git clone https://github.com/Augustkim-dev/flutter_routine_mate.git
cd flutter_routine_mate/app/routine_mate
```

2. **의존성 설치**
```bash
flutter pub get
```

3. **개발 서버 실행**
```bash
flutter run
```

### 빌드 방법

**Android APK**
```bash
flutter build apk --release
```

**iOS**
```bash
flutter build ios --release
```

## 📱 스크린샷

> 📸 스크린샷은 준비 중입니다. 곧 업데이트될 예정입니다.

## 🗓 개발 로드맵

### Phase 1-4: MVP ✅ (완료)
- [x] 프로젝트 초기 설정
- [x] Phase 1: SQLite 데이터베이스 구축
- [x] Phase 2: 핵심 UI 시스템 구현
- [x] Phase 3: Riverpod 상태 관리 구현
- [x] 요일별 루틴 설정 기능
- [x] 스트릭 시스템 구현

### Phase 5-8: Post-MVP (2주)
- [ ] 홈 위젯 구현
- [ ] 알림 시스템
- [ ] 통계 & 분석
- [ ] 스토어 배포

## 📊 성능 목표

- **앱 시작**: Cold start < 2초
- **메모리 사용**: < 100MB
- **프레임 레이트**: 60fps 유지
- **배터리 사용**: 일일 < 1%

## 🧪 테스트

```bash
# 단위 테스트 실행
flutter test

# 테스트 커버리지 확인
flutter test --coverage

# 통합 테스트
flutter test integration_test
```

## 📄 문서

- [상세 PRD](docs/plans/routine_mate_detailed_prd.md)
- [Phase별 작업 계획](docs/plans/)
- [작업 규칙](docs/plans/000.작업_규칙.md)
- [데이터베이스 설계](docs/plans/003.데이터베이스_변경_sqlite.md)
- [작업 일지](docs/worklogs/)

### 구현 완료 문서
- [Phase 1: 데이터베이스 구축](docs/worklogs/004.phase1_기초설정_데이터베이스.md)
- [Phase 2: UI 시스템 구현](docs/worklogs/002.phase2_ui_구현.md)
- [Phase 3: 상태관리 구현](docs/worklogs/006.phase3_상태관리_데이터연동.md)
- [요일 설정 기능](docs/worklogs/012.요일_설정_기능.md)

## 🤝 기여하기

이 프로젝트는 개인 학습 목적으로 진행되고 있습니다.
피드백과 제안은 언제나 환영합니다!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📮 연락처

**Developer**: August Kim
**Email**: august@routinemate.app
**GitHub**: [@Augustkim-dev](https://github.com/Augustkim-dev)

## 📝 라이센스

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  Made with ❤️ using Flutter

  ⭐ Star this repo if you find it helpful!
</div>
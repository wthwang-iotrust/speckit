# speckit Roadmap

## Vision

> "잘 해줘"는 명세가 아니다.

speckit은 AI를 "해결사"로 만드는 도구다.
모호한 위임을 기준과 근거 기반의 위임으로 전환한다. 개발에서 시작하지만, 개발에 머물지 않는다.
디자인, 전략, 프로세스, 어떤 도메인이든 "알아서 잘"이 필요한 곳에 기준을 세운다.

```
v0.3.x (현재)     v0.4.0              v1.0
─────────────     ──────              ────
개발 spec 생성기   팀 협업 + 학습     도메인 확장 — 해결사 완성
"기준을 만든다"   "기준이 누적된다"   "어떤 요청이든 기준으로 전환한다"
```

```
                    speckit v1.0
                    ┌─────────┐
                    │  Router  │ ← "이 화면 디자인해줘" / "마케팅 전략 세워줘" / "API 만들어줘"
                    └────┬────┘
           ┌─────────────┼─────────────┐
           ▼             ▼             ▼
    ┌──────────┐  ┌──────────┐  ┌──────────┐
    │ dev/     │  │ design/  │  │ strategy/│  ...
    │ 기능     │  │ 무드     │  │ 타겟     │
    │ 시각     │  │ 레이아웃 │  │ 채널     │
    │ 인터랙션 │  │ 타이포   │  │ KPI      │
    │ 제약조건 │  │ 컬러     │  │ 제약     │
    │ 테스트   │  │ 계층구조 │  │ 타임라인 │
    └──────────┘  └──────────┘  └──────────┘
           │             │             │
           ▼             ▼             ▼
        spec 출력 + (reason: ...) 근거
```

---

## v0.3.0 — 해결사 기반 확립 (완료)

### 달성 결과

- SKILL.md 프롬프트 품질: 5.2/10 → **9/10** (Codex 독립 검증)
- 결정적 상태 머신: route → context → spec → STOP
- fast path: trivial 작업 3줄 micro-spec
- decision 누적 구조 (opt-in)
- spec → implement 핸드오프 가이드
- 백엔드 프로젝트 지원

### v0.3.1 (현재)

- SKILL.md 레포 루트로 이동 (Claude Code 스킬 디스커버리 수정)

---

## v0.4.0 — 팀 협업 + 학습

### 목표

1. 팀 전체가 같은 기준으로 일한다
2. 반복되는 판단이 자동으로 축적된다
3. 실사용 피드백 기반으로 속성 품질을 올린다

### 기능

| # | 항목 | 설명 |
|---|------|------|
| F1 | 팀 decisions 공유 | `.speckit/decisions.md`를 git으로 공유. 팀 전체 판단 기준 통일. 새 멤버도 "우리 팀은 인증을 이렇게 한다"를 자동으로 알게 됨. |
| F2 | spec 품질 자동 채점 | 생성된 spec의 구체성을 자동 평가. vague 필드 감지 ("fast" → 경고, "LCP < 2.5s" → 통과). 팀 전체 spec 품질 바닥선 유지. |
| F3 | 다른 스킬과 연동 | gstack `/plan-eng-review`가 spec을 입력으로 받아 리뷰. spec이 구현의 입력이자 리뷰의 기준이 되는 파이프라인. |
| F4 | spec 히스토리 | 같은 기능의 spec 변경 이력 추적. "2달 전 로그인 spec은 이랬는데 지금은 이렇다". |

### 검증 계획

- 팀 내 2명 이상이 같은 프로젝트에서 speckit 사용 → decisions 충돌 없이 누적되는지
- spec 품질 채점이 실제 구현 품질과 상관관계 있는지
- 기존 gstack 워크플로우에 자연스럽게 끼워지는지

---

## v1.0 — 도메인 확장, 해결사 완성

### 핵심 전환

speckit이 "개발 명세 도구"에서 **"모든 도메인의 기준 생성기"**로 확장된다.
"알아서 잘 해줘"가 통하는 모든 영역에서, "이 기준대로 해줘"를 자동 생성한다.

### 도메인 팩 구조

```
speckit/
├── SKILL.md                    # 도메인 감지 + 라우팅
├── domains/
│   ├── dev/                    # 개발 (현재 speckit의 모든 것)
│   │   ├── attributes/
│   │   │   ├── functional.md
│   │   │   ├── visual.md
│   │   │   ├── interaction.md
│   │   │   ├── constraint.md
│   │   │   ├── test-strategy.md
│   │   │   └── acceptance.md
│   │   └── presets/
│   │
│   ├── design/                 # 디자인
│   │   ├── attributes/
│   │   │   ├── mood.md         # 무드보드, 톤앤매너, 레퍼런스
│   │   │   ├── layout.md       # 구도, 그리드, 여백, 비율
│   │   │   ├── typography.md   # 서체, 크기 체계, 행간
│   │   │   ├── color.md        # 팔레트, 대비, 의미 체계
│   │   │   ├── hierarchy.md    # 정보 우선순위, 시선 흐름
│   │   │   └── constraint.md   # 브랜드 가이드라인, 접근성, 매체 제약
│   │   └── presets/
│   │
│   ├── strategy/               # 전략/기획
│   │   ├── attributes/
│   │   │   ├── target.md       # 타겟/페르소나, 세그먼트
│   │   │   ├── channel.md      # 채널, 수단, 터치포인트
│   │   │   ├── message.md      # 핵심 메시지, 톤, 차별화 포인트
│   │   │   ├── metric.md       # KPI, 측정 방법, 목표치
│   │   │   ├── timeline.md     # 일정, 마일스톤, 의존성
│   │   │   └── constraint.md   # 예산, 리소스, 법적 제약
│   │   └── presets/
│   │
│   └── process/                # 프로세스/운영
│       ├── attributes/
│       │   ├── as-is.md        # 현재 상태, 문제점, 측정값
│       │   ├── to-be.md        # 목표 상태, 개선 방향
│       │   ├── steps.md        # 단계별 절차, 담당, 도구
│       │   ├── metric.md       # 측정 지표, 모니터링
│       │   └── constraint.md   # 제약조건, 변경 관리
│       └── presets/
│
├── presets/                    # 글로벌 프리셋 (도메인 간 공유)
└── .speckit/decisions.md       # 프로젝트 판단 누적 (도메인 공통)
```

### 도메인 라우팅

| 요청 패턴 | 도메인 | 예시 |
|----------|--------|------|
| 만들어줘, 구현, 기능, API, 버그 | `dev` | "로그인 페이지 만들어줘" |
| 디자인, UI, 화면 설계, 목업, 와이어프레임 | `design` | "대시보드 디자인해줘" |
| 전략, 마케팅, 기획, 캠페인, GTM | `strategy` | "Q3 마케팅 전략 세워줘" |
| 프로세스, 개선, 온보딩, 워크플로우 | `process` | "코드 리뷰 프로세스 개선해줘" |
| (감지 불가) | `dev` (기본값) | "이거 좀 고쳔줘" |

### 도메인 공통 원칙

모든 도메인이 공유하는 불변 규칙:

1. **Never ask. Analyze, decide, output, stop.** 도메인이 뭐든 동일.
2. **Every choice gets `(reason: ...)`**. 디자인이든 전략이든 근거 필수.
3. **Match existing context.** 프로젝트에 브랜드 가이드라인이 있으면 따르고, 기존 전략 문서가 있으면 참조.
4. **Right-size.** 간단한 요청에 30페이지 전략서 쓰지 않는다.
5. **Constraint is non-negotiable.** 모든 도메인에 제약조건 섹션 존재.

### 검증 계획

| 도메인 | 테스트 요청 | 기대 결과 |
|--------|-----------|----------|
| design | "랜딩페이지 디자인해줘" | mood + layout + typography + color + hierarchy spec |
| strategy | "신규 기능 GTM 전략 세워줘" | target + channel + message + metric + timeline spec |
| process | "배포 프로세스 개선해줘" | as-is + to-be + steps + metric spec |
| 크로스도메인 | "새 제품 런칭해줘" | dev + design + strategy 복합 spec |

---

## 완료 기록

### v0.1.0 (2026-04-09)
- 초기 릴리즈: SKILL.md, 6개 attribute, preset, install.sh

### v0.2.0 (2026-04-09)
- Codex 리뷰 기반 품질 개선
- spec-only 모드 확립 (auto-implement 제거)
- 10개 이슈 수정 (P0 3개, P1 3개, P2 4개)

### v0.3.0 (2026-04-09)
- 프롬프트 품질 5.2/10 → 9/10 (Codex 2회 검증)
- 결정적 상태 머신, fast path, decision 누적, 백엔드 지원

### v0.3.1 (2026-04-09)
- SKILL.md 레포 루트 이동 (Claude Code 디스커버리 수정)

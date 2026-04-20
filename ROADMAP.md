# speckit Roadmap

## Vision

> "잘 해줘"는 명세가 아니다.

speckit은 AI를 "해결사"로 만드는 도구다.
모호한 위임을 기준과 근거 기반의 위임으로 전환한다. 개발에서 시작하지만, 개발에 머물지 않는다.
디자인, 전략, 프로세스, 어떤 도메인이든 "알아서 잘"이 필요한 곳에 기준을 세운다.

```
v0.3.x (현재)     v0.4.0              v0.5.0            v1.0
─────────────     ──────              ──────            ────
단일 dev 도메인    구조 리팩토링       design 도메인      strategy + process
flat attributes   domains/ 구조       두 번째 도메인      해결사 완성
                  팀 decisions        크로스도메인 검증
```

```
                    speckit v1.0
                    ┌─────────┐
                    │  Router  │ ← "디자인해줘" / "전략 세워줘" / "API 만들어줘"
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

## Architecture Decisions (eng review 기반)

### AD-1: SKILL.md는 라우터만, 도메인 로직은 분리

SKILL.md가 모든 도메인의 Phase 지시를 담으면 500줄+ → 컨텍스트 낭비.
SKILL.md는 라우터 + 공통 Phase만, 도메인별 차이는 `domains/{domain}/instructions.md`에서 Read로 로드.

### AD-2: 도메인별 속성 경로 통일

`$SPECKIT_DIR/domains/$DOMAIN/attributes/{attribute}.md` 패턴.
도메인 간 같은 이름(constraint.md)이 있어도 경로로 구분.

### AD-3: 기존 사용자 마이그레이션

v0.4.0에서 `attributes/` → `domains/dev/attributes/` 이동.
SKILL.md에 fallback: 루트 `attributes/`가 있으면 레거시로 감지, 경고 + 정상 동작.
install.sh에 마이그레이션 로직 추가.

### AD-4: 점진 확장 (incremental delivery)

한 번에 4개 도메인이 아니라, 도메인 하나씩 추가하며 실사용 검증.
"boring by default" — 검증 안 된 도메인을 동시에 출시하지 않는다.

---

## v0.3.0 — 해결사 기반 확립 (완료)

- SKILL.md 프롬프트 품질: 5.2/10 → **9/10** (Codex 독립 검증 2회)
- 결정적 상태 머신, fast path, decision 누적, 백엔드 지원

### v0.3.1 (현재)

- SKILL.md 레포 루트로 이동 (Claude Code 디스커버리 수정)

---

## v0.4.0 — 구조 리팩토링 + 팀 기반

### 목표

1. `domains/` 구조로 전환 (dev 도메인만, 기능 변화 없음)
2. 팀 decisions 공유 기반 확립
3. 기존 사용자 마이그레이션 경로 제공

### 작업

| # | 항목 | 설명 |
|---|------|------|
| R1 | 디렉토리 구조 전환 | `attributes/` → `domains/dev/attributes/`, `presets/` → `domains/dev/presets/` |
| R2 | SKILL.md 라우터 분리 | 공통 Phase(0, 0.5, 3) + 도메인 라우터. dev 도메인 로직은 `domains/dev/instructions.md`로 이동 |
| R3 | 레거시 fallback | 루트 `attributes/` 감지 시 경고 + 정상 동작 |
| R4 | install.sh 마이그레이션 | 기존 설치 감지 → 구조 자동 이동 |
| F1 | 팀 decisions 공유 | `.speckit/decisions.md`를 git 추적 권장. README에 팀 사용 가이드 추가 |
| F2 | spec 품질 자동 채점 | 생성된 spec의 vague 필드 감지, 경고 표시 |

### 검증

- `git pull` 후 기존 `/speckit` 호출이 동일하게 동작하는지
- `domains/dev/` 경로에서 attribute 로딩이 정상인지
- 레거시 `attributes/` 경로에서도 fallback 동작하는지

---

## v0.5.0 — design 도메인 추가

### 목표

1. 두 번째 도메인(design) 추가로 멀티 도메인 구조 검증
2. 디자인 요청에 대한 spec 품질 실사용 테스트
3. 도메인 간 라우팅 정확도 확인

### 작업

| # | 항목 | 설명 |
|---|------|------|
| D1 | design attribute 작성 | mood.md, layout.md, typography.md, color.md, hierarchy.md, constraint.md (각각 BAD/GOOD 예시 포함) |
| D2 | design instructions.md | 디자인 도메인 전용 Phase 지시 (컨텍스트 스캔: DESIGN.md, Figma 링크, 브랜드 가이드라인 등) |
| D3 | design presets | 기본 카테고리: ui-design, branding, wireframe, visual-audit |
| D4 | 라우터 업데이트 | "디자인", "UI", "목업", "와이어프레임" → design 도메인 |
| D5 | 크로스 도메인 테스트 | "로그인 페이지 디자인해줘" → design? dev? 둘 다? |

### design 도메인 속성 구조

```
domains/design/
├── instructions.md
├── attributes/
│   ├── mood.md         # 무드보드, 톤앤매너, 레퍼런스 이미지
│   ├── layout.md       # 구도, 그리드, 여백, 비율, 반응형
│   ├── typography.md   # 서체 선택, 크기 체계, 행간, 가독성
│   ├── color.md        # 팔레트, 대비, 의미 체계, 다크모드
│   ├── hierarchy.md    # 정보 우선순위, 시선 흐름, CTA 배치
│   └── constraint.md   # 브랜드 가이드라인, 접근성, 매체 제약
└── presets/
    └── default.json
```

### 검증

| 테스트 | 입력 | 기대 도메인 | 기대 속성 |
|--------|------|-----------|----------|
| 디자인 요청 | "대시보드 디자인해줘" | design | mood + layout + color + hierarchy |
| 개발 요청 | "대시보드 만들어줘" | dev | functional + visual + interaction |
| 모호한 요청 | "대시보드 좀 바꿔줘" | 컨텍스트 기반 판단 | 코드 존재 → dev, 디자인 파일만 → design |
| 크로스 도메인 | "로그인 페이지 디자인하고 만들어줘" | design + dev 복합 | 양쪽 속성 모두 |

---

## v0.6.0 — 디자이너 현실 반영 (Designer Reality)

### 목표

1. 실제 디자이너가 AI와 작업하며 겪는 7가지 반복 고충을 design 도메인에 구조화
2. 스펙 단계에서 "변경 전 합의" / "스코프 가드" / "레퍼런스 필수" 강제
3. 6개 기존 속성에 AI Anti-patterns 섹션 추가 — AI의 기본 실수 패턴을 미리 차단

### 해결하는 고충 (pain points)

| # | 고충 | 담당 속성 |
|---|------|----------|
| 1 | 5~10회 반복 수정 루프 | workflow (Pre-change Agreement, Iteration Prevention) |
| 2 | 원본에 없는 섹션/CTA/뱃지 임의 추가 | scope (Inclusion, Exclusion, Addition Policy) |
| 3 | 모바일이 후순위라 데스크톱 완성 후 깨짐 발견 | layout (Responsive VERIFICATION RULE), workflow (Multi-viewport) |
| 4 | "이런 느낌으로" 5라운드 오해 | workflow (Reference-first Rule), mood (Reference Requirement) |
| 5 | 디자인 토큰 드리프트 (거의 비슷한 hex/px) | constraint (Design System Token Adherence) |
| 6 | 카피 환각 (원본에 없는 문구/수치 생성) | scope (Copy Fidelity) |
| 7 | 점진적 피드백의 패치 누적 | workflow (Iteration Prevention) |

### 작업

| # | 항목 | 설명 |
|---|------|------|
| N1 | 신규 속성 workflow.md | 변경 전 합의, 체크리스트, 반복 방지, 멀티 뷰포트, 레퍼런스 필수, 스코프 확인 |
| N2 | 신규 속성 scope.md | 소스 단일 근거, inclusion/exclusion, 추가 정책, 수정 경계, 카피 충실성 |
| E1 | 6개 속성에 AI Anti-patterns 섹션 추가 | mood / layout / typography / color / hierarchy / constraint |
| E2 | mood.md — Reference Requirement 섹션 | 주관적 형용사 → 레퍼런스 강제 |
| E3 | layout.md — Responsive VERIFICATION RULE 강화 | 데스크톱/모바일 동시 검증 규정 |
| E4 | hierarchy.md — Scope Guard 섹션 | 원본에 없는 primary 요소 발명 금지 |
| E5 | constraint.md — Design System Token Adherence | 기존 토큰만 사용, ad-hoc 값 금지 |
| P1 | presets/designer-strict.json 추가 | 모든 카테고리에 workflow + scope 포함 |
| P2 | presets/default.json 업데이트 | ui-design / wireframe / visual-audit에 workflow·scope 선택 추가 |
| D1 | pain-points.md 메타 문서 | 7가지 고충과 각 속성의 대응 매핑 |
| D2 | instructions.md 업데이트 | 카테고리, 라우팅 룰, 기본값, 섹션 카운트, 출력 템플릿 반영 |
| D3 | SKILL.md 업데이트 | design 도메인 valid attributes에 workflow, scope 추가 |
| D4 | README.md 업데이트 | Design Categories 표에 workflow/scope 반영 |

### 검증

| 테스트 | 입력 | 기대 동작 |
|--------|------|----------|
| 주관적 언어 | "좀 더 모던하게 해줘" | workflow의 Reference-first로 레퍼런스 요청 |
| 소스 제공 | "이 와이어프레임대로 만들어" | scope 활성화, Copy Fidelity 규칙 적용 |
| 수정 요청 | "이 페이지 좀 개선해" | workflow + scope 둘 다 활성화 |
| 토큰 존재 프로젝트 | CSS 변수 detected | constraint의 Token Adherence 자동 강화 |
| 점진적 피드백 3+ 이슈 | "A도 고치고 B도 고치고..." | workflow의 Iteration Prevention으로 consolidated rewrite 제안 |

---

## v1.0 — 해결사 완성

### 전제 조건

- v0.5.0의 design 도메인이 실사용에서 검증됨
- 도메인 라우팅 정확도 90%+ 확인
- 크로스 도메인 spec 품질이 단일 도메인과 동등

### 추가 도메인

| 도메인 | 속성 | 대표 요청 |
|--------|------|----------|
| strategy | target, channel, message, metric, timeline, constraint | "Q3 마케팅 전략 세워줘" |
| process | as-is, to-be, steps, metric, constraint | "코드 리뷰 프로세스 개선해줘" |

### 도메인 공통 원칙 (불변)

1. **Never ask. Analyze, decide, output, stop.** 도메인 무관.
2. **Every choice gets `(reason: ...)`**. 근거 없는 판단 없음.
3. **Match existing context.** 프로젝트 기존 자산 우선 참조.
4. **Right-size.** 간단한 요청에 30줄 보고서 안 씀.
5. **Constraint is non-negotiable.** 모든 도메인에 제약조건 존재.

---

## 완료 기록

### v0.1.0 (2026-04-09)
- 초기 릴리즈: SKILL.md, 6개 attribute, preset, install.sh

### v0.2.0 (2026-04-09)
- Codex 리뷰 기반 품질 개선, spec-only 모드 확립

### v0.3.0 (2026-04-09)
- 프롬프트 품질 5.2/10 → 9/10 (Codex 2회 검증)

### v0.3.1 (2026-04-09)
- SKILL.md 레포 루트 이동 (Claude Code 디스커버리 수정)

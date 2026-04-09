# speckit Roadmap

## Vision

> "잘 해줘"는 명세가 아니다.

speckit은 AI를 "해결사"로 만드는 도구다. 모호한 위임을 기준과 근거 기반의 위임으로 전환한다.
spec 생성에서 시작해, 기준 기반 구현, 프로젝트 수준 판단 누적까지 확장한다.

```
v0.2.0 (현재)     v0.3.0              v0.4.0+
─────────────     ──────              ───────
spec 생성기   →   해결사 기반 확립  →   팀 협업 도구
"기준을 만든다"   "기준대로 수행한다"   "기준이 학습된다"
```

---

## v0.3.0 — 해결사 기반 확립

### 목표

1. SKILL.md 프롬프트 품질을 실전 수준으로 끌어올린다
2. spec → implement 연결을 만든다
3. 프로젝트 수준 판단이 누적되는 구조를 만든다

### 프롬프트 품질 개선 (평균 5.2/10 → 8/10 목표)

| # | 항목 | 현재 문제 | 수정 방향 | 영향 차원 |
|---|------|----------|----------|----------|
| P1 | 지시 충돌 해소 | "STOP" vs "implementation begins" 공존 | footer의 "implementation begins" 제거. STOP이 유일한 종료 지시. spec 확정 후 구현은 별도 스킬이나 사용자 다음 메시지에서 시작. | 지시 계층 |
| P2 | Phase 0 중간 요약 강제 | 수집만 하고 요약 없음 | Phase 0 끝에 내부 요약 강제: `CONTEXT: stack={}, design_system={}, auth={}, test_framework={}, patterns={}`. Phase 2에서 이 요약을 참조하도록 명시. | 컨텍스트 활용 |
| P3 | Glob/Grep 구체화 | "Also read with Glob/Grep" (모호) | 구체적 패턴 목록으로 교체. 예: `Grep "export default" glob="*.tsx" \| head -5` / `Grep "className=" glob="*.tsx" \| head -3` / `Glob "**/*.test.*"` | 행동 명확성 |
| P4 | 분량 가이드 구체화 | "Right-size" (해석 여지) | 섹션별 항목 수 명시. Edge Cases: 2-5개. Business Logic: 1-3개. Test Strategy: 주요 시나리오 3-7개. trivial은 전체 3-5줄, small은 10-20줄, medium은 50-100줄, large는 100줄+. | 출력 제어 |
| P5 | 에러 복구 경로 추가 | happy path만 존재 | 매 Phase에 fallback 추가. Phase 0 bash 실패 → Glob/Read로 재시도. attribute 파일 없음 → inline 지식으로 진행. 카테고리 판단 불가 → general + 경고 메시지. 사용자 요청 해석 불가 → 가장 가까운 해석으로 진행 + 해석 명시. | 에러 복구 |
| P6 | 중복 제거 | preset JSON이 SKILL.md에도 있고 파일에도 있음 | SKILL.md 내 JSON 예시 제거. `Read "$SPECKIT_DIR/presets/default.json"` 참조만. | 토큰 효율 |

### 제품 기능

| # | 항목 | 설명 |
|---|------|------|
| F1 | spec → implement 연결 | spec 확정 후, 다음 구현 단계에서 spec을 source of truth로 참조하는 지시 추가. "이 spec의 Functional Attributes를 만족하도록 구현하라. 완료 후 Acceptance Criteria로 자가 검증하라." |
| F2 | 프로젝트 수준 reason 누적 | 반복되는 reason을 `.speckit/decisions.md`에 자동 축적. 다음 spec 생성 시 기존 decisions를 읽고 일관된 판단. 예: "인증은 항상 JWT + httpOnly cookie (reason: 2024-03 보안 감사 결과)" |
| F3 | 경량 모드 (fast path) | trivial 작업을 감지하면 전체 Phase를 건너뛰고 3-5줄 인라인 spec만 출력. 별도 Output Format 없이 바로 "Spec: {한 줄 요약}\n- {변경 내용}\n- {제약조건}" 형태. |

### 검증 계획

| 테스트 | 입력 | 기대 출력 | 검증 기준 |
|--------|------|----------|----------|
| 웹 프론트엔드 feature | "북마크 기능 추가해줘" (CBT 앱) | functional + visual + interaction + constraint | visual이 자동 포함되는지, reason이 코드베이스 기반인지 |
| trivial bugfix | "버튼 색상 #333으로 바꿔줘" | 3-5줄 경량 spec | 과잉 spec 없이 빠르게 끝나는지 |
| 빈 레포 | "로그인 페이지 만들어줘" | 기본값 기반 full spec | "no existing pattern" reason이 명시되는지 |
| 백엔드 API | "사용자 CRUD API 만들어줘" (Go 프로젝트) | functional + constraint + test-strategy | visual/interaction이 N/A로 처리되는지 |
| 모호한 요청 | "이거 좀 고쳐줘" | general 카테고리 + 경고 | fallback이 작동하는지, 해석을 명시하는지 |
| reason 누적 | 같은 프로젝트에서 2번째 spec | 이전 decisions 참조 | "기존 판단 참조: JWT + httpOnly (decisions.md:3)" |

---

## v0.4.0+ — 팀 협업 도구 (방향성)

아직 확정하지 않음. v0.3.0 실전 검증 후 결정.

- **팀 decisions 공유** — `.speckit/decisions.md`를 git으로 공유, 팀 전체 판단 기준 통일
- **spec 히스토리** — 같은 기능의 spec 변경 이력 추적
- **다른 스킬과 연동** — gstack의 `/plan-eng-review`가 spec을 입력으로 받아 리뷰
- **spec 품질 평가** — 생성된 spec의 구체성을 자동 채점 (vague 필드 감지)

---

## 완료 기록

### v0.1.0 (2026-04-09)
- 초기 릴리즈: SKILL.md, 6개 attribute, preset, install.sh

### v0.2.0 (2026-04-09)
- Codex 리뷰 기반 품질 개선
- spec-only 모드 확립 (auto-implement 제거)
- 10개 이슈 수정 (P0 3개, P1 3개, P2 4개)

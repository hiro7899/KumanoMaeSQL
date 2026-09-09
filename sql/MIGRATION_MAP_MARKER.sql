--------------------------------------------------------------------------------
-- KumanoMae 마이그레이션 — 지도 마커 뷰에 위험해제(CLEAR) 상태 별도 노출
-- CREATE OR REPLACE VIEW라 재실행 안전, 신규/기존 배포 모두 이 스크립트만 실행하면 됨
--------------------------------------------------------------------------------

CREATE OR REPLACE VIEW V_MAP_MARKER AS
SELECT
    'USER'                 AS SOURCE_TYPE,
    BOARD_ID                AS TARGET_ID,
    TITLE,
    RISK_LEVEL,                                                  -- ★ 원본 위험도 그대로 노출 (DANGER/WARNING/CAUTION)
    CLEAR_YN,                                                     -- ★ 해제 여부 원본값도 노출 (Y/N)
    CASE WHEN CLEAR_YN = 'Y' THEN 'CLEAR' ELSE RISK_LEVEL END AS DISPLAY_RISK,  -- ★ 'CLEARED' → 'CLEAR'로 통일
    LATITUDE, LONGITUDE, ADDRESS,
    SIGHTING_DATE           AS EVENT_DATE,
    REG_DATE
FROM BOARD
WHERE STATUS = 'Y'
UNION ALL
SELECT
    CASE WHEN SOURCE_TYPE = 'GOV' THEN 'OFFICIAL_GOV' ELSE 'OFFICIAL_NEWS' END,
    NEWS_ID,
    TITLE,
    RISK_LEVEL,
    'N' AS CLEAR_YN,                                              -- 뉴스/공지는 해제 개념 자체가 없음 - 항상 N
    NVL(RISK_LEVEL, 'CAUTION'),
    LATITUDE, LONGITUDE, REGION_TEXT,
    PUBLISHED_DATE,
    COLLECTED_DATE
FROM NEWS_ALERT
WHERE LATITUDE IS NOT NULL AND LONGITUDE IS NOT NULL;
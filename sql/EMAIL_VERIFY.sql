--------------------------------------------------------------------------------
-- KumanoMae 마이그레이션 — 이메일 인증 / 비밀번호 재설정 기능 추가
-- 이미 배포된 DB(MEMBER, BOARD 등 기존 테이블이 존재하는 상태)에 실행
-- 실행 전 백업 권장
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 0. 롤백용 (혹시 되돌려야 할 경우 아래를 실행 - 평소엔 주석 처리)
--------------------------------------------------------------------------------
-- DROP TABLE EMAIL_TOKEN PURGE;
-- DROP SEQUENCE EMAIL_TOKEN_ID_SEQ;
-- ALTER TABLE MEMBER DROP CONSTRAINT CK_MEMBER_EMAIL_VERIFIED;
-- ALTER TABLE MEMBER DROP COLUMN EMAIL_VERIFIED_YN;


--------------------------------------------------------------------------------
-- 1. MEMBER 테이블에 이메일 인증 여부 컬럼 추가
--------------------------------------------------------------------------------
ALTER TABLE MEMBER ADD (
    EMAIL_VERIFIED_YN CHAR(1) DEFAULT 'N' NOT NULL
);

ALTER TABLE MEMBER ADD CONSTRAINT CK_MEMBER_EMAIL_VERIFIED CHECK (EMAIL_VERIFIED_YN IN ('Y','N'));

COMMENT ON COLUMN MEMBER.EMAIL_VERIFIED_YN IS '이메일 인증 완료 여부(N이면 로그인 차단)';

-- ⚠️ 이미 가입되어 있는 기존 회원들은 EMAIL_VERIFIED_YN='N'으로 채워지므로
--    이 상태로 두면 전부 로그인이 막힙니다. 아래 둘 중 하나를 선택하세요.

-- 선택 A) 기존 회원은 전부 인증된 것으로 간주하고 넘어간다 (테스트/소규모 팀 프로젝트에 무난)
UPDATE MEMBER SET EMAIL_VERIFIED_YN = 'Y';

-- 선택 B) 기존 회원도 전부 재인증 메일을 받아야 한다면 위 UPDATE 문은 실행하지 말고
--        대신 관리자가 회원별로 이메일 재발송 처리를 하거나, 로그인 시 자동으로
--        인증 메일을 재발송하는 로직을 LoginService에 추가해야 합니다 (필요하면 요청해 주세요).


--------------------------------------------------------------------------------
-- 2. EMAIL_TOKEN 테이블 신규 생성
--------------------------------------------------------------------------------
CREATE SEQUENCE EMAIL_TOKEN_ID_SEQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE EMAIL_TOKEN (
    TOKEN_ID     NUMBER              NOT NULL,
    MEMBER_ID    NUMBER              NOT NULL,
    TOKEN        VARCHAR2(64 CHAR)   NOT NULL,
    TOKEN_TYPE   VARCHAR2(20 CHAR)   NOT NULL,
    EXPIRE_DATE  DATE                NOT NULL,
    USED_YN      CHAR(1)             DEFAULT 'N' NOT NULL,
    REG_DATE     DATE                DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_EMAIL_TOKEN        PRIMARY KEY (TOKEN_ID),
    CONSTRAINT UQ_EMAIL_TOKEN_TOKEN  UNIQUE (TOKEN),
    CONSTRAINT FK_EMAILTOKEN_MEMBER  FOREIGN KEY (MEMBER_ID) REFERENCES MEMBER (MEMBER_ID) ON DELETE CASCADE,
    CONSTRAINT CK_EMAILTOKEN_TYPE    CHECK (TOKEN_TYPE IN ('SIGNUP_VERIFY','PASSWORD_RESET')),
    CONSTRAINT CK_EMAILTOKEN_USED    CHECK (USED_YN IN ('Y','N'))
);

CREATE INDEX IDX_EMAILTOKEN_LOOKUP ON EMAIL_TOKEN (TOKEN, TOKEN_TYPE);

COMMENT ON TABLE  EMAIL_TOKEN             IS '회원가입 인증 / 비밀번호 재설정 공용 토큰';
COMMENT ON COLUMN EMAIL_TOKEN.TOKEN_ID    IS '토큰 번호(PK)';
COMMENT ON COLUMN EMAIL_TOKEN.MEMBER_ID   IS '대상 회원(FK→MEMBER, 회원 삭제 시 CASCADE)';
COMMENT ON COLUMN EMAIL_TOKEN.TOKEN       IS '실제 토큰 문자열(UUID 등, URL에 노출됨)';
COMMENT ON COLUMN EMAIL_TOKEN.TOKEN_TYPE  IS 'SIGNUP_VERIFY:가입인증, PASSWORD_RESET:비밀번호재설정';
COMMENT ON COLUMN EMAIL_TOKEN.EXPIRE_DATE IS '만료 일시';
COMMENT ON COLUMN EMAIL_TOKEN.USED_YN     IS '사용 완료 여부(재사용 방지)';
COMMENT ON COLUMN EMAIL_TOKEN.REG_DATE    IS '발급 일시';


--------------------------------------------------------------------------------
-- 3. 확인용 조회 (선택 실행)
--------------------------------------------------------------------------------
-- SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'MEMBER' AND COLUMN_NAME = 'EMAIL_VERIFIED_YN';
-- SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME = 'EMAIL_TOKEN';
-- SELECT COUNT(*) FROM MEMBER WHERE EMAIL_VERIFIED_YN = 'N';

COMMIT;
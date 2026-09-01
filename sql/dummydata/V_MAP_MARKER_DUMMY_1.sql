INSERT INTO BOARD (
    BOARD_ID,
    MEMBER_ID,
    TITLE,
    CONTENT,
    RISK_LEVEL,
    LATITUDE,
    LONGITUDE,
    ADDRESS,
    SIGHTING_DATE,
    STATUS
) VALUES (
    BOARD_ID_SEQ.NEXTVAL,
    1,
    '테스트 곰 출몰',
    '지도 마커 테스트용 데이터입니다.',
    'DANGER',
    35.6895,
    139.6917,
    '東京都',
    SYSDATE,
    'Y'
);

COMMIT;

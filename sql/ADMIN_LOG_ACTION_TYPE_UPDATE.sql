--------------------------------------------------------------------------------
-- ADMIN_LOG.ACTION_TYPE에 HIDE / SHOW 추가
--------------------------------------------------------------------------------

ALTER TABLE ADMIN_LOG DROP CONSTRAINT CK_ADMINLOG_ACTION;

ALTER TABLE ADMIN_LOG ADD CONSTRAINT CK_ADMINLOG_ACTION
    CHECK (ACTION_TYPE IN (
        'APPROVE',
        'REJECT',
        'DELETE',
        'CLEAR',
        'UPDATE_GRADE',
        'HIDE',
        'SHOW'
    ));

COMMENT ON COLUMN ADMIN_LOG.ACTION_TYPE
    IS 'APPROVE/REJECT/DELETE/CLEAR/UPDATE_GRADE/HIDE/SHOW';

COMMIT;

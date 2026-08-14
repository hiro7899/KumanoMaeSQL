# 🗄️ KumanoMaeSQL

프로젝트의 데이터베이스(Oracle DB) 구조(DDL) 및 초기 데이터(DML) 스크립트를 중앙 관리하고 공유하기 위한 리포지터리입니다.

## 🚨 업로드 규칙 (필독!)

안전하고 원활한 DB 스크립트 공유를 위해 아래 규칙을 반드시 지켜주세요.

1. **파일 확장자 제한**
   - 모든 파일은 반드시 `.sql` 형식으로만 업로드해 주세요.
   - 예: `schema.sql` (O) / `schema.txt` (X)

2. **DCL(데이터 제어어) 업로드 금지!** 🚫
   - `GRANT`, `REVOKE`, `CREATE USER` 등 권한 및 계정 제어와 관련된 스크립트는 **절대 올리지 말아주세요.**
   - (사유: 팀원마다 로컬 DB 계정 환경이 다르므로 실행 시 충돌 및 에러가 발생합니다.)

3. **파일명 네이밍 컨벤션 (권장)**
   - 실행 순서를 알 수 있도록 파일명 앞에 번호를 붙여주세요.
   - 🏗️ 구조 생성(DDL): `01_schema_DDL.sql`
   - 📝 데이터 삽입(DML): `02_dummy_DML.sql`

4. **쿼리 작성 규칙**
   - SQL 예약어(SELECT, INSERT 등)와 테이블/컬럼명은 **대문자(UPPER_SNAKE_CASE)**로 작성하여 가독성을 높여주세요.


## 📐 ERD (Entity Relationship Diagram) 공유 규칙

데이터베이스 구조를 한눈에 파악하고 수정하기 위해 ERD 파일과 이미지 파일을 함께 업로드합니다.

### 1. 업로드 파일 형식
ERD 추가/수정 시 `erd/` 폴더 내에 **두 가지 형식**으로 함께 올려주세요.

1. **이미지 파일 (`.png` 또는 `.svg`)**: 
   - GitHub 웹 화면에서 툴 설치 없이 바로 확인하기 위한 용도
   - 예: `erd/kumano_mae_erd.png`
2. **ERD 편집용 원본 파일 (`.drawio`, `.erd.json` 등)**:
   - 추후 테이블 구조 수정 시 불러와서 편집하기 위한 용도
   - 예: `erd/kumano_mae_erd.drawio`

### 2. 추천 작성 툴 (무료 및 가벼운 툴)
- **[draw.io](https://app.diagrams.net/) (강력 추천 ⭐)**: 
  - 무료이며, VS Code 확장 프로그램(`Draw.io Integration`)으로 편하게 편집 가능
- **[ERD-Cloud](https://www.erdcloud.com/)**: 
  - 웹 기반 무료 ERD 툴이며, 오라클 SQL DDL을 자동 추출할 수 있어 매우 유용함

### 3. ERD 표기 규칙
- 테이블명 및 컬럼명은 DDL 스크립트와 동일하게 **대문자 (`UPPER_SNAKE_CASE`)**로 작성해 주세요.
- Primary Key (PK), Foreign Key (FK), Not Null 여부와 데이터 타입(VARCHAR2, NUMBER, DATE 등)을 명확히 표기해 주세요.

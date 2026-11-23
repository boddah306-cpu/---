개발 내용
- 자동 패치 현황 화면 (http://localhost:8303/dash/auto-patch.do)
  - 패치 진행 현황 패널
    - TB_TDBAPM001 테이블을 참조하여 pie chart 생성 
    - 목업데이터 이용
  - SW 설치 현황 패널
    - TB_TDBAPM001 테이블을 참조하여 reverse bar chart 생성
    - 목업데이터 이용
  - Agent 운영 현황 패널
    - TB_TDBAPM001 테이블을 참조하여 bar chart 생성
    - 목업데이터 이용
  - os 패치율 패널
    - TB_TDBAPM001 테이블을 참조하여 pie chart 생성
    - 목업데이터 이용
  - os 등록 현황 패널
    - TB_TDBAPM001 테이블을 참조하여 bar chart 생성
    - 목업데이터 이용
  - 패치 현황 패널
    - TB_TDBAPM001 테이블을 참조하여 테이블 생성
    - 목업데이터 이용

-공통
  - 모든 패널은 현재 영역 크기와 디자인을 유지하도록 구현
  - 위에서 명시한 테이블을 이용하여 가데이터를 입력하고 불러올수 있도록 컨트롤러, 서비스, 매퍼 구현 필요
  - 구현 후 playwright 확인
  - 접속 정보 admin / admin
  
 
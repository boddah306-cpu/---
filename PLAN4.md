개발 내용
- 교육 훈련 현황 화면 (http://localhost:8303/dash/edu-status.do)
  - 교육 개혁 현황 패널
    - TB_MEABAS001~008, TB_MEACOD001, TB_MEASTS001, TB_MECBAS001~005, TB_MECCOD001, TB_MEMBAS001, TB_MEPBAS001~002 테이블을 참조하여 데이터 매핑 
    - 목업데이터 이용
  - 컨텐츠별 교육 계획 패널
    - TB_MEABAS001~008, TB_MEACOD001, TB_MEASTS001, TB_MECBAS001~005, TB_MECCOD001, TB_MEMBAS001, TB_MEPBAS001~002 테이블을 참조하여 데이터 매핑
    - 목업데이터 이용
  - 교육 수료 현황
    - TB_MEABAS001~008, TB_MEACOD001, TB_MEASTS001, TB_MECBAS001~005, TB_MECCOD001, TB_MEMBAS001, TB_MEPBAS001~002 테이블을 참조하여 데이터 매핑
    - 목업데이터 이용
  - 교육 컨텐츠 이용 현황
    - TB_MEABAS001~008, TB_MEACOD001, TB_MEASTS001, TB_MECBAS001~005, TB_MECCOD001, TB_MEMBAS001, TB_MEPBAS001~002 테이블을 참조하여 데이터 매핑
    - 목업데이터 이용
    
-공통
  - 모든 패널은 현재 영역 크기와 디자인을 유지하도록 구현
  - 위에서 명시한 테이블을 이용하여 가데이터를 입력하고 불러올수 있도록 컨트롤러, 서비스, 매퍼 구현 필요
  - 구현 후 playwright 확인
  - 접속 정보 admin / admin
  
 
개발 내용
- 통합 관리 화면 (http://localhost:8303/dash/system2.do)
  - 관제설비 통합감시현황 패널
    - NT_SVR_CPU 테이블에서 IDLE_PCT가 높은 순서로 8대의 장비의 IDLE_PCT 상태를 표현 
      - 기존 CSS와 레이아웃은 유지하면서 server-grid 안에 장비 성능 수치를 bar 색상으로 표현 
      - 장비가 없을 경우는 공백으로 표현
        - 4대만 있을 경우 위의 4열만 표현 
        - 6대 있을 경우 위에 4대 아래 2대
      - bar 표현 방법은 IDLE_PCT 값의 PCT 수치 만큼 span을 표현
        - 97인경우 server-bars ok level-9 안의 9개 span의 색상을 green 색상으로 적용
  - 네트워크 감시 현황 패널 
    - 회선성능 Top 5 에 속한 장비들의 시계열 차트를 표현
      - 차트 영역 크기에 맞게 차트 크기 설정
      - IN/OUT BPS 의 사용량을 표현하고 G/M/B 변환 으로 표현 
      - x축 은 HH:mm 형식으로 표현 
      - 성능 수치는 CM_PERF_IF_LAST 테이블을 참조하여 표현 
  - 전산설비감시현황
    - 특정 그룹에 속한 CM_DEV10 중 DEV_KIND2 가 RTU 인 장비들의 센서 별 개수를 표현
      - 신호컴퓨터실, 전원실 각각 센서 갯수 표현 
        - 항온항습기, UPS, 배터리, 온습도 
        - 참조 쿼리 
          - SELECT
                A.MNG_NO,
                A.DEV_KIND1,
                A.DEV_KIND2,
                B.FMS_SEQ_NO,
                A.VENDOR,
                B.SENSOR_KIND,
                B.SENSOR_KIND_CODE,
                B.SENSOR_NAME
            FROM
                CM_DEV10 A,
                CM_FMS_SENSOR B
            WHERE 
                A.MNG_NO = B.MNG_NO
            GROUP BY CONNECT_TYPE
  - 통합이벤트 현황 패널
    - system2.jsp 마크업에 맞게 event-summary 장애 건수를 표현 
    - 기존 이벤트 쿼리로 event-table 동적으로 표현 
  - 자산관리현황 패널 
    - assetChart 할당 영역에 맞게 x-axis : reverse 된 bar 차트 표현
      - 가데이터 표현 (서비스요청, 자산요청, 유지보수요청)

  - 자동화패치 관리현황 패널
    - CREATE TABLE IF NOT EXISTS TB_TDBAPM001 (
      PATCH_ID            INT(10)     NOT NULL AUTO_INCREMENT COMMENT '패치 ID',
      PATCH_KIND          VARCHAR(50) NOT NULL  COMMENT '패치 유형',
      PATCH_NAME          VARCHAR(50) NOT NULL  COMMENT '패치 명',
      PATCH_OS            VARCHAR(50) NOT NULL  COMMENT '패치 대상 OS',
      TOTAL_PATCH         INTEGER(10) NULL      COMMENT '전체 패치 건수',
      TOTAL_COMPL         INTEGER(10) NULL      COMMENT '전체 완료 패치 건수',
      TOTAL_ROLLBACK      INTEGER(10) NULL      COMMENT '롤백 대상 패치 건수',
      TOTAL_ROLLBACK_TMPL INTEGER(10) NULL      COMMENT '롤백 완료 패치 건수',
      PATCH_STATUS        VARCHAR(50) NULL      COMMENT '패치 상태',
      LAST_UPD            TIMESTAMP   NOT NULL  DEFAULT CURRENT_TIMESTAMP
      ON UPDATE CURRENT_TIMESTAMP
      COMMENT '최종 업데이트 일시',
      PRIMARY KEY (PATCH_ID)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='자동 패치관리 패치현황';
    - 위 테이블 스키마 기준으로 금일 패치 건수 및 piechart(donut-wrap) 표현
    
  - 시험 및 개발 현황 패널
    - CREATE TABLE IF NOT EXISTS TB_TDBTND001 (
      PRJ_KIND       VARCHAR(20)  NOT NULL  COMMENT '프로젝트 유형',
      PRJ_NAME       VARCHAR(100) NOT NULL  COMMENT '프로젝트 명',
      PRJ_START_DATE VARCHAR(14)  NOT NULL  COMMENT '시작 일시 (YYYYMMDDHHmmss)',
      PRJ_END_DATE   VARCHAR(14)  NOT NULL  COMMENT '종료 일시 (YYYYMMDDHHmmss)',
      PRJ_PROGRESS   VARCHAR(20)  NULL      COMMENT '진행 상태',
      LAST_UPD       TIMESTAMP    NOT NULL  DEFAULT CURRENT_TIMESTAMP
      ON UPDATE CURRENT_TIMESTAMP
      COMMENT '최종 업데이트 일시',
      PRIMARY KEY (PRJ_KIND, PRJ_NAME)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='시험 및 개발 요약';
    - 위 테이블 스키마 기준으로 시험 및 개발 현황 수 조회 

  - 토폴로지 영역 패널
    - 해당 영역 크기에 맞게 <%@include file="/WEB-INF/view/d3map/topology.jsp" %> 표현 
      - 토폴로지 영역 크기를 벗어나지 않게 해야 됨


-공통
  - 모든 패널은 현재 영역 크기와 디자인을 유지하도록 구현
  - 구현 후 playwright 확인
  - 접속 정보 admin / rhror!50akswhr
  
 
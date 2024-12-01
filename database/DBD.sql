-- Active: 1732895344838@@127.0.0.1@3306@DBD
CREATE DATABASE IF NOT EXISTS DBD
    DEFAULT CHARACTER SET = 'utf8mb4';
USE DBD;
CREATE TABLE student_info (
    enter_year INT,
    user_dep VARCHAR(50),
    major VARCHAR(45),
    name VARCHAR(45),
    toeic_score INT,
    GPA FLOAT,
    student_id VARCHAR(10) PRIMARY KEY
);
CREATE TABLE course_list (
    category VARCHAR(45),
    course_name VARCHAR(100),
    credit INT,
    course_id VARCHAR(10) PRIMARY KEY
);
CREATE TABLE student_enrollment (
    student_id VARCHAR(10),
    major VARCHAR(45),
    course_id VARCHAR(10),
    course_name VARCHAR(70),
    category VARCHAR(45),
    is_english boolean,
    credit int,
    CONSTRAINT student_id FOREIGN KEY (student_id)
        REFERENCES student_info(student_id),
    CONSTRAINT course_id FOREIGN KEY (course_id)
        REFERENCES course_list(course_id)
);
CREATE TABLE graduation_requirement (
    standard_year INT,
    standard_dep VARCHAR(50), -- 공대 17-22 / 에융 23,24
    standard_total_credit INT,   -- 17-22(140), 23, 24(130)
    standard_major_total_credit INT,     -- 전공 전체 이수학점 84
    standard_major_ess_credit INT,   -- 전공 필수 이수학점 17-22(29), 23,24(26)
    standard_major_ess_list VARCHAR(1000),-- 17-22, 23/24
    standard_general_ess_credit INT,     -- 17-22(14), 23(17), 24(25)
    standard_g_ess_list VARCHAR(1000),    -- 공교/기본소양 팔수이수학점(자명, 불인, eas1, eas2, 기보작, 커디, 기업과 정신 리더십)
    standard_g_sel_list VARCHAR(1000),    -- 공교 선택이수학점 (24학번만 세미나 선택 3/9)
    standard_basic_total_credit INT,     -- 기본소양 9 기본소양 3개 체크해서 넣기
    standard_bsm_total_credit INT,       -- 21
    standard_bsm_ess__credit INT,   -- 17-22(9), 23,24(12)
    standard_bsm_ess_list VARCHAR(100),  -- 17-22(미1, 확통, 공선대), 23,24(미1, 확통, 공선대,이산수학)
    standard_sci_sel_list VARCHAR(100),  -- 일화실1, 일생실1, 일물실1 중 최소 1 , if문으로 sci_flag 처리 0이면 -> 졸업x
    standard_eng_total_credit INT,       -- 10 TF
    standard_toeic INT,            -- >= 700
    standard_GPA FLOAT,                  -- >= 2.0
    indexNum INT AUTO_INCREMENT PRIMARY KEY
);
CREATE TABLE student_status (
    total_credit INT,
    major_total_credit INT,
    bsm_total_credit INT,
    major_ess_credit INT,                -- student_enrollment랑 graduation_requirement_major_ess_list랑 비교해서 총 전공 필수강의 학점
    general_ess_credit INT,              -- student_enrollment랑 graduation_requirement_g_ess_list랑 비교해서 총 공교 필수강의 학점
    bsm_ess_credit INT,                  -- student_enrollment랑 graduation_requirement_bsm_ess_list랑 비교해서 총 bsm 필수강의 학점 
    eng_total_credit INT,                -- student_enrollment에서 총 영어강의 학점 
    student_id VARCHAR(10) PRIMARY KEY,  -- 학생 ID (user_info 테이블과 연관)
    CONSTRAINT fk_student_id FOREIGN KEY (student_id)
        REFERENCES student_info(student_id)  -- 학생 ID는 student_info 테이블의 student_id와 연결
);
-- 전체 전공 과목
INSERT INTO course_list (category, course_id, course_name, credit) VALUES
('전공', 'CSC2001', '기초프로그래밍', 3),
('전공', 'CSC2002', '심화프로그래밍', 3),
('전공', 'CSC2003', '객체지향프로그래밍', 3),
('전공', 'CSC2004', '어드벤처디자인', 3),
('전공', 'CSC2005', '시스템소프트웨어', 3),
('전공', 'CSC2006', '프로그래밍언어론', 3),
('전공', 'CSC2007', '자료구조', 3),
('전공', 'CSC2008', '알고리즘', 3),
('전공', 'CSC2009', '인공지능수학', 3),
('전공', 'CSC2010', '게임프로그래밍', 3),
('전공', 'CSC4003', '디지털영상처리', 3),
('전공', 'CSC4004', '공개SW프로젝트', 3),
('전공', 'CSC4005', '임베디드시스템', 3),
('전공', 'CSC4010', '소프트웨어공학', 3),
('전공', 'CSC4012', '인공지능', 3),
('전공', 'CSC4013', '컴퓨터구조', 3),
('전공', 'CSC4015', '컴파일러', 3),
('전공', 'CSC4018', '종합설계1', 3),
('전공', 'CSC4019', '종합설계2', 3),
('전공', 'CSC4020', '데이터베이스설계', 3),
('전공', 'CSC4021', '데이터통신입문', 3),
('전공', 'CSC4023', '딥러닝입문', 3),
('전공', 'CSC4026', '컴퓨터비전입문', 3),
('전공', 'CSC4029', '웹서비스보안', 3),
('전공', 'CSC4030', '암호학과네트워크보안', 3),
('전공', 'DAI3089', '개별연구(CSC제목과 이미지 쌍들로부터 이를 요약하는 제목과 이미지 생성)', 1),
('전공', 'DAI3066', '개별연구(CSC의학지식그래프기반의약물-질병관계예측을통한약물재창출연구)', 1),
('전공', 'DAI3068', '개별연구(CSC기계를위한 비디오부호화(Video Coding for Machines)기술연구)', 1),
('전공', 'DAI3069', '개별연구(CSC 스마트 노인 돌봄을 위한 행동 및 상황인지 기술 연구)', 1),
('전공', 'DAI3074', '개별연구(CSC 음성데이터를 통한 감정인식 연구)', 1),
('전공', 'DAI3075', '개별연구(CSC 동형암호 활용 연구)', 1),
('전공', 'DAI3076', '개별연구(CSC Privacy Enhancing Technology 심화 연구)', 1),
('전공', 'DAI3080', '개별연구(CSC 속성기반 재식별 모델 분석 및 게임엔진 활용 성능개선 연구)', 1),
('전공', 'DAI3084', '개별연구(CSC 딥러닝 기반 Computational Camera 기술 연구)', 1),
('전공', 'DAI3086', '개별연구(CSC 독거노인 스마트케어 서비스 어플리케이션 설계 및 구현)', 1),
('전공', 'DAI3087', '개별연구(CSC 유전체 데이터 분석 및 결과 해석)', 1),
('전공', 'DAI3106', '개별연구(CSC 게임엔진을 활용한 딥러닝 분석용 데이터 생성 연구)', 1),
('전공', 'DAI3107', '개별연구(CSC 게임엔진을 활용한 딥러닝 분석용 데이터 생성 연구 심화)', 1),
('전공', 'DAI3113', '개별연구(CSC 스포츠 데이터를 활용한 딥러닝 응용 연구)', 1),
('전공', 'DAI3116', '개별연구(CSC 딥페이크(Deepfake) 탐지 기술 연구)', 1),
('전공', 'DAI3118', '개별연구(CSC 공간전사체의 대조학습 기반 조직 이미지의 구획 구분 모델)', 1),
('전공', 'DAI3121', '개별연구(CSC 분산영지식증명 연구 2)', 1),
('전공', 'DAI3122', '개별연구(CSC 멀티모달 대화기반 스케치 생성 연구)', 1),
('전공', 'DAI3123', '개별연구(CSC 멀티모달 sLLM 연구)', 1),
('전공', 'DAI3124', '개별연구(CSC 강화학습 기반 군집 에이전트 시스템의 자율적 협력 및 성능)', 1),
('전공', 'DAI3125', '개별연구(CSC LMM 기반 음악 서비스 연구)', 1),
('전공', 'DAI3126', '개별연구(CSC LMM 기반 가상 시뮬레이션/게임 서비스 연구)', 1),
('전공', 'DAI3127', '개별연구(CSC 3차원 스캐닝 로봇 개발1)', 1),
('전공', 'DAI3128', '개별연구(CSC 로봇 Fleet Management System 개발1)', 1),
('전공', 'DAI3129', '개별연구(CSC 스마트 노인 돌봄을 위한 행동 및 상황인지 기술 연구2)', 1),
('전공', 'DAI3130', '개별연구(CSC딥러닝모델을 적용한 에지노드에서의 위험 감지 및 예측 성능 분석)', 1),
('전공', 'DAI3131', '개별연구(CSC 금융 데이터를 활용한 딥러닝 응용 연구)', 1),
('전공', 'DAI3132', '개별연구(CSC 공정성을 고려한 딥러닝 응용 연구)', 1),
('전공', 'DAI3133', '개별연구(CSC 인공위성 촬영 영상 내 객체 탐지 및 분류 기술 연구)', 1),
('전공', 'DAI3134', '개별연구(CSC 전사체 기반 화합물 그래프 생성형 AI 연구)', 1),
('전공', 'DAI3135', '개별연구(CSC 특정 사무 프로세스 자동화를 위한 UI/UX 개선 연구 심화)', 1),
('전공', 'DAI3136', '개별연구(CSC 지능형 융합보안서비스 시뮬레이터 연구)', 1),
('전공', 'DAI3137', '개별연구(CSC 타겟 질병의 발병 확률 예측 알고리즘을 적용한 어플리케이션 제작)', 1),
('전공', 'DAI3141', '개별연구(CSC 메타버스 내 범죄자 회피 및 증거 기록을 위한 방안 연구 심화)', 1),
('전공', 'CSE2015', '웹프로그래밍', 3),
('전공', 'ITS4011', '현장실습(Co-op)3', 9),
('전공', 'ITS4012', '현장실습(Co-op)4', 12),
('전공', 'ITS4015', '현장실습3', 9),
('전공', 'ITS4016', '현장실습4', 12),
('전공', 'CSC2011', '컴퓨터구성', 3),
('전공', 'CSC4001', '운영체제', 3),
('전공', 'CSC4002', '컴퓨터그래픽스', 3),
('전공', 'CSC4006', '게임엔진프로그래밍', 3),
('전공', 'CSC4007', '디지털신호처리', 3),
('전공', 'CSC4008', '다변량 및 시계열 데이터 분석', 3),
('전공', 'CSC4009', '데이터베이스', 3),
('전공', 'CSC4011', '인간컴퓨터상호작용', 3),
('전공', 'CSC4014', '형식언어', 3),
('전공', 'CSC4016', '컴퓨터네트워크', 3),
('전공', 'CSC4022', '머신러닝', 3),
('전공', 'CSC4024', '컴퓨터보안', 3),
('전공', 'CSC4025', '가상현실', 3),
('전공', 'CSC4027', '자연어처리개론', 3),
('전공', 'CSC4028', '시큐어코딩', 3),
('전공', 'CSC4031', '양자컴퓨팅', 3),
('전공', 'DAI3058', '개별연구(CSC 인지 기능 향상을 위한 멀티모달 케어챗봇)', 1),
('전공', 'DAI3064', '개별연구(CSC AI생성모델의 편향완화)', 1),
('전공', 'DAI3065', '개별연구(CSC 그래프및 전사체데이터의 멀티모달딥러닝기반 약물반응성예측)', 1),
('전공', 'DAI3067', '개별연구(CSC 애니메이션에 특화된 Super-resolution 기술 연구)', 1),
('전공', 'DAI3070', '개별연구(CSC 로봇 3차원 지도 생성 및 위치 추정 연구)', 1),
('전공', 'DAI3071', '개별연구(CSC 다중 로봇 관제 시스템 개발)', 1),
('전공', 'DAI3072', '개별연구(CSC 다중 센서를 활용한 스마트미러기반 사용자 인식 연구)', 1),
('전공', 'DAI3073', '개별연구(CSC 아래를 내려다보는 영상내 다수 사람과 움직이는 물체 인식 연구)', 1),
('전공', 'DAI3077', '개별연구(CSC 지능형 융합보안서비스 지원 시뮬레이터용 객체 행위 연구)', 1),
('전공', 'DAI3078', '개별연구(CSC 특정 사무프로세스 자동화를 위한 주요모듈 및 UI/UX개선연구)', 1),
('전공', 'DAI3085', '개별연구(CSC 딥러닝모델을 적용한 에지노드에서의 화재감지 및 예측성능 분석2)', 1),
('전공', 'DAI3088', '개별연구(CSC 다양한 관점에서의 보건영양데이터 분석 및 결과 도출)', 1),
('전공', 'DAI3091', '개별연구(CSC VR 기기를 활용한 스마트 시스템 설계)', 1),
('전공', 'DAI3092', '개별연구(CSC AI Chip Board을 활용한 응용시스템 설계)', 1),
('전공', 'DAI3093', '개별연구(CSC 장애인/노인을 위한 제스처인식 시스템 설계)', 1),
('전공', 'DAI3094', '개별연구(CSC LiDAR센서를 활용한 주변 지도 생성 연구)', 1),
('전공', 'DAI3096', '개별연구(CSC 드론을 활용한 높이별 얼굴인식 모델 연구)', 1),
('전공', 'DAI3097', '개별연구(CSC 여러 각도에서 촬영된 얼굴 영상의 감정 인식 연구)', 1),
('전공', 'DAI3098', '개별연구(CSC 단계별 감정 인식 연구)', 1),
('전공', 'DAI3099', '개별연구(CSC 일반 카메라와 열화상 카메라 기반 사람 인식 연구)', 1),
('전공', 'DAI3100', '개별연구(CSC 키넥트를 활용한 노인 친화적 응용 서비스 개발 및 연구)', 1),
('전공', 'DAI3101', '개별연구(CSC 유사 질문/댓글 클러스터링 연구)', 1),
('전공', 'DAI3102', '개별연구(CSC 웹뉴스 및 SNS을 통한 시민 정서 분석 빅데이터 연구)', 1),
('전공', 'DAI3105', '개별연구(CSC 메타버스내 범죄자 회피 및 증거 기록을 위한 방안 연구)', 1),
('전공', 'DAI3044', '개별연구(CS웹뉴스 및 SNS을 통한 시민 정서 분석 빅데이터 연구)', 1),
('전공', 'CSE2025', '계산적사고법', 3),
('전공', 'CSE4061', 'S/W품질관리및테스팅', 3),
('전공', 'CSE2013', '시스템소프트웨어와실습', 3),
('전공', 'CSE2024', '프로그래밍언어개념', 3),
('전공', 'CSE4029', '컴퓨터알고리즘과실습', 3),
('전공', 'CSE4036', '인공지능', 3),
('전공', 'CSE4066', '컴퓨터공학종합설계1', 3),
('전공', 'CSE4067', '컴퓨터공학종합설계2', 3),
('전공', 'CSE4081', '암호학과네트워크보안', 3),
('전공', 'CSE2017', '자료구조와실습', 3),
('전공', 'CSE4031', '형식언어', 3),
('전공', 'CSE4043', '컴퓨터네트워킹', 3),
('전공', 'CSE4051', '객체지향설계와패턴', 3),
('전공', 'CSE2022', '심화프로그래밍', 3),
('전공', 'CSE2027', '객체지향프로그래밍', 3),
('전공', 'CSE4038', '데이터통신입문', 3),
('전공', 'CSE4041', '데이터베이스프로그래밍', 3),
('전공', 'CSE4053', '모바일컴퓨팅', 3),
('전공', 'CSE4058', '소프트웨어공학개론', 3),
('전공', 'CSE4074', '공개SW프로젝트', 3),
('전공', 'CSE4075', 'SW비즈니스와창업', 3),
('전공', 'CSE4076', '테크니컬프리젠테이션', 3),
('전공', 'CSE2014', '기초프로그래밍', 3),
('전공', 'CSE2018', '컴퓨터구성', 3),
('전공', 'CSE2026', '이산구조', 3),
('전공', 'CSE2028', '어드벤처디자인', 3),
('전공', 'CSE4033', '운영체제', 3),
('전공', 'CSE4037', '데이터베이스시스템', 3),
('전공', 'CSE4044', '컴퓨터보안', 3),
('전공', 'CSE4060', '컴퓨터그래픽스입문', 3),
('전공', 'CSE4085', '머신러닝', 3),
('전공', 'CSE4034', '컴퓨터구조', 3),
('전공', 'CSE4035', '컴파일러구성', 3),
('전공', 'CSE4070', '임베디드소프트웨어입문', 3),
('전공', 'CSE4082', '데이터분석 및 실습', 3),
('전공', 'ITS4004', '현장실습4', 12),
('전공', 'CSE4080', '동시성프로그래밍', 3),
('전공', 'DES4032', '기술창업캡스톤디자인2', 3),
('전공', 'ASW4014', '공개SW프로젝트', 3),
('전공', 'ASW2008', '심화프로그래밍', 3);
-- 전체 공통교양 과목
INSERT INTO course_list (category, course_id, course_name, credit) VALUES
('공통교양', 'RGC0003', '불교와인간', 2),
('공통교양', 'RGC0005', '기술보고서작성및발표', 3),
('공통교양', 'RGC0017', '자아와명상1', 1),
('공통교양', 'RGC0018', '자아와명상2', 1),
('공통교양', 'RGC1001', '나의삶,나의비전', 1),
('공통교양', 'RGC1010', '존재와역사 명작세미나', 3),
('공통교양', 'RGC1011', '경제와사회 명작세미나', 3),
('공통교양', 'RGC1012', '자연과기술 명작세미나', 3),
('공통교양', 'RGC1013', '문화와예술 명작세미나', 3),
('공통교양', 'RGC1014', '지혜와자비 명작세미나', 3),
('공통교양', 'RGC1030', 'BasicEAS', 0),
('공통교양', 'RGC1033', 'EAS1', 2),
('공통교양', 'RGC1034', 'EAS2', 2),
-- ('공통교양', 'RGC1050', '소셜앙트레프레너십과리더십', 2),
-- ('공통교양', 'RGC1051', '글로벌앙트레프레너십과리더십', 2),
-- ('공통교양', 'RGC1052', '테크노앙트레프레너십과리더십', 2),
('공통교양', 'RGC1074', '커리어디자인', 1),
('공통교양', 'RGC1053', '기업가정신과리더십', 2),
('공통교양', 'RGC1080', 'EAS1', 2),
('공통교양', 'RGC1081', 'EAS2', 2),
('공통교양', 'RGC1082', 'Global English1', 2),
('공통교양', 'RGC1083', 'Global English2', 2);
-- 전체 BDM 과목
INSERT INTO course_list (category, course_id, course_name, credit) VALUES
('학문기초', 'PRI4001', '미적분학및연습1', 3),
('학문기초', 'PRI4012', '미적분학및연습2', 3),
('학문기초', 'PRI4023', '확률및통계학', 3),
('학문기초', 'PRI4024', '공학선형대수학', 3),
('학문기초', 'PRI4025', '공학수학1', 3),
('학문기초', 'PRI4027', '이산수학', 3),
('학문기초', 'PRI4036', '수치해석및실습', 3),
('학문기초', 'PRI4051', '산업수학', 3),
('기본소양', 'EGC7026', '기술창조와특허', 3),
('기본소양', 'PRI4041', '공학경제', 3),
('기본소양', 'EGC4039', '공학윤리', 3),
('학문기초', 'PRI4002', '일반물리학및실험1', 4),
('학문기초', 'PRI4013', '일반물리학및실험2', 4),
('학문기초', 'PRI4003', '일반화학및실험1', 4),
('학문기초', 'PRI4014', '일반화학및실험2', 4),
('학문기초', 'PRI4004', '일반생물학및실험1', 3),
('학문기초', 'PRI4015', '일반생물학및실험2', 3),
('학문기초', 'PRI4029', '물리학개론', 3),
('학문기초', 'PRI4030', '화학개론', 3),
('학문기초', 'PRI4028', '생물학개론', 3),
('학문기초', 'PRI4033', '지구환경과학', 3),
('학문기초', 'PRI4035', '프로그래밍기초와실습', 3),
('학문기초', 'PRI4039', '인터넷프로그래밍', 3),
('학문기초', 'PRI4037', '컴퓨터응용', 3),
('학문기초', 'PRI4038', '비쥬얼프로그래밍', 3),
('학문기초', 'EGC9005', '컴퓨터알고리즘의이해', 1),
('학문기초', 'EGC4040', '인공지능프로그래밍기초와실습', 3),
('학문기초', 'EGC5033', '데이터프로그래밍기초와실습', 3);
-- student_info 추가
INSERT INTO student_info (enter_year, user_dep, major, name, toeic_score, GPA, student_id) VALUES
    (2021, '공과대학', '컴퓨터공학전공', '김예나', 0, 4.5, '2021110439'),
    (2021, '공과대학', '컴퓨터공학전공', '박선유', 0, 4.5, '2021111590'),
    (2022, 'AI융합대학', '컴퓨터공학전공', '김은서', 0, 4.5, '2022111700'),
    (2023, 'AI융합대학', '컴퓨터공학전공', '김은서', 0, 4.5, '2023000000'),
    (2024, 'AI융합대학', '컴퓨터공학전공', '아무개', 0, 4.5, '2024000000');
-- 21김예나 이수 수업 추가
INSERT INTO student_enrollment (student_id, major, course_id, course_name, category, is_english, credit) VALUES
('2021110439', '컴퓨터공학전공', 'PRI4023', '확률및통계학', '학문기초', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'DAI3089', '개별연구(CSC제목과 이미지 쌍들로부터 이를 요약하는 제목과 이미지 생성)', '전공', FALSE, 1),
('2021110439', '컴퓨터공학전공', 'DES4032', '기술창업캡스톤디자인2', '전공', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'CSC2005', '시스템소프트웨어와실습', '전공', TRUE, 3),
('2021110439', '컴퓨터공학전공', 'CSC4018', '종합설계1', '전공', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'CSC4020', '데이터베이스설계', '전공', TRUE, 3),
('2021110439', '컴퓨터공학전공', 'CSC4010', '소프트웨어공학', '전공', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'PRI4028', '생물학개론', '학문기초', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'CSC2008', '알고리즘', '전공', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'DAI3044', '개별연구(CS웹뉴스 및 SNS을 통한 시민 정서 분석 빅데이터 연구)', '전공', FALSE, 1),
('2021110439', '컴퓨터공학전공', 'CSE4031', '형식언어', '전공', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'CSE2025', '계산적사고법', '전공', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'ASW4014', '공개SW프로젝트', '전공', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'EGC4039', '공학윤리', '기본소양', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'EGC7026', '기술창조와특허', '기본소양', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'CSE4037', '데이터베이스시스템', '전공', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'ASW2008', '심화프로그래밍', '전공', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'CSE2027', '객체지향프로그래밍', '전공', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'PRI4024', '공학선형대수학', '학문기초', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'CSE2026', '이산구조', '전공', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'RGC0005', '기술보고서작성및발표', '공통교양', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'CSE2018', '컴퓨터구성', '전공', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'CSE2017', '자료구조와실습', '전공', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'CSE2028', '어드벤처디자인', '전공', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'PRI4012', '미적분학및연습2', '학문기초', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'RGC0018', '자아와명상2', '공통교양', FALSE, 1),
('2021110439', '컴퓨터공학전공', 'RGC1074', '커리어 디자인', '공통교양', FALSE, 1),
('2021110439', '컴퓨터공학전공', 'CSE2014', '기초프로그래밍', '전공', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'PRI4014', '일반화학및실험2', '학문기초', FALSE, 4),
('2021110439', '컴퓨터공학전공', 'RGC1081', 'EAS2', '공통교양', TRUE, 2),
('2021110439', '컴퓨터공학전공', 'PRI4003', '일반화학및실험1', '학문기초', FALSE, 4),
('2021110439', '컴퓨터공학전공', 'RGC0003', '불교와인간', '공통교양', FALSE, 2),
-- ('2021110439', '컴퓨터공학전공', 'RGC1051', '글로벌앙트레프레너십과리더십', '공통교양', FALSE, 2),
('2021110439', '컴퓨터공학전공', 'RGC1053', '기업가정신과리더십', '공통교양', FALSE, 2),
('2021110439', '컴퓨터공학전공', 'RGC1080', 'EAS1', '공통교양', TRUE, 2),
('2021110439', '컴퓨터공학전공', 'PRI4001', '미적분학및연습1', '학문기초', FALSE, 3),
('2021110439', '컴퓨터공학전공', 'RGC0017', '자아와명상1', '공통교양', FALSE, 1);
-- 24아무개 이수 수업 추가
INSERT INTO student_enrollment (student_id, major, course_id, course_name, category, is_english, credit) VALUES
('2024000000', '컴퓨터공학전공', 'RGC1080', 'EAS1', '공통교양', TRUE, 2),
('2024000000', '컴퓨터공학전공', 'RGC1081', 'EAS2', '공통교양', TRUE, 2),
('2024000000', '컴퓨터공학전공', 'RGC0017', '자아와명상1', '공통교양', FALSE, 1),
('2024000000', '컴퓨터공학전공', 'RGC0018', '자아와명상2', '공통교양', FALSE, 1),
('2024000000', '컴퓨터공학전공', 'PRI4002', '일반물리학및실험1', '학문기초', FALSE, 3),
('2024000000', '컴퓨터공학전공', 'RGC1012', '지혜와자비 명작세미나', '공통교양', FALSE, 3),
('2024000000', '컴퓨터공학전공', 'PRI4001', '미적분학및연습1', '학문기초', FALSE, 3),
('2024000000', '컴퓨터공학전공', 'PRI4027', '이산수학', '학문기초', FALSE, 3),
('2024000000', '컴퓨터공학전공', 'CSC2001', '기초프로그래밍', '전공', FALSE, 3),
('2024000000', '컴퓨터공학전공', 'CSE2028', '어드벤처디자인', '전공', FALSE, 3),
('2024000000', '컴퓨터공학전공', 'ASW2008', '심화프로그래밍', '전공', FALSE, 3),
('2024000000', '컴퓨터공학전공', 'RGC0005', '기술보고서작성및발표', '공통교양', FALSE, 3);
INSERT INTO graduation_requirement (standard_year, standard_dep, standard_total_credit, standard_major_total_credit, standard_major_ess_credit, 
standard_major_ess_list, standard_general_ess_credit, 
standard_g_ess_list, standard_g_sel_list, 
standard_basic_total_credit, standard_bsm_total_credit, standard_bsm_ess__credit, standard_bsm_ess_list, standard_sci_sel_list, standard_eng_total_credit, standard_toeic, standard_GPA) VALUES
    (2017, '공과대학', 140, 84, 29, 
    '어드벤처디자인, 종합설계1, 종합설계2, 자료구조와실습, 개별연구1, 개별연구2, 컴퓨터구성, 시스템소프트웨어와실습, 이산구조, 계산적사고법, 공개SW프로젝트', 14, 
    '자아와명상1, 자아와명상2, 불교와인간, EAS1, EAS2, 기술보고서작성및발표, 커리어 디자인, 기업가정신과리더십', '', 
    9, 21, 13, '미적분학및연습1, 확률및통계학, 공학선형대수학', '일반화학및실험1, 일반생물학및실험1, 일반물리학및실험1', 10, 700, 2.0),
    (2018, '공과대학', 140, 84, 29, 
    '어드벤처디자인, 종합설계1, 종합설계2, 자료구조와실습, 개별연구1, 개별연구2, 컴퓨터구성, 시스템소프트웨어와실습, 이산구조, 계산적사고법, 공개SW프로젝트', 14, 
    '자아와명상1, 자아와명상2, 불교와인간, EAS1, EAS2, 기술보고서작성및발표, 커리어 디자인, 기업가정신과리더십', '', 
    9, 21, 13, '미적분학및연습1, 확률및통계학, 공학선형대수학', '일반화학및실험1, 일반생물학및실험1, 일반물리학및실험1', 10, 700, 2.0),
    (2019, '공과대학', 140, 84, 29, 
    '어드벤처디자인, 종합설계1, 종합설계2, 자료구조와실습, 개별연구1, 개별연구2, 컴퓨터구성, 시스템소프트웨어와실습, 이산구조, 계산적사고법, 공개SW프로젝트', 14, 
    '자아와명상1, 자아와명상2, 불교와인간, EAS1, EAS2, 기술보고서작성및발표, 커리어 디자인, 기업가정신과리더십', '', 
    9, 21, 13, '미적분학및연습1, 확률및통계학, 공학선형대수학', '일반화학및실험1, 일반생물학및실험1, 일반물리학및실험1', 10, 700, 2.0),
    (2020, '공과대학', 140, 84, 29, 
    '어드벤처디자인, 종합설계1, 종합설계2, 자료구조와실습, 개별연구1, 개별연구2, 컴퓨터구성, 시스템소프트웨어와실습, 이산구조, 계산적사고법, 공개SW프로젝트', 14, 
    '자아와명상1, 자아와명상2, 불교와인간, EAS1, EAS2, 기술보고서작성및발표, 커리어 디자인, 기업가정신과리더십', '',
    9, 21, 13, '미적분학및연습1, 확률및통계학, 공학선형대수학', '일반화학및실험1, 일반생물학및실험1, 일반물리학및실험1', 10, 700, 2.0),
    (2021, '공과대학', 140, 84, 29, 
    '어드벤처디자인, 종합설계1, 종합설계2, 자료구조와실습, 개별연구1, 개별연구2, 컴퓨터구성, 시스템소프트웨어와실습, 이산구조, 계산적사고법, 공개SW프로젝트', 14, 
    '자아와명상1, 자아와명상2, 불교와인간, EAS1, EAS2, 기술보고서작성및발표, 커리어 디자인, 기업가정신과리더십', '',
    9, 21, 13, '미적분학및연습1, 확률및통계학, 공학선형대수학', '일반화학및실험1, 일반생물학및실험1, 일반물리학및실험1', 10, 700, 2.0),
    (2022, '공과대학', 140, 84, 29, 
    '어드벤처디자인, 종합설계1, 종합설계2, 자료구조와실습, 개별연구1, 개별연구2, 컴퓨터구성, 시스템소프트웨어와실습, 이산구조, 계산적사고법, 공개SW프로젝트', 14, 
    '자아와명상1, 자아와명상2, 불교와인간, EAS1, EAS2, 기술보고서작성및발표, 커리어 디자인, 기업가정신과리더십', '',
    9, 21, 16, '미적분학및연습1, 확률및통계학, 공학선형대수학', '일반화학및실험1, 일반생물학및실험1, 일반물리학및실험1', 10, 700, 2.0),
    (2023, 'AI융합대학', 130, 84, 26, 
    '어드벤처디자인, 종합설계1, 종합설계2, 자료구조와실습, 개별연구1, 개별연구2, 컴퓨터구성, 시스템소프트웨어와실습, 계산적사고법, 공개SW프로젝트', 17, 
    '자아와명상1, 자아와명상2, 불교와인간, EAS1, EAS2, 기술보고서작성및발표, 커리어 디자인, 기업가정신과리더십', 
    '지혜와자비 명작세미나, 존재와역사 명작세미나, 경제와사회 명작세미나, 자연과기술 명작세미나, 문화와예술 명작세미나',
    9, 21, 16, '미적분학및연습1, 확률및통계학, 공학선형대수학, 이산수학', '일반화학및실험1, 일반생물학및실험1, 일반물리학및실험1', 10, 700, 2.0),
    (2024,'AI융합대학', 130, 84, 26, 
    '어드벤처디자인, 종합설계1, 종합설계2, 자료구조와실습, 개별연구1,개별연구2, 컴퓨터구성, 시스템소프트웨어와실습, 계산적사고법, 공개SW프로젝트', 25, 
    '자아와명상1, 자아와명상2, 불교와인간, Global English 1, Global English 2, 기술보고서작성및발표, 커리어 디자인, 기업가정신과리더십, 디지털 기술과 사회의 이해, 프로그래밍 이해와 실습, 빅데이터와 인공지능의 이해', 
    '지혜와자비 명작세미나, 존재와역사 명작세미나, 경제와사회 명작세미나, 자연과기술 명작세미나, 문화와예술 명작세미나',
    9, 21, 16, '미적분학및연습1, 확률및통계학, 공학선형대수학, 이산수학', '일반화학및실험1, 일반생물학및실험1, 일반물리학및실험1', 10, 700, 2.0);

DROP PROCEDURE IF EXISTS update_student_status;
CREATE PROCEDURE update_student_status(IN student_id_i VARCHAR(10))
BEGIN
    DECLARE total_credit INT DEFAULT 0;
    DECLARE major_total_credit INT DEFAULT 0;
    DECLARE bsm_total_credit INT DEFAULT 0;
    DECLARE major_ess_credit INT DEFAULT 0;
    DECLARE general_ess_credit INT DEFAULT 0;
    DECLARE bsm_ess_credit INT DEFAULT 0;
    DECLARE eng_total_credit INT DEFAULT 0;
    DECLARE major_ess_list_c TEXT;
    DECLARE general_ess_list_c TEXT;
    DECLARE bsm_ess_list_c TEXT;

    -- 영어 강의 학점 합산
    SELECT IFNULL(SUM(credit), 0) 
    INTO eng_total_credit
    FROM student_enrollment 
    WHERE student_id = student_id_i AND is_english = TRUE;
    SELECT eng_total_credit;

    -- 총 학점, 전공 학점, 학문기초 학점 계산
    SELECT IFNULL(SUM(credit), 0), 
           IFNULL(SUM(CASE WHEN category = '전공' THEN credit ELSE 0 END), 0),
           IFNULL(SUM(CASE WHEN category = '학문기초' THEN credit ELSE 0 END), 0)
    INTO total_credit, major_total_credit, bsm_total_credit
    FROM student_enrollment 
    WHERE student_id = student_id_i;
    SELECT total_credit, major_total_credit, bsm_total_credit;

    -- graduation_requirement에서 major_ess_list, g_ess_list, bsm_ess_list 가져오기
    SELECT standard_major_ess_list, standard_g_ess_list, standard_bsm_ess_list
    INTO major_ess_list_c, general_ess_list_c, bsm_ess_list_c
    FROM graduation_requirement
    JOIN student_info ON graduation_requirement.standard_year = student_info.enter_year
    WHERE student_info.student_id = student_id_i;
    SELECT major_ess_list_c, general_ess_list_c, bsm_ess_list_c;

    -- 각 필수 과목 학점 계산
    CALL calculate_credits(student_id_i, major_ess_list_c, major_ess_credit);
    SELECT major_ess_credit;
    CALL calculate_credits(student_id_i, general_ess_list_c, general_ess_credit);
    SELECT general_ess_credit;
    CALL calculate_credits(student_id_i, bsm_ess_list_c, bsm_ess_credit);
    SELECT bsm_ess_credit;

    -- student_status 업데이트 또는 삽입
    IF EXISTS (SELECT 1 FROM student_status WHERE student_id = student_id_i) THEN
        UPDATE student_status
        SET total_credit = total_credit,
            major_total_credit = major_total_credit,
            bsm_total_credit = bsm_total_credit,
            major_ess_credit = major_ess_credit,
            general_ess_credit = general_ess_credit,
            bsm_ess_credit = bsm_ess_credit,
            eng_total_credit = eng_total_credit
        WHERE student_id = student_id_i;
    ELSE
        INSERT INTO student_status (student_id, total_credit, major_total_credit, bsm_total_credit, 
                                    major_ess_credit, general_ess_credit, bsm_ess_credit, eng_total_credit)
        VALUES (student_id_i, total_credit, major_total_credit, bsm_total_credit, major_ess_credit, 
                general_ess_credit, bsm_ess_credit, eng_total_credit);
    END IF;
END ;

DROP PROCEDURE IF EXISTS calculate_credits;
CREATE PROCEDURE calculate_credits(
    IN student_id_i VARCHAR(10),
    IN course_list_e TEXT,
    OUT total_credits INT
)
BEGIN
    DECLARE major_ess_list_n TEXT;
    -- 초기화
    SET total_credits = 0;

    IF course_list_e IS NULL THEN
        SELECT 'course_list is NULL';
    END IF;
    -- course_list_e 비어있지 않은 경우 처리
    IF course_list_e IS NOT NULL AND course_list_e != '' THEN
        -- major_ess_list 값을 graduation_requirement 테이블에서 가져옴
        SELECT standard_major_ess_list INTO major_ess_list_n
        FROM graduation_requirement
        WHERE standard_year = LEFT(student_id_i, 4);  -- student_id의 앞 4자리와 matching되는 standard_year 찾기

        SET SESSION group_concat_max_len = 150000;  -- 충분히 큰 값으로 설정

        -- major_ess_list와 course_list_e 동일한 경우 처리
        IF course_list_e = major_ess_list_n THEN
            SET @sql_query = CONCAT(
                'SELECT SUM(credit) INTO @total_credits ',
                'FROM student_enrollment ',
                'WHERE student_id = "', student_id_i, '" ',
                'AND (course_name IN (', 
                    -- course_list_e를 comma-separated 형태로 변환하여 처리
                    (SELECT GROUP_CONCAT(CONCAT('"', TRIM(course_name), '"')) 
                    FROM (SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(course_list_e, ',', n), ',', -1)) AS course_name
                        FROM (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
                                UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 
                                UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11) numbers
                        WHERE n <= (LENGTH(course_list_e) - LENGTH(REPLACE(course_list_e, ',', '')) + 1)
                    ) AS courses
                ),
                ') ',
                'OR (course_name LIKE "개별연구%" AND category = "전공"))'  -- 전공 필터 추가
            );

        ELSE
            -- course_list_e가 major_ess_list와 다를 때의 처리
            SET @sql_query = CONCAT(
                'SELECT SUM(credit) INTO @total_credits ',
                'FROM student_enrollment ',
                'WHERE student_id = "', student_id_i, '" ',
                'AND course_name IN (',
                (SELECT GROUP_CONCAT(CONCAT('"', TRIM(course_name), '"')) 
                 FROM (
                     SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(course_list_e, ',', n), ',', -1)) AS course_name
                     FROM (
                         SELECT n 
                         FROM (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
                                   UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 
                                   UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11) numbers
                         WHERE n <= (LENGTH(course_list_e) - LENGTH(REPLACE(course_list_e, ',', '')) + 1)
                     ) AS numbers
                 ) AS courses
                ),
                ')'
            );
        END IF;

        -- 생성된 쿼리 확인
        SELECT @sql_query AS generated_query;

        -- 동적 SQL 실행
        PREPARE stmt FROM @sql_query;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        -- 결과를 OUT 매개변수에 저장
        SET total_credits = @total_credits;
    END IF;
END ;

CREATE TRIGGER update_student_status_trigger
AFTER INSERT ON student_enrollment
FOR EACH ROW
BEGIN
    CALL update_student_status(NEW.student_id);
END;

SET @REGC = 0;
CALL calculate_credits('2021110439', '미적분학및연습1, 확률및통계학, 공학선형대수학', @REGC);
-- 결과 확인
SELECT @REGC AS total_credits;

CALL update_student_status('2024000000');
SELECT * FROM student_status;

SELECT * FROM student_info;
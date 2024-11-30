from flask import Flask, render_template, request

app = Flask(__name__)  # Flask 앱 초기화

# 첫 화면 라우트 - 시작 버튼을 포함
@app.route('/')
def index():
    return render_template('index.html')  # index.html 템플릿 렌더링

# 학번과 전공 입력 화면 라우트
@app.route('/search/')
def search():
    return render_template('search.html')  # search.html 템플릿 렌더링

# 졸업 사정 결과 화면 라우트
@app.route('/result/', methods=['POST'])
def result():
    # 서버에서 데이터 준비
    student_data = {
        "name": "김은서",
        # statusResponse
        "bsm_ess_credit": 6,
        "bsm_total_credit": 9,
        "eng_total_credit": 4,
        "general_ess_credit": 5,
        "major_ess_credit": 3,
        "major_total_credit": 9,
        "student_id": "2024000000",
        "total_credit": 30,
        # gradeResponse
        "GPA": 3.5,
        "toeic_score": 0,
        "indexNum": 8,
        # requirementResponse
        "standard_GPA": 2.0,
        "standard_bsm_ess_credit": 16,
        "standard_bsm_ess_list": "미적분학및연습1, 확률및통계학, 공학선형대수학, 이산수학",
        "standard_bsm_total_credit": 21,
        "standard_dep": "AI융합대학",
        "standard_eng_total_credit": 10,
        "standard_g_ess_list": "자아와명상1, 자아와명상2, 불교와인간, Global English 1, Global English 2, 기술보고서작성및발표, 커리어 디자인, 기업가정신과리더십, 디지털 기술과 사회의 이해, 프로그래밍 이해와 실습, 빅데이터와 인공지능의 이해",
        "standard_g_sel_list": "지혜와자비 명작세미나, 존재와역사 명작세미나, 경제와사회 명작세미나, 자연과기술 명작세미나, 문화와예술 명작세미나",
        "standard_general_ess_credit": 25,
        "standard_major_ess_credit": 26,
        "standard_major_ess_list": "어드벤처디자인, 종합설계1, 종합설계2, 자료구조와실습, 개별연구1,개별연구2, 컴퓨터구성, 시스템소프트웨어와실습, 계산적사고법, 공개SW프로젝트",
        "standard_major_total_credit": 84,
        "standard_sci_sel_list": "일반화학및실험1, 일반생물학및실험1, 일반물리학및실험1",
        "standard_toeic": 700,
        "standard_total_credit": 130,
        "standard_year": 2024,
    }
    return render_template('result.html', **student_data)

if __name__ == '__main__':
    app.run(debug=True)  # Flask 앱 실행 (디버그 모드 활성화)

    
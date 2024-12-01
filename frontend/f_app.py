from flask import Flask, render_template, request
import requests

app = Flask(__name__)

@app.route('/result/<student_id>')
def result(student_id):
    if not student_id:
        return f"학번 {student_id} 정보 error."
    
    try:
        # 백엔드 API에서 성적 정보를 요청
        performance_url = f"http://127.0.0.1:5555/student-info/{student_id}"
        graduation_url = f"http://127.0.0.1:5555/graduation-requirements/{student_id}"
        status_url = f"http://127.0.0.1:5555/student-status/{student_id}"

        # 각각의 API에 GET 요청을 보냄
        performance_response = requests.get(performance_url)
        graduation_response = requests.get(graduation_url)
        status_response = requests.get(status_url)

        # 각 응답 상태 코드 확인 후 데이터 추출
        if performance_response.status_code == 200:
            performance_data = performance_response.json()
        else:
            performance_data = None

        if graduation_response.status_code == 200:
            graduation_data = graduation_response.json()
        else:
            graduation_data = None

        if status_response.status_code == 200:
            status_data = status_response.json()
        else:
            status_data = None

        # 모든 데이터를 결과 페이지로 전달
        return render_template('result.html', performance_data=performance_data, graduation_data=graduation_data, status_data=status_data)
    
    except requests.exceptions.RequestException as e:
        return f"학번 {student_id} 정보 데이터 불러오기 오류: {e}"

# 첫 화면 라우트 - 시작 버튼을 포함
@app.route('/')
def index():
    return render_template('index.html')  # index.html 템플릿 렌더링

# 학번과 전공 입력 화면 라우트
@app.route('/search/')
def search():
    return render_template('search.html')  # search.html 템플릿 렌더링

if __name__ == '__main__':
    app.run(debug=True)  # Flask 앱 실행 (디버그 모드 활성화)

    
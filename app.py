from flask import Flask, request, jsonify
from flask_mysqldb import MySQL
from flask_cors import CORS
import json
from datetime import datetime
import logging

logging.basicConfig(level=logging.DEBUG)

# config.py에서 설정을 불러옵니다.
app = Flask(__name__)
app.config.from_object('config.Config')  # 'config.Config'를 통해 설정을 가져옵니다.

# CORS 설정 (모든 도메인에서 접근 가능하도록 설정)
CORS(app)

mysql = MySQL(app)

logging.basicConfig(level=logging.DEBUG)

@app.route('/')
def home():
    return "Hello, World!"

@app.route('/graduation-requirements/<student_id>', methods=['GET'])
def get_graduation_requirements(student_id):
    try:
        cursor = mysql.connection.cursor()
        
        # SQL 쿼리 실행
        query = """
        SELECT * FROM graduation_requirement
        WHERE standard_year = (
            SELECT enter_year FROM student_info WHERE student_id = %s
        )
        """
        cursor.execute(query, (student_id,))
        result = cursor.fetchone()
        cursor.close()
        
        # 데이터가 존재할 경우 반환
        if result:
            keys = [
                "standard_year", "standard_dep", "standard_total_credit", "standard_major_total_credit", 
                "standard_major_ess_credit", "standard_major_ess_list", "standard_general_ess_credit", 
                "standard_g_ess_list", "standard_g_sel_list", "standard_basic_total_credit", "standard_bsm_total_credit", 
                "standard_bsm_ess_credit", "standard_bsm_ess_list", "standard_sci_sel_list", "standard_eng_total_credit", 
                "standard_toeic", "standard_GPA", "indexNum"
            ]
            graduation_data = dict(zip(keys, result))
            return jsonify(graduation_data), 200
        
        # 데이터가 없을 경우
        return jsonify({"error": "No graduation requirements found for this student_id"}), 404
    
    except Exception as e:
        logging.error(f"Error fetching graduation requirements: {e}")
        return jsonify({"error": "Internal Server Error"}), 500
    
@app.route('/student-status/<student_id>', methods=['GET'])
def get_student_status(student_id):
    try:
        cursor = mysql.connection.cursor()
        query = "SELECT * FROM student_status WHERE student_id = %s"
        cursor.execute(query, (student_id,))
        result = cursor.fetchone()
        if result:
            column_names = [desc[0] for desc in cursor.description]
            response = dict(zip(column_names, result))
            return jsonify(response), 200
        else:
            return jsonify({"error": "No student status found"}), 404
    except Exception as e:
        logging.error(f"Error fetching student status: {e}")
        return jsonify({"error": "Internal Server Error"}), 500

@app.route('/student-info/<student_id>/performance', methods=['GET'])
def get_student_performance(student_id):
    try:
        cursor = mysql.connection.cursor()
        query = "SELECT toeic_score, GPA FROM student_info WHERE student_id = %s"
        cursor.execute(query, (student_id,))
        result = cursor.fetchone()
        if result:
            response = {"toeic_score": result[0], "GPA": result[1]}
            return jsonify(response), 200
        else:
            return jsonify({"error": "No student performance data found"}), 404
    except Exception as e:
        logging.error(f"Error fetching student performance: {e}")
        return jsonify({"error": "Internal Server Error"}), 500
    
if __name__ == "__main__":
    #app.run(host="10.74.27.188", port=5000)
    app.run(host='0.0.0.0', port='5000')

# # 전체 학생 상태 업데이트
# @app.route('/update_student_status', methods=['POST'])
# def update_student_status():
#     try:
#         logging.debug("API 호출 시작")
#         data = request.get_json()
#         logging.debug(f"요청 데이터: {data}")
        
#         student_id = data.get('student_id')
#         if not student_id:
#             logging.error("student_id가 없습니다.")
#             return jsonify({'error': 'student_id is required'}), 400
        
#         cursor = mysql.connection.cursor()
#         logging.debug("Cursor 생성 완료")

#         # student_enrollment에서 is_english가 True인 강의의 학점 합산
#         cursor.execute("""
#             SELECT SUM(credit) 
#             FROM student_enrollment 
#             WHERE student_id = %s AND is_english = 1
#         """, (student_id,))
#         eng_total_credit = cursor.fetchone()[0] or 0
#         logging.debug(f"총 영어 강의 학점: {eng_total_credit}")

#         # 학생의 total_credit, major_total_credit, bsm_total_credit 계산
#         cursor.execute("""
#             SELECT SUM(credit), 
#                    SUM(CASE WHEN category = '전공' THEN credit ELSE 0 END),
#                    SUM(CASE WHEN category = '학문기초' THEN credit ELSE 0 END)
#             FROM student_enrollment
#             WHERE student_id = %s
#         """, (student_id,))
#         result_credits = cursor.fetchone()
#         logging.debug(f"학생의 총 학점 결과: {result_credits}")
        
#         if result_credits:
#             total_credit, major_total_credit, bsm_total_credit = result_credits
#         else:
#             total_credit, major_total_credit, bsm_total_credit = 0, 0, 0

#         logging.debug(f"Total Credit: {total_credit}")
#         logging.debug(f"Major Total Credit: {major_total_credit}")
#         logging.debug(f"BSM Total Credit: {bsm_total_credit}")
        
#         # graduation_requirement에서 major_ess_list, general_ess_list, bsm_ess_list 가져오기
#         cursor.execute("""
#             SELECT gr.major_ess_list, gr.g_ess_list, gr.bsm_ess_list
#             FROM graduation_requirement AS gr
#             JOIN student_info AS si ON gr.standard_year = si.enter_year
#             WHERE si.student_id = %s
#         """, (student_id,))
#         result = cursor.fetchone()
#         logging.debug(f"graduation_requirement 결과: {result}")
        
#         if not result:
#             logging.error("graduation_requirement 데이터 없음")
#             return jsonify({'error': 'No graduation requirement found for the student'}), 404
        
#         major_ess_list = [course.strip() for course in result[0].split(',')]
#         general_ess_list = [course.strip() for course in result[1].split(',')] if result[1] else []
#         bsm_ess_list = [course.strip() for course in result[2].split(',')] if result[2] else []

#         logging.debug(f"major_ess_list: {major_ess_list}")
#         logging.debug(f"general_ess_list: {general_ess_list}")
#         logging.debug(f"bsm_ess_list: {bsm_ess_list}")

#         # 각 리스트에 대한 조건을 처리
#         def calculate_credits(course_list):
#             if not course_list:
#                 return 0
#             placeholders = ', '.join(['%s'] * len(course_list))
#             if course_list == major_ess_list :
#                 query = f"""
#                     SELECT course_name, credit 
#                     FROM student_enrollment 
#                     WHERE student_id = %s 
#                     AND (course_name IN ({placeholders}) OR (course_name LIKE %s AND category = '전공'))
#                 """
#                 cursor.execute(query, (student_id, *course_list, '개별연구%'))
#             else:
#                 query = f"""
#                     SELECT course_name, credit 
#                     FROM student_enrollment 
#                     WHERE student_id = %s 
#                     AND (course_name IN ({placeholders}))
#                 """
#                 cursor.execute(query, (student_id, *course_list))

#             enrolled_courses = cursor.fetchall()
#             logging.debug(f"매칭된 강의: {enrolled_courses}")
#             return sum(course[1] for course in enrolled_courses)
        
#         # 각 credit 계산
#         major_ess_credit = calculate_credits(major_ess_list)
#         general_ess_credit = calculate_credits(general_ess_list)
#         bsm_ess_credit = calculate_credits(bsm_ess_list)

#         logging.debug(f"Major Essential Credit: {major_ess_credit}")
#         logging.debug(f"General Essential Credit: {general_ess_credit}")
#         logging.debug(f"BSM Essential Credit: {bsm_ess_credit}")

#         # graduation_requirement에서 g_sel_list 가져오기
#         cursor.execute("""
#             SELECT gr.g_sel_list
#             FROM graduation_requirement AS gr
#             JOIN student_info AS si ON gr.standard_year = si.enter_year
#             WHERE si.student_id = %s
#         """, (student_id,))
#         result_g = cursor.fetchone()
#         logging.debug(f"graduation_requirement 결과: {result_g}")

#         if not result_g:
#             logging.error("graduation_requirement 데이터 없음")
#             return jsonify({'error': 'No graduation requirement found for the student'}), 404
        
#         # g_sel_list 가져오기
#         g_sel_list = [course.strip() for course in result_g[0].split(',')] if result_g[0] else []
#         logging.debug(f"g_sel_list: {g_sel_list}")

#         # '공통교양' category의 수업 이름들을 가져오기
#         cursor.execute("""
#             SELECT DISTINCT course_name 
#             FROM student_enrollment 
#             WHERE student_id = %s AND category = '공통교양'
#         """, (student_id,))
#         enrolled_g_courses = cursor.fetchall()
#         enrolled_g_courses = [course[0] for course in enrolled_g_courses]

#         logging.debug(f"enrolled_g_courses: {enrolled_g_courses}")

#         # 교집합 확인
#         matching_courses = set(g_sel_list) & set(enrolled_g_courses)
#         logging.debug(f"matching_courses: {matching_courses}")
#         if matching_courses:
#             general_ess_credit += 3

#         # graduation_requirement에서 sci_sel_list 가져오기
#         cursor.execute("""
#             SELECT gr.sci_sel_list
#             FROM graduation_requirement AS gr
#             JOIN student_info AS si ON gr.standard_year = si.enter_year
#             WHERE si.student_id = %s
#         """, (student_id,))
#         result_bsm = cursor.fetchone()
#         logging.debug(f"graduation_requirement 결과: {result_bsm}")

#         if not result_bsm:
#             logging.error("graduation_requirement 데이터 없음")
#             return jsonify({'error': 'No graduation requirement found for the student'}), 404
        
#         # sci_sel_list 가져오기
#         sci_sel_list = [course.strip() for course in result_bsm[0].split(',')] if result_bsm[0] else []
#         logging.debug(f"sci_sel_list: {sci_sel_list}")

#         # '학문기초' category의 수업 이름들을 가져오기
#         cursor.execute("""
#             SELECT DISTINCT course_name 
#             FROM student_enrollment 
#             WHERE student_id = %s AND category = '학문기초'
#         """, (student_id,))
#         enrolled_bsm_courses = cursor.fetchall()
#         enrolled_bsm_courses = [course[0] for course in enrolled_bsm_courses]

#         logging.debug(f"enrolled_sci_courses: {enrolled_bsm_courses}")

#         # 교집합 확인
#         matching_courses = set(sci_sel_list) & set(enrolled_bsm_courses)
#         logging.debug(f"matching_courses: {matching_courses}")
#         if matching_courses:
#             bsm_ess_credit += 4

#         # student_status 테이블에 해당 학생이 존재하는지 확인
#         cursor.execute("SELECT COUNT(*) FROM student_status WHERE student_id = %s", (student_id,))
#         count = cursor.fetchone()[0]

#         if count > 0:
#             # 존재하면 업데이트
#             cursor.execute("""
#                 UPDATE student_status 
#                 SET total_credit = %s, major_total_credit = %s, bsm_total_credit = %s,
#                     major_ess_credit = %s, general_ess_credit = %s, bsm_ess_credit = %s, eng_total_credit = %s
#                 WHERE student_id = %s
#             """, (total_credit, major_total_credit, bsm_total_credit, major_ess_credit, general_ess_credit, bsm_ess_credit, eng_total_credit, student_id))
#             logging.info("학점 업데이트 성공")
#         else:
#             # 존재하지 않으면 새로 삽입
#             cursor.execute("""
#                 INSERT INTO student_status (student_id, total_credit, major_total_credit, bsm_total_credit, 
#                                             major_ess_credit, general_ess_credit, bsm_ess_credit, eng_total_credit) 
#                 VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
#             """, (student_id, total_credit, major_total_credit, bsm_total_credit, major_ess_credit, general_ess_credit, bsm_ess_credit, eng_total_credit))
#             logging.info("student_status에 새로운 기록 추가 성공")
        
#         mysql.connection.commit()

#         return jsonify({
#             'message': 'Essential credits updated successfully',
#             'total_credit': total_credit,
#             'major_total_credit': major_total_credit,
#             'bsm_total_credit': bsm_total_credit,
#             'major_ess_credit': major_ess_credit,
#             'general_ess_credit': general_ess_credit,
#             'bsm_ess_credit': bsm_ess_credit,
#             'eng_total_credit': eng_total_credit
#         }), 200
#     except Exception as e:
#         logging.error(f"예외 발생: {e}")
#         mysql.connection.rollback()
#         return jsonify({'error': 'An error occurred during processing'}), 500
#     finally:
#         if 'cursor' in locals():
#             cursor.close()
#             logging.debug("Cursor 닫기 완료")

# # /graduation_requirement API
# @app.route('/graduation_requirement', methods=['POST'])
# def graduation_requirement():
#     # 요청에서 student_id 가져오기
#     data = request.get_json()
#     student_id = data.get('student_id')
    
#     if not student_id:
#         return jsonify({"error": "student_id is required"}), 400

#     # 학번 앞 4자리로 졸업 요건 년도 찾기
#     standard_year = int(str(student_id)[:4])

#     # 데이터베이스 연결
#     cursor = mysql.connection.cursor()
#     logging.debug("Cursor 생성 완료")

#     # 해당 년도의 졸업 요건 찾기
#     cursor.execute("""
#         SELECT * FROM graduation_requirement WHERE standard_year = %s
#     """, (standard_year,))

#     # 결과 가져오기
#     graduation_requirement = cursor.fetchone()  # 한 행을 가져옴

#     # 졸업 요건이 없으면 오류 메시지 반환
#     if not graduation_requirement:
#         return jsonify({"error": "No graduation requirement found for this year"}), 404

#     # 졸업 요건 반환
#     graduation_requirement_dict = {
#         "standard_year": graduation_requirement[0],
#         "standard_dep": graduation_requirement[1],
#         "total_credit": graduation_requirement[2],
#         "major_total_credit": graduation_requirement[3],
#         "major_ess_credit": graduation_requirement[4],
#         "major_ess_list": graduation_requirement[5],
#         "general_ess_credit": graduation_requirement[6],
#         "g_ess_list": graduation_requirement[7],
#         "g_sel_list": graduation_requirement[8],
#         "basic_total_credit": graduation_requirement[9],
#         "bsm_total_credit": graduation_requirement[10],
#         "bsm_ess_credit": graduation_requirement[11],
#         "bsm_ess_list": graduation_requirement[12],
#         "sci_sel_list": graduation_requirement[13],
#         "eng_total_credit": graduation_requirement[14],
#         "toeic_score": graduation_requirement[15],
#         "GPA": graduation_requirement[16]
#     }

#     # 연결 종료
#     cursor.close()

#     return jsonify(graduation_requirement_dict), 200

# if __name__ == '__main__':
#     app.run(port=5000)

# 확인용
# @app.route('/test_connection', methods=['GET'])
# def test_connection():
#     try:
#         cursor = mysql.connection.cursor()
#         cursor.execute('SELECT 1')
#         result = cursor.fetchone()
#         cursor.close()

#         if result:
#             return jsonify({"message": "Successfully connected to MySQL!"})
#         else:
#             return jsonify({"message": "Failed to connect to MySQL."}), 500
#     except Exception as e:
#         return jsonify({"message": f"Error: {str(e)}"}), 500
    
# @app.route('/get_all_student_ids', methods=['GET'])
# def get_all_student_ids():
#     try:
#         cursor = mysql.connection.cursor()
        
#         # student_info 테이블에서 모든 student_id 가져오기
#         cursor.execute("SELECT student_id FROM student_info")
#         result = cursor.fetchall()
        
#         # 결과를 리스트 형태로 변환
#         student_ids = [row[0] for row in result]
        
#         return jsonify({'student_ids': student_ids}), 200
#     except Exception as e:
#         return jsonify({'error': str(e)}), 500
#     finally:
#         cursor.close()

# 필수만 업데이트 리스트랑 비교해서
# @app.route('/update_ess_credit', methods=['POST'])
# def update_major_ess_credit():
#     try:
#         logging.debug("API 호출 시작")
#         data = request.get_json()
#         logging.debug(f"요청 데이터: {data}")
        
#         student_id = data.get('student_id')
#         if not student_id:
#             logging.error("student_id가 없습니다.")
#             return jsonify({'error': 'student_id is required'}), 400
        
#         cursor = mysql.connection.cursor()
#         logging.debug("Cursor 생성 완료")
        
#         # graduation_requirement에서 major_ess_list, general_ess_list, bsm_ess_list 가져오기
#         cursor.execute("""
#             SELECT gr.major_ess_list, gr.g_ess_list, gr.bsm_ess_list
#             FROM graduation_requirement AS gr
#             JOIN student_info AS si ON gr.standard_year = si.enter_year
#             WHERE si.student_id = %s
#         """, (student_id,))
#         result = cursor.fetchone()
#         logging.debug(f"graduation_requirement 결과: {result}")
        
#         if not result:
#             logging.error("graduation_requirement 데이터 없음")
#             return jsonify({'error': 'No graduation requirement found for the student'}), 404
        
#         major_ess_list = [course.strip() for course in result[0].split(',')]
#         general_ess_list = [course.strip() for course in result[1].split(',')] if result[1] else []
#         bsm_ess_list = [course.strip() for course in result[2].split(',')] if result[2] else []

#         logging.debug(f"major_ess_list: {major_ess_list}")
#         logging.debug(f"general_ess_list: {general_ess_list}")
#         logging.debug(f"bsm_ess_list: {bsm_ess_list}")

#         # 각 리스트에 대한 조건을 처리
#         def calculate_credits(course_list):
#             if not course_list:
#                 return 0
#             placeholders = ', '.join(['%s'] * len(course_list))
#             if course_list == major_ess_list :
#                 query = f"""
#                     SELECT course_name, credit 
#                     FROM student_enrollment 
#                     WHERE student_id = %s 
#                     AND (course_name IN ({placeholders}) OR (course_name LIKE %s AND category = '전공'))
#                 """
#                 cursor.execute(query, (student_id, *course_list, '개별연구%'))
#             else:
#                 query = f"""
#                     SELECT course_name, credit 
#                     FROM student_enrollment 
#                     WHERE student_id = %s 
#                     AND (course_name IN ({placeholders}))
#                 """
#                 cursor.execute(query, (student_id, *course_list))

#             enrolled_courses = cursor.fetchall()
#             logging.debug(f"매칭된 강의: {enrolled_courses}")
#             return sum(course[1] for course in enrolled_courses)
        
#         # 각 credit 계산
#         major_ess_credit = calculate_credits(major_ess_list)
#         general_ess_credit = calculate_credits(general_ess_list)
#         bsm_ess_credit = calculate_credits(bsm_ess_list)

#         logging.debug(f"Major Essential Credit: {major_ess_credit}")
#         logging.debug(f"General Essential Credit: {general_ess_credit}")
#         logging.debug(f"BSM Essential Credit: {bsm_ess_credit}")

#         # graduation_requirement에서 g_sel_list 가져오기
#         cursor.execute("""
#             SELECT gr.g_sel_list
#             FROM graduation_requirement AS gr
#             JOIN student_info AS si ON gr.standard_year = si.enter_year
#             WHERE si.student_id = %s
#         """, (student_id,))
#         result_g = cursor.fetchone()
#         logging.debug(f"graduation_requirement 결과: {result_g}")

#         if not result_g:
#             logging.error("graduation_requirement 데이터 없음")
#             return jsonify({'error': 'No graduation requirement found for the student'}), 404
        
#         # g_sel_list 가져오기
#         g_sel_list = [course.strip() for course in result_g[0].split(',')] if result_g[0] else []
#         logging.debug(f"g_sel_list: {g_sel_list}")

#         # '공통교양' category의 수업 이름들을 가져오기
#         cursor.execute("""
#             SELECT DISTINCT course_name 
#             FROM student_enrollment 
#             WHERE student_id = %s AND category = '공통교양'
#         """, (student_id,))
#         enrolled_g_courses = cursor.fetchall()
#         enrolled_g_courses = [course[0] for course in enrolled_g_courses]

#         logging.debug(f"enrolled_g_courses: {enrolled_g_courses}")

#         # 교집합 확인
#         matching_courses = set(g_sel_list) & set(enrolled_g_courses)
#         logging.debug(f"matching_courses: {matching_courses}")
#         if matching_courses:
#             general_ess_credit += 3

#         # graduation_requirement에서 sci_sel_list 가져오기
#         cursor.execute("""
#             SELECT gr.sci_sel_list
#             FROM graduation_requirement AS gr
#             JOIN student_info AS si ON gr.standard_year = si.enter_year
#             WHERE si.student_id = %s
#         """, (student_id,))
#         result_bsm = cursor.fetchone()
#         logging.debug(f"graduation_requirement 결과: {result_bsm}")

#         if not result_bsm:
#             logging.error("graduation_requirement 데이터 없음")
#             return jsonify({'error': 'No graduation requirement found for the student'}), 404
        
#         # sci_sel_list 가져오기
#         sci_sel_list = [course.strip() for course in result_bsm[0].split(',')] if result_bsm[0] else []
#         logging.debug(f"sci_sel_list: {sci_sel_list}")

#         # '학문기초' category의 수업 이름들을 가져오기
#         cursor.execute("""
#             SELECT DISTINCT course_name 
#             FROM student_enrollment 
#             WHERE student_id = %s AND category = '학문기초'
#         """, (student_id,))
#         enrolled_bsm_courses = cursor.fetchall()
#         enrolled_bsm_courses = [course[0] for course in enrolled_bsm_courses]

#         logging.debug(f"enrolled_sci_courses: {enrolled_bsm_courses}")

#         # 교집합 확인
#         matching_courses = set(sci_sel_list) & set(enrolled_bsm_courses)
#         logging.debug(f"matching_courses: {matching_courses}")
#         if matching_courses:
#             bsm_ess_credit += 4

#         # student_status 테이블에 해당 학생이 존재하는지 확인
#         cursor.execute("SELECT COUNT(*) FROM student_status WHERE student_id = %s", (student_id,))
#         count = cursor.fetchone()[0]

#         if count > 0:
#             # 존재하면 업데이트
#             cursor.execute("""
#                 UPDATE student_status 
#                 SET major_ess_credit = %s, general_ess_credit = %s, bsm_ess_credit = %s
#                 WHERE student_id = %s
#             """, (major_ess_credit, general_ess_credit, bsm_ess_credit, student_id))
#             logging.info("major_ess_credit, general_ess_credit, bsm_ess_credit 업데이트 성공")
#         else:
#             # 존재하지 않으면 새로 삽입
#             cursor.execute("""
#                 INSERT INTO student_status (student_id, major_ess_credit, general_ess_credit, bsm_ess_credit) 
#                 VALUES (%s, %s, %s, %s)
#             """, (student_id, major_ess_credit, general_ess_credit, bsm_ess_credit))
#             logging.info("student_status에 새로운 기록 추가 성공")
        
#         mysql.connection.commit()

#         return jsonify({
#             'message': 'Essential credits updated successfully',
#             'major_ess_credit': major_ess_credit,
#             'general_ess_credit': general_ess_credit,
#             'bsm_ess_credit': bsm_ess_credit
#         }), 200
#     except Exception as e:
#         mysql.connection.rollback()
#         logging.error(f"오류 발생: {e}")
#         return jsonify({'error': str(e)}), 500
#     finally:
#         if 'cursor' in locals():
#             cursor.close()
#             logging.debug("Cursor 닫기 완료")

#영어 강의만 업데이트
# @app.route('/update_eng_total_credit', methods=['POST'])
# def update_eng_total_credit():
#     try:
#         logging.debug("API 호출 시작")
#         data = request.get_json()
#         logging.debug(f"요청 데이터: {data}")
        
#         student_id = data.get('student_id')
#         if not student_id:
#             logging.error("student_id가 없습니다.")
#             return jsonify({'error': 'student_id is required'}), 400
        
#         cursor = mysql.connection.cursor()
#         logging.debug("Cursor 생성 완료")
        
#         # student_enrollment에서 is_english가 True인 강의의 학점 합산
#         cursor.execute("""
#             SELECT SUM(credit) 
#             FROM student_enrollment 
#             WHERE student_id = %s AND is_english = 1
#         """, (student_id,))
#         total_english_credits = cursor.fetchone()[0] or 0
#         logging.debug(f"총 영어 강의 학점: {total_english_credits}")
        
#         # student_status 테이블에 해당 학생이 존재하는지 확인
#         cursor.execute("SELECT COUNT(*) FROM student_status WHERE student_id = %s", (student_id,))
#         count = cursor.fetchone()[0]
        
#         if count > 0:
#             # 존재하면 업데이트
#             cursor.execute("""
#                 UPDATE student_status 
#                 SET eng_total_credit = %s 
#                 WHERE student_id = %s
#             """, (total_english_credits, student_id))
#             logging.info("eng_total_credit 업데이트 성공")
#         else:
#             # 존재하지 않으면 새로 삽입
#             cursor.execute("""
#                 INSERT INTO student_status (student_id, eng_total_credit) 
#                 VALUES (%s, %s)
#             """, (student_id, total_english_credits))
#             logging.info("student_status에 새로운 기록 추가 성공")
        
#         mysql.connection.commit()

#         return jsonify({'message': 'English total credits updated successfully', 'total_credits': total_english_credits}), 200
#     finally:
#         if 'cursor' in locals():
#             cursor.close()
#             logging.debug("Cursor 닫기 완료")
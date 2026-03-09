# 과제 제출 방법

스터디 문제는 `study` 브랜치에 주차별 폴더 형태로 업로드됩니다.  
각 스터디원은 해당 폴더 안에 **자신의 이름으로 된 sql 파일을 생성하여 풀이를 제출**합니다.
정답을 적어서 제출하되, 왜 이렇게 작성했는지, 어떤 부분에서 에러가 났는지 등을 주석으로 적어서 같이 제출
dbeaver 안에서 쿼리쳐서 테스트 이거저거 해보고 제일 좋았던 것을 이걸로 제출하는것도 나쁘진않을듯

# 폴더 구조

예시 구조는 아래와 같습니다.

study  
 ├ week1  
 │   ├ problem.sql  
 │   ├ dongha_week1.sql  
 │   ├ minsu_week1.sql  
 │   └ jiho_week1.sql  
 ├ week2  
 │   ├ problem.sql  
 │   ├ dongha_week2.sql  
 │   └ minsu_week2.sql

- `sample_question.sql` : 해당 주차 문제 파일
    
- `이름_weekN.sql` : 각 스터디원의 풀이 파일
    

예시

dongha_week1.sql


# 제출 절차

## 1. study 브랜치로 이동

git checkout study

## 2. 최신 코드 가져오기

git pull origin study

## 3. 문제 파일 복사

해당 주차 폴더에서 `sample_question.ipynb` 파일을 복사하여  
자신의 이름으로 된 파일을 생성합니다.

예

dongha_week1.ipynb


## 4. 문제 풀이 작성

`.ipynb` 파일 안에 SQL 쿼리와 실행 결과를 작성합니다.


## 5. 커밋 및 제출

git add .  
git commit -m "week1 dongha 제출"  
git push origin study


# 동시에 작업하는 경우

여러 명이 동시에 작업할 수 있으므로 **push 전에 항상 최신 코드를 가져오는 것을 권장합니다.**

git pull origin study

다른 스터디원이 먼저 파일을 추가했더라도  
각자 **다른 파일을 생성하는 방식이므로 대부분 자동으로 병합됩니다.**

예

dongha_week1.ipynb  
minsu_week1.ipynb


# 주의사항

- `problem.ipynb` 파일은 수정하지 않습니다.
    
- 본인 이름으로 된 파일만 수정합니다.
    
- push가 거절될 경우 `pull` 후 다시 `push`합니다.

- 절대 main 브랜치에 병합하지 않기!!!!!!!!!!!
    

git pull origin study  
git push origin study
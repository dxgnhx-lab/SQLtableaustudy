# 과제 제출 방법

스터디 문제는 `study` 브랜치에 주차별 폴더 형태로 업로드됩니다.  
각 스터디원은 해당 폴더 안에 **자신의 이름으로 된 ipynb 파일을 생성하여 풀이를 제출**합니다.


# 폴더 구조

예시 구조는 아래와 같습니다.

study  
 ├ week1  
 │   ├ problem.ipynb  
 │   ├ dongha_week1.ipynb  
 │   ├ minsu_week1.ipynb  
 │   └ jiho_week1.ipynb  
 ├ week2  
 │   ├ problem.ipynb  
 │   ├ dongha_week2.ipynb  
 │   └ minsu_week2.ipynb

- `problem.ipynb` : 해당 주차 문제 파일
    
- `이름_weekN.ipynb` : 각 스터디원의 풀이 파일
    

예시

dongha_week1.ipynb


# 제출 절차

## 1. study 브랜치로 이동

git checkout study

## 2. 최신 코드 가져오기

git pull origin study

## 3. 문제 파일 복사

해당 주차 폴더에서 `problem.ipynb` 파일을 복사하여  
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
    

git pull origin study  
git push origin study
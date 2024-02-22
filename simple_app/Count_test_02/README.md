# CountUp
웹 페이지를 새로고침하면 숫자가 하나씩 카운팅된다.  
그러나 해당 코드에서 테스트하고자 한 내용은 node.js 를 이용한 서비스가 아니다.  

----

## 사용된 서비스
- Github Actions 에서 AWS 인증
- AWS ECR (Elastic Container Registry) 이미지 빌드/푸시 및 배포
- sonarqube 실행
- telegram alert 발송
- jira ticket 생성

### Github-Actions을 이용하여 테스트한 사항
1. docker image 자동 빌드 및 hub로 푸시
2. sonarqube 자동 실행하여 레포지토리에 있는 소스 코드 분석
3. 배포 스크립립트를 이용하여 docker image 배포  
 3.1. 도커이미지 배포는 무중단 배포를 위한 blue-green 형태로 배포 스크립트 작성

### 추가로 진행해볼 사항
1. AWS EC2 접근하기 위한 최적의 방안 탐색 (SSH가 아닌, SSM 등)
2. sonarqube 소스 코드 분석 후, 원하는 workflows 즉시 실행하도록 수동 버튼 생성 (dispatch)
3. Telegram Alert  
 3.1. sonarqube 소스 코드 완료시 알림 발생 (성공/스멜/악성 등)  
 3.2. 이미지 빌드/푸시 성공여부 알림  
 3.3. 배포 성공여부 알림  

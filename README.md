# NaverShoppingApp
<br>

### 프로젝트
 - 인원 : 개인프로젝트 <br>
 - 기간 : 2023.09.24 ~ 2023.10.22 (4주) <br>
 - 최소지원버전 : iOS 13 <br>
 
<br>

### 한줄소개
 - 상품 검색, 좋아요 기능으로 마음에 드는 상품을 저장 해둘 수 있는 앱 입니다.
   
<br>

### 미리보기


<br>

### 기술
| Category | Stack |
|----|-----|
| Architecture | `MVC` |
| iOS | `UIKit` `WebKit` `UserDefaults` |
|  UI  | `CodeBaseUI` `SnapKit` |
|  Network  | `Alamofire` `Codable` |
|  Database  | `Realm` |
|  Image  | `Kingfisher` |
|  Dependency Manager  | `SwiftPackageManager` |
|  Etc  | `Toast` `SkeletonView` `Basekit` |

<br>

### 기능
1. 네이버 쇼핑 API 를 이용해 검색 및 페이지네이션
2. 좋아요 상태는 모든화면에서 동기화
3. 좋아요 목록 Realm 저장
4. 좋아요 실시간 검색
5. pull down refresh 

<br>

### 개발 고려사항
- NetworkMonitor 활용해서 인터넷 연결 체크
- Realm NotificationToken 활용해 Realm 데이터 변경될 때 UI 업데이트 되도록 구현
- 다크모드, 다국어 대응

<br>


### 트러블슈팅

####  1. 검색화면에서 좋아요 터치 반응 없는 오류
 -> mainView 에 TabGesture 를 이용해 키보드가 올라와있을 때 키보드를 내려주는 기능을 구현이 되어 있는 상태였습니다.<br>
  하트버튼의 터치를 mainView 의 TabGesture 가 가로채서 didSelectItemAt 메서드가 호출 되지 않고 있었습니다. <br>
  Cell 에 TabGesture 를 추가해주고 다시 didSelectItemAt 이 호출 되는 것을 확인했습니다.

####  2. 상세화면으로 이동할 때 버벅이는 오류
-> AppDelegate 에서 UIView backgroundColor 를 clear 시켜주고 있는 상태였습니다. <br>
  다른 ViewController 는 버벅이지 않고 있어서 비교해보니 mainView 의 backgroundColor 가 적용되어 있지 않은 것을 확인 후
   Color 값을 지정해주자 부드럽게 화면 전환이 되는 것을 확인했습니다.

####  3. 자체적으로 만든 BaseKit 이 github 에 커밋 안되는 오류
 -> BaseKit 프레임워크를 처음 생성시 현재프로젝트 폴더와 같은 레벨에 위치해있었습니다. <br>
 git 이 연결되어 있지 않은 곳에 BaseKit 프레임워크가 위치하고 있어 github 에 커밋할 때 추가되지 않았던 오류로 <br>
 git 이 연결되어 있는 현재 프로젝트 폴더 안으로 BaseKit 을 추가해준 뒤 github 에 커밋할 수 있었습니다.
   

<br>

### 회고


<br>


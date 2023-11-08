# NaverShoppingApp
<br>

### 프로젝트
 - 인원 : 개인프로젝트 <br>
 - 기간 : 2023.09.07 ~ 2023.09.11 (5일) <br>
 - 최소지원버전 : iOS 13 <br>
 
<br>

### 한줄소개
 - 상품 검색, 좋아요 기능으로 마음에 드는 상품을 저장 해둘 수 있는 앱 입니다.
   
<br>

### 미리보기
![1102023039317995](https://github.com/J-comet/traveltune/assets/67407666/9925c78e-1faf-4477-8f83-96d23503cfd9)

<br>

### 기술
| Category | Stack |
|:----|:-----|
| Architecture | `MVC` |
| iOS | `UIKit` `WebKit` `UserDefaults` |
|  UI  | `SnapKit` |
|  Network  | `Alamofire` `Codable` |
|  Database  | `Realm` |
|  Image  | `Kingfisher` |
|  Dependency Manager  | `SPM` |
|  Etc  | `Toast` `SkeletonView` `Basekit` |

<br>

### 기능
1. 네이버 쇼핑 API 이용해 검색 및 페이지네이션
2. 상품 상세페이지 WebView load
3. 좋아요 상태는 모든 화면에서 동기화
4. 좋아요 목록 Realm 저장
5. 좋아요 상품 실시간 검색
6. Pagination / Infinite Scroll / pull down refresh

<br>

### 개발 고려사항
- NWPathMonitor 활용해 인터넷 상태 체크
- 공통으로 사용중인 코드 BaseKit 모듈화
- Realm 좋아요 기능 구현, NotificationToken 활용해 데이터 변경시 UI 업데이트
- WebKit 활용해 상품 상세페이지 URL 로드
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
 - 개발을 시작하며 기능별 공수산정을 하지 않고 개발을 시작했습니다. 결과 특정 기능에 시간을 많이 사용해서 다른 기능을 개발할 때 <br>
   많은 시간을 투자하지 못했습니다. 공수산정을 잘하는 부분도 중요하고 구현이 완료된 부분을 리팩토링 하는 것은 모든 기능을 완료 후 하는 것이 좋을 것 같다고 느꼈습니다.
 - pull down refresh 기능을 구현할 때 단순히 당겼을 때 업데이트만 해주면 될 것 같아서 시작했는데 막상 개발해보니 <br>
   검색 결과 유무, 검색어 입력 값 유무, refresh 중인지 유무등 체크해야 되는 지점이 상당히 많았습니다. <br>
   간단한 기능으로 보일지라도 뒤에서 개발자가 어떤 예외처리를 해주고 있는지 고민을 많이 해봐야 될 것 같습니다.

<br>


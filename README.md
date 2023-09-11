Recap02
==========
상품 검색, 좋아요 기능으로 마음에 드는 상품을 저장 해둘 수 있는 앱. 

<br>

> 요구사항
1. 네이버 쇼핑 API 를 이용해 검색 및 페이지네이션 기능.
2. 좋아요 상태는 모든화면에서 동기화.
3. 좋아요 목록은 앱이 삭제되기 전까지 영구적으로 저장.
4. 로컬 DB에 저장된 좋아요 실시간 검색 기능
5. CodeBase UI

<br>

> 추가 기능
1. 다크모드 대응
2. 다국어 대응
3. 검색화면 당겨서 새로고침   
4. 좋아요화면 목록 없을 때 검색화면으로 이동버튼 추가
5. 네트워크 연결 체크
6. SkeletonView 적용

<br>

> 문제 해결
<details>
<summary>검색화면에서 좋아요 터치 반응 없는 오류</summary>
<div markdown="1">
- mainView 에 TabGesture 를 이용해 키보드가 올라와있을 때 키보드를 내려주는 기능을 구현이 되어 있는 상태였다.<br> 
  하트버튼의 터치를 mainView 의 TabGesture 가 가로채서 didSelectItemAt 가 호출 되지 않고 있었다.<br>
  Cell 에 TabGesture 를 추가해주고 다시 didSelectItemAt 이 호출 되는 것을 확인했다.
</div>
</details>

<details>
<summary>검색화면에서 페이징 이후 좋아요 누르지 않은 아이템이 좋아요 표시로 되는 오류</summary>
<div markdown="1">
- CollectionViewCell 에서 prepareForReuse() 함수에 image = nil 로 처리를 해두었지만 통하지 않았다.<br>
  그래서 애초에 빈하트,꽉찬하트 이미지뷰를 2개를 곂쳐서 두고 hidden 처리하는 방식으로 변경 후 잘동작하는 것을 확인했다.
</div>
</details>

<details>
<summary>상세화면으로 이동할 때 버벅이는 오류</summary>
<div markdown="1">
- viewDidLoad()를 작성했는지 체크했는데 이미 작성되어있었다.<br>
  그 이후 DetailProductView 에 BackgroundColor 가 지정되지 않은 걸 보고 BackgroundColor 값을 지정해주자 잘동작하는 것을 확인했다.
</div>
</details>

<br>

NaverAPIKey
----------
name | value
:---------:|:----------:|
 clientID | EvDsEyvh9JtGGD8l0VIv
 ClientSecret | 6hvb5CCpas 

<br>

Development Environment
----------
<p align="left">
<img src ="https://img.shields.io/badge/Swift-5.8.1-F05138?style=for-the-plastic&logo=swift&logoColor=white">
<img src ="https://img.shields.io/badge/Xcode-14.3.1-147EFB?style=for-the-plastic&logo=Xcode&logoColor=white">
<img src ="https://img.shields.io/badge/iOS-13.0-orange?style=for-the-plastic&logo=apple&logoColor=white">
</p>

<br>
  
Architecture
----------
MVC Pattern
<br>
<img src="https://github.com/J-comet/Recap02/assets/67407666/6eb16d96-41e6-43c6-866a-72acf1be67e8.png" width="700" height="300"/>
<br><br>

Used Libraries & Framework
----------
- [Basekit][0] - 공통으로 사용되는 View, 코드가 있는 Framework 
- [Alamofire][1] - 네트워크 통신
- [Kingfisher][2] - 이미지 로딩
- [Realm][3] - 로컬 데이터베이스
- [SkeletonView][4] - 로딩
- [Snapkit][5] - UI Layout 
- [Toast][6] - 사용자에게 간단한 알림 띄워주고 싶을 때 사용

[0]: https://github.com/J-comet/BaseKit
[1]: https://github.com/Alamofire/Alamofire
[2]: https://github.com/onevcat/Kingfisher
[3]: https://realm.io/
[4]: https://github.com/Juanpe/SkeletonView
[5]: https://github.com/SnapKit/SnapKit
[6]: https://github.com/scalessec/Toast-Swift

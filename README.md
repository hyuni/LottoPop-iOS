# LottoPop-iOS
로또팝은 나눔로또6/45와 연금복권520의 당첨 결과를 확인할 수 있는 앱입니다.
[앱스토어로 이동](https://itunes.apple.com/kr/app/id1278737707?mt=8)


# 기능
메인 화면에서 나눔로또, 연금복권의 회차별 당첨 결과를 확인할 수 있습니다.
번호를 일일이 비교할 필요 없이 복권의 QR 코드 스캔으로 당첨결과를 확인할 수 있습니다.
나눔로또 번호화 연금복권 조번호를 추천해 드립니다.
* 당첨 결과는 나눔로또 홈페이지에서 다시 한 번 확인하시기 바랍니다.
* 추천번호는 당첨과 상관이 없으며, 당첨 결과에 따른 책임을 지지 않습니다.


# 요구사항
iOS 10.0+
Xcode 9.0+
Swift 4.0+


# 라이브러리 설치
로또팝은 HTTP 통신 라이브러리인 Alamofire, JSON 변환 라이브러리인 ObjectMapper를 사용합니다.

### CocoaPods
[CocoaPods](https://cocoapods.org) 는 의존성 관리자로, 다음 명령어로 설치할 수 있습니다.
<pre>
<code>
$ gem install cocoapods
</code>
</pre>

CocoaPods이 설치되어 있다면, 프로젝트 디렉토리로 이동해 다음 명령어로 라이브러리를 설치합니다.
<pre>
<code>
$ pod install
</code>
</pre>

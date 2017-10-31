# 개발 환경

필요한 라이브러를 설치합니다.

```
$ bundle install
$ bundle exec pod install
```

env.yml.sample을 env.yml로 복사하고 적절한 값을 채웁니다. 적절한 값은 아래 "환경 설정 env.yml" 섹션을 참조합니다. 

아래 명령을 수행합니다.

```
$ bin/keys development
```

## 패키징

env.yml.sample을 env.yml로 복사하고 적절한 값을 채웁니다. 그후 아래 명령을 수행합니다.

```
$ bin/keys production
```


## 환경 설정 env.yml

env.yml.sample에 예시가 있습니다. 각 항목은 아래와 같은 의미를 가지고 있습니다.

serviceClientId: 빠띠API 클라이언트키
serviceClientSecret: 빠띠API 비밀키
serviceBaseUrl: 빠띠API 베이스 웹주소

## ToDo
* 페이스북 로그인 오류 리포팅
* API Base URL을 설정값으로
* 페북 로그인 버튼 누를 때 화면을 블럭 시켜야 합니다

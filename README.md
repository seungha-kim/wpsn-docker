# WPSN Docker

Docker란 경량 가상화 기술인 [리눅스 컨테이너](http://pyrasis.com/book/DockerForTheReallyImpatient/Chapter01/01) 및 [윈도우 컨테이너](https://blog.docker.com/2016/09/build-your-first-docker-windows-server-container/)의 제작, 배포, 공유를 편리하게 만들어주는 플랫폼 및 그를 위한 도구를 말합니다.
Docker를 사용하면 소프트웨어 실행 환경의 차이 때문에 생기는 여러 가지 문제를 피해갈 수 있습니다.

## 설치

### macOS

[Docker for Mac](https://www.docker.com/docker-mac)을 설치하세요.

### Windows

Windows 10 Pro 또는 Edu 사용자는 [Docker for Windows](https://www.docker.com/docker-windows)를 설치하세요.

Windows 10 Home 사용자는 [Docker Toolbox](https://www.docker.com/products/docker-toolbox)를 설치하세요. 이 경우 실습 예제를 Docker Terminal에서 실행시키세요.

## 컨테이너의 실행과 삭제

Docker의 설치가 완료되었다면 바로 아래의 명령으로 우분투 컨테이너를 실행시킬 수 있습니다.

### 새로운 컨테이너 실행

`docker run` 명령을 이용해 새로운 컨테이너를 실행시킬 수 있습니다. bash를 실행시키기 위해서는 표준 입력을 유지시키는 `-i` 옵션과, 가상 터미널을 띄우는 `-t` 옵션을 줘야 합니다.

```bash
# ubuntu 이미지를 받아와 bash 명령어 실행
$ docker run -i -t ubuntu bash

# 혹은 아래와 같이 줄여쓸 수 있습니다.
$ docker run -it ubuntu bash
```

여러분은 방금 Docker를 이용해 가상 우분투 컨테이너를 실행시킨 것입니다. 이 컨테이너는 격리된 자원(네트워크, 파일시스템, ...)을 사용하기 때문에 컨테이너 내부에서 호스트 머신(Docker가 실행되고 있는 운영체제)에 직접 접근하는 것은 불가능합니다. root 계정의 bash 쉘을 이용해 필요한 작업을 마친 후에 `exit` 명령을 입력해서 컨테이너를 종료해주세요.

### 컨테이너 목록 확인

방금 종료시킨 컨테이너는 직접 지우지 않는 한 디스크에 계속 남아있게 됩니다. `docker ps -a` 명령을 이용해 종료된 컨테이너를 포함한 모든 컨테이너의 목록을 확인할 수 있습니다.

### 컨테이너 다시 시작

방금 종료시킨 컨테이너를 다시 시작하려면 `docker start -ia <컨테이너 이름 혹은 ID>` 명령을 입력하면 됩니다. **컨테이너 ID**는 위에서 `docker ps -a` 명령을 입력했을 때 가장 왼쪽 열에 표시되는 값입니다. docker CLI에서 컨테이너 식별자를 사용할 때는 전체를 모두 입력할 필요 없이 앞의 서너 글자만 입력하면 됩니다. 다시 bash를 사용하기 위해서는 `-a` 옵션과 `-i` 옵션을 줘서 표준 입출력을 연결시켜야 합니다.

```bash
$ docker start -i -a e0e # 컨테이너 ID가 'e0e604644060'인 경우
```

### 컨테이너 삭제

컨테이너를 삭제하려면 `docker rm` 명령을 실행하면 됩니다. 실행 중인 컨테이너를 삭제하려고 시도하면 에러가 나는데, 그 때에는 강제로 삭제를 하는 `--force` 혹은 `-f` 옵션을 주면 됩니다.

```bash
$ docker rm -f e0e # 컨테이너 ID가 'e0e604644060'인 경우
```

애초에 컨테이너를 실행시킬 때, 컨테이너가 종료되면 자동으로 컨테이너가 삭제되도록 `--rm` 옵션을 줄 수도 있습니다.

```bash
$ docker run --rm -it ubuntu bash
```

## 이미지, 컨테이너, 레이어

우리는 위에서 `ubuntu` 이미지를 가지고 컨테이너를 실행시켰습니다. 이처럼, 이미지는 컨테이너를 실행시키기 위한 기반 파일들이 저장되어 있는 파일 뭉치입니다.

컨테이너는 실행 환경과 파일 시스템을 격리시키는 단위입니다. 그러니까, 컨테이너 안에서 프로그램이 실행되고, 이 프로그램으로 인해 일어난 파일 시스템의 변경 사항 역시 컨테이너에 기록됩니다.

그렇다면 이미지는 어떻게 만들어지는 것일까요? Docker는 Git과 유사한 개념을 사용하는데, 컨테이너 안에서 일어난 파일 시스템의 변경 사항을 **커밋**할 수 있습니다. 컨테이너를 커밋하면, 해당 커밋이 반영된 **새로운 이미지**가 만들어지게 됩니다.

한 번 커밋을 할 때에 기록되는 한 번의 변경 사항을 **레이어**라고 부릅니다. 그러니까, 이미지는 쉽게 말해 여러 개의 레이어가 쌓여있는 것입니다. 이미지를 다운로드 받을 때, 무언가 여러 개의 파일을 다운로드 받는 것 같은 진행상황이 출력되는 것을 확인할 수 있는데, 이는 이미지를 다운로드 받을 때 실제로 여러 개의 레이어를 다운로드 받기 때문입니다.

이제 ubuntu 이미지로부터 컨테이너를 실행시키고, 컨테이너 안에서 파일을 하나 만든 다음, 해당 컨테이너를 커밋해서 `myimage`라는 새 이미지를 만들어 보겠습니다.

```bash
$ docker run -it ubuntu bash

# 컨테이너 안에서
$ touch myfile
$ exit

# 컨테이너 밖에서
$ docker ps -a # 가장 위의 컨테이너 ID 확인하기
$ docker commmit 21e myimage # 컨테이너 ID가 '21e2c1fb80d1'인 경우

# 시스템에 설치된 Docker 이미지 목록 확인하기
$ docker images

# 이미지 삭제하기
$ docker rmi myimage
```

이미지, 컨테이너, 레이어에 자세한 사항은 [공식 가이드](https://docs.docker.com/engine/userguide/storagedriver/imagesandcontainers/)를 참고해주세요.

## Redis 컨테이너 실행

Redis 서버와 같은 프로그램은 별도의 프로토콜을 통해서 통신을 하기 때문에, 표준 입출력을 연결시킬 필요가 없습니다. 아래와 같이 `-d` 옵션을 줘서 Redis 이미지를 Detached 컨테이너로 실행시킬 수 있습니다. 또한 컨테이너 ID 대신 사용할 컨테이너 이름을 `--name` 옵션을 통해 지정할 수 있습니다.

```bash
$ docker run -d --name my-redis redis
```

Redis가 잘 실행되고 있는지 확인하기 위해서 `docker logs` 명령을 통해 컨테이너 안에서 실행되고 있는 프로세스의 표준 출력과 표준 에러를 확인할 수 있습니다.

```bash
$ docker logs -f my-redis
```

이렇게 Redis 서버가 잘 실행이 되었습니다. 다만 한 가지 문제가 있는데, Docker 바깥에서는 우리가 방금 실행시킨 Redis 서버에 접속할 방법이 없습니다. Docker 컨테이너 밖에서 컨테이너 안에 있는 프로세스와 통신을 하기 위해서는 포트를 직접 열어줘야 합니다. `-P` 혹은 `-p` 옵션을 통해 포트를 열어줄 수 있습니다. (다만 Docker 컨테이너끼리는 후술할 [네트워크 기능](https://docs.docker.com/engine/userguide/networking/)을 이용해 별도로 포트를 열어주지 않고도 통신할 수 있습니다.)

바깥으로 포트를 열어주기 위해, 방금 만든 컨테이너를 지우고 `-P` 옵션을 줘서 다시 실행시켜 보겠습니다.

```bash
$ docker rm -f my-redis
$ docker run -d --name my-redis -P redis
$ docker ps # 포트 확인
```

컨테이너 실행 시에 `-P` 옵션을 주면, 시스템에 남아있는 포트 중 아무거나 골라서 redis 이미지가 사용하는 포트에 연결시켜줍니다. 소문자 `-p` 옵션을 통해 우리가 직접 포트 번호를 지정할 수도 있습니다. 어쨌든, 이제부터 Docker 바깥에서 Redis 서버에 접속할 수 있게 되었습니다.

실행 중인 컨테이너를 중지시키려면, `docker stop` 혹은 `docker kill` 명령을 사용하면 됩니다. 보통의 경우에는 `docker stop`을 사용하면 됩니다. 둘의 차이점에 대한 자세한 사항은 [관련 StackOverflow 글](https://superuser.com/questions/756999/whats-the-difference-between-docker-stop-and-docker-kill)을 참고하세요.

## Dockerfile로 이미지 생성하기

위에서 컨테이너에 파일 변경을 가한 다음, 커밋을 함으로써 이미지를 생성하는 방법을 배웠습니다. 하지만 매번 이런 식으로 이미지를 생성하는 것은 오래 걸리고, 또 유지보수를 하기도 어려울 것입니다.

Docker는 이미지를 생성하는 절차를 정의할 수 있는 문서 형식인 Dockerfile을 지원하고 있습니다. Dockerfile을 한 번만 작성하면, 그 다음부터는 간단한 명령을 통해서 이미지를 생성할 수 있습니다. Dockerfile의 문법에 대한 자세한 사항은 [공식 문서](https://docs.docker.com/engine/reference/builder/)를 참고하세요.

Dockerfile 작성법은 꽤 복잡한데, 실무에서 이렇게 복잡한 Dockerfile을 처음부터 끝까지 다 작성하는 일은 드뭅니다. 다른 Dockerfile을 기반으로 필요한 명령을 몇 가지만 추가해서 새로운 Dockerfile을 만들 수 있기 때문입니다. [이 프로젝트의 Dockerfile](./Dockerfile)이 이런 식으로 작성되어 있습니다.

이제 이 폴더에 들어있는 Dockerfile과 `docker build` 명령을 이용해 이미지를 생성해 보겠습니다.

```bash
$ docker build -t wpsn-image .
```

빌드가 끝난 뒤에는 `docker images` 명령을 통해 이미지가 잘 생성되었는지 확인하세요.

## Docker의 활용

이미지는 만들었는데, 이 이미지를 어떻게 사용해야 할까요?

### Docker Registry

개발 환경에서 Docker 이미지를 실행할 수도 있겠지만, 방금 만든 이미지를 EC2 서버와 같은 클라우드에 전송해서 그 곳에서 이미지를 실행해야 할 경우가 있을 것입니다. 이처럼 Docker 이미지를 다른 컴퓨터에 전송할 수 있는 방법이 필요한데, 이를 위해 **Docker 이미지 저장소**를 두고 그 곳에 이미지를 업로드 한 뒤 필요할 때 받아서 쓰는 방식으로 이미지를 공유할 수 있습니다. 이런 용도로 쓰이는 Docker 이미지 저장소를 Docker Registry라고 부릅니다.

우리가 위에서 `docker run` 명령을 이용해서 이미지를 다운로드 받았는데, 그 이미지는 [Docker Hub](hub.docker.com)라는 공개된 Docker Registry에서 받은 것입니다. Docker Hub에는 누구나 이미지를 올릴 수 있고, 우리가 방금 만든 이미지도 Docker Hub에 올릴 수 있습니다.

그러나 보통의 회사에서는, 그 회사에서 만든 소스코드나 이미지를 공개하지 않는 경우가 대부분입니다. 이렇게 공개되면 안 되는 이미지를 저장하기 위해서 회사 내부용으로 사용할 자체 Docker Registry를 운영할 수도 있습니다. 자세한 사항은 [공식 문서](https://docs.docker.com/registry/)를 참고하세요.

### Docker Compose

Docker를 사용할 때에, 하나의 서비스를 운영하기 위해 여러 종류의 컨테이너를 동시에 띄워야 할 일이 자주 생깁니다. 이런 작업을 쉽게 만들어주는 Docker Compose라는 도구가 있습니다. 어떤 종류의 컨테이너를 어떻게 실행하면 되는지를 `docker-compose.yml` 파일에 미리 작성해두고 그 파일을 이용해 한 번에 여러 개의 컨테이너를 실행시킬 수 있습니다. 여러 컨테이너를 이용한 서비스 배포, 혹은 테스트를 해야할 때 Docker Compose를 이용해 전체 컨테이너를 빠르게 실행시킬 수 있습니다.

Docker 설치가 잘 되었다면 바로 Docker Compose를 시험해볼 수 있습니다. 이 폴더에서 `docker-compose up` 명령을 실행해보세요. 또한 이 폴더의 `docker-compose.yml` 파일의 내용도 확인해보세요.

이 폴더의 `docker-compose.yml` 파일에서는 컨테이너의 파일 공유를 위한 [volume](https://docs.docker.com/engine/admin/volumes/volumes/), 컨테이너 간 통신을 위한 [network](https://docs.docker.com/engine/userguide/networking/) 기능을 사용하고 있습니다.

### 클라우드에서 Docker 실행하기

Docker Registry와 Docker Compose의 설정이 끝났다면 EC2와 같은 가상 서버에서 Docker를 직접 실행시킬 수 있습니다. 하지만 대부분의 유명한 클라우드 서비스들은 우리가 직접 Docker Registry나 컨테이너의 실행을 위한 가상 서버를 설정하지 않고도 이미지를 공유하거나 컨테이너를 실행할 수 있는 방법을 제공하고 있습니다. 아래의 링크에서 자세한 사항을 확인하세요.

- [Docker Swarm](https://docs.docker.com/engine/swarm/key-concepts/) + [Docker Cloud](https://cloud.docker.com/)
- [Amazon EC2 Container Registry](https://aws.amazon.com/ko/ecr/) + [Amazon EC2 Container Service](https://aws.amazon.com/ko/ecs/)
- [GCP Container Engine](https://cloud.google.com/container-engine/) + [GCP Container Registry](https://cloud.google.com/container-registry/)
- [Azure Container Service](https://azure.microsoft.com/ko-kr/services/container-service/) + [Azure Container Registry](https://azure.microsoft.com/ko-kr/services/container-registry/)

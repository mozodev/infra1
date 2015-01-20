# Infra1 - 드루팔 서비스하기

terraform, ansible, digitalocean을 활용해 드루팔을 서비스하기 위해 terraform이 디지털오션에서 가상 서버 인스턴스를 생성하고 dns A 레코드를 설정한 후 ansible이 드루팔 서비스를 위한 서버 소프트웨어를 설치 및 설정합니다. 

## terraform 테라폼
[terraform](https://www.terraform.io)은 그 유명한 [vagrant](https://www.vagrantup.com)를 만든 [harshicorp](https://www.hashicorp.com)사의 오픈소스 프로젝트로서 인프라를 코드로 관리하도록 도와줍니다. 여기서 인프라라는 건 단지 웹서버나 데이터베이스 서버만 말하는게 아니라 DNS, 외부 이메일 서비스 등 API로 접근할 수 있는 다양한 자원들이라는 의미입니다. 사실 테라폼을 쓰지 않더라도 디지털오션에서 가상 서버 올리고 설정할 수 있지만 한 번 써보고 싶어서 삽질을 시작했습니다.

```
brew install terraform
```

## ansible 엔써블
[ansible](http://www.ansible.com/home)은 수많은 서버의 설정을 한꺼번에 게다가 코드로 관리할 수 있는 IT 자동화 도구입니다. chef와 다른 특징은 agentless. 엔써블은 ssh로 서버에 붙어서 실제 명령어를 날립니다. 사실 뭐 서버 한 대 설정하는데 이렇게까지 하냐 이럴 수 있지만 vagrant provisioner로 사용하면 단번에 잘 알지 못하는 개발환경을 만들어주어서 평소 참 좋아하는 도구입니다. [ansible galaxy](https://galaxy.ansible.com)에는 수많은 서버 관리자들이 공유한 플레이북, 롤이 있어서 직접 쓰지 않아도 유명한 개발 환경이나 서비스 환경을 명령어 한번으로 설정할 수도 있습니다.

```
brew install ansible
```

## drupal role
[geerlingguy.drupal](https://galaxy.ansible.com/list#/roles/932) 롤을 사용해서 드루팔 서비스 환경을 설정합니다. git, apache, mysql, php, php-mysql, composer, drush 등을 설치하고 설정합니다. 코드는 [깃헙 레포지토리](https://github.com/geerlingguy/ansible-role-drupal)에 있습니다. 제가 쓴 것도 있는데 옛날에 잘 됐는데 귀찮아서 방치하고 있습니다.

```
ansible-galaxy install geerlingguy.drupal
```


### 참고 문서
https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean
https://developers.digitalocean.com/#list-all-regions
https://gist.github.com/thisismitch/91815a582c27bd8aa44d

terraform digitalocean provider
http://www.terraform.io/docs/providers/do/index.html


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
[geerlingguy.drupal](https://galaxy.ansible.com/list#/roles/932) 롤을 사용해서 드루팔 서비스 환경을 설정합니다. git, apache, mysql, php, php-mysql, composer, drush 등을 설치하고 설정합니다. 코드는 [깃헙 레포지토리](https://github.com/geerlingguy/ansible-role-drupal)에 있습니다. [제가 쓴 것](https://github.com/mozodev/vagrant-ansible-drupal)도 있는데 다듬기 귀찮아서 방치하고 있습니다.

```
ansible-galaxy install geerlingguy.drupal

```

저 롤에 문제가 있어서 진행하다가 오류로 중단됩니다. 일단 아래 quick fix 적용하시면 진행됩니다.

```
geerlingguy.drush/tasks/main.yml 7줄 삭제 혹은 주석 처리
// update={{ drush_keep_updated }} git clone 안됨.

```

## Provisioning via ansible

테라폼으로 가상 서버가 만들어지고 나면 생성된 가상 서버의 아이피로 ansible이 사용할 hosts 파일을 만들고 바로 ansible이 가상 서버에 필요한 패키지를 설치하고 설정합니다.

우선 ```default.settings.yml```을 복사해서 ```settings.yml```을 만들고 아래처럼 도메인 등 원하는 설정으로 수정을 해야 합니다. 실행할 ansible playbook은 이 설정 파일로 서버를 설치하고 설정합니다.

```
settings.yml
# Your drupal site's domain name (e.g. 'example.com').
drupal_domain: "drupaltest.dev"
```

위 파일에서 drupaltest.dev을 테라폼 도메인으로 수정해야 드루팔에 도메인으로 접근할 수 있습니다. 혹시 바꾸지 않고 실행해버리면 아파치 가상호스트가 저 로컬 도메인을 듣고 있으므로 암만 때려봐야 접근이 안됩니다. 이럴때는 ssh로 붙어서 직접 수정해야 합니다.


```
ansible-playbook -i hosts playbook.yml
```

설정 값을 다 수정하고 나면 위 명령어로 서버 프로비저닝 시작. 문제 없이 완료되고 난 후 해당 도메인으로 접근하면 드루팔이 똿!

```
참고:

# 에러 중단 후 중간부터 다시 시작
ansible-playbook -i hosts playbook.yml --start-at="Clone Drush from GitHub."
```


## Configure terraform

```

// 필요한 환경 변수 등록.
// 디지털오션에 가서 토큰을 발급받아야 함.
export DO_PAT={YOUR_PERSONAL_ACCESS_TOKEN}

// 사용할 공개키 핑커프린트
export SSH_FINGERPRINT=$(ssh-keygen -lf ~/.ssh/id_rsa.pub | awk '{print $2}')

source .bash_profile // or .zshrc

// 계획 세우기
terraform plan \
  -var "do_token=${DO_PAT}" \
  -var "pub_key=$HOME/.ssh/id_rsa.pub" \
  -var "pvt_key=$HOME/.ssh/id_rsa" \
  -var "ssh_fingerprint=$SSH_FINGERPRINT" \
  -var "domain={YOUR_DOMAIN}"

// 계획 실행하기
terraform apply \
  -var "do_token=${DO_PAT}" \
  -var "pub_key=$HOME/.ssh/id_rsa.pub" \
  -var "pvt_key=$HOME/.ssh/id_rsa" \
  -var "ssh_fingerprint=$SSH_FINGERPRINT" \
  -var "domain={YOUR_DOMAIN}"

# 삭제하기

terraform plan -destroy -out=terraform.tfplan \
  -var "do_token=${DO_PAT}" \
  -var "pub_key=$HOME/.ssh/id_rsa.pub" \
  -var "pvt_key=$HOME/.ssh/id_rsa" \
  -var "ssh_fingerprint=$SSH_FINGERPRINT" \
  -var "domain={YOUR_DOMAIN}"

terraform apply terraform.tfplan

```

### 참고 문서
https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean
https://developers.digitalocean.com/#list-all-regions
https://gist.github.com/thisismitch/91815a582c27bd8aa44d

terraform digitalocean provider
http://www.terraform.io/docs/providers/do/index.html


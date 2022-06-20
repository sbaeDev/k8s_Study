# k8s_Study

- [강의 사이트](https://kubetm.github.io/k8s/)
- [인프런 강의](https://www.inflearn.com/course/%EC%BF%A0%EB%B2%84%EB%84%A4%ED%8B%B0%EC%8A%A4-%EA%B8%B0%EC%B4%88)
- 모든 사진, 자료는 해당 강의를 참조하였습니다.

## 목차

- [k8s_Study](#k8s_study)
  - [목차](#목차)
    - [설치 전 설정사항](#설치-전-설정사항)
    - [Docker 설치](#docker-설치)
    - [k8s 설치](#k8s-설치)
      - [master, work 설정](#master-work-설정)
      - [k8s 명령어 자동완성](#k8s-명령어-자동완성)
      - [kubeadm init 오류시 실행](#kubeadm-init-오류시-실행)
      - [token 만료 시 생성](#token-만료-시-생성)
    - [Study md file](#study-md-file)

---

### 설치 전 설정사항

| <span style="color:rgb(245, 109, 5)">NAME</span> | <span style="color:rgb(245, 109, 5)">IP</span> | <span style="color:rgb(245, 109, 5)">CORE.RAM</span> | <span style="color:rgb(245, 109, 5)">VOLUME</span> | <span style="color:rgb(245, 109, 5)">OS</span> |
|:-----:|:--:|:----:|:--:|:--:|
| <span style="color:rgb(5, 101, 245)">vm-sbae-master</span> | <span style="color:rgb(5, 101, 245)">192.168.77.71</span> | 8Core.4G | 30GB | ubuntu20.04 |
| <span style="color:rgb(5, 101, 245)">vm-sbae-node1</span> | <span style="color:rgb(5, 101, 245)">192.168.77.72</span> | 8Core.4G | 30GB | ubuntu20.04 |
| <span style="color:rgb(5, 101, 245)">vm-sbae-node2</span> | <span style="color:rgb(5, 101, 245)">192.168.77.73</span> | 8Core.4G | 30GB | ubuntu20.04 |
| <span style="color:rgb(5, 101, 245)">vm-sbae-node3</span> | <span style="color:rgb(5, 101, 245)">192.168.77.74</span> | 8Core.4G | 30GB | ubuntu20.04 |
| <span style="color:rgb(5, 101, 245)">▲ 최신 버전 설치</span> | <span style="color:rgb(245, 47, 49)">▼ 구 버전 설치</span> | 구 버전은 강의용 | |  |
| <span style="color:rgb(245, 47, 49)">vm-sbae-master_ver2</span> | <span style="color:rgb(245, 47, 49)">192.168.77.75</span> | 8Core.4G | 30GB | ubuntu20.04 |
| <span style="color:rgb(245, 47, 49)">vm-sbae-node1_ver2</span> | <span style="color:rgb(245, 47, 49)">192.168.77.76</span> | 8Core.4G | 30GB | ubuntu20.04 |
| <span style="color:rgb(245, 47, 49)">vm-sbae-node2_ver2</span> | <span style="color:rgb(245, 47, 49)">192.168.77.77</span> | 8Core.4G | 30GB | ubuntu20.04 |
| <span style="color:rgb(245, 47, 49)">vm-sbae-node3_ver2</span> | <span style="color:rgb(245, 47, 49)">192.168.77.78</span> | 8Core.4G | 30GB | ubuntu20.04 |

---

### Docker 설치

1. 패키지 설치

    ```bash
    sudo apt-get update
    sudo apt-get install -y openssh-server \\
    net-tools \\
    ca-certificates \\
    curl \\
    software-properties-common \\
    apt-transport-https \\
    gnupg \\
    lsb-release \\
    nftables
    ```

2. Docker의 Official GPG Key 를 등록.

    ```bash
    sudo curl -fsSL <https://download.docker.com/linux/ubuntu/gpg> | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    ```

3. stable repository 를 등록

    ```bash
    sudo echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] <https://download.docker.com/linux/ubuntu> $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    ```

4. Docker Engine 설치

    ```bash
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    #sudo apt-get install -y docker-ce=특정버전 docker-ce-cli=특정버전 containerd.io=특정버전
    sudo systemctl enable docker
    ```

5. Docker 설치 확인

    ```bash
    docker --version
    sudo docker run hello-world
    ```

6. Docker compose 설치

    ```bash
    sudo curl -L "<https://github.com/docker/compose/releases/download/1.29.2/docker-compose>-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version
    ```

7. sudo없이 Docker 명령어 실행

    ```bash
    sudo usermod -aG docker {사용자명}
    ```

---

### k8s 설치

1. 방화벽 종료

    ```bash
    sudo systemctl stop ufw
    sudo systemctl disable ufw
    ```

2. 필수 패키지 설치

    ```bash
    sudo apt update
    sudo apt-get update
    sudo apt-get install -y openssh-server \\
    net-tools \\
    ca-certificates \\
    curl \\
    software-properties-common \\
    apt-transport-https \\
    gnupg \\
    lsb-release \\
    nftables
    ```

3. swap 메모리 끄기

    ```bash
    sudo swapoff -a
    sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
    ```

4. k8s 설치

    ```bash
    sudo apt -y full-upgrade

    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg <https://packages.cloud.google.com/apt/doc/apt-key.gpg>


    sudo echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] <https://apt.kubernetes.io/> kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl
    # sudo apt-get install -y kubelet=특정버전 kubeadm=특정버전 kubectl=특정버전

    sudo cat <<EOF | sudo tee /etc/docker/daemon.json
    { "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts":
    { "max-size": "100m" },
    "storage-driver": "overlay2"
    }
    EOF

    sudo systemctl daemon-reload
    sudo systemctl restart docker

    (root) cat <<EOF | tee /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    EOF

    sudo systemctl daemon-reload
    sudo systemctl restart kubelet
    sudo systemctl enable kubelet
    # 각각의 버전 확인
    ```

#### master, work 설정

1. __master에서 실행__
    - sudo kubeadm init
    - 토큰값 저장해두기
      - ex) kubeadm join __IP:PORT__ --token __Token값__ --discovery-token-ca-cert-hash sha256:__Hash__
    - mkdir -p $HOME/.kube
    - sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    - sudo chown \$(id -u):\$(id -g) $HOME/.kube/config
    - kubectl apply -f "<https://cloud.weave.works/k8s/net?k8s-version=$(kubectl> version | base64 | tr -d '\n')"
2. __node에서 실행__
    - kubeadm join __IP:PORT__ --token __Token값__ --discovery-token-ca-cert-hash sha256:__Hash__
    - (master) kubectl get nodes

#### k8s 명령어 자동완성

```bash
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc
source <(kubeadm completion bash)
echo "source <(kubeadm completion bash)" >> ~/.bashrc
```

#### kubeadm init 오류시 실행

1. rm /etc/containerd/config.toml
2. sudo systemctl restart containerd

#### token 만료 시 생성

1. kubeadm token list
2. kubeadm token create
3. openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
4. kubeadm join __IP:PORT__ --token __Token값__ --discovery-token-ca-cert-hash sha256:__Hash__

### Study md file

- __[기초편](%EA%B8%B0%EC%B4%88%ED%8E%B8.md)__
- __[중급편](%EC%A4%91%EA%B8%89%ED%8E%B8.md)__
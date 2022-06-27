# CKA study

- [CKA study](#cka-study)
  - [CKA dump 문제 정리](#cka-dump-문제-정리)
    - [파드 확장(scale)](#파드-확장scale)
    - [describe 미사용하고 파드 이미지 버전 보기](#describe-미사용하고-파드-이미지-버전-보기)
    - [요구사항에 따라 yaml 파일 만들기](#요구사항에-따라-yaml-파일-만들기)
    - [환경 변수가 var1=value1로 만들고 확인](#환경-변수가-var1value1로-만들고-확인)
    - [한 줄로 만들기](#한-줄로-만들기)
    - [pv를 capacity로 정렬하여 제시되는 경로로 저장해라](#pv를-capacity로-정렬하여-제시되는-경로로-저장해라)
    - [제시된 pod에 service 연결하기](#제시된-pod에-service-연결하기)

## CKA dump 문제 정리

### 파드 확장(scale)

- `scale deploy 이름 --replicas=늘릴 숫자`

### describe 미사용하고 파드 이미지 버전 보기

- `kubectl get pod 파드명 jsonpath='{.spec.containers[].image}("\n")'`

### 요구사항에 따라 yaml 파일 만들기

- pod, deployment 등등

### 환경 변수가 var1=value1로 만들고 확인

- `kubectl run nginx --image=nginx --restart=Never --env=var1=value1`
- `kubectl descrie pod nginx | grep value1`

### 한 줄로 만들기

- `kubectl run nginx --image=nginx --restart=Never --labels=env=test --namespace=engunearing --dry-run -o yaml > file.txt`
- `--dry-run=client -o yaml은 오브젝트를 생성하지 않고 작업만하고 yaml파일로 출력하고 싶을 때 사용하고 추후 create, apply로 생성하면 된다.`

### pv를 capacity로 정렬하여 제시되는 경로로 저장해라

- `kubectl get pv --sort-by=.spec.capacity.storage > 경로`

### 제시된 pod에 service 연결하기

- `kubectl expose pod 파드명 --name=cluster-service --type=ClusterIP --port=8080`

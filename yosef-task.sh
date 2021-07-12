#!/bin/sh

# String formatters
if [ -t 1 ]; then
  tty_escape() { printf "\033[%sm" "$1"; }
else
  tty_escape() { :; }
fi

tty_mkbold() { tty_escape "1;$1"; }
tty_underline="$(tty_escape "4;39")"
tty_blue="$(tty_mkbold 34)"
tty_red="$(tty_mkbold 31)"
tty_green="$(tty_mkbold 32)"
tty_bold="$(tty_mkbold 39)"
tty_reset="$(tty_escape 0)"


msg() {
  printf "${tty_blue}==>${tty_bold} %s${tty_reset}\n" "$1"
}

warn() {
  printf "${tty_red}Warning${tty_reset}: %s\n" "$1"
}

success() {
  printf "${tty_green}%s${tty_reset} \n" "$1"
}


abort() {
  printf "${tty_red}%s\n${tty_reset}" "$1"
  exit 1
}

#-------
VM_ENVIROMENT=true
K8S_INSTALL=false
K8S_DEPLOY=false
K8S_UPDATE=false

# check if user passed all 3 arguments 
if [ "$#" -ne 3 ]; then
  abort "you must passed to script 3 arguments 1: k8s_install 2: k8s_deploy 3: k8s_update"
fi
for arg in "$@"; do
    case $arg in
        k8s_install) K8S_INSTALL=true;;
        k8s_deploy) K8S_DEPLOY=true;;
        k8s_update) K8S_UPDATE=true;;
    esac
done

## function to install docker 
docker_install(){
	msg "checking if docker allready installed"
	docker -v > /dev/null 2>&1  
    if [ $? -ne 0 ]; then 
	msg "install docker"
	sudo apt update
	sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
	sudo apt update
	apt-cache policy docker-ce
	sudo apt install docker-ce -y
	sudo systemctl status docker
	sudo usermod -aG docker ${USER} 
   else 
	msg "docker allready installed" 
    fi 
}
## function to install and configure kubectl 
kubectl_install(){
        msg "checking if kubectl allready installed"
        kubectl version --client > /dev/null 2>&1
    if [ $? -ne 0 ]; then 
        msg "install kubectl"
	#sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	#sudo curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
	#echo " kubectl.sha256 kubectl" | sha256sum --check
	#sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
	sudo apt-get update
	sudo apt-get install -y apt-transport-https ca-certaificates curl
	sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
	echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
	sudo apt-get update
	sudo apt-get install -y kubectl
   else 
        msg "kubectl allready installed" 
    fi 
}

## function  to install and configure minikube
minikube_install(){
        msg "checking if minikube allready running"
        minikube status > /dev/null 2>&1
    if [ $? -ne 0 ]; then 
        msg "install and deploy minikube"
	sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	sudo install minikube-linux-amd64 /usr/local/bin/minikube
	sudo chown -R $USER $HOME/.minikube
	sudo chmod -R u+wrx $HOME/.minikube
	minikube start --cpus=4 --memory 4096 --disk-size 32g --driver=docker
   else 
        msg "minikube up and running" 
    fi 
}


## function to install skaffold
skaffold_install(){
   msg "checking if skaffold is allready installed"
   skaffold version > /dev/null 2>&1
   if [ $? -ne 0 ]; then
      msg "install skaffold"
      sudo curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 
      sudo install skaffold /usr/local/bin/
  else 
      msg "skaffold allready installed" 
  fi 
}

microservices_deployment() {
   git clone https://github.com/GoogleCloudPlatform/microservices-demo.git
   cd microservices-demo/
   sudo skaffold run
   sleep 20  
   # minikube service frontend-external
}

microservices_update(){
    msg "updating frontend-external service type to NodePort "
    kubectl patch svc frontend-external --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"}]'
    sleep 20 
    FRONTEND_EXTERNAL_URL=$(minikube service --url frontend-external) 
    msg "url Address for browsing frontend_external service $FRONTEND_EXTERNAL_URL"
    #minikube service frontend-external
}

nginx_revers_proxy(){
msg "revers proxy from localhost ip to the up"
cd ..
FRONTEND_EXTERNAL_URL=$(minikube service --url frontend-external)
HOST_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
touch default.conf
$(cat <<EOF > default.conf
server {
    listen       80;
    server_name $HOST_IP;
    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;
    location / {
         proxy_pass $FRONTEND_EXTERNAL_URL;
    }
}
EOF
)
   docker run --network=host --name nginx -v $(pwd)/default.conf:/etc/nginx/conf.d/default.conf -p 80:80 -d nginx:alpine
   msg "It is now possible to browse the site via the machine's IP (port 80 used by nginx) ..  your machine IP= $HOST_IP"
}

if ( $K8S_INSTALL ); then 
   docker_install
   kubectl_install
   minikube_install
fi


if ( $K8S_DEPLOY ); then
   skaffold_install
   microservices_deployment
fi

if ( $K8S_UPDATE ); then 
   microservices_update
fi

if ( $VM_ENVIROMENT ); then 
   nginx_revers_proxy
fi 

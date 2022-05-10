#!/bin/sh
VERSION=v16.15.0
DISTRO=linux-x64
wget https://nodejs.org/dist/$VERSION/node-$VERSION-$DISTRO.tar.gz
sudo mkdir -p /usr/local/lib/nodejs
sudo tar -xvf node-$VERSION-$DISTRO.tar.gz -C /usr/local/lib/nodejs
echo "export PATH=/usr/local/lib/nodejs/node-$VERSION-$DISTRO"'/bin:$PATH' >> ~/.profile
. ~/.profile

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs)-prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/dotnetdev.list'
sudo apt-get update
sudo apt-get install azure-functions-core-tools-4

func init MyFunctionProj --worker-runtime node --language javascript

cd MyFunctionProj
func new --template "Http Trigger" --name MyHttpTrigger

func start &
echo "************************"
sleep 5s
curl http://localhost:7071/api/MyHttpTrigger?name=FunctionTriggered

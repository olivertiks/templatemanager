# Template Manager

## Introduction

Template Manager is a lightweight application (API + Dashboard) which helps to create, manage and maintain I-Tee virtual learning spaces (custom Virtualbox virtual machines) without hassle. This solution makes it possible to keep multiple lab templates up-to-date within few mouseclicks, without any need to enter the container one-by-one to make changes.

Please keep in mind that this application is still under heavy development and should not be used as of now.
## Abilities

Template Manager has the following abilities to manipulate with VBox containers:

* Manage state of VM
* Create/Delete snapshots of VMs
* Modify NICs and DMIDECODE properties of VM
* Modify RDP access credentials
* Clone machines
* Automatic SSH key deployment
* Guest additions updating
* Custom script deployment

## System dependencies
Template Manager is developed and tested in headless Ubuntu 16.04 environment. It has few dependencies that must be installed beforehand, we will cover them at "Installation" section later:

* Virtualbox 5.x installation
* Docker 
* MongoDB
* NodeJS
* Nginx

## Installation
This section walks you through the process of actually setting Template Manager up and running. Please keep in mind that tutorial was written with Ubuntu 16.04 LTS as a template, so few steps may vary in case you're using another distribution.

### Virtualbox 5.x install
If you have I-Tee deployed, chances are that Virtualbox 5.x is already installed and configured aswell. In that case you can skip this step and proceed to XXX, otherwise please follow the Virtualbox 5.x setup process in I-Tee's documentation, which is described here: https://github.com/magavdraakon/i-tee#installing-virtualbox-headless

### Node.JS install
Template Manager's API component is written in Node.JS, which means we have to obtain it, too. If you are already familiar with NodeJS and have atleast v8.4.0 installed, you may skip this step. We're going to install NodeJS via NVM to keep maintainability of our project as convenient as possible.

Let's download nvm and install it somewhere global, for example:
```
sudo -i
apt-get install git
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | NVM_DIR=/usr/local/nvm bash
```
Now, close and reopen terminal to start using nvm. If you are lazy:
```
export NVM_DIR="/usr/local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
```
to bypass terminal reopening.
Run ``` command -v nvm ``` to test nvm installation. If it returns "nvm", everything turned well. Otherwise please refer to nvm's documentation.

To install Node.JS via nvm, run command ```nvm install v8.4.0``` . If ```which node``` returns path in /usr/local, then NodeJS is installed correctly. 

### Installation of I-tee-Virtualbox API

I-tee-Virtualbox API is the component which connects Dashboard to actual Virtualbox services. API endpoints are described and can be found from here: https://github.com/K43GFX/i-tee-virtualbox

Let's start off by cloning I-Tee-Virtualbox instance with
```
sudo -i
cd /opt
git clone https://github.com/K43GFX/i-tee-virtualbox
```
Great. Now we need to install required node modules for our application, which can be done with:
```
cd /opt/i-tee-virtualbox
npm -g install
npm -g install babel-cli
```
NodeJS with all needed dependencies is now installed.

I-tee-virtualbox has a default configuration file named ```config_sample.json``` at it's root, which consists default port for API service. By default it's 3000, if you wish to, you can change it. After you're done, rename it to ```config.json```.

Now, let's prepare our systemctl service file. Open i-tee-virtualbox.service with your preferred text editor, eg
```
nano /opt/i-tee-virtualbox/i-tee-virtualbox.service
```
and verify that everything is pointing where it should be. Now, let's move it to correct place, ```/etc/systemd/system``` by ```mv /opt/i-tee-virtualbox/i-tee-virtualbox.service /etc/systemd/system```

I-Tee-Virtualbox API is now installed. Start the application with ```systemctl start i-tee-virtualbox```. To check the status: ```systemctl status i-tee-virtualbox```. If services started successfully, you may want to add it to autostart, too, with ```systemctl enable i-tee-virtualbox```

### Installing Docker
Template Manager's dashboard is dockerized, which means that we need to have Docker too to deploy it. If you have Docker installed correctly, you may skip this step.

First, let's add Docker's GPG key
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

```
Now, we need to add Docker's repo to our apt sources
```
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```
... to actually install docker via:
```
sudo apt-get update
sudo apt-get install -y docker-ce
```
Docker should be installed as of now. You can check it with ```sudo systemctl status docker```

### Installing MongoDB
Template Manager keeps it's initial configuration, RDP connection data, Snapshot names ... basically everything in MongoDB database. For the moment, MongoDB should be installed in host machine.

Let's get started by importing MongoDB's public key:
```
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
```
... and then adding their repository to our APT list:
```
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
```
Now, we have to install MongoDB with:
```
sudo apt-get update
sudo apt-get install -y mongodb-org
```
Create unit file to manage MongoDB service:
```
sudo nano /etc/systemd/system/mongodb.s[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.targetervice
```
... and paste the following bits into the file:
```
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target
```
Almost done. Let's launch MongoDB with ```sudo systemctl start mongodb```. Did it launched successfully? You can check the status of the service with ```sudo systemctl status mongodb```.

MongoDB is now installed.

### Installing Dashboard
In a nutshell, Template Manager's dashboard is a front-end for our API service. This component holds the magic which translates API calls into something visual that an end-user can understand and interact with. Dashboard is written in RoR and dockerized.

To install Dashboard, create and cd to the directory:
```
mkdir -p /opt/dashboard
cd /opt/dashboard
```
```
docker pull karlerikounapuu/tplmgr
```
TODO 
### Configuring Nginx & Firewall
TODO

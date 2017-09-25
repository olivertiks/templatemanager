# Template Manager

## Introduction

Template Manager is a lightweight application (API + Dashboard) which helps to create, manage and maintain I-Tee virtual learning spaces (custom Virtualbox virtual machines) without hassle. This solution makes it possible to keep multiple lab templates up-to-date within few mouseclicks, without any need to enter the container one-by-one to make changes.

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
* Ruby 5.x

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

I-tee-Virtualbox API is the component which connects Dashboard to actual Virtualbox services.

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

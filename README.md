# Windows now!

Setup a Windows developer workstation in corporate environment - ASAP.

## Scenario

* Corporate laptop issued, OS baseline configured already and managed externally

## Philosophy
* WSL 2 + Ubuntu FTW!
* Most stuff runs inside WSL, set it as the default shell and install utils such as terraform, gcloud, awscli inside WSL
* Some things have to run on the host in powershell - like vagrant <<<--- fixme!

## Todo
* Vagrant https://developer.hashicorp.com/vagrant/docs/other/wsl

## Lets do it

### Manual setup

* All scripts run as `administrator` in powershell
* Remember the `.\` is backwards on Windows

#### Keyboard (Thinkpad)

BIOS/UEFI is locked. To swap FN and CTRL login to Windows, press F11 to access Lenovo Keyboard Manager. There is a switch if you scroll down to swap these two buttons

#### CPU Usage in taskbar

This sucks!
* Open Task Manager
* Settings: "hide when minimised"
* Drag and drop from expanded system tray onto taskbar
* Never close the taskbar window or it will remove the system tray icon :/

#### Install basic dev tools

1. [Install chocolatey](https://chocolatey.org/install)
2. `choco install firefox vscode git`
3. Create Gihub classic Personal Access Token with repo and workflow permission, then clone this repo somewhere

#### Execution policy to allow scripts to run

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass
```

#### Run the script

```powershell
cd \this\repo
.\setmeup.ps1
```

Reboot as needed


## App Setup

After install, some setups to do

### Git

Stop git from munting line endings in all files:

```shell
git config --global core.autocrlf false
```

### Docker Desktop
* Login with your personal Docker ID, ask IT to add your Docker ID to the corporate account
* Test: `docker run hello-world`
* [See notes on WSL Integration](https://docs.docker.com/desktop/wsl/)
* `wsl --set-default Ubuntu`

### WSL/Windows Terminal
In the above steps, WSL and Ubuntu were installed. After reboot, setup Windows Terminal to boot Ubuntu by defualt:
1. Launch terminal
2. Arrow down menu
3. Settings
4. Default Profile -> Ubuntu
5. Save and reopen. Should now be in Ubuntu shell

Now you can setup Ubuntu. Some apps like `az` run "magically" from windows inside WSL but most dont, so run the next script inside Ubuntu - you can launch terminal from inside VS code editing this project and you will be in the right place:

```shell
sudo ./setup_system.sh
./setup_user.sh
```

### VS code

Ubuntu terminal as default:
1. File->Preferences->Settings
2. Feature->Terminal
3. Terminal: Explorer Kind -> external
4. Terminal › External: Windows Exec -> wt
5. Terminal › Integrated › Default Profile: Windows > Ubuntu (WSL)

Close, restart code. Should now have Ubuntu terminal on click

### Intellij (new UI)

* Settings -> Tools -> Terminal -> Shell path -> `wsl --distribution Ubuntu`

## Notes and gotchas/Tips and Tricks

* Powershell 5 remains installed after installing 7x and cannot be removed without breaking system
* Always launch powershell via Windows Terminal on start menu - if you lauch the old powershell icon you will get powershell 5 no matter what you do
* `/bin/bash^M: bad interpreter` means something has randomly converted your files from git to windows line endings. Probably VS code
* The command 'docker' could not be found in this WSL 2 distro. [purge docker data:](https://stackoverflow.com/a/77106268/3441106)
* Share maven/gradle cache with Windows: `ln -s /mnt/c/Users/GeoffWilliams/.m2 ~/.m2` - this must be done after running maven on windows or the symlink will be nuked by maven (non existing target)
* WSL filesystem mount is so slow! https://github.com/microsoft/WSL/issues/9430

## Accessing Ubuntu services from Windows 

* You have a service bound to a port on WSL2/Ubuntu
* You want to access this port from Windows - eg in web browser

[Follow these instructions](https://github.com/microsoft/WSL/issues/4150#issuecomment-504209723)

**but use the script in this repo as the execution target**

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
* Apply all Windows updates first
* If something doesnt work try rebooting

#### Keyboard (Thinkpad)

BIOS/UEFI is locked. To swap FN and CTRL login to Windows, press F11 to access Lenovo Keyboard Manager. There is a switch if you scroll down to swap these two buttons

#### Install basic dev tools

1. [Install chocolatey](https://chocolatey.org/install#individual)
    * Choose `individual`
    * Copy-paste the powershell codes into an `Adminstrator` powershell terminal
2. `choco install firefox vscode git`

#### Clone this repo

Stop git breaking line endings:

```shell
git config --global core.autocrlf false
```

Open new powershell terminal as user and clone the repo somewhere:
```shell
git clone https://github.com/GeoffWilliams/windowsnow.git
```

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

### CPU Usage

* Unfortunately not in taskbar (xmeters does this but doesnt work with Windows 11 - author contacted)
* Provided through chocolatey package: `8gadgets`. Start `gadgets` and you get a separate giant panel which you can add a monitor to
* Start `8gadgets`, choose run at startup and add the widgets you want to monitor system


### Docker Desktop
* Start Docker Desktop, accept the licence
* Login with your personal Docker ID, ask IT to add your Docker ID to the corporate account
* resources -> WSL integration -> enable ubuntu integration
* Test (check powershell terminal _and_ ubuntu - use `windows terminal`): `docker run hello-world`
* [See notes on WSL Integration](https://docs.docker.com/desktop/wsl/)
* `wsl --set-default Ubuntu`

### WSL/Windows Terminal
In the above steps, WSL and Ubuntu were installed. After reboot, setup Windows Terminal to boot Ubuntu by defualt:
1. Launch terminal
2. Arrow down menu
3. Settings
4. Default Profile -> Ubuntu
5. Save and reopen. Should now be in Ubuntu shell

#### Setup Ubuntu system
Now you can setup Ubuntu. Some apps like `az` run "magically" from windows inside WSL but most dont, so run the next script inside Ubuntu - you can launch terminal from inside VS code editing this project and you will be in the right place otherwise your Windows system files are at `/mnt/c`:

```shell
sudo ./setup_system.sh
```

You will need to reboot WSL2, see notes at bottom of this file.

#### Setup Ubuntu user apps/configs

Install user apps and settings, run this script as yourself:

```shell
./setup_user.sh
```

The script is idempotent so run as many times as you like. You will need to run the script multiple times and logout/login to update your settings as new apps are installed, mainly for python. The script tells you when this is needed.

Fixes welcome - I was in a hurry so gave up.

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



## Post-setup DIY

### Maven/gradle
Keep the maven/gradle cache on Windows (adjust as needed):

```shell
mkdir -p /mnt/c/Users/GeoffWilliams/.m2
ln -s /mnt/c/Users/GeoffWilliams/.m2 ~/.m2
```

This must be done before running maven on WSL2 or the symlink will be nuked by maven (non existing target)

### SSH and kubectl

Keep SSH keys and config on Windows:

```shell
mkdir -p /mnt/c/Users/GeoffWilliams/.ssh
chmod 0700 /mnt/c/Users/GeoffWilliams/.ssh
ln -s /mnt/c/Users/GeoffWilliams/.ssh ~/.ssh

# optional
# ...make keys
#ssh-keygen ...
# ...copy keys
#ssh-copy-id ...
```

Same trick applies for Kubernetes (~/kube) and any other files you want to keep on Windows

* This requires the `metadata` mount option (set in `setup_system.sh` - you may need to reboot WSL2)
* `metadata` option lets you apply the correct permissions to the private key (`0600`), with lax permissions SSH will refuse to work

## Accessing Ubuntu services from Windows

* You have a service bound to a port on WSL2/Ubuntu
* You want to access this port from Windows - eg in web browser

[Follow these instructions](https://github.com/microsoft/WSL/issues/4150#issuecomment-504209723)

**but use the script in this repo as the execution target: wsl2_port_forward.ps1**


## Notes and gotchas/Tips and Tricks

### How to reboot WSL2

Run in powershell:

```powershell
wsl --shutdown ; wsl -d ubuntu
```

### Powershell
* Powershell 5 remains installed after installing 7x and cannot be removed without breaking system
* Always launch powershell via Windows Terminal on start menu - if you launch the old powershell icon you will get powershell 5 no matter what you do

### Script errors
`/bin/bash^M: bad interpreter` means something has randomly converted your files from git to windows line endings. Probably `git`, see setup instructions above

### Docker errors

* `The command docker' could not be found in this WSL 2 distro`.
    * Restart Docker Desktop
    * [purge docker data:](https://stackoverflow.com/a/77106268/3441106)

### WSL2

* WSL filesystem mount is so slow! https://github.com/microsoft/WSL/issues/9430

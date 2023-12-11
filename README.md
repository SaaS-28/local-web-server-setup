# Local web server setup

Bash script that **downloads**, **installs** and **configures** automatically all the packages needed to run a **web server** on the **local network**.

The script has been tested and works perfectly using [M4rga's debian12 preseed](https://github.com/M4rga/debian12-server-setup) and uses **HTTP protocol**, so it is a real basic setup for testing or just personal purpose.

## Before running the script

With the debian 12 virtual machine <u>closed</u> , right click on the machine &rarr; settings &rarr; network and **change** the entry `"Connected to"` from **NAT** to **Board with bridge**. - *if you are not using a virtual machine you do not need to do this step.*

> **NOTE**: This won't allow you to connect with SSH anymore.

After starting the VM again, type 

```bash
ip a
``` 

so you can see the **ip** and **gateway** your machine is using.

Now type

```bash
sudo nano main.sh
```

and edit the file where the ***!** mark can be seen <u>(follow the instructions written on the file)</u>. 

> **NOTE**: I advise you not to change anything except the one highlighted by ***!**.

## How to run

With your file on your **home directory**(Should be `/home/mainuser`), type

```bash
sudo ./main.sh
```

and **wait** until the **entire process has finished**.

Once you have done this, your virtual machine will **work as a web server**.

## Final steps

You can simply **copy** your *html*, *css*, *js* and *php* files in `/var/www/html/name-of-your-site`.

You can see the **index page of your web server** by typing `your-ip/name-of-your-site`.

e.g. `192.168.x.x/site`

If you want to access your site with the **name** you **assigned prievously**, you have to modify the **hosts** file.

## Modify hosts file

Open with notepad the **file hosts** wich you can find at `C:\Windows\System32\drivers\etc` if you are on **Windows**. If you are on **Linux/MacOs** type the following command in the terminal:

```bash
sudo nano /etc/hosts
```

Now write in the bottom of the file the **ip** and the **name** you assigned at the web server seprated by **TAB** key.

e.g. `192.168.x.x   site`.

Make sure to **save the file** and **restart your pc**.

### installations

    sudo (admin)
    apt (advanced packaging tool)
    sudo apt update && sudo apt upgrade
    sudo apt-get update | sudo apt-get upgrade (update system)
    sudo apt install mysql-server (install a package mysql-server ,finger etc)
    man finger (manual for package)
    whatis finger (short description of package)
    whereis finger (location of package)
    wget link  - download stuff from network
    curl link > file  - download stuff and put it in file

### moving

    pwd (print working directory)
    cd / (cd to root)
    cd .. (cd up)
    cd /Home/michu/Desktop (absolute directory from root /)
    cd ~ (cd to home)


### directories

    mkdir - Make Directory
    ls (list directories)
    ls -a
    ls -l  - list directories with more info
    ls -al  - with hidden stuff
    mkdir dir1 dir2  - make directories (folders)
    mkdir -p dir3/dir4  - make them inside them
    -p option/switch  - additional functions of commands


### files

    echo "hi mom"
    echo "i like pizza" > pizza.txt
    touch tmp.txt (create a file)
    nano tmp.txt  (edit/enter a file)
    cat tmp.txt  (read a file)
    vi tmp.txt (vim)

    shread
    cp tmp.txt (copy)
    mv tmp.txt /Home/Michu/Desktop/Downloads
    rm tmp.txt (remove)
    rmdir myDirectory (remove a directory)
    rm -r myDirectory  (remove with files recursive)
    ln -s tmp.txt link_to_tmp (?)
    zip tmp.zip tmp.txt (unzip file?)
    sudo dpkg -i (Default Package Manager install)

### MySQL

    sudo systemctl status mysql (system control)
    sudo systemctl start mysqld
    sudo systemctl stop mysqld
    sudo mysql_secure_installation
    sudo mysql
    sudo mysql -u root  (login as root)
    
    create user 'skubi_chrupki'@'localhost' identified by 'password';
    grant all privileges on *.* TO 'skubi_chrupki'@'localhost' with grant option;
    flush privileges (save the privileges)
    mysql -u skubichrupki -p
    
    show databases;
    use tda;
    show tables;

### user

    whoami
    sudo useradd skubi (add new user)
    sudo adduser skubi (add user with parameters like password)
    su skubi (switch user)
    exit (back to default user) 
    sudo passwd skubi (change password of user skubi)
    passwd (change current user password)
    finger skubi (check info on user)

### other

    tmp_?.txt -> any single character [_ in sql]
    tmp_* -> zero or more characters [% in sql]

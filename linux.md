### installations (mysql)

    sudo - super user do
    apt - advanced packaging tool
    sudo apt update && sudo apt upgrade
    sudo apt install mysql-server
    systemctl status mysql (system control)
    sudo mysql_secure_installation
    sudo mysql

    sudo apt install mysql-server  - install a package (mysql-server ,finger etc)
    systemctl status mysql (system control)
    sudo mysql_secure_installation
    sudo mysqls
    man finger (manual for finger etc)
    whatis finger  - short description of package
    whereis finger  - location of package
    wget <link>  - download stuff from network
    curl link > file  - download stuff and put it in file
    >>>>>>> d4302c927086fa0066f20cb2b4c301cbd3d262e2

### moving

    ~pwd  - Print Working Directory
    cd /  - start from Root Directory
    cd ..  - go up
    cd  - go back to home/username
    cd /Home/michu/Desktop -> absolute directory from root /
    cd ~  - start from Home directory


### creating folders and files

    mkdir - Make Directory
    ls  - list directories
    ls -l  - list directories with more info
    ls -al  - with hidden stuff
    mkdir dir1 dir2  - make directories (folders)
    mkdir -p dir3/dir4  - make them inside them
    -p option/switch  - additional functions of commands
    touch tmp.txt - create a file


### in files

    nano tmp.txt  - edit/enter a file
    cat tmp.txt  - read a file

    =======
    shread
    cp tmp.txt - copy a file
    mv tmp.txt /Home/Michu/Desktop/Downloads
    sudo dpkg -i - Default Package Manager -Install
    rm tmp.txt  - remove a file
    rmdir myDirectory  - remove a directory
    rm -r myDirectory  - remove with files
    =======
    rm -r myDirectory  - remove with files (recursive)
    ln -s tmp.txt link_to_tmp
    zip tmp.zip tmp.txt


### MySQL

    sudo mysql -u root  - login as root
    create user michu in mysql
    CREATE USER 'michu'@'localhost' IDENTIFIED BY 'your_password';
    grant all privileges to michu
    GRANT ALL PRIVILEGES ON *.* TO 'michu'@'localhost' WITH GRANT OPTION;
    FLUSH PRIVILEGES -- commit on privileges (reload the grant tables)
    ###-
    mysql -u michu -p
    show databases;


### other

    echo "hi mom"
    echo "i like pizza" > pizza.txt
    tmp_?.txt -> any single character [_ in sql]
    tmp_* -> zero or more characters [% in sql]


### user

    sudo useradd skubi  - add new user
    sudo adduser skubi -> parameters like password
    su skubi  - switch user
    exit  - back to def user 
    sudo passwd skubi  - change skubi password
    passwd  - change my password
    finger skubi

### terminal ###

    pwd - print working directory
    ls - list
    ls -a - list all (hidden files)
    cd - change directory
    nano finance.csv - modify content
        save: ctrl+o
        exit: ctrl+x
    echo - create/edit file
    echo "learn git" > todo.txt (>> to add content to existing file)

### general git ###

    git --version
    git status
    git add .
    git commit -m "changes"

### update ###

    git clone https://github.com/skubichrupki/SQL
    git fetch origin
    git pull origin
    svn checkout repository_URL [local_directory]
    svn update

### checks ###

    git status | svn status
    git diff CHEATSHEET.sql / git diff
    git diff --cached -> staged but not commited
    q -> exit git diff
    svn diff CHEATSHEET.sql / svn diff

### stage ###

    git add . 
    git restore --staged CHEATSHEET.sql
    svn add *
    svn revert CHEATSHEET.sql

### commit ###

    git commit -m "commit message"
    git push origin main
    svn commit -m "commit message"

### branch ###

    git branch

### restoring ###

    git restore main.py
    git restore --staged main.env -> like unchecking the checkbox in desktop
    svn revert CHEATSHEET.sql

### delete commits ###

    git reset ---soft HEAD~1
    git push origin +main --force

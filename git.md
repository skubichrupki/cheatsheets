### terminal ###

    pwd
    ls
    ls -a (list all hidden files)
    ls -l (list as a list)
    cd (change directory)
    nano finance.csv (modify content)
        save: ctrl+o
        exit: ctrl+x
    echo (create/edit file)

### git ###

    git --version
    git status

    git clone https://github.com/skubichrupki/SQL
    git fetch origin
    git pull origin

    git status
    git diff CHEATSHEET.sql / git diff (compare unstaged file with last commited version)
    git diff --cached (staged but not commited)
    git diff -r HEAD CHEATSHEET.sql (compare staged file with last commited version)
    q (exit git diff)

    git add .
    git add cheatsheet.sql

    git restore main.py
    git restore --staged CHEATSHEET.sql

    git branch
    git branch main

    git commit -m "commit message"
    git push origin main

### delete commits ###

    git reset ---soft HEAD~1
    git push origin +main --force

gitbook build . ../tmp_mysite

function publish_to()
{
    repo_name=$1
    cd ../${repo_name}
    rm -rf `ls |grep -v .git`
    cp -r ../tmp_mysite/* ../${repo_name}
    cd ../${repo_name}
    git add -A
    git commit -a -m 'update from gitbook'
    git push
}

# publish_to mysite
publish_to ahangchen.github.io

rm -rf ../tmp_mysite
# ssh cwh@cweihang.io "cd mysite;git pull"

gitbook build . ../tmp_mysite
cd ../mysite
rm -rf `ls |grep -v .git`
cp -r ../tmp_mysite/* ../mysite
rm -rf ../tmp_mysite
cd ../mysite
git add -A
git commit -a -m 'update from gitbook'
git push origin master
# ssh cwh@cweihang.io "cd mysite;git pull"

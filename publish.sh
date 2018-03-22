gitbook build . ../tmp_mysite
cd ../mysite
rm -rf `ls |grep -v .git`
cd ../ahangchen.github.io
rm -rf `ls |grep -v .git`
cp -r ../tmp_mysite/* ../mysite
cp -r ../tmp_mysite/* ../ahangchen.github.io
rm -rf ../tmp_mysite
cd ../mysite
git add -A
git commit -a -m 'update from gitbook'
git push origin master
cd ../ahangchen.github.io
git add -A
git commit -a -m 'update from gitbook'
git push origin master
ssh wemeet@wemeet.tech "cd mysite;git pull"

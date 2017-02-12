gitbook build . ../mysite
cp -r ../mysite/* ../ahangchen.github.io
cd ../mysite
git add -A
git commit -a -m 'update from gitbook'
git push origin master
cd ../ahangchen.github.io
git add -A
git commit -a -m 'update from gitbook'
git push origin master

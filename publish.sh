gitbook build . ../tmp_mysite
rm -rf !(../ahangchen.github.io/.git/*) ../ahangchen.github.io
rm -rf !(../mysite/.git/*) ../mysite
cp -r ../tmp_mysite ../mysite
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

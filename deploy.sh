hugo -D
git add .
echo "please input the commit_log:"
read commit_log
git commit -m "$commit_log"
git push
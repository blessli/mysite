hugo -D
git add .
echo "Enter the commit_log:"
read commit_log
git commit -m "$commit_log"
git push
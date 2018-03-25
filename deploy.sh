rsync -r dist/ docs/
rsync build/contracts/IdeaStarter.json docs/
git add .
git commit -m "deploy frontend"
git push

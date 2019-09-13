echo $PWD

SNAPSHOT_VERSION=`grep "version=" < gradle.properties | sed 's/version=//'`
VERSION=`echo $SNAPSHOT_VERSION | sed 's/-SNAPSHOT//'`

PRERELEASE_BRANCH="release/rc-$VERSION"

git checkout -b $PRERELEASE_BRANCH release/stg
git pull origin develop --no-commit

CHANGED=`git status -s -uno | sed 's/[A-Z]  //'`

if [[ "$CHANGED" == "" ]]; then
  echo "no changes"
  git checkout develop
  git branch -d $PRERELEASE_BRANCH
else
  echo "pushing changes"
  git commit -a --no-edit
  git push -u -n origin $PRERELEASE_BRANCH

  # IS THIS RIGHT??
  git request-pull $PRERELEASE_BRANCH https://github.com/coatsbj/lockstep-release-1.git release/stg
fi

echo $PWD

SNAPSHOT_VERSION=`grep "version=" < gradle.properties | sed 's/version=//'`
VERSION=`echo $SNAPSHOT_VERSION | sed 's/-SNAPSHOT//'`

PRERELEASE_BRANCH="release/rc-$VERSION"

git checkout release/stg
git pull origin develop

CHANGED=`git status | grep "use \"git push\""`

if [[ "$CHANGED" == "" ]]; then
  echo "no changes"
  git checkout develop
else
  echo "pushing changes"

  git push -u origin release/stg:$PRERELEASE_BRANCH

  # IS THIS RIGHT??
  git request-pull $PRERELEASE_BRANCH https://github.com/coatsbj/lockstep-release-1.git release/stg
fi

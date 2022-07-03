bash $WORKSPACE/devops/script/codemgt/checkBranchBeforeBuild.sh -b $branch -P "false" -S $appname
npm -v
rm -rf $appname
if [[ $appname == "xt-vue-components" ]] || [[ $appname == "owl-sdk" ]]; then
  git clone -b $branch git@atta-gitlab.xtrfr.cn:atta-team/frontend_base/boss/$appname.git
  cd $appname
  echo `pwd`
  npm config set registry https://registry.npmmirror.com
  npm install
  npm config set registry http://registry.xtrfr.cn/repository/npm-private/
  #curl -X PUT -H 'content-type: application/json' -d '{"name": "xxxxx", "password": "XXXXX"}' http://registry.xtrfr.cn/repository/npm-private/-/user/org.couchdb.user:npm_rw |jq | grep token |awk -F'"' '{print $4}'
  npm set //registry.xtrfr.cn/repository/npm-private/:_authToken $npm_token
  
  if [[ $appname == "xt-vue-components" ]]; then
    npm run docs:build
  fi
  npm run build && npm publish
elif [[ $appname == "frontend-foundation" ]] || [[ $appname == "frontend-components" ]] || [[ $appname == "frontend-fomily-xtd" ]]; then
  npm config set registry http://registry.xtrfr.cn/repository/npm-private/
  npm set //registry.xtrfr.cn/repository/npm-private/:_authToken $npm_token
  git clone -b $branch git@atta-gitlab.xtrfr.cn:atta-team/dev/$appname.git
  cd $appname
  if [[ "$isprod" == "false" ]]; then
    sh publish-dev.sh
  else
    sh publish.sh
  fi
fi


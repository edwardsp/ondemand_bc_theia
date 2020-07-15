#!/bin/bash

apps_dir=/apps

mkdir theia
cp package.json theia

pushd theia

yarn --pure-lockfile && \
    NODE_OPTIONS="--max_old_space_size=4096" yarn theia build && \
    yarn theia download:plugins && \
    yarn --production && \
    yarn autoclean --init && \
    echo *.ts >> .yarnclean && \
    echo *.ts.map >> .yarnclean && \
    echo *.spec.* >> .yarnclean && \
    yarn autoclean --force && \
    yarn cache clean

cat <<EOF >launch.sh
#!/bin/bash

port=\$1
workspace=\$2

cd $apps_dir/theia
export THEIA_DEFAULT_PLUGINS=local-dir:$apps_dir/theia/plugins
node src-gen/backend/main.js --hostname \$HOSTNAME --port \$port "\$workspace"
EOF

popd

sudo mv theia /apps/.

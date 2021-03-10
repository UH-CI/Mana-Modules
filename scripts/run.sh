#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"


module load lmod
spider  -o spider-json  ${MODULEPATH} | python  -mjson.tool  > ${DIR}/modules.json
python ${DIR}/parse.py
mv data.json ${DIR}/../data.json

git add ${DIR}/../data.json
git commit -m "`date` modules updated"

GIT_SSH_COMMAND="ssh -i ${DIR}/id_rsa" git push



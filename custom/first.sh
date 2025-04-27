#!/bin/bash
# https://github.com/281677160/build-actions
# common Module by 28677160
# matrix.target=${FOLDER_NAME}

function TIME() {
  case $1 in
    r) export Color="\e[31m";;
    g) export Color="\e[32m";;
    b) export Color="\e[34m";;
    y) export Color="\e[33m";;
    z) export Color="\e[35m";;
    l) export Color="\e[36m";;
  esac
echo
echo -e "\e[36m\e[0m${Color}${2}\e[0m"
}

function Diy_one() {
cd ${GITHUB_WORKSPACE}
if [[ -d "build" ]] && [[ -z "${BENDI_VERSION}" ]]; then
  rm -rf ${OPERATES_PATH}
  cp -Rf build ${OPERATES_PATH}
fi
}

function Diy_two() {
cd ${GITHUB_WORKSPACE}
if [[ ! -d "${OPERATES_PATH}" ]]; then
  TIME r "根目录缺少编译必要文件夹"
elif [[ ! -d "${COMPILE_PATH}" ]]; then
  TIME r "缺少${COMPILE_PATH}文件夹"
elif [[ ! -f "${BUILD_PARTSH}" ]]; then
  TIME r "缺少${BUILD_PARTSH}文件"
elif [[ ! -f "${BUILD_SETTINGS}" ]]; then
  TIME r "缺少${BUILD_SETTINGS}文件"
elif [[ ! -f "${COMPILE_PATH}/relevance/actions_version" ]]; then
  TIME r "缺少relevance/actions_version文件"
elif [[ ! -f "${COMPILE_PATH}/seed/${CONFIG_FILE}" ]]; then
  TIME r "缺少seed/${CONFIG_FILE}文件，请先建立seed/${CONFIG_FILE}文件"
  exit 1
fi
}

function Diy_memu() {
Diy_one
Diy_two
}

Diy_memu "$@"
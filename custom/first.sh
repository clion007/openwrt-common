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

function Diy_three() {
LINSHI_COMMON="/tmp/common"
rm -rf ${LINSHI_COMMON}
mkdir -p ${LINSHI_COMMON}
curl -fsSL https://raw.githubusercontent.com/clion007/openwrt-common/main/common.sh -o ${LINSHI_COMMON}/common.sh
curl -fsSL https://raw.githubusercontent.com/clion007/openwrt-common/main/upgrade.sh -o ${LINSHI_COMMON}/upgrade.sh
export COMMON_SH="${LINSHI_COMMON}/common.sh"
export UPGRADE_SH="${LINSHI_COMMON}/upgrade.sh"
export CONFIG_TXT="${LINSHI_COMMON}/config.txt"
if grep -q "TIME" "${COMMON_SH}" && grep -q "Diy_Part2" "${UPGRADE_SH}"; then
  cp -Rf ${COMPILE_PATH} ${LINSHI_COMMON}/${FOLDER_NAME}
  export DIY_PT1_SH="${LINSHI_COMMON}/${FOLDER_NAME}/diy-part.sh"
  export DIY_PT2_SH="${LINSHI_COMMON}/${FOLDER_NAME}/diy2-part.sh"
else
  TIME r "common文件下载失败"
  exit 1
fi

echo "DIY_PT1_SH=${DIY_PT1_SH}" >> ${GITHUB_ENV}
echo "DIY_PT2_SH=${DIY_PT2_SH}" >> ${GITHUB_ENV}
echo "COMMON_SH=${COMMON_SH}" >> ${GITHUB_ENV}
echo "UPGRADE_SH=${UPGRADE_SH}" >> ${GITHUB_ENV}
echo "CONFIG_TXT=${CONFIG_TXT}" >> ${GITHUB_ENV}

echo '#!/bin/bash' > ${DIY_PT2_SH}
grep -E '.*export.*=".*"' $DIY_PT1_SH >> ${DIY_PT2_SH}
chmod +x ${DIY_PT2_SH}
source ${DIY_PT2_SH}

grep -E 'grep -rl '.*'.*|.*xargs -r sed -i' $DIY_PT1_SH >> ${DIY_PT2_SH}
sed -i 's/\. |/.\/feeds |/g' ${DIY_PT2_SH}
grep -E 'grep -rl '.*'.*|.*xargs -r sed -i' $DIY_PT1_SH >> ${DIY_PT2_SH}
sed -i 's/\. |/.\/package |/g' ${DIY_PT2_SH}
sed -i 's?./packagefeeds?./feeds?g' ${DIY_PT2_SH}
grep -vE '^[[:space:]]*grep -rl '.*'.*|.*xargs -r sed -i' $DIY_PT1_SH > tmp && mv tmp $DIY_PT1_SH

echo "OpenClash_branch=${OpenClash_branch}" >> ${GITHUB_ENV}
echo "Mandatory_theme=${Mandatory_theme}" >> ${GITHUB_ENV}
echo "Default_theme=${Default_theme}" >> ${GITHUB_ENV}
chmod -R +x ${OPERATES_PATH}
chmod -R +x ${LINSHI_COMMON}
}

function Diy_memu() {
Diy_one
Diy_two
Diy_three
}

Diy_memu "$@"
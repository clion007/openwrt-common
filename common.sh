#!/bin/bash
# https://github.com/281677160/build-actions
# common Module by 28677160
# matrix.target=${FOLDER_NAME}

ACTIONS_VERSION="2.3.0"
Compte=$(date +%Y年%m月%d号%H时%M分)
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

function Diy_variable() {
# 读取变量
case "${SOURCE_CODE}" in
COOLSNOWWOLF)
  export REPO_URL="https://github.com/coolsnowwolf/lede"
  export SOURCE="Lede"
  export SOURCE_OWNER="Lean"
  export LUCI_EDITION="23.05"
  export DISTRIB_SOURCECODE="lede"
  export GENE_PATH="${HOME_PATH}/package/base-files/luci2/bin/config_generate"
;;
LIENOL)
  export REPO_URL="https://github.com/Lienol/openwrt"
  export SOURCE="Lienol"
  export SOURCE_OWNER="Lienol"
  export DISTRIB_SOURCECODE="lienol"
  export LUCI_EDITION="$(echo "${REPO_BRANCH}" |sed 's/openwrt-//g')"
  export GENE_PATH="${HOME_PATH}/package/base-files/files/bin/config_generate"
;;
IMMORTALWRT)
  export REPO_URL="https://github.com/immortalwrt/immortalwrt"
  export SOURCE="Immortalwrt"
  export SOURCE_OWNER="ctcgfw"
  export DISTRIB_SOURCECODE="immortalwrt"
  export LUCI_EDITION="$(echo "${REPO_BRANCH}" |sed 's/openwrt-//g')"
  export GENE_PATH="${HOME_PATH}/package/base-files/files/bin/config_generate"
;;
XWRT)
  export REPO_URL="https://github.com/x-wrt/x-wrt"
  export SOURCE="Xwrt"
  export SOURCE_OWNER="ptpt52"
  export DISTRIB_SOURCECODE="xwrt"
  export LUCI_EDITION="$(echo "${REPO_BRANCH}" |sed 's/openwrt-//g')"
  export GENE_PATH="${HOME_PATH}/package/base-files/files/bin/config_generate"
;;
OFFICIAL)
  export REPO_URL="https://github.com/openwrt/openwrt"
  export SOURCE="Official"
  export SOURCE_OWNER="openwrt"
  export DISTRIB_SOURCECODE="official"
  export LUCI_EDITION="$(echo "${REPO_BRANCH}" |sed 's/openwrt-//g')"
  export GENE_PATH="${HOME_PATH}/package/base-files/files/bin/config_generate"
;;
MT798X)
  if [[ "${REPO_BRANCH}" == "hanwckf-21.02" ]]; then
    export REPO_URL="https://github.com/hanwckf/immortalwrt-mt798x"
    export SOURCE="Mt798x"
    export SOURCE_OWNER="hanwckf"
    export REPO_BRANCH="openwrt-21.02"
    export DISTRIB_SOURCECODE="immortalwrt"
    export LUCI_EDITION="$(echo "${REPO_BRANCH}" |sed 's/openwrt-//g')"
    export GENE_PATH="${HOME_PATH}/package/base-files/files/bin/config_generate"
  else
    export REPO_URL="https://github.com/padavanonly/immortalwrt-mt798x-24.10"
    export SOURCE="Mt798x"
    export SOURCE_OWNER="padavanonly"
    if [[ "${REPO_BRANCH}" == "2410" ]]; then
      export LUCI_EDITION="24.10"
    else
      export LUCI_EDITION="$(echo "${REPO_BRANCH}" |sed 's/openwrt-//g')"
    fi
    export DISTRIB_SOURCECODE="immortalwrt"
    export GENE_PATH="${HOME_PATH}/package/base-files/files/bin/config_generate"
  fi
;;
*)
  if [[ -n "${BENDI_VERSION}" ]]; then
    TIME r "因刚同步上游文件,请设置好[operates]文件夹内的配置后，再次使用命令编译"
  else
    TIME r "不支持${SOURCE_CODE}此源码，当前只支持COOLSNOWWOLF、LIENOL、IMMORTALWRT、XWRT、OFFICIAL"
  fi
  exit 1
;;
esac

export FILES_PATH="${HOME_PATH}/package/base-files/files/etc/shadow"
export DELETE="${HOME_PATH}/package/base-files/files/etc/deletefile"
export DEFAULT_PATH="${HOME_PATH}/package/auto-scripts/files/99-first-run"
export KEEPD_PATH="${HOME_PATH}/package/base-files/files/lib/upgrade/keep.d/base-files-essential"
export CLEAR_PATH="/tmp/Clear"
export Upgrade_Date="`date -d "$(date +'%Y-%m-%d %H:%M:%S')" +%s`"
export Gujian_Date="$(date +%m.%d)"
export LICENSES_DOC="${HOME_PATH}/LICENSES/doc"
export CON_TENTCOM="$(echo "${REPO_URL}" |cut -d"/" -f4-5)"
export RAW_WEB="https://raw.githubusercontent.com/${CON_TENTCOM}/${REPO_BRANCH}/feeds.conf.default"

echo "REPO_URL=${REPO_URL}" >> ${GITHUB_ENV}
echo "REPO_BRANCH=${REPO_BRANCH}" >> ${GITHUB_ENV}
echo "SOURCE=${SOURCE}" >> ${GITHUB_ENV}
echo "SOURCE_OWNER=${SOURCE_OWNER}" >> ${GITHUB_ENV}
echo "LUCI_EDITION=${LUCI_EDITION}" >> ${GITHUB_ENV}
echo "DISTRIB_SOURCECODE=${DISTRIB_SOURCECODE}" >> ${GITHUB_ENV}
echo "GENE_PATH=${GENE_PATH}" >> ${GITHUB_ENV}
echo "RAW_WEB=${RAW_WEB}" >> ${GITHUB_ENV}

echo "FILES_PATH=${FILES_PATH}" >> ${GITHUB_ENV}
echo "DELETE=${DELETE}" >> ${GITHUB_ENV}
echo "DEFAULT_PATH=${DEFAULT_PATH}" >> ${GITHUB_ENV}
echo "KEEPD_PATH=${KEEPD_PATH}" >> ${GITHUB_ENV}
echo "CLEAR_PATH=${CLEAR_PATH}" >> ${GITHUB_ENV}
echo "Upgrade_Date=${Upgrade_Date}" >> ${GITHUB_ENV}
echo "Gujian_Date=$(date +%m.%d)" >> ${GITHUB_ENV}
echo "LICENSES_DOC=${LICENSES_DOC}" >> ${GITHUB_ENV}

# 启动编译时的变量文件
if [[ -z "${BENDI_VERSION}" ]]; then
  cat >"${COMPILE_PATH}/relevance/settings.ini" <<-EOF
SOURCE_CODE="${SOURCE_CODE}"
REPO_BRANCH="${REPO_BRANCH}"
CONFIG_FILE="${CONFIG_FILE}"
INFORMATION_NOTICE="${INFORMATION_NOTICE}"
UPLOAD_FIRMWARE="${UPLOAD_FIRMWARE}"
UPLOAD_RELEASE="${UPLOAD_RELEASE}"
CACHEWRTBUILD_SWITCH="${CACHEWRTBUILD_SWITCH}"
UPDATE_FIRMWARE_ONLINE="${UPDATE_FIRMWARE_ONLINE}"
COMPILATION_INFORMATION="${COMPILATION_INFORMATION}"
RETAIN_MINUTE="${RETAIN_MINUTE}"
KEEP_LATEST="${KEEP_LATEST}"
EOF
fi
}

function Diy_checkout() {
# 下载源码后，进行源码微调和增加插件源
TIME y "正在执行：下载和整理应用,请耐心等候..."
cd ${HOME_PATH}
[[ ! -d "${LICENSES_DOC}" ]] && mkdir -p "${LICENSES_DOC}"
if ! curl -fsSL "${RAW_WEB}" -o "${LICENSES_DOC}/feeds.conf.default"; then
  wget -q ${RAW_WEB} -O ${LICENSES_DOC}/feeds.conf.default
fi
# 增加一些应用
echo '#!/bin/sh' > "${DELETE}" && chmod +x "${DELETE}"
if [[ -d "$LINSHI_COMMON/auto-scripts" ]]; then
  cp -Rf "$LINSHI_COMMON/auto-scripts" "${HOME_PATH}/package/auto-scripts"
else
  TIME r "缺少auto-scripts文件"
  exit 1
fi

sed -i "s/ZHUJI_MING/${SOURCE}/g" "${DEFAULT_PATH}"
sed -i "s/LUCI_EDITION/${LUCI_EDITION}/g" "${DEFAULT_PATH}"
sed -i "s/OPHUBOPENWRT/${DISTRIB_SOURCECODE}/g" "${DEFAULT_PATH}"
sed -i 's/root:.*/root::0:0:99999:7:::/g' ${FILES_PATH}
grep -q "admin:" ${FILES_PATH} && sed -i 's/admin:.*/admin::0:0:99999:7:::/g' ${FILES_PATH}

# 添加自定义插件源
srcdir="$(mktemp -d)"
if grep -q "src-git-full" "${LICENSES_DOC}/feeds.conf.default"; then
  SRC_LIANJIE="$(grep -E '^src-git-full luci https' "${LICENSES_DOC}/feeds.conf.default" | sed -E 's/src-git-full luci (https?:\/\/[^;]+).*/\1/')"
  a=$(grep -E '^src-git-full luci https' "feeds.conf.default")
  if [[ -n "$(echo "$a" |grep -E '\;')" ]]; then
    SRC_FENZHIHAO="$(grep -E '^src-git-full luci https' "${LICENSES_DOC}/feeds.conf.default" | sed -E 's/.*;(.+)/\1/')"
  fi
else
 SRC_LIANJIE="$(grep -E '^src-git luci https' "${LICENSES_DOC}/feeds.conf.default" | sed -E 's/src-git luci (https?:\/\/[^;]+).*/\1/')"
  a=$(grep -E '^src-git luci https' "feeds.conf.default")
  if [[ -n "$(echo "$a" |grep -E '\;')" ]]; then
    SRC_FENZHIHAO="$(grep -E '^src-git luci https' "${LICENSES_DOC}/feeds.conf.default" | sed -E 's/.*;(.+)/\1/')"
  fi
fi
if [[ -n "${SRC_FENZHIHAO}" ]]; then
  git clone --single-branch --depth=1 --branch=${SRC_FENZHIHAO} ${SRC_LIANJIE} ${srcdir}
else
  git clone --depth=1 ${SRC_LIANJIE} ${srcdir}
fi
if [[ -d "${srcdir}/modules/luci-mod-system" ]]; then
  THEME_BRANCH="Theme2"
  rm -rf ${srcdir}
  gitsvn https://github.com/281677160/luci-theme-argon/tree/master ${HOME_PATH}/package/luci-theme-argon
else
  THEME_BRANCH="Theme1"
  rm -rf ${srcdir}
  gitsvn https://github.com/281677160/luci-theme-argon/tree/18.06 ${HOME_PATH}/package/luci-theme-argon
fi

echo "src-git danshui https://github.com/281677160/openwrt-package.git;$SOURCE" >> ${HOME_PATH}/feeds.conf.default
echo "src-git dstheme https://github.com/281677160/openwrt-package.git;$THEME_BRANCH" >> ${HOME_PATH}/feeds.conf.default
if [[ "${OpenClash_branch}" == "1" ]]; then
  echo "src-git OpenClash https://github.com/vernesong/OpenClash.git;master" >> ${HOME_PATH}/feeds.conf.default
elif [[ "${OpenClash_branch}" == "2" ]]; then
  echo "src-git OpenClash https://github.com/vernesong/OpenClash.git;dev" >> ${HOME_PATH}/feeds.conf.default
fi

# 增加中文语言包
if [[ -z "$(find "$HOME_PATH/package" -type d -name "default-settings" -print)" ]] && [[ "${THEME_BRANCH}" == "Theme2" ]]; then
  gitsvn https://github.com/281677160/common/tree/main/Share/default-settings ${HOME_PATH}/package/default-settings
  if grep -q "libustream-wolfssl" "${HOME_PATH}/include/target.mk"; then
    sed -i 's?libustream-wolfssl?libustream-openssl?g' "${HOME_PATH}/include/target.mk"
  fi
  if ! grep -q "dnsmasq-full" "${HOME_PATH}/include/target.mk"; then
    sed -i 's?dnsmasq?dnsmasq-full?g' "${HOME_PATH}/include/target.mk"
  fi
  if ! grep -q "ca-bundle" "${HOME_PATH}/include/target.mk"; then
    sed -i 's?DEFAULT_PACKAGES:=?DEFAULT_PACKAGES:=ca-bundle ?g' "${HOME_PATH}/include/target.mk"
  fi
  if ! grep -q "default-settings" "${HOME_PATH}/include/target.mk"; then
    sed -i 's?DEFAULT_PACKAGES:=?DEFAULT_PACKAGES:=default-settings luci luci-compat luci-lib-base luci-lib-ipkg ?g' "${HOME_PATH}/include/target.mk"
  fi
elif [[ -z "$(find "$HOME_PATH/package" -type d -name "default-settings" -print)" ]] && [[ "${THEME_BRANCH}" == "Theme1" ]]; then
  gitsvn https://github.com/281677160/common/tree/main/Share/default-setting ${HOME_PATH}/package/default-settings
  if grep -q "libustream-wolfssl" "${HOME_PATH}/include/target.mk"; then
    sed -i 's?libustream-wolfssl?libustream-openssl?g' "${HOME_PATH}/include/target.mk"
  fi
  if ! grep -q "dnsmasq-full" "${HOME_PATH}/include/target.mk"; then
    sed -i 's?dnsmasq?dnsmasq-full?g' "${HOME_PATH}/include/target.mk"
  fi
  if ! grep -q "ca-bundle" "${HOME_PATH}/include/target.mk"; then
    sed -i 's?DEFAULT_PACKAGES:=?DEFAULT_PACKAGES:=ca-bundle ?g' "${HOME_PATH}/include/target.mk"
  fi
  if ! grep -q "default-settings" "${HOME_PATH}/include/target.mk"; then
    sed -i 's?DEFAULT_PACKAGES:=?DEFAULT_PACKAGES:=default-settings luci luci-compat luci-lib-fs luci-lib-ipkg ?g' "${HOME_PATH}/include/target.mk"
  fi
fi

if ! grep -q "default-settings" "${HOME_PATH}/include/target.mk"; then
  sed -i 's?DEFAULT_PACKAGES:=?DEFAULT_PACKAGES:=default-settings luci ?g' "${HOME_PATH}/include/target.mk"
fi

ZZZ_PATH="$(find "$HOME_PATH/package" -name "*-default-settings" -not -path "A/exclude_dir/*" -print)"
export ZZZ_PATH="${ZZZ_PATH}"
if [[ -n "${ZZZ_PATH}" ]]; then
  echo "ZZZ_PATH=${ZZZ_PATH}" >> ${GITHUB_ENV}
  export LUCI_EDITION="$(grep -oP "DISTRIB_REVISION='\K[^']+" ${ZZZ_PATH})"
  echo "LUCI_EDITION=${LUCI_EDITION}" >> ${GITHUB_ENV}
  sed -i '/exit 0$/d' "${ZZZ_PATH}"
  sed -i "s?main.lang=.*?main.lang='zh_cn'?g" "${ZZZ_PATH}"
  grep -q "openwrt_banner" "${ZZZ_PATH}" && sed -i '/openwrt_banner/d' "${ZZZ_PATH}"
fi


# 更新feeds
cd ${HOME_PATH}
./scripts/feeds clean
./scripts/feeds update -a > /dev/null 2>&1


# 更新feeds后再次修改补充
cd ${HOME_PATH}
z="luci-theme-argon,luci-app-argon-config,luci-theme-Butterfly,luci-theme-netgear,luci-theme-atmaterial, \
luci-theme-rosy,luci-theme-darkmatter,luci-theme-infinityfreedom,luci-theme-design,luci-app-design-config, \
luci-theme-bootstrap-mod,luci-theme-freifunk-generic,luci-theme-opentomato,luci-theme-kucat, \
luci-app-eqos,adguardhome,luci-app-adguardhome,mosdns,luci-app-mosdns,luci-app-openclash, \
luci-app-gost,gost,luci-app-smartdns,smartdns,luci-app-wizard,luci-app-msd_lite,msd_lite, \
luci-app-ssr-plus,luci-app-passwall,luci-app-passwall2,shadowsocksr-libev,v2dat,v2ray-geodata, \
luci-app-wechatpush,v2ray-core,v2ray-plugin,v2raya,xray-core,xray-plugin,luci-app-alist,alist"
t=(${z//,/ })
for x in "${t[@]}"; do
    find ./feeds ./package \
        -path './feeds/danshui' -prune -o \
        -path './feeds/dstheme' -prune -o \
        -path './feeds/OpenClash' -prune -o \
        -path './package/luci-theme-argon' -prune -o \
        -name "$x" -type d -exec rm -rf {} +
done


if [[ ! "${REPO_BRANCH}" =~ ^(main|master|(openwrt-)?(24\.10))$ ]]; then
  rm -rf ${HOME_PATH}/feeds/danshui/luci-app-fancontrol
fi

if [[ "${REPO_BRANCH}" =~ ^(2410|(openwrt-)?(24\.10))$ ]]; then
  rm -rf ${HOME_PATH}/feeds/danshui/luci-app-quickstart
  rm -rf ${HOME_PATH}/feeds/danshui/luci-app-linkease
  rm -rf ${HOME_PATH}/feeds/danshui/luci-app-istorex
fi

if [[ ! -d "${HOME_PATH}/package/network/config/firewall4" ]]; then
    rm -rf ${HOME_PATH}/feeds/danshui/luci-app-nikki
    rm -rf ${HOME_PATH}/feeds/danshui/luci-app-homeproxy
fi


# 更新golang和node版本
gitsvn https://github.com/sbwml/packages_lang_golang ${HOME_PATH}/feeds/packages/lang/golang
gitsvn https://github.com/sbwml/feeds_packages_lang_node-prebuilt ${HOME_PATH}/feeds/packages/lang/node

# store插件依赖
if [[ -d "${HOME_PATH}/feeds/danshui/relevance/nas-packages/network/services" ]] && [[ ! -d "${HOME_PATH}//package/network/services/ddnsto" ]]; then
  mv ${HOME_PATH}/feeds/danshui/relevance/nas-packages/network/services/* ${HOME_PATH}/package/network/services
fi
if [[ -d "${HOME_PATH}/feeds/danshui/relevance/nas-packages/multimedia/ffmpeg-remux" ]] && [[ ! -d "${HOME_PATH}/feeds/packages/multimedia/ffmpeg-remux" ]]; then
  mv ${HOME_PATH}/feeds/danshui/relevance/nas-packages/multimedia/ffmpeg-remux ${HOME_PATH}/feeds/packages/multimedia/ffmpeg-remux
fi

# tproxy补丁
bash <(curl -fsSL https://github.com/281677160/common/raw/main/Share/tproxy/nft_tproxy.sh)

if [[ ! -d "${HOME_PATH}/feeds/packages/lang/rust" ]]; then
    gitsvn https://github.com/openwrt/packages/tree/openwrt-23.05/lang/rust ${HOME_PATH}/feeds/packages/lang/rust
fi

if [[ ! -d "${HOME_PATH}/feeds/packages/devel/packr" ]]; then
  gitsvn https://github.com/281677160/common/tree/main/Share/packr ${HOME_PATH}/feeds/packages/devel/packr
fi

# files大法，设置固件无烦恼
if [ -d "${BUILD_PATCHES}" ]; then
  find "${BUILD_PATCHES}" -type f -name '*.patch' -print0 | sort -z | xargs -I % -t -0 -n 1 sh -c "cat '%'  | patch -d './' -p1 --forward --no-backup-if-mismatch"
fi
if [ -d "${BUILD_DIY}" ]; then
  cp -Rf ${BUILD_DIY}/* ${HOME_PATH}
fi
if [ -d "${BUILD_FILES}" ]; then
  cp -Rf ${BUILD_FILES} ${HOME_PATH}
fi

# 定时更新固件的插件包
if grep -q "armvirt=y" $MYCONFIG_FILE || grep -q "armsr=y" $MYCONFIG_FILE; then
  find . -type d -name "luci-app-autoupdate" |xargs -i rm -rf {}
  if grep -q "luci-app-autoupdate" "${HOME_PATH}/include/target.mk"; then
    sed -i 's?luci-app-autoupdate ??g' ${HOME_PATH}/include/target.mk
  fi
elif [[ "${UPDATE_FIRMWARE_ONLINE}" == "true" ]]; then
    source ${UPGRADE_SH} && Diy_Part1
else
  find . -type d -name "luci-app-autoupdate" |xargs -i rm -rf {}
  if grep -q "luci-app-autoupdate" "${HOME_PATH}/include/target.mk"; then
    sed -i 's?luci-app-autoupdate ??g' ${HOME_PATH}/include/target.mk
  fi
fi

# N1类型固件修改
if [[ -f "${HOME_PATH}/target/linux/armsr/Makefile" ]]; then
  sed -i "s?FEATURES+=.*?FEATURES+=targz?g" ${HOME_PATH}/target/linux/armsr/Makefile
elif [[ -f "${HOME_PATH}/target/linux/armvirt/Makefile" ]]; then
  sed -i "s?FEATURES+=.*?FEATURES+=targz?g" ${HOME_PATH}/target/linux/armvirt/Makefile
fi

# 给固件保留配置更新固件的保留项目
cat >> "${KEEPD_PATH}" <<-EOF
/etc/config/AdGuardHome.yaml
/www/luci-static/argon/background
/etc/smartdns/custom.conf
 /etc/dnsmasq.d/
 /usr/share/adss/
 /etc/init.d/adss
 /etc/rc.d/S90adss
 /usr/bin/chinadns-ng
 /etc/puship/
 /etc/hotplug.d/iface/99-puship
EOF
}


function Diy_COOLSNOWWOLF() {
cd ${HOME_PATH}
rm -rf ${HOME_PATH}/package/wwan/driver
}


function Diy_LIENOL() {
cd ${HOME_PATH}
rm -rf $HOME_PATH/feeds/packages/net/miniupnpd
gitsvn https://github.com/openwrt/packages/tree/master/net/tailscale ${HOME_PATH}/feeds/packages/net/tailscale
if [[ -d "${HOME_PATH}/feeds/other/lean" ]]; then
  rm -rf ${HOME_PATH}/feeds/other/lean/mt
  rm -rf ${HOME_PATH}/feeds/other/lean/luci-app-vlmcsd
  rm -rf ${HOME_PATH}/feeds/other/lean/vlmcsd
fi
if [[ "${REPO_BRANCH}" == *"24.10"* ]]; then
  gitsvn https://github.com/coolsnowwolf/lede/tree/master/package/libs/mbedtls ${HOME_PATH}/package/libs/mbedtls
  gitsvn https://github.com/coolsnowwolf/lede/tree/master/package/libs/ustream-ssl ${HOME_PATH}/package/libs/ustream-ssl
  gitsvn https://github.com/coolsnowwolf/lede/tree/master/package/libs/uclient ${HOME_PATH}/package/libs/uclient
  rm -fr ${HOME_PATH}/feeds/packages/utils/owut
fi
if [[ "${REPO_BRANCH}" == *"21.02"* ]]; then
  gitsvn https://github.com/coolsnowwolf/packages/tree/152022403f0ab2a85063ae1cd9687bd5240fe9b7/net/dnsproxy ${HOME_PATH}/feeds/packages/net/dnsproxy
  gitsvn https://github.com/coolsnowwolf/lede/tree/326599e3d08d7fe1dc084e1c87581cdf5a8e41a6/package/libs/libjson-c ${HOME_PATH}/package/libs/libjson-c
fi
}


function Diy_IMMORTALWRT() {
cd ${HOME_PATH}
if [[ "${REPO_BRANCH}" =~ (openwrt-18.06|openwrt-18.06-k5.4) ]]; then
  gitsvn https://github.com/openwrt/routing/tree/openwrt-21.02/bmx6 ${HOME_PATH}/feeds/routing/bmx6
  rm -rf ${HOME_PATH}/feeds/packages/net/shadowsocksr-libev
  rm -rf ${HOME_PATH}/feeds/danshui/luci-app-nikki
  rm -rf ${HOME_PATH}/feeds/danshui/luci-app-homeproxy
fi
if [[ "${REPO_BRANCH}" == *"21.02"* ]] || [[ "${REPO_BRANCH}" == *"18.06"* ]] || [[ "${REPO_BRANCH}" == *"23.05"* ]]; then
  gitsvn https://github.com/coolsnowwolf/packages/tree/152022403f0ab2a85063ae1cd9687bd5240fe9b7/net/dnsproxy ${HOME_PATH}/feeds/packages/net/dnsproxy
  gitsvn https://github.com/coolsnowwolf/lede/tree/326599e3d08d7fe1dc084e1c87581cdf5a8e41a6/package/libs/libjson-c ${HOME_PATH}/package/libs/libjson-c
fi
}


function Diy_XWRT() {
cd ${HOME_PATH}
}


function Diy_OFFICIAL() {
cd ${HOME_PATH}
if [[ "${REPO_BRANCH}" == "openwrt-19.07" ]]; then
  gitsvn https://github.com/openwrt/openwrt/tree/openwrt-22.03/package/utils/bcm27xx-userland ${HOME_PATH}/package/utils/bcm27xx-userland
  rm -fr ${HOME_PATH}/feeds/danshui/luci-app-kodexplorer
fi
if [[ "${REPO_BRANCH}" =~ (main|master|openwrt-24.10) ]]; then
  gitsvn https://github.com/281677160/common/blob/main/Share/luci-app-nginx-pingos/Makefile ${HOME_PATH}/feeds/danshui/luci-app-nginx-pingos/Makefile
fi
if [[ "${REPO_BRANCH}" == *"23.05"* ]]; then
  gitsvn https://github.com/coolsnowwolf/packages/tree/152022403f0ab2a85063ae1cd9687bd5240fe9b7/net/dnsproxy ${HOME_PATH}/feeds/packages/net/dnsproxy
  gitsvn https://github.com/coolsnowwolf/lede/tree/326599e3d08d7fe1dc084e1c87581cdf5a8e41a6/package/libs/libjson-c ${HOME_PATH}/package/libs/libjson-c
fi
}


function Diy_MT798X() {
cd ${HOME_PATH}
}


function Diy_partsh() {
TIME y "正在执行：自定义文件"
cd ${HOME_PATH}
# 运行自定义文件
${DIY_PT1_SH}
./scripts/feeds update -a
}


function Diy_scripts() {
TIME y "正在执行：更新和安装feeds"
# 运行自定义后,检测主题是否可用
cd ${HOME_PATH}
# 主题设置
if [[ ! "${Mandatory_theme}" == "0" ]] && [[ -n "${Mandatory_theme}" ]]; then
  sed -i "/${Mandatory_theme}/d" $MYCONFIG_FILE
  echo "CONFIG_PACKAGE_luci-theme-$Mandatory_theme=y" >>$MYCONFIG_FILE
  SEARCH_DIRS=("${HOME_PATH}/package" "${HOME_PATH}/feeds")
  TARGET_DIR="luci-theme-${Mandatory_theme}"
  if find "${SEARCH_DIRS[@]}" -type d -name "$TARGET_DIR" -print -quit | grep -q .; then
    [[ -f "${HOME_PATH}/feeds/luci/collections/luci/Makefile" ]] && sed -i -E "s/(\+luci-theme-)[^ \\]*/\1${Mandatory_theme}/g" "${HOME_PATH}/feeds/luci/collections/luci/Makefile"
    [[ -f "${HOME_PATH}/feeds/luci/collections/luci-light/Makefile" ]] && sed -i -E "s/(\+luci-theme-)[^ \\]*/\1${Mandatory_theme}/g" "${HOME_PATH}/feeds/luci/collections/luci-light/Makefile"
  fi
fi
if [[ ! "${Default_theme}" == "0" ]] && [[ -n "${Default_theme}" ]]; then
  sed -i "/${Default_theme}/d" $MYCONFIG_FILE
  echo "CONFIG_PACKAGE_luci-theme-$Default_theme=y" >>$MYCONFIG_FILE
fi

# 更新和安装feeds
./scripts/feeds install -a > /dev/null 2>&1
./scripts/feeds install -a

# 使用自定义配置文件
[[ -f "$MYCONFIG_FILE" ]] && cp -Rf $MYCONFIG_FILE .config
}


function Diy_profile() {
cd ${HOME_PATH}
make defconfig > /dev/null 2>&1
TIME y "正在执行：识别源码编译为何机型"
export TARGET_BOARD="$(awk -F '[="]+' '/TARGET_BOARD/{print $2}' ${HOME_PATH}/.config)"
export TARGET_SUBTARGET="$(awk -F '[="]+' '/TARGET_SUBTARGET/{print $2}' ${HOME_PATH}/.config)"
export TARGET_PROFILE_DG="$(awk -F '[="]+' '/TARGET_PROFILE/{print $2}' ${HOME_PATH}/.config)"
if [[ -n "$(grep -Eo 'CONFIG_TARGET.*x86.*64.*=y' ${HOME_PATH}/.config)" ]]; then
  export TARGET_PROFILE="x86-64"
elif [[ -n "$(grep -Eo 'CONFIG_TARGET.*x86.*=y' ${HOME_PATH}/.config)" ]]; then
  export TARGET_PROFILE="x86-32"
elif [[ -n "$(grep -Eo 'CONFIG_TARGET.*DEVICE.*phicomm.*n1=y' ${HOME_PATH}/.config)" ]]; then
  export TARGET_PROFILE="phicomm_n1"
elif [[ -n "$(grep -Eo 'armvirt=y' $HOME_PATH/.config)" ]] || [[ -n "$(grep -Eo 'armsr=y' $HOME_PATH/.config)" ]]; then
  export TARGET_PROFILE="aarch_64"
elif [[ -n "$(grep -Eo 'CONFIG_TARGET.*DEVICE.*=y' ${HOME_PATH}/.config)" ]]; then
  export TARGET_PROFILE="$(grep -Eo "CONFIG_TARGET.*DEVICE.*=y" ${HOME_PATH}/.config | sed -r 's/.*DEVICE_(.*)=y/\1/')"
else
  export TARGET_PROFILE="${TARGET_PROFILE_DG}"
fi
export FIRMWARE_PATH=${HOME_PATH}/bin/targets/${TARGET_BOARD}/${TARGET_SUBTARGET}
export TARGET_OPENWRT=openwrt/bin/targets/${TARGET_BOARD}/${TARGET_SUBTARGET}
echo "TARGET_BOARD=${TARGET_BOARD}" >> ${GITHUB_ENV}
echo "TARGET_SUBTARGET=${TARGET_SUBTARGET}" >> ${GITHUB_ENV}
echo "TARGET_PROFILE=${TARGET_PROFILE}" >> ${GITHUB_ENV}
echo "FIRMWARE_PATH=${FIRMWARE_PATH}" >> ${GITHUB_ENV}
echo "正在编译：${TARGET_PROFILE}"
}


function Diy_management() {
cd ${HOME_PATH}
# 机型为aarch_64的时,修改cpufreq代码适配Armvirt
if [[ "${TARGET_BOARD}" =~ (armvirt|armsr) ]]; then
  for X in $(find . -type d -name "luci-app-cpufreq"); do \
    [[ -d "$X" ]] && \
    sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' "$X/Makefile"; \
  done
fi

if [[ ! -f "${HOME_PATH}/staging_dir/host/bin/upx" ]]; then
  cp -Rf /usr/bin/upx ${HOME_PATH}/staging_dir/host/bin/upx
  cp -Rf /usr/bin/upx-ucl ${HOME_PATH}/staging_dir/host/bin/upx-ucl
fi

# 正在执行插件语言修改
if [[ ! -d "${HOME_PATH}/feeds/luci/modules/luci-mod-system" ]]; then
  bash <(curl -fsSL https://raw.githubusercontent.com/281677160/common/main/language/zh-cn.sh)
fi
# files文件夹删除LICENSE,README
[[ -d "${HOME_PATH}/files" ]] && sudo chmod +x ${HOME_PATH}/files
rm -rf ${HOME_PATH}/files/{LICENSE,README}
}


function Diy_definition() {
cd ${HOME_PATH}
source "${DIY_PT2_SH}"

# 获取源码文件的IP
lan="/set network.\$1.netmask/a"
ipadd="$(grep "ipaddr:-" "${GENE_PATH}" |grep -v 'addr_offset' |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
netmas="$(grep "netmask:-" "${GENE_PATH}" |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
opname="$(grep "hostname=" "${GENE_PATH}" |grep -v '\$hostname' |cut -d "'" -f2)"
if [[ -n "$(grep "set network.\${1}6.device" "${GENE_PATH}")" ]]; then
  ifnamee="uci set network.ipv6.device='@lan'"
  set_add="uci add_list firewall.@zone[0].network='ipv6'"
else
  ifnamee="uci set network.ipv6.ifname='@lan'"
  set_add="uci set firewall.@zone[0].network='lan ipv6'"
fi

if [[ "${SOURCE_CODE}" == "OFFICIAL" ]] && [[ "${REPO_BRANCH}" == "openwrt-19.07" ]]; then
  devicee="uci set network.ipv6.device='@lan'"
fi

if [[ "${Ipv4_ipaddr}" == "0" ]] || [[ -z "${Ipv4_ipaddr}" ]]; then
  echo "不进行,修改后台IP"
elif [[ -n "${Ipv4_ipaddr}" ]]; then
  Kernel_Pat="$(echo ${Ipv4_ipaddr} |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  ipadd_Pat="$(echo ${ipadd} |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  if [[ -n "${Kernel_Pat}" ]] && [[ -n "${ipadd_Pat}" ]]; then
     sed -i "s/${ipadd}/${Ipv4_ipaddr}/g" "${GENE_PATH}"
     echo "openwrt后台IP[${Ipv4_ipaddr}]修改完成"
   else
     TIME r "因IP获取有错误，后台IP更换不成功，请检查IP是否填写正确，如果填写正确，那就是获取不了源码内的IP了"
   fi
fi

if [[ "${Netmask_netm}" == "0" ]] || [[ -z "${Netmask_netm}" ]]; then
  echo "不进行,子网掩码修改"
elif [[ -n "${Netmask_netm}" ]]; then
  Kernel_netm="$(echo ${Netmask_netm} |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  ipadd_mas="$(echo ${netmas} |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  if [[ -n "${Kernel_netm}" ]] && [[ -n "${ipadd_mas}" ]]; then
     sed -i "s/${netmas}/${Netmask_netm}/g" "${GENE_PATH}"
     echo "子网掩码[${Netmask_netm}]修改完成"
   else
     TIME r "因子网掩码获取有错误，子网掩码设置失败，请检查IP是否填写正确，如果填写正确，那就是获取不了源码内的IP了"
  fi
fi

if [[ ! "${Default_theme}" == "0" ]] && [[ -n "${Default_theme}" ]]; then
  if [[ `grep -c "${Default_theme}=y" ${HOME_PATH}/.config` -eq '0' ]]; then
    TIME r "没有${Default_theme}此主题存在，默认主题设置失败"
  else
    echo "uci set luci.main.mediaurlbase='/luci-static/${Default_theme}'" >> "${DEFAULT_PATH}"
    echo "uci commit luci" >> "${DEFAULT_PATH}"
    echo "默认主题[${Default_theme}]设置完成"
  fi
else
  echo "不进行,默认主题设置"
fi

if [[ ! "${Mandatory_theme}" == "0" ]] && [[ -n "${Mandatory_theme}" ]]; then
  if [[ `grep -c "${Mandatory_theme}=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    [[ -f "$HOME_PATH/feeds/luci/collections/luci/Makefile" ]] && sed -i -E "s/(\+luci-theme-)[^ \\]*/\1${Mandatory_theme}/g" "$HOME_PATH/feeds/luci/collections/luci/Makefile"
    [[ -f "$HOME_PATH/feeds/luci/collections/luci-light/Makefile" ]] && sed -i -E "s/(\+luci-theme-)[^ \\]*/\1${Mandatory_theme}/g" "$HOME_PATH/feeds/luci/collections/luci-light/Makefile"
    echo "替换系统默认主题完成,您现在的系统默认主题为：luci-theme-${Mandatory_theme}"
  else
    [[ -f "$HOME_PATH/feeds/luci/collections/luci/Makefile" ]] && sed -i -E "s/(\+luci-theme-)[^ \\]*/\1bootstrap/g" "$HOME_PATH/feeds/luci/collections/luci/Makefile"
    [[ -f "$HOME_PATH/feeds/luci/collections/luci-light/Makefile" ]] && sed -i -E "s/(\+luci-theme-)[^ \\]*/\1bootstrap/g" "$HOME_PATH/feeds/luci/collections/luci-light/Makefile"
    echo "CONFIG_PACKAGE_luci-theme-bootstrap=y" >>.config
    TIME r "没有${Mandatory_theme}此主题存在，替换失败，继续使用原默认主题"
  fi
else
  echo "不进行,系统默认主题替换"
fi

if [[ "${Customized_Information}" == "0" ]] || [[ -z "${Customized_Information}" ]]; then
  echo "不进行,个性签名设置"
elif [[ -n "${Customized_Information}" ]]; then
  sed -i '/DISTRIB_DESCRIPTION/d' "${ZZZ_PATH}"
cat >> "${ZZZ_PATH}" <<-EOF
    [[ -f "/usr/lib/os-release" ]] && sed -i 's?RELEASE=".*"?RELEASE="Customized_Information @ OpenWrt"?g' /usr/lib/os-release
    sed -i '/DISTRIB_DESCRIPTION/d' /etc/openwrt_release
    echo "DISTRIB_DESCRIPTION='Customized_Information @ OpenWrt '" >> /etc/openwrt_release
EOF
  Customized_Informat="${Customized_Information}"
  sed -i "s?Customized_Information?${Customized_Informat}?g" "${ZZZ_PATH}"
  echo "个性签名[${Customized_Informat}]增加完成"
fi

if [[ -n "${Kernel_partition_size}" ]] && [[ "${Kernel_partition_size}" != "0" ]]; then
  echo "CONFIG_TARGET_KERNEL_PARTSIZE=${Kernel_partition_size}" >> ${HOME_PATH}/.config
  echo "内核分区设置完成，大小为：${Kernel_partition_size}MB"
else
  echo "不进行,内核分区大小设置"
fi

if [[ -n "${Rootfs_partition_size}" ]] && [[ "${Rootfs_partition_size}" != "0" ]]; then
  echo "CONFIG_TARGET_ROOTFS_PARTSIZE=${Rootfs_partition_size}" >> ${HOME_PATH}/.config
  echo "系统分区设置完成，大小为：${Rootfs_partition_size}MB"
else
  echo "不进行,系统分区大小设置"
fi

if [[ "${Op_name}" == "0" ]] || [[ -z "${Op_name}" ]]; then
  echo "不进行,修改主机名称"
elif [[ -n "${Op_name}" ]] && [[ -n "${opname}" ]]; then
  sed -i "s/${opname}/${Op_name}/g" "${GENE_PATH}"
  echo "主机名[${Op_name}]修改完成"
fi

if [[ "${Gateway_Settings}" == "0" ]] || [[ -z "${Gateway_Settings}" ]]; then
  echo "不进行,网关设置"
elif [[ -n "${Gateway_Settings}" ]]; then
  Router_gat="$(echo ${Gateway_Settings} |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  if [[ -n "${Router_gat}" ]]; then
    sed -i "$lan\set network.lan.gateway='${Gateway_Settings}'" "${GENE_PATH}"
    echo "网关[${Gateway_Settings}]修改完成"
  else
    TIME r "因子网关IP获取有错误，网关IP设置失败，请检查IP是否填写正确，如果填写正确，那就是获取不了源码内的IP了"
  fi
fi

if [[ "${DNS_Settings}" == "0" ]] || [[ -z "${DNS_Settings}" ]]; then
  echo "不进行,DNS设置"
elif [[ -n "${DNS_Settings}" ]]; then
  ipa_dns="$(echo ${DNS_Settings} |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  if [[ -n "${ipa_dns}" ]]; then
     sed -i "$lan\set network.lan.dns='${DNS_Settings}'" "${GENE_PATH}"
     echo "DNS[${DNS_Settings}]设置完成"
  else
    TIME r "因DNS获取有错误，DNS设置失败，请检查DNS是否填写正确"
  fi
fi

if [[ "${Broadcast_Ipv4}" == "0" ]] || [[ -z "${Broadcast_Ipv4}" ]]; then
  echo "不进行,广播IP设置"
elif [[ -n "${Broadcast_Ipv4}" ]]; then
  IPv4_Bro="$(echo ${Broadcast_Ipv4} |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  if [[ -n "${IPv4_Bro}" ]]; then
    sed -i "$lan\set network.lan.broadcast='${Broadcast_Ipv4}'" "${GENE_PATH}"
    echo "广播IP[${Broadcast_Ipv4}]设置完成"
  else
    TIME r "因IPv4 广播IP获取有错误，IPv4广播IP设置失败，请检查IPv4广播IP是否填写正确"
  fi
fi

if [[ "${Disable_DHCP}" == "1" ]]; then
   sed -i "$lan\set dhcp.lan.ignore='1'" "${GENE_PATH}"
   echo "关闭DHCP设置完成"
else
   echo "不进行,关闭DHCP设置"
fi

if [[ "${Disable_Bridge}" == "1" ]]; then
   sed -i "$lan\delete network.lan.type" "${GENE_PATH}"
   echo "去掉桥接设置完成"
else
   echo "不进行,去掉桥接设"
fi

if [[ "${Ttyd_account_free_login}" == "1" ]]; then
   sed -i "$lan\set ttyd.@ttyd[0].command='/bin/login -f root'" "${GENE_PATH}"
   echo "TTYD免账户登录完成"
else
   echo "不进行,TTYD免账户登录"
fi

if [[ "${Password_free_login}" == "1" ]]; then
   sed -i '/CYXluq4wUazHjmCDBCqXF/d' "${ZZZ_PATH}"
   echo "固件免密登录设置完成"
else
   echo "不进行,固件免密登录设置"
fi

if [[ "${Disable_53_redirection}" == "1" ]]; then
   sed -i '/to-ports 53/d' "${ZZZ_PATH}"
   echo "删除DNS重定向53端口完成"
else
   echo "不进行,删除DNS重定向53端"
fi

if [[ "${Cancel_running}" == "1" ]]; then
   echo "sed -i '/coremark/d' /etc/crontabs/root" >> "${DEFAULT_PATH}"
   echo "删除每天跑分任务完成"
else
   echo "不进行,删除每天跑分任务"
fi

if [[ "${OpenClash_branch}" =~ (1|2) ]]; then
  CLASH_BRANCH="$(grep -E '^src-git OpenClash https' "${HOME_PATH}/feeds.conf.default" | sed -E 's/.*;(.+)/\1/')"
  echo -e "\nCONFIG_PACKAGE_luci-app-openclash=y" >> ${HOME_PATH}/.config
  echo "增加luci-app-openclash(${CLASH_BRANCH})完成"
else
  echo -e "\n# CONFIG_PACKAGE_luci-app-openclash is not set" >> ${HOME_PATH}/.config
  echo "去除luci-app-openclash完成"
fi


if [[ "${Disable_autosamba}" == "1" ]]; then
sed -i '/samba/d;/SAMBA/d' "${HOME_PATH}/.config"
echo '
# CONFIG_PACKAGE_autosamba is not set
# CONFIG_PACKAGE_luci-app-samba is not set
# CONFIG_PACKAGE_luci-app-samba4 is not set
# CONFIG_PACKAGE_samba36-server is not set
# CONFIG_PACKAGE_samba4-libs is not set
# CONFIG_PACKAGE_samba4-server is not set
' >> ${HOME_PATH}/.config
   echo "去掉samba完成"
else
   echo "不进行,去掉samba"
fi

if [[ "${Automatic_Mount_Settings}" == "1" ]]; then
echo '
CONFIG_PACKAGE_block-mount=y
CONFIG_PACKAGE_fdisk=y
CONFIG_PACKAGE_usbutils=y
CONFIG_PACKAGE_badblocks=y
CONFIG_PACKAGE_ntfs-3g=y
CONFIG_PACKAGE_kmod-scsi-core=y
CONFIG_PACKAGE_kmod-usb-core=y
CONFIG_PACKAGE_kmod-usb-ohci=y
CONFIG_PACKAGE_kmod-usb-uhci=y
CONFIG_PACKAGE_kmod-usb-storage=y
CONFIG_PACKAGE_kmod-usb-storage-extras=y
CONFIG_PACKAGE_kmod-usb2=y
CONFIG_PACKAGE_kmod-usb3=y
CONFIG_PACKAGE_kmod-fs-ext4=y
CONFIG_PACKAGE_kmod-fs-vfat=y
CONFIG_PACKAGE_kmod-fuse=y
# CONFIG_PACKAGE_kmod-fs-ntfs is not set
' >> ${HOME_PATH}/.config
gitsvn https://github.com/281677160/common/blob/main/Share/block/10-mount ${HOME_PATH}/files/etc/hotplug.d/block/10-mount
  if [[ "${SOURCE}" == "Lienol" ]] && [[ "${REPO_BRANCH}" == "19.07" ]]; then
    sed -i '/CONFIG_PACKAGE_ntfs-3g=y/d' "${HOME_PATH}/.config"
    sed -i '/CONFIG_PACKAGE_NTFS-3G_HAS_PROBE=y/d' "${HOME_PATH}/.config"
  fi
fi

if [[ "${Enable_IPV6_function}" == "1" ]]; then
  echo "编译IPV6固件"
  echo "
    uci set network.lan.ip6assign='64'
    uci commit network
    uci set dhcp.lan.ra='server'
    uci set dhcp.lan.dhcpv6='server'
    uci set dhcp.lan.ra_management='1'
    uci set dhcp.lan.ra_default='1'
    uci set dhcp.@dnsmasq[0].localservice=0
    uci set dhcp.@dnsmasq[0].nonwildcard=0
    uci set dhcp.@dnsmasq[0].filter_aaaa='0'
    uci commit dhcp
  " >> "${DEFAULT_PATH}"
elif [[ "${Create_Ipv6_Lan}" == "1" ]]; then
  echo "爱快+OP双系统时,爱快接管IPV6,在OP创建IPV6的lan口接收IPV6信息"
  echo "
    uci delete network.lan.ip6assign
    uci set network.lan.delegate='0'
    uci commit network
    uci delete dhcp.lan.ra
    uci delete dhcp.lan.ra_management
    uci delete dhcp.lan.ra_default
    uci delete dhcp.lan.dhcpv6
    uci delete dhcp.lan.ndp
    uci set dhcp.@dnsmasq[0].filter_aaaa='0'
    uci commit dhcp
    uci set network.ipv6=interface
    uci set network.ipv6.proto='dhcpv6'
    ${devicee}
    ${ifnamee}
    uci set network.ipv6.reqaddress='try'
    uci set network.ipv6.reqprefix='auto'
    uci commit network
    ${set_add}
    uci commit firewall
  " >> "${DEFAULT_PATH}"
elif [[ "${Enable_IPV4_function}" == "1" ]]; then
  echo "编译IPV4固件"
  echo "
    uci delete network.globals.ula_prefix
    uci delete network.lan.ip6assign
    uci delete network.wan6
    uci set network.lan.delegate='0' 
    uci commit network
    uci delete dhcp.lan.ra
    uci delete dhcp.lan.ra_management
    uci delete dhcp.lan.ra_default
    uci delete dhcp.lan.dhcpv6
    uci delete dhcp.lan.ndp
    uci set dhcp.@dnsmasq[0].filter_aaaa='1'
    uci commit dhcp
  " >> "${DEFAULT_PATH}"
fi

if [[ "${Enable_IPV6_function}" == "1" ]]; then
echo '
CONFIG_PACKAGE_ipv6helper=y
CONFIG_PACKAGE_ip6tables=y
CONFIG_PACKAGE_dnsmasq_full_dhcpv6=y
CONFIG_PACKAGE_odhcp6c=y
CONFIG_PACKAGE_odhcpd-ipv6only=y
CONFIG_IPV6=y
CONFIG_PACKAGE_6rd=y
CONFIG_PACKAGE_6to4=y
' >> ${HOME_PATH}/.config
fi

if [[ "${Create_Ipv6_Lan}" == "1" ]]; then
echo '
CONFIG_PACKAGE_ipv6helper=y
CONFIG_PACKAGE_ip6tables=y
CONFIG_PACKAGE_dnsmasq_full_dhcpv6=y
CONFIG_PACKAGE_odhcp6c=y
CONFIG_PACKAGE_odhcpd-ipv6only=y
CONFIG_IPV6=y
CONFIG_PACKAGE_6rd=y
CONFIG_PACKAGE_6to4=y
' >> ${HOME_PATH}/.config
fi

if [[ "${Enable_IPV4_function}" == "1" ]] && \
[[ "${REPO_BRANCH}" =~ ^(main|master|2410|(openwrt-)?(19\.07|23\.05|24\.10))$ ]]; then
echo '
# CONFIG_PACKAGE_ipv6helper is not set
# CONFIG_PACKAGE_ip6tables is not set
# CONFIG_PACKAGE_dnsmasq_full_dhcpv6 is not set
# CONFIG_PACKAGE_odhcp6c is not set
# CONFIG_PACKAGE_odhcpd-ipv6only is not set
# CONFIG_IPV6 is not set
# CONFIG_PACKAGE_6rd is not set
# CONFIG_PACKAGE_6to4 is not set
' >> ${HOME_PATH}/.config
else
echo '
CONFIG_IPV6=y
CONFIG_PACKAGE_odhcp6c=y
CONFIG_PACKAGE_odhcpd-ipv6only=y
' >> ${HOME_PATH}/.config
fi


if [[ "${Delete_unnecessary_items}" == "1" ]]; then
  echo "删除其他机型的固件,只保留当前主机型固件完成"
  sed -i "s|^TARGET_|# TARGET_|g; s|# TARGET_DEVICES += ${TARGET_PROFILE}|TARGET_DEVICES += ${TARGET_PROFILE}|" ${HOME_PATH}/target/linux/${TARGET_BOARD}/image/Makefile
fi

export patchverl="$(grep "KERNEL_PATCHVER" "${HOME_PATH}/target/linux/${TARGET_BOARD}/Makefile" |grep -Eo "[0-9]+\.[0-9]+")"
if [[ "${TARGET_BOARD}" == "armvirt" ]]; then
  export KERNEL_patc="config-${Replace_Kernel}"
else
  export KERNEL_patc="patches-${Replace_Kernel}"
fi
if [[ "${Replace_Kernel}" == "0" ]]; then
  echo "不进行,内核更换"
elif [[ -n "${Replace_Kernel}" ]] && [[ -n "${patchverl}" ]]; then
  if [[ `ls -1 "${HOME_PATH}/target/linux/${TARGET_BOARD}" |grep -c "${KERNEL_patc}"` -eq '1' ]]; then
    sed -i "s/${patchverl}/${Replace_Kernel}/g" ${HOME_PATH}/target/linux/${TARGET_BOARD}/Makefile
    echo "内核[${Replace_Kernel}]更换完成"
  else
    TIME r "${TARGET_PROFILE}机型源码没发现[ ${Replace_Kernel} ]内核存在，替换内核操作失败，保持默认内核[${patchverl}]继续编译"
  fi
fi

cat >> "${HOME_PATH}/.config" <<-EOF
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_default-settings=y
CONFIG_PACKAGE_default-settings-chn=y
EOF

# 晶晨CPU机型自定义机型,内核,分区
echo "amlogic_model=${amlogic_model}" >> ${GITHUB_ENV}
echo "amlogic_kernel=${amlogic_kernel}" >> ${GITHUB_ENV}
echo "auto_kernel=${auto_kernel}" >> ${GITHUB_ENV}
echo "openwrt_size=${rootfs_size}" >> ${GITHUB_ENV}
echo "kernel_repo=ophub/kernel" >> ${GITHUB_ENV}
echo "kernel_usage=${kernel_usage}" >> ${GITHUB_ENV}
echo "builder_name=ophub" >> ${GITHUB_ENV}

# adguardhome增加核心
if [[ `grep -c "CONFIG_ARCH=\"x86_64\"" ${HOME_PATH}/.config` -eq '1' ]]; then
  Arch="linux_amd64"
  Archclash="linux-amd64"
  echo "CPU架构：amd64"
elif [[ `grep -c "CONFIG_ARCH=\"i386\"" ${HOME_PATH}/.config` -eq '1' ]]; then
  Arch="linux_386"
  Archclash="linux-386"
  echo "CPU架构：X86 32"
elif [[ `grep -c "CONFIG_ARCH=\"aarch64\"" ${HOME_PATH}/.config` -eq '1' ]]; then
  Arch="linux_arm64"
  Archclash="linux-arm64"
  echo "CPU架构：arm64"
elif [[ `grep -c "CONFIG_arm_v7=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  Arch="linux_armv7"
  Archclash="linux-armv7"
  echo "CPU架构：armv7"
elif [[ `grep -c "CONFIG_ARCH=\"arm\"" ${HOME_PATH}/.config` -eq '1' ]] && [[ `grep -c "CONFIG_arm_v7=y" ${HOME_PATH}/.config` -eq '0' ]] && [[ `grep "CONFIG_TARGET_ARCH_PACKAGES" "${HOME_PATH}/.config" |grep -c "vfp"` -eq '1' ]]; then
  Arch="linux_armv6"
  Archclash="linux-armv6"
  echo "CPU架构：armv6"
elif [[ `grep -c "CONFIG_ARCH=\"arm\"" ${HOME_PATH}/.config` -eq '1' ]] && [[ `grep -c "CONFIG_arm_v7=y" ${HOME_PATH}/.config` -eq '0' ]] && [[ `grep "CONFIG_TARGET_ARCH_PACKAGES" "${HOME_PATH}/.config" |grep -c "vfp"` -eq '0' ]]; then
  Arch="linux_armv5"
  Archclash="linux-armv5"
  echo "CPU架构：armv6"
elif [[ `grep -c "CONFIG_ARCH=\"mips\"" ${HOME_PATH}/.config` -eq '1' ]]; then
  Arch="linux_mips_softfloat"
  Archclash="linux-mips-softfloat"
  echo "CPU架构：mips"
elif [[ `grep -c "CONFIG_ARCH=\"mips64\"" ${HOME_PATH}/.config` -eq '1' ]]; then
  Arch="linux_mips64_softfloat"
  Archclash="linux-mips64"
  echo "CPU架构：mips64"
elif [[ `grep -c "CONFIG_ARCH=\"mipsel\"" ${HOME_PATH}/.config` -eq '1' ]]; then
  Arch="linux_mipsle_softfloat"
  Archclash="linux-mipsle-softfloat"
  echo "CPU架构：mipsel"
elif [[ `grep -c "CONFIG_ARCH=\"mips64el\"" ${HOME_PATH}/.config` -eq '1' ]]; then
  Arch="linux_mips64le_softfloat"
  Archclash="linux-mips64le"
  echo "CPU架构：mips64el"
else
  echo "不了解您的CPU为何架构"
  weizhicpu="1"
fi

if [[ ! "${weizhicpu}" == "1" ]] && [[ "${AdGuardHome_Core}" == "1" ]]; then
  echo "正在执行：给adguardhome下载核心"
  rm -rf ${HOME_PATH}/AdGuardHome && rm -rf ${HOME_PATH}/files/usr/bin
  wget -q https://github.com/281677160/common/releases/download/API/AdGuardHome.api -O AdGuardHome.api
  if [[ $? -ne 0 ]];then
    curl -fsSL https://github.com/281677160/common/releases/download/API/AdGuardHome.api -o AdGuardHome.api
  fi
  latest_ver="$(grep -E 'tag_name' 'AdGuardHome.api' |grep -E 'v[0-9.]+' -o 2>/dev/null)"
  rm -rf AdGuardHome.api
  wget -q https://github.com/AdguardTeam/AdGuardHome/releases/download/${latest_ver}/AdGuardHome_${Arch}.tar.gz
  if [[ -f "AdGuardHome_${Arch}.tar.gz" ]]; then
    tar -zxf AdGuardHome_${Arch}.tar.gz -C ${HOME_PATH}
    echo "AdGuardHome核心下载成功"
  else
    echo "AdGuardHome核心下载失败"
  fi
  mkdir -p ${HOME_PATH}/files/usr/bin
  if [[ -f "${HOME_PATH}/AdGuardHome/AdGuardHome" ]]; then
    mv -f ${HOME_PATH}/AdGuardHome ${HOME_PATH}/files/usr/bin/
    sudo chmod +x ${HOME_PATH}/files/usr/bin/AdGuardHome/AdGuardHome
    echo "增加AdGuardHome核心完成"
    echo -e "\nCONFIG_PACKAGE_luci-app-adguardhome=y" >> ${HOME_PATH}/.config
  else
    echo "增加AdGuardHome核心失败"
  fi
    rm -rf ${HOME_PATH}/{AdGuardHome_${Arch}.tar.gz,AdGuardHome}
else
  [[ -f "${HOME_PATH}/files/usr/bin/AdGuardHome" ]] && rm -rf ${HOME_PATH}/files/usr/bin/AdGuardHome
fi

# 源码内核版本号
KERNEL_PATCH="$(grep -Eo "KERNEL_PATCHVER.*[0-9.]+" "${HOME_PATH}/target/linux/${TARGET_BOARD}/Makefile" |grep -Eo "[0-9.]+")"
KERNEL_VERSINO="kernel-${KERNEL_PATCH}"
  if [[ -f "${HOME_PATH}/include/${KERNEL_VERSINO}" ]]; then
LINUX_KERNEL="$(grep -Eo "LINUX_KERNEL_HASH-[0-9.]+" "${HOME_PATH}/include/${KERNEL_VERSINO}"  |grep -Eo "[0-9.]+")"
  [[ -z ${LINUX_KERNEL} ]] && export LINUX_KERNEL="nono"
else
  LINUX_KERNEL="$(grep -Eo "LINUX_KERNEL_HASH-${KERNEL_PATCH}.[0-9]+" "${HOME_PATH}/include/kernel-version.mk" |grep -Eo "[0-9.]+")"
  [[ -z ${LINUX_KERNEL} ]] && export LINUX_KERNEL="nono"
fi
echo "LINUX_KERNEL=${LINUX_KERNEL}" >> ${GITHUB_ENV}
}


function Diy_prevent() {
cd ${HOME_PATH}
TIME y "正在执行：判断插件有否冲突减少编译错误"
if [[ `grep -c "CONFIG_PACKAGE_luci-app-ipsec-server=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-ipsec-vpnd=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-ipsec-vpnd=y/# CONFIG_PACKAGE_luci-app-ipsec-vpnd is not set/g' ${HOME_PATH}/.config
    TIME r "您同时选择luci-app-ipsec-vpnd和luci-app-ipsec-server，插件有冲突，相同功能插件只能二选一，已删除luci-app-ipsec-vpnd"
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-docker=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-dockerman=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-docker=y/# CONFIG_PACKAGE_luci-app-docker is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-i18n-docker-zh-cn=y/# CONFIG_PACKAGE_luci-i18n-docker-zh-cn is not set/g' ${HOME_PATH}/.config
    TIME r "您同时选择luci-app-docker和luci-app-dockerman，插件有冲突，相同功能插件只能二选一，已删除luci-app-docker"
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-qbittorrent=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-qbittorrent-simple=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-qbittorrent-simple=y/# CONFIG_PACKAGE_luci-app-qbittorrent-simple is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-i18n-qbittorrent-simple-zh-cn=y/# CONFIG_PACKAGE_luci-i18n-qbittorrent-simple-zh-cn is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_qbittorrent=y/# CONFIG_PACKAGE_qbittorrent is not set/g' ${HOME_PATH}/.config
    TIME r "您同时选择luci-app-qbittorrent和luci-app-qbittorrent-simple，插件有冲突，相同功能插件只能二选一，已删除luci-app-qbittorrent-simple"
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-advanced=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-fileassistant=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-fileassistant=y/# CONFIG_PACKAGE_luci-app-fileassistant is not set/g' ${HOME_PATH}/.config
    TIME r "您同时选择luci-app-advanced和luci-app-fileassistant，luci-app-advanced已附带luci-app-fileassistant，所以删除了luci-app-fileassistant"
   fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-adblock-plus=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-adblock=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-adblock=y/# CONFIG_PACKAGE_luci-app-adblock is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_adblock=y/# CONFIG_PACKAGE_adblock is not set/g' ${HOME_PATH}/.config
    sed -i '/luci-i18n-adblock/d' ${HOME_PATH}/.config
    TIME r "您同时选择luci-app-adblock-plus和luci-app-adblock，插件有依赖冲突，只能二选一，已删除luci-app-adblock"
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-kodexplorer=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-vnstat=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-vnstat=y/# CONFIG_PACKAGE_luci-app-vnstat is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_vnstat=y/# CONFIG_PACKAGE_vnstat is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_vnstati=y/# CONFIG_PACKAGE_vnstati is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_libgd=y/# CONFIG_PACKAGE_libgd is not set/g' ${HOME_PATH}/.config
    sed -i '/luci-i18n-vnstat/d' ${HOME_PATH}/.config
    TIME r "您同时选择luci-app-kodexplorer和luci-app-vnstat，插件有依赖冲突，只能二选一，已删除luci-app-vnstat"
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-ssr-plus=y" ${HOME_PATH}/.config` -ge '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-cshark=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-cshark=y/# CONFIG_PACKAGE_luci-app-cshark is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_cshark=y/# CONFIG_PACKAGE_cshark is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_libustream-mbedtls=y/# CONFIG_PACKAGE_libustream-mbedtls is not set/g' ${HOME_PATH}/.config
    TIME r "您同时选择luci-app-ssr-plus和luci-app-cshark，插件有依赖冲突，只能二选一，已删除luci-app-cshark"
  fi
fi

if grep -q "ssr-plus=y" "${HOME_PATH}/.config" && [[ "${SOURCE}" == "Lienol" ]] && [[ "${REPO_BRANCH}" == "19.07" ]]; then
  sed -i '/plus_INCLUDE_PACKAGE_libustream-wolfssl/d' ${HOME_PATH}/.config
  sed -i '/plus_INCLUDE_libustream-openssl/d' ${HOME_PATH}/.config
  sed -i '/CONFIG_PACKAGE_libustream-openssl=y/d' ${HOME_PATH}/.config
  echo "CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_PACKAGE_libustream-wolfssl=y" >> ${HOME_PATH}/.config
  echo "# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_libustream-openssl is not set" >> ${HOME_PATH}/.config
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_SHORTCUT_FE_CM=y" ${HOME_PATH}/.config` -ge '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_SHORTCUT_FE=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_SHORTCUT_FE=y/# CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_SHORTCUT_FE is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_kmod-fast-classifier=y/# CONFIG_PACKAGE_kmod-fast-classifier is not set/g' ${HOME_PATH}/.config
    TIME r "luci-app-turboacc同时选择Include Shortcut-FE CM和Include Shortcut-FE，有冲突，只能二选一，已删除Include Shortcut-FE"
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_wpad-openssl=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_wpad=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_wpad=y/# CONFIG_PACKAGE_wpad is not set/g' ${HOME_PATH}/.config
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_antfs-mount=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_ntfs3-mount=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_antfs-mount=y/# CONFIG_PACKAGE_antfs-mount is not set/g' ${HOME_PATH}/.config
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_dnsmasq-full=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_dnsmasq=y" ${HOME_PATH}/.config` -eq '1' ]] || [[ `grep -c "CONFIG_PACKAGE_dnsmasq-dhcpv6=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_dnsmasq=y/# CONFIG_PACKAGE_dnsmasq is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_dnsmasq-dhcpv6=y/# CONFIG_PACKAGE_dnsmasq-dhcpv6 is not set/g' ${HOME_PATH}/.config
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-samba4=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-samba=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_autosamba=y/# CONFIG_PACKAGE_autosamba is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-app-samba=y/# CONFIG_PACKAGE_luci-app-samba is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-i18n-samba-zh-cn=y/# CONFIG_PACKAGE_luci-i18n-samba-zh-cn is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_samba36-server=y/# CONFIG_PACKAGE_samba36-server is not set/g' ${HOME_PATH}/.config
    TIME r "您同时选择luci-app-samba和luci-app-samba4，插件有冲突，相同功能插件只能二选一，已删除luci-app-samba"
  fi
elif [[ `grep -c "CONFIG_PACKAGE_samba4-server=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  echo "# CONFIG_PACKAGE_samba4-admin is not set" >> ${HOME_PATH}/.config
  echo "# CONFIG_PACKAGE_samba4-client is not set" >> ${HOME_PATH}/.config
  echo "# CONFIG_PACKAGE_samba4-libs is not set" >> ${HOME_PATH}/.config
  echo "# CONFIG_PACKAGE_samba4-server is not set" >> ${HOME_PATH}/.config
  echo "# CONFIG_PACKAGE_samba4-utils is not set" >> ${HOME_PATH}/.config
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-dockerman=y" ${HOME_PATH}/.config` -eq '0' ]] || [[ `grep -c "CONFIG_PACKAGE_luci-app-docker=y" ${HOME_PATH}/.config` -eq '0' ]]; then
  echo "# CONFIG_PACKAGE_luci-lib-docker is not set" >> ${HOME_PATH}/.config
  echo "# CONFIG_PACKAGE_luci-i18n-dockerman-zh-cn is not set" >> ${HOME_PATH}/.config
  echo "# CONFIG_PACKAGE_docker is not set" >> ${HOME_PATH}/.config
  echo "# CONFIG_PACKAGE_dockerd is not set" >> ${HOME_PATH}/.config
  echo "# CONFIG_PACKAGE_runc is not set" >> ${HOME_PATH}/.config
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-theme-argon=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  pmg="$(echo "$(date +%M)" | sed 's/^.//g')"
  mkdir -p ${HOME_PATH}/files/www/luci-static/argon/background
  cp -f ${GITHUB_WORKSPACE}/source/img/*.png ${HOME_PATH}/files/www/luci-static/argon/background
  if [[ $? -ne 0 ]]; then
    echo "拉取文件错误,请检测网络"
    exit 1
  fi
  if [[ `grep -c "CONFIG_PACKAGE_luci-theme-argon_new=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-theme-argon_new=y/# CONFIG_PACKAGE_luci-theme-argon_new is not set/g' ${HOME_PATH}/.config
    TIME r "您同时选择luci-theme-argon和luci-theme-argon_new，插件有冲突，相同功能插件只能二选一，已删除luci-theme-argon_new"
  fi
  if [[ `grep -c "CONFIG_PACKAGE_luci-theme-argonne=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-theme-argonne=y/# CONFIG_PACKAGE_luci-theme-argonne is not set/g' ${HOME_PATH}/.config
    TIME r "您同时选择luci-theme-argon和luci-theme-argonne，插件有冲突，相同功能插件只能二选一，已删除luci-theme-argonne"
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-sfe=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-flowoffload=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_DEFAULT_luci-app-flowoffload=y/# CONFIG_DEFAULT_luci-app-flowoffload is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-app-flowoffload=y/# CONFIG_PACKAGE_luci-app-flowoffload is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-i18n-flowoffload-zh-cn=y/# CONFIG_PACKAGE_luci-i18n-flowoffload-zh-cn is not set/g' ${HOME_PATH}/.config
    TIME r "提示：您同时选择了luci-app-sfe和luci-app-flowoffload，两个ACC网络加速，已删除luci-app-flowoffload"
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_libustream-wolfssl=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_libustream-openssl=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_libustream-wolfssl=y/# CONFIG_PACKAGE_libustream-wolfssl is not set/g' ${HOME_PATH}/.config
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-unblockneteasemusic=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-unblockneteasemusic-go=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-unblockneteasemusic-go=y/# CONFIG_PACKAGE_luci-app-unblockneteasemusic-go is not set/g' ${HOME_PATH}/.config
    TIME r "您选择了luci-app-unblockneteasemusic-go，会和luci-app-unblockneteasemusic冲突导致编译错误，已删除luci-app-unblockneteasemusic-go"
  fi
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-unblockmusic=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-unblockmusic=y/# CONFIG_PACKAGE_luci-app-unblockmusic is not set/g' ${HOME_PATH}/.config
    TIME r "您选择了luci-app-unblockmusic，会和luci-app-unblockneteasemusic冲突导致编译错误，已删除luci-app-unblockmusic"
  fi
fi

if [[ `grep -c "CONFIG_TARGET_armvirt=y" ${HOME_PATH}/.config` -eq '1' ]] || [[ `grep -c "CONFIG_TARGET_armsr=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  echo -e "\nCONFIG_TARGET_ROOTFS_TARGZ=y" >> "${HOME_PATH}/.config"
  sed -i 's/CONFIG_PACKAGE_luci-app-autoupdate=y/# CONFIG_PACKAGE_luci-app-autoupdate is not set/g' ${HOME_PATH}/.config
fi

if [[ `grep -c "CONFIG_TARGET_x86=y" ${HOME_PATH}/.config` -eq '1' ]] || [[ `grep -c "CONFIG_TARGET_rockchip=y" ${HOME_PATH}/.config` -eq '1' ]] || [[ `grep -c "CONFIG_TARGET_bcm27xx=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  echo -e "\nCONFIG_PACKAGE_snmpd=y" >> "${HOME_PATH}/.config"
  echo -e "\nCONFIG_TARGET_IMAGES_GZIP=y" >> "${HOME_PATH}/.config"
  echo -e "\nCONFIG_PACKAGE_openssh-sftp-server=y" >> "${HOME_PATH}/.config"
  echo -e "\nCONFIG_GRUB_IMAGES=y" >> "${HOME_PATH}/.config"
  if [[ `grep -c "CONFIG_TARGET_ROOTFS_PARTSIZE=" ${HOME_PATH}/.config` -eq '1' ]]; then
    PARTSIZE="$(grep -Eo "CONFIG_TARGET_ROOTFS_PARTSIZE=[0-9]+" ${HOME_PATH}/.config |cut -f2 -d=)"
    if [[ "${PARTSIZE}" -lt "220" ]];then
      sed -i '/CONFIG_TARGET_ROOTFS_PARTSIZE/d' ${HOME_PATH}/.config
      echo -e "\nCONFIG_TARGET_ROOTFS_PARTSIZE=220" >> ${HOME_PATH}/.config
    fi
  fi
fi
if [[ `grep -c "CONFIG_TARGET_mxs=y" ${HOME_PATH}/.config` -eq '1' ]] || [[ `grep -c "CONFIG_TARGET_sunxi=y" ${HOME_PATH}/.config` -eq '1' ]] || [[ `grep -c "CONFIG_TARGET_zynq=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  echo -e "\nCONFIG_TARGET_IMAGES_GZIP=y" >> "${HOME_PATH}/.config"
  echo -e "\nCONFIG_PACKAGE_openssh-sftp-server=y" >> "${HOME_PATH}/.config"
  echo -e "\nCONFIG_GRUB_IMAGES=y" >> "${HOME_PATH}/.config"
  if [[ `grep -c "CONFIG_TARGET_ROOTFS_PARTSIZE=" ${HOME_PATH}/.config` -eq '1' ]]; then
    PARTSIZE="$(grep -Eo "CONFIG_TARGET_ROOTFS_PARTSIZE=[0-9]+" ${HOME_PATH}/.config |cut -f2 -d=)"
    if [[ "${PARTSIZE}" -lt "220" ]];then
      sed -i '/CONFIG_TARGET_ROOTFS_PARTSIZE/d' ${HOME_PATH}/.config
      echo -e "\nCONFIG_TARGET_ROOTFS_PARTSIZE=220" >> ${HOME_PATH}/.config
    fi
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_libopenssl-devcrypto=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_libopenssl-afalg_sync=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_libopenssl-afalg_sync=y/# CONFIG_PACKAGE_libopenssl-afalg_sync is not set/g' ${HOME_PATH}/.config
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_dnsmasq_full_nftset=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-passwall2_Nftables_Transparent_Proxy=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_dnsmasq_full_nftset=y/# CONFIG_PACKAGE_dnsmasq_full_nftset is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-app-passwall2_Nftables_Transparent_Proxy=y/# CONFIG_PACKAGE_luci-app-passwall2_Nftables_Transparent_Proxy is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_nftables-json=y/# CONFIG_PACKAGE_nftables-json is not set/g' ${HOME_PATH}/.config
  fi
fi

if [[ "${REPO_BRANCH}" == *"18.06"* ]] || [[ "${REPO_BRANCH}" == *"19.07"* ]] || [[ "${REPO_BRANCH}" == *"21.02"* ]] || [[ "${REPO_BRANCH}" == *"22.03"* ]] || [[ "${REPO_BRANCH}" == *"23.05"* ]]; then
  if [[ "${REPO_BRANCH}" == *"22.03"* ]]; then
    sed -i '/CONFIG_PACKAGE_kmod-fs-nfsd=y/d' ${HOME_PATH}/.config
    sed -i '/CONFIG_PACKAGE_kmod-fs-nfs-common-rpcsec=y/d' ${HOME_PATH}/.config
    sed -i '/CONFIG_PACKAGE_kmod-fs-nfs-common=y/d' ${HOME_PATH}/.config
  fi
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Rust_Client=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i '/CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Libev_Client/d' ${HOME_PATH}/.config
    sed -i '/CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Rust_Client/d' ${HOME_PATH}/.config
    sed -i '/CONFIG_PACKAGE_shadowsocks-libev-ss-local/d' ${HOME_PATH}/.config
    sed -i '/CONFIG_PACKAGE_shadowsocks-libev-ss-redir/d' ${HOME_PATH}/.config
    echo -e "\nCONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Libev_Client=y" >> ${HOME_PATH}/.config
    echo -e "\n# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Rust_Client is not set" >> ${HOME_PATH}/.config
    echo -e "\nCONFIG_PACKAGE_shadowsocks-libev-ss-local=y" >> ${HOME_PATH}/.config
    echo -e "\nCONFIG_PACKAGE_shadowsocks-libev-ss-redir=y" >> ${HOME_PATH}/.config
  fi
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Rust_Server=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i '/CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Libev_Server/d' ${HOME_PATH}/.config
    sed -i '/CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Rust_Server/d' ${HOME_PATH}/.config
    sed -i '/CONFIG_PACKAGE_shadowsocks-rust-ssserver/d' ${HOME_PATH}/.config
    echo -e "\nCONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Libev_Server=y" >> ${HOME_PATH}/.config
    echo -e "\n# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Rust_Server is not set" >> ${HOME_PATH}/.config
    echo -e "\n# CONFIG_PACKAGE_shadowsocks-rust-ssserver is not set" >> ${HOME_PATH}/.config
  fi
  if [[ `grep -c "CONFIG_PACKAGE_dns2socks-rust=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_dns2socks-rust=y/# CONFIG_PACKAGE_dns2socks-rust is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_DNS2SOCKS_RUST=y/# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_DNS2SOCKS_RUST is not set/g' ${HOME_PATH}/.config
    echo -e "\nCONFIG_PACKAGE_dns2socks=y" >> ${HOME_PATH}/.config
  fi
  if [[ `grep -c "CONFIG_PACKAGE_shadowsocks-rust-sslocal=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i '/CONFIG_PACKAGE_shadowsocks-rust-sslocal=y/d' ${HOME_PATH}/.config
    echo -e "\n# CONFIG_PACKAGE_shadowsocks-rust-sslocal is not set" >> ${HOME_PATH}/.config
  fi
  if [[ `grep -c "CONFIG_PACKAGE_shadowsocks-rust-ssserver=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i '/CONFIG_PACKAGE_shadowsocks-rust-ssserver=y/d' ${HOME_PATH}/.config
    echo -e "\n# CONFIG_PACKAGE_shadowsocks-rust-ssserver is not set" >> ${HOME_PATH}/.config
  fi
  if [[ `grep -c "CONFIG_PACKAGE_shadowsocks-rust-ssmanager=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i '/CONFIG_PACKAGE_shadowsocks-rust-ssmanager=y/d' ${HOME_PATH}/.config
    echo -e "\n# CONFIG_PACKAGE_shadowsocks-rust-ssmanager is not set" >> ${HOME_PATH}/.config
  fi
  if [[ `grep -c "CONFIG_PACKAGE_shadowsocks-rust-ssurl=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i '/CONFIG_PACKAGE_shadowsocks-rust-ssurl=y/d' ${HOME_PATH}/.config
    echo -e "\n# CONFIG_PACKAGE_shadowsocks-rust-ssurl is not set" >> ${HOME_PATH}/.config
  fi
  if [[ -n "$(grep -E "CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Rust_Client=y" ${HOME_PATH}/.config)" ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Rust_Client=y/# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Rust_Client is not set/g' ${HOME_PATH}/.config
  fi
  if [[ -n "$(grep -E "CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Rust_Server=y" ${HOME_PATH}/.config)" ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Rust_Server=y/# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Rust_Server is not set/g' ${HOME_PATH}/.config
  fi
  if [[ -n "$(grep -E "CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Client=y" ${HOME_PATH}/.config)" ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Client=y/# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Client is not set/g' ${HOME_PATH}/.config
  fi
  if [[ -n "$(grep -E "CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Server=y" ${HOME_PATH}/.config)" ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Server=y/# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Server is not set/g' ${HOME_PATH}/.config
  fi 
fi

if [[ `grep -c "CONFIG_TARGET_ROOTFS_EXT4FS=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  PARTSIZE="$(grep -Eo "CONFIG_TARGET_ROOTFS_PARTSIZE=[0-9]+" ${HOME_PATH}/.config |cut -f2 -d=)"
  if [[ "${PARTSIZE}" -lt "950" ]];then
    sed -i '/CONFIG_TARGET_ROOTFS_PARTSIZE/d' ${HOME_PATH}/.config
    echo -e "\nCONFIG_TARGET_ROOTFS_PARTSIZE=950" >> ${HOME_PATH}/.config
    TIME r "EXT4提示：请注意，您选择了ext4安装的固件格式,而检测到您的分配的固件系统分区过小"
    TIME r "为避免编译出错,已自动帮您修改成950M"
  fi
fi

cd ${HOME_PATH}
make defconfig > /dev/null 2>&1
./scripts/diffconfig.sh > ${CONFIG_TXT}

d="CONFIG_CGROUPFS_MOUNT_KERNEL_CGROUPS=y,CONFIG_DOCKER_CGROUP_OPTIONS=y,CONFIG_DOCKER_NET_MACVLAN=y,CONFIG_DOCKER_STO_EXT4=y, \
CONFIG_KERNEL_CGROUP_DEVICE=y,CONFIG_KERNEL_CGROUP_FREEZER=y,CONFIG_KERNEL_CGROUP_NET_PRIO=y,CONFIG_KERNEL_EXT4_FS_POSIX_ACL=y,CONFIG_KERNEL_EXT4_FS_SECURITY=y, \
CONFIG_KERNEL_FS_POSIX_ACL=y,CONFIG_KERNEL_NET_CLS_CGROUP=y,CONFIG_PACKAGE_btrfs-progs=y,CONFIG_PACKAGE_cgroupfs-mount=y, \
CONFIG_PACKAGE_containerd=y,CONFIG_PACKAGE_docker=y,CONFIG_PACKAGE_dockerd=y,CONFIG_PACKAGE_fdisk=y,CONFIG_PACKAGE_kmod-asn1-encoder=y,CONFIG_PACKAGE_kmod-br-netfilter=y, \
CONFIG_PACKAGE_kmod-crypto-rng=y,CONFIG_PACKAGE_kmod-crypto-sha256=y,CONFIG_PACKAGE_kmod-dax=y,CONFIG_PACKAGE_kmod-dm=y,CONFIG_PACKAGE_kmod-dummy=y,CONFIG_PACKAGE_kmod-fs-btrfs=y, \
CONFIG_PACKAGE_kmod-ikconfig=y,CONFIG_PACKAGE_kmod-keys-encrypted=y,CONFIG_PACKAGE_kmod-keys-trusted=y,CONFIG_PACKAGE_kmod-lib-raid6=y,CONFIG_PACKAGE_kmod-lib-xor=y, \
CONFIG_PACKAGE_kmod-lib-zstd=y,CONFIG_PACKAGE_kmod-nf-ipvs=y,CONFIG_PACKAGE_kmod-oid-registry=y,CONFIG_PACKAGE_kmod-random-core=y,CONFIG_PACKAGE_kmod-tpm=y, \
CONFIG_PACKAGE_kmod-veth=y,CONFIG_PACKAGE_libdevmapper=y,CONFIG_PACKAGE_liblzo=y,CONFIG_PACKAGE_libnetwork=y,CONFIG_PACKAGE_libseccomp=y,CONFIG_PACKAGE_luci-i18n-docker-zh-cn=y, \
CONFIG_PACKAGE_luci-i18n-dockerman-zh-cn=y,CONFIG_PACKAGE_luci-lib-docker=y,CONFIG_PACKAGE_mount-utils=y,CONFIG_PACKAGE_runc=y,CONFIG_PACKAGE_tini=y,CONFIG_PACKAGE_naiveproxy=y, \
CONFIG_PACKAGE_samba36-server=y,CONFIG_PACKAGE_samba4-libs=y,CONFIG_PACKAGE_samba4-server=y"
k=(${d//,/ })
for x in "${k[@]}"; do \
  sed -i "/${x}/d" "${CONFIG_TXT}"; \
done
sed -i '/^$/d' "${CONFIG_TXT}"

# 前面修改的文件改回去
sed -i -E '/^\t/! s/^ +//' "${DEFAULT_PATH}"
[[ -z "$( grep -E 'exit 0' "$DEFAULT_PATH" 2>/dev/null)" ]] && sed -i '$a\exit 0' "${DEFAULT_PATH}"
sed -i -E '/^\t/! s/^ +//' "${ZZZ_PATH}"
[[ -z "$( grep -E 'exit 0' "$ZZZ_PATH" 2>/dev/null)" ]] && sed -i '$a\exit 0' "${ZZZ_PATH}"
}



function Diy_firmware() {
# 远程更新处理固件
if [ "${UPDATE_FIRMWARE_ONLINE}" == "true" ]; then
  cd ${HOME_PATH}
  source $UPGRADE_SH && Diy_Part3
fi
# 编译完毕后,整理固件
cd ${FIRMWARE_PATH}
mkdir -p ipk
cp -rf $(find ${HOME_PATH}/bin/packages/ -type f -name "*.ipk") ipk/ && sync
sudo tar -czf ipk.tar.gz ipk && sync && sudo rm -rf ipk
if [[ -n "$(ls -1 |grep -E 'immortalwrt')" ]]; then
  rename -v "s/^immortalwrt/openwrt/" *
  sed -i 's/immortalwrt/openwrt/g' `egrep "immortalwrt" -rl ./`
fi

for X in $(cat ${CLEAR_PATH} |sed "s/.*${TARGET_BOARD}//g"); do
  rm -rf *"$X"*
done

if [[ -z "$(ls -1 |grep -E 'armvirt')" ]] || [[ -z "$(ls -1 |grep -E 'armsr')" ]]; then
  rename -v "s/^openwrt/${Gujian_Date}-${SOURCE}-${LUCI_EDITION}-${LINUX_KERNEL}/" *
fi
}


function gitsvn() {
cd "${HOME_PATH}"
local A="${1%.git}"
local B="$2"
local branch_name=""
local path_part=""
local url=""
tmpdir="$(mktemp -d)" && C="$HOME_PATH/${tmpdir#*.}"
rm -fr "${tmpdir}"
if [[ $A =~ tree/([^/]+)(/(.*))? ]]; then
    branch_name="${BASH_REMATCH[1]}"
    path_part="${BASH_REMATCH[3]:-}"
elif [[ $A =~ blob/([^/]+)(/(.*))? ]]; then
    branch_name="${BASH_REMATCH[1]}"
    path_part="${BASH_REMATCH[3]:-}"
    ck_name="$(echo "${A}"|cut -d"/" -f4-5)"
elif [[ "$A" == *"github.com"* ]]; then
    branch_name="1"
else
    echo "无效的GitHub URL格式"
    exit 1
fi

if [[ -z "$B" ]]; then
    echo "没设置文件投放路径"
    exit 1
elif [[ "$B" == *"openwrt"* ]]; then
    content="$HOME_PATH/${B#*openwrt/}"
    wenjianjia="${B#*openwrt/}"
elif [[ "$B" == *"./"* ]]; then
    content="$HOME_PATH/${B#*./}"
    wenjianjia="${B#*./}"
else
    content="$HOME_PATH/$B"
    wenjianjia="${B}"
fi

if [[ "$A" == *"tree"* ]] && [[ -n "${path_part}" ]]; then
    url="${A%%/tree/*}"
    file_name="${A##*/}"
    git_laqu="1"
elif [[ "$A" == *"tree"* ]] && [[ -n "${branch_name}" ]] && [[ -z "${path_part}" ]]; then
    url="${A%%/tree/*}"
    file_name="$(echo "${A}" |cut -d"/" -f5)"
    git_laqu="2"
elif [[ "${branch_name}" == "1" ]]; then
    url="${A}"
    file_name="$(echo "${A}" |cut -d"/" -f5)"
    git_laqu="3"
elif [[ "$A" == *"blob"* ]]; then
    url="https://raw.githubusercontent.com/${ck_name}/${branch_name}/${path_part}"
    file_name="${path_part}"
    parent_dir="${wenjianjia%/*}"
    git_laqu="4"
fi

if [[ "${git_laqu}" == "1" ]]; then
    if git clone -q --no-checkout "$url" "$C"; then
      cd "${C}"
      git sparse-checkout init --cone > /dev/null 2>&1
      git sparse-checkout set "${path_part}" > /dev/null 2>&1
      git checkout "${branch_name}" > /dev/null 2>&1
      grep -rl 'include ../../luci.mk' . | xargs -r sed -i 's#include ../../luci.mk#include \$(TOPDIR)/feeds/luci/luci.mk#g'
      grep -rl 'include ../../lang/' . | xargs -r sed -i 's#include ../../lang/#include \$(TOPDIR)/feeds/packages/lang/#g'
      rm -fr "${content}"
      mv "${path_part}" "${content}"
      if [[ $? -ne 0 ]]; then
         echo "${file_name}文件投放失败,请检查投放路径是否正确"
         exit 1
      else
         echo "${file_name}文件下载完成"
      fi
      cd "${HOME_PATH}"
    else
      echo "${file_name}文件下载失败"
      exit 1
    fi
    [[ "${file_name}" == "auto-scripts" ]] && chmod +x "${content}"
    cd "${HOME_PATH}"
    rm -fr "$C"
elif [[ "${git_laqu}" == "2" ]]; then
    rm -fr "${content}"
    if git clone -q --single-branch --depth=1 --branch=${branch_name} ${url} ${content}; then
      echo "${file_name}文件下载完成"
    else
      echo "${file_name}文件下载失败"
      exit 1
    fi
elif [[ "${git_laqu}" == "3" ]]; then
    rm -fr "${content}"
    if git clone -q --depth 1 "${url}" "${content}"; then
      echo "${file_name}文件下载完成"
    else
      echo "${file_name}文件下载失败"
      exit 1
    fi
elif [[ "${git_laqu}" == "4" ]]; then
    [[ ! -d "${parent_dir}" ]] && mkdir -p "${parent_dir}"
    curl -fsSL "${url}" -o "${content}"
    if [[ -s "${content}" ]]; then
      echo "${file_name}文件下载完成"
      chmod +x "${content}"
    else
      echo "${file_name}文件下载失败"
      exit 1
    fi
fi
}




function Diy_menu() {
cd $HOME_PATH
Diy_checkout
Diy_${SOURCE_CODE}
}

function Diy_menu2() {
cd $HOME_PATH
Diy_partsh
}

function Diy_menu3() {
cd $HOME_PATH
Diy_scripts
}

function Diy_menu4() {
cd $HOME_PATH
Diy_profile
}

function Diy_menu5() {
cd $HOME_PATH
Diy_management
Diy_definition
Diy_prevent
}

case "$1" in
  "Diy_menu")
    Diy_menu
    ;;
  "Diy_menu2")
    Diy_menu2
    ;;
  "Diy_menu3")
    Diy_menu3
    ;;
  "Diy_menu4")
    Diy_menu4
    ;;
  "Diy_menu5")
    Diy_menu5
    ;;
  *)
    echo ""
    ;;
esac

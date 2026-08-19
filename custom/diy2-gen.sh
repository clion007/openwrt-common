#!/bin/bash
# Shared diy2-part.sh generation logic.
# Used by builder .github/actions/var (整理编译变量) and custom/first.sh (Diy_three).
# Required env vars: COMPILE_PATH, LINSHI_COMMON, FOLDER_NAME, OPERATES_PATH, GITHUB_ENV

function Diy_Gen_Part2() {
  cp -Rf ${COMPILE_PATH} ${LINSHI_COMMON}/${FOLDER_NAME}
  DIY_PT1_SH="${LINSHI_COMMON}/${FOLDER_NAME}/diy-part.sh"
  DIY_PT2_SH="${LINSHI_COMMON}/${FOLDER_NAME}/diy2-part.sh"
  export DIY_PT1_SH
  export DIY_PT2_SH
  echo "DIY_PT1_SH=${DIY_PT1_SH}" >> ${GITHUB_ENV}
  echo "DIY_PT2_SH=${DIY_PT2_SH}" >> ${GITHUB_ENV}
  echo '#!/bin/bash' > ${DIY_PT2_SH}
  # Note: greps below may legitimately match nothing (e.g. a diy-part.sh
  # using the backtick-egrep form); guard with || true so `set -e` does not abort.
  grep -E '.*export.*=".*"' ${DIY_PT1_SH} >> ${DIY_PT2_SH} || true
  chmod +x ${DIY_PT2_SH}
  source ${DIY_PT2_SH}
  grep -E 'grep -rl '.*'.*|.*xargs -r sed -i' ${DIY_PT1_SH} >> ${DIY_PT2_SH} || true
  sed -i 's/\. |/.\/feeds |/g' ${DIY_PT2_SH}
  grep -E 'grep -rl '.*'.*|.*xargs -r sed -i' ${DIY_PT1_SH} >> ${DIY_PT2_SH} || true
  sed -i 's/\. |/.\/package |/g' ${DIY_PT2_SH}
  sed -i 's?./packagefeeds?./feeds?g' ${DIY_PT2_SH}
  grep -vE '^[[:space:]]*grep -rl '.*'.*|.*xargs -r sed -i' ${DIY_PT1_SH} > tmp && mv tmp ${DIY_PT1_SH} || true
  echo "OpenClash_branch=${OpenClash_branch}" >> ${GITHUB_ENV}
  echo "Mandatory_theme=${Mandatory_theme}" >> ${GITHUB_ENV}
  echo "Default_theme=${Default_theme}" >> ${GITHUB_ENV}
  chmod -R +x ${OPERATES_PATH}
  chmod -R +x ${LINSHI_COMMON}
}

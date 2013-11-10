#!/bin/sh

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy.txt
touch "$RESOURCES_TO_COPY"

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "rsync -rp ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -rp "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename $1 .xcdatamodeld`.momd"
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename $1 .xcdatamodeld`.momd"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
install_resource 'QuadCurveMenu/AwesomeMenu/Images/bg-addbutton-highlighted.png'
install_resource 'QuadCurveMenu/AwesomeMenu/Images/bg-addbutton-highlighted@2x.png'
install_resource 'QuadCurveMenu/AwesomeMenu/Images/bg-addbutton.png'
install_resource 'QuadCurveMenu/AwesomeMenu/Images/bg-addbutton@2x.png'
install_resource 'QuadCurveMenu/AwesomeMenu/Images/bg-menuitem-highlighted.png'
install_resource 'QuadCurveMenu/AwesomeMenu/Images/bg-menuitem-highlighted@2x.png'
install_resource 'QuadCurveMenu/AwesomeMenu/Images/bg-menuitem.png'
install_resource 'QuadCurveMenu/AwesomeMenu/Images/bg-menuitem@2x.png'
install_resource 'QuadCurveMenu/AwesomeMenu/Images/icon-plus-highlighted.png'
install_resource 'QuadCurveMenu/AwesomeMenu/Images/icon-plus-highlighted@2x.png'
install_resource 'QuadCurveMenu/AwesomeMenu/Images/icon-plus.png'
install_resource 'QuadCurveMenu/AwesomeMenu/Images/icon-plus@2x.png'
install_resource 'QuadCurveMenu/AwesomeMenu/Images/icon-star.png'
install_resource 'QuadCurveMenu/AwesomeMenu/Images/icon-star@2x.png'

rsync -avr --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rm "$RESOURCES_TO_COPY"

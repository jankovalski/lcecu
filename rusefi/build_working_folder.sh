#!/bin/bash

#
# file build_working_folder.sh
#

FULL_BUNDLE_FILE="${BUNDLE_FULL_NAME}.zip"

echo "${BUNDLE_FULL_NAME}: Packaging temp/$FULL_BUNDLE_FILE file"

rm -rf temp
mkdir temp

SCRIPT_NAME=build_working_folder.sh
echo "Entering $SCRIPT_NAME"

pwd
# This working folder name starts with 'temp/'
echo "$SCRIPT_NAME: Working folder: $FOLDER"
mkdir $FOLDER

CONSOLE_FOLDER="$FOLDER/console"
DRIVERS_FOLDER="$FOLDER/drivers"
OPENBLT_FOLDER="$CONSOLE_FOLDER/openblt"
update_ts_cacerts_FOLDER="$FOLDER/update-ts-cacerts"

mkdir $CONSOLE_FOLDER
mkdir $DRIVERS_FOLDER
mkdir $OPENBLT_FOLDER
mkdir $update_ts_cacerts_FOLDER
ls -l $FOLDER

# this magic file is created manually using 'make_package2.bat'
wget https://rusefi.com/build_server/st_files/silent_st_drivers2.exe -P $DRIVERS_FOLDER
[ -e $DRIVERS_FOLDER/silent_st_drivers2.exe ] || { echo "$SCRIPT_NAME: ERROR DOWNLOADING silent_st_drivers2.exe"; exit 1; }

if [ -z $INI_FILE_OVERRIDE ]; then
    INI_FILE_OVERRIDE="rusefi.ini"
    echo "$SCRIPT_NAME: No ini_file_override specified"
fi
echo "$SCRIPT_NAME: Will use $INI_FILE_OVERRIDE"

if [ -z $RUSEFI_CONSOLE_SETTINGS ]; then
  echo "$SCRIPT_NAME: No rusefi_console_settings"
else
  echo "Using rusefi_console_settings [$RUSEFI_CONSOLE_SETTINGS]"
  cp $RUSEFI_CONSOLE_SETTINGS $CONSOLE_FOLDER
fi

cp java_console_binary/rusefi_autoupdate.jar $CONSOLE_FOLDER
cp java_console_binary/rusefi_console.jar $CONSOLE_FOLDER
cp java_tools/ts_plugin_launcher/build/jar/rusefi_ts_plugin_launcher.jar $FOLDER
cp simulator/build/rusefi_simulator.exe   $CONSOLE_FOLDER
cp misc/console_launcher/rusefi_autoupdate.exe     $CONSOLE_FOLDER
cp misc/console_launcher/rusefi_console.exe     $CONSOLE_FOLDER
cp misc/console_launcher/rusefi_updater.exe     $FOLDER
cp misc/console_launcher/update-ts-cacerts/* $update_ts_cacerts_FOLDER
cp java_console/*.dll                     $CONSOLE_FOLDER
cp java_console/rusefi.xml                $CONSOLE_FOLDER
cp -r java_console/bin                    $FOLDER
cp firmware/ext/openblt/Host/BootCommander.exe $OPENBLT_FOLDER
cp firmware/ext/openblt/Host/libopenblt.dll    $OPENBLT_FOLDER

cp misc/console_launcher/readme.html      $FOLDER

cp firmware/tunerstudio/generated/$INI_FILE_OVERRIDE $FOLDER
# Unsetting since would not be used anywhere else
INI_FILE_OVERRIDE=""
RUSEFI_CONSOLE_SETTINGS=""

# users probably do not really care for this file
# cp firmware/svnversion.h $FOLDER

cp -r misc/install/openocd $CONSOLE_FOLDER
cp -r misc/install/STM32_Programmer_CLI $CONSOLE_FOLDER
# 407 has additional version of firmware
#cp firmware/deliver/rusefi_no_asserts.bin $FOLDER
#cp firmware/deliver/rusefi_no_asserts.dfu $FOLDER
# just for now - DFU work in progress
#cp firmware/deliver/rusefi_no_asserts.hex $FOLDER

cp firmware/deliver/rusefi.bin $FOLDER

cp firmware/deliver/rusefi.dfu $FOLDER
# just for now - DFU work in progress
cp firmware/deliver/rusefi.hex $FOLDER
if [ -e firmware/deliver/rusefi.elf ]; then
 # ELF is useful for debug bundles
 cp firmware/deliver/rusefi.elf $FOLDER
fi

# bootloader
[ -e firmware/deliver/openblt.bin ] && { cp firmware/deliver/openblt.bin $FOLDER ; }
[ -e firmware/deliver/openblt.dfu ] && { cp firmware/deliver/openblt.dfu $FOLDER ; }
# update srec
[ -e firmware/deliver/rusefi_update.srec ] && { cp firmware/deliver/rusefi_update.srec $FOLDER ; }

if [ -n "$BUNDLE_NAME" ]; then
    mv $FOLDER/rusefi.dfu $FOLDER/rusefi_$BUNDLE_NAME.dfu
fi

[ -e firmware/deliver/rusefi.bin ] || { echo "$SCRIPT_NAME: rusefi.bin not found"; exit 1; }

cd temp

echo "Building bundle"
pwd
zip -r $FULL_BUNDLE_FILE *
[ $? -eq 0 ] || (echo "$SCRIPT_NAME: ERROR INVOKING zip"; exit 1)

echo "$SCRIPT_FILE: Bundle $FULL_BUNDLE_FILE ready"
ls -l $FULL_BUNDLE_FILE

[ -e $FULL_BUNDLE_FILE ] || { echo "$SCRIPT_NAME: ERROR not found $FULL_BUNDLE_FILE"; exit 1; }

cd ..

mkdir -p artifacts
mv temp/$FULL_BUNDLE_FILE artifacts

echo "$SCRIPT_NAME: We are back in root directory"

pwd
echo "Exiting $SCRIPT_NAME"
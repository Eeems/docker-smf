#!/bin/bash
echo "SMF Board URL: ${SMF_BOARD_URL}"
boardurl=$(echo ${SMF_BOARD_URL} | sed -e 's/[\/&]/\\&/g')
sed -i "s/http\:\/\/SMF_BOARD_URL/${boardurl}\//" /var/www/smf/Settings.php
service mysql start
service apache2 start
rawurlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER)
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}
postboardurl=$(rawurlencode "${SMF_BOARD_URL}")
cp /repair_settings.php /var/www/smf
curl "http://localhost/repair_settings.php" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" -H "Accept-Language: en-CA,en;q=0.5" --compressed -H "Referer: ${boardurl}/repair_settings.php" -H "Content-Type: application/x-www-form-urlencoded" -H "Cookie: X-Handle-Time="%"7B"%"22start"%"22"%"3A1525403751.50580692291259765625"%"2C"%"22end"%"22"%"3A1525403751.8645761013031005859375"%"2C"%"22time"%"22"%"3A0.3587691783905029296875"%"7D; PHPSESSID=58279fb04a1f5d878fe4dbf8880557c3" -H "DNT: 1" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1" -H "Pragma: no-cache" -H "Cache-Control: no-cache" --data "flatsettings"%"5Bmaintenance"%"5D=0&flatsettings"%"5Blanguage"%"5D=english&flatsettings"%"5Bcookiename"%"5D=SMFCookie956&dbsettings"%"5BenableCompressedOutput"%"5D=1&dbsettings"%"5BdatabaseSession_enable"%"5D=1&dbsettings"%"5Btheme_default"%"5D=0&flatsettings"%"5Bdb_type"%"5D=mysql&flatsettings"%"5Bdb_server"%"5D=127.0.0.1&flatsettings"%"5Bdb_name"%"5D=smf&flatsettings"%"5Bdb_user"%"5D=smf&flatsettings"%"5Bdb_passwd"%"5D=smfpass&flatsettings"%"5Bssi_db_user"%"5D=&flatsettings"%"5Bssi_db_passwd"%"5D=&flatsettings"%"5Bdb_prefix"%"5D=smf_&flatsettings"%"5Bdb_persist"%"5D=0&flatsettings"%"5Bboardurl"%"5D=${postboardurl}&flatsettings"%"5Bboarddir"%"5D="%"2Fvar"%"2Fwww"%"2Fsmf&flatsettings"%"5Bsourcedir"%"5D="%"2Fvar"%"2Fwww"%"2Fsmf"%"2FSources&dbsettings"%"5BattachmentUploadDir_1"%"5D="%"2Fvar"%"2Fwww"%"2Fsmf"%"2Fattachments&dbsettings"%"5Bavatar_url"%"5D=${postboardurl}avatars&dbsettings"%"5Bavatar_directory"%"5D="%"2Fvar"%"2Fwww"%"2Fsmf"%"2Favatars&dbsettings"%"5Bcustom_avatar_url"%"5D=&dbsettings"%"5Bcustom_avatar_dir"%"5D=&dbsettings"%"5Bsmileys_url"%"5D=${postboardurl}Smileys&dbsettings"%"5Bsmileys_dir"%"5D="%"2Fvar"%"2Fwww"%"2Fsmf"%"2FSmileys&flatsettings"%"5Bcachedir"%"5D="%"2Fvar"%"2Fwww"%"2Fsmf"%"2Fcache&themesettings"%"5Btheme_1_theme_url"%"5D=${postboardurl}Themes"%"2Fdefault&themesettings"%"5Btheme_1_images_url"%"5D=${postboardurl}Themes"%"2Fdefault"%"2Fimages&themesettings"%"5Btheme_1_theme_dir"%"5D="%"2Fvar"%"2Fwww"%"2Fsmf"%"2FThemes"%"2Fdefault&themesettings"%"5Btheme_2_theme_url"%"5D=${postboardurl}Themes"%"2Fcore&themesettings"%"5Btheme_2_images_url"%"5D=${postboardurl}Themes"%"2Fcore"%"2Fimages&themesettings"%"5Btheme_2_theme_dir"%"5D="%"2Fvar"%"2Fwww"%"2Fsmf"%"2FThemes"%"2Fcore&submit=Save+Settings" > /dev/null
rm /var/www/smf/repair_settings.php
pid=$(cat /var/run/apache2/apache2.pid)
tail --pid=$pid -f /dev/null

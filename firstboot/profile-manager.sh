#!/bin/bash
# LuKePicci <github.com/LuKePicci>

propath=/org/gnome/terminal/legacy/profiles:/
defaultold=$(dconf read ${propath}default)

if [[ $1 == switch-by-name ]]
then
  # select default profile by name
  for pro in $(dconf list $propath)
  do
    if [[ $pro != list && $pro != default ]]
    then
      proname=$(dconf read ${propath}${pro}visible-name)
      procommand=$(dconf read ${propath}${pro}custom-command)
      proid=\'${pro:1:-1}\'

      if [[ $proname != "" && $proname == "'$2'" ]]
      then
        echo "switching profile $defaultold"
        echo "                  --> $proid"
        dconf write ${propath}default $proid
        break
      fi
    fi
  done
elif [[ $1 == switch-by-id ]]
then
  # select default profile by id
  echo "switching profile $defaultold"
  echo "                  --> '$2'"
  dconf write ${propath}default \'$2\'
elif [[ $1 == list || $1 == "" ]]
then
  # list custom-commnad profiles
  for pro in $(dconf list $propath)
  do
    if [[ $pro != list && $pro != default ]]
    then
      proname=$(dconf read ${propath}${pro}visible-name)
      procommand=$(dconf read ${propath}${pro}custom-command)
      proid=\'${pro:1:-1}\'

      echo "Profile: $proid, name: $proname, custom command: $procommand"
    fi
  done
  echo "Current default: $defaultold"
elif [[ $1 == set-by-name ]]
then
  # search profile with given name
  for pro in $(dconf list $propath)
  do
    if [[ $pro != list && $pro != default ]]
    then
      proname=$(dconf read ${propath}${pro}visible-name)
      procommand=$(dconf read ${propath}${pro}custom-command)
      proid=\'${pro:1:-1}\'

      if [[ $proname != "" && $proname == "'$2'" ]]
      then
        echo "setting :($proname)/$3 --> \"$4\""
        dconf write ${propath}${pro}$3 "$4"
        break
      fi
    fi
  done
else
echo "Usage:
  $0 [COMMAND [ARGS...]]

Commands:
  help                           Show this information
                                 This is the default command if COMMAND is not
                                 recognized
  list                           List gnome-terminal available profiles and show
                                 current default
                                 This is the default COMMAND if none passed
  switch-by-id ID                Set gnome-terminal profile with given ID as new
                                 default
  switch-by-name NAME            Set gnome-terminal profile named NAME as new
                                 default
  set-by-name PNAME KEY VALUE    Write VALUE into KEY of profile named PNAME
"
fi

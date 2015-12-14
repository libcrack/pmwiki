# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or 
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#!/bin/bash 

if [ $# -ne 1 ]; then 
    echo Usage : doHoove.sh adresse
    exemple : doHoove.sh www.pmwiki.org/wiki/PmWikiFr/PmWikiFr
fi


#dir=`pwd`
basewiki=$1
basephp="pmwiki.php"
entryphp=$basewiki$basephp

safebasewiki=`echo $basewiki | sed 's/\//\\\ \//g' | sed 's/\\\ /\\\/g'`  # putain de sed

echo $basewiki $safebasewiki

echo Cleaning

rm -rf $basewiki

echo Collecting the website

wget -e robots=off -r --level=4 $entryphp


echo Collecting the website Done

echo Name conversion
cd $basewiki 

#dans les noms de fichiers remplacer les ? par Q et les = par E, les & par des e les : par des .
allfiles=`ls -1 pmwiki*`

echo "--------------------"
# on filtre les choses a ne pas traiter
usefulfiles=`ls -1 pmwiki* | grep -v action | grep -v Private | grep -v RecentChanges`

echo Conversion de $usefulfiles

for i in $usefulfiles
do
    ni=`echo $i | sed "s/pmwiki.php?n=/pmwiki.phpQnE/g"`
    echo Convert $i to $ni
    # absolute to relative + css + standard php links + entry link + vire les trucs privés ou non focntionnels
    #
    sed  "s/http:\/\/$safebasewiki//g" $i > $ni.tmp ;   mv $ni.tmp $ni

    # css need updating depending on the wiki
    sed "s/pub\/skins\/pmwiki\/pub\/pmwiki.css/pub\/skins\/pmwiki\/pmwiki.css/g" $ni > $ni.tmp;   mv $ni.tmp $ni

    sed "s/pmwiki.php?n=/pmwiki.phpQnE/g"  $ni  > $ni.tmp;   mv $ni.tmp $ni

    sed "s/Edit<\/a/<\/a/g"  $ni  > $ni.tmp;   mv $ni.tmp $ni
    sed "s/Private<\/a/<\/a/g"  $ni  > $ni.tmp;   mv $ni.tmp $ni
    sed "s/History<\/a/<\/a/g"  $ni  > $ni.tmp;   mv $ni.tmp $ni
    sed "s/Recent Changes<\/a/<\/a/g"  $ni  > $ni.tmp;   mv $ni.tmp $ni
    sed "s/Print<\/a/<\/a/g"  $ni  > $ni.tmp;   mv $ni.tmp $ni
    sed "s/View<\/a/<\/a/g"  $ni  > $ni.tmp;   mv $ni.tmp $ni
    sed "s/edit SideBar<\/a/<\/a/g"  $ni  > $ni.tmp;   mv $ni.tmp $ni
    sed "s/Search<\/a/<\/a/g"  $ni  > $ni.tmp;   mv $ni.tmp $ni
done

rm -v *.tmp

rm -v *Private*

rm -v *RecentChanges

rm -v *action=edit*

rm -v *action=diff*

rm -v *action=print*

cp $entryphp index.html


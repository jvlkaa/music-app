#!/bin/bash

# Author           : Julia Chomicka
# Created On       : 29.05.2022
# Last Modified By : Julia Chomicka
# Last Modified On : 01.06.2022
# Version          : 1.0
#
# Description      : Skrypt imitujący aplikacje do
#		     wyszukiwania plików mp3 po
#		     tagu oraz tworzenia własnych
#		     playlist

version(){
echo "Wersja skryptu: 1.0"
}

help(){
echo ""
echo "Wyszukaj pliki mp3 oraz stwórz własne playlisty"
echo "-h ----> pomoc"
echo "-v ----> informacje o wersji"
echo "-m ----> otwórz menu"
}

#szukanie po artyscie
szukaj_artysta(){
ARTYSTA=$(zenity --entry --title "Wyszukaj" --text "Podaj nazwe artysty piosenki której szukasz" --height 120)
if [ "$ARTYSTA" == "" ]
then
zenity --error --text "Nie podano wartości"
else
cd Piosenki
WYSWIETL=""
for file in *;
do
SZUKANY=$(eyeD3 $file | grep artist)
POM=${#SZUKANY}
MP3=${SZUKANY:8:$POM}
if [ "$ARTYSTA" == "$MP3" ]
then
WYSWIETL+="$file\r\r"
fi
done
if [ "$WYSWIETL" == "" ]
then
zenity --error --text "Brak utworów"
else
zenity --info --text "$WYSWIETL" --title "Lista utworów" --height 200
fi
cd ..
fi
}

#szukanie po tytule
szukaj_tytul(){
TYTUL=$(zenity --entry --title "Wyszukaj" --text "Podaj tytuł piosenki której szukasz" --height 120)
if [ "$TYTUL" == "" ]
then
zenity --error --text "Nie podano wartości"
else
cd Piosenki
WYSWIETL=""
for file in *;
do
SZUKANY=$(eyeD3 $file | grep title)
POM=${#SZUKANY}
MP3=${SZUKANY:7:$POM}
if [ "$TYTUL" == "$MP3" ]
then
WYSWIETL+="$file\r\r"
fi
done
if [ "$WYSWIETL" == "" ]
then
zenity --error --text "Brak utworów"
else
zenity --info --text "$WYSWIETL" --title "Lista utworów" --height 200
fi
cd ..
fi
}

#tworzenie playlisty
stworz(){
PLAYLISTA=$(zenity --entry --title "Stwórz playliste" --text "Podaj nazwe playlisty którą chcesz stworzyć" --height 120)
if [ "$PLAYLISTA" == "" ]
then
zenity --error --text "Nie podano wartosci"
else
cd Piosenki
if [ -f "$PLAYLISTA.m3u" ]
then
zenity --error --text "Playlista o tej nazwie już istnieje"
else
touch "$PLAYLISTA.m3u"
zenity --info --text "Playlista stworzona pomyślnie!"
fi
cd ..
fi
}

#dodawanie do playlisty
dodaj(){
TYTUL=$(zenity --entry --title "Dodaj do playlisty" --text "Podaj tytuł piosenki którą chcesz dodać" --height 120)
ARTYSTA=$(zenity --entry --title "Dodaj do playlisty" --text "Podaj artyste piosenki którą chcesz dodać" --height 120)
PLAYLISTA=$(zenity --entry --title "Dodaj do playlisty" --text "Podaj nazwe playlisty do której chcesz dodać piosenke" --height 120)
if [ "$TYTUL" == "" ] || [ "$ARTYSTA" == "" ] || [ "$PLAYLISTA" == "" ]
then
zenity --error --text "Nie podano wartości"
else
cd Piosenki
if [ -f "$PLAYLISTA.m3u" ]
then
for file in *;
do
SZUKANY1=$(eyeD3 $file | grep artist)
POM1=${#SZUKANY1}
MP31=${SZUKANY1:8:$POM1}
SZUKANY2=$(eyeD3 $file | grep title)
POM2=${#SZUKANY2}
MP32=${SZUKANY2:7:$POM2}
if [ "$TYTUL" == "$MP32" ] && [ "$ARTYSTA" == "$MP31" ]
then
ls -1 $file >> "$PLAYLISTA.m3u"
zenity --info --text "Piosenka dodana do playlisty $PLAYLISTA!"
fi
done
cd ..
else
zenity --error --text "Niepoprawna nazwa playlisty"
fi
fi
}


menu(){
while [ Q==1 ]; do
menu=("Znajdź plik mp3 po artyście" "Znajdź plik mp3 po tytule" "Stwórz playliste" "Dodaj do playlisty" "Zakończ")
odp=$(zenity --list --column=Menu "${menu[@]}" --height 350 --title "MENU")

case "$odp" in
"${menu[0]}" )
szukaj_artysta;;

"${menu[1]}" )
szukaj_tytul;;

"${menu[2]}" )
stworz;;

"${menu[3]}" )
dodaj;;

"${menu[4]}" )
exit;;

esac
done
}


while getopts hvm OPT;
do
case $OPT in
h) help;;
v) version;;
m) menu;;
*)
esac
done




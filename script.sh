#!/bin/bash

# Author           : Milosz ( spoties.wojcik@gmail.com )
# Created On       : 15.01.2021
# Last Modified By : Milosz ( spoties.wojcik@gmail.com )
# Last Modified On : 18.01.2021 
# Version          : 1.0.3
#
# Description      : 
# 
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more # details or contact the Free Software Foundation for a copy)

if [[ $1 = "-h" ]]; then
    echo "Short help instructions :)"
elif [[ $1 = "-v" ]]; then
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "          Version: 1.0.3"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Milosz (spoties.wojcik@gmail.com)"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
elif [[ $1 = "" ]]; then
    option(){
        OPTION=`zenity --list --column=Menu "${MENU[@]}" --width 400 --height 500`
    }

    _SCRIPTPATH = pwd
    SIZE="0"
    FILE=""
    STARTINGPAGE=""
    ENDINGPAGE=""
    OUTPUTNAME=""

    while [ "$OPTION" != "Finish" ] ; do
        MENU=("Pick a file: $FILE"
            "Output PDF name: $OUTPUTNAME"  
            "Starting page number: $STARTINGPAGE"  
            "Ending page number: $ENDINGPAGE"
            "Execute"
            "Finish")
        clear
        option
        re='^[0-9]+$'
            case $OPTION in
                "Pick a file: $FILE")
                    FILE=`zenity --file-selection --file-filter="*.pdf" --title="Select a File"`
                    SIZE="`qpdf --show-npages $FILE`";;
                "Output PDF name: $OUTPUTNAME")
                    OUTPUTNAME=`zenity --entry --text "Enter output PDF name: "`;;
                "Starting page number: $STARTINGPAGE" )
                    STARTINGPAGE=`zenity --entry --text "Enter starting page number: "`;;
                "Ending page number: $ENDINGPAGE")
                    ENDINGPAGE=`zenity --entry --text "Enter ending page number: "`;;
                "Execute")
                    if [[ $ENDINGPAGE == "" ]]; then
                        if [[ $FILE == "" ]]; then
                            zenity --error --width=400 --height=200 --text "You did not pick any file!"
                        elif ! [[ $STARTINGPAGE =~ $re ]]; then
                            STARTINGPAGE=""
                            zenity --error --width=400 --height=200 --text "Page number is not an integer!"
                        elif [[ $STARTINGPAGE > $SIZE ]]; then
                            STARTINGPAGE=""
                            zenity --error --width=400 --height=200 --text "There are no pages with this index!"
                        else
                            if [[ $OUTPUTNAME == "" ]]; then
                                OUTPUTNAME="extracted"
                            fi
                            qpdf $FILE --pages . $STARTINGPAGE -- `pwd`/result_pdfs/$OUTPUTNAME.pdf   
                        fi
                    else
                        if [[ $FILE == "" ]]; then
                            zenity --error --width=400 --height=200 --text "You did not pick any file!"
                        elif [[ $STARTINGPAGE > $ENDINGPAGE ]]; then
                            STARTINGPAGE=""
                            ENDINGPAGE=""
                            zenity --error --width=400 --height=200 --text "Starting page is greater than ending page"
                        elif ! [[ $STARTINGPAGE =~ $re ]]; then
                            STARTINGPAGE=""
                            zenity --error --width=400 --height=200 --text "Starting page number is not an integer!"
                        elif ! [[ $ENDINGPAGE =~ $re ]]; then
                            ENDINGPAGE=""
                            zenity --error --width=400 --height=200 --text "Ending page number is not an integer!"
                        elif [[ $ENDINGPAGE > $SIZE ]]; then
                            ENDINGPAGE=""
                            zenity --error --width=400 --height=200 --text "There are no pages with this index!"
                        else
                            if [[ $OUTPUTNAME == "" ]]; then
                                OUTPUTNAME="extracted"
                            fi
                            qpdf $FILE --pages . $STARTINGPAGE-$ENDINGPAGE -- `pwd`/result_pdfs/$OUTPUTNAME.pdf   
                        fi
                    fi 
            esac
    done
else 
    echo "Unknown option"
fi


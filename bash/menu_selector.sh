#!/bin/bash

options=("Option 1" "Option 2" "Option 3" "Exit")
selected=0

draw_menu() {
    clear
    echo "Select an option (↑ ↓ Enter):"
    echo

    for i in "${!options[@]}"; do
        if [ $i -eq $selected ]; then
            echo -e " ➜ \e[1;32m${options[$i]}\e[0m"
        else
            echo "   ${options[$i]}"
        fi
    done
}

tput civis

while true; do
    draw_menu

    read -rsn1 key

    case "$key" in
        $'\x1b')
            read -rsn2 key2
            case "$key$key2" in
                $'\x1b[A') # ↑
                    if [ $selected -gt 0 ]; then
                        ((selected--))
                    fi
                    ;;
                $'\x1b[B') # ↓
                    if [ $selected -lt $((${#options[@]} - 1)) ]; then
                        ((selected++))
                    fi
                    ;;
            esac
            ;;
        "")
            clear
            echo "You selected: ${options[$selected]}"
            echo

            case "${options[$selected]}" in
                "Option 1")
                    echo "Running option 1..."
                    ;;
                "Option 2")
                    echo "Running option 2..."
                    ;;
                "Option 3")
                    echo "Running option 3..."
                    ;;
                "Exit")
                    echo "Exiting..."
                    tput cnorm
                    exit 0
                    ;;
            esac

            echo
            read -p "Press Enter to return to the menu..."
            ;;
    esac
done

tput cnorm

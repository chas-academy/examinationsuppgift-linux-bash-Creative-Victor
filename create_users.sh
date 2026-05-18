#!/bin/bash

# Kontrollera om scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Du måste köra scriptet som root."
    exit 1
fi

# Loopar igenom alla användarnamn som skrivs in
for username in "$@"; do

    echo "Skapar användare $username"

    # Skapa användaren och hemkatalogen
    useradd -m "$username"

    # Skapa mappar i användarens hemkatalog
    mkdir "/home/$username/Documents"
    mkdir "/home/$username/Downloads"
    mkdir "/home/$username/Work"

    # Skapa welcome.txt
    echo "Välkommen $username" > "/home/$username/welcome.txt"
    echo "Andra användare i systemet:" >> "/home/$username/welcome.txt"

    # Lägg till alla användare från systemet
    cut -d: -f1 /etc/passwd >> "/home/$username/welcome.txt"

    # Ändra ägare på hemkatalogen
    chown -R "$username:$username" "/home/$username"

    # Endast ägaren ska kunna läsa och ändra mapparna
    chmod 700 "/home/$username/Documents"
    chmod 700 "/home/$username/Downloads"
    chmod 700 "/home/$username/Work"

    # Endast ägaren ska kunna läsa och ändra filen
    chmod 600 "/home/$username/welcome.txt"

    echo "$username är klar"

done

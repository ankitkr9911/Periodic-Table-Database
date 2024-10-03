#! /bin/bash

if [[ -z $1 ]];
then
   echo "Please provide an element as an argument."
   exit 0
fi

#Determine if the input is a number (atomic number) or a string(name or symbol)
if [[ $1 =~ ^[0-9]+$ ]];
then
    #if input is a numeric number
    QUERY="SELECT e.atomic_number,e.name,e.symbol,t.type,p.atomic_mass,p.melting_point_celsius,p.boiling_point_celsius
           FROM elements as e
           JOIN properties AS p ON p.atomic_number=e.atomic_number
           JOIN types AS t ON t.type_id=p.type_id
           WHERE e.atomic_number=$1 ;"
else
   #if input is a string
   QUERY="SELECT e.atomic_number,e.name,e.symbol,t.type,p.atomic_mass,p.melting_point_celsius,p.boiling_point_celsius
          FROM elements AS e
          JOIN properties AS p ON p.atomic_number=e.atomic_number
          JOIN types AS t ON t.type_id=p.type_id
          WHERE e.name='$1' OR e.symbol='$1';"
fi

RESULT=$(psql -U freecodecamp -d periodic_table -c "$QUERY" -t -A)

if [[ -z $RESULT ]];
then
   echo "I could not find that element in the database."
else
   echo "The element with atomic number $(echo $RESULT | cut -d'|' -f1) is $(echo $RESULT | cut -d'|' -f2) ($(echo $RESULT | cut -d'|' -f3)). It's a $(echo $RESULT | cut -d'|' -f4), with a mass of $(echo $RESULT | cut -d'|' -f5) amu. $(echo $RESULT | cut -d'|' -f2) has a melting point of $(echo $RESULT | cut -d'|' -f6) celsius and a boiling point of $(echo $RESULT | cut -d'|' -f7) celsius."
fi


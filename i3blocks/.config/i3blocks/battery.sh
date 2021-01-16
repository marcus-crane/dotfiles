#!/bin/bash

BAT=$(acpi -b | grep -E -o '[0-9][0-9]?%')
REMAINING=$(acpi -b | grep -E -o '[0-9][0-9]:[0-9][0-9]')
ADAPTOR=$(acpi -a | grep -E '[A-Za-z]+-[A-Za-z]+')

if [[ ! $REMAINING && ADAPTOR == "on-line" ]]; then
  echo "Battery Charged"
else
  echo "Battery: $BAT ($REMAINING)"
  echo "BAT: $BAT ($REMAINING)"
  [ "${BAT%?}" -le 5 ] && exit 33
  [ "${BAT%?}" -le 20 ] && echo "#FF8000"
fi

exit 0

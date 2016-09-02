if [ ${INSTALL_FROM} = 'ppa' ]; then
  /scripts/install_from_ppa.sh
elif [ ${INSTALL_FROM} = 'source' ]; then
  /scripts/install_from_source.sh
else
  echo "Fail... INSTALL_FROM should be one of 'ppa' or 'source'."
  exit 1
fi

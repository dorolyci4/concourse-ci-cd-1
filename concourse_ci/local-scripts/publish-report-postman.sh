#!/bin/bash
set -e
erreur_validation=0

if [ -z "$COLLECTION_URL" ]; then
  echo -e "Le paramètre COLLECTION_URL doit être renseigné."
  erreur_validation=1
fi

#if [ -z "$ENVIRONMENT_URL" ]; then
#  echo -e "Le paramètre ENVIRONMENT_URL doit être renseigné."
#  erreur_validation=1
#fi

if [ -z "$erreur_validation" == "1" ]; then
  echo -e "ARRÊT DU TRAITEMENT."
  exit 1
fi

echo "Checking for NPM"
echo " Node Version: "$(node -v)
echo " NPM Version: "$(npm -v)
echo " Newman Version: "$(newman --version)

echo "Test Environment"
echo " Collection URL: " $COLLECTION_URL
echo " ENVIRONMENT URL: " ENVIRONMENT_URL

# Fonction qui permet de valider et de définir le statut de la job Concourse (à appeler à la fin du script)
function setExitStatus {
    if [ $NEWMAN_STATUS -eq 0 ]
     then
       exit 0 #Succes
     else
       exit $NEWMAN_STATUS # Echec
    fi
}
echo "Install newman html-reporter."
echo "npm install -g newman."
npm i -g newman
npm i newman-collection
npm i newman-env
npm i -D jest-runner-newman
echo "npm install -g newman-reporter-htmlextra."
npm i -g newman-reporter-htmlextra
echo "**********************PWD************ DEBUT"
pwd
echo "run newman"
echo $COLLECTION_URL
#newman run $COLLECTION_URL -e $ENVIRONMENT_URL -r htmlextra
newman run $COLLECTION_URL \
 #      -e $ENVIRONMENT_URL \
       $NEWMAN_ADDITIONAL_ARGS
echo "**********************PWD************ FIN"
pwd

echo " recherche1"
find /reports
echo " recherche2"
find /report

echo " deplacement reports"
cd reports
ls /reports/


NEWMAN_STATUS=$?
trap set setExitStatus EXIT


#!/bin/bash
# Manages the Circulation Manager database (either initializing it, migrating
# it, or ignoring it) when the container starts and before the app launches.

set -ex

WORKDIR=/var/www/circulation
BINDIR=$WORKDIR/bin
CORE_BINDIR=$WORKDIR/core/bin

su simplified <<EOF
# Default value 'ignore' does nothing.
if ! [[ $SIMPLIFIED_DB_TASK == "ignore" ]]; then

  # Enter the virtual environment for the application.
  source $WORKDIR/env/bin/activate;

  if [[ $SIMPLIFIED_DB_TASK == "init" ]] && [[ -f ${BINDIR}/util/initialize_instance ]]; then
    # Initialize the database with value 'init'
    ${BINDIR}/util/initialize_instance;

  elif [[ $SIMPLIFIED_DB_TASK == "migrate" ]] && [[ -f ${CORE_BINDIR}/migrate_database ]]; then
    # Migrate the database with value 'migrate'
    ${CORE_BINDIR}/migrate_database;

  # Raise an error if any other value is sent
  else echo "Unknown database task '${SIMPLIFIED_DB_TASK}' requested" && exit 127;
  fi;

fi;
EOF

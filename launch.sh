#!/usr/bin/env bash

THIS_DIR=$(cd $(dirname $0); pwd)
cd $THIS_DIR

update() {
  git pull
}

install() {
  cd tg
  ./configure && make

  RET=$?; if [ $RET -ne 0 ]; then
    echo "Error. Exiting."; exit $RET;
  fi
  cd ..
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "update" ]; then
  update
else
  if [ ! -f ./tg/telegram.h ]; then
    echo "tg not found"
    echo "Run $0 install"
    exit 1
  fi

  if [ ! -f ./tg/bin/telegram-cli ]; then
    echo "tg binary not found"
    echo "Run $0 install"
    exit 1
  fi
  rm -r ../.telegram-cli/state #Prevent tg from crash
  ./tg/bin/telegram-cli -k ./tg/tg-server.pub -s ./bot/seedbot.lua -l 1 -E $@
fi

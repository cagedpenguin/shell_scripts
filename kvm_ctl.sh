#!/bin/bash

if [ "$1" == "list" ]; then
  virsh list --all
fi

if [ "$1" == "installable" ]; then
  osinfo-query os
fi

if [ "$1" == "start" ]; then
  if [ -z "$2" ]; then
    echo "$0 start name_of_virtual"
    echo "--- LIST ---"
    virsh list --all
  fi
  if [ ! -z "$2" ]; then
    virsh start $2
  fi
fi

if [ "$1" == "stop" ]; then
  if [ -z "$2" ]; then
    echo "$0 stop name_of_virtual"
    echo "--- LIST ---"
    virsh list --all
  fi
  if [ ! -z "$2" ]; then
    virsh destroy $2
  fi
fi

if [ "$1" == "delete" ]; then
  if [ -z "$2" ]; then
    echo "$0 delete name_of_virtual"
    echo "--- LIST ---"
    virsh list --all
  fi
  if [ ! -z "$2" ]; then
    #virsh undefine $2 --remove-all-storage
    virsh undefine $2
  fi
fi

if [ "$1" == "display" ]; then
  if [ -z "$2" ]; then
    echo "$0 display name_of_virtual"
    echo "--- LIST ---"
    virsh list --all
  fi
  if [ ! -z "$2" ]; then
    virsh vncdisplay $2
  fi
fi

if [ -z "$1" ]; then
  echo "$0 {list|installable|start|stop|delete|display}"
fi

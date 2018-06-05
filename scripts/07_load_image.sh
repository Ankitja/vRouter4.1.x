#!/bin/bash
# Loads Ocata openstack image
#TODO: Add check for existing image and remove from server-manager
echo "Making JSON config directory"
cd ${PWD}/../
if [ $(ls | grep "confs") == "confs" ]; then
	rm -r confs/*
else
	mkdir confs
fi

echo "Copying and updating config templates"
cp ${PWD}/clusterconf/2node_cluster/* ${PWD}/confs
IMAGE="${PWD}/confs/image.json"
DIR='s,<docker_path>,'${PWD}'/contrail-cloud-docker_4.1.0.0-8-ocata_xenial.tgz,g'
sed -i $DIR $IMAGE

echo "Downloading OpenStack Image"
#wget http://172.26.1.131/nas/vrouter4/contrail-cloud-docker_4.1.0.0-8-ocata_xenial.tgz

echo "Adding image to server manager"
server-manager add image -f $IMAGE

echo "Waiting for image upload"
LAST="start"
while [ $(docker image list | grep main | wc -l) != "57" ]; do
	CURRENT=$(docker image list | grep main | wc -l)
	if [ "${CURRENT}" != "${LAST}" ]; then 
		echo  "Docker image no: $CURRENT"
		LAST=$CURRENT
	fi
done
echo "Instalation complete"
sleep 1
server-manager display image

#!/usr/bin/env zsh

username="PLACEHOLDER_USERNAME"
password="PLACEHOLDER_PASSWORD"
host="PLACEHOLDER_HOST"
 
mkdir /nas
mkdir /nas/synology
mkdir /nas/synology/TVShows
 
mount_afp 'afp://$username:$password@$host/TVShows' /nas/synology/TVShows;
 
mkdir /nas/synology/Movies
 
mount_afp 'afp://$username:$password@$host/Movies' /nas/synology/Movies;
 
mkdir /nas/synology/Documentaries
 
mount_afp 'afp://$username:$password@$host/Documentaries' /nas/synology/Documentaries
 
exit 0
 
#
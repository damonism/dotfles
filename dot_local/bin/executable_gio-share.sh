#! /bin/bash
#
#  User script for mounting and unmounting a samba share 
#
#  - No fstab entry
#  - No mount units
#  - Easy customization
#  - Symlinks are located in designated folder (default: $HOME/SMBLinks)
#  - Symlink can be named  (default: $SHARENAME)
#  - Using `-u` argument will unmount and remove the symlink
#  - Option for providing credentials
#  - Option for a user service to mount at login
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# @linux-aarhus - root.nix.dk
# See: https://github.com/pheiduck/smb-share

###########################################
# NECESSARY -  MODIFY THESE VARIABLES

# your samba server's hostname or IP address
HOST="jervis.local"

# the share name on the server
SHARENAME=$1

# credentials
USERNAME=
WORKGROUP=
PASSWD=

SMBCREDENTIALS="$HOME/.config/samba/smbcredentials"

###########################################
# don't modify below this line 
#  - unless you know what you are doing

LINKNAME="$SHARENAME"
SYMLINKS="$HOME/Network"
SCRIPTNAME=$(basename "$0")
VERSION="0.2"

# check argument $1
if [[ "$2" == "-u" ]]; then
    # remove symlink
    rm -f "$SYMLINKS/$LINKNAME"
    # unmount share
    gio mount -u "smb://$HOST/$SHARENAME"
    exit
elif [[ $1 == "" ]]; then
    echo ":: $SCRIPTNAME v$VERSION"
    echo "==> invalid argument: $1"
    echo "Usage: "
    echo "  mount SMB : $SCRIPTNAME"
    echo "  umount SMB: $SCRIPTNAME -u"
    exit 1
fi

# ----------------------------------------------------------------
# mount command
if  [ -f "$SMBCREDENTIALS" ]; then
    # create credentials file
    # mount and feed the credentials to the mount command
    gio mount "smb://$HOST/$SHARENAME" < $SMBCREDENTIALS
else
    # mount (if credentials are required you will be prompted
    gio mount "smb://$HOST/$SHARENAME"
fi
# ----------------------------------------------------------------

# easy reference to gio mount point
ENDPOINT=/run/user/$UID/gvfs/''smb-share:server=$HOST,share=$SHARENAME''

# crete the subfolder
if ! [ -d "$SYMLINKS" ]; then
    # use --parents to suppress warnings if folder exist
    mkdir -p "$SYMLINKS"
fi

# use --force argument to suppress warning if link exist
ln -sf "$ENDPOINT" "$SYMLINKS/$LINKNAME"

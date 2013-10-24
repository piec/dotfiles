#!/bin/bash
#################################
### Please enter your API keys in
### a file with
### APIKEYS="key1 key2 ..."
### in follow files or options
### 
### /etc/nomyan.key
### ~/.nomyan.key
### or as option -k
#################################

# a simple logger function
function logger {
LOGLINE="`date +%Y-%m-%d_%H:%M:%S` [$$] $@"
[[ -z $NOLOG ]] && echo -e $LOGLINE >> $LOGFILE
[[ -n $VERBOSE ]] && echo -e $LOGLINE
}

# some default settings
filename=$(basename "$0")
basename=${filename%.*}
LOGFILE="$basename.log"
PRIORITY=0
PINGHOST="4.2.2.3"
NOTIFYURL="https://nma.usk.bz/publicapi/notify"
CURL=$(which curl)
WGET=$(which wget)
[[ -z $CURL && -z $WGET ]] && logger "Neither curl nor wget installed" && exit 1

function usage {
cat << EOF
usage: $filename application event description

This script notifies your android devices via Notify-My-Android app.

OPTIONS:
	-h	Prints this usage
	-k	Specify the API keys (overrides API keyfiles)
	-l	Specify logfile
	-L	Disable Logging to file
	-p	Specify priority (-2 to 2)
	-t	Specify the content-type
	-u	Specify a URL/URI
	-v	Verbose output
EOF
exit 3
}

# check default paths for keyfiles
# keyfile in $HOME will override keyfile in /etc/
# keyfile specified in -k option overrides everything
[[ -r /etc/$basename.key ]] && . /etc/$basename.key
[[ -r ~/.$basename.key ]] && . ~/.$basename.key

while getopts "hik:l:Lp:t:u:v" OPTION
do
	case $OPTION in
	h)
		# print the help (usage)
		usage
		exit 1
		;;
	i)
		# ping check
		ping -qc1 $PINGHOST > /dev/null 2> /dev/null
		[[ $? -ne 0 ]] && logger "No connection to ping host." && exit 5
		;;
	k)
		# set apikey from option
		APIKEY=$OPTARG
		;;
	l)
		# specify logfile
		LOGFILE=$OPTARG
		;;
	L)
		# disable logging to file
		NOLOG=0
		;;
	p)
		# set priority
		PRIORITY=$OPTARG
		[[ $PRIORITY -lt -2 || $PRIORITY -gt 2 ]] && logger "The priority must be between -2 and 2." && exit 6
		;;
	t)
		# specify optional content-type
		CONTENTTYPE="--data-ascii content-type=$OPTARG"
		;;
	u)
		# specify optional url
		URL="--data-ascii url=$OPTARG"
		;;
	v)
		# enable verbose logging
		VERBOSE=1
		;;
	?)
		# print usage on unknown command
		usage
		;;
	esac
done

# shift parsed options for easy use of $1,$2 and $3
shift $((OPTIND-1))

# check if API keys are set, if not print usage
[[ -z $APIKEYS ]] && logger "No API keys specified." && logger "Please create API keyfiles or use -k option" && usage

# check for right number of arguments
[[ ! $# -eq 3 ]] && logger "Wrong number of arguments." && usage

# iterate over API keylist
for d in $APIKEYS; do
	# send notifcation
	# check if curl is installed ($(which curl) returned nothing)
	if [[ -n $CURL ]]; then
		# if curl is installed use curl
		NOTIFY="`$CURL -s --data-ascii apikey=$d --data-ascii application="$1" --data-ascii event="$2" --data-asci description="$3" --data-ascii priority=$PRIORITY $URL $CONTENTTYPE $NOTIFYURL -o- | sed 's/.*success code="\([0-9]*\)".*/\1/'`"
	else
		# if curl is not intalled use wget
		# one of them must be installed because of previous check
		NOTIFY="`$WGET -q -O- --post-data "apikey=$d&application=$1&event=$2&description=$3&priority=$PRIORITY $URL $CONTENTTYPE" $NOTIFYURL | sed 's/.*success code="\([0-9]*\)".*/\1/'`"
	fi
	# handle return code
	case $NOTIFY in
		200)
		logger "Notification submitted to API key $d."
		;;
		400)
		logger "The data supplied is in the wrong format, invalid length or null."
		exit 400
		;;
		401)
		logger "None of the API keys provided were valid."
		exit 401
		;;
		402)
		logger "Maximum number of API calls per hour exceeded."
		exit 402
		;;
		500)
		logger "Internal server error. Please contact our support if the problem persists."
		exit 500
		;;
		*)
		logger "An unexpected error occured."
		exit 9001
		;;
	esac
done
exit 0

#!/bin/bash

# Copyright (c) 2012, Haggis
# Copyright (c) 2014, Nikos Papakonstantinou <npapak@gmail.com>
# -Add colors in distribution logos
# -Support for SSH sessions
# -Bug fixes
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met :
#
#   * Redistributions of source code must retain the above copyright notice,
#     this list of conditions and the following disclaimer.
#   * Redistributions in binary form must reproduce the above copyright notice,
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#   * Neither the name of any individual or organization nor the names of its
#     contributors may be used to endorse or promote products derived from this
#     software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# ( INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION ) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT ( INCLUDING NEGLIGENCE OR OTHERWISE ) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

########################################################################
#                           Global Variables                           #
########################################################################

unset os         # Human-readable (pretty) name of the operating system
unset host       # Hostname
unset kernel     # Linux kernel build string

unset days       # Days the system has been online
unset hours      # Hours the system has been online (in relation to days)
unset label      # Precision of days, hours, minutes, or seconds
unset day_label  # day/days
unset hour_label # hour/hours

unset totalram   # Size of installed RAM in kilabytes
unset ram        # Size of installed RAM in megabytes
unset free	# Size of used RAM in megabytes
unset user       # Name of the user running this script
unset res        # Resolution of the current X session
unset load       # Load average since the last reboot
unset cpu        # CPU identifier information
unset temp       # CPU temperature

unset de         # Desktop environment (or window manager) running
unset ver        # DE version information, if available

########################################################################
#                           Primary Functions                          #
########################################################################

# Print a pretty logo for the Linux distribution the user is running.
function print_logo
{
	exists=`ls /etc/ | grep "\-release" | wc -l`
	if [ "$exists" -gt "0" ]; then
		#if [ -e /etc/*-release ]; then
		id="$(cat /etc/*-release | grep -E '^ID[ ]*=[ ]*[A-Za-z]+[ ]*' | cut -d '=' -f 2)"
		case $id in
			ubuntu)
				echo -e " \e[38;5;202m             ..::::::..               \e[0m"
				echo -e " \e[38;5;202m         .;::::::::::::::;.           \e[0m"
				echo -e " \e[38;5;202m      .;::::::::::::::''':::;.        \e[0m"
				echo -e " \e[38;5;202m    .;::::::::;:::::;.   .::::;.      \e[0m"
				echo -e " \e[38;5;202m   .:::::::::;;.     \`...:::::::.     \e[0m"
				echo -e " \e[38;5;202m  .:::::::'  ;:;::::,.   .:::::::.    \e[0m"
				echo -e " \e[38;5;202m  ;::::::   ,::::::::::.   ::::::;    \e[0m"
				echo -e " \e[38;5;202m  :::   \`.  ::::::::::::....::::::    \e[0m"
				echo -e " \e[38;5;202m  :::   .'  ::::::::::::::::::::::    \e[0m"
				echo -e " \e[38;5;202m  ;::::::   \`::::::::::    ::::::;    \e[0m"
				echo -e " \e[38;5;202m  .:::::::.  .:,;::;,'   .:::::::.    \e[0m"
				echo -e " \e[38;5;202m   .:::::::;;;;'      ,.,:::::::.     \e[0m"
				echo -e " \e[38;5;202m     ;::::::::;:::::;;   .::::;       \e[0m"
				echo -e " \e[38;5;202m      .;::::::::::::::;.::::;.        \e[0m"
				echo -e " \e[38;5;202m         .,::::::::::::::,.           \e[0m"
				echo -e " \e[38;5;202m            \`::::::::::'               \e[0m"
				echo -e " \e[38;5;202m                                      \e[0m"
				;;
			debian)
				echo -e "\e[1;31m              _,met\$\$\$\$\$gg.            \e[0m"
				echo -e "\e[1;31m           ,g\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$P.         \e[0m"
				echo -e "\e[1;31m         ,g\$\$P\$\$       \$\$\$Y\$\$.\$.       \e[0m"
				echo -e "\e[1;31m        ,\$\$P\`              \`\$\$\$.     \e[0m"
				echo -e "\e[1;31m       ,\$\$P       ,ggs.     \`\$\$b:     \e[0m"
				echo -e "\e[1;31m       d\$\$\`     ,\$P\$\`   .    \$\$\$     \e[0m"
				echo -e "\e[1;31m       \$\$P      d\$\`     ,    \$\$P      \e[0m"
				echo -e "\e[1;31m       \$\$:      \$\$.   -    ,d\$\$\`      \e[0m"
				echo -e "\e[1;31m       \$\$;      Y\$b._   _,d\$P\`        \e[0m"
				echo -e "\e[1;31m       Y\$\$.     .\`\$Y\$\$\$\$P\$\`          \e[0m"
				echo -e "\e[1;31m       \`\$\$b      \$-.__                \e[0m"
				echo -e "\e[1;31m        \`Y\$\$b                         \e[0m"
				echo -e "\e[1;31m         \`Y\$\$.                        \e[0m"
				echo -e "\e[1;31m           \`\$\$b.                      \e[0m"
				echo -e "\e[1;31m             \`Y\$\$b.                   \e[0m"
				echo -e "\e[1;31m              \`\$Y\$b._                  \e[0m"
				echo -e "\e[1;31m                 \`\$\$\$\$                \e[0m"
				echo -e "\e[1;31m                                       \e[0m"
				;;
			mint)
				echo -e "\e[1;32m.:::::::::::::::::::::::::;,.          \e[0m" 
				echo -e "\e[1;32m,0000000000000000000000000000Oxl,      \e[0m"
				echo -e "\e[1;32m,00,                       ..,cx0Oo.   \e[0m"
				echo -e "\e[1;32m,00,       ,,.                  .cO0o  \e[0m"
				echo -e "\e[1;32m,00l,,.   \`00;       ..     ..    .k0x \e[0m"
				echo -e "\e[1;32m\`kkkkO0l  \`00;    ck000Odlk000Oo.  .00c\e[0m"
				echo -e "\e[1;32m     d0k  \`00;   x0O:.\`d00O;.,k00.  x0x\e[0m"
				echo -e "\e[1;32m     d0k  \`00;  .00x   ,00o   ;00c  d0k\e[0m"
				echo -e "\e[1;32m     d0k  \`00;  .00d   ,00o   ,00c  d0k\e[0m"
				echo -e "\e[1;32m     d0k  \`00;  .00d   ,00o   ,00c  d0k\e[0m"
				echo -e "\e[1;32m     d0k  \`00;   ;;\`   .;;.   .cc\`  d0k\e[0m"
				echo -e "\e[1;32m     d0O  .00d                ...   d0k\e[0m"
				echo -e "\e[1;32m     ;00,  :00x:,,,,        .....   d0k\e[0m"
				echo -e "\e[1;32m      o0O,  .:dO000k...........     d0k\e[0m"
				echo -e "\e[1;32m       :O0x,                        x0k\e[0m"
				echo -e "\e[1;32m         :k0Odc,\`.................;x00k\e[0m"
				echo -e "\e[1;32m           .;lxO0000000000000000000000k\e[0m"
				echo -e "\e[1;32m                 ......................\e[0m"
				echo -e "\e[1;32m                                     \e[0m"
				;;
			fedora)
				echo -e "\e[1;34m                  ___                  \e[0m"
				echo -e "\e[1;34m          ,g@@@@@@@@@@@p,              \e[0m"
				echo -e "\e[1;34m       ,@@@@@@@@@@@D****4@@.           \e[0m"
				echo -e "\e[1;34m     ,@@@@@@@@@@P\`        \`%@.       \e[0m"
				echo -e "\e[1;34m    y@@@@@@@@@@F   ,g@@p.  !3@k        \e[0m"
				echo -e "\e[1;34m   !@@@@@@@@@@@.  !@@@@@@@@@@@@k       \e[0m"
				echo -e "\e[1;34m  :@@@@@@@@@@@@   J@@@@@@@@@@@@@L      \e[0m"
				echo -e "\e[1;34m  J@@@@@@@@@***   \`***@@@@@@@@@@)     \e[0m"
				echo -e "\e[1;34m  J@@@@@@@@@          @@@@@@@@@@)      \e[0m"
				echo -e "\e[1;34m  J@@@@@@@@@@@@   J@@@@@@@@@@@@@L      \e[0m"
				echo -e "\e[1;34m  J@@@@@@@@@@@@   J@@@@@@@@@@@@F       \e[0m"
				echo -e "\e[1;34m  J@@@@@@@@@@@F   {@@@@@@@@@@@F        \e[0m"
				echo -e "\e[1;34m  J@@@E.  \`\`*^\`   i@@@@@@@@@@B^     \e[0m"
				echo -e "\e[1;34m  J@@@@@._      ,@@@@@@@@@@P\`         \e[0m"
				echo -e "\e[1;34m  J@@@@@@@@@@@@@@@@@@BP*\`             \e[0m"
				;;
			*)
				echo -e "                 MMMM                 "
				echo -e "              MMMMMMMMM               "
				echo -e "             MMMMMMMDZDM              "
				echo -e "            MMMMMMMMMMMMM             "
				echo -e "            MMDMMMM$?MMMMM            "
				echo -e "            M,~.MM,,D.MMMM            "
				echo -e "            M.M$NN~MM.NMMM            "
				echo -e "            MO$I??+??$MMMM            "
				echo -e "            M$I??=??$IMMMM            "
				echo -e "            MNZZO$777=DMINM           "
				echo -e "            MO~=77==,..MMMMM          "
				echo -e "           MN..===......MMMMM         "
				echo -e "         MMM............MMMMMM        "
				echo -e "        MMM?~,..,...:~~=.MMMMMM       "
				echo -e "        M8M,............~,MMNMMM      "
				echo -e "       MZM................,D8DMMM     "
				echo -e "       MM......,...........MMMMMM     "
				echo -e "      MMM..................MMMMMM     "
				echo -e "     MMN+..................MMOMMMM    "
				echo -e "     MMM~..................MDMDMM     "
				echo -e "     ???M:...............I?MMMMNM     "
				echo -e " 777I????MM..............IIMMMMM??    "
				echo -e "7?????????MMM...........~7I7$$$I??    "
				echo -e "$I?????????MMM..........~7I?III????I  "
				echo -e "$I??????????+..........MM7??????????? "
				echo -e "7???????????IN......?MMMD7?????????7  "
				echo -e "$77II???????7OMMMMMMMMMM8$I????I7     "
				echo -e "     OZZ$77$OD          DZ$77$Z       "
				echo -e "         D8D              D88         "
				echo -e "                                      "
				;;
		esac
	fi

}

# Collect release information.
function get_release
{
	test=$(lsb_release -a 2>&1 | grep Description:| sed -r 's/Description:"?([^"]+)"?/\1/')
	os=${test#"${test%%[![:space:]]*}"}
	#exists=`ls /etc/ | grep "-release" | wc -l`
	#if [ -f /etc/debian_version ]; then
	#os='Debian'

	#elif [ "$exists" -gt "0" ]; then
	#    os=$(cat /etc/*-release | grep "^PRETTY_NAME=" | sed -r 's/PRETTY_NAME="?([^"]+)"?/\1/')
	#    [ -z "$os" ] && os='Not Found'

	#elif [ "$exists" -gt "0" ]; then
	#if [ "$(cat /etc/*-release | grep "^DISTRIB_ID=" | sed -r 's/DISTRIB_ID="?([^"]+)"?/\1/')" == "LinuxMint" ]; then
	#os='Linux Mint'
	#fi
	#fi
	host=$(uname -n)
	kernel=$(uname -r)
}

# Save the uptime at the time this function is executed.
function get_uptime
{
	# Since uptime changes constantly, save it before parsing so the output is consistent.
	current_uptime="$(uptime)"
	# Parse the uptime snapshot.
	days=$(echo $current_uptime | awk '{print $3}' | sed 's/,//g')
	if [ "$days" = 1 ]; then
		day_label='day'
	else
		day_label='days'
	fi
	hours=$(echo $current_uptime | awk '{print $5}' | sed 's/,//g')
	if [ "$hours" = 1 ]; then
		hour_label='hour'
	else
		hour_label='hours'
	fi
	label=$(echo $current_uptime | awk '{print $4}')
}

# Collect generic system statistics.
function get_system_stats
{
	totalram=$(awk '/MemTotal/{print $2}' /proc/meminfo)
	ram=$((totalram/1024))
	free=$(free -mt | awk {print'$4'} | sed -n -e '2{p;q}')
	user=$(whoami)
	if [ -z "$SSH_CLIENT" ] || [ -z "$SSH_TTY" ]; then
		res=$(xdpyinfo | grep dimensions | awk {'print $2'})
	fi
	load=$(uptime | awk -F 'load average:' '{ print $2 }')
	# AFAIK there is no standard identification strings between CPU architectures.
	case $(arch) in
		x86_64|i386|i486|i586|i686)
			cpu="$(cat /proc/cpuinfo | grep 'model name' | head -n 1 | cut -d ':' -f 2-)"
			;;
		ppc)
			cpu="$(cat /proc/cpuinfo | grep -E '^cpu' | head -n 1 | cut -d ':' -f 2-)"
			cpu="${cpu}   @$(cat /proc/cpuinfo | grep -E '^clock' | head -n 1 | cut -d ':' -f 2-)"
			;;
		arm*)
			cpu=$(cat /proc/cpuinfo | grep 'Processor' | head -n 1 | cut -d ':' -f 2-)
			;;
		*)
			cpu='Unknown'
			;;
	esac
}

# Determine which desktop environment the user is running.
function get_desktop_environment
{
	# $DESKTOP_SESSION in an UNRELIABLE method for determining which
	# desktop environment is running. It is tied to the display manager,
	# not the desktop environment itself. It is useful, though, when it
	# is set.
	if [ -z "$DESKTOP_SESSION" ]; then
		if [ -n "$(ps xo cmd | grep -v 'grep' | grep -E '([/][A-Za-z]+)*[/]{0,1}kdeinit')" ]; then
			DESKTOP_SESSION='kde-plasma'
		elif [ -n "$(ps xo cmd | grep -v 'grep' | grep -E '([/][A-Za-z]+)*[/]{0,1}cinnamon')" ]; then
			DESKTOP_SESSION='cinnamon'
		elif [ -n "$(ps xo cmd | grep -v 'grep' | grep -E '([/][A-Za-z]+)*[/]{0,1}unity')" ]; then
			DESKTOP_SESSION='unity'
		elif [ -n "$(ps xo cmd | grep -v 'grep' | grep -E '([/][A-Za-z]+)*[/]{0,1}gnome-session')" ]; then
			DESKTOP_SESSION='gnome'
		elif [ -n "$(ps xo cmd | grep -v 'grep' | grep -E '([/][A-Za-z]+)*[/]{0,1}lxsession')" ]; then
			DESKTOP_SESSION='LXDE'
		elif [ -n "$(ps xo cmd | grep -v 'grep' | grep -E '([/][A-Za-z]+)*[/]{0,1}xfce.*-session')" ]; then
			DESKTOP_SESSION='xfce'
		elif [ -n "$(ps xo cmd | grep -v 'grep' | grep -E '([/][A-Za-z]+)*[/]{0,1}mate-session')" ]; then
			DESKTOP_SESSION='mate'
		elif [ -n "$(ps xo cmd | grep -v 'grep' | grep -E '([/][A-Za-z]+)*[/]{0,1}openbox')" ]; then
			DESKTOP_SESSION='openbox'
		elif [ -n "$(ps xo cmd | grep -v 'grep' | grep -E '([/][A-Za-z]+)*[/]{0,1}fluxbox')" ]; then
			DESKTOP_SESSION='fluxbox'
		fi
	fi


	if [ -n "$KDE_FULL_SESSION" ]; then
		de='KDE'
		ver=$(kde-open -v | awk '/Platform/ {print $4}')
	elif [ "$DESKTOP_SESSION" == 'cinnamon' ]; then
		de='Cinnamon'
		ver=$(cinnamon --version | cut -d ' ' -f 2)
	elif [ "$DESKTOP_SESSION" == 'ubuntu' ]; then
		de='Unity'
		ver=$(unity --version | cut -d ' ' -f 2)
	elif [ -n "$GNOME_DESKTOP_SESSION_ID" ]; then
		de='GNOME'
		ver=$(gnome-session --version | awk {'print $2'})
	elif [ "$DESKTOP_SESSION" == 'LXDE' ]; then
		de='LXDE'
		ver=$(lxpanel --version | cut -d ' ' -f 2)
	elif [ "$DESKTOP_SESSION" == 'xfce' ]; then
		de='XFCE'
		ver=$(xfce4-session --version | head -n 1 | cut -d ' ' -f 2)
	elif [ "$DESKTOP_SESSION" == 'mate' ]; then
		de='Mate'
		ver=$(mate-session --version | cut -d ' ' -f 2)
	elif [ "$DESKTOP_SESSION" == 'openbox' ]; then
		de='Openbox'
		ver=$(openbox --version | head -n 1 | cut -d ' ' -f 2)
	elif [ "$DESKTOP_SESSION" == 'fluxbox' ]; then
		de='Fluxbox'
		ver=$(fluxbox -version | head -n 1 | cut -d ' ' -f 2)
	else
		de='Not Found'
	fi
}
function get_processes {
processes="$(ps aux --sort -rss | head | awk {'print $11'} | sed -n '2p')"
}

function get_temeprature {
temp="$(sensors | grep 'Core' | awk '{print "["$3"] "}' | tr -d '\n')"
}
########################################################################
#                                 Main                                 #
########################################################################

clear

get_release
get_uptime
get_system_stats
get_temeprature
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
	me='Session Type:'
	de='SSH'
else
	get_desktop_environment
	me='Desktop Enviroment:'
fi
get_processes

print_logo
echo
echo "    $(tput bold)$(tput setaf 4)OS:$(tput sgr0) $os"
echo "    $(tput bold)$(tput setaf 4)Hostname:$(tput sgr0) $host"
if [ "$label" = 'min,' ]; then
	echo "    $(tput bold)$(tput setaf 4)Uptime:$(tput sgr0) $days minutes"
elif [[ "$label" = 'day,' || "$label" = 'days,' ]]; then
	echo "    $(tput bold)$(tput setaf 4)Uptime:$(tput sgr0) $days $day_label, $hours $hour_label"
elif [ "$label" = '2' ]; then
	echo "    $(tput bold)$(tput setaf 4)Uptime:$(tput sgr0) $days hours"
fi
echo "    $(tput bold)$(tput setaf 4)CPU:$(tput sgr0)$cpu"
echo "    $(tput bold)$(tput setaf 4)RAM (used / total):$(tput sgr0) $free $(tput bold)$(tput setaf 4)/$(tput sgr0) $ram $(tput bold)$(tput setaf 4)Mb$(tput sgr0)"
echo "    $(tput bold)$(tput setaf 4)CPU Temperature:$(tput sgr0) $temp"
echo "    $(tput bold)$(tput setaf 4)$me$(tput sgr0) $de $ver"
echo "    $(tput bold)$(tput setaf 4)Logged in as:$(tput sgr0) $user"
echo "    $(tput bold)$(tput setaf 4)Kernel:$(tput sgr0) $kernel"
if [ -z "$SSH_CLIENT" ] || [ -z "$SSH_TTY" ]; then
	echo "    $(tput bold)$(tput setaf 4)Resolution:$(tput sgr0) $res $(tput bold)$(tput setaf 4)pixels$(tput sgr0)"
fi
echo "    $(tput bold)$(tput setaf 4)Load Averages:$(tput sgr0)$load"
echo "    $(tput bold)$(tput setaf 4)Top Process (by memory use): $(tput sgr0)$processes"
echo

#!/bin/sh
#Ibus settings if you need them
#type ibus-setup in terminal to change settings and start the daemon
#delete the hashtags of the next lines and restart
#export GTK_IM_MODULE=ibus
#export XMODIFIERS=@im=dbus
#export QT_IM_MODULE=ibus
#sudo 


# If not running interactively, don't do anything
[[ $- != *i* ]] && return


#my to
colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

# set the colour of the hostname 
PS1="\e[0;31m[\u@\h \W]\$ \e[0m "
export HISTCONTROL=ignoreboth:erasedups

#here  is hostname and  other texts config file
#orginal
#PS1='[\u@\h \W]\$ '
#PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '

#my
#PS1='\[\033[00;36m\][\u\[\033[00;35m\]@\h \W]\[\033[00;32m\]\$\[\033[00m\] '
#PS1='\[\033[01;32m\] \W$ \[\033[00m\]'
#PS1='\[\033[01;32m\] \W $ \[\033[00m\]'
PS1=' \[\033[01;32m\][\[\033[01;37m\] \W\[\033[01;32m\] \$ ] \[\033[00m\]'

#PS1='\[\033[01;36m\]-\[\033[01;35m\]>> \[\033[01;36m\]\W\[\033[00;32m\]\$\[\033[00m\] '
#PS1='\[\033[01;32m\][\u\[\033[01;31m\]@\h \W\[\033[01;36m\]]\[\033[01;31m\]\$\[\033[00m\] '


 #for root
#PS1='\e~[1;31m->> \W$ \e[m'

if [ -d "$HOME/.bin" ] ;
	then PATH="$HOME/.bin:$PATH"
fi

#list
alias nnn='nnn -H -d'
alias reboot='sudo reboot'
alias poweroff='sudo poweroff'
#alias s='sudo '
alias ls='ls --color=auto'

alias uname='uname -a'
alias lsx='ls --color=auto -lh '
alias lsh='ls --color=auto -sh '
alias lsd='ls -a --color=auto -d */'
alias la='ls -a'
alias ll='ls -la'
alias l='ls' 					
alias l.="ls -A | egrep '^\.'"      
#alias ss='ss -natu0Spl   --vsock --xdp '
#fix obvious typo's
alias cd..='cd ..'
alias cp='cp -pv'
alias cocd='cd Documents/onlinecourses/udacity/'
alias ccourse='cd /media/jerome/VG/courses/c'
alias v='vim'
alias c='cat'
alias nv='nvim'
alias n='nano'
#alias sta='sudo /usr/bin/sta'
alias sta='sudo ifup wlp2s0'
#alias stp='sudo /usr/bin/stp'
alias stp='sudo ifdown wlp2s0'
alias re='sudo sh /home/$(whoami)/my\ scripts/re'
alias pm='sh /home/$(whoami)/my\ scripts/pm.sh'
alias p2='sh /home/$(whoami)/my\ scripts/p2.sh'
alias p3='sh /home/$(whoami)/my\ scripts/p3.sh'
alias fp='sh /home/$(whoami)/my\ scripts/fp.sh'
alias ff='sh /home/$(whoami)/my\ scripts/ff.sh'
alias f2='sh /home/$(whoami)/my\ scripts/f2.sh'
alias ssx='ss -natup'
alias gay='whois '

alias tk='sudo sh /home/$(whoami)/my\ scripts/tk.sh'
alias sf='sh /home/$(whoami)/my\ scripts/sf.sh'
#alias sf='sh /home/$(whoami)/my\ scripts/sf.sh'
alias sf2='sh /home/$(whoami)/my\ scripts/sf2.sh'
alias python='firejail --quiet python'
alias pip='firejail --quiet pip'
alias surf='surf -sgta'
alias rdt='sh /home/$(whoami)/my\ scripts/reddit.sh'
alias fb='sh /home/$(whoami)/my\ scripts/facebook.sh'
#alias irssiconf='nano w/palemoon/.irssi/config.RP4P8Z '
alias newsboat='firejail newsboat -r'
#alias newsboat='sh /home/$(whoami)/my\ scripts/newsboat.sh'
alias news='sh /home/$(whoami)/my\ scripts/newsboat.sh'
alias stor='sh /home/$(whoami)/my\ scripts/tor.sh'
alias torset='sudo sh /home/$(whoami)/my\ scripts/ftor.sh'
alias newsurls='vim /opt/BROWSING_DATA/newsboat/.newsboat/urls'
alias newsconf='vim /opt/BROWSING_DATA/newsboat/.newsboat/config'
alias mnt='sudo /usr/bin/mnt'
alias mnt2='sudo /usr/bin/mnt2'
alias mnd='cd /run/media/$(whoami)/ ; ls '
alias lt='sh /home/$(whoami)/my\ scripts/light.sh'
#alias lynx='firejail lynx -crawl    duckduckgo '
alias lynx='firejail /usr/bin/lynx -crawl -dump '
alias w3m='firejail w3m -no-cookie -graph -cols -num -4   www.duckduckgo.com'
alias elinks='firejail elinks  -anonymous duckduckgo.com  '
alias yv='bash /home/$(whoami)/my\ scripts/yt.sh'
#alias yv='rm -rf .config/youtube-viewer; rm -rf .cache/youtube-viewer;  sh /home/$(whoami)/my\ scripts/youtube-viewer'
#alias yv='rm -rf .cache/youtube-viewer ;  /usr/bin/vendor_perl/youtube-viewer'
alias pdw="pwd"
alias man='firejail --quiet  man'


alias rtv='firejail rtv'
alias nsup='bash /home/$(whoami)/my\ scripts/nslookup.sh'
alias nanob='firejail nanob -i www.duckduckgo.com '
## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias palemoon='firejail palemoon'
alias fgrep='fgrep --color=auto'
#alias facecam='sh /home/$(whoami)/my\ scripts/webcam.sh'
alias facecam='firejail mpv  -geometry 420x240+1450+800  --demuxer-lavf-format video4linux2 --demuxer-lavf-o-set input_format=mjpeg av://v4l2:/dev/video0 '
alias facerecord='ffmpeg -f v4l2 -framerate 25 -video_size 640x480 -i /dev/video0 Facecam-record-$(date +%Y)-$(date +%m)-$(date +%d){$(date +%T)}.mp4'
#alias screenrecord='ffmpeg -y -f x11grab -s $(xdpyinfo | awk '/dimensions:/ { print $2; exit }')  -i :0.0 -f alsa -i default  ffmpeg-record-$(date +%Y)-$(date +%m)-$(date +%d){$(date +%T)}.mp4'
alias mp3='firejail mpv --no-video --geometry 300x100'
alias mpvx='firejail mpv --stream-record=$1 "$2" --geometry 700x400'
alias mpvv='sh /home/$(whoami)/my\ scripts/mpv.sh '
alias mpdl=' /home/$(whoami)/my\ scripts/mpdl.sh'
alias pullanime='sh ./scripttest/pullanime.sh '
alias pullmusic='sh ./my\ scripts/pullmusic.sh'
alias yt='sh /home/$(whoami)/my\ scripts/playlists.sh'
alias gogosearch='sh my\ scripts/gogo.sh'
alias nicosearch='sh scripttest/nico.sh'
alias moviessearch='sh scripttest/movies.sh'
alias macx='cd /media/jerome/NR/macx/high-sierra '
alias ip2='firejail --private --noroot --nonewprivs  --quiet wget -Ucurl   -qO- ifconfig.co/ip'
alias cuif='firejail --quiet curl ifconfig.co'
alias ipx='read x; firejail --quiet wget -qO-  "https://ipinfo.io/$x"'
alias yt-add='nano .config/.yt-playlist'
alias mplayer='firejail mplayer -x 700 -y 390'
alias mpv='/usr/bin/mpv   --brightness 7  --no-cache  \
  --video-sync=audio   --vd-lavc-threads=2 --video-sync=audio \
 --geometry  880x495    $@'
alias ai='cd /media/jerome/VG/appimage/'
alias mpv-tor=' firejail  --noprofile --hosts-file=/etc/hosts  --disable-mnt --apparmor --ignore=shell --protocol=unix,inet --ignore=seccomp.drop   --private-cache --no3d --seccomp --read-only=all --noroot --debug --caps.drop=all --shell=none --ipc-namespace --machine-id   --apparmor --private  --nogroups --nonewprivs --noexec=all  --netfilter --blacklist=all --netfilter --netfilter=/etc/firejail/nolocal.net  --private-opt=palemoon --dns=62.152.64.0   --dns=77.232.49.115  --dns=163.172.25.118 --private-etc=hosts,ssl,ca-certificates,proxychains.conf,proxychains4.conf  --private-bin=mpv,youtube-dl,python*,env,tor,torsocks,proxychains4,proxychains --private-dev --private-tmp       \
/usr/bin/proxychains4 /usr/bin/mpv --brightness 7 --user-agent="Mozilla/5.0 (Windows NT 6.1; WOW64; rv:54.0) Gecko/20100101 Firefox/74.0" \
	--user-agent="Mozilla/5.0 (Windows NT 6.1; WOW64; rv:54.0) Gecko/20100101 Firefox/74.0" \
	--user-agent="Mozilla/5.0 (Linux; U; Android 4.1.1; en-gb; Build/KLP) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30" '
alias cls='clear'
alias python='firejailx  --private-etc=group,passwd,nsswitch.conf,ssl,ca-certificates  python '
alias mpvs='firejail --private --disable-mnt --nonewprivs --noexec=all mpv '
alias mpv2='firejail mpv --loop-file=200  --geometry 700x400'
alias mpb='firejail  mpv --ytdl-format=best'
alias aptx='sudo   apt install --no-install-recommends --no-install-suggests' 
alias cmus='firejail --noprofile --noroot --nonewprivs --cpu=0 --net=none cmus'
alias aptrm='sudo  apt autoremove --purge '
alias aptv='apt-cache madison '
alias apts='apt-cache search '
alias workd='sh /home/$(whoami)/my\ scripts/workdir.sh'
alias speedcheck='firejail curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python - '
#alias updatedb='sudo sh /home/$(whoami)/my\ scripts/updatedb.sh'
alias chess='firejail xboard -fcp gnuchess'
alias curl='firejail --quiet curl' 
alias ffdl='sh /home/$(whoami)/my\ scripts/ffdl.sh'
alias ffd='sh /home/$(whoami)/my\ scripts/ffplay-youtube.sh -nodisp '
alias calcurse='firejail calcurse'
alias lsofx='sudo sh /home/$(whoami)/my\ scripts/lsof'
#alias news='firejail newsboat -r'
alias irssi='sh /home/$(whoami)/my\ scripts/irc.sh'
alias mp='firejail mplayer  -loop 100 -autosync 100 '
alias surfx='firejail --noprofile   --seccomp --noroot --nonewprivs --private-tmp --private-cache  --net=none /usr/bin/surf   ' 
# Virtualbox
alias livelinux='sh /home/$(whoami)/my\ scripts/liveqemu.sh '
alias livelinux2='sh /home/$(whoami)/my\ scripts/liveqemu2.sh'
alias vm='sh /home/$(whoami)/my\ scripts/qemu.sh ' 
alias vm2='/usr/bin/qemu-system-x86_64 -vga vmware -monitor stdio  -enable-kvm --cpu host -smp 8,cores=8 -name subnode --sandbox on  -m 2G   -boot d'
#-vga std \
alias firejailx=' firejail   \
--noprofile --protocol=unix,inet \
--env=LD_LIBRARY_PATH=none  --hosts-file=/etc/hosts \
--disable-mnt  \
--private-cache  --seccomp \
--read-only=all --noroot --caps.drop=all --shell=none \
--ipc-namespace --machine-id   \
--noexec=all --noexec=/tmp --nogroups --nonewprivs --netfilter \
--blacklist=all --netfilter --netfilter=/etc/firejail/nolocal.net  \
--private-opt=all --private-etc=nsswitch.conf,hosts,ssl,ca-certificates   \
--private-tmp --dns=1.1.1.1   $@ '

alias virshx='firejail --noprofile --quiet  \
--env=LD_LIBRARY_PATH=none  --hosts-file=/etc/hosts \
--private-cache  --seccomp \
--read-only=all --noroot --caps.drop=all --shell=none \
--ipc-namespace --machine-id   \
--noexec=all --noexec=/tmp --nogroups --nonewprivs --netfilter \
--blacklist=all --netfilter --netfilter=/etc/firejail/nolocal.net  \
--private-opt=all --private-etc=group,passwd,nsswitch.conf,hosts,ssl,ca-certificates   \
--private-tmp --dns=80.80.80.80 --dns=1.1.0.1 --dns=2.2.2.2   \
--private=/opt/BROWSING_DATA/libvirt  virsh' 
alias fchange='sudo /usr/bin/smip.sh'
#alias xm='echo select the drive name ; read x; echo select the mount point ; read y; sudo /usr/bin/mount /dev/sd$x /home/jerome/"$y"' 
#alias xu=' sudo umount /home/jerome/"$@"'
 alias qemu-ssh=' firejail --private="$(pwd)"  \
qemu-system-x86_64 \
-soundhw ac97 \
-k en-us \
-m 8G --sandbox on  \
-smp 6 -enable-kvm \
-net user,hostfwd=tcp::2222-:22 \
-boot c   '
alias qemu-win=' firejail  qemu-system-x86_64 --sandbox on  -soundhw ac97 -smp 6 -enable-kvm -m 8G -vga std  /media/jerome/VG/VirtualBox\ VMs/VirtualBox\ VMs/window/win7.vdi'
alias sx='sudo '
alias qemu-system-x86_64='firejail --private="$(pwd)"  qemu-system-x86_64 --sandbox on  '
alias virtd='cd /media/jerome/NR/VirtualBox\ VMs/iso\ s/'
alias virt2d='cd /media/jerome/PS/windows/linux/'
alias NR='cd /media/jerome/NR'
alias VG='cd /media/jerome/VG'
alias PS='cd /media/jerome/PS'
alias AS='cd /media/jerome/AS'
alias AJ='cd /media/jerome/AJ'
alias mv='mv -v '
alias virtv='cd /media/jerome/NR/VirtualBox\ VMs/'
alias curl-time="firejail curl -I 'https://google.com/' 2>/dev/null | grep -i '^date:' | sed 's/^[Dd]ate: //g'"

alias mac='echo wifi; macchanger -s wlp2s0; echo ethernet; macchanger -s  enp3s0f1; echo local ; macchanger -s lo'
alias vol='amixer | head -5 |tail -1 |cut -d" " -f6'
alias openconf='openbox --reconfigure'
alias video='sh /home/$(whoami)/my\ scripts/videowatch'
#readable output
alias et='exit'
alias df='df -h'
alias wget='firejail --private="$(pwd)"  wget -c  -U "Mozilla/5.0 (Linux; Android 6.0.1; SM-J700M Build/MMB29K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Mobile Safari/537.36" -U "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:54.0) Gecko/20100101 Firefox/74.0" '
alias wgett='firejail wget -c '
alias wgetx='firejail --private  wget -qO-  -Ucurl  '
alias scrapy='firejail --quiet scrapy'
alias dosbox='firejail --quiet dosbox'
alias steam='firejail --quiet steam'
alias cfget='wget   -U "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:39.0) Gecko/20100101 Firefox/39.0" --header="Accept: text/html" --header="Cookie: __cfduid=xpzezr54v5qnaoet5v2dx1ias5xx8m4faj7d5mfg4og; cf_clearance=0n01f6dkcd31en6v4b234a6d1jhoaqgxa7lklwbj-1438079290-3600" -np  -qO-  ' #-r 
alias wgeth='sh /home/$(whoami)/my\ scripts/wgeth.sh'
alias curl='firejail curl '
alias ls='ls -a --color=auto'
alias mutt='firejail mutt'



#free
alias free="free -mt"
alias hexchat='firejail hexchat'
#use all cores
alias uac="sh ~/.bin/main/000*"

#continue download
#alias aria2c='firejail --private=$(pwd) aria2c -x 3 --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.129 Safari/537.36" --user-agent="Mozilla/5.0 (Windows NT 6.1; WOW64; rv:54.0) Gecko/20100101 Firefox/74.0"  -c '
#alias man='firejail --quiet  --noprofile man'
#userlist
alias userlist="cut -d: -f1 /etc/passwd"

#merge new settings
alias merge="xrdb -merge ~/.Xresources"

# Aliases for software managment




# yay as aur helper - updates everything
alias pksyua="yay -Syu --noconfirm"

#ps
alias ps="ps af"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias tor:='proxychains4'
#grub update
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

#improve png
#alias fixpng="find . -type f -name "*.png" -exec convert {} -strip {} \;"

#add new fonts
alias fc='sudo fc-cache -fv'

#copy/paste all content of /etc/skel over to home folder - Beware
alias skel='cp -rf /etc/skel/* ~'
#backup contents of /etc/skel to hidden backup folder in home/user
alias bupskel='cp -Rf /etc/skel ~/.skel-backup-$(date +%Y.%m.%d-%H.%M.%S)'


#quickly kill conkies
alias kc='killall conky'

#hardware info --short
alias hw="hwinfo --short"

#skip integrity check
alias yayskip='yay -S --mflags --skipinteg'
alias trizenskip='trizen -S --skipinteg'

#check vulnerabilities microcode
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'

#get fastest mirrors in your neighborhood                                                       





#mounting the folder Public for exchange between host and guest on virtualbox
alias vbm="sudo mount -t vboxsf -o rw,uid=1000,gid=1000 Public /home/$USER/Public"

#shopt
#youtube-dl
alias youtube-dl='firejail youtube-dl'
alias ytd='firejail  --private="$(pwd)" youtube-dl  --user-agent "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36" \
 --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36" -c ' 
alias yta-aac="youtube-dl --extract-audio --audio-format aac "
alias yta-best="youtube-dl --extract-audio --audio-format best "
alias yta-flac="youtube-dl --extract-audio --audio-format flac "
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a "
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
alias yta-opus="youtube-dl --extract-audio --audio-format opus "
alias yta-vorbis="youtube-dl --extract-audio --audio-format vorbis "
alias yta-wav="youtube-dl --extract-audio --audio-format wav "
alias ytd-playlist='firejail youtube-dl  --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" '
alias ytv-best="youtube-dl -f bestvideo+bestaudio "

#Recent Installed Packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -100"

#Cleanup orphaned packages


#get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"


shopt -s autocd # change to named directory
shopt -s cdspell # autocorrects cd misspellings
shopt -s cmdhist # save multi-line commands in history as single line
shopt -s dotglob
shopt -s histappend # do not overwrite history
shopt -s expand_aliases # expand aliases


#create a file called .bashrc-personal and put all your personal aliases
#in there. They will not be overwritten by skel.
HORIZONTAL=600
VERTICAL=380
#wmctrl -r ":ACTIVE:" -e 0,-1,-1,${HORIZONTAL},${VERTICAL}

[[ -f ~/.bashrc-personal ]] && . ~/.bashrc-personal
	
#neofetch



#bspc node -t pseudo_tiled
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11R6/bin:/usr/local/bin:/home/v$


export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/bin:/usr/local/bin:/bin:/usr/sbin:/bin:/usr/local/bin
PATH=$PATH:/home/$(whoami)/my\ scripts/
PATH=$PATH:/home/$(whoami)/scripttest/
PATH=$PATH:/home/$(whoami)/.local/bin/
PATH=$PATH$( find $HOME/.local/node_modules -type d -printf ":%p" )

#case $TERM in
#   linux) LANG=C ;;
#    *) LANG=ja_JP.UTF-8 ;;
#esac
# export GTK_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
# export QT_IM_MODULE=ibus

#LANG=ja_JP.SHIFT_JIS 
LANG=en_US.UTF-8 
alias wineapimg='/media/jerome/AS/appimage/Wine-4.2-x86_64.AppImage '
shopt -s autocd # change to named directory
shopt -s cdspell # autocorrects cd misspellings
shopt -s cmdhist # save multi-line commands in history as single line
shopt -s dotglob
shopt -s histappend # do not overwrite history
shopt -s expand_aliases # expand aliases
#[ -f ~/.fzf.bash ] && source ~/.fzf.bash
alias lxv='cd /media/jerome/VG/linux\ video/x/x/'
alias am='alsamixer'
#export CPATH=$CPATH:/usr/include/********
#export CPATH=$CPATH:/usr/lib/********

#export http_proxy=socks5://127.0.0.1:9050 HTTP_PROXY=socks5://127.0.0.1:9050
#export https_proxy=socks5://127.0.0.1:9050 HTTPS_PROXY=socks5://127.0.0.1:9050
#
alias sc='service --status-all'

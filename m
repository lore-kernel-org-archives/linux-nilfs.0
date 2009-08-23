From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Fail to mount NILFS.
Date: Sun, 23 Aug 2009 12:23:22 +0900 (JST)
Message-ID: <20090823.122322.09561031.ryusuke@osrg.net>
References: <200908221736.42571.yuri@itinteg.net>
	<20090823.012139.108366726.ryusuke@osrg.net>
	<200908221936.12308.yuri@itinteg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sun_Aug_23_12_23_22_2009_541)--"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <200908221936.12308.yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org

----Next_Part(Sun_Aug_23_12_23_22_2009_541)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On Sat, 22 Aug 2009 19:36:12 +0300, Yuri Chislov wrote:
> On Saturday 22 August 2009 19:21:39 Ryusuke Konishi wrote:
> > What will happen if you run the attached script?
> >
> >  $ chmod +x find-root.sh
> >  $ sudo ./find-root.sh <device> 10938 | tee -a segment-with-root-inode.log
> Done.
> 
> Log file attached.
> 
> Thanks.
> Yuri.

Ah, sorry.  Pattern matching of the script was incomplete.

Could you retry with the revised script?

If the new script find the blocks storing the root inode, it will also
dump them to files like:

ifile-2-seg649-1329203
ifile-2-seg649-1329259
ifile-2-seg649-1329315
ifile-2-seg649-1329372
ifile-2-seg649-1329428
ifile-2-seg649-1329455

Then, we can see if the root inode is actually broken or not.

Thanks,
Ryuske Konishi


----Next_Part(Sun_Aug_23_12_23_22_2009_541)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="find-root.sh"

#!/bin/bash

cmd=`basename $0`
blocksize=4k

function die() { echo "$1" 1>&2; exit 1; }

test -n "$1" -a -n "$2" -a -b "$1" || die "usage: $cmd <device> <segnum>"

dev=$1

for (( i=$2; i >= 0; i-- )); do
    hit=`dumpseg $dev $i | sed -ne '/ino = 6,/,/finfo/{p}' |  sed -ne "/blkoff = 2,/{s/^.* blocknr = \([0-9]\+\).*$/\1/p}"`
    if [ -n "$hit" ]; then
	echo "$cmd: root inode found in segnum=$i"
	dumpseg $dev $i

	for b in $hit; do
	    echo "$cmd: dump root inode block: blocknr=$b"
	    dd if=$dev of=ifile-2-seg${i}-${b} bs=$blocksize skip=$b count=1
	done
	exit 0
    fi
done

die "$cmd: root inode not found"


----Next_Part(Sun_Aug_23_12_23_22_2009_541)--
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

----Next_Part(Sun_Aug_23_12_23_22_2009_541)----

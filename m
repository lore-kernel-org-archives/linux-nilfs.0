From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Fail to mount NILFS.
Date: Sun, 23 Aug 2009 01:21:39 +0900 (JST)
Message-ID: <20090823.012139.108366726.ryusuke@osrg.net>
References: <20090822.204316.57646960.ryusuke@osrg.net>
	<20090822.213438.101583642.ryusuke@osrg.net>
	<200908221736.42571.yuri@itinteg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sun_Aug_23_01_21_39_2009_547)--"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <200908221736.42571.yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org>
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

----Next_Part(Sun_Aug_23_01_21_39_2009_547)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On Sat, 22 Aug 2009 17:36:42 +0300, Yuri Chislov wrote:
> On Saturday 22 August 2009 15:34:38 Ryusuke Konishi wrote:
> > Could you send me the dump log around the segment?
> >
> > If you find an entry like:
> >
> >     finfo
> >       ino = 6, cno = xxxxx, nblocks = x, ndatblk = x
> >         vblocknr = yyyyyy, blkoff = 2, blocknr = xxxxxx
> >       ~~~~~~~              ~~~~~~~~~~
> >    ino = 6 indicates       The root inode is included in this block.
> >    inode metadata file
> >
> > This writeback is suspicious.
> >
> > Thanks,
> > Ryusuke Konishi
> Hi, 
> 
> Attached file with dumpseg output.
> It's look, that root inode in  segnum=10938.
> 
> Thank you.
> Yuri.

The segment in the attached log did not include the root inode.
( The entry with ino = 6, did not include the block with blkoff = 2 )

What will happen if you run the attached script?

 $ chmod +x find-root.sh
 $ sudo ./find-root.sh <device> 10938 | tee -a segment-with-root-inode.log

Thanks,
Ryusuke Konishi

----Next_Part(Sun_Aug_23_01_21_39_2009_547)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="find-root.sh"

#!/bin/bash

cmd=`basename $0`

function die() { echo "$1" 1>&2; exit 1; }

test -n "$1" -a -n "$2" -a -b "$1" || die "usage: $cmd <device> <segnum>"

dev=$1

for (( i=$2; i >= 0; i-- )); do
    if dumpseg $dev $i | sed -ne '/ino = 6/,/finfo/{p}' | grep -q "blkoff = 2,";  then
	echo "$cmd: root inode found in segnum=$i"
	dumpseg $dev $i
	exit 0
    fi
done

die "$cmd: root inode not found"


----Next_Part(Sun_Aug_23_01_21_39_2009_547)--
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

----Next_Part(Sun_Aug_23_01_21_39_2009_547)----

From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Kernel Bug after corrupted filesystem
Date: Sun, 04 Jan 2009 01:10:27 +0900 (JST)
Message-ID: <20090104.011027.32666159.ryusuke@osrg.net>
References: <20090101093121.302730@gmx.net>
	<20090102.002735.88475791.ryusuke@osrg.net>
	<20090103075438.264510@gmx.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090103075438.264510-hi6Y0CQ0nG0@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, robinx99-hi6Y0CQ0nG0@public.gmane.org

Hi,
On Sat, 03 Jan 2009 08:54:38 +0100, robinx99-hi6Y0CQ0nG0@public.gmane.org wrote:
> Oops didn't send the mail to the mailinglist, so I will resend.
> Hi
> > 
> > Thanks for your help.
> > I have another request:
> > 
> >  # dumpseg /dev/loop1 12
> 
> root@robin-laptop:/tmp# dumpseg /dev/loop1 12
> segment: segnum = 12
>   partial segment
>     creation time = 2008-12-26 11:45:06
>     nfinfo = 0

Uh, that was not good.

> >  - This will dump the summary of the segment in question
> > 
> >  # dd if=/dev/loop1 bs=4k skip=24576 count=2 | hd
> > 
> >  - This will dump the (broken) root block of the file system
> > 
> Ok I atached it to the email bzip2 compressed

This was informative.

The last segment was that written for GC and I actually confirmed that
the inconsistency of DAT root.  It must be a bug of one of GC, btree,
or the DAT file.

> > According to your log, the btree root of DAT file (i.e. a table file
> > to translate disk addresses) seems inconsistent.  It might not be
> > updated properly when GC moved its blocks.  I suspect that it was
> > caused by some sort of GC problem.
> > 
> > And, your nilfs partition seems to have shut down uncleanly before
> > this mount error repeatedly happened.  Do you remember what the first
> > trouble was like?
> > 
> Actualy I have no real idea. Didn't start the computer for some days
> over christmas, befor christmas I could use the filesystem withoul
> any trouble, and on december 26 I was unable to mount it.  I actualy
> quite often moved files of the nilfs filesystem to an USB
> stick. Using comands like "mv /mnt/nilfs/directory/*.avi /mnt/usb &&
> poweroff". So there were some shutdowns I didn't watch, and I was
> thinking that the normal shutdown scripts should unmount every
> mounted filesystem. Well the computer was definitv off, but I have
> no idea if it could be possible that something importend was stoped
> to soon when it came to the point "sending all procecess the term
> signal"
>
> robinx99

Thank you once again.

There is no doubt that this corruption was caused by a bug of NILFS
because NILFS verifies validity of every segment with checksums.

If NILFS doesn't have any bugs, and write barrier is assured, the file
system must be recovered propery even if you have reset the PC during
GC (unless hardware failures occur, of course).

So we have to review code to find out the cause, and I believe your
information will help this.

Thanks,
Ryusuke

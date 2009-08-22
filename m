From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Fail to mount NILFS.
Date: Sat, 22 Aug 2009 18:50:13 +0900 (JST)
Message-ID: <20090822.185013.23110170.ryusuke@osrg.net>
References: <200908211918.34720.yuri@itinteg.net>
	<20090822.112533.68801227.ryusuke@osrg.net>
	<200908221146.28241.yuri@itinteg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <200908221146.28241.yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org>
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

Hi,
On Sat, 22 Aug 2009 11:46:28 +0300, Yuri Chislov wrote:
> On Saturday 22 August 2009 05:25:33 Ryusuke Konishi wrote:
> > f you made the kernel from source, try the patch as follows:
> >
> >  $ cd linux-2.6.30.4
> >  $ patch -p1 < path-to/0001-nilfs2-remove-snapshot-check-on-mount.patch
> >  $ make modules
> >  $ sudo rmmod nilfs2
> >  $ sudo insmod fs/nilfs2/nilfs2.ko
> >  $ sudo mount -t nilfs2 -r -o cp=xxx /dev/yyy /mnt
> >
> > If you succeed to mount a valid past checkpoint, you will be able to
> > do backup with rsync or so from the checkpoint.
> >
> > Regards,
> > Ryusuke Konishi
> 
> Hi, 
>   
>   Thank you for patch.
>  I have try to mount as you propose, but receive following errors:
> /sbin/mount.nilfs2 -r -o cp=30778 /dev/cciss/c0d1p1 /mnt/
> 
> NILFS: latest checkpoint=30778
> NILFS: The specified checkpoint is not a snapshot (checkpoint number=30778).

Ignore this message. The patch actually changed nilfs to accept all
checkpoints, but I left this error message.

> NILFS: corrupt root inode.

This _is_ the problem. This shows the inode of root directory is
broken or empty.  I think you cannot mount generations which you see
this message.
 
> If I try to mount older snapshot 
> /sbin/mount.nilfs2 -r -o cp=27252 /dev/cciss/c0d1p1 /mnt/
> 
> then 
> 
> NILFS: latest checkpoint=30778
> NILFS: corrupt root inode.

The first message is just information I added in the patch.
But, uum, the root inode of checkpoint 27252 seems to be broken, too.
 
Can you go back to much older checkpoints ?

> If try to convert 30778 to snapshot I get
> chcp: /dev/cciss/c0d1p1: cannot open NILFS

Yeah, chcp is not possible if there is no rw-mount.
You don't have to do chcp because my workaround patch makes
existent checkpoints mountable.

BTW, your nilfs-utils seems a bit old.  I believe there was no problem
causing filesystem corruption in nilfs-utils-2.0.12.  But, I recommend
you to use nilfs-utils-2.0.14 if available.

Regards,
Ryusuke Konishi

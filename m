From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Questions regarding use of nilfs2 on SSDs
Date: Sun, 29 Mar 2009 15:17:50 +0900 (JST)
Message-ID: <20090329.151750.64733928.ryusuke@osrg.net>
References: <49CE8EDA.8070304@web.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <49CE8EDA.8070304-S0/GAf8tV78@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, iglockner-S0/GAf8tV78@public.gmane.org

Hi!
On Sat, 28 Mar 2009 21:55:54 +0100, Ingo Gl=F6ckner wrote:
> Hello,
> =

> first of all thank you very much for contributing
> this great file system, nilfs2!
> I would like to use nilfs2 on an SSD but there
> are some open questions, hopefully you can help
> me clearing these issues.
> =

> - I have read somewhere
> > http://www.ocztechnologyforum.com/forum/showpost.php?p=3D361424&postcou=
nt=3D10
> =

>   that using nilfs2 as the rootfs generates enormous I/O traffic
>   (up to 45 GB write in 1-2 days!) If this is true, then it will
>   eventually translate into reduced lifetime for SSDs.
>   Can you confirm that the segment management of nilfs2
>   is so write-heavy on the drive?
>   If so, are there ways to avoid this?

Yes, this is true.  This is mainly because garbage collection creep
around the partition until no old updates are found.

The current GC algorithm is not intelligent.  Under the algorithm, a
filesystem holding large amount of data suffers long-run of GC.  That
is why the rootfs generated enourmous I/O traffic.

An easy way to reduce this is increasing ``protection_period'' in
/etc/nilfs_cleanerd.conf or just stopping GC while the partition has
enough free space.

Your requirement is clearly one of primary TODO items of nilfs2, but
unfortunately I have too many things to do.  One of my colleagues is
trying to improve the GC, so I'd like to expect his work.  Any
proposal to refine clearnerd is welcome.
 =

> - The standard segment size of nilfs2 appears to be 8MB.
>   This compares to an erase block size of the SSD of
>   (say) 512 KB. I wonder if reducing the segment size
>   of nilfs to a smaller value (i.e., closer to the
>   erase block size of the SSD) will help to
>   keep the number of erased blocks/day small
>   (this will benefit the lifetime of the drive)
>   or if there is no such connection.
>   In any case, what is the useful range for segment
>   sizes? If I reduce the segment size, will I get
>   a performance penalty?

The segment size can be changed with -B option of mkfs.nilfs2.
It specifies the number of blocks per segment.

  # mkfs -t nilf2 -B 128  /dev/xxx

will make a partition with the segment size of 512 KB.
(the block size is 4KB unless you change it with -b option)

This will mitigate GC overhead because the number of segments per
cleaning is fixed to a value defined in /etc/nilfs_cleanerd.conf.

But, it's just effect of speed decreasing of the cleaner.  If the
purpose is slowing down the speed, just reducing
``nsegments_per_clean'' or increasing ``cleaning_interval'' in the
conf file can serve the purpose.

> - nilfs_cleanerd.conf specifies the following default values,
> =

> # The maximum number of segments to be cleaned at a time.
> nsegments_per_clean     2
> =

> # Cleaning interval in second.
> cleaning_interval       5
> =

> Do I interpret this correctly as stating that only 2 segments
> (i.e. 16MB) can be cleaned in 5 seconds?

Exactly.

> What negative effects will I get if I increase the number
> of segments that can be cleaned at a time?

It will increase memory pressure, and may unstabilize system.  And,
some trouble is reported in this mainling list.  We know filesystem
corrution will occasionally occur due to a nilfs2 bug which comes to
surface under such condition; I'm actually dig into the problem now.

I recommend you to decrease cleaning_interval instead of increasing
nsegemnts_per_clean if you try to speed up the cleaner.
 =

Cheers,
Ryusuke Konishi

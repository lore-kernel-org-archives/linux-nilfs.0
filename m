From: pg-9Cpm1x5jwYpury8xqvH7Ik8g8846gVy9@public.gmane.org (Peter Grandi)
Subject: Re: cleanerd taking too long to complete
Date: Sun, 17 Dec 2017 10:57:44 +0000
Message-ID: <23094.19880.836004.830487@tree.ty.sabi.co.uk>
References: <20171216221326.39ce57f1@babalu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171216221326.39ce57f1@babalu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux fs NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

> Well, since monday I started it (mount -o remount) it and
> noticed it uses almost 100% of my CPUs.

Unlikely -- probably you are seeing IO wait time reported as CPU
time. Consider using 'iotop' or 'iostat -dk -zyx 1'.

> [ ... ] The partition (512G) was not cleared throughout the
> week. [ ... ]

The 'cleanerd' is (to simplify) a background "defragmenter", so
it never "completes". However it is an "active" phase, where it
moves segments, and a "inactive" phase when it reaches a
threshold configurable in 'nilfs_cleanerd.conf'.

By default it becomes active if there is less than 10% free
space and the becomes inactive once there is more than 20% (or
all checkpoints are within the protection period).

Like all copy-on-write (including log-based) filesystem designs,
the assumption is that there will be a significant free space
reserve in a NILFS2 filetree, and that the overwrite rate will
not significantly exceed the "defragmentation" rate in the long
term.

As to the free space reserve:

* For comparison, consider the '-m' parameter in 'mke2fs', where
  it is said that "The default percentage is 5%"; this is a value
  that I think is way too low for 'ext4'. There are reports that
  for active workloads 'ext4' speed starts to fall with free
  space below 20%.

* There is a similar '-m' argument for 'mkfs.nilfs2', the default
  is 5%. Probably it should be 10% in most cases, and there should
  be another 5-10% free on top of that.

I have some not-very-active 500GB and 1000GB filetrees and for
this reason I usually run the 'nilfs_cleanerd' occasionally (for
example in one of them I have 2 months worth of checkpoints),
and it takes usually around 1-2 hours.

So there is a three-way trade-off between filetree churn, free
space, 'nilfs_cleanerd' effort required.

BTW for a filetree that contains mostly media that I rarely
update I have got 1 year of checkpoints, which take up around
10% of the filetree space:

  base#  du -sm /au/sdb10/.
  657054  /au/sdb10/.

  base#  df -BM /au/sdb10/.
  Filesystem     1M-blocks    Used Available Use% Mounted on
  /dev/sdb10       950256M 802880M    99856M  89% /au/sdb10

  base#  lscp /dev/sdb10 | head -4
		   CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
		129527  2016-12-30 02:14:52   cp    -         6211      73283
		129528  2016-12-30 02:14:57   cp    -         3699      73283
		130240  2017-01-29 13:34:19   cp    -        12439      73284

  base#  lscp /dev/sdb10 | tail -4
		130788  2017-10-30 13:46:38   cp    -         2855      76491
		130789  2017-10-30 13:46:48   cp    -        25939      76545
		130790  2017-11-03 13:44:27   cp    -         2963      76576
		130791  2017-11-20 13:41:01   cp    -         7812      76587

> How can I be informed about how much of the job has cleanerd
> already completed?

Well, it does not complete, but it will become inactive once the
protection period checkpoints have been reached, or the free
space is above 20% or 10%. You can use 'lscp', 'nilfs-tune -l'
and 'df' vs. 'du' to get an idea of the filesystem status. The
number of wholly free segments does not seem to be reported
unfortunately.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Is NILFS2 suitable for long term archival storage?
Date: Wed, 22 Jun 2022 00:02:40 +0900
Message-ID: <CAKFNMo=nn1hu==S6xB5sWGuN_KpCuoHjmQb76WjrHg1875T_Vg@mail.gmail.com>
References: <CA+Tk8fzpXneoDAyvdoJFdFjX7Cx-cJ7GO0uNXjGrYDk23FyekA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jcpCAoNbc0xzuhPIvpEKg132Fwj9YR6uxrslS8Yon4w=;
        b=LfJGetRuZLXbjGFrkh7yyhkks7KQUVRfLsHto2sq2vIp537o2c6/Fm+A+UkVP00zF+
         TrHWROxYVB3UwZypHIPd7uCXwElZBjE9DP2YuQQ4c5xjNGzemJJMP1+u3/CLYPVSl6Du
         KDudgtTxCiZzktxlxIfjP/OPUAqWn1wjAYCS0aZh2wERSxZPlmv+cY8zhRZxZPywSfpw
         8kQCz4DDWayU/C1vvmkELqvIabAaW8eIhEIdv8sBw9oxKHHdMrqsiUSsyRscerQ4fnJ+
         2si/+oDN25xa+b1BJcn5aepl/b0h8Mp5DIQWO/l9P9icLe/7l6t9XFCQkxZagIfFcVRc
         Ww7A==
In-Reply-To: <CA+Tk8fzpXneoDAyvdoJFdFjX7Cx-cJ7GO0uNXjGrYDk23FyekA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ciprian Craciun <ciprian.craciun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Ciprian,

On Tue, Jun 21, 2022 at 6:42 PM Ciprian Craciun wrote:
>
> [I'm not subscribed to the mailing list, thus please keep me in CC.]
>
>
> I was looking at NILFS2 as a potential solution for a file-system for
> long-term archival (as in backups or append-only store).  In this
> use-case I would use large CMR or SMR rotational disks (say 4+ TB, WD
> or Seagate) without any RAID or disk-encryption, connected via USB
> (thus sudden disconnects are to be expected), used with `restic`, or
> `rdiff-backup` and `rsync`-like if `restic` doesn't work.  As such,
> the IO pattern during backup would be mostly creating new files, a
> couple MiB each in case of `restic`, and random reads during `restic`
> checks.  In both cases there is quite some concurrency (proportional
> to the number of cores).
>
> So I was wondering the following:
> * is NILFS2 suitable for such a use-case?  (my assumption is yes, at
> least based on the features and promises;)

The suitability for storage media such as CMR and SMR is uncertain in
actual use, so I think you should actually evaluate that pattern with some
file systems.

Writing with NILFS2 has the characteristic of being sequential, including
updating file system metadata and concurrent writes.  However, reading
causes random access, which will be a trade-off with the effect of caching.

In addition, NILFS2 periodically updates the superblocks at the beginning
and end of the partition alternately, so writes are not completely sequential.
These properties can work in both the good and the bad.

For sudden removal, NILFS2 will be robust as the result of checkpointing,
but that assumption, in the first place, sounds physically not good for
disk media unless the device has a battery-backed safety guarantee.
On the other hand, most modern file systems these days are also robust
enough for unusual disconnections.

The use case where NILFS2 is most useful is that the latest data can be
recovered even if the data is overwritten or deleted by human error or an
application bug.
However, this does not seem to be utilized in the above archive storage
applications.

> * how reliable is the current version (as upstreamed in the kernel) of
> NILFS2?  data-loss of previously written (and `fsync`-ed) files is of
> paramount importance (especially for files that have been written say
> days ago);
> * are there instances of NILFS2 used in production (for any use-case)?

I believe NILFS2 in the upstream kernel is still reliable enough, but I
think you should refer to other users' opinions on this.

As far as I know, NILFS2 once operated as a document storage server
in a company for about 5 years and had no failure.   The server really
helped to rescue office documents that the staff accidentally overwritten
and erased.  But this is more than eight years ago.   I don't  know about
application examples for commercial device products.

> I've tried searching on the internet and the email archives, but I
> couldn't find anything "current" enough.  Moreover at least OpenSUSE
> (and SUSE) have dropped the NILFS2 kernel module from the standard
> packages (granted JFS was also dropped).
>
> Also I'm concerned due to the fact that there isn't any `fsck` for NILFS2 yet.

This is true.
NILFS2 guarantees reliability with a checkpoint write method, so if a bug
in the file system itself corrupts the data or metadata, there is no way to
remedy it yet.

> Related to this, could the community recommend an alternative
> file-system that would fit the bill?  (Ext4 and JFS are the only
> file-systems I have heavily used and relied upon.)

Again, this depends on the opinions of everyone else.

To mention just one thing, when it comes to large archive storage,
I guess there is a perspective of resistance to the bit rot issue.
From this perspective, btrfs or zfs would be your choice unless
you combine an FS with other solutions like dm-integrity.

Regards,
Ryusuke Konishi

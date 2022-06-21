From: Ciprian Craciun <ciprian.craciun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Is NILFS2 suitable for long term archival storage?
Date: Tue, 21 Jun 2022 12:40:28 +0300
Message-ID: <CA+Tk8fzpXneoDAyvdoJFdFjX7Cx-cJ7GO0uNXjGrYDk23FyekA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=0/Z6/I6MXGt005euOEO8lskeXxe8CmInEjWcMvwjoVw=;
        b=Ow/90e63LjwtOUgoFS7unWWIJj7F8D54Tjn7+Mq2TRx9LXYUJIknV6uKYfPIZjjOis
         Dgv83CpC4kIVW05FAxL5qxvd+PKXff2sJjLEoNgTJS1lnnv40rd27aiaFKh6T+BqXm3v
         +S1YQZij8rNBKpFm2QBp/4yMBIuZCYWUtpnr/BSdSw7OO2uK+8XEsxk2w9SV0xx7eHfM
         TqxrrfBfOKNzrk/fAQwEHB7PAau/6oOETu1O43HxOUjIW8hYQQWyfUHpzhZ91FwkRLLh
         WyGb8Mjaa43YEA4DcBfV7mJ+zSBIswps5vmuZetx3VFkjUkR5YhRVZ5JmE3oJ0F95/i1
         KXsw==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

[I'm not subscribed to the mailing list, thus please keep me in CC.]


I was looking at NILFS2 as a potential solution for a file-system for
long-term archival (as in backups or append-only store).  In this
use-case I would use large CMR or SMR rotational disks (say 4+ TB, WD
or Seagate) without any RAID or disk-encryption, connected via USB
(thus sudden disconnects are to be expected), used with `restic`, or
`rdiff-backup` and `rsync`-like if `restic` doesn't work.  As such,
the IO pattern during backup would be mostly creating new files, a
couple MiB each in case of `restic`, and random reads during `restic`
checks.  In both cases there is quite some concurrency (proportional
to the number of cores).

So I was wondering the following:
* is NILFS2 suitable for such a use-case?  (my assumption is yes, at
least based on the features and promises;)
* how reliable is the current version (as upstreamed in the kernel) of
NILFS2?  data-loss of previously written (and `fsync`-ed) files is of
paramount importance (especially for files that have been written say
days ago);
* are there instances of NILFS2 used in production (for any use-case)?


I've tried searching on the internet and the email archives, but I
couldn't find anything "current" enough.  Moreover at least OpenSUSE
(and SUSE) have dropped the NILFS2 kernel module from the standard
packages (granted JFS was also dropped).

Also I'm concerned due to the fact that there isn't any `fsck` for NILFS2 yet.


Related to this, could the community recommend an alternative
file-system that would fit the bill?  (Ext4 and JFS are the only
file-systems I have heavily used and relied upon.)

Thanks,
Ciprian.

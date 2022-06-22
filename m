From: Tommy Pettersson <ptp-SamgB31n2u5IcsJQ0EH25Q@public.gmane.org>
Subject: Re: Is NILFS2 suitable for long term archival storage?
Date: Wed, 22 Jun 2022 14:12:21 +0200
Message-ID: <YrMHJYobUpjv+KRj@kelsos>
References: <CA+Tk8fzpXneoDAyvdoJFdFjX7Cx-cJ7GO0uNXjGrYDk23FyekA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+Tk8fzpXneoDAyvdoJFdFjX7Cx-cJ7GO0uNXjGrYDk23FyekA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ciprian Craciun <ciprian.craciun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Ciprian,

I am using nilfs2 daily at work since 5 years. During this
time I have had a handful of "bad btree node" corruptions.
They don't destroy the current data, but causes weird
problems with snapshots, and I have re-created the
filesystem on these occasions. This is of course not
supposed to happen, and may eventually be fixed if someone
future version.

But the main reason I would not recommend nilfs2 for
long-term backup is, like Ryusuke has mentioned, that nilfs2
does not have checksums and a corresponding scrub mechanism
to validate that no bits on the disk have accidentally
flipped or become unreadable. For safe long-term storage you
will need checksums and scrubbing to detect corrupted data,
and redundancy (raid, mirror) to correct the corruption and
get a notice to replace the failing disk.

Even if safety is not a priority, there is little benefit
from using nilfs2 for backups, since you will probably make
a manual snapshots after a backup anyway, and not have any
use for all the automatic checkpoints that will be created
during the backup.

Another thing that could be an issue is that nilfs2 does not
support xattr, if that is needed for the backup.

Yet another curiosity I have had to deal with is symlink
properties. The standard says that rwx properties of
symlinks may be set to anything but should be ignored. All
filesystems I have used sets them to 777, except for nilfs2,
which honors the current umask value. Now, rsync, which is
probably to blame here, tries to update the properties on
symlinks, and if it reads from nilfs2, and gets something
other than 777, it can not set this other value if the
target is not also nilfs2, and will think it has failed. The
only workaround I have come up with is to find all symlinks
on nilfs2 and update their permission to 777.

That said, I could go on and on about how much I love nilfs2
for its user error protection. I use it as a "working area"
where I can experiment fearlessly, because I can backtrack
to any point in time.

From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 0/9] nilfs2: introduce functionality of creation of
 sysfs groups and attributes
Date: Mon, 21 Apr 2014 01:18:25 +0900 (JST)
Message-ID: <20140421.011825.85418432.konishi.ryusuke@lab.ntt.co.jp>
References: <1397837240.2178.51.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1397837240.2178.51.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Vyacheslav,
On Fri, 18 Apr 2014 20:07:20 +0400, Vyacheslav Dubeyko wrote:
> Hi,
> 
> This second version of patchset implements creation of
> sysfs groups and attributes with the purpose to show
> NILFS2 volume details and internal state of the driver.
> 
> v1->v2
>  * Improve human-readable format of timestamp output (Michael L. Semon)
>  * Fix issue with nilfs_sysfs_{create/delete}_snapshot_group (Michael L. Semon)
> 
> Implemented functionality creates such groups:
> 
> (1) /sys/fs/nilfs - root group
> (2) /sys/fs/nilfs/features - group contains attributes that describe NILFS
> file system driver features
> (3) /sys/fs/nilfs/<device> - group contains attributes that describe file
> system partition's details
> (4) /sys/fs/nilfs/<device>/superblock - group contains attributes that describe
> superblock's details
> (5) /sys/fs/nilfs/<device>/segctor - group contains attributes that describe
> segctor thread activity details
> (6) /sys/fs/nilfs/<device>/segments - group contains attributes that describe
> details about volume's segments
> (7) /sys/fs/nilfs/<device>/checkpoints - group contains attributes that describe
> details about volume's checkpoints
> (8) /sys/fs/nilfs/<device>/mounted_snapshots - group contains group for every
> mounted snapshot
> (9) /sys/fs/nilfs/<device>/mounted_snapshots/<snapshot> - group contains
> details about mounted snapshot

Thank you for posting this series.

I am thinking of sending this series to upstream.

For that end, please clarify the motivation, the background, or the
issue what this series tries to solve within the cover letter ([PATCH
0/n]).  I will refer to it when I will send the series to upstream.

Also, it's preferable to include a brief overview of this sysfs
interface in a Documentation file.

Some filesystems describe their sysfs interface in
Documentation/ABI/testing/sysfs-fs-xxx.  Even though this sysfs
interface has description of ABI in README files, I think
documentation should be added in a similar manner to other
filesystems.

You chose "nilfs" instead of "nilfs2" as the filesystem name.  This
may lead to discussion, but I also prefer "nilfs" because we
intentionally use the name "nilfs" in userland as the name separated
from implementation and this is the name of interface for users and
userland tools.

One my question is about the "device" name.  Is it guaranteed that
every device has canonical single node name?  What will happen for
devices such as /dev/mapper/xxx?

Thanks,
Ryusuke Konishi

> With the best regards,
> Vyacheslav Dubeyko.
> ---
>  fs/nilfs2/Makefile    |    2 +-
>  fs/nilfs2/nilfs.h     |    8 +
>  fs/nilfs2/super.c     |    9 +-
>  fs/nilfs2/sysfs.c     | 1134 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/nilfs2/sysfs.h     |  174 ++++++++
>  fs/nilfs2/the_nilfs.c |   17 +-
>  fs/nilfs2/the_nilfs.h |   20 +-
>  7 files changed, 1360 insertions(+), 4 deletions(-)
> -- 
> 1.7.9.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

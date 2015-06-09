From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: NILFS2: double uuid
Date: Tue, 09 Jun 2015 22:04:15 +0900
Message-ID: <5576E44F.5030201@lab.ntt.co.jp>
References: <20150608094559.GB15702@fritha.org> <20150608100835.GA16569@fritha.org> <55756F17.7080603@lab.ntt.co.jp> <20150609.003127.1516615115859573912.konishi.ryusuke@lab.ntt.co.jp> <20150609085329.GF1992@ws.net.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150609085329.GF1992-xkT7n84Rsxv/9pzu0YdTqQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Heinz Diehl <htd+ml-iEI8Y0CNJBYdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On 2015/06/09 17:53, Karel Zak wrote:
> On Tue, Jun 09, 2015 at 12:31:27AM +0900, Ryusuke Konishi wrote:
>> It looks like the backup super block should be dropped from candidates
>> if its device size (sbp->s_dev_size) doesn't match the partition size.
>
> Yeah, fixed:
> http://git.kernel.org/cgit/utils/util-linux/util-linux.git/commit/?id=00817742ce360119e079a33e12cf84118ff7c63e
>
> Note that workaround is to not use nilfs2 on the last partition or
> have a tiny gap (1 sector is enough) between last partition and the
> end of the whole-disk.
>
>      Karel
>

Thanks for your quick work!

I tested the patch.  It almost worked fine.
One issue I found is a transient state after fs-resizing.

After shrinking the file system, both superblocks dropped and
lsblk failed to detect the filesystem:

$ sudo LD_LIBRARY_PATH=/usr/local/lib lsblk -f
NAME   FSTYPE  LABEL           UUID 
MOUNTPOINT
[...]
sdb
`-sdb1 nilfs2                  2d7cd130-82a0-4a3c-b8a8-4ac5a26f5703 /test

$ sudo nilfs-resize -y /dev/sdb1 1G
Partition size = 2146435072 bytes.
Shrink the filesystem size from 2146435072 bytes to 1073741824 bytes.
128 segments will be truncated from segnum 127.
Moving 103 in-use segments.
progress |***********************************************|
Done.

$ sudo umount /test
$ sudo mount /dev/sdb1 /test
$ sudo LD_LIBRARY_PATH=/usr/local/lib lsblk -f
NAME   FSTYPE  LABEL           UUID 
MOUNTPOINT
[...]
sdb
`-sdb1                                                              /test

This blank state continued until I shrank the partition or
re-extended the filesystem to the partition size.

Could you consider confining the s_dev_size test only to the
backup superblock ?

It seems that we don't have to drop the primary super block
even if s_dev_size doesn't fit to the partition size.


Regards,
Ryusuke Konishi

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

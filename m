From: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: NILFS2: double uuid
Date: Tue, 9 Jun 2015 16:07:42 +0200
Message-ID: <20150609140742.GH1992@ws.net.home>
References: <20150608094559.GB15702@fritha.org>
 <20150608100835.GA16569@fritha.org>
 <55756F17.7080603@lab.ntt.co.jp>
 <20150609.003127.1516615115859573912.konishi.ryusuke@lab.ntt.co.jp>
 <20150609085329.GF1992@ws.net.home>
 <5576E44F.5030201@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5576E44F.5030201-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Heinz Diehl <htd+ml-iEI8Y0CNJBYdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jun 09, 2015 at 10:04:15PM +0900, Ryusuke Konishi wrote:
> $ sudo nilfs-resize -y /dev/sdb1 1G
> Partition size = 2146435072 bytes.
> Shrink the filesystem size from 2146435072 bytes to 1073741824 bytes.
> 128 segments will be truncated from segnum 127.
> Moving 103 in-use segments.
> progress |***********************************************|
> Done.
> 
> $ sudo umount /test
> $ sudo mount /dev/sdb1 /test
> $ sudo LD_LIBRARY_PATH=/usr/local/lib lsblk -f
> NAME   FSTYPE  LABEL           UUID MOUNTPOINT
> [...]
> sdb
> `-sdb1                                                              /test
> 
> This blank state continued until I shrank the partition or
> re-extended the filesystem to the partition size.
> 
> Could you consider confining the s_dev_size test only to the
> backup superblock ?

Hmm... why nilfs-resize does not update the size in the superblock?
It seems like nilfs-resize bug.

> It seems that we don't have to drop the primary super block
> even if s_dev_size doesn't fit to the partition size.

Yes, fixed. I have also enabled the s_dev_size check for whole-disk
devices only to minimize number of situations when we rely on the
s_dev_size.

    Karel

-- 
 Karel Zak  <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 http://karelzak.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

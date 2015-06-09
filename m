From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: NILFS2: double uuid
Date: Wed, 10 Jun 2015 01:00:29 +0900 (JST)
Message-ID: <20150610.010029.2104807508136297204.konishi.ryusuke@lab.ntt.co.jp>
References: <20150609085329.GF1992@ws.net.home>
	<5576E44F.5030201@lab.ntt.co.jp>
	<20150609140742.GH1992@ws.net.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=sKe22t17ZJVfhN0dBHmgOvVgg+z8lgQ1tQ2BITXQ6V4=;
        b=Yvam0C52LvVRChSZ8YKZBHzHH2UvXQEGAwy65a6gfIYN6W63K+ElNL1nJBTgDcys5x
         rrV9kCDMU6wcOiAB61S+/Irr2iOW004fN2LZ86fjVX2uv9MOzAcmzfkdk/FGUwpUMFH4
         2N83nR4v3DGLpCRL8Ih8A6SNmv2HuXbqq9k8ZZo/4kcsSoUAGTLUN+lwyItgTTpOVHyQ
         VunLVlUkz8R9YPIMogQJ0zb3bC/W3d8h+5YbrNUggtw/ZXbF6WsimT6B8hpEM404k3QY
         ORyvw6OAC4QQn4IG/77EOJjxLHM9UJESXOfo+ztDk3rX8p90VHeSrxQ9mnSENPcKzZZc
         656g==
In-Reply-To: <20150609140742.GH1992-xkT7n84Rsxv/9pzu0YdTqQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Heinz Diehl <htd+ml-iEI8Y0CNJBYdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 9 Jun 2015 16:07:42 +0200, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Jun 09, 2015 at 10:04:15PM +0900, Ryusuke Konishi wrote:
>> $ sudo nilfs-resize -y /dev/sdb1 1G
>> Partition size = 2146435072 bytes.
>> Shrink the filesystem size from 2146435072 bytes to 1073741824 bytes.
>> 128 segments will be truncated from segnum 127.
>> Moving 103 in-use segments.
>> progress |***********************************************|
>> Done.
>> 
>> $ sudo umount /test
>> $ sudo mount /dev/sdb1 /test
>> $ sudo LD_LIBRARY_PATH=/usr/local/lib lsblk -f
>> NAME   FSTYPE  LABEL           UUID MOUNTPOINT
>> [...]
>> sdb
>> `-sdb1                                                              /test
>> 
>> This blank state continued until I shrank the partition or
>> re-extended the filesystem to the partition size.
>> 
>> Could you consider confining the s_dev_size test only to the
>> backup superblock ?
> 
> Hmm... why nilfs-resize does not update the size in the superblock?
> It seems like nilfs-resize bug.

nilfs-resize (to be exact, RESIZE ioctl of nilfs2) updates s_dev_size
in both superblocks.  What nilfs-resize doesn't change is the
partition size.  (It needs help of a partitioning tool)

> 
>> It seems that we don't have to drop the primary super block
>> even if s_dev_size doesn't fit to the partition size.
> 
> Yes, fixed. I have also enabled the s_dev_size check for whole-disk
> devices only to minimize number of situations when we rely on the
> s_dev_size.
> 
>     Karel

Thanks again.  The updated libblkid/lsblk works frawlessly.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

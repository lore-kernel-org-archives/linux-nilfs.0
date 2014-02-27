From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: snapshots contain the same rrd database
Date: Thu, 27 Feb 2014 11:45:47 +0900 (JST)
Message-ID: <20140227.114547.220041242.konishi.ryusuke@lab.ntt.co.jp>
References: <20140226133201.GA2022@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140226133201.GA2022@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Piotr,
On Wed, 26 Feb 2014 14:32:02 +0100, Piotr Szymaniak wrote:
> Hi,
> 
> I got a system crash after some 160+ days uptime. After a hard reboot I
> noticed my rrd database looks corrupted.
> 
> So I changed some recent checkpoints to snapshots, mounted them and...
> all the rrd files are the same!
> 
> Here's some info about current state:
<snip>
> wloczykij ~ # uname -sr
> Linux 3.4.56

This version looks a bit old.  The current head of linux-3.4.y is
v3.4.82.

The following important bug fixes are not included in this version:

 $ git shortlog v3.4.56..v3.4.82 | grep nilfs
   nilfs2: fix segctor bug that causes file system corruption
   nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNOTSUPP error
   nilfs2: fix issue with counting number of bio requests for BIO_EOPNOTSUPP error detection

Was it a distro kernel?

If you can try the latest version, I hope it both for avoiding
critical error of yours and for narrowing down cause of the problem.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

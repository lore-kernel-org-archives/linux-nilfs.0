From: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: NILFS2: double uuid
Date: Tue, 9 Jun 2015 10:53:29 +0200
Message-ID: <20150609085329.GF1992@ws.net.home>
References: <20150608094559.GB15702@fritha.org>
 <20150608100835.GA16569@fritha.org>
 <55756F17.7080603@lab.ntt.co.jp>
 <20150609.003127.1516615115859573912.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150609.003127.1516615115859573912.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Heinz Diehl <htd+ml-iEI8Y0CNJBYdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jun 09, 2015 at 12:31:27AM +0900, Ryusuke Konishi wrote:
> It looks like the backup super block should be dropped from candidates
> if its device size (sbp->s_dev_size) doesn't match the partition size.

Yeah, fixed:
http://git.kernel.org/cgit/utils/util-linux/util-linux.git/commit/?id=00817742ce360119e079a33e12cf84118ff7c63e

Note that workaround is to not use nilfs2 on the last partition or
have a tiny gap (1 sector is enough) between last partition and the 
end of the whole-disk.

    Karel

-- 
 Karel Zak  <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 http://karelzak.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

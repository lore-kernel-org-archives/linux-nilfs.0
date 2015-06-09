From: Heinz Diehl <htd+ml-iEI8Y0CNJBYdnm+yROfE0A@public.gmane.org>
Subject: Re: NILFS2: double uuid
Date: Tue, 9 Jun 2015 07:45:40 +0200
Message-ID: <20150609054540.GC13357@fritha.org>
References: <20150608094559.GB15702@fritha.org>
 <20150608100835.GA16569@fritha.org>
 <55756F17.7080603@lab.ntt.co.jp>
 <20150609.003127.1516615115859573912.konishi.ryusuke@lab.ntt.co.jp>
 <20150608172324.GA7760@fritha.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150608172324.GA7760-iEI8Y0CNJBYdnm+yROfE0A@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 08.06.2015, Heinz Diehl wrote: 

> > This change has been applied between v2.24 and v2.24.1 of util-linux,
> > and not yet fixed in the mainline.
 
> Ok, I'll try to identify and revert this commit in the meantime.

The patch doesn't revert cleanly. Is there a workaround I could use
until the problem is properly fixed?

Thanks,
Heinz

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

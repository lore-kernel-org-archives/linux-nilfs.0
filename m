From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 1/1] nilfs2: fix potential memory overrun on inode
Date: Fri, 20 Feb 2015 18:00:55 -0800
Message-ID: <20150220180055.443bbce8.akpm@linux-foundation.org>
References: <1424439995-613-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<20150220135842.0cd5c9338316a8a20b6a604a@linux-foundation.org>
	<20150221.092208.1795135375638032743.konishi.ryusuke@lab.ntt.co.jp>
	<20150221.101328.1613471465739082397.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150221.101328.1613471465739082397.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Henderson <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>, Ivan Kokshaysky <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>, Matt Turner <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>

On Sat, 21 Feb 2015 10:13:28 +0900 (JST) Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:

> I've got a warning from 0day kernel testing backend:
> 
>     fs/nilfs2/btree.c: In function 'nilfs_btree_root_broken':
> >> fs/nilfs2/btree.c:394:3: warning: format '%lu' expects argument of type 'long unsigned int', but argument 2 has type 'ino_t' [-Wformat=]
>        pr_crit("NILFS: bad btree root (inode number=%lu): level = %d, 
> flags = 0x%x, nchildren = %d\n",
>        ^
> 
> This is output for s390 arch since ino_t doesn't mean "unsigned long"
> in s390.

alpha uses uint for ino_t as well.

It seems a bit pointless - neither arch uses ino_t in ./arch/ code.  I
suspect both could switch to ulong, which would make the world a
slightly better place.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

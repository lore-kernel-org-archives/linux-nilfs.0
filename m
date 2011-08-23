From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: lscp - what's NBLKINC and ICNT? (and the i FLG)
Date: Tue, 23 Aug 2011 18:37:22 +0900 (JST)
Message-ID: <20110823.183722.131908329.ryusuke@osrg.net>
References: <20110823085330.GA1472@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110823085330.GA1472@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Tue, 23 Aug 2011 10:53:30 +0200, Piotr Szymaniak wrote:
> Hi.
> 
> I just started (~2 weeks ago) to use nilfs2 on my / and i'm missing
> some information about those last two attritubes of lscp. Looking back
> at the list it seems that the first one (NBLKINC) is changed blocks
> between checkpoints, but i'm unable to find what's the last one (ICNT).

ICNT field shows the number of inodes existing in the filesystem.

> wloczykij ~ # lscp
>             CNO        DATE     TIME  MODE  FLG   NBLKINC       ICNT
>           27193  2011-08-19 15:25:38   cp    -         87      37613
>           27194  2011-08-19 15:27:39   cp    -         20      37612
>           27195  2011-08-19 15:30:09   cp    -         58      37615
>           27196  2011-08-19 15:32:09   cp    -         38      37612
> (...)
> 
> Some checkpoints also are marked with "i" FLG. I think this also was
> answered on the list before, but i cant dig the answer.

This flag shows that the checkpoint was created by a garbage
collection or some kind of metadata change (usually snapshot
operation).

> Is there some doc on nilfs homepage about those attributes that i'm
> missing? (or man?) I would appreciate if someone could point me to
> some answers. Thanks. (-:
> 
> Piotr Szymaniak.

Yes, try "man lscp".

If the man page is deficient or confusing for you, then it should be
rewritten well :)

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] nilfs2: insert checkpoint number in segment summary header
Date: Sun, 2 May 2010 12:50:58 +0200
Message-ID: <20100502105058.GA812@heethoofdje.13thmonkey.org>
References: <20100410.200731.57444134.ryusuke@osrg.net>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100410.200731.57444134.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

On Sat, Apr 10, 2010 at 08:07:31PM +0900, Ryusuke Konishi wrote:
> This patch extends the format of segment summary so that it stores a
> checkpoint number in the header.  This is normally not used, but I
> think this would help recovery from critcal situation in which the
> filesystem has lost its pointer to the latest log.

that sounds like i good plan. I'm not that happy about the position in the
structure you added the cno to... Would have like to see `next' as one of the
first fields and all extra appended but thats not the issue i am writing
about.

> diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
> index e21497f..fdf1c3b 100644
> --- a/fs/nilfs2/segbuf.h
> +++ b/fs/nilfs2/segbuf.h
> @@ -37,6 +37,7 @@
>   * @sumbytes: Byte count of segment summary
>   * @nfileblk: Total number of file blocks
>   * @seg_seq: Segment sequence number
> + * @cno: Checkpoint number
>   * @ctime: Creation time
>   * @next: Block number of the next full segment
>   */
> @@ -48,6 +49,7 @@ struct nilfs_segsum_info {
>  	unsigned long		sumbytes;
>  	unsigned long		nfileblk;
>  	u64			seg_seq;
> +	__u64			cno;
>  	time_t			ctime;
>  	sector_t		next;
>  };

What i miss in the patch is the roll-forward support for this. The field
`sector_t next' has moved but i dont see any reference in the patch that takes
into account the size of the structure to see if the `next' field has shifted
position or not. Am i missing/overseeing a thing?

With regards,
Reinoud

P.S. the write support of the NetBSD NiLFS implementation has been delayed
quite some time due to simple lack of time (AKA too many projects running
simultaniously) but after some time dormant i've picked it up again.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

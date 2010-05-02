From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] nilfs2: insert checkpoint number in segment summary
 header
Date: Sun, 02 May 2010 23:27:10 +0900 (JST)
Message-ID: <20100502.232710.172548204.ryusuke@osrg.net>
References: <20100410.200731.57444134.ryusuke@osrg.net>
	<20100502105058.GA812@heethoofdje.13thmonkey.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100502105058.GA812-bVHBekiX4bNgoMqBc1r0ESegHCQxtGRMHZ5vskTnxNA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Reinoud,
On Sun, 2 May 2010 12:50:58 +0200, Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org> wrote:
> Hi Ryusuke,
> 
> On Sat, Apr 10, 2010 at 08:07:31PM +0900, Ryusuke Konishi wrote:
> > This patch extends the format of segment summary so that it stores a
> > checkpoint number in the header.  This is normally not used, but I
> > think this would help recovery from critcal situation in which the
> > filesystem has lost its pointer to the latest log.
> 
> that sounds like i good plan. I'm not that happy about the position in the
> structure you added the cno to...
> 
> What i miss in the patch is the roll-forward support for this. The field
> `sector_t next' has moved but i dont see any reference in the patch that takes
> into account the size of the structure to see if the `next' field has shifted
> position or not. Am i missing/overseeing a thing?

There seems a misunderstanding on use of the structure in question.

nilfs_segsum_info is an on-memory structure and is not for the on-disk
format.  The on-disk summary header is defined by
nilfs_segment_summary as below:

> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
> index 640702e..f642e8a 100644
> --- a/include/linux/nilfs2_fs.h
> +++ b/include/linux/nilfs2_fs.h
> @@ -377,6 +377,7 @@ union nilfs_binfo {
>  * @ss_nfinfo: number of finfo structures
>  * @ss_sumbytes: total size of segment summary in bytes
>  * @ss_pad: padding
> + * @ss_cno: checkpoint number
>  */
>  struct nilfs_segment_summary {
>        __le32 ss_datasum;
> @@ -391,6 +392,7 @@ struct nilfs_segment_summary {
>        __le32 ss_nfinfo;
>        __le32 ss_sumbytes;
>        __le32 ss_pad;
> +       __le64 ss_cno;
>        /* array of finfo structures */
>  };

The checkpoint number field is appended to the tail in order to keep
compatibility; the ``next'' and other fields are not moved in the
header.

nilfs_segsum_info is volatile, so we don't have to care about the
order except for the viewpoint of optimization or simplicity.
 
> P.S. the write support of the NetBSD NiLFS implementation has been delayed
> quite some time due to simple lack of time (AKA too many projects running
> simultaniously) but after some time dormant i've picked it up again.

Me neither for lack of time, thanks anyway :)

With regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

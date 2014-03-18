From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 4/6] nilfs2: add ioctl() to clean snapshot flags from
 dat entries
Date: Tue, 18 Mar 2014 11:10:28 +0400
Message-ID: <1395126628.2190.3.camel@slavad-CELSIUS-H720>
References: <cover.1394966728.git.andreas.rohner@gmx.net>
		 <be7d3bd13015117222aac43194c0fdb9c5d0046f.1394966729.git.andreas.rohner@gmx.net>
	 <1395062377.2221.17.camel@slavad-CELSIUS-H720> <5326FD51.7000209@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=aRdtv2KeIBiL2RC84Uj3lr5UikcbuGkGWwiWx90eSG8=;
	b=N1UjXxoDPVRg6ZCDtfDIPoY4cmLdiuYq3xiKsYLsOD1JupJOZ6DaQd3IxlJVONUQt5wzVnhM5peMVEuqmKJoceoudBKbr2nrl13iVAV4TmBHmr8rYEaOVSeZSdMBh672;
In-Reply-To: <5326FD51.7000209-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 2014-03-17 at 14:49 +0100, Andreas Rohner wrote:

> > 
> >>   */
> >>  struct nilfs_vdesc {
> >>  	__u64 vd_ino;
> >> @@ -873,9 +873,55 @@ struct nilfs_vdesc {
> >>  	__u64 vd_blocknr;
> >>  	__u64 vd_offset;
> >>  	__u32 vd_flags;
> >> -	__u32 vd_pad;
> >> +	/* vd_flags2 needed because of backwards compatibility */
> > 
> > Completely, misunderstand comment. Usually, it keeps old fields for
> > backward compatibility. But this flag is new.
> 
> I will rewrite the comment. I need vd_flags2 because I can't use
> vd_flags because of backwards compatibility.
> 
> >> +	__u32 vd_flags2;

What about vd_blk_state instead of vd_flags2?

> >>  };
> >>  
> >> +/* vdesc flags */
> > 
> > To be honest, I misunderstand why such number of flags and why namely
> > such flags? Comments are really necessary.
> > 
> >> +enum {
> >> +	NILFS_VDESC_DATA,
> >> +	NILFS_VDESC_NODE,
> >> +	/* ... */
> > 
> > What does it mean?
> 
> NILFS_VDESC_DATA = 0 and NILFS_VDESC_NODE = 1. This represents the type
> of block. These two already existed, in the previous version, but they
> were not explicit. See "[Patch 4/4] nilfs-utils: add extra flags to
> nilfs_vdesc and update sui_nblocks":
> 
> @@ -148,17 +149,19 @@ static int nilfs_acc_blocks_file(struct nilfs_file
> *file,
> -				vdesc->vd_flags = 0;	/* data */
> +				nilfs_vdesc_set_data(vdesc);
>  			} else {
>  				vdesc->vd_vblocknr =
>  					le64_to_cpu(*(__le64 *)blk.b_binfo);
> -				vdesc->vd_flags = 1;	/* node */
> +				nilfs_vdesc_set_node(vdesc);
>  			}
> 
> >> +};
> >> +enum {
> >> +	NILFS_VDESC_SNAPSHOT,
> >> +	__NR_NILFS_VDESC_FIELDS,
> >> +	/* ... */
> > 
> > What does it mean?

I asked here about strange comment. What does it mean?

Moreover, I slightly confused by NILFS_VDESC_SNAPSHOT. Is it bit-based
flag? I mean NILFS_VDESC_SNAPSHOT = (1 << 0). Or am I incorrect?

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] fs/nilfs2: Fix potential underflow in call to crc32_le
Date: Sat, 18 Jun 2016 03:25:07 +0900 (JST)
Message-ID: <20160618.032507.1597365191396955107.konishi.ryusuke@lab.ntt.co.jp>
References: <5763AF95.7050302@secunet.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lo6JSUyk0QnTgKtxGFtl7/50v51IFC/0htAWSpoSrOQ=;
        b=yUJiSYUJBCmZolbvS73OIgkTlPNpcivxQef4Po0ALznAjJokDBt+9WzY7uvnfh+oBi
         gW0FpOtAmgDLlrdHaOkZti5FFIJrNOYL476rs9OEaKPhCfK98gaVw8g3Xu4ffiBey3b8
         SHn8fvd3QauDyNjO/UgoyRSv03TNrrpXuX66pEkrsJA+eMAgspUbn6HDyquFfCUR/jz/
         5LgUh4dg8fEOUCduZvq2+N5EQ9EbO9LVlg2/6+EVx29vxyxetQk3pqwJz+hVMtFfkEF1
         WdZ1gqVG9lESrHapR+c/fo/uQ7abfAqdnXwtuMqUk1chLjHiWgWu9Wo+A9ELPblJVSP4
         ZVdw==
In-Reply-To: <5763AF95.7050302-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Torsten Hilbrich <torsten.hilbrich-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

I have a few comments.  Please see the inline comments below.

On Fri, 17 Jun 2016 10:06:45 +0200, Torsten Hilbrich wrote:
> The value bytes comes from the filesystem which is about to be
> mounted. We cannot trust that the value is always in the range
> we expect it to be.
> 
> Check its value before using it to calculate the length for the
> crc32_le call. It value must be larger (or equal) sumoff + 4 and
> smaller than the remaining space in the block where the superblock
> is stored (BLOCK_SIZE - sumoff - 4).
> 

> This fixes a problem where the accidential mounting of an encrypted
> volume caused a kernel panic. It had the correct magic value 0x3434
> at offset 0x406 by chance and the following 2 bytes were 0x01, 0x00
> (interpreted as s_bytes value with value 1).

Could you improve the description on the problem a bit ?

The true issue looks a "memory access overrun" on the superblock
buffer that can occur when "s_bytes - sumoff - 4" underflows and
crc32_le() receives an uninteded large byte count.

The reason why a "kernel panic" occurs, is unclear in the comment.

Even if a non-nilfs volume is mistakenly mounted as a nilfs volume, it
usually will return an error.  Kernel panic should never occur just by
an accidental mount.  If it happens except the overrun issue, it is
another bug.

> 
> Signed-off-by: Torsten Hilbrich <torsten.hilbrich-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
> Tested-by: Torsten Hilbrich <torsten.hilbrich-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
> ---
>  fs/nilfs2/the_nilfs.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index 69bd801..21f6b23 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -438,18 +438,19 @@ static int nilfs_valid_sb(struct nilfs_super_block *sbp)
>  	static unsigned char sum[4];
>  	const int sumoff = offsetof(struct nilfs_super_block, s_sum);
>  	size_t bytes;
> +	size_t crc_offset = sumoff + 4;

The name "crc_offset" is confusing.  This just means the offset of the
latter part of the region that the crc function will verify.
In addition, it should be defined with a "const" qualifier.

>  	u32 crc;
>  
>  	if (!sbp || le16_to_cpu(sbp->s_magic) != NILFS_SUPER_MAGIC)
>  		return 0;
>  	bytes = le16_to_cpu(sbp->s_bytes);
> -	if (bytes > BLOCK_SIZE)

> +	if (bytes < crc_offset || bytes > BLOCK_SIZE - crc_offset)

The latter part of this test should be "bytes > BLOCK_SIZE".
Why do you subtract crc_offset here ?

Regards,
Ryusuke Konishi

>  		return 0;
>  	crc = crc32_le(le32_to_cpu(sbp->s_crc_seed), (unsigned char *)sbp,
>  		       sumoff);
>  	crc = crc32_le(crc, sum, 4);
> -	crc = crc32_le(crc, (unsigned char *)sbp + sumoff + 4,
> -		       bytes - sumoff - 4);
> +	crc = crc32_le(crc, (unsigned char *)sbp + crc_offset,
> +		       bytes - crc_offset);
>  	return crc == le32_to_cpu(sbp->s_sum);
>  }
>  
> -- 
> 2.1.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

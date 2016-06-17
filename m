From: Viacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] fs/nilfs2: Fix potential underflow in call to crc32_le
Date: Fri, 17 Jun 2016 09:51:54 -0700
Message-ID: <1466182314.2756.3.camel@slavad-ubuntu-14.04>
References: <5763AF95.7050302@secunet.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ctPNxGmt9BQJlYOjtSLJLaF/efB4j3+yTp2EaDxBGDU=;
        b=jas1xoa0ma9cT6L3ARBk/rP8Qh3IQ2kLb5HObQnCEkS5LC0sqZaJtvy1jcL/g3A2eX
         9vro8ztMpnUSeTJD3V77qVbuyx1EX7Mz6O8e902uvaBNetSS57Lyd9ZxOiHbaGEifDHO
         KYFkcbQwLMusooIZtqCyIHCuHY9F1LZPHVbOT6u39tvRC53fEzYU3oeZHRMS+Ilni073
         0XNFCW+d/d54lq744/3Z3JvZDP+Kiu6FKfpXDyzDtMSfL+jGxQjEMlfs0ytFXg7BSHC5
         49KXDcaVEG0GkstD9nOFzgp0LvBMsx5Xb6SGc+/HXYKEFWDxaMf13mjWlukNHZrLO9gW
         DzMQ==
In-Reply-To: <5763AF95.7050302-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Torsten Hilbrich <torsten.hilbrich-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 2016-06-17 at 10:06 +0200, Torsten Hilbrich wrote:
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

Hard-coded value looks very weird and not understandable, usually. Could
you change hard-coded value on some declared constant with reasonable
name or on sizeof(something)?

Thanks,
Vyacheslav Dubeyko.

>  	u32 crc;
>  
>  	if (!sbp || le16_to_cpu(sbp->s_magic) != NILFS_SUPER_MAGIC)
>  		return 0;
>  	bytes = le16_to_cpu(sbp->s_bytes);
> -	if (bytes > BLOCK_SIZE)
> +	if (bytes < crc_offset || bytes > BLOCK_SIZE - crc_offset)
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


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

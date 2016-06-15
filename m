From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 3/3] nilfs2: move ioctl interface and disk layout to
 uapi separately
Date: Wed, 15 Jun 2016 22:27:13 +0900 (JST)
Message-ID: <20160615.222713.1679449238980418194.konishi.ryusuke@lab.ntt.co.jp>
References: <1465825507-3407-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1465825507-3407-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<20160614152952.05480c4a15aaf7973f302080@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p11bNmwirw/UBE93B1oSsIycu9qo0djiG+eQqHfSiLU=;
        b=cXc7jRlYe8mghUM3vIhEqk95iYqeK6aSNzmFFZOdwERfrcwqzl7dKPUDNyhHyin2Y+
         SYfTpVi04ctUg058eqJ+K8hjSO6foBLtbkjptSSsFR+esRD3WEiVkuAOEc1EiDtzfEJd
         E29KgVcm70nhSfQMsToAG96Ah6s0v7ilFlhEya1NOBtAgs5vBlE59O9BJDBvcu0gW8Bw
         Z1ghAPzB7uKw24Y1qVCJqKGD9kKvzqoHTr6jRiHQ6+S5pGD51KXHKVzYnZP9OzOZ+m/g
         Qbmyxi1c2mC/AWoDwgEG0/GMSC5AQoen4uFIvqAHbq7uFWL2G6TrQTr8l9Hyy0j7d6fC
         y/pA==
In-Reply-To: <20160614152952.05480c4a15aaf7973f302080-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, 14 Jun 2016 15:29:52 -0700, Andrew Morton wrote:
> On Mon, 13 Jun 2016 22:45:07 +0900 Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> 
>> The header file "include/linux/nilfs2_fs.h" is composed of parts for
>> ioctl and disk format, and both are intended to be shared with user
>> space programs.
>> 
>> This moves them to the uapi directory "include/uapi/linux" splitting
>> the file to "nilfs2_api.h" and "nilfs2_ondisk.h".  The following minor
>> changes are accompanied by this migration:
>> 
>>  - nilfs_direct_node struct in nilfs2/direct.h is converged to
>>    nilfs2_ondisk.h because it's an on-disk structure.
>>  - inline functions nilfs_rec_len_from_disk() and
>>    nilfs_rec_len_to_disk() are moved to nilfs2/dir.c.
>> 
>> ...
>>
>> +static inline __le16 nilfs_rec_len_to_disk(unsigned int len)
>> +{
>> +#if (PAGE_SIZE >= 65536)
>> +	if (len == (1 << 16))
>> +		return cpu_to_le16(NILFS_MAX_REC_LEN);
>> +
>> +	BUG_ON(len > (1 << 16));
> 
> Is there any way in which the mount of a corrupted filesystem could
> trigger this BUG?  If so, that would be bad.

This BUG is never triggered in theory because the length is limited to
"chunk_size" by nilfs_check_page(), nilfs_make_empty(), etc, and the
chunk_size is limited to s_blocksize which is verified to be less than
or equal to NILFS_MAX_BLOCK_SIZE (= 65536) at mount time.

This time I didn't come up with a simple way to remove it - I hope to
clean it when refactoring the directory implementation.

Thanks,
Ryusuke Konishi


>> +#endif
>> +	return cpu_to_le16(len);
>> +}
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

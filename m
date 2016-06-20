From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] fs/nilfs2: Fix potential underflow in call to crc32_le
Date: Sun, 19 Jun 2016 23:53:51 -0700
Message-ID: <CAKFNMo=6A9Ns3EDe8PFL+LMX769WdGT39yo-p+Oi7gzPLG3-9w@mail.gmail.com>
References: <5763AF95.7050302@secunet.com> <20160618.032507.1597365191396955107.konishi.ryusuke@lab.ntt.co.jp>
 <57677408.1@secunet.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=2Iv+24qO40tPrNenXpNPuZ/+Igl4SzFIJUtBEQ/BB7w=;
        b=CZmVoINpgOOX6rH6FG/wjrDBDuZCiT1UEtZkCZ9G5Av29C7IlFW5XVkSX/LAc/YuOa
         4Himc+wkv3CyuGWguHegcV3Z9MCfFYYgdOVHy3+KCS6ElVDUUe2W5T9ivYquzZLyKC8s
         gIgY3sR+THeFjqqlZTFiJliFtshVLwoarhEfalT1cYKWNcAYABAWQTQEPY5o0g3ir2Kd
         S2HITxz8V7DM0tsV46X+CbU4YTethHgQrIyQIbXXK2GYhsE8XwUDCTRcrVwTeiHFGweP
         S8hQ4UUshxSgLbyQtOWdIayDBbFKn8EyZ/IwYu6J0lUECOKE0FRL6XJfJ6uCETI2pZc1
         ZOSQ==
In-Reply-To: <57677408.1-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Torsten Hilbrich <torsten.hilbrich-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Torsten,

Thank you for your cooperation.

I saw the log and the patch, then
I have one more thing to ask you to change.

Could you drop the modifications related to the new constant
"crc_start" or "crc_offset" ?

The position and the importance of your patch became clear
since you inserted by the oops message and the commit log.

I now want the fix to be delivered also to stable-trees in order
to reflect it to old kernels.   For it, the patch is recommended
to be simple and include only necessary change.

Thus, it's preferable to only include the change:

-       if (bytes > BLOCK_SIZE)
+       if (bytes < sumoff + 4  || bytes > BLOCK_SIZE)

Regards,
Ryusuke Konishi


2016-06-19 21:41 GMT-07:00 Torsten Hilbrich <torsten.hilbrich-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>:
> On 17.06.2016 20:25, Ryusuke Konishi wrote:
>> Hi,
>>
>> I have a few comments.  Please see the inline comments below.
>>
>> On Fri, 17 Jun 2016 10:06:45 +0200, Torsten Hilbrich wrote:
>>> The value bytes comes from the filesystem which is about to be
>>> mounted. We cannot trust that the value is always in the range
>>> we expect it to be.
>>>
>>> Check its value before using it to calculate the length for the
>>> crc32_le call. It value must be larger (or equal) sumoff + 4 and
>>> smaller than the remaining space in the block where the superblock
>>> is stored (BLOCK_SIZE - sumoff - 4).
>>>
>>
>>> This fixes a problem where the accidential mounting of an encrypted
>>> volume caused a kernel panic. It had the correct magic value 0x3434
>>> at offset 0x406 by chance and the following 2 bytes were 0x01, 0x00
>>> (interpreted as s_bytes value with value 1).
>>
>> Could you improve the description on the problem a bit ?
>>
>> The true issue looks a "memory access overrun" on the superblock
>> buffer that can occur when "s_bytes - sumoff - 4" underflows and
>> crc32_le() receives an uninteded large byte count.
>>
>> The reason why a "kernel panic" occurs, is unclear in the comment.
>>
>> Even if a non-nilfs volume is mistakenly mounted as a nilfs volume, it
>> usually will return an error.  Kernel panic should never occur just by
>> an accidental mount.  If it happens except the overrun issue, it is
>> another bug.
>
> You are right, I only got the kernel panic when first testing on a
> grsecurity kernel. I repeated the test and there just a BUG on the
> underflow/overrun is reported. I have attached the kernel logs of this
> test run to this mail (nilfs.bug).
>
>>
>>>
>>> Signed-off-by: Torsten Hilbrich <torsten.hilbrich-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
>>> Tested-by: Torsten Hilbrich <torsten.hilbrich-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
>>> ---
>>>  fs/nilfs2/the_nilfs.c | 7 ++++---
>>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
>>> index 69bd801..21f6b23 100644
>>> --- a/fs/nilfs2/the_nilfs.c
>>> +++ b/fs/nilfs2/the_nilfs.c
>>> @@ -438,18 +438,19 @@ static int nilfs_valid_sb(struct nilfs_super_block *sbp)
>>>      static unsigned char sum[4];
>>>      const int sumoff = offsetof(struct nilfs_super_block, s_sum);
>>>      size_t bytes;
>>> +    size_t crc_offset = sumoff + 4;
>>
>> The name "crc_offset" is confusing.  This just means the offset of the
>> latter part of the region that the crc function will verify.
>> In addition, it should be defined with a "const" qualifier.
>
> I will rename it to crc_start.
>
>>
>>>      u32 crc;
>>>
>>>      if (!sbp || le16_to_cpu(sbp->s_magic) != NILFS_SUPER_MAGIC)
>>>              return 0;
>>>      bytes = le16_to_cpu(sbp->s_bytes);
>>> -    if (bytes > BLOCK_SIZE)
>>
>>> +    if (bytes < crc_offset || bytes > BLOCK_SIZE - crc_offset)
>>
>> The latter part of this test should be "bytes > BLOCK_SIZE".
>> Why do you subtract crc_offset here ?
>
> I made here some wrong assumption about the memory layout and the
> meaning of bytes. bytes is the end of the area which is to be
> crc32-checked so comparing against BLOCK_SIZE (which should be the
> maximum size of the super block) is okay.
>
>>
>> Regards,
>> Ryusuke Konishi
>>
>>>              return 0;
>>>      crc = crc32_le(le32_to_cpu(sbp->s_crc_seed), (unsigned char *)sbp,
>>>                     sumoff);
>>>      crc = crc32_le(crc, sum, 4);
>>> -    crc = crc32_le(crc, (unsigned char *)sbp + sumoff + 4,
>>> -                   bytes - sumoff - 4);
>>> +    crc = crc32_le(crc, (unsigned char *)sbp + crc_offset,
>>> +                   bytes - crc_offset);
>>>      return crc == le32_to_cpu(sbp->s_sum);
>>>  }
>>>
>>> --
>>> 2.1.4
>>> --
>
> I will sent an updated patch.
>
>         Torsten
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

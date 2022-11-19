From: Chen Zhongjin <chenzhongjin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] nilfs2: Fix nilfs_sufile_mark_dirty() not set segment
 usage as dirty
Date: Sat, 19 Nov 2022 17:39:34 +0800
Message-ID: <1e20693d-a72a-2247-fbd9-3715f44d0aa2@huawei.com>
References: <20221118063304.140187-1-chenzhongjin@huawei.com>
 <20221118141138.c091445bdda36b78f6277c1f@linux-foundation.org>
 <0e693d41-0bb5-b4a9-19b7-1c71e90e06bf@huawei.com>
 <55553de4-04c3-09f3-b075-f0112d2298cb@huawei.com>
 <CAKFNMom=vjGrXJoc02ut8GocQ6hMmHrkcdReEvk-ykcE4p0b-w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <CAKFNMom=vjGrXJoc02ut8GocQ6hMmHrkcdReEvk-ykcE4p0b-w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On 2022/11/19 15:17, Ryusuke Konishi wrote:
> Hi Chen Zhongjin,
>
> On Sat, Nov 19, 2022 at 2:29 PM Chen Zhongjin wrote:
>>
>> On 2022/11/19 13:24, Chen Zhongjin wrote:
>>> On 2022/11/19 6:11, Andrew Morton wrote:
>>>> On Fri, 18 Nov 2022 14:33:04 +0800 Chen Zhongjin
>>>> <chenzhongjin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>>>>
>>>>> In nilfs_sufile_mark_dirty(), the buffer and inode are set dirty, but
>>>>> nilfs_segment_usage is not set dirty, which makes it can be found by
>>>>> nilfs_sufile_alloc() because it checks nilfs_segment_usage_clean(su).
>>>>>
>>>>> This will cause the problem reported by syzkaller:
>>>>> https://syzkaller.appspot.com/bug?id=c7c4748e11ffcc367cef04f76e02e931833cbd24
>>>>>
>>>>>
>>>>> It's because the case starts with segbuf1.segnum = 3, nextnum = 4, and
>>>>> nilfs_sufile_alloc() not called to allocate a new segment.
>>>>>
>>>>> The first time nilfs_segctor_extend_segments() allocated segment
>>>>> segbuf2.segnum = segbuf1.nextnum = 4, then nilfs_sufile_alloc() found
>>>>> nextnextnum = 4 segment because its su is not set dirty.
>>>>> So segbuf2.nextnum = 4, which causes next segbuf3.segnum = 4.
>>>>>
>>>>> sb_getblk() will get same bh for segbuf2 and segbuf3, and this bh is
>>>>> added to both buffer lists of two segbuf.
>>>>> It makes the list head of second list linked to the first one. When
>>>>> iterating the first one, it will access and deref the head of second,
>>>>> which causes NULL pointer dereference.
>>>>>
>>>>> Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
>>>> Merged in 2009!
>>> Yes, seems it is introduced at the beginning of this file and the
>>> function called nilfs_touch_segusage().
>>>
> Could you please resubmit the patch reflecting the following comments ?
>
> After I replied to Andrew, I noticed them.
> Also, When reposting, it would be helpful if you could add all the
> tags I asked for Andrew in advance.
>
> Comments:
> 1) Please change nilfs_sufile_mark_dirty() so that it protects the
> segusage modification
> with &NILFS_MDT(sufile)->mi_sem:
>
>> --- a/fs/nilfs2/sufile.c
>> +++ b/fs/nilfs2/sufile.c
>> @@ -495,12 +495,18 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
>>   int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
>>   {
>>        struct buffer_head *bh;
>> +     void *kaddr;
>> +     struct nilfs_segment_usage *su;
>>        int ret;
>>
>>        ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
> +       down_write(&NILFS_MDT(sufile)->mi_sem);
>>        if (!ret) {
>>                mark_buffer_dirty(bh);
>>                nilfs_mdt_mark_dirty(sufile);
>> +             kaddr = kmap_atomic(bh->b_page);
>> +             su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
>> +             nilfs_segment_usage_set_dirty(su);
>> +             kunmap_atomic(kaddr);
>>                brelse(bh);
>>        }
> +       up_write(&NILFS_MDT(sufile)->mi_sem);
>>        return ret;
> All functions that modify metadata on the sufile need protection with
> this R/W semaphore.
> You may not see this protection for some sufile functions as is, but
> in that case, the wrapper function that uses them acquires this R/W
> semaphore instead.
>
> Since I retested for this change as well, you don't have to drop my
> "Tested-by" tag.
>
> 2) Please use the following complete email address for the
> "Reported-by" tag of syzbot.
>
> Reported-by: syzbot+77e4f005cb899d4268d1-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
>
> Your tag is partially abbreviated.  I don't know that abbreviation is
> valid, but there are very few examples of such.
> And even if it's valid for syzbot, I don't think that omission is
> desirable as some tools may not support it.

Thanks for suggestions! I have sent v2 for all of them, please check.


Best,

Chen

> Thanks,
> Ryusuke Konishi

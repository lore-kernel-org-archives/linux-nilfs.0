From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 1/3] nilfs2: add new nilfs_suinfo_update struct
Date: Fri, 24 Jan 2014 13:11:47 +0100
Message-ID: <52E25883.3010307@gmx.net>
References: <cover.1390310509.git.andreas.rohner@gmx.net>	<cec6a449ddf5ae9da2928cdddfb96ebcb2789eee.1390312777.git.andreas.rohner@gmx.net> <20140124.135635.27780504.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140124.135635.27780504.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-01-24 05:56, Ryusuke Konishi wrote:
> On Tue, 21 Jan 2014 15:00:28 +0100, Andreas Rohner wrote:
>> This adds struct nilfs_suinfo_update and some flags. It contains the
>> information needed to update one entry of segment usage information in
>> the SUFILE. The flags specify, which fields need to be updated.
>>
>> This can be used to update segment usage information from userspace with an
>> ioctl.
>>
>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>> ---
>>  include/linux/nilfs2_fs.h | 39 +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 39 insertions(+)
>>
>> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
>> index 9875576..2ee1594 100644
>> --- a/include/linux/nilfs2_fs.h
>> +++ b/include/linux/nilfs2_fs.h
>> @@ -709,6 +709,45 @@ static inline int nilfs_suinfo_clean(const struct nilfs_suinfo *si)
>>  	return !si->sui_flags;
>>  }
>>  
>> +/**
>> + * nilfs_suinfo_update - segment usage information update
>> + * @sup_segnum: segment number
>> + * @sup_flags: flags for which fields are active in sup_sui
>> + * @sup_sui: segment usage information
>> + */
>> +struct nilfs_suinfo_update {
>> +	__u64 sup_segnum;
>> +	__u32 sup_flags;
>> +	struct nilfs_suinfo sup_sui;
>> +};
> 
> This structure is not aligned on 8 byte boundary.  You need a 4 byte
> pad to make the alignment architecture independent since the structure
> already has some 64-bit variables.
> 
> If you do not so, the ioctl will lose compatibility, for instance,
> between 32 bit userland programs and 64 bit kernel.
> 
> struct nilfs_suinfo_update {
> 	__u64 sup_segnum;
> 	__u32 sup_flags;
> 	__u32 sup_reserved;
> 	struct nilfs_suinfo sup_sui;
> };

Ok, I thought 4 byte alignment would be enough. But now I see the
problem, nilfs_suinfo contains 64 bit values, that need to be 8 byte
aligned on a 64 bit architecture.

> Do you really need different suinfo update flags per segment ?

No.

> If it's not so, we don't have to add nilfs_suinfo_update structure.
> v_flags of nilfs_argv structure looks to be available for that purpose.

Yes v_flags is available, but I need nilfs_suinfo_update to contain the
segment number. I can't use v_index for the segment number like with
GET_SUINFO, because the segment numbers are not necessarily sequential.
If I use v_index I could effectively only use the ioctl to update one
segment at a time. So I thought, since I need  nilfs_suinfo_update
anyway, I might as well put the flags there. But with the extra
alignment it gets a bit ugly, so I tend to agree with you to put the
flags into v_flags now.

Maybe I missed something, but how would you propose to send the segment
numbers, only using nilfs_suinfo and nilfs_argv?

It is certainly possible to use v_index of nilfs_argv and update one
segment at a time. It shouldn't be a problem, because there are at most

#define NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN_MAX	32

segments to be updated.

> It's just a confirmation.  Basically, I think this extension
> is acceptable.

Cool. Thanks!

br,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 4/6] nilfs2: add ioctl() to clean snapshot flags from
 dat entries
Date: Tue, 18 Mar 2014 09:38:31 +0100
Message-ID: <53280607.4060201@gmx.net>
References: <cover.1394966728.git.andreas.rohner@gmx.net>		 <be7d3bd13015117222aac43194c0fdb9c5d0046f.1394966729.git.andreas.rohner@gmx.net>	 <1395062377.2221.17.camel@slavad-CELSIUS-H720> <5326FD51.7000209@gmx.net> <1395126628.2190.3.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395126628.2190.3.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-03-18 08:10, Vyacheslav Dubeyko wrote:
> On Mon, 2014-03-17 at 14:49 +0100, Andreas Rohner wrote:
> 
>>>
>>>>   */
>>>>  struct nilfs_vdesc {
>>>>  	__u64 vd_ino;
>>>> @@ -873,9 +873,55 @@ struct nilfs_vdesc {
>>>>  	__u64 vd_blocknr;
>>>>  	__u64 vd_offset;
>>>>  	__u32 vd_flags;
>>>> -	__u32 vd_pad;
>>>> +	/* vd_flags2 needed because of backwards compatibility */
>>>
>>> Completely, misunderstand comment. Usually, it keeps old fields for
>>> backward compatibility. But this flag is new.
>>
>> I will rewrite the comment. I need vd_flags2 because I can't use
>> vd_flags because of backwards compatibility.
>>
>>>> +	__u32 vd_flags2;
> 
> What about vd_blk_state instead of vd_flags2?

Yes sounds good to me.

>>>>  };
>>>>  
>>>> +/* vdesc flags */
>>>
>>> To be honest, I misunderstand why such number of flags and why namely
>>> such flags? Comments are really necessary.
>>>
>>>> +enum {
>>>> +	NILFS_VDESC_DATA,
>>>> +	NILFS_VDESC_NODE,
>>>> +	/* ... */
>>>
>>> What does it mean?
>>
>> NILFS_VDESC_DATA = 0 and NILFS_VDESC_NODE = 1. This represents the type
>> of block. These two already existed, in the previous version, but they
>> were not explicit. See "[Patch 4/4] nilfs-utils: add extra flags to
>> nilfs_vdesc and update sui_nblocks":
>>
>> @@ -148,17 +149,19 @@ static int nilfs_acc_blocks_file(struct nilfs_file
>> *file,
>> -				vdesc->vd_flags = 0;	/* data */
>> +				nilfs_vdesc_set_data(vdesc);
>>  			} else {
>>  				vdesc->vd_vblocknr =
>>  					le64_to_cpu(*(__le64 *)blk.b_binfo);
>> -				vdesc->vd_flags = 1;	/* node */
>> +				nilfs_vdesc_set_node(vdesc);
>>  			}
>>
>>>> +};
>>>> +enum {
>>>> +	NILFS_VDESC_SNAPSHOT,
>>>> +	__NR_NILFS_VDESC_FIELDS,
>>>> +	/* ... */
>>>
>>> What does it mean?
> 
> I asked here about strange comment. What does it mean?

Sorry for the misunderstanding. I copied the comment from other flags like:

enum {
	NILFS_SEGMENT_USAGE_ACTIVE,
	NILFS_SEGMENT_USAGE_DIRTY,
	NILFS_SEGMENT_USAGE_ERROR,

	/* ... */
};

I guess it means "additional flags come here".

But you are right it is confusing it should be like that:

enum {
	NILFS_VDESC_SNAPSHOT,
	NILFS_VDESC_PROTECTION_PERIOD,

	/* ... */

	__NR_NILFS_VDESC_FIELDS,
};

> Moreover, I slightly confused by NILFS_VDESC_SNAPSHOT. Is it bit-based
> flag? I mean NILFS_VDESC_SNAPSHOT = (1 << 0). Or am I incorrect?

Yes NILFS_VDESC_SNAPSHOT and NILFS_VDESC_PROTECTION_PERIOD are
bit-based. NILFS_VDESC_DATA and NILFS_VDESC_NODE are not bit-based
because of backwards compatibility.

Please also note, that [PATCH 5/6] adds another flag, namely
NILFS_VDESC_PROTECTION_PERIOD.

Best regards,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

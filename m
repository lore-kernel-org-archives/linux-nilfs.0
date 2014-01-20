From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 1/4] nilfs-utils: cldconfig add an option to set minimal
 free blocks
Date: Mon, 20 Jan 2014 12:55:46 +0100
Message-ID: <52DD0EC2.9060706@gmx.net>
References: <cover.1390139797.git.andreas.rohner@gmx.net>		 <685e5c720189d1e451ed8a0d65581aa8c5a3f7f0.1390139797.git.andreas.rohner@gmx.net>	 <1390212899.3034.66.camel@slavad-ubuntu> <52DCFFEB.4070809@gmx.net> <1390215908.3034.95.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1390215908.3034.95.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

On 2014-01-20 12:05, Vyacheslav Dubeyko wrote:
> I suppose that it should be made by nilfs_cleanerd by itself but not an
> user.
> 
>>> What will we have in situation when an user selects not proper value of
>>> threshold?
>>
>> Well that's the users problem. You could also ask what will happen if
>> the user selects an improper min_clean_segments value ;)
>>
> 
> I don't think that it is good approach not to defend an user from
> mistaken decision.

I guess my point was, that NILFS2 isn't the user friendliest file system
on the planet anyway. Good documentation in the config file and sensible
default values would probably be the best solution.

We could of course set some default value and remove the option from the
config file, but I think it is a powerful option and the user might want
to tweak it to his or her needs.

>>> I worried about situation of skipping sibling segments from cleaning. Is
>>> NILFS2 driver really ready for this? Did you think about efficiency of
>>> free space allocation after such cleaning and about file system
>>> consistency? Are you sure that all will be good after such approach of
>>> cleaning? I simply want to be sure that you have analyzed this.
>>
>> I tested it extensively and I am quite sure, that there are no problems
>> with that on the driver side.
>>
> 
> I want to listen the approach at whole and arguments how it works for
> the NILFS2 at whole. Such words as "I tested it and it works" is
> dangerous. Did you check your file system by fsck? I suppose that you
> don't. So, we need some reasonable description of concept that it prove
> your vision.

Ok I am sorry about that. Let me address all of your points:

If you look at nilfs_sufile_alloc in sufile.c you will see, that the
allocation algorithm basically just remembers the last allocated segment
in sh_last_alloc and then from there sequentially scans the SUFILE for a
clean segment. Thereby it checks the flags of the nilfs_segment_usage
structure and skips it if it is not clean:

if (!nilfs_segment_usage_clean(su))
	continue;

So it is perfectly capable of skipping segments that are left over at
random places.

Could that reduce the performance of the allocation algorithm? Probably
yes, but I don't think it would be significant. Most of the SUFILE will
be in Cache anyway.

I don't see how the file system consistency could be affected by just
updating a timestamp in the SUFILE. The value of su_lastmod is never
used in the driver. It is only set at creation time and used by the GC
to sort the segment list.

Best regards,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

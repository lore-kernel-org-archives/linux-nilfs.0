From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 1/4] nilfs-utils: cldconfig add an option to set minimal
 free blocks
Date: Mon, 20 Jan 2014 11:52:27 +0100
Message-ID: <52DCFFEB.4070809@gmx.net>
References: <cover.1390139797.git.andreas.rohner@gmx.net>	 <685e5c720189d1e451ed8a0d65581aa8c5a3f7f0.1390139797.git.andreas.rohner@gmx.net> <1390212899.3034.66.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1390212899.3034.66.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

On 2014-01-20 11:14, Vyacheslav Dubeyko wrote:
> On Sun, 2014-01-19 at 15:01 +0100, Andreas Rohner wrote:
> 
> It is expected "From: <author name and name>" and "Subject: <subject>"
> in the begin of patch.

Are you sure? I don't see that in other patches and I think this
information is already contained in the email headers. I used "git
send-email" to submit the patch.

>> With this option the user can specify the minimal number of free/dead
>> blocks, which is a threshold for the GC. If there are less free blocks
>> to gain from cleaning a segment than the specified number, the GC will
>> abort and try again with a different segment.
>>
> 
> What will be under stress? I mean situation when we processed all
> segments that it is valuable for cleaning on threshold basis. Then we
> need to clean segments for space allocation but all "dirty" segments not
> reasonable choice for cleaning because of threshold.

You have a point here. I could add another option that is used when the
file system is under stress. Just like with cleaning_interval and
mc_cleaning_interval. By setting the mc-option to 0 you could disable
the threshold under stress.

> What will we have in situation when an user selects not proper value of
> threshold?

Well that's the users problem. You could also ask what will happen if
the user selects an improper min_clean_segments value ;)

> I worried about situation of skipping sibling segments from cleaning. Is
> NILFS2 driver really ready for this? Did you think about efficiency of
> free space allocation after such cleaning and about file system
> consistency? Are you sure that all will be good after such approach of
> cleaning? I simply want to be sure that you have analyzed this.

I tested it extensively and I am quite sure, that there are no problems
with that on the driver side.

Thanks for reviewing my patches,

Best regards,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

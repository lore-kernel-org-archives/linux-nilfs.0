From: Mark Trumpold <markt-qk0wvQ0ghJwAvxtiuMwx3w@public.gmane.org>
Subject: Re: Obtaining kernel patches
Date: Fri, 06 Sep 2013 07:33:21 -0700
Message-ID: <CE4F33C9.8E07%markt@netqa.com>
References: <1378449417.2326.18.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378449417.2326.18.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

Thank you for this information.  I will try applying the patch you
suggest.  Upgrading our kernel is not desirable at this time, as
it could introduce other problems.

Also, thank you for all you hard work on nilfs.

Best regards,
Mark Trumpold


On 9/5/13 11:36 PM, "Vyacheslav Dubeyko" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:

>Hi Mark,
>
>On Thu, 2013-09-05 at 07:54 -0700, Mark Trumpold wrote:
>> Hello nilfs'ers:
>> 
>> I've been actively using nilfs in my project for a couple years now,
>> and follow closely the development via this mailing list.
>> 
>> In my environment nilfs has been very stable; however, the way I'm
>> using it does not stress any existing race conditions (fairly quiet
>> activity).
>> 
>> Recently however I have a case where a snapshot disappeared, and a
>> message in the syslog from the nilfs cleaner "..snapshot count
>>mismatch..".
>> 
>
>I believe that we understand now the initial reason of your issue. I
>posted the patch [1] that initiates discussion with the goal to
>elaborate proper solution of the issue. Currently, suggested by me
>solution can be treated as workaround yet.
>
>I hope that solving of the discovered problem can stabilize NILFS2
>driver significantly.
>
>> I'm using Debian and the 3.3.1 kernel, and am wondering how to best
>>obtain
>> all important patches to date.
>> 
>
>All suggested patches are discussed in this e-mail list publicly. So,
>you are informed about all existing implementation or bug fixing
>activity in NILFS2.
>
>Usually, every reasonable patch is committed in -next branch of Linux
>kernel after discussion in this e-mail list. Then, after some time,
>NILFS2 patches are merged in stable kernel version during current merge
>window. If a patch has significant importance from stability point of
>view then it is merged in long-term supported Linux kernel versions. So,
>you are getting important NILFS2 updates by means of updating of your
>distro. But, of course, you can get the latest stable version of the
>Linux kernel by yourself. Finally, if you are updating your kernel on
>regular basis then you have actual state of the NILFS2 driver.
>
>With the best regards,
>Vyacheslav Dubeyko.
>
>[1] http://www.spinics.net/lists/linux-fsdevel/msg68054.html
>
>
>


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

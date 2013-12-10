From: Jon Watte <jwatte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs error
Date: Tue, 10 Dec 2013 08:47:31 -0800
Message-ID: <CAJgyHGMKCwOKR9dZ6tfTr8j7vMaye94HsiWVZSYZ3Y=+P=HkYQ@mail.gmail.com>
References: <CAJgyHGOeRhj7D4GeyfHhBjXLE3K40DiakT2Zms2D7TPB-BiRog@mail.gmail.com>
	<BA9C3894-7D2F-4FA1-88DE-E830102A0B5D@dubeyko.com>
	<CAJgyHGMmxs8RUiFiZyJW2xNODuip_1yYkUTZ1_-VSPWivtHeSg@mail.gmail.com>
	<1386657940.4007.24.camel@slavad-ubuntu>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=nARah3UQzEFrSvrzm6mStQGvv/x9OWkLpOnIzzdhd64=;
        b=qIV+TISe5zN5a/VLTCOgLQjBpoQsWoPAzAU9GSyPPQBNW0DzPekJ0JaXwYViqLW+Nq
         kU49uSpEeQD3MnOlR/OdSQ6aHAGPrebIZLS6scrHrLtZD+O0lWDk+yZz8xhy8lV4qJfq
         N+vDunt15KeLEagI6HBAPC7c4dudSg5No0BTBtYePTaAUTbQw+/UeJWiiQQbb7Wb7w0C
         SQTwl0Od3kYJxfRIbHwvWDRjmS/we/DsU7Ap93Mly/uO0Yn96Zq+PsaLb9PwKyJmIND0
         vB28eJ0vkGNW1Hp6eHhWNnYKov+14rF5ilP1eq549HaYwMj38PblYP2nSaSVEfvAFMXt
         2ezg==
In-Reply-To: <1386657940.4007.24.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Thanks for your suggestions. I have no idea about how to reproduce the
issue -- this is a light-to-medium-use desktop system.
I took an image of that volume and can mount it on an older kernel if
I need to copy out any files, although all of the important stuff was
in git or dropbox off-site, so no data really lost.
Is there anything I can do to this volume that would give you more
information about what the cause might be (i e, whether the cause is
patched or not)?
Some debug utility that will create a dump of some sort that will
help? Else I will probably just wipe that image and recover the 30G of
space.

Sincerely,

jw




Sincerely,

Jon Watte


--
"I pledge allegiance to the flag of the United States of America, and
to the republic for which it stands, one nation indivisible, with
liberty and justice for all."
~ Adopted by U.S. Congress, June 22, 1942


On Mon, Dec 9, 2013 at 10:45 PM, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:
> On Mon, 2013-12-09 at 08:33 -0800, Jon Watte wrote:
>> I am using Linux robot1 3.12.3-1-ARCH #1 SMP PREEMPT Wed Dec 4
>> 21:45:42 CET 2013 x86_64 GNU/Linux
>>
>> Is that an "old" kernel?
>>
>
> I can see that v3.12.2 tag contains the patch is mentioned by me.
>
>> Also, note that an "old" kernel (from February this year) could mount
>> this image, whereas this newer kernel hung. Is that consistent with
>> the changes you have done?
>>
>
>> NILFS: bad bree node (blocknr=1364234) ; level = 100; flags = 0x73; nchildren = 12336
>> NILFS error (device sda1): nilfs_bmap_lookup_contig: broken bmap (inode number=3935)
>
> Such error messages mean that you have corrupted NILFS2 volume. My patch
> doesn't recover NILFS2 volume. It fixes the reason of such corruption.
> And corruption of NILFS2 volume takes place without any visible
> symptoms. So, you had volume corruption more earlier than you have
> discovered the issue. I have such vision of the situation on your side.
> Your NILFS2 volume was corrupted on kernel version that it doesn't
> contain my patch. And you had discovered the issue after kernel update
> only by chance. It is simply coincidence, from my point of view.
>
> I suppose that error messages are emitted by nilfs-cleanerd. So, you can
> mount volume without any troubles if nilfs-cleanerd doesn't work.
>
> Of course, I can be not fully correct in treating of your situation. The
> error message about broken bmap is very common and there are many
> possible reason of it. But, anyway, this message means corruption of
> volume. As a result, I need in reproducing path of the issue. I can't
> investigate and fix the issue without opportunity of reproducing the
> issue on my side. Can you reproduce the issue from the state of valid
> volume to corrupted state stably? And could you share reproducing path
> of the issue?
>
> If I am right in understanding of your issue then I suppose that
> possible solution can be: (1) create new NILFS2 volume; (2) copy valid
> data from corrupted NILFS2 volume; (3) continue using new NILFS2 volume
> under last version of kernel version. Unfortunately, we haven't fsck
> tool for NILFS2 yet.
>
> Thanks,
> Vyacheslav Dubeyko.
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Mark Trumpold <markt-qk0wvQ0ghJwAvxtiuMwx3w@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Sat, 18 Jan 2014 08:25:07 -0800
Message-ID: <CEFFE8EC.9A4A%markt@netqa.com>
References: <CAFvQSYQZtf0fsfX_7zNHdw4hVo9VHggN9F0TYEi1Fwo2ZvS4Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFvQSYQZtf0fsfX_7zNHdw4hVo9VHggN9F0TYEi1Fwo2ZvS4Ng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>



On 1/18/14 1:44 AM, "Clemens Eisserer" <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

>Hi again,
>
>> Rather, the issue on the flash devices may come from the current
>> immature garbage collection algorithm.  The current cleanerd only
>> supports the timestamp-based GC policy which always tries to move the
>> oldest segment first and even moves segments full of live blocks,
>> thereby shortens the lifetime of flash devices. :-(
>
>It depends - for SSDs the timestamp policy is not optimal as it leads
>to unnecessary writes.
>
>On the other hand, most cards only implement dynamic wear leveling
>(wear leveling takes only place for areas that are written to, which
>leads to very uneven wear distribution when there is mostly static
>data) and also don't have read-disturb handling.
>So for cards it is actually helpful to have the writes spread out
>evenly and as a bonus there is no need to worry about read-disturb
>effects =)
>
>Regards, Clemens
>--
>To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


Hi Clemens and group,

Good information.  So, is it true that the logging/cow nature of
nilfs actually improves wear leveling by having 'writes spread out
evenly'?

Regards,
Mark T.
>


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

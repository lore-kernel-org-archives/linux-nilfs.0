From: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Subject: Re: Nilfs2 crash debugging
Date: Mon, 26 Aug 2013 20:37:56 +0200
Message-ID: <521BA084.80901@antoneliasson.se>
References: <51F2A8A4.4020400@antoneliasson.se>  <51F2A945.6050909@antoneliasson.se>  <9016EBD5-1E01-476F-B1B9-66AE593F4728@dubeyko.com>  <520CB032.2000602@antoneliasson.se>  <FEA41B6A-7D82-4563-AAF5-D5AFA3734D79@dubeyko.com>  <521A1C88.9080100@antoneliasson.se> <1377510966.2621.3.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377510966.2621.3.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vyacheslav Dubeyko skrev 2013-08-26 11:56:
> On Sun, 2013-08-25 at 17:02 +0200, Anton Eliasson wrote:
>
> [snip]
>> Yes. Here's another huge kernel.log for you [2]. It's 19 MB compress=
ed
>> and 282 MB uncompressed. I blanked the log while running the stock
>> kernel and then rebooted to the custom debugging kernel. X wouldn't
>> start so I just logged in to a virtual terminal, changed directory t=
o
>> "~/Bilder/20130321-28 Jakobs bilder fr=C3=A5n Nederl=C3=A4nderna" an=
d then
>> executed `cat 179.JPG >/dev/null`.
>>
>> This caused a read-only remount and a bunch of "broken bmap" message=
s to
>> show, followed by an "Input/Output error". I saved a copy of
>> /var/log/kernel.log as soon as I could after that, before reinstalli=
ng
>> the stock kernel and rebooting.
>>
>> [1]: http://antoneliasson.se/publicdump/config.x86_64.last.20130825
>> [2]: http://antoneliasson.se/publicdump/kernel.log.20130825.gz
>>
> Yes, it's great. Thank you. Now I can investigate the issue's
> environment. I suspect that this issue is related to the issue with
> "unable to handle kernel paging request" in nilfs_end_page_io(). But,
> maybe, I am wrong. Anyway, it is a good basis for more detailed
> understanding of the issue.
>
> Thanks,
> Vyacheslav Dubeyko.
>
>
You're welcome. And thank you for your thorough instructions. It's been=
=20
very informative and worthwhile for me to patch and build a kernel with=
=20
custom options. Let me know if you need more experiments run on the=20
damaged filesystem. Otherwise I'll delete the stored disk images in a=20
month or two.

--=20
Best Regards,
Anton Eliasson

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

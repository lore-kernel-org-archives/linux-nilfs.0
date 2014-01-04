From: Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH nilfs-utils 1/2] cleanerd: call _exit(2) twice for
 ensuring not being a session leader
Date: Sat, 4 Jan 2014 22:18:00 +0900
Message-ID: <CAE1WaKLvwoTwM0W5Wsv0wcWSzihWLjifNi3HXsPt3XK529tanQ@mail.gmail.com>
References: <1388561449-13980-1-git-send-email-mitake.hitoshi@gmail.com>
	<1388561449-13980-2-git-send-email-mitake.hitoshi@gmail.com>
	<20140101.183018.491730600.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=TWcKCs7nYK2Mt4Q6Socjm+p2IFsPlQss9S4lXz+FYvo=;
        b=WtcuWHOMx0Okfv0VLEpLBnU/C2Z5PtFbF8R2F+v71aBxtHmJYKI61ic3Apvw+cHEF4
         QrL9iDFJOzb9XvOPdE5us06c5LCZbqQK9+/y/kZQ1Afq24v0mPACEJ4g3JKupUuCoYn7
         IQUrhdkOx0LUIzmMNH4akZaxYoG8mOAI+8PsVdZH9uGSZ7r5ZLhKLSPidiJyGg1BVgYS
         y3Y5iD42oLirn5pPQ0Wz5qZzKjqQjTyafzcI4Hk9TGjUMksMu6+JxJqakfZYTn4cRRkb
         f0xQ0taYfvCApLWu/vS25WerboVc7UNuifT9398YnppN/PM0QIfAa0LE6n9KNk8AowIQ
         z/Lw==
In-Reply-To: <20140101.183018.491730600.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

On Wed, Jan 1, 2014 at 6:30 PM, Ryusuke Konishi
<konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> On Wed,  1 Jan 2014 16:30:48 +0900, Hitoshi Mitake wrote:
>> Current daemonize() function of cleanerd call _exit(2) only once during its
>> process of becoming a daemon process. But in the linux environment, a daemon
>> process should call _exit(2) twice for ensuring not being a session leader. If a
>> process don't do that, unexpected SIGHUP can be sent to the process (though it
>> happens rarely). The signal would be confusing event for cleanerd of nilfs. This
>> patch removes this potential problem.
>>
>> Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
>> ---
>>  sbin/cleanerd/cleanerd.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
>> index 26067bd..edfa083 100644
>> --- a/sbin/cleanerd/cleanerd.c
>> +++ b/sbin/cleanerd/cleanerd.c
>> @@ -676,6 +676,16 @@ static int daemonize(int nochdir, int noclose, int nofork)
>>
>>       /* umask(0); */
>>
>> +     /* for ensuring I'm not a session leader */
>> +     if (!nofork) {
>> +             pid = fork();
>> +             if (pid < 0)
>> +                     return -1;
>> +             else if (pid != 0)
>> +                     /* parent */
>> +                     _exit(0);
>> +     }
>> +
>
> I tried your patch, but the cleaner daemon still was a session leader.

Thanks for your review and testing.

>
> This turned out because nilfs_cleanerd is usually executed by
> mount.nilfs2 program with the nofork option (-n).
>
> To fix this problem, it looks like the above !nofork check of the
> second fork() should be removed even though it becomes confusing.  In
> that case, we may need to add some explanation why fork() should be
> called even if nofork is specified.

For ensuring not being a session leader, fork() should be called twice. Removing
the second condition of !nofork is not enough. For this purpose, we need to
remove both of the conditions of !nofork.

BTW, what is an intention of "-n" option of cleanerd? I read the code of
nilfs_launch_cleanerd() but couldn't understand the reason of this option.

If this option is aiming to reduce calling of fork(), I think this can be
eliminated. Calling 3 fork()s (1 in mount.nilfs2, 2 in cleanerd) would be
acceptable.

Thanks,
Hitoshi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

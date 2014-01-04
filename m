From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH nilfs-utils 1/2] cleanerd: call _exit(2) twice for
 ensuring not being a session leader
Date: Sat, 04 Jan 2014 23:28:06 +0900 (JST)
Message-ID: <20140104.232806.190364467.konishi.ryusuke@lab.ntt.co.jp>
References: <1388561449-13980-2-git-send-email-mitake.hitoshi@gmail.com>
	<20140101.183018.491730600.konishi.ryusuke@lab.ntt.co.jp>
	<CAE1WaKLvwoTwM0W5Wsv0wcWSzihWLjifNi3HXsPt3XK529tanQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAE1WaKLvwoTwM0W5Wsv0wcWSzihWLjifNi3HXsPt3XK529tanQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,
On Sat, 4 Jan 2014 22:18:00 +0900, Hitoshi Mitake wrote:
> On Wed, Jan 1, 2014 at 6:30 PM, Ryusuke Konishi
> <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
>> On Wed,  1 Jan 2014 16:30:48 +0900, Hitoshi Mitake wrote:
>>> Current daemonize() function of cleanerd call _exit(2) only once during its
>>> process of becoming a daemon process. But in the linux environment, a daemon
>>> process should call _exit(2) twice for ensuring not being a session leader. If a
>>> process don't do that, unexpected SIGHUP can be sent to the process (though it
>>> happens rarely). The signal would be confusing event for cleanerd of nilfs. This
>>> patch removes this potential problem.
>>>
>>> Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
>>> ---
>>>  sbin/cleanerd/cleanerd.c | 10 ++++++++++
>>>  1 file changed, 10 insertions(+)
>>>
>>> diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
>>> index 26067bd..edfa083 100644
>>> --- a/sbin/cleanerd/cleanerd.c
>>> +++ b/sbin/cleanerd/cleanerd.c
>>> @@ -676,6 +676,16 @@ static int daemonize(int nochdir, int noclose, int nofork)
>>>
>>>       /* umask(0); */
>>>
>>> +     /* for ensuring I'm not a session leader */
>>> +     if (!nofork) {
>>> +             pid = fork();
>>> +             if (pid < 0)
>>> +                     return -1;
>>> +             else if (pid != 0)
>>> +                     /* parent */
>>> +                     _exit(0);
>>> +     }
>>> +
>>
>> I tried your patch, but the cleaner daemon still was a session leader.
> 
> Thanks for your review and testing.
> 
>>
>> This turned out because nilfs_cleanerd is usually executed by
>> mount.nilfs2 program with the nofork option (-n).
>>
>> To fix this problem, it looks like the above !nofork check of the
>> second fork() should be removed even though it becomes confusing.  In
>> that case, we may need to add some explanation why fork() should be
>> called even if nofork is specified.
> 
> For ensuring not being a session leader, fork() should be called twice. Removing
> the second condition of !nofork is not enough. For this purpose, we need to
> remove both of the conditions of !nofork.

Yes, I supposed here that the caller (the mount helper program)
already did a fork() call when -n option is specified.

But, anyway, removing only the latter check of !nofork isn't a good
idea.  It's a hacky.

> BTW, what is an intention of "-n" option of cleanerd? I read the code of
> nilfs_launch_cleanerd() but couldn't understand the reason of this option.

This is an option just to avoid fork doubly when mount.nilfs2 already
did a fork().

> If this option is aiming to reduce calling of fork(), I think this can be
> eliminated. Calling 3 fork()s (1 in mount.nilfs2, 2 in cleanerd) would be
> acceptable.

Okay, accepting 3 forks()s seems reasonable.  So, how about changing
both programs as follow?

 1) Change cleanerd to simply ignore -n option as a historical option
    (remove the existing !nofork check).
 2) Change cleanerd always fork twice to ensure that it will not be a
    session leader.
 3) Change cleaner_exec.c not to add -n option.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Fri, 29 Mar 2013 12:15:10 +0400
Message-ID: <1364544910.11128.9.camel@slavad-ubuntu>
References: <50A65588.3000205@li.ru>
	 <CAKFNMomO6ebYkXk=A9H2Wieswvogt6dj16Otj0u74M4aHOOPBg@mail.gmail.com>
	 <20121127151924.GW4028@wloczykij>
	 <295B3FE7-A44E-4D57-9A6A-B725EF1BA9EB@dubeyko.com>
	 <20121128142116.GY4028@wloczykij> <1354113560.2017.11.camel@slavad-ubuntu>
	 <20121128205943.GZ4028@wloczykij> <1354172459.2077.11.camel@slavad-ubuntu>
	 <20130328120700.GK1672@wloczykij>
	 <E24177B1-2EF0-4274-BD13-4642E3663D08@dubeyko.com>
	 <20130329074249.GL1672@wloczykij>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=3z2koWzLZTJT8cVfzWhifcncUWPr3iWkm8PeQFmbMuI=;
	b=Bw8cfSotYCnAaXrnBKXKnDZQEdfZzxehTq9lAvNAkA1T5+DBdkF9JfUZKWqTWgCa2B5Lt4/grQdlaQBX8ptCqz622qaAZZmGHXzzB/KpOb06SOm/C+eveP7YN5DGAtJ7;
In-Reply-To: <20130329074249.GL1672@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 2013-03-29 at 08:42 +0100, Piotr Szymaniak wrote:
> On Thu, Mar 28, 2013 at 10:22:52PM +0300, Vyacheslav Dubeyko wrote:
> > Thank you for additional details. Unfortunately, your sysrq-trigger
> > output is not complete. So, I can't make conclusion about what
> > operation was a reason of issue on your side. Could you send to me the
> > full log of sysrq-trigger output?
> 
> How to generete more verbose log?
> 

I meant that sysrq-trigger output ends with resume about runnable tasks
and locks in the system (for example):

[ 8670.960040] runnable tasks:
[ 8670.960040]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 8670.960040] ----------------------------------------------------------------------------------------------------------
[ 8670.960040]      migration/1    14         0.002037      2223     0         0.002037      2308.610315         0.000000 /
[ 8670.960040]      kworker/1:1    29   2713578.453275     43727   120   2713578.453275      2098.177537   8659787.039783 /
[ 8670.960040] R           bash 11089        61.102602       142   120        61.102602        39.773082     46581.905519 /autogroup-171
[ 8670.960040] 
[ 8670.960040] 
[ 8670.960040] Showing all locks held in the system:
[ 8670.960040] 1 lock held by getty/892:
[ 8670.960040]  #0:  (&ldata->atomic_read_lock){+.+.+.}, at: [<ffffffff81460139>] n_tty_read+0x399/0x950
[ 8670.960040] 1 lock held by getty/901:
[ 8670.960040]  #0:  (&ldata->atomic_read_lock){+.+.+.}, at: [<ffffffff81460139>] n_tty_read+0x399/0x950
[ 8670.960040] 1 lock held by getty/927:
[ 8670.960040]  #0:  (&ldata->atomic_read_lock){+.+.+.}, at: [<ffffffff81460139>] n_tty_read+0x399/0x950
[ 8670.960040] 1 lock held by getty/930:
[ 8670.960040]  #0:  (&ldata->atomic_read_lock){+.+.+.}, at: [<ffffffff81460139>] n_tty_read+0x399/0x950
[ 8670.960040] 1 lock held by getty/937:
[ 8670.960040]  #0:  (&ldata->atomic_read_lock){+.+.+.}, at: [<ffffffff81460139>] n_tty_read+0x399/0x950
[ 8670.960040] 1 lock held by getty/1214:
[ 8670.960040]  #0:  (&ldata->atomic_read_lock){+.+.+.}, at: [<ffffffff81460139>] n_tty_read+0x399/0x950
[ 8670.960040] 1 lock held by bash/9572:
[ 8670.960040]  #0:  (&ldata->atomic_read_lock){+.+.+.}, at: [<ffffffff81460139>] n_tty_read+0x399/0x950
[ 8670.960040] 1 lock held by bash/9797:
[ 8670.960040]  #0:  (&ldata->atomic_read_lock){+.+.+.}, at: [<ffffffff81460139>] n_tty_read+0x399/0x950
[ 8670.960040] 1 lock held by bash/9879:
[ 8670.960040]  #0:  (&ldata->atomic_read_lock){+.+.+.}, at: [<ffffffff81460139>] n_tty_read+0x399/0x950
[ 8670.960040] 1 lock held by bash/10021:
[ 8670.960040]  #0:  (&ldata->atomic_read_lock){+.+.+.}, at: [<ffffffff81460139>] n_tty_read+0x399/0x950
[ 8670.960040] 1 lock held by bash/10224:
[ 8670.960040]  #0:  (&ldata->atomic_read_lock){+.+.+.}, at: [<ffffffff81460139>] n_tty_read+0x399/0x950
[ 8670.960040] 2 locks held by bash/11089:
[ 8670.960040]  #0:  (sysrq_key_table_lock){......}, at: [<ffffffff814689c2>] __handle_sysrq+0x32/0x190
[ 8670.960040]  #1:  (tasklist_lock){.?.?.-}, at: [<ffffffff810bf4e4>] debug_show_all_locks+0x44/0x1e0
[ 8670.960040] 
[ 8670.960040] =============================================

So, I need in full sysrq-trigger output for understanding situation on
your side. Could you share it?


> Btw looking at ps aux output it seems, that this flush is hanging there
> almost from first boot:
> root       937 88.2  0.0      0     0 ?        S    Feb17 50160:39 [flush-8:0]
> 

Could you share "cat /proc/partitions" and "mount" outputs? I need to
understand what partition is processed by [flush-8:0].

> And an uptime:
> 08:25:18 up 39 days, 10:57,  4 users,  load average: 0.72, 0.89, 0.98
> 

Yes, it can define a reason of the issue on your side.

> Also I don't know if this isn't some kind of regression. I'm using nilfs
> for, well, some time now (looking at fs creation date Aug 2011) and
> didn't noticed any strange behaviour before. I think I won't be able to
> check this, but before that last boot I used (95% sure) vanilla kernel
> 3.4.4 and it was not flushing things or I didn't noticed. I could go to
> some older LTS kernel on other machine and check that.
> 
> 
> > I can easily reproduce the issue by big file (100 - 500 GB) deletion
> > or truncation. Please, find description in:
> > http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01504.html.
> 
> If this brings something new - I'm not using huge files like that (this
> flush above is a 3.7G device). But if this reproduces the issue, it
> could be related.  (:
> 

Yes, it is really important to understand the situation on your side.
Because you can have another reason of the issue with similar symptoms.
So, we need to investigate your case more deeply, I think.

With the best regards,
Vyacheslav Dubeyko.

> 
> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Wed, 12 Jun 2013 22:31:10 +0200
Message-ID: <51B8DA8E.6020802@antoneliasson.se>
References: <1369809573.2253.31.camel@slavad-ubuntu>  <20130529.233757.27789741.konishi.ryusuke@lab.ntt.co.jp>  <1369894385.2255.8.camel@slavad-ubuntu>  <20130530.155543.480320022.konishi.ryusuke@lab.ntt.co.jp> <1370501769.2202.36.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370501769.2202.36.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vyacheslav Dubeyko skrev 2013-06-06 08:56:
> On Thu, 2013-05-30 at 15:55 +0900, Ryusuke Konishi wrote:
>> On Thu, 30 May 2013 10:13:05 +0400, Vyacheslav Dubeyko wrote:
>>> On Wed, 2013-05-29 at 23:37 +0900, Ryusuke Konishi wrote:
>>>> I don't know whether this may be a hint of this trouble, but according
>>>> to the system log, page_buffers() of nilfs_end_page_io() seems to hit
>>>> an Oops due to an invalid page address "0x36cd":
>>>>
>>> Yes. There are two possible way to be in nilfs_end_page_io(): (1)
>>> nilfs_segctor_complete_write(); (2) nilfs_abort_logs(). Currently, I
>>> suspect the nilfs_abort_logs()
>> That sounds a likely cause.
>>
>> Can you test nilfs_abort_logs by injecting a random fault in some easy
>> way ?
>>
> So, what I discovered currently.
>
> First of all, unfortunately, I can't reproduce the issue yet, currently.
> I suspect that in this issue the aging state of volume, peculiarity of
> workload and environment play very important role. As I remember, all
> reporters of likewise symptoms (broken bnode error messages) talked
> about several months of successful working of NILFS2 file system.
>
> I tried to make LVM environment as it was described by Anton. But I
> didn't catch the issue in this environment. So, I think that I haven't
> properly aged NILFS2 volume state and I tried not proper workload. It
> needs to think about proper workload more deeply. As I can see from
> Anton's system log that it took place frequent update and git activity.
> Moreover, update and git were nearly before crash:
I'm not so sure that my issues are caused by aging of the filesystem. As 
I described in my third e-mail on May 30 
(http://article.gmane.org/gmane.comp.file-systems.nilfs.user/2957), I 
was able to trash my new /home which was only a week old. I'm starting 
to think it has something to do with either VMware or bup (which is git 
based) or a combination of both.
> May 22 18:48:45 riven slim[274]: [2013-05-22 18:48:43] Downloading update (37 782 of 41 158 KB)...
> May 22 18:48:45 riven slim[274]: [2013-05-22 18:48:43] Downloading update (38 390 of 41 158 KB)...
> May 22 18:48:45 riven slim[274]: [2013-05-22 18:48:43] Downloading update (39 066 of 41 158 KB)...
> May 22 18:48:45 riven slim[274]: [2013-05-22 18:48:44] Downloading update (39 742 of 41 158 KB)...
> May 22 18:48:45 riven slim[274]: [2013-05-22 18:48:44] Downloading update (40 311 of 41 158 KB)...
> May 22 18:48:45 riven slim[274]: [2013-05-22 18:48:44] Downloading update (40 956 of 41 158 KB)...
> May 22 18:48:45 riven slim[274]: [2013-05-22 18:48:45] Downloading update (41 158 of 41 158 KB)...
> May 22 18:50:13 riven slim[274]: [2013-05-22 18:48:45] Downl18:50:13 | Git | default | Checking for remote changes...
> May 22 18:50:13 riven slim[274]: 18:50:13 | Cmd | default | git rev-parse HEAD
> May 22 18:50:13 riven slim[274]: 18:50:13 | Cmd | default | git ls-remote --heads --exit-code "ssh://storage@hephaestus/home/storage/default" master
> May 22 18:50:13 riven slim[274]: 18:50:13 | Git | default | No remote changes, local+remote: 8eab1e96aa618010ff17c11a955f4423d823beb6
> May 22 18:50:14 riven slim[274]: 18:50:14 | ListenerTcp | Pinging tcp://notifications.sparkleshare.org:443/
> May 22 18:50:14 riven slim[274]: 18:50:14 | ListenerTcp | Received pong from tcp://notifications.sparkleshare.org:443/
> May 22 18:53:31 riven kernel: [ 3821.605568] BUG: unable to handle kernel paging request at 00000000000036cd
> May 22 18:53:31 riven kernel: [ 3821.605577] IP: [<ffffffffa027f1a2>] nilfs_end_page_io+0x12/0xc0 [nilfs2]
>
> So, maybe, git activity is a possible workload for the issue
> reproducing. It needs to check it, I suppose.
Git in this case is a part of SparkleShare. SparkleShare is a Git based 
file synchronisation program, much like Dropbox but self hosted. 
However, I've made very little changes to the files tracked by 
SparkleShare so the Git workload should be extremely light.

I believe Steam is what's printing "Downloading update".
> I tried to simulate errors occurrence in nilfs_segctor_do_construct()
> method by means of excluding of error checking in places:
>
[...]

-- 
Best Regards,
Anton Eliasson

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

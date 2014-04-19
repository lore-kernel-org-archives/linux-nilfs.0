From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: few patches from Debian
Date: Sat, 19 Apr 2014 20:26:20 +0900 (JST)
Message-ID: <20140419.202620.220041591.konishi.ryusuke@lab.ntt.co.jp>
References: <6284364.q7fsBQ3iYY@debstor>
	<20140419.195816.57462893.konishi.ryusuke@lab.ntt.co.jp>
	<4645877.yriC0M9ozk@debstor>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4645877.yriC0M9ozk@debstor>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Dmitry Smirnov <onlyjob-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 19 Apr 2014 21:17:19 +1000, Dmitry Smirnov wrote:
> On Sat, 19 Apr 2014 19:58:16 Ryusuke Konishi wrote:
>> This patch breaks mount program; mount.nilfs2 fails to find cleanerd
>> since it was moved to /usr/sbin:
>> 
>>   # mount -t nilfs2 /dev/sdb1 /test
>>   mount.nilfs2: Error: nilfs_cleanerd not found
>>   nilfs_cleanerd aborted
> 
> Damn, sorry for mess...
> 
> 
>> I think nilfs_cleanerd should be installed to /sbin.
> 
> You're right but in this case it should be statically linked with dependent 
> libraries...

Yes, I agree.  nilfs_cleanerd should statically link libnilfs and
libnilfsgc.  I am searching the way to do that.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

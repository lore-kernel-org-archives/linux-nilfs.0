From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: snapshots contain the same rrd database
Date: Wed, 26 Feb 2014 17:54:21 +0400
Message-ID: <1393422861.5481.9.camel@slavad-CELSIUS-H720>
References: <20140226133201.GA2022@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=cGkoEO9kZvKFY/uH+O4saIMcHpxrzgok8ufAhAbeZhk=;
	b=o0n5PS337h7c43DZ8S3MQotwIeqp+nHp2hEOFrpEgrCBAtOTI6mqs/mWnhAwikpKvml1qaQd6WByWsAikvcVWweaKTZweu25/eBqUHQV6QUPNvargJpre3MgCIRqcTTw;
In-Reply-To: <20140226133201.GA2022@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Piotr,

On Wed, 2014-02-26 at 14:32 +0100, Piotr Szymaniak wrote:
> Hi,
> 
> I got a system crash after some 160+ days uptime. After a hard reboot I
> noticed my rrd database looks corrupted.
> 
> So I changed some recent checkpoints to snapshots, mounted them and...
> all the rrd files are the same!
> 

To be honest, I don't understand clearly:
(1) How did you get the issue?
(2) Did you create snapshots after crash?
(3) Had you some snapshots before crash?

If you had a crash then you should have some error messages in the
system log. Have you something? Or did you lose all error messages
during the crash?

Anyway, I need to have the reproducing path for investigate the issue.
Of course, I am not going to wait 160 days before achieving the issue
reproducibility. :) One of the possible way is to share some small
NILFS2 volume with good issue reproducibility. But, currently, I don't
quite follow in what way I can reproduce the issue.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

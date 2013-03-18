From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Corrupted nilfs2 volume
Date: Mon, 18 Mar 2013 23:44:41 +0300
Message-ID: <4E5BDA60-7615-4F82-AC0F-4459DD9EF544@dubeyko.com>
References: <20130315024019.7DC1BD00@mail.dragonworks.ru> <1363328491.2078.21.camel@slavad-ubuntu> <20130315232157.GC1542@black> <70219EF1-8083-4DD5-BA18-84CD1914DC3E@dubeyko.com> <20130318142352.GA4148@black>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=efD1Mn/a9QknJfTOgc2zBYrlkImkoi7qBx+4Rrwi6hY=;
	b=nuN4LulBjCv8Ey86p9tdQhvx3tAp08cAwxVbsJ02cMLn2dC0ZSwkjfQLuZzmRic3IiCW+DfElgggYAqk4MGjfY59Yw3TDjvV6YQfsSHEBbHzpkHh3ojTqoyONN2e+EH5;
In-Reply-To: <20130318142352.GA4148@black>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexander Bezrukov <nilfs-issues-tvrqcU/I3+LBxmVkcvZ8vQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Alexander,

On Mar 18, 2013, at 5:23 PM, Alexander Bezrukov wrote:

[snip]
> 
> [offtopic]: I observed and am still observing continous timeouts
> after data coming from bluehost.com domain like this:
> 
> Mar 15 10:22:18 localhost postfix/smtpd[26071]: connect from oproxy5-pub.bluehost.com[67.222.38.55]
> Mar 15 10:22:19 localhost postfix/smtpd[26071]: 53590D03:client=oproxy5-pub.bluehost.com[67.222.38.55]
> Mar 15 10:24:01 localhost postfix/smtpd[26054]: disconnect from vger.kernel.org[209.132.180.67]
> Mar 15 10:25:18 localhost postfix/smtpd[26037]: timeout after DATA (407 bytes) from unknown[144.76.18.105]
> Mar 15 10:25:18 localhost postfix/smtpd[26037]: disconnect from unknown[144.76.18.105]
> Mar 15 10:26:46 localhost postfix/smtpd[26052]: timeout after DATA (999 bytes) from oproxy1-pub.bluehost.com[66.147.249.253]
> Mar 15 10:26:46 localhost postfix/smtpd[26052]: disconnect from oproxy1-pub.bluehost.com[66.147.249.253]
> Mar 15 10:26:46 localhost postfix/cleanup[26053]: 39E48256: message-id=<1363328491.2078.21.camel@slavad-ubuntu>
> Mar 15 10:27:19 localhost postfix/smtpd[26071]: timeout after DATA (1006 bytes) from oproxy5-pub.bluehost.com[67.222.38.55]
> Mar 15 10:27:19 localhost postfix/smtpd[26071]: disconnect from oproxy5-pub.bluehost.com[67.222.38.55]
> Mar 15 10:27:19 localhost postfix/cleanup[26060]: 53590D03: message-id=<1363328512.2078.23.camel@slavad-ubuntu>
> Mar 15 10:28:23 localhost postfix/smtpd[26052]: connect from oproxy1-pub.bluehost.com[66.147.249.253]
> Mar 15 10:28:24 localhost postfix/smtpd[26052]: 1995D256: client=oproxy1-pub.bluehost.com[66.147.249.253]
> 
> This may or may not be connected to delivery of your previous mail. What
> makes me to suspect this may have relation is the hostname in the
> message-id. [/offtopic]
> 

Sorry for that. I send e-mails from several machines. I have to configure my e-mail client (Evolution) on Ubuntu more better. Currently, it fills "References" field with something like "some-uid.camel@slavad-ubuntu" instead of real e-mail. But now I don't find solution for it in internet yet.

> 
>> Now you can download nilfs-utils archive with last actual
>> version of fsck.nilfs2 from
>> http://dubeyko.com/development/FileSystems/NILFS/nilfs-utils-fsck-v.0.04-under-development.tar.gz.
> 
> Thank you for the tool.
> 
>> Please, compile utilities set with fsck and run "fsck -v debug [device] 2> [output-file]".
> 
> I first tried with '-n' and discovered that this mode is not supported.
> Then I ran the program as you suggested. I didn't study the program
> source but is seems that this tool never writes. The report came out
> really huge, please download in from
> http://www.dragonworks.ru/nilfs2/fsck.nilfs2.debug.log.xz
> 
> I also prepared the '-v info' version which is considerably smaller:
> http://www.dragonworks.ru/nilfs2/fsck.nilfs2.info.log.xz
> 
> Besides seemengly many problems in the filesystem's structures it
> suggests that the primary and secondary superblocks are not identical
> so I simply copied last 4kB of the volume to offset 1kB --- to no avail.
> (Of course I experimented with a copy of the volume data)
> 
> What else can I do?
> 

As I can see from the debug output last write was on Friday March 15, 2013 at 00:02:24. This write operation took place in segment #23445 (log #0) with sequence number ss_seq = 305303 that begins from block #48015360. It occurred something bad during with write operation or after it. Secondary superblock points out on segment with sequence number ss_seq = 305303. But primary superblock points out on segment with sequence number ss_seq = 305301.

So, I need in raw dump of three segments #23443 (ss_seq = 305301, first block #48011264), #23444 (ss_seq = 305302, first block #48013312), #23445 (ss_seq = 305303, first block #48015360). Please, make raw dump from #48011264 till #48017408 (namely, 6144 blocks) and share with me. Moreover, please, share dumpseg output for this segments.

Tomorrow, I prepare patch with additional debug output for deeper investigation of the issue on your side.

Thanks,
Vyacheslav Dubeyko.

> Thanks and regards.
> Alexander.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

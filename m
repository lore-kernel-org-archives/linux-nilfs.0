From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: NILFS2 get stuck after bio_alloc() fail
Date: Mon, 15 Jun 2009 03:02:45 +0900 (JST)
Message-ID: <20090615.030245.104791670.konishi.ryusuke@gmail.com>
References: <20090614013211.GA22552@homero.springfield.home>
	<20090614.124517.47505469.konishi.ryusuke@gmail.com>
	<20090614153256.GA4020@homero.springfield.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758546AbZFNSC7@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:date:message-id:to:cc:subject
         :from:in-reply-to:references:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        bh=KEaYwcECoYR2qbRt+Opzuv1KIM8SvT5Ox7rSfA/Czdk=;
        b=KRtc+pfrk58VKRIvtNgY0aGzgzPxASXJ29DEe5rRfXjw5xik/1XrLB0oj0U3G3n5vX
         2Xaub24vHkubRxOkUSyyzB61vssEDLBq65qeWAMAYQBt+XAuAS6WmuBlJLO8VTyBQ76d
         d5kEzgh+3eB7OMAy8NGllCZcPR2aOeoIOYjtw=
In-Reply-To: <20090614153256.GA4020@homero.springfield.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org, albertito@blitiri.com.ar, users@nilfs.org, llucax@gmail.com

Hi Leandro,
On Sun, 14 Jun 2009 12:32:56 -0300, Leandro Lucarella wrote:
> Ryusuke Konishi, el 14 de junio a las 12:45 me escribiste:
>> Hi,
>> On Sat, 13 Jun 2009 22:32:11 -0300, Leandro Lucarella wrote:
>> > Hi!
>> > 
>> > While testing nilfs2 (using 2.6.30) doing some "cp"s and "rm"s, I noticed
>> > sometimes they got stucked in D state, and the kernel had said the
>> > following message:
>> > 
>> >         NILFS: IO error writing segment
>> > 
>> > A friend gave me a hand and after adding some printk()s we found out that
>> > the problem seems to occur when bio_alloc()s inside nilfs_alloc_seg_bio()
>> > fail, making it return NULL; but we don't know how that causes the
>> > processes to get stucked.
>> 
>> Thank you for reporting this issue.
>> 
>> Could you get stack dump of the stuck nilfs task?
>> It is acquirable as follows if you enabled magic sysrq feature:
>> 
>>  # echo t > /proc/sysrq-trigger
>> 
>> I will dig into the process how it got stuck.
> 
> Here is (what I thought it's) the important stuff:
<snip>
 
> 'rm' is the "original" stuck process, 'umount' got stuck after that, when I
> tried to umount the nilfs (it was mounted in a loop device).
> 
> Here is the complete trace:
> http://pastebin.lugmen.org.ar/4931

Thank you for your help.

According to your log, there seems to be a leakage in clear processing
of the writeback flag on pages.  I will review the error path of log
writer to narrow down the cause.

Regards,
Ryusuke Konishi

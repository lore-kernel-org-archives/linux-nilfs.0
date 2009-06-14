From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: NILFS2 get stuck after bio_alloc() fail
Date: Sun, 14 Jun 2009 12:45:17 +0900 (JST)
Message-ID: <20090614.124517.47505469.konishi.ryusuke@gmail.com>
References: <20090614013211.GA22552@homero.springfield.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754784AbZFNDpa@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:sender:date:message-id:to:cc
         :subject:from:in-reply-to:references:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        bh=UCN5EA1Uz8EvYfwPaDOF3J1giMk888UyQCx1PhK1Bpw=;
        b=pRLkanbg/EouTgBF5oY7ORgAOPxG18CbKKiRXptvm603JpHk7KVEauHvGG9IN2xzlm
         aAyvfH2/1gwyg5cxGswenU2sgkSfOA19GgCEv5m6orCTNnXYLt6FubXkLGWDmD1DUW17
         sswEpbE3j6H3OGyUjp1cb1+kklkdXExW8N7CU=
In-Reply-To: <20090614013211.GA22552@homero.springfield.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
Cc: linux-kernel@vger.kernel.org, albertito@blitiri.com.ar, users@nilfs.org, llucax@gmail.com, konishi.ryusuke@lab.ntt.co.jp

Hi,
On Sat, 13 Jun 2009 22:32:11 -0300, Leandro Lucarella wrote:
> Hi!
> 
> While testing nilfs2 (using 2.6.30) doing some "cp"s and "rm"s, I noticed
> sometimes they got stucked in D state, and the kernel had said the
> following message:
> 
>         NILFS: IO error writing segment
> 
> A friend gave me a hand and after adding some printk()s we found out that
> the problem seems to occur when bio_alloc()s inside nilfs_alloc_seg_bio()
> fail, making it return NULL; but we don't know how that causes the
> processes to get stucked.
> 
> PS: Please CC me.
> -- 
> Leandro Lucarella (luca) | Blog colectivo: http://www.mazziblog.com.ar/blog/

Thank you for reporting this issue.

Could you get stack dump of the stuck nilfs task?
It is acquirable as follows if you enabled magic sysrq feature:

 # echo t > /proc/sysrq-trigger

I will dig into the process how it got stuck.

P.S.
nilfs.org and the nilfs mailing list is stopping due to planned power
outage.  They will be back on June 15 0:30 a.m.

A backup site except the list is available on
http://nilfs.sourceforge.net/en/ during the period.

Regards,
Ryusuke Konishi

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Thu, 06 Jun 2013 13:34:48 +0400
Message-ID: <1370511288.2209.5.camel@slavad-ubuntu>
References: <1369809573.2253.31.camel@slavad-ubuntu>
	 <20130529.233757.27789741.konishi.ryusuke@lab.ntt.co.jp>
	 <1369894385.2255.8.camel@slavad-ubuntu>
	 <20130530.155543.480320022.konishi.ryusuke@lab.ntt.co.jp>
	 <1370501769.2202.36.camel@slavad-ubuntu>
	 <20130606092054.GA201@diablo.13thmonkey.org>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=5bZ88DsN23gmgsuExdqY4wOCd6StxoI1RgBwDcG4bUE=;
	b=nCVZvkENc9ziM7012MqDzRLF+zx2PRaBPXNbEUFrvbCD0NIRAvXPkq6p9EEJIZ9y8VOR6g8OuyLDk9Fp5Yq1B8gCSmFnHtDiT5gSBa9vOqvpQ7qDCnMwXGsWiC66FOTD;
In-Reply-To: <20130606092054.GA201-HNv6YvNvQKMNqjISwOrxaLFspR4gePGN@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 2013-06-06 at 11:20 +0200, Reinoud Zandijk wrote:
> Hi,
> 
> just my $0.02 so to say:
> 
> On Thu, Jun 06, 2013 at 10:56:09AM +0400, Vyacheslav Dubeyko wrote:
> > First of all, unfortunately, I can't reproduce the issue yet, currently.
> > I suspect that in this issue the aging state of volume, peculiarity of
> > workload and environment play very important role. As I remember, all
> > reporters of likewise symptoms (broken bnode error messages) talked
> > about several months of successful working of NILFS2 file system.
> 
> sounds to me as if a b-tree is in a perculiar state and that updating the
> btree results in this corruption.
> 
> Have you tried to mount one of the checkpoints/snapshots earlier as RO and see
> if those are correct? If so, dumping both DATs and both btrees might give a
> clue as to what went wrong. If only it gives a clue as to how complicated the
> btree is before the updating and what actions are taken on it.
> 

Unfortunately, I haven't reproduced issue on my side. On my side all is
OK. I am trying to reproduce the issue that was reported by many times
of different users. But, currently, without any success on my side. So,
I can't investigate the essence of the issue. I know symptoms but I
don't know reproducing path of the issue.

Thank you for your advice. But without corruption on my side I can't
investigate anything.

Thanks,
Vyacheslav Dubeyko.

> With regards,
> Reinoud
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

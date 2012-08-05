From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs2 not garbage collecting
Date: Sun, 5 Aug 2012 17:54:36 +0400
Message-ID: <F7DFCB7F-9015-4051-9A60-5056EAB81E4D@dubeyko.com>
References: <CANku=ggohcWWoxE1x=XmfWpANKyWRTWb5p_aHh8LU6+utU4OPQ@mail.gmail.com> <CANku=ghnDzkFHpPZ8eT9Y3kTM62zBKMk6TjBVraE4Kisa1TRPQ@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=y7QQkBnGKy35Z1YqqBu8B+mPVelqJzclxAk7FXRrLyQ=;
	b=Wr8THAktdgTbv8n9VtPL841ZSiNMFrJa9VdH9QVY1mnvPbWdRFmJhl9kiS1dlMvx+By/iTLgEOfp2PHCk07fDM6WlzjyIfgQTnkz+hLMQV21mSB2ioW9Ja1obi/tWPKJ;
In-Reply-To: <CANku=ghnDzkFHpPZ8eT9Y3kTM62zBKMk6TjBVraE4Kisa1TRPQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paolo Giangrandi <paolo-UnihLHphgvQ1GQ1Ptb7lUw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Paolo,

On Aug 5, 2012, at 3:00 PM, Paolo Giangrandi wrote:

> Hello,
> 
> I'm using NILFS2 as the root filesystem of an ArchLinux on my EeePC
> 900A. The filesystem has been created last November.
> At the moment there's no more space left, `lscp` shows that there are
> 2648 checkpoints, but nilfs_cleanerd is in idle.
> I tried to tweak nilfs_cleanerd configuration, but couldn't achieve anything.
> 
> Is it possible to know why nilfs_cleanerd isn't collecting the
> checkpoints, or force it to collect them?

Could you share more details about your issue?

It is interested to know:
1. mount output.
2. nilfs_cleanerd configuration.
3. system log content related to NILFS2 or nilfs_cleanerd.
4. ps ax output.
5. cat /proc/partitions.
6. df -h

I think that these info can be starting point for analysis of your issue.

With the best regards,
Vyacheslav Dubeyko.

> 
> Thanks,
> Paolo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

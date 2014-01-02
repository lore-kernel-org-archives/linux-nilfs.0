From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix segctor bug that causes file system corruption
Date: Thu, 2 Jan 2014 23:16:22 +0300
Message-ID: <88B1B6B6-1AC9-4BC4-9776-C07D1360A99F@dubeyko.com>
References: <1388674131-22579-1-git-send-email-andreas.rohner@gmx.net> <741898E4-B794-47FF-ABF6-2DCACA2AED43@dubeyko.com> <52C5961F.8000608@gmx.net> <20140103.021703.220046134.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=c2e3WfnfVpQ322oMU7n79Xipuy8sMkzQHztkNXEQAnc=;
	b=E0d8mviJ5gWnASiuVlpeEGOr33tiOetl0S0h979uyJyY8X/iknRr6sfy6GbDdNYlrvoAMA2kDoKZGBwYuZF/D2yVWkzlADD1oc1cfTUQNF1tMeg14y8/0m5rws8uDa3h;
In-Reply-To: <20140103.021703.220046134.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

On Jan 2, 2014, at 8:17 PM, Ryusuke Konishi wrote:

> Hi, Andreas, and Vyacheslav
> 
> Thank you for posting this patch.
> 
> I reviewed the patch, and yes, the patch looks correct and needed to
> fix the retry logic of nilfs_segctor_collect().
> 
> I am thinking of sending this to upstream.  But, before that, please
> test the patch enough in the same situation to confirm that it
> actually fixes the problem and it doesn't cause other issues.
> 
> At this point, I feel this patch has no defects nor side effects, but
> I cannot test it in the same situation until the next week.
> 

		if (sci->sc_stage.flags & NILFS_CF_SUFREED) {
			err = nilfs_sufile_cancel_freev(nilfs->ns_sufile,
							sci->sc_freesegs,
							sci->sc_nfreesegs,
							NULL);
			WARN_ON(err); /* do not happen */
+			sci->sc_stage.flags &= ~NILFS_CF_SUFREED;
		}

I see adding the code of clear NILFS_CF_SUFREED flag in the patch.
But nilfs_segctor_abort_construction() contains likewise code:

1727         if (sci->sc_stage.flags & NILFS_CF_SUFREED) {
1728                 ret = nilfs_sufile_cancel_freev(nilfs->ns_sufile,
1729                                                 sci->sc_freesegs,
1730                                                 sci->sc_nfreesegs,
1731                                                 NULL);
1732                 WARN_ON(ret); /* do not happen */
1733         }

Maybe, this code needs in flag clearing too?

Anyway, I can see setting this flag and cannot see clearing
of it. Andreas suggests to clear this flag in the patch.
Is logic of setting/clearing this flag fully correct?

With the best regards,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

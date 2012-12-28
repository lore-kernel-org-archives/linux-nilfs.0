From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Which version of nilfs do you use?
Date: Fri, 28 Dec 2012 12:17:39 +0400
Message-ID: <1356682659.2126.23.camel@slavad-ubuntu>
References: <BB9A0F28-A902-4FE4-BA58-A66EA93290F8@gmail.com>
	 <20121228.115843.568913897223506746.hermes@ceres.dti.ne.jp>
	 <1356675289.2126.10.camel@slavad-ubuntu>
	 <20121228.165816.981117143166927771.hermes@ceres.dti.ne.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=2tpI/oTBcJ9/SdM5WPntLh0knu32lnLLkzo83iOK5rs=;
	b=ByJ54jDVgWoq51Eyo+lsjTChcI/SyxdD1xaQQOLIYEKzhiR2k+66BP+/SPWY3tIrK6STHfQvhJahkrjw0EQEluSJCfsRdCXRnaRzxwtoaOahHqZY71A1pXkP9iEPPLjf;
In-Reply-To: <20121228.165816.981117143166927771.hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ARAI Shun-ichi <hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 2012-12-28 at 16:58 +0900, ARAI Shun-ichi wrote:
> In <1356675289.2126.10.camel@slavad-ubuntu>;
>    Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote
>    as Subject "Re: Which version of nilfs do you use?":
> 
> > I think that it can be a synchronization issue. But it needs to
> > investigate the situation more deeply. As I can see, it is using 8 CPUs
> > in the case of the issue and it takes place frequent update. So, it can
> > be a ground for good issue reproducibility, from my point of view.
> 
> CPU of my PC is Core i7 3770S. It has 4 cores with HTT (8 threads).

And you had the issue also. But I tried to reproduce on 2 cores CPU
(without success currently). So, in the case of synchronization issue a
count of CPUs' cores can be a important factor, I think. And
unfortunately, currently, we haven't clear and easy way of the issue
reproducing.

With the best regards,
Vyacheslav Dubeyko.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

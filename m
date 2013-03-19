From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Corrupted nilfs2 volume
Date: Tue, 19 Mar 2013 15:42:23 +0400
Message-ID: <1363693343.2229.28.camel@slavad-ubuntu>
References: <1363680412.2229.14.camel@slavad-ubuntu>
	 <20130319.173020.3478740326553917.hermes@ceres.dti.ne.jp>
	 <1363684508.2229.17.camel@slavad-ubuntu>
	 <20130319.201730.1543938923107719972.hermes@ceres.dti.ne.jp>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=YxWKBOk81Y6zPtAEZg1qh4AwDcjiA0tK28n758Aw7YI=;
	b=dhvEiD0KdWbUMxWhUiPvi5bXPKoLzUflM+GDzjqEf0ZL8btYv3Qa0IPIt7p6md9f1stgvPxewKOf7Da1SS6oarHBMhCfKBwNRvNbTs8Pj5ZcyYE9+PFQbCyRTPyYhcaV;
In-Reply-To: <20130319.201730.1543938923107719972.hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ARAI Shun-ichi <hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>
Cc: nilfs-issues-tvrqcU/I3+LBxmVkcvZ8vQ@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi ARAI,

On Tue, 2013-03-19 at 20:17 +0900, ARAI Shun-ichi wrote:
> Hi,
> 
> In <1363684508.2229.17.camel@slavad-ubuntu>;
>    Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote
>    as Subject "Re: Corrupted nilfs2 volume":
> 
> > On Tue, 2013-03-19 at 17:30 +0900, ARAI Shun-ichi wrote:
> >> Hello,
> >> 
> >> I reported nilfs2 filesystem corruption in Nov.-Dec., 2012.
> > 
> > Could you point out on initial e-mail with report about file system
> > corruption?
> > 
> > It is possible that you had another reason of file system corruption.
> 
> Please refer this.
> 
> In <20121130.164616.1703426007244850753.hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>;
>    ARAI Shun-ichi <hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org> wrote
>    as Subject "Re: A lot of NILFS: bad btree node messages (readonly fs)":
> 

But it is another issue. Now I don't know exactly what is a reason of
the issue that is reported in this thread. And we have different
symptoms in the case of "Re: A lot of NILFS: bad btree node messages
(readonly fs)" and in the case of issue of this thread.

Yes, I am investigating the issue with "bad b-tree node messages". It
was reported recently the script with the reproduction path that is
reproducible on my side. But I am worrying only that this reproduction
path can be a 1 KB related issue (maybe, I am wrong).

But if you can provide some additional details about issue with "bad
b-tree node messages" then, please, share it.

Thanks,
Vyacheslav Dubeyko.


> To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Date: Fri, 30 Nov 2012 16:46:16 +0900 (JST)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

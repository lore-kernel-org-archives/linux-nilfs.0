From: ARAI Shun-ichi <hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>
Subject: Re: Which version of nilfs do you use?
Date: Fri, 28 Dec 2012 16:58:16 +0900 (JST)
Message-ID: <20121228.165816.981117143166927771.hermes@ceres.dti.ne.jp>
References: <BB9A0F28-A902-4FE4-BA58-A66EA93290F8@gmail.com>
	<20121228.115843.568913897223506746.hermes@ceres.dti.ne.jp>
	<1356675289.2126.10.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1356675289.2126.10.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org

In <1356675289.2126.10.camel@slavad-ubuntu>;
   Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote
   as Subject "Re: Which version of nilfs do you use?":

> I think that it can be a synchronization issue. But it needs to
> investigate the situation more deeply. As I can see, it is using 8 CPUs
> in the case of the issue and it takes place frequent update. So, it can
> be a ground for good issue reproducibility, from my point of view.

CPU of my PC is Core i7 3770S. It has 4 cores with HTT (8 threads).
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: ARAI Shun-ichi <hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>
Subject: Re: Which version of nilfs do you use?
Date: Fri, 28 Dec 2012 11:58:43 +0900 (JST)
Message-ID: <20121228.115843.568913897223506746.hermes@ceres.dti.ne.jp>
References: <AAEC3976-3D79-4170-B1DC-2A04499392DE@gmail.com>
	<1902997.ayblf9kj7g@coil>
	<BB9A0F28-A902-4FE4-BA58-A66EA93290F8@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BB9A0F28-A902-4FE4-BA58-A66EA93290F8-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org


In <BB9A0F28-A902-4FE4-BA58-A66EA93290F8-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>;
   Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote
   as Subject "Re: Which version of nilfs do you use?":

> There is more than 2TB of data and a large number of databases, tables in our MySQL service. The conventional cold backup methods can not meet our needs. So we are trying to find some other methods.

I posted report mail about the "bad btree node" error in 2012-11-30,
I told about VirtualBox.
When I met the error first, virtual disk file (approx. 16GB) was in
NILFS FS.

Zhang's DB is large. Perhaps there are files which has large size, I think.
And these files are updated frequently.

Can the common point (file size, update) cause inconsistency?
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [writable snapshots discussion] Does nilfs2 do any in-place
 writes?
Date: Mon, 20 Jan 2014 15:54:09 +0400
Message-ID: <1390218849.3034.121.camel@slavad-ubuntu>
References: <1389787304.3913.28.camel@slavad-ubuntu>
	 <20140116.002353.94325733.konishi.ryusuke@lab.ntt.co.jp>
	 <1389866912.2565.44.camel@slavad-ubuntu>
	 <20140118.075519.43661574.konishi.ryusuke@lab.ntt.co.jp>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=hIsAFVp7ChkByVYodkwFNvWPq4IZshKOMW+j9DPWY7k=;
	b=LpL0yEsnznb0XNyOJsk1/ZIdxm2XROIY3iBNuBJJKY4Q1lliFDe7Y5Kb+1PCbHGOy8zYw3obq21+lxHjXUUeeoGGOdFMQySQ/YAdKgrW3q9vbHwMsG3YY4a7qfVZ9JAT;
In-Reply-To: <20140118.075519.43661574.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

On Sat, 2014-01-18 at 07:55 +0900, Ryusuke Konishi wrote:

> > Yes, I think too that such suggestion is valuable for NILFS2. But I
> > suppose that the problem is more complex. I mean a situation with
> > write-able snapshots. If we will have write-able snapshots then it means
> > necessity to have independent version of some superblock's  fields
> > (s_last_cno, s_last_pseg, s_last_seq, s_mtime, s_wtime, s_mnt_count,
> > s_state, s_c_interval, s_feature_compat_ro, s_feature_incompat). For
> > example, snapshot can be made before xafile creation on a volume and
> > write-able snapshot should continue to live without possibility to xattr
> > creation, and so on.
> 
> OK, please tell me what do you suppose about the writable snapshot.
> 
> Do you think we should keep multiple branches or concurrently
> mountable namespaces on one device ?
> 

When I think about notion of snapshot then I have such understanding.
Read-only snapshot is a "frozen" file system state. Writable snapshot is
an isolated file system state. So, I started from such understanding in
my considerations.

And I suppose that when we keep in one super root info about several
snapshots then we have "multiple branches" approach. But now we use
"concurrently mountable namespaces" approach for read-only snapshots, as
far as I can see. So, I think that users like and use "concurrently
mountable namespaces" and we should keep and evolve this approach. I
didn't think deeply about writable snapshots yet but maybe it will need
to modify VFS for multiple writable snapshots support (but I haven't any
concrete vision of it). Thereby, maybe, "multiple branches" and
"concurrently mountable namespaces" approaches are not contradictory but
complimentary.

> I prefer to maintain only one super root block per partition even if
> we support writable snapshots.  Otherwise, I think we should use
> multiple partitions to simplify the design.
> 
> I mean keeping multiple branches in one super root block with a DAT
> file and a sufile in such a case.  Maintaining multiple DAT files and
> sufiles on one device seems too complex to me.
> 

I suppose that your vision is right. But, anyway, it needs to elaborate
more concrete suggestions for discussion. I simply mentioned about it
but I didn't suggest something concrete. And I am not ready right now to
suggest several ideas. :) Firstly, I want to finish my consideration
about changing of superblocks' in-place update policy.

Anyway, I am going to return to discussion about writable snapshots.

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

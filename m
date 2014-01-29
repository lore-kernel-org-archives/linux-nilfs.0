From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [static superblock discussion] Does nilfs2 do any in-place
 writes?
Date: Wed, 29 Jan 2014 05:19:50 -0800
Message-ID: <1391001590.6162.12.camel@ubuntu>
References: <1389787304.3913.28.camel@slavad-ubuntu>
		 <20140116.002353.94325733.konishi.ryusuke@lab.ntt.co.jp>
		 <1389866912.2565.44.camel@slavad-ubuntu>
		 <20140118.090008.194171715.konishi.ryusuke@lab.ntt.co.jp>
	 <1390901114.2942.11.camel@slavad-ubuntu-12.04> <52E8F7A7.8010505@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=bR1z/908DgG2K8POgED3A++Xhevr0a7QnOoOMNAdMGw=;
	b=tRISiA/kwhSbMXQ4QbEFgjcv68yjHDYYB2NASlITWdC0vkof7NDoUIrp2/E/ODWLHfFqAEg+GLftppaEC6bzgLlK1sAr9LuyfMC4nqxfITRVzx99oEnbkar4uSHc21tn;
In-Reply-To: <52E8F7A7.8010505-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 2014-01-29 at 13:44 +0100, Andreas Rohner wrote:

> 
> I hope I understand your approach correctly. Can it be summarized as
> follows: Instead of overwriting the super block you want to reserve the
> first segment to write the super block in a round-robin way into groups.

Not superblock but super root. It's different things.

> Thereby spreading the writes over a larger area. Then the groups should
> probably have a typical erase block size like 512k. 

Group size hasn't any relation with erase block size. Group is not erase
block. Moreover, different NAND chips can have different erase block
size. Erase block size can be 8 MB for modern chips. I don't think that
it needs to have any relations with erase block size. Group can have
different sizes that it needs to define from the algorithm efficiency
point of view. This special segment will fill by COW policy, anyway. 

> If that is true, I
> don't think you need any special algorithm to search the latest super
> block. You just read in the whole segment at mount time and select the
> one with the biggest s_last_cno.
> 

Even if you read the whole segment then you will need to search. But if
you have smart algorithm then you don't need to read the whole segment
in memory. It can be expensive operation that it will make mount more
slow operation.

> What about Ryusukes suggestion of never updating the super block and
> instead using a clever segment allocation scheme that allows a binary
> search for the latest segment?
> 

I think that you need to read our discussion with more attention. Of
course, my suggestion can have disadvantages and it needs to discuss it
more deeply. But now I have feeling that you misunderstand my suggestion
yet.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

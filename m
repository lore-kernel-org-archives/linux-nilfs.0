From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NiLFS2 partial segment finfo
Date: Fri, 07 Jun 2013 10:18:18 +0400
Message-ID: <1370585898.2257.13.camel@slavad-ubuntu>
References: <20130604194713.GA3311@diablo.13thmonkey.org>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=v301Bs2JXKB1/CnbrsG20bD9PimfpUV0hUhLOB53QXM=;
	b=hUr5Rlgzk1H4xsZPP3dWaAaBaSxO0PpFUr+nfROhicQpvy0RCJt1/yEXrugCaz/xiFr0+6yJgGRncaX/1eUxRzP/eYQ4jgbhfEl0mYdqHQqc2/vYfJD2Eb1l+IrlIYpg;
In-Reply-To: <20130604194713.GA3311-HNv6YvNvQKMNqjISwOrxaLFspR4gePGN@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Reinoud,

On Tue, 2013-06-04 at 21:47 +0200, Reinoud Zandijk wrote:
> Hi folks,
> 
> would the Linux implementation grock multiple finfo's about one file even with
> overlapping blocks ? say a finfo of ino 12345, followed by some finfo's of say
> ino 123400, followed by some more of ino 12345? Or does it implicitly assume a
> kind of ordering in the blocks?
> 

I suspect that I don't exactly follow your thoughts. But I don't
understand about what overlapping blocks you are talking.

I have such understanding. Segment summary begins from segment summary
header (struct nilfs_segment_summary). This structure has many fields.
One of fields is the number of finfo structures in segment summary
block. Then, it follows array of file description items after segment
summary header. Every file description item begins from struct
nilfs_finfo. It defines number of blocks (including intermediate blocks)
and number of file data blocks. It follows array of block information
items (union nilfs_binfo) after each file information item.

So, file describes on block basis. And every file is described by
continuous array of union nilfs_binfo items. What do you mean by blocks
overlapping?

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

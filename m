From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Super Root Block
Date: Mon, 08 Mar 2010 19:08:41 +0900 (JST)
Message-ID: <20100308.190841.192724574.ryusuke@osrg.net>
References: <63c84f241003080059v5f147ecas5b8df9ebc2d154aa@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <63c84f241003080059v5f147ecas5b8df9ebc2d154aa-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: assaf.weizman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Mon, 8 Mar 2010 10:59:44 +0200, Assaf Weizman wrote:
> Hello,
> Could you please explain a few theoretical questions:
> a. What's the meaning/usage of the "Super Root Block"?
> b. in the Readme (v2) file it's described as "an optional super root
> block (SR)". So as optional element,  who chooses to whether to
> activate\use it or not?

The super root block contains inodes of checkpoint file (cpfile),
segment usage file (sufile), and disk address translation (DAT) file.

It represents the top of metadata hierarchy of NILFS at a time point.
For the metadata hierarchy, please see the page 9 of the slides:

 http://www.nilfs.org/papers/jls2009-nilfs.pdf 


I think the term "optional" in the readme looks confusing.

In nilfs, if a series of logs makes a new checkpoint, it essentially
ends with a super root block.  Otherwise, it does not entail the super
root block (there is a variant of log series used for synchronous data
write).

> Thanks a lot. this is a very interesting file system.
> 
> Best regards
> Assaf Weizman

Thank you.  I think the above slides would be helpful than the readme
file.

With regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

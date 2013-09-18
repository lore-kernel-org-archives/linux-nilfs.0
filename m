From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: RE: Problems in GC when using NilFS2 with large segment size
Date: Wed, 18 Sep 2013 11:36:54 +0400
Message-ID: <1379489814.2365.54.camel@slavad-ubuntu>
References: <3764420FCC841C4DAE85E3B76FC61A772A5A74F6@wdscexmb03.sc.wdc.com>
	 <201309161617.AA05682@capsicum.lab.ntt.co.jp>
	 <3764420FCC841C4DAE85E3B76FC61A772A5A77E9@wdscexmb03.sc.wdc.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=Y6d0LPSUbygo8XGINc0gdXCDs6/J8nWQzReDqNc1G24=;
	b=LnYlO6F40ugS46Txn3/6T3wI5bUFyrMnh6sx9XTzN/BlcPEHU1UxjAGrST7AcOh9dQ+ARh/H1Z7dLPngJ7TMfOc5e8zJ3GnDUStep5XTnlYRl492u2kCzdjHgrYYYPoe;
In-Reply-To: <3764420FCC841C4DAE85E3B76FC61A772A5A77E9-hHJbj3FrchuJlWOzvq4633xStJ4P+DSV@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Benixon Dhas <Benixon.Dhas-Sjgp3cTcYWE@public.gmane.org>
Cc: 'Ryusuke Konishi' <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, "'linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Benixon,

On Tue, 2013-09-17 at 18:39 +0000, Benixon Dhas wrote:

Yes, GC of NILFS2 is inefficient now. And GC optimization is the key
direction of NILFS2 optimization at whole, from my viewpoint. But I
suppose that we haven't efficient GC solution for LFS, currently. So,
suggestion of good solution of garbage collection scheme for LFS case is
promising direction, as far as I can judge.

I think that F2FS suggests some interesting approaches of garbage
collection. As you know, there are two classical approaches of GC
policies for the LFS case: (1) threading approach; (2) copying approach.
So, F2FS uses hybrid approach. I assume that it can be useful to be
familiar with F2FS techniques of garbage collection.

I know about efforts of NILFS2 GC optimization [1]. But I dissatisfied
as way of such optimization as code quality. So, I don't think that such
GC optimization is proper way.

If we are talking about shingled drive case then, first of all, it makes
sense to be acquainted with existed patents in this field. As I know,
there are significant number of inventions are suggested by guys from
Hitachi and HGST research centers. There are different suggestions of
using LFS in these patents and considerations about possible GC
overhead.

I think that it need to discuss promising techniques of garbage
collection in NILFS2 more deeply. Moreover, garbage collection
techniques for the case of flash and shingled drive can be different, as
far as I can see. I assume that in the case of shingled drive it makes
sense to use such technique of garbage collection. If you use LFS for
the case of shingled drive then you are using Copy-on-Write (COW)
policy. But, anyway, trying to read or update some sector results in
reading as minimum this sector in a cache. So, if you read not sector
but, for example, segment in a cache then you will have opportunity to
make clean operation in this segment. As a result, your read or update
operation will have addition in the form of copied valid blocks from
cleaned segment. I assume that shingled drive controller should have
support of GC operations in such approach.

> 
> We have tried the second suggestion of reducing the number of segments
> cleaned in a single pass in the configuration file. Even after this we
> are seeing the memory issue.
> Due to limitations of ShIngled Disks the smallest segment size that we
> can go with is 128MB. In our case a larger segment size is desirable.
> 
> We would like a feature which can limit the amount of kernel memory
> that is used for garbage collection. This might make the garbage
> collector inefficient. But it would make it stable on systems with
> limited resources.

By the way, there are probability that you have discovered some issue of
NILFS2 GC. So, if you think so then you need to describe a reproducing
path and what is wrong in GC behavior from your point of view.  

>  We are just beginning to look through the source to understand NilFS2
> better. We can experiment by modifying the NilFS2 source. We would
> welcome any suggestions or pointers that would help us in modifying
> the source. 
> 
NILFS2 has many TODO. So, you are welcome. :)

But if you plan to contribute into NILFS2 project then it makes sense to
distribute tasks. And it is possible to suggest something if you will
choose some TODO.

By the way, I am implementing extended attributes (xattr) support in
NILFS2 right now.

With the best regards,
Vyacheslav Dubeyko.

[1] http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01739.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

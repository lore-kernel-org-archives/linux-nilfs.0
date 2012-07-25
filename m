From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/2] nilfs-utils: add skeleton of fsck.nilfs2
Date: Wed, 25 Jul 2012 10:28:24 +0400
Message-ID: <1343197704.2025.35.camel@slavad-ubuntu-11>
References: <9DBF030C-DB82-4D29-884C-4C036FEC996D@dubeyko.com>
	 <20120725.023654.213985185.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:References:In-Reply-To:Cc:To:From:Subject; bh=ZyNp/9FS7kzjNeoBsEc4NKZkxDFM5Xds+RdMdWI4m0o=;
	b=B3O5dD6z6Ce43IgMJVAl0EAxmjsTpbukPRnR41S0QBEbJ51UkZ/kj3oJK3iz38tzT40iOpMHoAM/9kZUKfWvHmGFVMxzhhUOojJW6lSgxwROjkOwkiK5AWOiD3uCfx+m;
In-Reply-To: <20120725.023654.213985185.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Wed, 2012-07-25 at 02:36 +0900, Ryusuke Konishi wrote:
> Hi,
> On Sun, 22 Jul 2012 19:13:01 +0400, Vyacheslav Dubeyko wrote:
> > Hi,
> > 
> > This patch set adds skeleton of fsck.nilfs2 utility into nilfs-utils package. Currently, fsck.nilfs2 only try to check presence of primary and secondary superblocks. It checks magic signature in superblock.
> > 
> > With the best regards,
> > Vyacheslav Dubeyko.
> 
> I'm planning to look this patchset weekend.

Ok. I see.

> 
> One question is about your plan for proceeding this task.
> 
> Implementing fsck looks a tough task since NILFS has history of data
> and meta-data as well as the current file system structures, and correcting
> filesystem looks to need log write in user-land, which is not yet realized.
> 

I hope that I clear understand possible long duration and complexity of
this task. Currently, it is not so easy to predict duration of this
task. But, from my point of view, fsck is a key point of NILFS today and
it needs to implement it anyway.

> So, taking a step-by-step approach seems essential.
> 

I agree with you. I am thinking about step-by-step approach also. And
skeleton of fsck is a preparatory step.

> In this sense, did you design the skelton, thinking of further steps?
> If you have some strategy to accomplish this task, I'd like to hear
> that.
> 

Yes, you are right. I have some strategy in my mind.

First of all, I think that implementation can be divided into two big
steps:
1. Implementation fsck's checking functionality.
2. Implementation fsck's recovering functionality.

Currently, all my efforts is in direction of implementation fsck's
checking functionality. I think that next immediate step should be
preliminary definition of fsck's architecture, a strategy of fsck's
checking algorithm, discussion of it and declaration of functions' stub
in code.

I am going to elaborate more clear preliminary vision of fsck's checking
functionality during next two weeks (maybe earlier :-)). But, currently
and preliminary, I am thinking about several phases (passes) of check:
1. Check superblocks.
2. Check correctness of metadata in logs.
3. Check correctness of metadata files' contents for segments.
4. Check consistency of file system hierarchy.

This is a really raw and preliminary vision. I feel real necessity to
think more deeply about it. And elaboration of such more clear vision is
my current implementation activities. I am going to elaborate the vision
during implementation of superblocks checking functionality.

With the best regards,
Vyacheslav Dubeyko.

> My concern for this is avoiding rework of the future.
> 
> I'm very thankful for your challenges.
> 
> With regards,
> Ryusuke Konishi
> 
> > --
> >  configure.ac     |    3 ++-
> >  sbin/Makefile.am |    2 +-
> >  2 files changed, 3 insertions(+), 2 deletions(-)
> > 
> >  sbin/fsck/Makefile.am        |   13 ++
> >  sbin/fsck/fsck_messages.c    |  254 ++++++++++++++++++++++++
> >  sbin/fsck/fsck_messages.def  |   62 ++++++
> >  sbin/fsck/fsck_messages.h    |  110 +++++++++++
> >  sbin/fsck/fsck_nilfs2.c      |  379 +++++++++++++++++++++++++++++++++++
> >  sbin/fsck/fsck_nilfs2.h      |   37 ++++
> >  sbin/fsck/fsck_raw_ops.c     |  413 +++++++++++++++++++++++++++++++++++++++
> >  sbin/fsck/fsck_raw_ops.h     |   46 +++++
> >  sbin/fsck/nilfs_superblock.c |  445 ++++++++++++++++++++++++++++++++++++++++++
> >  sbin/fsck/nilfs_superblock.h |   48 +++++
> >  10 files changed, 1807 insertions(+), 0 deletions(-)
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] radix tree test suite: fix mapshift build target
Date: Thu, 12 Apr 2018 14:19:41 -0700
Message-ID: <20180412211941.GC18364@bombadil.infradead.org>
References: <20180412210518.27557-1-ross.zwisler@linux.intel.com>
 <20180412141543.a9d587c3836338e78de33d30@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cF/PmJWSw103CZky1TX4LRknwzi4RarSKD4AKGDh2qI=; b=S985yAGrUQ6EakQQLCg8xGX/I
        Pg5jKE8/NfKrEJHjE2sWq+4CwmlhxZ0AhMf7iXPOoMhnvjLBmLH9DToXZTNI8Kveo9A6xtlhn8cVX
        34T6zHCZSz0tjpGH4vlLANLu/PAL7JkqgDJxjsuKQXLi4wJjpFbm/Y5X5/wBS4lD5Pv7t9H1L6/Ox
        ugKn7zQ07epD9gIKTeIzVURWL0LvUjgtLh7KgB7Xs9z/JULCG/HhXFBYW1lIwZmyIOt6ibPYUqhTt
        a18rRiN7CK78yXLdYfqXD8OCLyz4fxShgJS0O6WhRoIYmY0/R3pEZTjVDAl0JtGFhDfbBNqVNCPLi
    
Content-Disposition: inline
In-Reply-To: <20180412141543.a9d587c3836338e78de33d30@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

On Thu, Apr 12, 2018 at 02:15:43PM -0700, Andrew Morton wrote:
> On Thu, 12 Apr 2018 15:05:18 -0600 Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
> 
> > The following commit
> > 
> >   commit c6ce3e2fe3da ("radix tree test suite: Add config option for map
> >   shift")
> > 
> > Introduced a phony makefile target called 'mapshift' that ends up
> > generating the file generated/map-shift.h.  This phony target was then
> > added as a dependency of the top level 'targets' build target, which is
> > what is run when you go to tools/testing/radix-tree and just type 'make'.
> > 
> > Unfortunately, this phony target doesn't actually work as a dependency, so
> > you end up getting:
> > 
> > $ make
> > make: *** No rule to make target 'generated/map-shift.h', needed by 'main.o'.  Stop.
> > make: *** Waiting for unfinished jobs....
> > 
> > Fix this by making the file generated/map-shift.h our real makefile target,
> > and add this a dependency of the top level build target.
> 
> I still get
> 
> akpm3:/usr/src/25/tools/testing/radix-tree> make
> cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o main.o main.c
> In file included from ./linux/../../../../include/linux/radix-tree.h:28:0,
>                  from ./linux/radix-tree.h:6,
>                  from main.c:10:
> ./linux/rcupdate.h:5:10: fatal error: urcu.h: No such file or directory

apt-get install liburcu-dev

>  #include <urcu.h>
> 
> 
> lots of breakage here :(
> 

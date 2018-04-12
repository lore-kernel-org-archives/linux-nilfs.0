From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v9 07/61] xarray: Add the xa_lock to the radix_tree_root
Date: Thu, 12 Apr 2018 14:10:36 -0700
Message-ID: <20180412211036.GB18364@bombadil.infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
 <20180313132639.17387-8-willy@infradead.org>
 <CAOxpaSXDX1fyrOnnsehEoRgQz2_K1OmOn9TikZzJcXmwMLEfnA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OsKUX0QV+N05Od7oweT6fR8623V/nmVlEU3udQw6ZKY=; b=Zo5pvshUoFSydCo7lpgLpRa2ac
        HdL5lDO3B8jtP0XR72oar7UQRdR2bhVFs1KCHHmJK4hToRwQJ/ppnQbn0VKPbQWeFkxUZpDAm4qU4
        DddQ1o2RXAigrrrZFAAkOnmB78PU3k9athD0NK1jE7irzGKMxMeOcCaXmSjm3y96Div39bxz5qrSy
        dB3ASa8O/8dvooaQL3r45jWXAgm+iX7DtgEHaxwtqv5vCshW+ZtIks1vVITG+xLKDltSbK1OUOQfM
        UODlgBLzRf/iA4JyXNkZUk8YBn6QPjAtfRyEN90eGEPKkFlv+oFQVFlcxSDQwSDYtnarTbEbPu6BL
    
Content-Disposition: inline
In-Reply-To: <CAOxpaSXDX1fyrOnnsehEoRgQz2_K1OmOn9TikZzJcXmwMLEfnA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ross Zwisler <zwisler@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

On Thu, Apr 12, 2018 at 02:59:32PM -0600, Ross Zwisler wrote:
> This is causing build breakage in the radix tree test suite in the
> current linux/master:
> 
> ./linux/../../../../include/linux/idr.h: In function ‘idr_init_base’:
> ./linux/../../../../include/linux/radix-tree.h:129:2: warning:
> implicit declaration of function ‘spin_lock_init’; did you mean
> ‘spinlock_t’? [-Wimplicit-function-declaration]

Argh.  That was added two patches later in
"xarray: Add definition of struct xarray":

diff --git a/tools/include/linux/spinlock.h b/tools/include/linux/spinlock.h
index b21b586b9854..4ec4d2cbe27a 100644
--- a/tools/include/linux/spinlock.h
+++ b/tools/include/linux/spinlock.h
@@ -6,8 +6,9 @@
 #include <stdbool.h>
 
 #define spinlock_t             pthread_mutex_t
-#define DEFINE_SPINLOCK(x)     pthread_mutex_t x = PTHREAD_MUTEX_INITIALIZER;
+#define DEFINE_SPINLOCK(x)     pthread_mutex_t x = PTHREAD_MUTEX_INITIALIZER
 #define __SPIN_LOCK_UNLOCKED(x)        (pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER
+#define spin_lock_init(x)      pthread_mutex_init(x, NULL)
 
 #define spin_lock_irqsave(x, f)                (void)f, pthread_mutex_lock(x)
 #define spin_unlock_irqrestore(x, f)   (void)f, pthread_mutex_unlock(x)

I didn't pick up that it was needed this early on in the patch series.


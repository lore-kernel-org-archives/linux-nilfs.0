From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC, PATCH] fs: push rcu_barrier() from deactivate_locked_super()
 to filesystems
Date: Fri, 8 Jun 2012 14:43:58 -0700
Message-ID: <CA+55aFz_RpR+T3Yx-hMf3veW55xAu3GgtmefKs1ZUydp4hRu8w@mail.gmail.com>
References: <1339190930-17233-1-git-send-email-kirill.shutemov@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
 h=mime-version:sender:in-reply-to:references:from:date
 :x-google-sender-auth:message-id:subject:to:cc:content-type;
 bh=/eLnw8vQp4o0eJinXjEZbCDLMosAi0gt/nL4y64h78M=;
 b=qfZgVjf9zjLNnqs2VhCarG+vtahN2baUimlErRUT28hech7yyXInijyTfjYrw3XLX+
 ouxdwOeD6E7Fjtc6IzqYTy98stMZ6tc+q8ymvXffLoe0u9cSqqgC26RjV9ATtUxRzjFZ
 319x9R6jiXZGP56DSDKoxA9P9Cn4IbISeT6qXb0rm/zIoBQqZoEgxtENfOBSToBXd4cW
 i1pX54/U/9moW3Hc1jK3qdfVLDzKvRg8lKtcN2NET8E9PK2kKUkg7XDahcD3PYgCHQrD
 4HknYNPt1N+DS07baIn/JffG3nWp++lhDmEnAmLTQ44we/C/aSRi8Avs27b1W9tGrXvu
 IUCw==
In-Reply-To: <1339190930-17233-1-git-send-email-kirill.shutemov@linux.intel.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: linux-mtd-bounces@lists.infradead.org
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Pekka Enberg <penberg@kernel.org>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.cz>, Kai Bankett <chaosman@ontika.net>, logfs@logfs.org, Frederic Weisbecker <fweisbec@gmail.com>, Anders Larsen <al@alarsen.net>, Trond Myklebust <Trond.Myklebust@netapp.com>, William Irwin <wli@holomorphy.com>, "Dmitry V. Levin" <ldv@altlinux.org>, David Howells <dhowells@redhat.com>, Dustin Kirkland <dustin.kirkland@gazzang.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, Petr Vandrovec <petr@vandrovec.name>, linux-afs@lists.infradead.org, Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>, linux-nilfs@vger.kernel.org, fuse-devel@lists.source

On Fri, Jun 8, 2012 at 2:28 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> There's no reason to call rcu_barrier() on every deactivate_locked_super().
> We only need to make sure that all delayed rcu free inodes are flushed
> before we destroy related cache.
>
> Removing rcu_barrier() from deactivate_locked_super() affects some
> fas paths. E.g. on my machine exit_group() of a last process in IPC
> namespace takes 0.07538s. rcu_barrier() takes 0.05188s of that time.

I think we should just delete it.

kmem_cache_destroy() (at least for SLUB) already has:

                if (s->flags & SLAB_DESTROY_BY_RCU)
                        rcu_barrier();

in it. But I think it's too late - it gets called *after* we do
kmem_cache_close(), and I get the feeling that we should do it before.

Shouldn't that be sufficient? And if other slab allocators don't have
this, we should add it to them too.

Hmm?

              Linus

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/

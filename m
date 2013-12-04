From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] nilfs2: rework error message subsystem
Date: Tue, 3 Dec 2013 16:29:44 -0800
Message-ID: <20131203162944.8f9ef3a08a3292a1959dd025@linux-foundation.org>
References: <1385993333.3945.3.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1385993333.3945.3.camel@slavad-ubuntu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: slava@dubeyko.com
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Michael Conrad <mconrad@intellitree.com>, linux-nilfs@vger.kernel.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>

On Mon, 02 Dec 2013 18:08:53 +0400 Vyacheslav Dubeyko <slava@dubeyko.com> wrote:

> There are situations when real error can emit huge amount of
> messages. As a result, system log contains many identical
> error messages. This patch changes printk on
> pr_[err|warn]_ratelimited version in proper places. Also
> printk was changed on pr_[err|warning|info] version in
> other places.

It converts every printk in nilfs2 into pr_foo_ratelimited (and bloats
nilfs2.ko by 5k in the process).  Isn't this rather overkill?


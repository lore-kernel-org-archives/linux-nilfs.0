From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: return an ERR_PTR from __filemap_get_folio v2
Date: Tue, 28 Mar 2023 16:04:33 -0700
Message-ID: <20230328160433.4f3dc32b480239bce9e2f9ef@linux-foundation.org>
References: <20230121065755.1140136-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680044674;
        bh=TwGyF4PkvxDzlLA402hHK1eLtIEBIL4SI/0qxIqDczQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zfFnOoP5liF9W0eIaPQY3fWY/x2c3YWeGxGG9Z+XtwTt6PdxvwTaVSJPl/wX9oHFa
         TN2zANmUIncV7Rx4/qsCq0LcMp4Wfg+6vxHO5Wt5VS0mnQryEzrkXU+ZLmL5qTwZbk
         NlIZmoUl864XszmR/3+xPQzAT+mE9qlCDRlYe16A=
In-Reply-To: <20230121065755.1140136-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, cluster-devel@redhat.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nilfs@vger.kernel.org

On Sat, 21 Jan 2023 07:57:48 +0100 Christoph Hellwig <hch@lst.de> wrote:

> __filemap_get_folio and its wrappers can return NULL for three different
> conditions, which in some cases requires the caller to reverse engineer
> the decision making.  This is fixed by returning an ERR_PTR instead of
> NULL and thus transporting the reason for the failure.  But to make
> that work we first need to ensure that no xa_value special case is
> returned and thus return the FGP_ENTRY flag.  It turns out that flag
> is barely used and can usually be deal with in a better way.
> 
> Note that the shmem patches in here are non-trivial and need some
> careful review and testing.

How are we going with the review and testing.  I assume that
we're now OK on the runtime testing front, but do you feel that
review has been adequate?

Thanks.

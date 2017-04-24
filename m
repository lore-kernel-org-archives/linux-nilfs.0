From: Mike Marshall <hubcap@omnibond.com>
Subject: Re: [PATCH v3 05/20] orangefs: don't call filemap_write_and_wait from fsync
Date: Mon, 24 Apr 2017 14:18:41 -0400
Message-ID: <CAOg9mSQPqSVLXqovLiezKycWJ+U2J1UZJ0tO2p8TeKh8WP2S2g@mail.gmail.com>
References: <20170424132259.8680-1-jlayton@redhat.com> <20170424132259.8680-6-jlayton@redhat.com>
 <20170424152348.GE9112@infradead.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=omnibond-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=jB+d8SSipnaTdXA2ChIMEBVSqC6B8TorTmukpix3Twc=;
        b=anCmZH09XFEGkhzKhpX/g949Ia3LEhTYhisKq5MQnMOi5I3OM367XT/Cs3/iIU31WC
         8eLWTSTMpijZdmUSPN1/ds/Oi6hxynGDp+sIULxs86H76bu/bBW3LO0vYrjW0d78c3xp
         mNCLphwdAtTFNJQgY0QGsJNdp230/0aoRKOzz/1sRk50+9/wXCweM2nCHUZqcozlSbvr
         RzUT+v4fihaueQUKI0GH4NSGb8iyHp2s5hC7XOs/UIchGnHySN084aj+W/JeQJajysJI
         Ma6rLmN8Hdq80J+9THxPaI0spSwOaTnctfSELF3PktLNtSvwiy8p8BjgAaDyx+ZruAZe
         BY5Q==
In-Reply-To: <20170424152348.GE9112@infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Layton <jlayton@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-cifs@vger.kernel.org, linux-mm <linux-mm@kvack.org>, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, David Howells <dhowells@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, jack@suse.com, Al Viro <viro@zeniv.linux.org.uk>, corbet@lwn.net, neilb@suse.de, Chris Mason <clm@fb.com>, Theodore Ts'o <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>

I've been running it here...

Acked-by: Mike Marshall <hubcap@omnibond.com>

On Mon, Apr 24, 2017 at 11:23 AM, Christoph Hellwig <hch@infradead.org> wrote:
> Looks fine,
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

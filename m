From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 02/11] MM: document and polish read-ahead code.
Date: Sun, 27 Feb 2022 20:47:28 -0800
Message-ID: <20220227204728.b2eb5dd94ecc3e86912bacad@linux-foundation.org>
References: <164447124918.23354.17858831070003318849.stgit@noble.brown>
        <164447147257.23354.2801426518649016278.stgit@noble.brown>
        <20220210122440.vqth5mwsqtv6vjpq@quack3.lan>
        <164453611721.27779.1299851963795418722@noble.neil.brown.name>
        <20220224182622.n7abfey3asszyq3x@quack3.lan>
        <164602251992.20161.9146570952337454229@noble.neil.brown.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646023649;
        bh=G8sG7lhMtemU8UaIfAlQyFfdM52xrPiAjoIoRCmr5pk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oGPNq6p6XPM77SHgO9aQqRI1rnuXHCc+59DXZQ1WNrGmN3OQd6S99TorBGhKumdok
         /al88n7DG2J8BkHYEPTcnC3PkoeWXPmOgtseuFvQx3PRiJwblKmCI9fhBlhdsjcaOW
         hLr6Rg6R30jUXs/Md/sM9bDGeMUMnt9uzXly3vn0=
In-Reply-To: <164602251992.20161.9146570952337454229@noble.neil.brown.name>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: NeilBrown <neilb@suse.de>
Cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Paolo Valente <paolo.valente@linaro.org>, Jens Axboe <axboe@kernel.dk>, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, lin

On Mon, 28 Feb 2022 15:28:39 +1100 "NeilBrown" <neilb@suse.de> wrote:

> When writing documentation the intent of the author is of some interest,
> but the behaviour of the code is paramount.

uh, er, ah, no.  The code describes the behaviour of the code.  The
comments are there to describe things other than the code's behaviour.
Things such as the author's intent.

Any deviation between the author's intent and the code's behaviour is
called a "bug", so it's pretty important to understand authorial
intent, no?


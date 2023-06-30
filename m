From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH 00/79] fs: new accessors for inode->i_ctime
Date: Fri, 30 Jun 2023 15:11:42 -0700
Message-ID: <ZJ9THiUlOUmm0xpD@bombadil.infradead.org>
References: <20230621144507.55591-1-jlayton@kernel.org>
 <20230621152141.5961cf5f@gandalf.local.home>
Mime-Version: 1.0
Return-path: <ecryptfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mmrCw93FsSgGVqkQGx3tY+c3DxJ3ErMGqt6cuZmQDk4=; b=3Xi9NJjkd4QPELIEMLqHm1+oJy
        QNIOVPA8HW3kXP6XuZluim3h/1Z/sfwrG9QOzNRHgYq+vOXcblPYVWq7qnircmbeiJPJDVgOjWyzo
        LbnhyHqo5AegY+fER/tKQShp8dh+Z/+/bv4xI3KoQiSpmxUAYDgP6p5vAe2pi77qFUU0ycsQEmV7V
        4gCVdOf3P+PueFWMrnvROKMoMz+u7SsILxSnayKbZrj37v0X+NhKaX7iej/SD3IFAsLN2XayGDdUC
        G3y/vRbujnR04W/Op5jRENlRX4f86+/5+pwYqxdiQMmhYNN5AwTPrNqa/XDugttEtOweLL0X0YqO/
        pQ84xrwQ==;
Content-Disposition: inline
In-Reply-To: <20230621152141.5961cf5f@gandalf.local.home>
Sender: Luis Chamberlain <mcgrof@infradead.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@inria.fr>, Takashi Iwai <tiwai@suse.de>
Cc: Jeff Layton <jlayton@kernel.org>, Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, Suren Baghdasaryan <surenb@google.com>, Den

On Wed, Jun 21, 2023 at 03:21:41PM -0400, Steven Rostedt wrote:
> On Wed, 21 Jun 2023 10:45:05 -0400
> Jeff Layton <jlayton@kernel.org> wrote:
> 
> > Most of this conversion was done via coccinelle, with a few of the more
> > non-standard accesses done by hand. There should be no behavioral
> > changes with this set. That will come later, as we convert individual
> > filesystems to use multigrain timestamps.
> 
> BTW, Linus has suggested to me that whenever a conccinelle script is used,
> it should be included in the change log.

Sometimes people like the coccinelle included in the commit, sometimes
people don't [0], it really ends up being up to a subjective maintainer
preference. A compromise could be to use git notes as these are
optional, however if we want to go down that path we should try to make
a general consensus on it so we can send a consistent message.

[0] https://lore.kernel.org/all/20230512073100.GC32559@twin.jikos.cz/

  Luis

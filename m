From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH 01/79] fs: add ctime accessors infrastructure
Date: Fri, 30 Jun 2023 15:12:43 -0700
Message-ID: <ZJ9TW9MQmlqmbRU/@bombadil.infradead.org>
References: <20230621144507.55591-1-jlayton@kernel.org>
 <20230621144507.55591-2-jlayton@kernel.org>
Mime-Version: 1.0
Return-path: <ecryptfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lAGAJ28n1AlcMoZYeCm9uRz7rvcCocSlQtZJp9kS4hM=; b=MDK5OMbWDIQ7k5BUsVfTTCeUKK
        ykHg2ksytfiKty5DqeoojsJgI19pnpO3bU4G0Nu4GjG2hEs2ZxnYXR7D6/oVlp5Pe2D5JneqmFcdb
        aqUSSmtLLmtBD1hqWecPq0g6kKIyzG4SS3mQ1IFdkZFT8q1yIbLznGNVCRFkmuvgVZewrQL+j94VD
        WaM6JFD5ZLKSStA4y0A2mjB/5tQW5fCKp810bYosB6+mCMAVZBJndIY7cGkKy5/JBuK2Tl+F43Ugr
        599NI5n1vZXoqkj6Re0aIa5xI5fj+j2Mg09LQQtRQAZLHqXoNHWcWfm/2CAipcBnuw9FG3zZ4Gpbp
        XVBvS0Ww==;
Content-Disposition: inline
In-Reply-To: <20230621144507.55591-2-jlayton@kernel.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@kernel.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, Suren Baghdasaryan <surenb@google.com>, Dennis Dalessandro <dennis.dalessandro@cornel>

On Wed, Jun 21, 2023 at 10:45:06AM -0400, Jeff Layton wrote:
> struct timespec64 has unused bits in the tv_nsec field that can be used
> for other purposes. In future patches, we're going to change how the
> inode->i_ctime is accessed in certain inodes in order to make use of
> them. In order to do that safely though, we'll need to eradicate raw
> accesses of the inode->i_ctime field from the kernel.
> 
> Add new accessor functions for the ctime that we can use to replace them.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

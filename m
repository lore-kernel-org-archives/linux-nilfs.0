From: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH 86/87] fs: switch timespec64 fields in inode to discrete integers
Date: Thu, 28 Sep 2023 11:48:16 -0400
Message-ID: <6020d6e7-b187-4abb-bf38-dc09d8bd0f6d@app.fastmail.com>
References: <20230928110554.34758-1-jlayton@kernel.org>
 <20230928110554.34758-2-jlayton@kernel.org>
Mime-Version: 1.0
Return-path: <ceph-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1695916119; x=1696002519; bh=AE
        M/fDbI9O0BImAELzI+hfXsnObtdXB3nh8ZZCXXqn0=; b=rYRrfUWcGURzZi2Kx3
        x77+TyShR9Sib8UhEkjRsEvF3DnYBPdVY6rzWwYeuhr4tdntul3oHtfVUF/z6EV2
        heYFaG3+Ohoslr/oEpgzvbQj8Ap/BO0Uo8fukRIGEYSG2EFeIuADh6kTnG/e/ZnK
        WKoyOI7jTOa1WvXs1EnNIde2dL42+ityLyFsYeIVnenJ8nJu5KRjOGJhaF2H5eLA
        4Rc3nmIeAUGsRgwN8l/vUa6uyPahwW8/lYYQtjTd1GdPmcRjEc4yki4fcm3o+0bg
        CM1ceI9x2XAIhPoWvIWcG7Pse0IJVI89HVvLU8Sx5WjoReHRv+R8kwtcD43rgTqO
        1Txg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1695916119; x=1696002519; bh=AEM/fDbI9O0BI
        mAELzI+hfXsnObtdXB3nh8ZZCXXqn0=; b=SVhvpMNNu2832r96OQM+NAupTyZUu
        9ApC30lDjAFYMGWGRYhGk9Ktw4UV75/4wX1D/NFDsHe0J/F4WGv8mVpKtbEtvn7p
        Rmjsr58zIcRx0QQa/XsGbKIRMC4kmp2y+lV4iGP4YPyx6mdJFfcRgxpTGWbUkYul
        fg2q9Uk1M3TSIwSOpuuTWD6z9oXV7akZjN8oooViePicLGd71ehHsuxX95jowg+t
        sIH70F+Njj7J5uzvO8LCP4IepniwS53HFBN7DFlHjczusBIIb6hJ6o+OFnMH7yBO
        ef+exyTTPsXWvxZc+NE+84UqAYqQq2LcMfq4tomSwJikU7iHJ9es8eYXA==
In-Reply-To: <20230928110554.34758-2-jlayton@kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Sterba <dsterba@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Theodore Ts'o <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <greg>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, platform-driver-x86@vger.kernel.org, linux-rdma@vger.kernel.org, linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, v9fs@lists.linux.dev, linux-afs@lists.infradead.org, autofs@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, linux-efi@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, gfs2@lists.linux.dev, linux-um@lists.infradead.org, linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-d

On Thu, Sep 28, 2023, at 07:05, Jeff Layton wrote:
> This shaves 8 bytes off struct inode, according to pahole.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

FWIW, this is similar to the approach that Deepa suggested
back in 2016:

https://lore.kernel.org/lkml/1452144972-15802-3-git-send-email-deepa.kernel@gmail.com/

It was NaKed at the time because of the added complexity,
though it would have been much easier to do it then,
as we had to touch all the timespec references anyway.

The approach still seems ok to me, but I'm not sure it's worth
doing it now if we didn't do it then.

     Arnd

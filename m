From: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH 86/87] fs: switch timespec64 fields in inode to discrete integers
Date: Thu, 28 Sep 2023 16:21:12 -0400
Message-ID: <ded0ef74-bdad-42f2-b0a7-5d867e446c19@app.fastmail.com>
References: <20230928110554.34758-1-jlayton@kernel.org>
 <20230928110554.34758-2-jlayton@kernel.org>
 <6020d6e7-b187-4abb-bf38-dc09d8bd0f6d@app.fastmail.com>
 <af047e4a1c6947c59d4a13d4ae221c784a5386b4.camel@kernel.org>
 <20230928171943.GK11439@frogsfrogsfrogs>
 <6a6f37d16b55a3003af3f3dbb7778a367f68cd8d.camel@kernel.org>
Mime-Version: 1.0
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1695932496; x=1696018896; bh=35
        hGd5DtemMMIKF1Zr0cZ5jy7ToQQid1yaZKtlkxNu4=; b=kYePS9tb7iX4DfdsrP
        KSG5kIGZHZ6II373RLg/R6yievFf5ZYxGwh2bHABIynK2hkA52tpJp3Oqt6Z3WOr
        EqKj++ONhEZxtgYMqLWXCzvXzNYTY67C+FNTS8BO7KmsYa1dEu2LxNvTTGge5dTC
        98J8ERH0LgbaCs96bDreSwTyXJA52oIcXMJdWw5N86IHuBkNDy0oNr/0YRW4bAe/
        0M4666MlVq40oMzm+hOyKlTRfSVgmNV/d/3Ff0cJaJ0SNIaaJnTv2IECtjx7okcZ
        2oTzttml5wZkULDWHm+AqgNYcCGYK4B55B9Z6uwZLoNIrGvBjakjMQdqnYhny59X
        c+DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1695932496; x=1696018896; bh=35hGd5DtemMMI
        KF1Zr0cZ5jy7ToQQid1yaZKtlkxNu4=; b=Mi38mWEo6Tol35uWyjeJmmWCT6PhB
        HqHdQW8+/vTI7Qw8Bqjnf4yascDSnQ3TwDDgcbk0sbZbyRT57QkzfpVhTvQ8tyG/
        LToaN9PzpBS9QrAj9YMndKxYandOQbuYzjXUqBNmiENTlTffglDnwu2iuDr2TsU+
        /NNGLhQAXePxiL0pEdoLHMSXcoqi6N/AkRauYrgRvDxZcWexBs/kQpWi1R5l+oVf
        it+YrCNEgaozEQG8vQeVMxdjNU22qXU18zXjjUwBmzzgDSvsRTJJPv6DyBI9Pzys
        O8qdOCiu0Uk7vB8Y73BLyFXAFOIxbyg1bikunx6mKyaqpJQGWudajkQ0A==
In-Reply-To: <6a6f37d16b55a3003af3f3dbb7778a367f68cd8d.camel@kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Sterba <dsterba@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Theodore Ts'o <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?Q?A

On Thu, Sep 28, 2023, at 13:40, Jeff Layton wrote:
> On Thu, 2023-09-28 at 10:19 -0700, Darrick J. Wong wrote:
>>
>> > I remember seeing those patches go by. I don't remember that change
>> > being NaK'ed, but I wasn't paying close attention at the time 
>> > 
>> > Looking at it objectively now, I think it's worth it to recover 8 bytes
>> > per inode and open a 4 byte hole that Amir can use to grow the
>> > i_fsnotify_mask. We might even able to shave off another 12 bytes
>> > eventually if we can move to a single 64-bit word per timestamp. 
>> 
>> I don't think you can, since btrfs timestamps utilize s64 seconds
>> counting in both directions from the Unix epoch.  They also support ns
>> resolution:
>> 
>> 	struct btrfs_timespec {
>> 		__le64 sec;
>> 		__le32 nsec;
>> 	} __attribute__ ((__packed__));
>> 
>
> Correct. We'd lose some fidelity in currently stored timestamps, but as
> Linus and Ted pointed out, anything below ~100ns granularity is
> effectively just noise, as that's the floor overhead for calling into
> the kernel. It's hard to argue that any application needs that sort of
> timestamp resolution, at least with contemporary hardware. 

There are probably applications that have come up with creative
ways to use the timestamp fields of file systems that 94 bits
of data, with both the MSB of the seconds and the LSB of the
nanoseconds carrying information that they expect to be preserved.

Dropping any information in the nanoseconds other than the top two
bits would trivially change the 'ls -t' output when two files have
the same timestamp in one kernel but slightly different timestamps
in another one. For large values of 'tv_sec', there are fewer
obvious things that break, but if current kernels are able to
retrieve arbitrary times that were stored with utimensat(), then we
should probably make sure future kernels can see the same.

        Arnd

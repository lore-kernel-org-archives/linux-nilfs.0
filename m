From: Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mkfs: check sizes of important structs at build time
Date: Sat, 4 Jan 2014 22:54:29 +0900
Message-ID: <CAE1WaKLr1EuovgHgXQa1o9LQVk1fRkUXbDrGiKfsdTB347ieqg@mail.gmail.com>
References: <1388842171-16105-1-git-send-email-mitake.hitoshi@gmail.com>
	<EF28F22A-C43F-41C9-A5B9-8597C5879E3E@dubeyko.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=YWqhWt96RIeMRISRCjZ+TFONFtkvcUx4hVIqRrzjSYU=;
        b=W8MLj6IrF6kPKcm00srxv1EW7qBcHV/JVH9Li8XR7+KL3YvuWEcMFK2bX2KTbdsyG3
         EltktliSIdj76fmBiNL6ZCjD+yRZ9FHq8v9jfZlqeODC54u29bFLDkC6Hzej8WNqC02d
         2vt/IEGmznjZm+3yuM28v9I7ou2FtIyE1CbB2ptfWYna7uImY3tra9FS9ny8IdEQJw9s
         eguju/DKIR3va3VIyVwKBRRVjL92CFjlqMgBJ6R52vQikJzSEJrMkUJBem8LqLDQJFyb
         QAZAOz+TLGkjKpPfnoE1SyJyCPooNhlnVtrHDuNEN7tyMCEJo8vrQH39qOnffk+PO3td
         z36g==
In-Reply-To: <EF28F22A-C43F-41C9-A5B9-8597C5879E3E-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

On Sat, Jan 4, 2014 at 11:52 PM, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:
>
> On Jan 4, 2014, at 4:29 PM, Hitoshi Mitake wrote:
>
>> Current nilfs_check_ondisk_sizes() checks sizes of important structs
>> at run time. The checking should be done at build time. This patch
>> adds a new macro, BUILD_BUG_ON(), for this purpose. It is similar to
>> static_assert() of C++11. If an argument is true, the macro causes a
>> bulid error.
>>
>> Below is an example of BUILD_BUG_ON(). When the checked conditions are
>> true like below:
>>
>> /* intentional change for testing BUILD_BUG_ON() */
>>
>> static __attribute__((used)) void nilfs_check_ondisk_sizes(void)
>> {
>>       BUILD_BUG_ON(sizeof(struct nilfs_inode) > NILFS_MIN_BLOCKSIZE);
>
> So, why do we need to have function for the case of checking on compilation
> phase?

Just for excluding the checking from other part of code and improve readability.

>
> I suppose that we need to have some run-time check anyway. Your approach
> is correct for the current state of the code. But I feel a necessity in run-time check
> anyway. Maybe it looks like a paranoia. :) Maybe it needs to extend checking
> in this place.

Do you mean both of the build time check and the run time check? If
so, I agree with your opinion. I'll send v2 based on this policy.

Thanks,
Hitoshi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

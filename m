From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v4 72/73] xfs: Convert mru cache to XArray
Date: Mon, 11 Dec 2017 14:43:01 -0800
Message-ID: <20171211224301.GA3925@bombadil.infradead.org>
References: <fd7130d7-9066-524e-1053-a61eeb27cb36@lge.com>
 <Pine.LNX.4.44L0.1712081228430.1371-100000@iolanthe.rowland.org>
 <20171208223654.GP5858@dastard>
 <1512838818.26342.7.camel@perches.com>
 <20171211214300.GT5858@dastard>
 <1513030348.3036.5.camel@perches.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=m8Q79Nc9GxvQg6IRHvkOKASCrJtmRwbp3Cc0h5E4C2U=; b=Tuj3sxZk6jeyKCvXGWGKxcbRy
	6YhuaWWJD97NH5uc3fJNU/mKLsJc6fngZXHHboHDLiisLo/TE/K2iHlqD/U+HxsT2B1Yi981wfUt7
	1b0ZaV/0yUIM+bpsRPstc+jqIvn6TLIJ6DjsmGjRlGIrbIpAbg+WSLxrTqBQBLtjYqAYteYLmqx+n
	8X2EZbZ9WssRzfDY9dFkDWM8U0qPRX5nx+/2VYhh4dhNIOcS3n3eOGc212WJ2SDufEfu6LTpf68rx
	wkn3+jxpYHjSo7xKggxsVfDvVF7twvypldm4hKTAKwE203xWnt51D4aszxupMa0zDT077y/fqiDPf
	CZNhyT8sg==;
Content-Disposition: inline
In-Reply-To: <1513030348.3036.5.camel@perches.com>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: Dave Chinner <david@fromorbit.com>, Alan Stern <stern@rowland.harvard.edu>, Byungchul Park <byungchul.park@lge.com>, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@lge.com

On Mon, Dec 11, 2017 at 02:12:28PM -0800, Joe Perches wrote:
> Completely reasonable.  Thanks.

If we're doing "completely reasonable" complaints, then ...

 - I don't understand why plain 'unsigned' is deemed bad.

 - The rule about all function parameters in prototypes having a name
   doesn't make sense.  Example:

int ida_get_new_above(struct ida *ida, int starting_id, int *p_id);

   There is zero additional value in naming 'ida'.  I know it's an ida.
   The struct name tells me that.  If there're two struct ida pointers
   in the prototype, then sure, I want to name them so I know which is
   which (maybe 'src' and 'dst').  Having an unadorned 'int' parameter
   to a function should be a firable offence.  But there's no need to
   call 'gfp_t' anything.  We know it's a gfp_t.  Adding 'gfp_mask'
   after it doesn't tell us anything extra.

 - Forcing a blank line after variable declarations sometimes makes for
   some weird-looking code.  For example, there is no problem with this
   code (from a checkpatch PoV):

        if (xa_is_sibling(entry)) {
                offset = xa_to_sibling(entry);
                entry = xa_entry(xas->xa, node, offset);
                /* Move xa_index to the first index of this entry */
                xas->xa_index = (((xas->xa_index >> node->shift) &
                                  ~XA_CHUNK_MASK) | offset) << node->shift;
        }

   but if I decide I don't need 'offset' outside this block, and I want
   to move the declaration inside, it looks like this:

        if (xa_is_sibling(entry)) {
                unsigned int offset = xa_to_sibling(entry);

                entry = xa_entry(xas->xa, node, offset);
                /* Move xa_index to the first index of this entry */
                xas->xa_index = (((xas->xa_index >> node->shift) &
                                  ~XA_CHUNK_MASK) | offset) << node->shift;
        }

   Does that blank line really add anything to your comprehension of the
   block?  It upsets my train of thought.

   Constructively, I think this warning can be suppressed for blocks
   that are under, say, 8 lines.  Or maybe indented blocks is where I don't
   want this warning.  Not sure.

   Here's another example where I don't think the blank line adds anything:

static inline int xa_store_empty(struct xarray *xa, unsigned long index,
                void *entry, gfp_t gfp, int errno)
{
        void *curr = xa_cmpxchg(xa, index, NULL, entry, gfp);
        if (!curr)
                return 0;
        if (xa_is_err(curr))
                return xa_err(curr);
        return errno;
}

   So line count definitely has something to do with it.

 - There's no warning for the first paragraph of section 6:

6) Functions
------------

Functions should be short and sweet, and do just one thing.  They should
fit on one or two screenfuls of text (the ISO/ANSI screen size is 80x24,
as we all know), and do one thing and do that well.

   I'm not expecting you to be able to write a perl script that checks
   the first line, but we have way too many 200-plus line functions in
   the kernel.  I'd like a warning on anything over 200 lines (a factor
   of 4 over Linus's stated goal).

 - I don't understand the error for xa_head here:

struct xarray {
        spinlock_t      xa_lock;
        gfp_t           xa_flags;
        void __rcu *    xa_head;
};

   Do people really think that:

struct xarray {
        spinlock_t      xa_lock;
        gfp_t           xa_flags;
        void __rcu	*xa_head;
};

   is more aesthetically pleasing?  And not just that, but it's an *error*
   so the former is *RIGHT* and this is *WRONG*.  And not just a matter
   of taste?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

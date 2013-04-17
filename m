From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v2] nilfs2: fix issue with flush kernel thread after
 remount in RO mode because of driver's internal error or metadata
 corruption
Date: Wed, 17 Apr 2013 12:57:01 -0700
Message-ID: <20130417125701.9fc97738f85f015e3ace1106@linux-foundation.org>
References: <1366186416.2113.5.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366186416.2113.5.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anthony Doggett <Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>, ARAI Shun-ichi <hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>, Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>, Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>, Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, 17 Apr 2013 12:13:36 +0400 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:

> +	BUG_ON(!test_bit(PG_locked, &page->flags));

The fs should be using PageLocked() here.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
